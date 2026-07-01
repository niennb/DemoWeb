/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package uef.edu.vn.model;

import jakarta.persistence.*;
import java.util.List;

@Entity
@Table(name = "rooms")
public class Room {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id; // Mã phòng tự động tăng từ 1

    @Column(name = "room_name", nullable = false, length = 50)
    private String roomName; // Tên phòng chiếu

    @Column(name = "capacity")
    private int capacity = 0; // Số lượng ghế tối đa trong phòng

    @OneToMany(mappedBy = "room", fetch = FetchType.EAGER)
    private List<Seat> seats;

    // Constructor mặc định (Bắt buộc phải có trong JPA Entity)
    public Room() {
    }

    // Constructor đầy đủ tham số để thuận tiện khởi tạo nhanh dữ liệu
    public Room(Long id, String roomName, int capacity) {
        this.id = id;
        this.roomName = roomName;
        this.capacity = capacity;
    }

    // System Getters and Setters
    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public String getRoomName() {
        return roomName;
    }

    public void setRoomName(String roomName) {
        this.roomName = roomName;
    }

    public int getCapacity() {
        return capacity;
    }

    public void setCapacity(int capacity) {
        this.capacity = capacity;
    }

    public List<Seat> getSeats() {
        return seats;
    }

    public void setSeats(List<Seat> seats) {
        this.seats = seats;
    }
    
    
}
