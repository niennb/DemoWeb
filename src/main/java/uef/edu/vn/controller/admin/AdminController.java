/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
 /*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package uef.edu.vn.controller.admin;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;
import org.springframework.dao.DataIntegrityViolationException;
import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;
import java.util.List;
import java.util.stream.Collectors;

// Import Models
import uef.edu.vn.model.Movie;
import uef.edu.vn.model.User;
import uef.edu.vn.model.Payment;
import uef.edu.vn.model.Room;
import uef.edu.vn.model.Seat;
import uef.edu.vn.model.Showtime;
import uef.edu.vn.model.Ticket;
import uef.edu.vn.service.DashboardService;

// Import Services
import uef.edu.vn.service.MovieService;
import uef.edu.vn.service.UserService;
import uef.edu.vn.service.RoomService;
import uef.edu.vn.service.PaymentService;
import uef.edu.vn.service.SeatService;
import uef.edu.vn.service.ShowtimeService;
import uef.edu.vn.service.TicketService;

/**
 * AdminController quản lý toàn bộ việc điều hướng và cấu hình hệ thống ma trận
 * của phân hệ ADMIN. Tất cả các đường dẫn trong này đều tự động có tiền tố
 * /admin (Ví dụ: /admin/dashboard)
 *
 * @author baoni
 */
@Controller
@RequestMapping("/admin")
public class AdminController {

    @Autowired
    private UserService userService;

    @Autowired
    private RoomService roomService;

    @Autowired
    private PaymentService paymentService;

    @Autowired
    private MovieService movieService;

    @Autowired
    private SeatService seatService;

    @Autowired
    private ShowtimeService showtimeService;

    @Autowired
    private TicketService ticketService;

    @Autowired
    private DashboardService dashboardService;

    @PersistenceContext
    private EntityManager entityManager;

