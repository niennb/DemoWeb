/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package uef.edu.vn.service;

import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import uef.edu.vn.model.Showtime;
import uef.edu.vn.model.Ticket;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.LocalTime;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service
@Transactional(readOnly = true)
public class DashboardService {

    @PersistenceContext
    private EntityManager em;

    /**
     * Hàm tổng hợp toàn bộ dữ liệu cần thiết cho trang Dashboard Admin Trả về
     * một Map chứa các nhóm dữ liệu để Controller dễ dàng đẩy qua JSP
     */
    public Map<String, Object> getDashboardData() {
        Map<String, Object> data = new HashMap<>();

        // Thiết lập mốc thời gian ngày hôm nay (Từ 00:00:00 đến 23:59:59)
        LocalDateTime startOfToday = LocalDate.now().atStartOfDay();
        LocalDateTime endOfToday = LocalDate.now().atTime(LocalTime.MAX);
        LocalDateTime sevenDaysAgo = LocalDate.now().minusDays(6).atStartOfDay(); // 7 ngày bao gồm cả hôm nay

        // ==============================================================================
        // 1. NHÓM THỐNG KÊ NHANH (4 CARDS)
        // ==============================================================================
        // Tổng doanh thu (Chỉ tính các hóa đơn SUCCESS hoặc Thành công)
        Double totalRevenue = em.createQuery(
                "SELECT SUM(p.amount) FROM Payment p WHERE p.status = 'SUCCESS' OR p.status = 'Thành công'", Double.class)
                .getSingleResult();
        data.put("totalRevenue", totalRevenue != null ? totalRevenue : 0.0);

        // Số lượng vé bán ra trong ngày hôm nay (Bỏ qua các vé đã hủy)
        Long ticketsToday = em.createQuery(
                "SELECT COUNT(t) FROM Ticket t WHERE t.bookingTime BETWEEN :start AND :end AND t.status != 'Đã hủy'", Long.class)
                .setParameter("start", startOfToday)
                .setParameter("end", endOfToday)
                .getSingleResult();
        data.put("ticketsToday", ticketsToday != null ? ticketsToday : 0L);

        // Tổng số khách hàng thành viên (Role là USER)
        Long totalCustomers = em.createQuery(
                "SELECT COUNT(u) FROM User u WHERE u.role = 'USER'", Long.class)
                .getSingleResult();
        data.put("totalCustomers", totalCustomers != null ? totalCustomers : 0L);

        // Số lượng phim đang chiếu trên hệ thống
        Long showingMovies = em.createQuery(
                "SELECT COUNT(m) FROM Movie m WHERE m.status = 'Đang chiếu'", Long.class)
                .getSingleResult();
        data.put("showingMovies", showingMovies != null ? showingMovies : 0L);

        // ==============================================================================
        // 2. NHÓM BIỂU ĐỒ (CHARTS)
        // ==============================================================================
        // Biểu đồ doanh thu 7 ngày qua (Trả về danh sách mảng: [Ngày, Doanh thu])
        List<Object[]> revenue7Days = em.createQuery(
                "SELECT FUNCTION('DATE', p.paymentTime), SUM(p.amount) "
                + "FROM Payment p "
                + "WHERE (p.status = 'SUCCESS' OR p.status = 'Thành công') AND p.paymentTime >= :startDate "
                + "GROUP BY FUNCTION('DATE', p.paymentTime) "
                + "ORDER BY FUNCTION('DATE', p.paymentTime) ASC", Object[].class)
                .setParameter("startDate", sevenDaysAgo)
                .getResultList();
        data.put("revenue7Days", revenue7Days);

        // Biểu đồ doanh thu theo phim (Tên phim, Tổng tiền)
        List<Object[]> revenueByMovie = em.createQuery(
                "SELECT t.movie.name, SUM(t.totalPrice) "
                + "FROM Ticket t "
                + "WHERE t.status != 'Đã hủy' "
                + "GROUP BY t.movie.name "
                + "ORDER BY SUM(t.totalPrice) DESC", Object[].class)
                .getResultList();
        data.put("revenueByMovie", revenueByMovie);

        // Biểu đồ doanh thu theo thể loại phim (Thể loại, Tổng tiền)
        List<Object[]> revenueByGenre = em.createQuery(
                "SELECT t.movie.genre, SUM(t.totalPrice) "
                + "FROM Ticket t "
                + "WHERE t.status != 'Đã hủy' "
                + "GROUP BY t.movie.genre "
                + "ORDER BY SUM(t.totalPrice) DESC", Object[].class)
                .getResultList();
        data.put("revenueByGenre", revenueByGenre);

        // ==============================================================================
        // 3. NHÓM DANH SÁCH TOP (TOP 5)
        // ==============================================================================
        // Top 5 phim bán chạy nhất (Dựa trên số lượng vé bán ra)
        List<Object[]> top5Movies = em.createQuery(
                "SELECT t.movie.name, COUNT(t), SUM(t.totalPrice) "
                + "FROM Ticket t "
                + "WHERE t.status != 'Đã hủy' "
                + "GROUP BY t.movie.name "
                + "ORDER BY COUNT(t) DESC", Object[].class)
                .setMaxResults(5)
                .getResultList();
        data.put("top5Movies", top5Movies);

        // Top 5 suất chiếu đông khách nhất (Suất chiếu ID, Tên phim, Giờ chiếu, Tên phòng, Số lượng vé)
        List<Object[]> top5Showtimes = em.createQuery(
                "SELECT s.id, s.movie.name, s.startTime, s.room.roomName, COUNT(t) "
                + "FROM Ticket t JOIN t.showtime s "
                + "WHERE t.status != 'Đã hủy' "
                + "GROUP BY s.id, s.movie.name, s.startTime, s.room.roomName "
                + "ORDER BY COUNT(t) DESC", Object[].class)
                .setMaxResults(5)
                .getResultList();
        data.put("top5Showtimes", top5Showtimes);

        // ==============================================================================
        // 4. LỊCH CHIẾU HÔM NAY & HOẠT ĐỘNG GẦN ĐÂY
        // ==============================================================================
        // Danh sách toàn bộ lịch chiếu của ngày hôm nay
        List<Showtime> todayShowtimes = em.createQuery(
                "SELECT s FROM Showtime s WHERE s.startTime BETWEEN :start AND :end ORDER BY s.startTime ASC", Showtime.class)
                .setParameter("start", startOfToday)
                .setParameter("end", endOfToday)
                .getResultList();
        data.put("todayShowtimes", todayShowtimes);

        // Hoạt động gần đây (Lấy ra 5 vé xem phim vừa được đặt mới nhất hệ thống)
        List<Ticket> recentActivities = em.createQuery(
                "SELECT t FROM Ticket t ORDER BY t.bookingTime DESC", Ticket.class)
                .setMaxResults(5)
                .getResultList();
        data.put("recentActivities", recentActivities);

        // ==============================================================================
        // 5. HỆ THỐNG CẢNH BÁO & THÔNG BÁO THÔNG MINH (NOTIFICATIONS)
        // ==============================================================================
        List<String> notifications = new ArrayList<>();

        // Cảnh báo 1: Đếm số lượng thanh toán đang chờ xác nhận (PENDING)
        Long pendingPayments = em.createQuery(
                "SELECT COUNT(p) FROM Payment p WHERE p.status = 'PENDING' OR p.status = 'Chưa thanh toán'", Long.class)
                .getSingleResult();
        if (pendingPayments != null && pendingPayments > 0) {
            notifications.add("Có " + pendingPayments + " thanh toán đang chờ xác nhận");
        }

        // Cảnh báo 2: Tìm các phim đang chiếu nhưng "Sắp hết lịch" (Không có suất chiếu nào trong 3 ngày tới)
        LocalDateTime threeDaysLater = LocalDateTime.now().plusDays(3);
        List<String> activeMoviesWithoutShowtimes = em.createQuery(
                "SELECT m.name FROM Movie m WHERE m.status = 'Đang chiếu' AND m.id NOT IN ("
                + "SELECT DISTINCT s.movie.id FROM Showtime s WHERE s.startTime >= :now AND s.startTime <= :future)", String.class)
                .setParameter("now", LocalDateTime.now())
                .setParameter("future", threeDaysLater)
                .getResultList();
        for (String movieName : activeMoviesWithoutShowtimes) {
            notifications.add("Phim " + movieName + " sắp hết lịch chiếu tiếp theo");
        }

        // Cảnh báo 3: Tìm các phòng chiếu (Room) hôm nay hoàn toàn trống lịch (Chưa có lịch chiếu nào)
        List<String> emptyRoomsToday = em.createQuery(
                "SELECT r.name FROM Room r WHERE r.id NOT IN ("
                + "SELECT DISTINCT s.room.id FROM Showtime s WHERE s.startTime BETWEEN :start AND :end)", String.class)
                .setParameter("start", startOfToday)
                .setParameter("end", endOfToday)
                .getResultList();
        for (String roomName : emptyRoomsToday) {
            notifications.add("Phòng " + roomName + " chưa có lịch chiếu nào trong hôm nay");
        }

        data.put("notifications", notifications);

        return data;
    }
}
