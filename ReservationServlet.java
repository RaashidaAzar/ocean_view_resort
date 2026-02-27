package com.oceanview.servlet;

import com.google.gson.Gson;
import com.oceanview.model.Reservation;
import com.oceanview.util.DBConnection;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.math.BigDecimal;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

@WebServlet("/reservation")
public class ReservationServlet extends HttpServlet {
    
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String action = request.getParameter("action");
        
        if ("getAll".equals(action)) {
            getAllReservations(request, response);
        } else if ("getById".equals(action)) {
            getReservationById(request, response);
        } else if ("search".equals(action)) {
            searchReservations(request, response);
        } else if ("getNextNumber".equals(action)) {
            getNextReservationNumber(response);
        }
    }
    
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String action = request.getParameter("action");
        
        if ("save".equals(action)) {
            saveReservation(request, response);
        } else if ("update".equals(action)) {
            updateReservation(request, response);
        } else if ("delete".equals(action)) {
            deleteReservation(request, response);
        }
    }
    
    private void saveReservation(HttpServletRequest request, HttpServletResponse response) 
            throws IOException {
        try (Connection conn = DBConnection.getConnection()) {
            String sql = "INSERT INTO reservations (reservation_number, guest_name, address, nic_number, " +
                        "contact_number, room_category, room_type, meal_plan, check_in_date, check_out_date, " +
                        "num_adults, num_children, num_rooms, promo_code, discount_amount, total_amount) " +
                        "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
            
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setString(1, request.getParameter("reservationNumber"));
            stmt.setString(2, request.getParameter("guestName"));
            stmt.setString(3, request.getParameter("address"));
            stmt.setString(4, request.getParameter("nicNumber"));
            stmt.setString(5, request.getParameter("contactNumber"));
            stmt.setString(6, request.getParameter("roomCategory"));
            stmt.setString(7, request.getParameter("roomType"));
            stmt.setString(8, request.getParameter("mealPlan"));
            stmt.setDate(9, Date.valueOf(request.getParameter("checkInDate")));
            stmt.setDate(10, Date.valueOf(request.getParameter("checkOutDate")));
            stmt.setInt(11, Integer.parseInt(request.getParameter("numAdults")));
            stmt.setInt(12, Integer.parseInt(request.getParameter("numChildren")));
            stmt.setInt(13, Integer.parseInt(request.getParameter("numRooms")));
            stmt.setString(14, request.getParameter("promoCode"));
            stmt.setBigDecimal(15, new BigDecimal(request.getParameter("discountAmount")));
            stmt.setBigDecimal(16, new BigDecimal(request.getParameter("totalAmount")));
            
            stmt.executeUpdate();
            response.getWriter().write("{\"success\": true, \"message\": \"Reservation saved successfully\"}");
        } catch (SQLException e) {
            e.printStackTrace();
            response.getWriter().write("{\"success\": false, \"message\": \"" + e.getMessage() + "\"}");
        }
    }
    
    private void updateReservation(HttpServletRequest request, HttpServletResponse response) 
            throws IOException {
        try (Connection conn = DBConnection.getConnection()) {
            String sql = "UPDATE reservations SET guest_name=?, address=?, nic_number=?, contact_number=?, " +
                        "room_category=?, room_type=?, meal_plan=?, check_in_date=?, check_out_date=?, " +
                        "num_adults=?, num_children=?, num_rooms=?, promo_code=?, discount_amount=?, total_amount=? " +
                        "WHERE id=?";
            
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setString(1, request.getParameter("guestName"));
            stmt.setString(2, request.getParameter("address"));
            stmt.setString(3, request.getParameter("nicNumber"));
            stmt.setString(4, request.getParameter("contactNumber"));
            stmt.setString(5, request.getParameter("roomCategory"));
            stmt.setString(6, request.getParameter("roomType"));
            stmt.setString(7, request.getParameter("mealPlan"));
            stmt.setDate(8, Date.valueOf(request.getParameter("checkInDate")));
            stmt.setDate(9, Date.valueOf(request.getParameter("checkOutDate")));
            stmt.setInt(10, Integer.parseInt(request.getParameter("numAdults")));
            stmt.setInt(11, Integer.parseInt(request.getParameter("numChildren")));
            stmt.setInt(12, Integer.parseInt(request.getParameter("numRooms")));
            stmt.setString(13, request.getParameter("promoCode"));
            stmt.setBigDecimal(14, new BigDecimal(request.getParameter("discountAmount")));
            stmt.setBigDecimal(15, new BigDecimal(request.getParameter("totalAmount")));
            stmt.setInt(16, Integer.parseInt(request.getParameter("id")));
            
            stmt.executeUpdate();
            response.getWriter().write("{\"success\": true, \"message\": \"Reservation updated successfully\"}");
        } catch (SQLException e) {
            e.printStackTrace();
            response.getWriter().write("{\"success\": false, \"message\": \"" + e.getMessage() + "\"}");
        }
    }
    
    private void deleteReservation(HttpServletRequest request, HttpServletResponse response) 
            throws IOException {
        try (Connection conn = DBConnection.getConnection()) {
            String sql = "DELETE FROM reservations WHERE id=?";
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setInt(1, Integer.parseInt(request.getParameter("id")));
            stmt.executeUpdate();
            response.getWriter().write("{\"success\": true, \"message\": \"Reservation deleted successfully\"}");
        } catch (SQLException e) {
            e.printStackTrace();
            response.getWriter().write("{\"success\": false, \"message\": \"" + e.getMessage() + "\"}");
        }
    }
    
    private void getAllReservations(HttpServletRequest request, HttpServletResponse response) 
            throws IOException {
        List<Reservation> reservations = new ArrayList<>();
        try (Connection conn = DBConnection.getConnection()) {
            String sql = "SELECT * FROM reservations ORDER BY created_at DESC";
            Statement stmt = conn.createStatement();
            ResultSet rs = stmt.executeQuery(sql);
            
            while (rs.next()) {
                Reservation r = new Reservation();
                r.setId(rs.getInt("id"));
                r.setReservationNumber(rs.getString("reservation_number"));
                r.setGuestName(rs.getString("guest_name"));
                r.setAddress(rs.getString("address"));
                r.setNicNumber(rs.getString("nic_number"));
                r.setContactNumber(rs.getString("contact_number"));
                r.setRoomCategory(rs.getString("room_category"));
                r.setRoomType(rs.getString("room_type"));
                r.setMealPlan(rs.getString("meal_plan"));
                r.setCheckInDate(rs.getDate("check_in_date"));
                r.setCheckOutDate(rs.getDate("check_out_date"));
                r.setNumAdults(rs.getInt("num_adults"));
                r.setNumChildren(rs.getInt("num_children"));
                r.setNumRooms(rs.getInt("num_rooms"));
                r.setPromoCode(rs.getString("promo_code"));
                r.setDiscountAmount(rs.getBigDecimal("discount_amount"));
                r.setTotalAmount(rs.getBigDecimal("total_amount"));
                reservations.add(r);
            }
            
            response.setContentType("application/json");
            response.getWriter().write(new Gson().toJson(reservations));
        } catch (SQLException e) {
            e.printStackTrace();
            response.getWriter().write("{\"error\": \"" + e.getMessage() + "\"}");
        }
    }
    
    private void getReservationById(HttpServletRequest request, HttpServletResponse response) 
            throws IOException {
        try (Connection conn = DBConnection.getConnection()) {
            String sql = "SELECT * FROM reservations WHERE id=?";
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setInt(1, Integer.parseInt(request.getParameter("id")));
            ResultSet rs = stmt.executeQuery();
            
            if (rs.next()) {
                Reservation r = new Reservation();
                r.setId(rs.getInt("id"));
                r.setReservationNumber(rs.getString("reservation_number"));
                r.setGuestName(rs.getString("guest_name"));
                r.setAddress(rs.getString("address"));
                r.setNicNumber(rs.getString("nic_number"));
                r.setContactNumber(rs.getString("contact_number"));
                r.setRoomCategory(rs.getString("room_category"));
                r.setRoomType(rs.getString("room_type"));
                r.setMealPlan(rs.getString("meal_plan"));
                r.setCheckInDate(rs.getDate("check_in_date"));
                r.setCheckOutDate(rs.getDate("check_out_date"));
                r.setNumAdults(rs.getInt("num_adults"));
                r.setNumChildren(rs.getInt("num_children"));
                r.setNumRooms(rs.getInt("num_rooms"));
                r.setPromoCode(rs.getString("promo_code"));
                r.setDiscountAmount(rs.getBigDecimal("discount_amount"));
                r.setTotalAmount(rs.getBigDecimal("total_amount"));
                
                response.setContentType("application/json");
                response.getWriter().write(new Gson().toJson(r));
            }
        } catch (SQLException e) {
            e.printStackTrace();
            response.getWriter().write("{\"error\": \"" + e.getMessage() + "\"}");
        }
    }
    
    private void searchReservations(HttpServletRequest request, HttpServletResponse response) 
            throws IOException {
        String searchType = request.getParameter("searchType");
        String searchValue = request.getParameter("searchValue");
        List<Reservation> reservations = new ArrayList<>();
        
        try (Connection conn = DBConnection.getConnection()) {
            String sql = "SELECT * FROM reservations WHERE " + 
                        ("nic".equals(searchType) ? "nic_number" : "reservation_number") + " LIKE ?";
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setString(1, "%" + searchValue + "%");
            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                Reservation r = new Reservation();
                r.setId(rs.getInt("id"));
                r.setReservationNumber(rs.getString("reservation_number"));
                r.setGuestName(rs.getString("guest_name"));
                r.setAddress(rs.getString("address"));
                r.setNicNumber(rs.getString("nic_number"));
                r.setContactNumber(rs.getString("contact_number"));
                r.setRoomCategory(rs.getString("room_category"));
                r.setRoomType(rs.getString("room_type"));
                r.setMealPlan(rs.getString("meal_plan"));
                r.setCheckInDate(rs.getDate("check_in_date"));
                r.setCheckOutDate(rs.getDate("check_out_date"));
                r.setNumAdults(rs.getInt("num_adults"));
                r.setNumChildren(rs.getInt("num_children"));
                r.setNumRooms(rs.getInt("num_rooms"));
                r.setPromoCode(rs.getString("promo_code"));
                r.setDiscountAmount(rs.getBigDecimal("discount_amount"));
                r.setTotalAmount(rs.getBigDecimal("total_amount"));
                reservations.add(r);
            }
            
            response.setContentType("application/json");
            response.getWriter().write(new Gson().toJson(reservations));
        } catch (SQLException e) {
            e.printStackTrace();
            response.getWriter().write("{\"error\": \"" + e.getMessage() + "\"}");
        }
    }
    
    private void getNextReservationNumber(HttpServletResponse response) throws IOException {
        try (Connection conn = DBConnection.getConnection()) {
            String sql = "SELECT reservation_number FROM reservations ORDER BY id DESC LIMIT 1";
            Statement stmt = conn.createStatement();
            ResultSet rs = stmt.executeQuery(sql);
            
            String nextNumber = "R000001";
            if (rs.next()) {
                String lastNumber = rs.getString("reservation_number");
                int num = Integer.parseInt(lastNumber.substring(1)) + 1;
                nextNumber = String.format("R%06d", num);
            }
            
            response.setContentType("application/json");
            response.getWriter().write("{\"reservationNumber\": \"" + nextNumber + "\"}");
        } catch (SQLException e) {
            e.printStackTrace();
            response.getWriter().write("{\"error\": \"" + e.getMessage() + "\"}");
        }
    }
}
