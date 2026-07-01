/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package uef.edu.vn.repository;

import uef.edu.vn.model.Movie;
import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;
import jakarta.persistence.TypedQuery;
import java.util.List;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

@Repository
@Transactional // Đảm bảo mọi thao tác ghi dữ liệu đều nằm trong một transaction
public class MovieRepository {

    @PersistenceContext
    private EntityManager entityManager;

    // Lưu Movie mới
    public void save(Movie movie) {
        entityManager.persist(movie);
    }

    // Tìm kiếm bằng ID
    public Movie findById(Long id) {
        return entityManager.find(Movie.class, id);
    }

    // Cập nhật thông tin phim
    public void update(Movie movie) {
        entityManager.merge(movie);
    }

    // Xóa phim
    public void delete(Long id) {
        Movie movie = findById(id);
        if (movie != null) {
            entityManager.remove(movie);
        }
    }

    // Tìm theo tên (Dùng cho các logic kiểm tra trùng lặp nếu cần)
    public Movie findByName(String name) {
        String jpql = "SELECT m FROM Movie m WHERE m.name = :name";
        TypedQuery<Movie> query = entityManager.createQuery(jpql, Movie.class);
        query.setParameter("name", name);
        try {
            return query.getSingleResult();
        } catch (Exception e) {
            return null;
        }
    }

    // =========================================================================
    // BỔ SUNG: Hàm lấy toàn bộ phim (Để phục vụ cho hàm getAllMovies() bên Service)
    // =========================================================================
    public List<Movie> findAll() {
        String jpql = "SELECT m FROM Movie m ORDER BY m.id DESC";
        return entityManager.createQuery(jpql, Movie.class).getResultList();
    }

    // =========================================================================
    // HÀM TÌM KIẾM - LỌC - SẮP XẾP ĐỘNG (BẠN ĐÃ VIẾT RẤT TỐT, GIỮ NGUYÊN)
    // =========================================================================
    public List<Movie> findMoviesWithFilter(String search, String statusFilter, String sortBy) {
        StringBuilder jpql = new StringBuilder("SELECT m FROM Movie m WHERE 1=1");

        // Lọc theo từ khóa tìm kiếm (Tên phim hoặc thể loại)
        if (search != null && !search.trim().isEmpty()) {
            jpql.append(" AND (LOWER(m.name) LIKE :search OR LOWER(m.genre) LIKE :search)");
        }

        // Lọc theo trạng thái phim
        if (statusFilter != null && !statusFilter.trim().isEmpty()) {
            jpql.append(" AND m.status = :statusFilter");
        }

        // Sắp xếp dữ liệu linh hoạt
        if (sortBy != null && !sortBy.trim().isEmpty()) {
            switch (sortBy) {
                case "name_asc":
                    jpql.append(" ORDER BY m.name ASC");
                    break;
                case "name_desc":
                    jpql.append(" ORDER BY m.name DESC");
                    break;
                case "price_asc":
                    jpql.append(" ORDER BY m.price ASC");
                    break;
                case "price_desc":
                    jpql.append(" ORDER BY m.price DESC");
                    break;
                case "date_desc":
                    jpql.append(" ORDER BY m.releaseDate DESC");
                    break;
                default:
                    jpql.append(" ORDER BY m.id DESC");
                    break;
            }
        } else {
            jpql.append(" ORDER BY m.id DESC");
        }

        TypedQuery<Movie> query = entityManager.createQuery(jpql.toString(), Movie.class);

        if (search != null && !search.trim().isEmpty()) {
            query.setParameter("search", "%" + search.trim().toLowerCase() + "%");
        }
        if (statusFilter != null && !statusFilter.trim().isEmpty()) {
            query.setParameter("statusFilter", statusFilter);
        }

        return query.getResultList();
    }

    // 7. Đếm số Phim Đang Chiếu
    public Long countShowingMovies() {
        try {
            return entityManager.createQuery(
                    "SELECT COUNT(m) FROM Movie m WHERE m.status = 'Đang chiếu'", Long.class)
                    .getSingleResult();
        } catch (Exception e) {
            return 0L;
        }
    }

    // 8. Top 5 Phim Bán Chạy Nhất (Dựa vào tổng tiền vé bán được)
    // Trả về dạng mảng Object: [Tên phim, Tổng doanh thu]
    public List<Object[]> getTop5MoviesByRevenue() {
        return entityManager.createQuery(
                "SELECT t.movie.name, SUM(t.totalPrice) "
                + "FROM Ticket t "
                + "WHERE t.status = 'PAID' OR t.status = 'SUCCESS' "
                + "GROUP BY t.movie.name "
                + "ORDER BY SUM(t.totalPrice) DESC", Object[].class)
                .setMaxResults(5)
                .getResultList();
    }
}
