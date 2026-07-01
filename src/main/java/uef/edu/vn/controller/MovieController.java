/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package uef.edu.vn.controller;

import uef.edu.vn.model.Movie;
import uef.edu.vn.model.Showtime;
import uef.edu.vn.model.User;
import uef.edu.vn.model.Seat;
import uef.edu.vn.model.Ticket;
import uef.edu.vn.model.Payment;
import uef.edu.vn.repository.MovieRepository;
import uef.edu.vn.repository.ShowtimeRepository;
import uef.edu.vn.repository.TicketRepository;
import uef.edu.vn.repository.SeatRepository;
import uef.edu.vn.repository.UserRepository;
import uef.edu.vn.repository.PaymentRepository;

import org.springframework.web.bind.annotation.*;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import uef.edu.vn.model.HistoryItem;

import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;
import java.util.HashMap;
import java.util.Map;
import org.springframework.transaction.annotation.Transactional;

@Controller
public class MovieController {

    @Autowired
    private MovieRepository movieRepository;

    @Autowired
    private ShowtimeRepository showtimeRepository;

    @Autowired
    private TicketRepository ticketRepository;

    @Autowired
    private SeatRepository seatRepository;

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private PaymentRepository paymentRepository;

    @PersistenceContext
    private EntityManager entityManager;

    // 1. XEM CHI TIẾT PHIM
    @GetMapping("/movie/{id}")
    public String showMovieDetails(@PathVariable Long id, Model model, HttpSession session) {
        User user = (User) session.getAttribute("user");

        if (user == null) {
            return "redirect:/login";
        }

        // ĐÃ SỬA: Dùng Repository của bạn (không có .orElse(null))
        Movie m = movieRepository.findById(id);
        if (m == null) {
            return "redirect:/";
        }

        model.addAttribute("movie", m);
        model.addAttribute("user", user);

        // ĐÃ THÊM: Cấu hình đưa vào layout/main của bạn
        model.addAttribute("pageTitle", m.getName() + " - AlphaCinema");
        model.addAttribute("viewFile", "movie-detail"); // Tên file khúc ruột movie-detail.jsp

        return "layout/main";
    }

    // 2. TRANG CHỌN GHẾ ĐẶT VÉ
// ==========================================
    // BƯỚC 1: CHỌN SUẤT CHIẾU CỦA PHIM
    // ==========================================
    @GetMapping("/booking/{movieId}")
    public String showShowtimesPage(@PathVariable("movieId") Long movieId, Model model, HttpSession session) {
        User user = (User) session.getAttribute("user");
        if (user == null) {
            return "redirect:/login";
        }

        Movie movie = movieRepository.findById(movieId);
        if (movie == null) {
            return "redirect:/";
        }

        List<Showtime> allShowtimes = showtimeRepository.findByMovieId(movieId);
        List<Showtime> futureShowtimes = new ArrayList<>();
        java.time.LocalDate today = java.time.LocalDate.now();

        for (Showtime st : allShowtimes) {
            try {
                java.time.LocalDate showDate = java.time.LocalDate.parse(st.getShowDate().toString());
                if (!showDate.isBefore(today)) {
                    futureShowtimes.add(st);
                }
            } catch (Exception e) {
                futureShowtimes.add(st);
            }
        }

        model.addAttribute("showtimes", futureShowtimes);
        model.addAttribute("movie", movie);
        model.addAttribute("pageTitle", "Chọn Suất Chiếu: " + movie.getName());

        // ĐỔI TÊN VIEW: File JSP này chỉ dùng để hiển thị nút chọn Giờ / Ngày
        model.addAttribute("viewFile", "select-showtime");
        return "layout/main";
    }

