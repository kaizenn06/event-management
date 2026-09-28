package com.manage.controller;

import com.manage.entity.Event;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

@RestController
public class EventController {
    static final String DB_URL = "jdbc:mysql://localhost:3306/event_tickets";
    static final String USER = "root";
    static final String PASS = "123456";
    @GetMapping("/api/event/")
    public List<Event> getEvent() {
        String sql = "SELECT * FROM EVENT";
        List<Event> result = new ArrayList<>();
        try (Connection connection = DriverManager.getConnection(DB_URL, USER, PASS);
             Statement statement = connection.createStatement();
             ResultSet resultSet = statement.executeQuery(sql);) {
            while (resultSet.next()) {
                Event event = new Event();
                event.setEvent_id(resultSet.getString("event_id"));
                event.setOrganizer_id(resultSet.getString("organizer_id"));
                event.setTitle(resultSet.getString("title"));
                event.setImage(resultSet.getString("image"));
                event.setDesc(resultSet.getString("desc"));
                event.setCreate_type(resultSet.getString("create_type"));
                result.add(event);
            }
        }
        catch(SQLException e) {
            e.printStackTrace();
        }
        return result;
    }
}
