/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package uef.edu.vn.model;

import jakarta.persistence.*;
import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.NotBlank;

@Entity // dung lien ket database
@Table(name="users")
public class User {
    @Id // danh dau primary key
    @GeneratedValue(strategy = GenerationType.IDENTITY) // tu tang id
    private Long id;
    
    @Column(nullable = false, unique = true, length = 50) // kh dc de trong va phai duy nhat
    private String username;
    
    @Column(nullable = false, length = 255)
    private String password;
    
    @Column(length = 20)
    private String role = "USER"; // mac dinh la USER

    @Email(message ="Email không hợp lệ")
    @NotBlank(message = "Email không được để trống")
    @Column(nullable = false, unique = true, length = 255) // email phai duy nhat va kh de trong
    private String email;
    
    // === CẬP NHẬT: THÊM THUỘC TÍNH STATUS ===
    @Column(length = 20)
    private String status = "ACTIVE"; // mac dinh la ACTIVE (Hoạt động)
    
    @Column(length = 100)
    private String full_name;
    

    // Constructor mặc định (Không tham số)
    public User(){
        this.id = 0L;
        this.username = "";
        this.password = "";
        this.role = "USER";
        this.email = "";
        this.full_name = "";
        this.status = "ACTIVE"; // Khởi tạo mặc định
    }
    
    // Constructor cũ (5 tham số) - Giữ nguyên để tránh lỗi compile ở các class khác
    public User(Long id, String username, String password, String role, String email) {
        this.id = id;
        this.username = username;
        this.password = password;
        this.role = role;
        this.email = email;
        this.status = "ACTIVE"; // Tự động gán ACTIVE khi tạo mới
    }

    // Constructor mới (6 tham số) - Dùng khi cần đọc/ghi đầy đủ trạng thái từ DB
    public User(Long id, String username, String password, String role, String email, String status) {
        this.id = id;
        this.username = username;
        this.password = password;
        this.role = role;
        this.email = email;
        this.status = status;
    }
    //Constructor mới 7 tham số
     public User(Long id, String username, String password, String role, String email,String full_name, String status) {
        this.id = id;
        this.username = username;
        this.password = password;
        this.role = role;
        this.email = email;
        this.full_name = full_name;
        this.status = status;
    }

    // === HỆ THỐNG GETTER VÀ SETTER ===

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public String getUsername() {
        return username;
    }

    public void setUsername(String username) {
        this.username = username;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public String getRole() {
        return role;
    }

    public void setRole(String role) {
        this.role = role;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    // === CẬP NHẬT: GETTER VÀ SETTER CHO STATUS ===
    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public String getFull_name() {
        return full_name;
    }

    public void setFull_name(String full_name) {
        this.full_name = full_name;
    }
    
    
}
