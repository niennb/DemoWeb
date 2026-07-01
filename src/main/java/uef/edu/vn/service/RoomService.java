/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package uef.edu.vn.service;

import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import uef.edu.vn.model.Room;
import uef.edu.vn.repository.RoomRepository;

@Service
@Transactional
public class RoomService {

    @Autowired
    private RoomRepository roomRepository;

    public List<Room> getAllRooms() {
        return roomRepository.findAll();
    }

    public Room getRoomById(Long id) {
        return roomRepository.findById(id);
    }

    public void createRoom(Room room) {
        roomRepository.save(room);
    }

    public void updateRoom(Room room) {
        roomRepository.update(room);
    }

    public void deleteRoom(Long id) {
        roomRepository.delete(id);
    }
}
