/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package uef.edu.vn.service;

import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import uef.edu.vn.model.Payment;
import uef.edu.vn.model.Ticket;
import uef.edu.vn.repository.PaymentRepository;
import uef.edu.vn.repository.TicketRepository;

@Service
@Transactional // Chạy cơ chế Transaction để nếu lỗi 1 bảng thì tự Rollback lại, tránh lệch dữ liệu
public class PaymentService {

    @Autowired
    private PaymentRepository paymentRepository;

    @Autowired
    private TicketRepository ticketRepository; // Nhúng thêm TicketRepository để đồng bộ trạng thái vé

    // Lấy toàn bộ hóa đơn
    public List<Payment> getAllPayments() {
        return paymentRepository.findAll();
    }

    // Xử lý lưu hóa đơn ban đầu
    public void processPayment(Payment payment) {
        paymentRepository.save(payment);
    }

    // 💡 BỔ SUNG: Hàm xử lý cập nhật trạng thái do Admin chỉ định
    public void updateStatus(Long paymentId, String status) {
        Payment payment = paymentRepository.findById(paymentId);
        if (payment == null) {
            throw new IllegalArgumentException("Không tìm thấy mã giao dịch hóa đơn này!");
        }

        // 1. Cập nhật trạng thái cho thực thể Payment
        payment.setStatus(status);
        paymentRepository.save(payment); // Thực hiện cập nhật vào Database

        // 2. Đồng bộ trạng thái sang cho tấm vé (Ticket) tương ứng
        Ticket ticket = payment.getTicket();
        if (ticket != null) {
            if ("SUCCESS".equalsIgnoreCase(status)) {
                ticket.setStatus("PAID"); // Đã thanh toán
            } else if ("PENDING".equalsIgnoreCase(status)) {
                ticket.setStatus("PENDING"); // Chờ xử lý
            } else {
                ticket.setStatus("FAILED"); // Thất bại hoặc bị hủy
            }
            ticketRepository.save(ticket); // Lưu trạng thái vé mới xuống DB
        }
    }
}
