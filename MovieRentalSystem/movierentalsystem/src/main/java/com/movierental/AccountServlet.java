package com.movierental;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public class AccountServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
                try {
                    Class.forName("org.postgresql.Driver");
                } catch (Exception e) {
                    System.err.println(e.toString());
                }  
        String customerIdParam = request.getParameter("customerId");
        
        // Only proceed if customerId parameter exists
        if (customerIdParam != null && !customerIdParam.isEmpty()) {
            try {
                int customerId = Integer.parseInt(customerIdParam);
                List<String[]> rentals = new ArrayList<>();
        
                try (Connection conn = DatabaseConnection.initializeDatabase()) {
                    // No need to load the driver twice, it's likely already loaded in DatabaseConnection
                    // and if needed, should be in the servlet init() method
                    
                    String sql = "SELECT m.title, r.movie_id, r.rented_date " +
                                 "FROM rentals r JOIN movies m ON r.movie_id = m.movie_id " +
                                 "WHERE r.customer_id = ? AND r.returned_date IS NULL " +
                                 "ORDER BY r.rented_date DESC";
        
                    try (PreparedStatement stmt = conn.prepareStatement(sql)) {
                        stmt.setInt(1, customerId);
                        
                        try (ResultSet rs = stmt.executeQuery()) {
                            while (rs.next()) {
                                String[] row = {
                                    rs.getString("title"),
                                    String.valueOf(rs.getInt("movie_id")),
                                    String.valueOf(rs.getTimestamp("rented_date"))
                                };
                                rentals.add(row);
                            }
                        }
                    }
        
                    request.setAttribute("rentals", rentals);
                    request.setAttribute("customerId", customerId);
                    
                } catch (SQLException e) {
                    e.printStackTrace();
                    request.setAttribute("error", "Database error: " + e.getMessage());
                }
            } catch (NumberFormatException e) {
                request.setAttribute("error", "Invalid customer ID format. Please enter a valid number.");
            }
        }
        
        // Always forward to the JSP, which will handle the display logic
        RequestDispatcher dispatcher = request.getRequestDispatcher("account.jsp");
        dispatcher.forward(request, response);
    }
}