    // ==============================================================================
    // 1. TRANG CHỦ ADMIN - BÁO CÁO DOANH THU (BI REPORTING)
    // ==============================================================================
    @GetMapping("/dashboard")
    public String showDashboard(Model model) {
        model.addAttribute("pageTitle", "Tổng Quan Hệ Thống - Admin");

        // [MỐC THỜI GIAN CHUẨN]
        java.time.LocalDate today = java.time.LocalDate.now(); // Lấy ngày hôm nay
        java.time.LocalDateTime startOfDay = today.atStartOfDay();
        java.time.LocalDateTime endOfDay = today.atTime(java.time.LocalTime.MAX);
        java.time.LocalDateTime sevenDaysAgo = today.minusDays(7).atStartOfDay();

        // 1. TỔNG DOANH THU
        Double totalRevenue = entityManager.createQuery(
                "SELECT COALESCE(SUM(p.amount), 0.0) FROM Payment p WHERE p.status = 'SUCCESS'", Double.class)
                .getSingleResult();
        model.addAttribute("totalRevenue", totalRevenue);

        // 2. VÉ BÁN HÔM NAY
        Long ticketsToday = entityManager.createQuery(
                "SELECT COUNT(t.id) FROM Ticket t WHERE t.bookingTime BETWEEN :start AND :end", Long.class)
                .setParameter("start", startOfDay)
                .setParameter("end", endOfDay)
                .getSingleResult();
        model.addAttribute("ticketsToday", ticketsToday);

        // 3. TỔNG SỐ KHÁCH HÀNG
        Long totalCustomers = entityManager.createQuery(
                "SELECT COUNT(u.id) FROM User u WHERE u.role = 'USER'", Long.class)
                .getSingleResult();
        model.addAttribute("totalCustomers", totalCustomers);

        // 4. PHIM ĐANG CHIẾU
        Long showingMovies = entityManager.createQuery(
                "SELECT COUNT(m.id) FROM Movie m WHERE m.status = 'Đang chiếu'", Long.class)
                .getSingleResult();
        model.addAttribute("showingMovies", showingMovies);

        // 5. TOP 5 PHIM BÁN CHẠY NHẤT
        List<Object[]> top5Movies = entityManager.createQuery(
                "SELECT p.ticket.movie.name, COUNT(p.ticket.id), SUM(p.amount) "
                + "FROM Payment p "
                + "WHERE p.status = 'SUCCESS' "
                + "GROUP BY p.ticket.movie.name "
                + "ORDER BY COUNT(p.ticket.id) DESC", Object[].class)
                .setMaxResults(5)
                .getResultList();
        model.addAttribute("top5Movies", top5Movies);

        // 6. [ĐÃ SỬA] TOP 5 SUẤT CHIẾU ĐÔNG KHÁCH (Bổ sung s.showDate vào vị trí index 5)
        List<Object[]> top5Showtimes = entityManager.createQuery(
                "SELECT s.id, s.movie.name, s.startTime, s.room.roomName, COUNT(t.id), s.showDate "
                + "FROM Ticket t JOIN t.showtime s "
                + "WHERE t.status != 'Đã hủy' "
                + "GROUP BY s.id, s.movie.name, s.startTime, s.room.roomName, s.showDate "
                + "ORDER BY COUNT(t.id) DESC", Object[].class)
                .setMaxResults(5)
                .getResultList();
        model.addAttribute("top5Showtimes", top5Showtimes);

        // 7. HOẠT ĐỘNG GẦN ĐÂY
        List<Ticket> recentActivities = entityManager.createQuery(
                "SELECT t FROM Ticket t ORDER BY t.bookingTime DESC", Ticket.class)
                .setMaxResults(5)
                .getResultList();
        model.addAttribute("recentActivities", recentActivities);

        // 8. BIỂU ĐỒ LINE CHART
        List<Object[]> revenue7Days = entityManager.createQuery(
                "SELECT FUNCTION('DATE', p.paymentTime), SUM(p.amount) "
                + "FROM Payment p "
                + "WHERE p.status = 'SUCCESS' AND p.paymentTime >= :sevenDaysAgo "
                + "GROUP BY FUNCTION('DATE', p.paymentTime) "
                + "ORDER BY FUNCTION('DATE', p.paymentTime) ASC", Object[].class)
                .setParameter("sevenDaysAgo", sevenDaysAgo)
                .getResultList();
        model.addAttribute("revenue7Days", revenue7Days);

        // 9. BIỂU ĐỒ DOUGHNUT CHART
        List<Object[]> revenueByMovie = entityManager.createQuery(
                "SELECT p.ticket.movie.name, SUM(p.amount) "
                + "FROM Payment p "
                + "WHERE p.status = 'SUCCESS' "
                + "GROUP BY p.ticket.movie.name", Object[].class)
                .getResultList();
        model.addAttribute("revenueByMovie", revenueByMovie);

        // 10. BIỂU ĐỒ PIE CHART
        List<Object[]> revenueByGenre = entityManager.createQuery(
                "SELECT p.ticket.movie.genre, SUM(p.amount) "
                + "FROM Payment p "
                + "WHERE p.status = 'SUCCESS' "
                + "GROUP BY p.ticket.movie.genre", Object[].class)
                .getResultList();
        model.addAttribute("revenueByGenre", revenueByGenre);

        // 11. [ĐÃ SỬA] LỊCH CHIẾU HÔM NAY (Lọc chính xác bằng cột showDate)
        List<Showtime> todayShowtimes = entityManager.createQuery(
                "SELECT s FROM Showtime s WHERE s.showDate = :today ORDER BY s.startTime ASC", Showtime.class)
                .setParameter("today", today)
                .getResultList();
        model.addAttribute("todayShowtimes", todayShowtimes);

        // Chỉ định file giao diện hiển thị
        model.addAttribute("viewFile", "admin/dashboard");
        return "layout/admin-layout";
    }

    // ==============================================================================
    // 2. QUẢN LÝ PHIM (DATA MANIPULATION)
    // ==============================================================================
    @GetMapping("/movie-manage")
    public String showMovieManage(
            @RequestParam(value = "search", required = false) String search,
            @RequestParam(value = "statusFilter", required = false) String statusFilter,
            @RequestParam(value = "sortBy", required = false) String sortBy,
            Model model) {

        // Thay vì gọi getAllMovies() lấy hết danh sách thô, 
        // Ta gọi hàm tìm kiếm nâng cao từ Service kết nối xuống Database
        List<Movie> movies = movieService.getMoviesWithFilter(search, statusFilter, sortBy);

        model.addAttribute("movies", movies);
        model.addAttribute("pageTitle", "Quản Lý Cơ Sở Dữ Liệu Phim - Admin");
        model.addAttribute("viewFile", "admin/movie-manage");
        return "layout/admin-layout";
    }

