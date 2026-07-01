/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package uef.edu.vn.repository;

import uef.edu.vn.model.Showtime;
import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;
import jakarta.persistence.TypedQuery;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;
import java.time.LocalDate;
import java.time.LocalTime;
import java.util.List;

@Repository
@Transactional
public class ShowtimeRepository {

    @PersistenceContext
    private EntityManager entityManager;

    // 1. Lấy toàn bộ danh sách suất chiếu (Sắp xếp ngày giờ mới nhất lên đầu)
    public List<Showtime> findAll() {
        String hql = "SELECT s FROM Showtime s ORDER BY s.showDate DESC, s.startTime DESC";
        return entityManager.createQuery(hql, Showtime.class).getResultList();
    }

    // 2. Tự động Thêm mới hoặc Cập nhật
    public void save(Showtime showtime) {
        if (showtime.getId() == null) {
            entityManager.persist(showtime); // Thêm mới
        } else {
            entityManager.merge(showtime);   // Cập nhật (Sửa)
        }
    }

    // 3. Tìm suất chiếu theo ID
    public Showtime findById(Long id) {
        return entityManager.find(Showtime.class, id);
    }

    // 4. Lấy danh sách suất chiếu của một bộ phim
    public List<Showtime> findByMovieId(Long movieId) {
        String jpql = "SELECT s FROM Showtime s WHERE s.movie.id = :movieId";
        TypedQuery<Showtime> query = entityManager.createQuery(jpql, Showtime.class);
        query.setParameter("movieId", movieId);
        return query.getResultList();
    }

    // 5. Xóa suất chiếu theo ID
    public void delete(Long id) {
        Showtime showtime = findById(id);
        if (showtime != null) {
            entityManager.remove(showtime);
        }
    }

    // ==================== HÀM MỚI BỔ SUNG ====================
    // 6. Kiểm tra trùng lịch chiếu trong cùng một phòng máy
    // Thuật toán: Nếu (Giờ_Bắt_Đầu_Mới < Giờ_Kết_Thúc_Cũ) VÀ (Giờ_Kết_Thúc_Mới > Giờ_Bắt_Đầu_Cũ) -> Bị Trùng Lịch
    public List<Showtime> findConflictingShowtimes(Long roomId, LocalDate showDate, LocalTime startTime, LocalTime endTime, Long excludeId) {
        String jpql = "SELECT s FROM Showtime s WHERE s.room.id = :roomId "
                    + "AND s.showDate = :showDate "
                    + "AND s.startTime < :endTime "
                    + "AND s.endTime > :startTime";
        
        // Nếu là hành động "Sửa", loại trừ chính suất chiếu đang sửa ra để không tự check trùng với chính nó
        if (excludeId != null) {
            jpql += " AND s.id != :excludeId";
        }

        TypedQuery<Showtime> query = entityManager.createQuery(jpql, Showtime.class);
        query.setParameter("roomId", roomId);
        query.setParameter("showDate", showDate);
        query.setParameter("startTime", startTime);
        query.setParameter("endTime", endTime);
        
        if (excludeId != null) {
            query.setParameter("excludeId", excludeId);
        }

        return query.getResultList();
    }
    // ==============================================================================
    // 7. TÌM KIẾM, LỌC VÀ SẮP XẾP SUẤT CHIẾU ĐỘNG (DÙNG CHO BỘ LỌC ADMIN)
    // ==============================================================================
    public List<Showtime> findShowtimesWithFilter(String search, Long roomId, String dateFilter, String sortBy) {
        StringBuilder jpql = new StringBuilder("SELECT s FROM Showtime s WHERE 1=1");

        // 1. Tìm theo tên bộ phim
        if (search != null && !search.trim().isEmpty()) {
            jpql.append(" AND LOWER(s.movie.name) LIKE :search");
        }

        // 2. Lọc theo phòng chiếu
        if (roomId != null) {
            jpql.append(" AND s.room.id = :roomId");
        }

        // 3. Lọc theo trạng thái thời gian chiếu
        if (dateFilter != null && !dateFilter.trim().isEmpty()) {
            switch (dateFilter) {
                case "today":
                    jpql.append(" AND s.showDate = CURRENT_DATE");
                    break;
                case "future":
                    jpql.append(" AND s.showDate > CURRENT_DATE");
                    break;
                case "past":
                    jpql.append(" AND s.showDate < CURRENT_DATE");
                    break;
            }
        }

        // 4. Sắp xếp dữ liệu (Mặc định là mới nhất xếp lên đầu)
        if (sortBy != null && !sortBy.trim().isEmpty()) {
            if ("date_asc".equals(sortBy)) {
                jpql.append(" ORDER BY s.showDate ASC, s.startTime ASC");
            } else if ("date_desc".equals(sortBy)) {
                jpql.append(" ORDER BY s.showDate DESC, s.startTime DESC");
            }
        } else {
            jpql.append(" ORDER BY s.showDate DESC, s.startTime DESC");
        }

        TypedQuery<Showtime> query = entityManager.createQuery(jpql.toString(), Showtime.class);

        // 5. Gán tham số an toàn (Chống SQL Injection)
        if (search != null && !search.trim().isEmpty()) {
            query.setParameter("search", "%" + search.trim().toLowerCase() + "%");
        }
        if (roomId != null) {
            query.setParameter("roomId", roomId);
        }

        return query.getResultList();
    }
}