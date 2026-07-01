/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package uef.edu.vn.model;

import jakarta.persistence.*;
import java.time.LocalDateTime;

@Entity
@Table(name = "payments")
public class Payment {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    // ĐÃ THAY ĐỔI: Chuyển đổi từ @ManyToOne thành @OneToOne để đồng nhất quan hệ cặp 1 - 1
    @OneToOne
    @JoinColumn(name = "ticket_id", nullable = false)
    private Ticket ticket;

    @Column(name = "amount", nullable = false)
    private Double amount;

    @Column(name = "payment_method", length = 50)
    private String paymentMethod;

    @Column(name = "payment_time", nullable = false)
    private LocalDateTime paymentTime = LocalDateTime.now();

    @Column(name = "status", length = 50)
    private String status = "SUCCESS";

    public Payment() {
    }

    public Payment(Long id, Ticket ticket, Double amount, String paymentMethod, LocalDateTime paymentTime, String status) {
        this.id = id;
        this.ticket = ticket;
        this.amount = amount;
        this.paymentMethod = paymentMethod;
        this.paymentTime = paymentTime;
        this.status = status;
    }

    // System Getters and Setters
    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public Ticket getTicket() {
        return ticket;
    }

    public void setTicket(Ticket ticket) {
        this.ticket = ticket;
    }

    public Double getAmount() {
        return amount;
    }

    public void setAmount(Double amount) {
        this.amount = amount;
    }

    public String getPaymentMethod() {
        return paymentMethod;
    }

    public void setPaymentMethod(String paymentMethod) {
        this.paymentMethod = paymentMethod;
    }

    public LocalDateTime getPaymentTime() {
        return paymentTime;
    }

    public void setPaymentTime(LocalDateTime paymentTime) {
        this.paymentTime = paymentTime;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }
}