    @PostMapping("/movie/add")
    public String handleAddMovie(@ModelAttribute("movieForm") Movie movie) {
        movieService.createMovie(movie);
        return "redirect:/admin/movie-manage";
    }

    @PostMapping("/movie/update")
    public String handleUpdateMovie(@ModelAttribute("movieForm") Movie movie) {
        movieService.updateMovie(movie);
        return "redirect:/admin/movie-manage";
    }

    @GetMapping("/movie/delete")
    public String handleDeleteMovie(@RequestParam("id") Long id) {
        movieService.deleteMovie(id);
        return "redirect:/admin/movie-manage";
    }

    // ==============================================================================
    // 3. QUẢN LÝ SUẤT CHIẾU (SHOWTIME CONFIGURATION MATRIX)
    // ==============================================================================
    @GetMapping("/showtime-manage")
    public String showShowtimeManage(
            @RequestParam(value = "search", required = false) String search,
            @RequestParam(value = "roomFilter", required = false) Long roomFilter,
            @RequestParam(value = "dateFilter", required = false) String dateFilter,
            @RequestParam(value = "sortBy", required = false, defaultValue = "date_desc") String sortBy,
            Model model) {

        // 1. Nạp toàn bộ danh sách Phim và Phòng chiếu để hiển thị lên Form và Bộ lọc Dropdown
        // --- ĐOẠN NÂNG CẤP TỐI ƯU DROPDOWN CHO FORM TRÊN GIAO DIỆN ---
        List<Movie> allMovies = movieService.getAllMovies();
        List<Room> allRooms = roomService.getAllRooms();

        // 1. Gửi danh sách gốc này nếu bạn cần dùng cho thanh tìm kiếm/bộ lọc ở header trang
        model.addAttribute("allMovies", allMovies);
        model.addAttribute("allRooms", allRooms);

        // 2. Lọc danh sách Phim hợp lệ (Chỉ lấy Đang chiếu/Sắp chiếu) phục vụ cho Form Thêm/Sửa
        List<Movie> validFormMovies = allMovies.stream()
                .filter(m -> "Đang chiếu".equalsIgnoreCase(m.getStatus()) || "Sắp chiếu".equalsIgnoreCase(m.getStatus()))
                .collect(Collectors.toList());

        // 3. Lọc danh sách Phòng hợp lệ (Chỉ lấy phòng có sức chứa > 0) phục vụ cho Form Thêm/Sửa
        List<Room> validFormRooms = allRooms.stream()
                .filter(r -> r.getCapacity() > 0)
                .collect(Collectors.toList());

        // Giữ nguyên tên thuộc tính "movies" và "rooms" để không phải sửa mã hiển thị thẻ <select> trong form JSP
        model.addAttribute("movies", validFormMovies);
        model.addAttribute("rooms", validFormRooms);

        // 2. Lấy danh sách suất chiếu gốc
        List<Showtime> showtimes = showtimeService.getAllShowtimes();

        // 3. XỬ LÝ BỘ LỌC TÌM KIẾM THEO TÊN PHIM (Nếu có)
        if (search != null && !search.trim().isEmpty()) {
            String keyword = search.toLowerCase().trim();
            showtimes = showtimes.stream()
                    .filter(s -> s.getMovie() != null && s.getMovie().getName().toLowerCase().contains(keyword))
                    .collect(Collectors.toList());
        }

        // 4. XỬ LÝ BỘ LỌC THEO PHÒNG CHIẾU (Nếu có)
        if (roomFilter != null) {
            showtimes = showtimes.stream()
                    .filter(s -> s.getRoom() != null && s.getRoom().getId().equals(roomFilter))
                    .collect(Collectors.toList());
        }

        // 5. XỬ LÝ BỘ LỌC THEO THỜI GIAN (Hôm nay, Sắp chiếu, Đã chiếu xong)
        if (dateFilter != null && !dateFilter.trim().isEmpty()) {
            java.time.LocalDate today = java.time.LocalDate.now();
            switch (dateFilter) {
                case "today":
                    showtimes = showtimes.stream()
                            .filter(s -> s.getShowDate() != null && s.getShowDate().equals(today))
                            .collect(Collectors.toList());
                    break;
                case "future":
                    showtimes = showtimes.stream()
                            .filter(s -> s.getShowDate() != null && s.getShowDate().isAfter(today))
                            .collect(Collectors.toList());
                    break;
                case "past":
                    showtimes = showtimes.stream()
                            .filter(s -> s.getShowDate() != null && s.getShowDate().isBefore(today))
                            .collect(Collectors.toList());
                    break;
            }
        }

        // 6. XỬ LÝ SẮP XẾP DỮ LIỆU
        if ("date_asc".equals(sortBy)) {
            // Cũ nhất lên đầu (Tăng dần theo Ngày -> Giờ)
            showtimes.sort((s1, s2) -> {
                int comp = s1.getShowDate().compareTo(s2.getShowDate());
                if (comp == 0) {
                    return s1.getStartTime().compareTo(s2.getStartTime());
                }
                return comp;
            });
        } else {
            // Mới nhất lên đầu (Giảm dần theo Ngày -> Giờ)
            showtimes.sort((s1, s2) -> {
                int comp = s2.getShowDate().compareTo(s1.getShowDate());
                if (comp == 0) {
                    return s2.getStartTime().compareTo(s1.getStartTime());
                }
                return comp;
            });
        }

        // 7. Đẩy danh sách đã xử lý lọc và sắp xếp sang giao diện hiển thị
        model.addAttribute("showtimes", showtimes);
        model.addAttribute("pageTitle", "Quản Lý Suất Chiếu - Admin");
        model.addAttribute("viewFile", "admin/showtime-manage");
        return "layout/admin-layout";
    }