    // ==========================================
    // BƯỚC 2: HIỂN THỊ SƠ ĐỒ GHẾ ĐỂ CHỌN
    // ==========================================
    @GetMapping("/booking/seat") // Đổi URL cho tách biệt hoàn toàn với hàm trên
    public String showSeatPage(@RequestParam("showtimeId") Long showtimeId, Model model, HttpSession session) {
        User user = (User) session.getAttribute("user");
        if (user == null) {
            return "redirect:/login";
        }

        Showtime showtime = entityManager.find(Showtime.class, showtimeId);
        if (showtime == null) {
            return "redirect:/";
        }

        List<String> allSeats = entityManager.createNativeQuery(
                "SELECT s.seat_name FROM seats s WHERE s.room_id = :roomId ORDER BY s.seat_name ASC")
                .setParameter("roomId", showtime.getRoom().getId())
                .getResultList();

        List<String> bookedSeats = entityManager.createNativeQuery(
                "SELECT s.seat_name FROM ticket_seats ts "
                + "INNER JOIN seats s ON ts.seat_id = s.id "
                + "INNER JOIN tickets t ON ts.ticket_id = t.id "
                + "WHERE t.showtime_id = :showtimeId AND (t.status = 'SUCCESS' OR t.status = 'PAID')")
                .setParameter("showtimeId", showtimeId)
                .getResultList();

        List<String> pendingSeats = entityManager.createNativeQuery(
                "SELECT s.seat_name FROM ticket_seats ts "
                + "INNER JOIN seats s ON ts.seat_id = s.id "
                + "INNER JOIN tickets t ON ts.ticket_id = t.id "
                + "WHERE t.showtime_id = :showtimeId AND t.status = 'PENDING'")
                .setParameter("showtimeId", showtimeId)
                .getResultList();

        model.addAttribute("movie", showtime.getMovie());
        model.addAttribute("showtime", showtime);
        model.addAttribute("allSeats", allSeats);
        model.addAttribute("bookedSeats", bookedSeats);
        model.addAttribute("pendingSeats", pendingSeats);

        model.addAttribute("pageTitle", "Đặt Ghế: " + showtime.getMovie().getName());

        // GIỮ NGUYÊN VIEW NÀY: Dành riêng cho file booking.jsp (Sơ đồ ghế)
        model.addAttribute("viewFile", "booking");
        return "layout/main";
    }

    // ==========================================
    // BƯỚC 3: XỬ LÝ XÁC NHẬN ĐẶT VÉ
    // ==========================================
    @PostMapping("/booking/confirm")
    public String confirmBooking(
            @RequestParam("showtimeId") Long showtimeId,
            @RequestParam("selectedSeats") String selectedSeats,
            HttpSession session, Model model) {

        User user = (User) session.getAttribute("user");
        if (user == null) {
            return "redirect:/login";
        }

        Showtime showtime = showtimeRepository.findById(showtimeId);
        if (showtime == null || selectedSeats == null || selectedSeats.trim().isEmpty()) {
            return "redirect:/";
        }

        List<Ticket> allTickets = ticketRepository.findAll();
        List<String> requestedSeatsNames = Arrays.asList(selectedSeats.split(","));

        // Kiểm tra trùng ghế
        for (Ticket t : allTickets) {
            if (t.getShowtime().getId().equals(showtimeId)
                    && (t.getStatus().equalsIgnoreCase("SUCCESS") || t.getStatus().equalsIgnoreCase("PAID"))) {
                if (t.getSeats() != null) {
                    for (Seat bookedSeat : t.getSeats()) {
                        if (requestedSeatsNames.contains(bookedSeat.getSeatName().trim())) {
                            model.addAttribute("error", "Rất tiếc, ghế " + bookedSeat.getSeatName() + " đã có người đặt trước đó vài giây. Vui lòng chọn lại!");
                            // LƯU Ý SỬA Ở ĐÂY: Trả về đúng link của Bước 2
                            return "redirect:/booking/seat?showtimeId=" + showtimeId;
                        }
                    }
                }
            }
        }

        // Tạo vé và lưu DB
        Long roomId = showtime.getRoom().getId();
        List<Seat> roomSeats = seatRepository.findByRoomId(roomId);
        List<Seat> seatsToSave = new ArrayList<>();

        // =========================================================================
        // ĐÃ SỬA LỖI TRÙNG GHẾ Ở ĐÂY: Đảo vòng lặp và thêm lệnh 'break'
        // =========================================================================
        for (String reqName : requestedSeatsNames) {
            String cleanReqName = reqName.trim();
            if (cleanReqName.isEmpty()) {
                continue;
            }

            for (Seat s : roomSeats) {
                // Khi tìm thấy ghế khớp với tên khách đã chọn
                if (s.getSeatName().trim().equalsIgnoreCase(cleanReqName)) {
                    seatsToSave.add(s);
                    break; // LẬP TỨC THOÁT VÒNG LẶP CON: Chặn đứng việc lưu trùng ghế thứ 2, 3, 4
                }
            }
        }
        // =========================================================================

        int seatCount = seatsToSave.size();
        Double totalPrice = showtime.getMovie().getPrice() * seatCount;

        Ticket ticket = new Ticket();
        ticket.setUser(user);
        ticket.setMovie(showtime.getMovie());
        ticket.setShowtime(showtime);
        ticket.setBookingTime(java.time.LocalDateTime.now());
        ticket.setTotalPrice(totalPrice);
        ticket.setSeats(seatsToSave);
        ticket.setStatus("PENDING");

        Payment payment = new Payment();
        payment.setTicket(ticket);
        payment.setAmount(totalPrice);
        payment.setPaymentMethod("Chưa chọn");
        payment.setStatus("PENDING");

        ticket.setPayment(payment);
        ticketRepository.save(ticket);

        return "redirect:/payment?ticketId=" + ticket.getId();
    }

