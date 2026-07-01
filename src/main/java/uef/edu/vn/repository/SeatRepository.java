/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package uef.edu.vn.repository;

import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;
import java.util.List;
import org.springframework.stereotype.Repository;
import uef.edu.vn.model.Seat;

@Repository
public class SeatRepository {

    @PersistenceContext
    private EntityManager entityManager;

    // Tìm tất cả ghế của một phòng chiếu cụ thể
    public List<Seat> findByRoomId(Long roomId) {
        return entityManager.createQuery("SELECT s FROM Seat s WHERE s.room.id = :roomId", Seat.class)
                .setParameter("roomId", roomId)
                .getResultList();
    }

    // Đếm tổng số ghế hiện tại đang có trong phòng
    public Long countByRoomId(Long roomId) {
        return entityManager.createQuery("SELECT COUNT(s) FROM Seat s WHERE s.room.id = :roomId", Long.class)
                .setParameter("roomId", roomId)
                .getSingleResult();
    }

// KIỂM TRA: Xem phòng này đã có ghế nào được khách đặt mua chưa (Dùng Native SQL)
    public Long countBookedSeatsByRoomId(Long roomId) {
        // Sử dụng tên bảng (ticket_seats, seats) và tên cột (seat_id, room_id, id) thực tế trong DB của bạn
        String sql = "SELECT COUNT(*) FROM ticket_seats ts " +
                     "INNER JOIN seats s ON ts.seat_id = s.id " +
                     "WHERE s.room_id = :roomId";
        
        try {
            Object result = entityManager.createNativeQuery(sql)
                    .setParameter("roomId", roomId)
                    .getSingleResult();
            
            // Ép kiểu an toàn từ Object/Number về Long
            if (result != null) {
                return ((Number) result).longValue();
            }
        } catch (Exception e) {
            e.printStackTrace(); // In ra log nếu tên bảng hoặc tên cột trong DB của bạn có chút khác biệt
        }
        
        return 0L;
    }

    // Lưu từng ghế đơn lẻ
    public void save(Seat seat) {
        entityManager.persist(seat);
    }

    // Xóa toàn bộ ghế của một phòng (Dùng khi Admin muốn Reset/Cài đặt lại từ đầu)
    public void deleteByRoomId(Long roomId) {
        entityManager.createQuery("DELETE FROM Seat s WHERE s.room.id = :roomId")
                .setParameter("roomId", roomId)
                .executeUpdate();
    }
}