    // 2. HÀM XỬ LÝ: THÊM/CẬP NHẬT SUẤT CHIẾU (ĐÃ FIX GIỮ DỮ LIỆU)
    @PostMapping("/showtime/save")
    public String handleSaveShowtime(@ModelAttribute("newShowtime") Showtime showtime, RedirectAttributes redirectAttributes) {
        try {
            showtimeService.saveShowtime(showtime);
            redirectAttributes.addFlashAttribute("successMsg", "Lưu suất chiếu thành công!");
        } catch (IllegalArgumentException e) {
            redirectAttributes.addFlashAttribute("errorMsg", e.getMessage());
            // ĐOẠN FIX: Ném ngược đối tượng showtime đang nhập dở về lại giao diện
            redirectAttributes.addFlashAttribute("newShowtime", showtime);
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("errorMsg", "Đã xảy ra lỗi hệ thống khi lưu suất chiếu. Vui lòng thử lại!");
            // ĐOẠN FIX: Ném ngược đối tượng showtime đang nhập dở về lại giao diện
            redirectAttributes.addFlashAttribute("newShowtime", showtime);
        }
        return "redirect:/admin/showtime-manage";
    }

    // 3. HÀM XỬ LÝ: XÓA SUẤT CHIẾU AN TOÀN (GIỮ NGUYÊN)
    @GetMapping("/showtime/delete")
    public String handleDeleteShowtime(@RequestParam("id") Long id, RedirectAttributes redirectAttributes) {
        try {
            showtimeService.deleteShowtime(id);
            redirectAttributes.addFlashAttribute("successMsg", "Xóa suất chiếu thành công!");
        } catch (DataIntegrityViolationException e) {
            redirectAttributes.addFlashAttribute("errorMsg", "Không thể xóa! Suất chiếu này đã có khách đặt vé.");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("errorMsg", "Đã xảy ra lỗi hệ thống khi xóa suất chiếu.");
        }
        return "redirect:/admin/showtime-manage";
    }

