/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package uef.edu.vn.controller;

import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import uef.edu.vn.model.User;
import uef.edu.vn.repository.UserRepository;

/**
 *
 * @author baoni
 */
@Controller
public class AuthController {

    @Autowired // tu tim doi tuong repository
    private UserRepository userRepository;

    @GetMapping("/register")
    public String showRegisterForm(Model model) {
        model.addAttribute("pageTitle", "Đăng Ký - AlphaCinema");
        model.addAttribute("viewFile", "register");
        return "layout/main"; // tra ve view dang ky
    }

    @PostMapping("/register")
    public String registerUser(@RequestParam String username, @RequestParam String email, @RequestParam String password, @RequestParam String confirmPassword, Model model) {
        if (!password.equals(confirmPassword)) {
            model.addAttribute("error", "Mật khẩu nhập lại không trùng khớp!");
            model.addAttribute("username", username);
            model.addAttribute("email", email);

            model.addAttribute("pageTitle", "Đăng Ký - AlphaCinema");
            model.addAttribute("viewFile", "register");
            return "layout/main";
        }
        if (userRepository.findByUsername(username) != null) {
            model.addAttribute("error", "Tên người dùng đã tồn tại!");
            model.addAttribute("email", email);
            return "register"; // ten ton tai thi quay lai
        }
        if (userRepository.findByEmail(email) != null) {
            model.addAttribute("error", "Email này đã được đăng ký!");
            model.addAttribute("username", username);
            return "register"; // email ton tai thi quay lai
        }
        User u = new User();
        u.setUsername(username);
        u.setPassword(password); // luu mat khau chua ma hoa (ko nen lam vay trong thuc te)
        u.setEmail(email);
        userRepository.save(u); // luu nguoi dung vao database
        return "redirect:/login"; // sau khi dang ky xong thi chuyen den
    }

    @GetMapping("/login")
    public String showLoginForm(Model model) {
        model.addAttribute("pageTitle", "Đăng Nhập - AlphaCinema");
        model.addAttribute("viewFile", "login");

        return "layout/main";
    }

    @PostMapping("/login")
    public String loginUser(@RequestParam String username, @RequestParam String password, HttpSession session, Model model) {
        User u = userRepository.findByUsername(username);
        
        // Kiểm tra tài khoản tồn tại, đúng mật khẩu và không bị khoá
        if (u != null && u.getUsername().equals(username) && u.getPassword().equals(password) && !"LOCKED".equalsIgnoreCase(u.getStatus())) {
            session.setAttribute("user", u); // lưu thông tin người dùng vào session
            
            // ================== ĐOẠN RẼ NHÁNH PHÂN QUYỀN TẠI ĐÂY ==================
            if (u.getRole() != null && "ADMIN".equalsIgnoreCase(u.getRole())) {
                return "redirect:/admin/dashboard"; // Nếu là ADMIN -> chuyển hướng vào trang quản trị
            } else {
                return "redirect:/"; // Nếu là USER (hoặc quyền khác) -> về trang chủ khách hàng
            }
            // ======================================================================
            
        } else {
            model.addAttribute("error", "Tên người dùng hoặc mật khẩu không đúng, hoặc tài khoản đã bị khoá!");
            
            model.addAttribute("pageTitle", "Đăng Nhập - AlphaCinema");
            model.addAttribute("viewFile", "login");
            return "layout/main";
        }
    }

    @GetMapping("/logout")
    public String logoutUser(HttpSession session) {
        session.invalidate(); // xoa session khi dang xuat
        return "redirect:/";
    }
}
