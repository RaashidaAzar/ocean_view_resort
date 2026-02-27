package com.oceanview.servlet;

import com.google.gson.Gson;
import com.oceanview.model.Promotion;
import com.oceanview.util.DBConnection;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.math.BigDecimal;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

@WebServlet("/promotion")
public class PromotionServlet extends HttpServlet {
    
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String action = request.getParameter("action");
        
        if ("getAll".equals(action)) {
            getAllPromotions(response);
        } else if ("validate".equals(action)) {
            validatePromoCode(request, response);
        } else if ("getById".equals(action)) {
            getPromotionById(request, response);
        }
    }
    
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String action = request.getParameter("action");
        
        if ("save".equals(action)) {
            savePromotion(request, response);
        } else if ("update".equals(action)) {
            updatePromotion(request, response);
        } else if ("delete".equals(action)) {
            deletePromotion(request, response);
        }
    }
    
    private void getAllPromotions(HttpServletResponse response) throws IOException {
        List<Promotion> promotions = new ArrayList<>();
        try (Connection conn = DBConnection.getConnection()) {
            String sql = "SELECT * FROM promotions ORDER BY created_at DESC";
            Statement stmt = conn.createStatement();
            ResultSet rs = stmt.executeQuery(sql);
            
            while (rs.next()) {
                Promotion p = new Promotion();
                p.setId(rs.getInt("id"));
                p.setPromoCode(rs.getString("promo_code"));
                p.setDescription(rs.getString("description"));
                p.setDiscountPercentage(rs.getBigDecimal("discount_percentage"));
                p.setStartDate(rs.getDate("start_date"));
                p.setEndDate(rs.getDate("end_date"));
                p.setActive(rs.getBoolean("is_active"));
                promotions.add(p);
            }
            
            response.setContentType("application/json");
            response.getWriter().write(new Gson().toJson(promotions));
        } catch (SQLException e) {
            e.printStackTrace();
            response.getWriter().write("{\"error\": \"" + e.getMessage() + "\"}");
        }
    }
    
    private void validatePromoCode(HttpServletRequest request, HttpServletResponse response) 
            throws IOException {
        String promoCode = request.getParameter("promoCode");
        
        try (Connection conn = DBConnection.getConnection()) {
            String sql = "SELECT * FROM promotions WHERE promo_code=? AND is_active=1 " +
                        "AND CURDATE() BETWEEN start_date AND end_date";
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setString(1, promoCode);
            ResultSet rs = stmt.executeQuery();
            
            if (rs.next()) {
                Promotion p = new Promotion();
                p.setId(rs.getInt("id"));
                p.setPromoCode(rs.getString("promo_code"));
                p.setDescription(rs.getString("description"));
                p.setDiscountPercentage(rs.getBigDecimal("discount_percentage"));
                
                response.setContentType("application/json");
                response.getWriter().write(new Gson().toJson(p));
            } else {
                response.getWriter().write("{\"valid\": false, \"message\": \"Invalid or expired promo code\"}");
            }
        } catch (SQLException e) {
            e.printStackTrace();
            response.getWriter().write("{\"error\": \"" + e.getMessage() + "\"}");
        }
    }
    
    private void savePromotion(HttpServletRequest request, HttpServletResponse response) 
            throws IOException {
        try (Connection conn = DBConnection.getConnection()) {
            String sql = "INSERT INTO promotions (promo_code, description, discount_percentage, " +
                        "start_date, end_date, is_active) VALUES (?, ?, ?, ?, ?, ?)";
            
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setString(1, request.getParameter("promoCode"));
            stmt.setString(2, request.getParameter("description"));
            stmt.setBigDecimal(3, new BigDecimal(request.getParameter("discountPercentage")));
            stmt.setDate(4, Date.valueOf(request.getParameter("startDate")));
            stmt.setDate(5, Date.valueOf(request.getParameter("endDate")));
            stmt.setBoolean(6, Boolean.parseBoolean(request.getParameter("isActive")));
            
            stmt.executeUpdate();
            response.getWriter().write("{\"success\": true, \"message\": \"Promotion saved successfully\"}");
        } catch (SQLException e) {
            e.printStackTrace();
            response.getWriter().write("{\"success\": false, \"message\": \"" + e.getMessage() + "\"}");
        }
    }
    
    private void updatePromotion(HttpServletRequest request, HttpServletResponse response) 
            throws IOException {
        try (Connection conn = DBConnection.getConnection()) {
            String sql = "UPDATE promotions SET promo_code=?, description=?, discount_percentage=?, " +
                        "start_date=?, end_date=?, is_active=? WHERE id=?";
            
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setString(1, request.getParameter("promoCode"));
            stmt.setString(2, request.getParameter("description"));
            stmt.setBigDecimal(3, new BigDecimal(request.getParameter("discountPercentage")));
            stmt.setDate(4, Date.valueOf(request.getParameter("startDate")));
            stmt.setDate(5, Date.valueOf(request.getParameter("endDate")));
            stmt.setBoolean(6, Boolean.parseBoolean(request.getParameter("isActive")));
            stmt.setInt(7, Integer.parseInt(request.getParameter("id")));
            
            stmt.executeUpdate();
            response.getWriter().write("{\"success\": true, \"message\": \"Promotion updated successfully\"}");
        } catch (SQLException e) {
            e.printStackTrace();
            response.getWriter().write("{\"success\": false, \"message\": \"" + e.getMessage() + "\"}");
        }
    }
    
    private void deletePromotion(HttpServletRequest request, HttpServletResponse response) 
            throws IOException {
        try (Connection conn = DBConnection.getConnection()) {
            String sql = "DELETE FROM promotions WHERE id=?";
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setInt(1, Integer.parseInt(request.getParameter("id")));
            stmt.executeUpdate();
            
            response.getWriter().write("{\"success\": true, \"message\": \"Promotion deleted successfully\"}");
        } catch (SQLException e) {
            e.printStackTrace();
            response.getWriter().write("{\"success\": false, \"message\": \"" + e.getMessage() + "\"}");
        }
    }
    
    private void getPromotionById(HttpServletRequest request, HttpServletResponse response) 
            throws IOException {
        try (Connection conn = DBConnection.getConnection()) {
            String sql = "SELECT * FROM promotions WHERE id=?";
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setInt(1, Integer.parseInt(request.getParameter("id")));
            ResultSet rs = stmt.executeQuery();
            
            if (rs.next()) {
                Promotion p = new Promotion();
                p.setId(rs.getInt("id"));
                p.setPromoCode(rs.getString("promo_code"));
                p.setDescription(rs.getString("description"));
                p.setDiscountPercentage(rs.getBigDecimal("discount_percentage"));
                p.setStartDate(rs.getDate("start_date"));
                p.setEndDate(rs.getDate("end_date"));
                p.setActive(rs.getBoolean("is_active"));
                
                response.setContentType("application/json");
                response.getWriter().write(new Gson().toJson(p));
            }
        } catch (SQLException e) {
            e.printStackTrace();
            response.getWriter().write("{\"error\": \"" + e.getMessage() + "\"}");
        }
    }
}
