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
                List<String[]> pastRentals = new ArrayList<>();
        
                try (Connection conn = DatabaseConnection.initializeDatabase()) {
                    //Get Customer information
                    String customerSql = "SELECT first_name, last_name, email, address FROM customers WHERE customer_id = ?";
                    PreparedStatement custStmt = conn.prepareStatement(customerSql);
                    custStmt.setInt(1, customerId);
                    ResultSet custRs = custStmt.executeQuery();

                    if (!custRs.next()) {
                        response.getWriter().println("No customer found.");
                    return;
                    }

                    // Save customer info to request
                    request.setAttribute("firstName", custRs.getString("first_name"));
                    request.setAttribute("lastName", custRs.getString("last_name"));
                    request.setAttribute("email", custRs.getString("email"));
                    request.setAttribute("address", custRs.getString("address"));
                    
                    //Get current rentals
                    String currentSql = "SELECT m.title, r.movie_id, r.rented_date " +
                                 "FROM rentals r JOIN movies m ON r.movie_id = m.movie_id " +
                                 "WHERE r.customer_id = ? AND r.returned_date IS NULL " +
                                 "ORDER BY r.rented_date DESC";
        
                    try (PreparedStatement stmt = conn.prepareStatement(currentSql)) {
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


                        //Get past rentals
                        String pastSql = "SELECT r.movie_id, m.title, r.rented_date, r.returned_date " +
                        "FROM rentals r JOIN movies m ON r.movie_id = m.movie_id " +
                        "WHERE r.customer_id = ? AND r.returned_date IS NOT NULL " +
                        "ORDER BY r.rented_date DESC";
            
                        try (PreparedStatement stmt = conn.prepareStatement(pastSql)) {
                            stmt.setInt(1, customerId);
                            
                            try (ResultSet rs = stmt.executeQuery()) {
                                while (rs.next()) {
                                    String[] row = {
                                        String.valueOf(rs.getInt("movie_id")),
                                        rs.getString("title"),
                                        String.valueOf(rs.getTimestamp("rented_date")),
                                        String.valueOf(rs.getTimestamp("returned_date"))
                                    };
                                    pastRentals.add(row);
                                }
                            }
                        }
        
                    request.setAttribute("rentals", rentals);
                    request.setAttribute("customerId", customerId);
                    request.setAttribute("pastRentals", pastRentals);
                    
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