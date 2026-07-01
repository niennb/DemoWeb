/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package uef.edu.vn.model;

import jakarta.persistence.*;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

@Entity
@Table(name = "tickets")
public class Ticket {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    // ĐÃ THAY ĐỔI: Xóa @JoinColumn, chuyển thành mappedBy trỏ sang thuộc tính "ticket" bên phía Payment.java
    @OneToOne(mappedBy = "ticket", fetch = FetchType.EAGER, cascade = CascadeType.ALL)
    private Payment payment;

    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "user_id")
    private User user;

    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "movie_id")
    private Movie movie;

    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "showtime_id")
    private Showtime showtime;

    @Column(name = "booking_time")
    private LocalDateTime bookingTime;

    @Column(name = "total_price")
    private Double totalPrice;

    @Column(name = "status")
    private String status;

    @ManyToMany(fetch = FetchType.EAGER)
    @JoinTable(
            name = "ticket_seats",
            joinColumns = @JoinColumn(name = "ticket_id"),
            inverseJoinColumns = @JoinColumn(name = "seat_id")
    )
    private List<Seat> seats = new ArrayList<>();

    public Ticket() {
    }

    public Ticket(Long id, Payment payment, User user, Movie movie, Showtime showtime, LocalDateTime bookingTime, Double totalPrice, String status, List<Seat> seats) {
        this.id = id;
        this.payment = payment;
        this.user = user;
        this.movie = movie;
        this.showtime = showtime;
        this.bookingTime = bookingTime;
        this.totalPrice = totalPrice;
        this.status = status;
        this.seats = seats;
    }

    // SYSTEM GETTERS / SETTERS
    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public Payment getPayment() {
        return payment;
    }

    public void setPayment(Payment payment) {
        this.payment = payment;
    }

    public User getUser() {
        return user;
    }

    public void setUser(User user) {
        this.user = user;
    }

    public Movie getMovie() {
        return movie;
    }

    public void setMovie(Movie movie) {
        this.movie = movie;
    }

    public Showtime getShowtime() {
        return showtime;
    }

    public void setShowtime(Showtime showtime) {
        this.showtime = showtime;
    }

    public LocalDateTime getBookingTime() {
        return bookingTime;
    }

    public void setBookingTime(LocalDateTime bookingTime) {
        this.bookingTime = bookingTime;
    }

    public Double getTotalPrice() {
        return totalPrice;
    }

    public void setTotalPrice(Double totalPrice) {
        this.totalPrice = totalPrice;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public List<Seat> getSeats() {
        return seats;
    }

    public void setSeats(List<Seat> seats) {
        this.seats = seats;
    }
}
