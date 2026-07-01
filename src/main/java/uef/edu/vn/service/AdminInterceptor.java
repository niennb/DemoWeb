/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package uef.edu.vn.service;

/**
 *
 * @author baoni
 */
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import org.springframework.web.servlet.HandlerInterceptor;
import uef.edu.vn.model.User;

public class AdminInterceptor implements HandlerInterceptor{
    @Override
    public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) throws Exception {
        // 1. Lấy session hiện tại của trình duyệt
        HttpSession session = request.getSession();
        
        // 2. Lấy thông tin user đã lưu lúc đăng nhập thành công (từ AuthController)
        User user = (User) session.getAttribute("user");

        // 3. KIỂM TRA: Nếu chưa đăng nhập HOẶC đã đăng nhập nhưng KHÔNG PHẢI ADMIN
        if (user == null || user.getRole() == null || !"ADMIN".equalsIgnoreCase(user.getRole()) || !"ACTIVE".equalsIgnoreCase(user.getStatus())) {
            
            // Đẩy thêm một thông báo lỗi để hiển thị ngoài trang login (nếu muốn)
            session.setAttribute("securityError", "Bạn không có quyền truy cập!");
            
            // Ép buộc trình duyệt chuyển hướng (văng) về trang đăng nhập
            response.sendRedirect(request.getContextPath() + "/login");
            
            return false; // CHẶN ĐỨNG REQUEST: Không cho đi tiếp vào AdminController
        }

        return true;
}
}