    // 4. ĐỔI MẬT KHẨU
    @GetMapping("/change-password")
    public String changePasswordPage(HttpSession session, Model model) {

        User user = (User) session.getAttribute("user");

        if (user == null) {
            return "redirect:/login"; // Chưa đăng nhập thì chuyển hướng, giữ nguyên
        }

        model.addAttribute("user", user);

        // ĐÃ THÊM: Tích hợp vào layout/main của bạn
        model.addAttribute("pageTitle", "Đổi Mật Khẩu - AlphaCinema");
        model.addAttribute("viewFile", "change-password");

        return "layout/main"; // Trả về layout tổng
    }

    @PostMapping("/change-password")
    public String changePassword(
            @RequestParam("oldPassword") String oldPassword,
            @RequestParam("newPassword") String newPassword,
            @RequestParam("confirmPassword") String confirmPassword,
            HttpSession session,
            Model model) {

        User user = (User) session.getAttribute("user");
        if (user == null) {
            return "redirect:/login";
        }

        model.addAttribute("pageTitle", "Đổi mật khẩu - AlphaCinema");
        model.addAttribute("viewFile", "change-password");
        model.addAttribute("user", user);

        if (!user.getPassword().equals(oldPassword)) {
            model.addAttribute("error", "Mật khẩu cũ không đúng.");
            return "layout/main";
        }

        if (!newPassword.equals(confirmPassword)) {
            model.addAttribute("error", "Mật khẩu xác nhận không khớp.");
            return "layout/main";
        }

        if (oldPassword.equals(newPassword)) {
            model.addAttribute("error", "Mật khẩu mới phải khác mật khẩu cũ.");
            return "layout/main";
        }

        user.setPassword(newPassword);
        userRepository.update(user);

        session.setAttribute("user", user);
        model.addAttribute("success", "Đổi mật khẩu thành công!");

        return "layout/main";
    }

    // LỊCH SỬ ĐẶT VÉ
    @GetMapping("/history")
    public String bookingHistory(HttpSession session, Model model) {

        User user = (User) session.getAttribute("user");

        if (user == null) {
            return "redirect:/login";
        }

        // Lấy danh sách vé của User thông qua EntityManager (Sắp xếp vé mới nhất lên đầu)
        List<Ticket> tickets = entityManager.createQuery(
                "SELECT t FROM Ticket t WHERE t.user.id = :userId ORDER BY t.bookingTime DESC", Ticket.class)
                .setParameter("userId", user.getId())
                .getResultList();

        List<HistoryItem> histories = new ArrayList<>();

        for (Ticket ticket : tickets) {
            // Model của bạn lấy trực tiếp Object thay vì dùng ID và Optional như của bạn mình
            Movie movie = ticket.getMovie();
            Showtime showtime = ticket.getShowtime();

            if (movie == null || showtime == null) {
                continue;
            }

            // Dùng Native SQL để lấy danh sách tên ghế thay vì dùng TicketSeatRepository
            String sql = "SELECT s.seat_name FROM ticket_seats ts JOIN seats s ON ts.seat_id = s.id WHERE ts.ticket_id = :ticketId";
            List<String> seatNames = entityManager.createNativeQuery(sql)
                    .setParameter("ticketId", ticket.getId())
                    .getResultList();

            // Ánh xạ dữ liệu sang HistoryItem
            HistoryItem item = new HistoryItem();
            item.setMovieName(movie.getName());
            item.setCategory(movie.getGenre());
            item.setShowDate(showtime.getShowDate().toString());
            item.setStartTime(showtime.getStartTime().toString()); // Sửa getShowTime() thành getStartTime() cho đúng Model của bạn

            // Lấy tên phòng chiếu (Cần kiểm tra null để tránh lỗi)
            item.setRoom(showtime.getRoom() != null ? showtime.getRoom().getRoomName() : "Phòng chiếu");

            item.setSeats(String.join(", ", seatNames));
            item.setSeatCount(seatNames.size());

            // Ưu tiên lấy tổng tiền từ Ticket, nếu không có thì nhân mặc định (Ép kiểu về int tùy theo cấu hình HistoryItem của bạn)
            if (ticket.getTotalPrice() != null) {
                item.setTotalPrice(ticket.getTotalPrice().intValue());
            } else {
                item.setTotalPrice(seatNames.size() * 75000);
            }

            item.setBookingTime(ticket.getBookingTime());

            histories.add(item);
        }

        model.addAttribute("user", user);
        model.addAttribute("histories", histories);

        // ĐÃ SỬA: Chuyển sang cấu hình Layout
        model.addAttribute("pageTitle", "Lịch sử đặt vé - AlphaCinema");
        model.addAttribute("viewFile", "history");

        return "layout/main";
    }

