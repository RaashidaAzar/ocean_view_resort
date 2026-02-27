package com.oceanview.servlet;

import com.google.gson.Gson;
import com.oceanview.model.RoomPrice;
import com.oceanview.util.DBConnection;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.math.BigDecimal;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

@WebServlet("/roomPrice")
public class RoomPriceServlet extends HttpServlet {
    
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String action = request.getParameter("action");
        
        if ("getAll".equals(action)) {
            getAllRoomPrices(response);
        } else if ("getPrice".equals(action)) {
            getRoomPrice(request, response);
        }
    }
    
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String action = request.getParameter("action");
        
        if ("update".equals(action)) {
            updateRoomPrice(request, response);
        }
    }
    
    private void getAllRoomPrices(HttpServletResponse response) throws IOException {
        List<RoomPrice> prices = new ArrayList<>();
        try (Connection conn = DBConnection.getConnection()) {
            String sql = "SELECT * FROM room_prices ORDER BY room_category, room_type, meal_plan";
            Statement stmt = conn.createStatement();
            ResultSet rs = stmt.executeQuery(sql);
            
            while (rs.next()) {
                RoomPrice rp = new RoomPrice();
                rp.setId(rs.getInt("id"));
                rp.setRoomCategory(rs.getString("room_category"));
                rp.setRoomType(rs.getString("room_type"));
                rp.setMealPlan(rs.getString("meal_plan"));
                rp.setPricePerNight(rs.getBigDecimal("price_per_night"));
                prices.add(rp);
            }
            
            response.setContentType("application/json");
            response.getWriter().write(new Gson().toJson(prices));
        } catch (SQLException e) {
            e.printStackTrace();
            response.getWriter().write("{\"error\": \"" + e.getMessage() + "\"}");
        }
    }
    
    private void getRoomPrice(HttpServletRequest request, HttpServletResponse response) 
            throws IOException {
        String roomCategory = request.getParameter("roomCategory");
        String roomType = request.getParameter("roomType");
        String mealPlan = request.getParameter("mealPlan");
        
        try (Connection conn = DBConnection.getConnection()) {
            String sql = "SELECT price_per_night FROM room_prices WHERE room_category=? AND room_type=? AND meal_plan=?";
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setString(1, roomCategory);
            stmt.setString(2, roomType);
            stmt.setString(3, mealPlan);
            ResultSet rs = stmt.executeQuery();
            
            if (rs.next()) {
                response.setContentType("application/json");
                response.getWriter().write("{\"price\": " + rs.getBigDecimal("price_per_night") + "}");
            } else {
                response.getWriter().write("{\"price\": 0}");
            }
        } catch (SQLException e) {
            e.printStackTrace();
            response.getWriter().write("{\"error\": \"" + e.getMessage() + "\"}");
        }
    }
    
    private void updateRoomPrice(HttpServletRequest request, HttpServletResponse response) 
            throws IOException {
        try (Connection conn = DBConnection.getConnection()) {
            String sql = "UPDATE room_prices SET price_per_night=? WHERE id=?";
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setBigDecimal(1, new BigDecimal(request.getParameter("price")));
            stmt.setInt(2, Integer.parseInt(request.getParameter("id")));
            stmt.executeUpdate();
            
            response.getWriter().write("{\"success\": true, \"message\": \"Price updated successfully\"}");
        } catch (SQLException e) {
            e.printStackTrace();
            response.getWriter().write("{\"success\": false, \"message\": \"" + e.getMessage() + "\"}");
        }
    }
}
