/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package uef.edu.vn.controller;
import uef.edu.vn.model.User;
import jakarta.servlet.http.HttpSession;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.beans.factory.annotation.Autowired;
import uef.edu.vn.model.Movie;
import uef.edu.vn.repository.MovieRepository;


@Controller
public class HomeController {
    @Autowired
    private MovieRepository movieRepository;

    @GetMapping("/")
    public String home(HttpSession session, Model model) {
        User u = (User) session.getAttribute("user");
        model.addAttribute("user", u);
        
        // 1. CHÈN TIÊU ĐỀ CHO TRANG CHỦ
        model.addAttribute("pageTitle", "Trang Chủ - AlphaCinema");
        
        
        List<Movie> movies = movieRepository.findAll();
        model.addAttribute("movies", movies);
        
        model.addAttribute("viewFile", "index"); 
        return "layout/main";
    }

    @GetMapping("/about")
    public String aboutPage(Model model) {
       // 1. CHÈN TIÊU ĐỀ CHO TRANG VỀ CHÚNG TÔI
        model.addAttribute("pageTitle", "Về Chúng Tôi - AlphaCinema");
        
        // 2. KHAI BÁO FILE RUỘT VÀ GỌI LAYOUT CHÍNH
        model.addAttribute("viewFile", "about"); 
        return "layout/main";
    }
    
      @GetMapping("/uudai")
    public String uudai(HttpSession session, Model model) {
        User user = (User) session.getAttribute("user");
        model.addAttribute("user", user);
        model.addAttribute("pageTitle", "Ưu Đãi - AlphaCinema");
        model.addAttribute("viewFile", "uudai"); 
        return "layout/main";
    }
    @GetMapping("/movie")
    public String phim(HttpSession session, Model model) {
        List<Movie> movies = movieRepository.findAll();
        Map<String, List<Movie>> moviesByGenre = movies.stream().collect(Collectors.groupingBy(Movie::getGenre));
        model.addAttribute("moviesByGenre", moviesByGenre);
        User user = (User) session.getAttribute("user");
        model.addAttribute("user", user);
        model.addAttribute("pageTitle", "Chi tiết phim - AlphaCinema");
        model.addAttribute("viewFile", "movie"); 
        return "layout/main";
    }
    
}

