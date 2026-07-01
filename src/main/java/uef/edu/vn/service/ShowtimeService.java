/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package uef.edu.vn.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import java.time.LocalDate;
import java.time.LocalTime;
import java.util.List;
import uef.edu.vn.repository.ShowtimeRepository;
import uef.edu.vn.repository.MovieRepository;
import uef.edu.vn.repository.RoomRepository; // IMPORT THÊM
import uef.edu.vn.model.Showtime;
import uef.edu.vn.model.Movie;
import uef.edu.vn.model.Room; // IMPORT THÊM

@Service
public class ShowtimeService {

    @Autowired
    private ShowtimeRepository showtimeRepository;

    @Autowired
    private MovieRepository movieRepository;

    @Autowired
    private RoomRepository roomRepository; // INJECT THÊM ĐỂ CHECK SỨC CHỨA PHÒNG

    public List<Showtime> getAllShowtimes() {
        return showtimeRepository.findAll();
    }

    public Showtime getShowtimeById(Long id) {
        return showtimeRepository.findById(id);
    }

    public void saveShowtime(Showtime showtime) {
        // 0. Kiểm tra tính hợp lệ ban đầu của dữ liệu đầu vào
        if (showtime.getMovie() == null || showtime.getMovie().getId() == null) {
            throw new IllegalArgumentException("Vui lòng chọn một bộ phim!");
        }
        if (showtime.getRoom() == null || showtime.getRoom().getId() == null) {
            throw new IllegalArgumentException("Vui lòng chọn phòng máy chiếu!");
        }
        if (showtime.getShowDate() == null) {
            throw new IllegalArgumentException("Vui lòng chọn ngày vận hành chiếu!");
        }
        if (showtime.getStartTime() == null) {
            throw new IllegalArgumentException("Vui lòng chọn giờ phát sóng!");
        }

        // ==================== CẢI TIẾN 1: KHÓA SUẤT CHIẾU ĐÃ QUA KHI SỬA ====================
        if (showtime.getId() != null) {
            Showtime oldShowtime = showtimeRepository.findById(showtime.getId());
            if (oldShowtime != null && oldShowtime.isPast()) {
                throw new IllegalArgumentException("Không thể chỉnh sửa suất chiếu đã diễn ra trong quá khứ!");
            }
        }

        // ==================== CẢI TIẾN 2: CHỈ CHO THÊM/SỬA NGÀY GIỜ HIỆN TẠI HOẶC TƯƠNG LAI ====================
        LocalDate today = LocalDate.now();
        LocalTime now = LocalTime.now();
        if (showtime.getShowDate().isBefore(today)) {
            throw new IllegalArgumentException("Ngày xếp lịch chiếu phải là ngày hiện tại hoặc các ngày trong tương lai!");
        }
        if (showtime.getShowDate().isEqual(today) && showtime.getStartTime().isBefore(now)) {
            throw new IllegalArgumentException("Giờ phát sóng phải lớn hơn hoặc bằng giờ hiện tại đối với suất chiếu trong ngày hôm nay!");
        }

        // Lấy thông tin phim đầy đủ từ DB
        Movie movie = movieRepository.findById(showtime.getMovie().getId());
        if (movie == null) {
            throw new IllegalArgumentException("Bộ phim được chọn không tồn tại trên hệ thống!");
        }

        // Lấy thông tin phòng đầy đủ từ DB
        Room room = roomRepository.findById(showtime.getRoom().getId());
        if (room == null) {
            throw new IllegalArgumentException("Phòng chiếu được chọn không tồn tại trên hệ thống!");
        }

        // ==================== CẢI TIẾN 3: PHÒNG CHIẾU CÓ SỐ CHỖ NGỒI > 0 ====================
        if (room.getCapacity() <= 0) {
            throw new IllegalArgumentException("Không thể xếp lịch vào phòng '" + room.getRoomName() + "' vì tổng số ghế đang bằng 0!");
        }

        // ==================== CHECK ĐIỀU KIỆN NGHIỆP VỤ CŨ CỦA BẠN ====================
        // o Chỉ được chọn phim khi thêm/sửa ở trạng thái “Đang chiếu” / “Sắp chiếu”
        String movieStatus = movie.getStatus();
        if (!"Đang chiếu".equalsIgnoreCase(movieStatus) && !"Sắp chiếu".equalsIgnoreCase(movieStatus)) {
            throw new IllegalArgumentException("Chỉ được phép xếp lịch cho phim ở trạng thái 'Đang chiếu' hoặc 'Sắp chiếu'!");
        }

        // o Ngày vận hành chiếu phải sau hoặc bằng ngày bắt đầu khởi chiếu của phim
        if (movie.getReleaseDate() != null && showtime.getShowDate().isBefore(movie.getReleaseDate())) {
            throw new IllegalArgumentException("Ngày vận hành chiếu không được trước ngày khởi chiếu của phim (Ngày khởi chiếu: " + movie.getReleaseDate() + ")!");
        }

        // o Thêm chức năng tự động tính Giờ kết thúc = Giờ phát sóng + Thời lượng + 15 phút dọn rạp
        int totalMinutes = movie.getDuration() + 15;
        LocalTime endTime = showtime.getStartTime().plusMinutes(totalMinutes);
        showtime.setEndTime(endTime);

        // Chặn trường hợp giờ chiếu quá muộn lọt sang ngày hôm sau
        if (endTime.isBefore(showtime.getStartTime())) {
            throw new IllegalArgumentException("Suất chiếu kéo dài xuyên đêm qua ngày hôm sau. Vui lòng đẩy giờ phát sóng sớm hơn!");
        }

        // o Hai bộ phim không thể chiếu cùng một khoảng thời gian và cùng một rạp (Chặn trùng lịch)
        List<Showtime> conflictingShowtimes = showtimeRepository.findConflictingShowtimes(
                showtime.getRoom().getId(),
                showtime.getShowDate(),
                showtime.getStartTime(),
                showtime.getEndTime(),
                showtime.getId()
        );

        if (!conflictingShowtimes.isEmpty()) {
            Showtime conflict = conflictingShowtimes.get(0);
            throw new IllegalArgumentException("Trùng lịch! Phòng máy này hiện đang có suất chiếu phim '"
                    + conflict.getMovie().getName() + "' từ "
                    + conflict.getStartTime() + " đến " + conflict.getEndTime() + " (đã gồm 15 phút dọn rạp).");
        }

        showtimeRepository.save(showtime);
    }

    public void deleteShowtime(Long id) {
        // ==================== CẢI TIẾN 4: KHÓA XÓA SUẤT CHIẾU ĐÃ QUA ====================
        Showtime showtime = showtimeRepository.findById(id);
        if (showtime != null && showtime.isPast()) {
            throw new IllegalArgumentException("Không thể xóa suất chiếu đã diễn ra trong quá khứ!");
        }
        showtimeRepository.delete(id);
    }

    public List<Showtime> getShowtimesWithFilter(String search, Long roomId, String dateFilter, String sortBy) {
        return showtimeRepository.findShowtimesWithFilter(search, roomId, dateFilter, sortBy);
    }
}
