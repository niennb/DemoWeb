/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package uef.edu.vn.repository;

import uef.edu.vn.model.User;
import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;
import jakarta.persistence.TypedQuery;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

@Repository
@Transactional
public class UserRepository {

    @PersistenceContext
    private EntityManager entityManager;

    // Tìm User theo Username
    public User findByUsername(String username) {
        String jpql = "SELECT u FROM User u WHERE u.username = :username";
        TypedQuery<User> query = entityManager.createQuery(jpql, User.class);
        query.setParameter("username", username);
        try {
            return query.getSingleResult();
        } catch (Exception e) {
            return null; // Không tìm thấy user
        }
    }

    // Tìm User theo Email
    public User findByEmail(String email) {
        String jpql = "SELECT u FROM User u WHERE u.email = :email";
        TypedQuery<User> query = entityManager.createQuery(jpql, User.class);
        query.setParameter("email", email);
        try {
            return query.getSingleResult();
        } catch (Exception e) {
            return null; // Không tìm thấy user
        }
    }

    // Lưu User mới (Đăng ký)
    @Transactional
    public void save(User user) {
        entityManager.persist(user);
    }

    // 1. Lấy toàn bộ danh sách tài khoản cho Admin
    public java.util.List<User> findAll() {
        String jpql = "SELECT u FROM User u";
        TypedQuery<User> query = entityManager.createQuery(jpql, User.class);
        return query.getResultList();
    }

    // 2. Tìm User theo ID (Dùng để lấy thực thể lên trước khi Khóa hoặc Reset Pass)
    public User findById(long id) {
        return entityManager.find(User.class, id);
    }

    // 3. Cập nhật thông tin User (Đồng bộ thay đổi xuống DB)
    @Transactional
    public void update(User user) {
        entityManager.merge(user);
    }

    // 6. Đếm số lượng Khách hàng (Thành viên)
    public Long countTotalCustomers() {
        try {
            return entityManager.createQuery(
                    "SELECT COUNT(u) FROM User u WHERE u.role = 'USER'", Long.class)
                    .getSingleResult();
        } catch (Exception e) {
            return 0L;
        }
    }
}
