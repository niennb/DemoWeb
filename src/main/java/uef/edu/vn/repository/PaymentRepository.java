/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package uef.edu.vn.repository;

import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;
import java.util.List;
import org.springframework.stereotype.Repository;
import uef.edu.vn.model.Payment;

@Repository
public class PaymentRepository {

    @PersistenceContext
    private EntityManager entityManager;

    // 💡 THAY ĐỔI: Bổ sung ORDER BY p.paymentTime DESC để sắp xếp hóa đơn mới nhất lên đầu danh sách
    public List<Payment> findAll() {
        return entityManager.createQuery("SELECT p FROM Payment p ORDER BY p.paymentTime DESC", Payment.class).getResultList();
    }

    // Tìm kiếm giao dịch thanh toán theo ID
    public Payment findById(Long id) {
        return entityManager.find(Payment.class, id);
    }

    // 💡 THAY ĐỔI: Tối ưu hóa hàm lưu dữ liệu, vừa giúp tạo mới, vừa giúp update trạng thái mà không lỗi
    public void save(Payment payment) {
        if (payment.getId() == null) {
            entityManager.persist(payment); // Tạo mới nếu chưa có ID
        } else {
            entityManager.merge(payment);   // Cập nhật nếu đã tồn tại ID
        }
    }

    // 1. Tính TỔNG DOANH THU (Chỉ tính các hóa đơn SUCCESS)
    public Double getTotalRevenue() {
        try {
            Double total = entityManager.createQuery(
                    "SELECT SUM(p.amount) FROM Payment p WHERE p.status = 'SUCCESS'", Double.class)
                    .getSingleResult();
            return total != null ? total : 0.0; // Tránh lỗi NullPointerException nếu chưa có hóa đơn nào
        } catch (Exception e) {
            return 0.0;
        }
    }

    // 2. Đếm số hóa đơn ĐANG CHỜ XÁC NHẬN (Cảnh báo Dashboard)
    public Long countPendingPayments() {
        try {
            return entityManager.createQuery(
                    "SELECT COUNT(p) FROM Payment p WHERE p.status = 'PENDING' OR p.status = 'Chưa thanh toán'", Long.class)
                    .getSingleResult();
        } catch (Exception e) {
            return 0L;
        }
    }

    // 3. Lấy dữ liệu Biểu đồ Doanh Thu 7 Ngày Qua
    // Hàm này trả về 1 danh sách các mảng Object (Bao gồm: [Ngày, Tổng tiền])
    public List<Object[]> getRevenueLast7Days(java.time.LocalDateTime startDate) {
        return entityManager.createQuery(
                "SELECT FUNCTION('DATE', p.paymentTime), SUM(p.amount) "
                + "FROM Payment p "
                + "WHERE p.status = 'SUCCESS' AND p.paymentTime >= :startDate "
                + "GROUP BY FUNCTION('DATE', p.paymentTime) "
                + "ORDER BY FUNCTION('DATE', p.paymentTime)", Object[].class)
                .setParameter("startDate", startDate)
                .getResultList();
    }
}
