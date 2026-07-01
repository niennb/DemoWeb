/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package uef.edu.vn.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import java.util.List;
import uef.edu.vn.repository.TicketRepository;
import uef.edu.vn.model.Ticket;

@Service
public class TicketService {

    @Autowired
    private TicketRepository ticketRepository;

    // Lấy toàn bộ danh sách vé (đã được sắp xếp mới nhất lên đầu nhờ Repository)
    public List<Ticket> getAllTickets() {
        return ticketRepository.findAll();
    }

    // Lấy thông tin chi tiết của 1 vé (dùng khi cần xem chi tiết hoặc sửa)
    public Ticket getTicketById(Long id) {
        return ticketRepository.findById(id);
    }

    // Nghiệp vụ Hủy vé của Admin
// Nghiệp vụ Hủy vé của Admin
    public void cancelTicket(Long ticketId) {
        Ticket ticket = ticketRepository.findById(ticketId);
        
        if (ticket == null) {
            throw new IllegalArgumentException("Không tìm thấy thông tin vé này trên hệ thống!");
        }
        
        if ("Đã hủy".equalsIgnoreCase(ticket.getStatus()) || "CANCELED".equalsIgnoreCase(ticket.getStatus())) {
            throw new IllegalArgumentException("Vé này đã được hủy trước đó, không thể hủy thêm!");
        }
        
        // 1. Chuyển trạng thái của chiếc vé thành "Đã hủy"
        ticket.setStatus("Đã hủy");
        
        // 2. 💡 XỬ LÝ ĐỒNG BỘ (FIX LỖI): Tìm hóa đơn đi kèm và đánh dấu FAILED
        // Nhờ ánh xạ @OneToOne, ta lấy thẳng đối tượng Payment ra mà không cần chọc vào PaymentRepository
        if (ticket.getPayment() != null) {
            ticket.getPayment().setStatus("FAILED");
        }
        
        ticketRepository.save(ticket);
    }
}