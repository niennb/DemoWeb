/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package uef.edu.vn.service;

import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import uef.edu.vn.model.User;
import uef.edu.vn.repository.UserRepository;

@Service
@Transactional // Đảm bảo tính toàn vẹn dữ liệu khi thay đổi DB qua JPA
public class UserService {

    @Autowired
    private UserRepository userRepository;

    // Lấy danh sách hiển thị lên bảng Admin
    public List<User> getAllAccounts() {
        return userRepository.findAll();
    }

    // ==============================================================================
    // HÀM HOÀN CHỈNH: THÊM MỚI HOẶC CẬP NHẬT TÀI KHOẢN NGƯỜI DÙNG
    // ==============================================================================
    public void saveAccount(User user) {
        if (user.getId() == null) {
            // ---------------------------------------------------------
            // TRƯỜNG HỢP 1: THÊM MỚI TÀI KHOẢN (ID chưa tồn tại)
            // ---------------------------------------------------------
            if (user.getStatus() == null || user.getStatus().trim().isEmpty()) {
                user.setStatus("ACTIVE"); // Mặc định hoạt động nếu để trống
            }
            if (user.getRole() == null || user.getRole().trim().isEmpty()) {
                user.setRole("USER"); // Mặc định quyền USER
            }

            // Gọi chính xác hàm save(user) sử dụng persist của bạn
            userRepository.save(user);

        } else {
            // ---------------------------------------------------------
            // TRƯỜNG HỢP 2: CẬP NHẬT TÀI KHOẢN (ID đã có sẵn)
            // ---------------------------------------------------------
            User existingUser = userRepository.findById(user.getId());
            if (existingUser != null) {
                // Đồng bộ cập nhật các trường thông tin cơ bản từ Form
                existingUser.setFull_name(user.getFull_name());
                existingUser.setUsername(user.getUsername());
                existingUser.setEmail(user.getEmail());
                existingUser.setRole(user.getRole());
                existingUser.setStatus(user.getStatus());

                // Xử lý bảo mật mật khẩu: 
                // Nếu trên Form Admin có nhập mật khẩu mới thì ghi đè, nếu để trống thì giữ nguyên mật khẩu cũ
                if (user.getPassword() != null && !user.getPassword().trim().isEmpty()) {
                    existingUser.setPassword(user.getPassword());
                }

                // Gọi hàm update sử dụng merge dữ liệu xuống SQL
                userRepository.update(existingUser);
            }
        }
    }

    // Logic Khóa / Mở khóa tài khoản (<<extend>>)
    public void toggleAccountStatus(long id) {
        User user = userRepository.findById(id);
        if (user != null) {
            // Nếu đang LOCKED thì chuyển thành ACTIVE, ngược lại chuyển thành LOCKED
            if ("LOCKED".equalsIgnoreCase(user.getStatus())) {
                user.setStatus("ACTIVE");
            } else {
                user.setStatus("LOCKED");
            }
            // Cập nhật trạng thái mới xuống DB
            userRepository.update(user);
        }
    }

    // Logic Đặt lại mật khẩu thủ công (<<extend>>)
    public void resetPassword(long id) {
        User user = userRepository.findById(id);
        if (user != null) {
            // Đặt lại mật khẩu mặc định là 123456
            user.setPassword("123456");
            userRepository.update(user);
        }
    }
}