    // ==============================================================================
    // 4. QUẢN LÝ TÀI KHOẢN & PHÂN QUYỀN (ĐÃ TỐI ƯU BỘ LỌC NÂNG CAO & FORM LƯU)
    // ==============================================================================
    @GetMapping("/account-manage")
    public String showAccountManage(
            @RequestParam(value = "search", required = false) String search,
            @RequestParam(value = "roleFilter", required = false) String roleFilter,
            @RequestParam(value = "statusFilter", required = false) String statusFilter,
            @RequestParam(value = "sortBy", required = false, defaultValue = "id_desc") String sortBy,
            Model model) {

        // 1. Lấy danh sách tài khoản thô gốc từ hệ thống Service
        List<User> accounts = userService.getAllAccounts();

        // 2. XỬ LÝ BỘ LỌC TÌM KIẾM (Theo Tên đăng nhập, Email hoặc Họ và tên)
        if (search != null && !search.trim().isEmpty()) {
            String keyword = search.toLowerCase().trim();
            accounts = accounts.stream()
                    .filter(a -> (a.getUsername() != null && a.getUsername().toLowerCase().contains(keyword))
                    || (a.getEmail() != null && a.getEmail().toLowerCase().contains(keyword))
                    || (a.getFull_name() != null && a.getFull_name().toLowerCase().contains(keyword)))
                    .collect(Collectors.toList());
        }

        // 3. XỬ LÝ BỘ LỌC THEO VAI TRÒ (ADMIN / USER)
        if (roleFilter != null && !roleFilter.trim().isEmpty()) {
            accounts = accounts.stream()
                    .filter(a -> roleFilter.equalsIgnoreCase(a.getRole()))
                    .collect(Collectors.toList());
        }

        // 4. XỬ LÝ BỘ LỌC THEO TRẠNG THÁI (ACTIVE / LOCKED)
        if (statusFilter != null && !statusFilter.trim().isEmpty()) {
            accounts = accounts.stream()
                    .filter(a -> statusFilter.equalsIgnoreCase(a.getStatus()))
                    .collect(Collectors.toList());
        }

        // 5. XỬ LÝ SẮP XẾP DỮ LIỆU ĐA NĂNG
        switch (sortBy) {
            case "id_asc":
                accounts.sort((a1, a2) -> a1.getId().compareTo(a2.getId()));
                break;
            case "name_asc":
                accounts.sort((a1, a2) -> {
                    String n1 = a1.getFull_name() != null ? a1.getFull_name() : "";
                    String n2 = a2.getFull_name() != null ? a2.getFull_name() : "";
                    return n1.compareToIgnoreCase(n2);
                });
                break;
            case "name_desc":
                accounts.sort((a1, a2) -> {
                    String n1 = a1.getFull_name() != null ? a1.getFull_name() : "";
                    String n2 = a2.getFull_name() != null ? a2.getFull_name() : "";
                    return n2.compareToIgnoreCase(n1);
                });
                break;
            case "id_desc":
            default:
                accounts.sort((a1, a2) -> a2.getId().compareTo(a1.getId()));
                break;
        }

        // 6. Đẩy dữ liệu ra view giao diện
        model.addAttribute("accounts", accounts);
        model.addAttribute("pageTitle", "Quản Lý Tài Khoản Khách Hàng - Admin");
        model.addAttribute("viewFile", "admin/account-manage");
        return "layout/admin-layout";
    }

    // HÀM XỬ LÝ MỚI: NHẬN DỮ LIỆU TỪ KHUNG THÊM / SỬA TÀI KHOẢN
    @PostMapping("/account/save")
    public String handleSaveAccount(@ModelAttribute("accountForm") User user, RedirectAttributes redirectAttributes) {
        try {
            /* LƯU Ý KỸ THUẬT: Hiện tại mình gọi hàm userService.saveAccount(user) theo tiêu chuẩn.
               Nếu trong file UserService.java của bạn đặt tên hàm lưu/cập nhật khác 
               (Ví dụ: .save(user) hoặc .createOrUpdate(user)), bạn chỉ cần đổi lại tên hàm này cho khớp nhé!
             */
            userService.saveAccount(user);
            redirectAttributes.addFlashAttribute("successMsg", "Lưu thông tin tài khoản thành công!");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("errorMsg", "Đã xảy ra lỗi hệ thống khi lưu tài khoản: " + e.getMessage());
        }
        return "redirect:/admin/account-manage";
    }

    @GetMapping("/account/toggle-status")
    public String handleToggleStatus(@RequestParam("id") Long id, RedirectAttributes redirectAttributes) {
        try {
            userService.toggleAccountStatus(id);
            redirectAttributes.addFlashAttribute("successMsg", "Cập nhật trạng thái tài khoản thành công!");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("errorMsg", "Lỗi khi thay đổi trạng thái tài khoản!");
        }
        return "redirect:/admin/account-manage";
    }

