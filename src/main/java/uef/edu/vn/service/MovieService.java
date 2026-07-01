/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package uef.edu.vn.service;

import java.time.LocalDate;
import java.time.ZoneId;
import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import uef.edu.vn.model.Movie;
import uef.edu.vn.repository.MovieRepository;

@Service
@Transactional
public class MovieService {

    @Autowired
    private MovieRepository movieRepository;

    public List<Movie> getAllMovies() {
        return movieRepository.findAll(); // Bây giờ Repo đã có hàm này, không lo bị lỗi nữa
    }

    public Movie getMovieById(Long id) {
        return movieRepository.findById(id);
    }

    // =========================================================
    // HÀM TIỆN ÍCH: TỰ ĐỘNG CẬP NHẬT TRẠNG THÁI THEO GIỜ VN
    // =========================================================
    private void applyAutoStatus(Movie movie) {
        if ("Ngưng chiếu".equals(movie.getStatus())) {
            return;
        }

        if (movie.getReleaseDate() != null) {
            LocalDate todayInVietnam = LocalDate.now(ZoneId.of("Asia/Ho_Chi_Minh"));

            if (movie.getReleaseDate().isAfter(todayInVietnam)) {
                movie.setStatus("Sắp chiếu");
            } else {
                movie.setStatus("Đang chiếu");
            }
        }
    }

    public void createMovie(Movie movie) {
        applyAutoStatus(movie); // Cập nhật trạng thái tự động trước khi thêm mới
        movieRepository.save(movie);
    }

    public void updateMovie(Movie movie) {
        applyAutoStatus(movie); // Cập nhật trạng thái tự động trước khi lưu chỉnh sửa
        movieRepository.update(movie);
    }

    public void deleteMovie(Long id) {
        movieRepository.delete(id);
    }

    // =========================================================================
    // BỔ SUNG HOÀN THIỆN: Làm cầu nối trung chuyển tham số bộ lọc từ AdminController xuống Repo
    // =========================================================================
    public List<Movie> getMoviesWithFilter(String search, String statusFilter, String sortBy) {
        return movieRepository.findMoviesWithFilter(search, statusFilter, sortBy);
    }
}