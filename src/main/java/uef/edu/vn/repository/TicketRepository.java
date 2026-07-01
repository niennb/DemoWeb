/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package uef.edu.vn.repository;

import uef.edu.vn.model.Ticket;
import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;
import jakarta.persistence.TypedQuery;
import java.util.List;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

@Repository
@Transactional
public class TicketRepository {

    @PersistenceContext
    private EntityManager entityManager;

    // Lưu Ticket mới hoặc cập nhật
    public void save(Ticket ticket) {
        if (ticket.getId() == null) {
            entityManager.persist(ticket);
        } else {
            entityManager.merge(ticket);
        }
    }

    // ĐÃ FIX: Sửa kiểu dữ liệu tham số từ String thành Long cho đồng bộ với Entity
    public Ticket findById(Long id) {
        try {
            return entityManager.find(Ticket.class, id);
        } catch (Exception e) {
            return null;
        }
    }

    // BỔ SUNG: Lấy toàn bộ danh sách vé (Sắp xếp thời gian đặt vé mới nhất lên đầu)
    public List<Ticket> findAll() {
        String jpql = "SELECT t FROM Ticket t ORDER BY t.bookingTime DESC";
        TypedQuery<Ticket> query = entityManager.createQuery(jpql, Ticket.class);
        return query.getResultList();
    }

    // 4. Đếm số lượng vé BÁN ĐƯỢC TRONG HÔM NAY
    public Long countTicketsToday(java.time.LocalDateTime startOfDay, java.time.LocalDateTime endOfDay) {
        try {
            return entityManager.createQuery(
                    "SELECT COUNT(t) FROM Ticket t WHERE t.bookingTime >= :startOfDay AND t.bookingTime <= :endOfDay AND (t.status = 'PAID' OR t.status = 'PENDING')", Long.class)
                    .setParameter("startOfDay", startOfDay)
                    .setParameter("endOfDay", endOfDay)
                    .getSingleResult();
        } catch (Exception e) {
            return 0L;
        }
    }

    // 5. Lấy danh sách HOẠT ĐỘNG GẦN ĐÂY (5 vé mới đặt nhất)
    public List<Ticket> getRecentTickets() {
        return entityManager.createQuery(
                "SELECT t FROM Ticket t ORDER BY t.bookingTime DESC", Ticket.class)
                .setMaxResults(5) // Chỉ lấy 5 dòng mới nhất
                .getResultList();
    }
    
    // Lấy danh sách tên các ghế đã được đặt của một suất chiếu
    public List<String> findBookedSeatNamesByShowtimeId(Long showtimeId) {
        String sql = "SELECT s.seat_name " +
                     "FROM ticket_seats ts " +
                     "JOIN tickets t ON ts.ticket_id = t.id " +
                     "JOIN seats s ON ts.seat_id = s.id " +
                     "WHERE t.showtime_id = :showtimeId";
                     
        return entityManager.createNativeQuery(sql)
                .setParameter("showtimeId", showtimeId)
                .getResultList();
    }
}