    @GetMapping("/account/reset-password")
    public String handleResetPassword(@RequestParam("id") Long id, RedirectAttributes redirectAttributes) {
        try {
            userService.resetPassword(id);
            redirectAttributes.addFlashAttribute("successMsg", "Đặt lại mật khẩu mặc định (123456) thành công!");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("errorMsg", "Lỗi hệ thống khi đặt lại mật khẩu!");
        }
        return "redirect:/admin/account-manage";
    }

// ==============================================================================
    // 5. QUẢN LÝ VÉ XEM PHIM (FIX TRẠNG THÁI & HÓA ĐƠN)
    // ==============================================================================
    @GetMapping("/ticket-manage")
    public String showTicketManage(
            @RequestParam(value = "search", required = false) String search,
            @RequestParam(value = "statusFilter", required = false) String statusFilter,
            @RequestParam(value = "sortBy", required = false, defaultValue = "date_desc") String sortBy,
            Model model) {

        // Lấy toàn bộ danh sách vé (Dữ liệu Room đã tự động được đính kèm nhờ FetchType.EAGER)
        List<Ticket> tickets = ticketService.getAllTickets();

        // 1. LỌC TÌM KIẾM (Đã nâng cấp: Thêm khả năng tìm kiếm theo Tên Rạp)
        if (search != null && !search.trim().isEmpty()) {
            String keyword = search.toLowerCase().trim();
            tickets = tickets.stream()
                    .filter(t
                            -> // Tìm theo Tên phim
                            (t.getMovie() != null && t.getMovie().getName().toLowerCase().contains(keyword))
                    // Tìm theo Tên khách hàng
                    || (t.getUser() != null && t.getUser().getFull_name() != null && t.getUser().getFull_name().toLowerCase().contains(keyword))
                    // Tìm theo Tên rạp (Room Name) - Bổ sung mới
                    || (t.getShowtime() != null && t.getShowtime().getRoom() != null && t.getShowtime().getRoom().getRoomName().toLowerCase().contains(keyword))
                    )
                    .collect(Collectors.toList());
        }

        // 2. LỌC TRẠNG THÁI (Theo data thực tế: PAID, PENDING, FAILED, Đã hủy)
        if (statusFilter != null && !statusFilter.trim().isEmpty()) {
            tickets = tickets.stream()
                    .filter(t -> statusFilter.equalsIgnoreCase(t.getStatus()))
                    .collect(Collectors.toList());
        }

        // 3. SẮP XẾP DỮ LIỆU
        if ("date_asc".equals(sortBy)) {
            tickets.sort((t1, t2) -> t1.getBookingTime().compareTo(t2.getBookingTime()));
        } else if ("price_desc".equals(sortBy)) {
            tickets.sort((t1, t2) -> t2.getTotalPrice().compareTo(t1.getTotalPrice()));
        } else {
            // Mặc định: Vé mới nhất xếp lên đầu
            tickets.sort((t1, t2) -> t2.getBookingTime().compareTo(t1.getBookingTime()));
        }

        model.addAttribute("tickets", tickets);
        model.addAttribute("pageTitle", "Quản Lý Đặt Vé - Admin");
        model.addAttribute("viewFile", "admin/ticket-manage");

        return "layout/admin-layout";
    }

    // HÀM HỦY VÉ GỌI TỪ NÚT BẤM TRONG BẢNG (Giữ nguyên)
    @GetMapping("/ticket/cancel")
    public String handleCancelTicket(@RequestParam("id") Long id, RedirectAttributes redirectAttributes) {
        try {
            ticketService.cancelTicket(id);
            redirectAttributes.addFlashAttribute("successMsg", "Đã hủy vé thành công!");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("errorMsg", "Không thể hủy vé: " + e.getMessage());
        }
        return "redirect:/admin/ticket-manage";
    }

//    @GetMapping("/price-manage")
//    public String showPriceManage(Model model) {
//        model.addAttribute("pageTitle", "Quản Lý Bảng Giá Vé - Admin");
//        model.addAttribute("viewFile", "admin/price-manage");
//        return "layout/admin-layout";
//    }
    // ==============================================================================
    // 6. QUẢN LÝ SƠ ĐỒ PHÒNG CHIẾU
    // ==============================================================================
    @GetMapping("/room-layout")
    public String showRoomLayout(Model model) {
        List<Room> rooms = roomService.getAllRooms();
        model.addAttribute("rooms", rooms);
        model.addAttribute("roomForm", new Room());
        model.addAttribute("pageTitle", "Cấu Trúc Sơ Đồ Phòng Chiếu - Admin");
        model.addAttribute("viewFile", "admin/room-layout");
        return "layout/admin-layout";
    }

