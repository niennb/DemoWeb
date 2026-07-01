/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package uef.edu.vn.repository;

import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;
import java.util.List;
import org.springframework.stereotype.Repository;
import uef.edu.vn.model.Room;

@Repository
public class RoomRepository {

    @PersistenceContext
    private EntityManager entityManager;

    // Lấy toàn bộ danh sách phòng chiếu
    public List<Room> findAll() {
        return entityManager.createQuery("SELECT r FROM Room r", Room.class).getResultList();
    }

    // Tìm kiếm phòng theo ID
    public Room findById(Long id) {
        return entityManager.find(Room.class, id);
    }

    // Thêm mới phòng chiếu
    public void save(Room room) {
        entityManager.persist(room);
    }

    // Cập nhật thông tin phòng chiếu
    public void update(Room room) {
        entityManager.merge(room);
    }

    // Xóa phòng chiếu theo ID
    public void delete(Long id) {
        Room room = findById(id);
        if (room != null) {
            entityManager.remove(room);
        }
    }
}