    // THÔNG TIN CÁ NHÂN
    @GetMapping("/profile")
    public String profile(HttpSession session, Model model) {

        User user = (User) session.getAttribute("user");

        if (user == null) {
            return "redirect:/login";
        }

        model.addAttribute("user", user);

        // ĐÃ SỬA: Chuyển sang cấu hình Layout
        model.addAttribute("pageTitle", "Thông tin cá nhân - AlphaCinema");
        model.addAttribute("viewFile", "profile");

        return "layout/main";
    }

    // 1. HÀM HIỂN THỊ TRANG THANH TOÁN
    @GetMapping("/payment")
    public String showPaymentPage(@RequestParam("ticketId") Long ticketId, HttpSession session, Model model) {
        User user = (User) session.getAttribute("user");
        if (user == null) {
            return "redirect:/login";
        }

        // Tìm vé dựa trên ticketId được truyền lên URL từ bước xác nhận đặt vé
        Ticket ticket = ticketRepository.findById(ticketId);

        // Kiểm tra bảo mật: Nếu vé không tồn tại hoặc vé này không phải của User đang đăng nhập thì đuổi về trang chủ
        if (ticket == null || !ticket.getUser().getId().equals(user.getId())) {
            return "redirect:/";
        }

        model.addAttribute("ticket", ticket);
        model.addAttribute("user", user);

        // Gọi Layout chung
        model.addAttribute("pageTitle", "Xác Nhận Thanh Toán - AlphaCinema");
        model.addAttribute("viewFile", "payment"); // Gọi file payment.jsp vừa tạo

        return "layout/main";
    }

    // 2. HÀM XỬ LÝ NÚT THANH TOÁN TỪ GIAO DIỆN CHUYỂN VỀ
    @PostMapping("/payment/process")
    @Transactional
    public String processPayment(
            @RequestParam("ticketId") Long ticketId,
            @RequestParam("paymentMethod") String paymentMethod,
            HttpSession session) {

        User user = (User) session.getAttribute("user");
        if (user == null) {
            return "redirect:/login";
        }

        Ticket ticket = ticketRepository.findById(ticketId);
        if (ticket == null || !ticket.getUser().getId().equals(user.getId())) {
            return "redirect:/";
        }

        // Lấy Payment liên kết với Ticket ra và cập nhật trạng thái
        Payment payment = ticket.getPayment();
        if (payment != null) {
            payment.setPaymentMethod(paymentMethod);
            payment.setStatus("SUCCESS");
        }

        ticket.setStatus("SUCCESS");

        ticketRepository.save(ticket);

        // ĐÃ SỬA: Chuyển hướng sang đường dẫn thông báo thành công thay vì history
        return "redirect:/booking/success";
    }

    // =========================================================
    // THÊM HÀM MỚI NÀY VÀO DƯỚI HÀM PROCESS PAYMENT
    // =========================================================
    // 3. HÀM HIỂN THỊ TRANG THÔNG BÁO THÀNH CÔNG (GET)
    @GetMapping("/booking/success")
    public String showBookingSuccess(HttpSession session, Model model) {
        User user = (User) session.getAttribute("user");
        if (user == null) {
            return "redirect:/login";
        }

        model.addAttribute("user", user);

        // Gọi Layout chung và nhúng file booking-success.jsp vào giữa
        model.addAttribute("pageTitle", "Đặt Vé Thành Công - AlphaCinema");
        model.addAttribute("viewFile", "booking-success");

        return "layout/main";
    }

}