    @PostMapping("/room/add")
    public String handleAddRoom(@ModelAttribute("roomForm") Room room) {
        roomService.createRoom(room);
        return "redirect:/admin/room-layout";
    }

    @PostMapping("/room/update")
    public String handleUpdateRoom(@ModelAttribute("roomForm") Room room) {
        roomService.updateRoom(room);
        return "redirect:/admin/room-layout";
    }

    @GetMapping("/room/delete")
    public String handleDeleteRoom(@RequestParam("id") Long id, RedirectAttributes redirectAttributes) {
        try {
            roomService.deleteRoom(id);
            redirectAttributes.addFlashAttribute("successMsg", "Xóa phòng chiếu thành công!");
        } catch (DataIntegrityViolationException e) {
            redirectAttributes.addFlashAttribute("errorMsg", "Không thể xóa! Phòng chiếu này đang có suất chiếu hoặc vé đã bán. Vui lòng hủy suất chiếu trước.");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("errorMsg", "Đã xảy ra lỗi hệ thống khi xóa phòng.");
        }
        return "redirect:/admin/room-layout";
    }

    // ==============================================================================
    // 7. QUẢN LÝ GHẾ NGỒI (TỰ ĐỘNG SINH MA TRẬN)
    // ==============================================================================
    @GetMapping("/seat-manage")
    public String showSeatManage(@RequestParam(value = "roomId", required = false) Long roomId,
            @RequestParam(value = "showtimeId", required = false) Long showtimeId,
            Model model) {
        // 1. Lấy danh sách tất cả các phòng chiếu
        List<Room> rooms = entityManager.createQuery("SELECT r FROM Room r", Room.class).getResultList();
        model.addAttribute("rooms", rooms);

        if (roomId != null) {
            Room selectedRoom = entityManager.find(Room.class, roomId);
            if (selectedRoom != null) {
                // 2. Lấy danh sách ghế của phòng này
                List<Seat> seats = seatService.getSeatsByRoom(roomId);
                model.addAttribute("selectedRoom", selectedRoom);
                model.addAttribute("seats", seats);
                model.addAttribute("currentSeatCount", seats.size());

                // 3. (MỚI) Lấy danh sách Suất chiếu của phòng này để đưa vào bộ lọc
                List<Showtime> showtimes = entityManager.createQuery(
                        "SELECT s FROM Showtime s WHERE s.room.id = :roomId ORDER BY s.showDate DESC, s.startTime DESC", Showtime.class)
                        .setParameter("roomId", roomId)
                        .getResultList();
                model.addAttribute("showtimes", showtimes);

                // 4. (MỚI) Nếu Admin chọn xem 1 Suất chiếu cụ thể -> Query vé để tính trạng thái ghế
                if (showtimeId != null) {
                    model.addAttribute("selectedShowtimeId", showtimeId);

                    // Lấy toàn bộ Vé (Tickets) thuộc suất chiếu này
                    List<Ticket> tickets = entityManager.createQuery(
                            "SELECT t FROM Ticket t WHERE t.showtime.id = :showtimeId", Ticket.class)
                            .setParameter("showtimeId", showtimeId)
                            .getResultList();

                    // Sử dụng HashMap: Key = ID Ghế (Long), Value = Trạng thái (String)
                    java.util.Map<Long, String> seatStatusMap = new java.util.HashMap<>();

                    for (Ticket ticket : tickets) {
                        String status = "FAILED";
                        if (ticket.getPayment() != null) {
                            status = ticket.getPayment().getStatus().toUpperCase();
                        }

                        // Chỉ bắt trạng thái SUCCESS (Đã đặt) hoặc PENDING (Đang chờ)
                        if (status.equals("SUCCESS") || status.equals("THÀNH CÔNG")
                                || status.equals("PENDING") || status.equals("CHƯA THANH TOÁN")) {

                            String standardStatus = (status.equals("SUCCESS") || status.equals("THÀNH CÔNG")) ? "SUCCESS" : "PENDING";

                            for (Seat seat : ticket.getSeats()) {
                                // Tránh ghi đè PENDING lên SUCCESS nếu bị trùng logic
                                if (!"SUCCESS".equals(seatStatusMap.get(seat.getId()))) {
                                    seatStatusMap.put(seat.getId(), standardStatus);
                                }
                            }
                        }
                    }
                    // Đẩy bản đồ trạng thái này xuống JSP
                    model.addAttribute("seatStatusMap", seatStatusMap);
                }
            }
        }

        model.addAttribute("pageTitle", "Cấu Hình Sơ Đồ Ghế Ngồi - Admin");
        model.addAttribute("viewFile", "admin/seat-manage");
        return "layout/admin-layout";
    }

