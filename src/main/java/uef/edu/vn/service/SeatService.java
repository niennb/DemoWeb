/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package uef.edu.vn.service;

import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import uef.edu.vn.model.Room;
import uef.edu.vn.model.Seat;
import uef.edu.vn.repository.SeatRepository;
import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;

@Service
@Transactional
public class SeatService {

    @Autowired
    private SeatRepository seatRepository;

    @PersistenceContext
    private EntityManager entityManager; // Dùng để tìm Room nhanh không cần viết thêm RoomRepo

    public List<Seat> getSeatsByRoom(Long roomId) {
        return seatRepository.findByRoomId(roomId);
    }

    /**
     * THUẬT TOÁN: TỰ ĐỘNG SINH HÀNG LOẠT GHẾ THEO MA TRẬN HÀNG X CỘT
     */
    public String generateSeatsForRoom(Long roomId, int rows, int cols) {
        // 1. Tìm thông tin phòng chiếu để lấy Capacity
        Room room = entityManager.find(Room.class, roomId);
        if (room == null) {
            return "Phòng chiếu không tồn tại!";
        }

        // 2. Tính số lượng ghế định sinh ra
        int totalNewSeats = rows * cols;

        // 3. Kiểm tra số lượng ghế hiện tại đã có trong DB của phòng này
        Long currentSeatCount = seatRepository.countByRoomId(roomId);

        // RÀNG BUỘC 1: Nếu phòng đã cài đặt đủ số lượng ghế bằng hoặc vượt quá Sức chứa -> Chặn luôn
        if (currentSeatCount >= room.getCapacity()) {
            return "Thất bại: Phòng này đã được cấu hình đủ số lượng ghế quy định (" + currentSeatCount + "/" + room.getCapacity() + " ghế). Không thể thêm!";
        }

        // RÀNG BUỘC 2: Nếu số lượng ghế định sinh thêm cộng với ghế cũ vượt quá sức chứa cho phép
        if (currentSeatCount + totalNewSeats > room.getCapacity()) {
            return "Thất bại: Số ghế sinh thêm làm tổng số ghế vượt quá sức chứa tối đa của phòng (" + (currentSeatCount + totalNewSeats) + "/" + room.getCapacity() + " ghế)!";
        }

        // 4. TIẾN HÀNH VÒNG LẶP TỰ SINH MÃ GHẾ (Ví dụ: rows=5, cols=4 -> A1..A4, B1..B4,..., E1..E4)
        for (int i = 0; i < rows; i++) {
            // Đổi chỉ số i thành chữ cái (0 -> 'A', 1 -> 'B', 2 -> 'C',...)
            char rowLetter = (char) ('A' + i);

            for (int j = 1; j <= cols; j++) {
                // Ghép chữ và số: A + 1 = "A1"
                String seatName = rowLetter + String.valueOf(j);

                // Khởi tạo đối tượng ghế mới và lưu vào DB
                Seat seat = new Seat();
                seat.setRoom(room);
                seat.setSeatName(seatName);

                seatRepository.save(seat);
            }
        }

        return "Thành công: Đã tự động sinh thành công " + totalNewSeats + " ghế ngồi cho " + room.getRoomName() + "!";
    }

    /**
     * CHỨC NĂNG BỔ SUNG: XÓA TOÀN BỘ GHẾ TRONG PHÒNG ĐỂ LÀM LẠI SƠ ĐỒ
     */
    public String clearAllSeatsInRoom(Long roomId) {
        // RÀNG BUỘC: Nếu đã có vé bán ra cho các ghế thuộc phòng này thì tuyệt đối KHÔNG cho xóa sơ đồ
        Long bookedCount = seatRepository.countBookedSeatsByRoomId(roomId);
        if (bookedCount > 0) {
            return "Thất bại: Không thể cấu hình lại phòng! Đã có " + bookedCount + " ghế trong phòng này được khách đặt mua vé!";
        }

        seatRepository.deleteByRoomId(roomId);
        return "Thành công: Đã xóa toàn bộ sơ đồ ghế cũ của phòng chiếu này.";
    }
}