    @PostMapping("/seat/generate")
    public String handleGenerateSeats(
            @RequestParam("roomId") Long roomId,
            @RequestParam("rows") int rows,
            @RequestParam("cols") int cols,
            RedirectAttributes redirectAttributes) {

        String resultMessage = seatService.generateSeatsForRoom(roomId, rows, cols);
        if (resultMessage.startsWith("Thành công")) {
            redirectAttributes.addFlashAttribute("successMsg", resultMessage);
        } else {
            redirectAttributes.addFlashAttribute("errorMsg", resultMessage);
        }
        return "redirect:/admin/seat-manage?roomId=" + roomId;
    }

    @GetMapping("/seat/clear")
    public String handleClearSeats(
            @RequestParam("roomId") Long roomId,
            RedirectAttributes redirectAttributes) {

        String resultMessage = seatService.clearAllSeatsInRoom(roomId);
        if (resultMessage.startsWith("Thành công")) {
            redirectAttributes.addFlashAttribute("successMsg", resultMessage);
        } else {
            redirectAttributes.addFlashAttribute("errorMsg", resultMessage);
        }
        return "redirect:/admin/seat-manage?roomId=" + roomId;
    }

    // ==============================================================================
    // 8. QUẢN LÝ THANH TOÁN & HÓA ĐƠN GIAO DỊCH
    // ==============================================================================
    @GetMapping("/payment-manage")
    public String showPaymentManage(Model model) {
        List<Payment> payments = paymentService.getAllPayments();

        // Tính toán các chỉ số thống kê nhanh cho Admin Dashboard Widget
        double totalRevenue = payments.stream()
                .filter(p -> "SUCCESS".equalsIgnoreCase(p.getStatus()))
                .mapToDouble(Payment::getAmount)
                .sum();

        long successCount = payments.stream().filter(p -> "SUCCESS".equalsIgnoreCase(p.getStatus())).count();
        long pendingCount = payments.stream().filter(p -> "PENDING".equalsIgnoreCase(p.getStatus())).count();

        model.addAttribute("payments", payments);
        model.addAttribute("totalRevenue", totalRevenue);
        model.addAttribute("successCount", successCount);
        model.addAttribute("pendingCount", pendingCount);

        model.addAttribute("pageTitle", "Lịch Sử Giao Dịch Hóa Đơn - Admin");
        model.addAttribute("viewFile", "admin/payment-manage");
        return "layout/admin-layout";
    }

    // Hàm 2: BỔ SUNG CHỨC NĂNG CẬP NHẬT TRẠNG THÁI THANH TOÁN (Giải quyết lỗi 404)
    @PostMapping("/payment-manage/update-status")
    public String updatePaymentStatus(@RequestParam("paymentId") Long paymentId,
            @RequestParam("status") String status,
            RedirectAttributes redirectAttributes) {
        try {
            // Gọi service xử lý cập nhật trạng thái hóa đơn và vé liên quan
            paymentService.updateStatus(paymentId, status);

            // Định dạng chuỗi thông báo tiếng Việt hiển thị ra giao diện cho đẹp
            String statusVN = status.equalsIgnoreCase("SUCCESS") ? "Thành công"
                    : status.equalsIgnoreCase("PENDING") ? "Chờ thanh toán" : "Thất bại/Hủy";

            redirectAttributes.addFlashAttribute("successMsg", "Cập nhật trạng thái giao dịch #" + paymentId + " sang [" + statusVN + "] thành công!");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("errorMsg", "Lỗi khi cập nhật trạng thái: " + e.getMessage());
        }

        // Quay trở lại trang quản lý thanh toán sau khi xử lý xong
        return "redirect:/admin/payment-manage";
    }

    // ==============================================================================
    // 9. CẤU HÌNH HỆ THỐNG CHUNG
    // ==============================================================================
    @GetMapping("/system-manage")
    public String showSystemManage(Model model) {
        model.addAttribute("pageTitle", "Cấu Hình Hệ Thống - Admin");
        model.addAttribute("viewFile", "admin/system-manage");
        return "layout/admin-layout";
    }
}
