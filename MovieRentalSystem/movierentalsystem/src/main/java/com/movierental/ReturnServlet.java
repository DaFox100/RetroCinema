package com.movierental;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public class ReturnServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {
            try {
                Class.forName("org.postgresql.Driver");
            } catch (Exception e) {
                System.err.println(e.toString());
            }   
            
            int movieId = Integer.parseInt(request.getParameter("movieId"));
            int customerId = Integer.parseInt(request.getParameter("customerId"));
    
            try (Connection conn = DatabaseConnection.initializeDatabase()) {
                conn.setAutoCommit(false);  // Begin transaction
    
                try {
                    // Step 1: Decrement copies_rented (but not below 0)
                    String updateSql = "UPDATE movies SET copies_rented = GREATEST(copies_rented - 1, 0) WHERE movie_id = ?";
                    try (PreparedStatement updateStmt = conn.prepareStatement(updateSql)) {
                        updateStmt.setInt(1, movieId);
                        updateStmt.executeUpdate();
                    }
    
                    // Step 2: Delete a rental record (assumes one rental per movie per customer)
                    String deleteSql = 
                    "WITH one_row AS (" +
                    "  SELECT ctid FROM rentals WHERE movie_id = ? AND customer_id = ? LIMIT 1" +
                    ") " +
                    "DELETE FROM rentals WHERE ctid IN (SELECT ctid FROM one_row)";
                
                    try (PreparedStatement deleteStmt = conn.prepareStatement(deleteSql)) {
                        deleteStmt.setInt(1, movieId);
                        deleteStmt.setInt(2, customerId);
                        deleteStmt.executeUpdate();
                    }
    
                    conn.commit();  // Commit if both succeed
                    response.sendRedirect("account.jsp?customerId=" + customerId);
    
                } catch (SQLException ex) {
                    conn.rollback();  // Roll back if any step fails
                    throw ex;
                }
    
            } catch (SQLException e) {
                e.printStackTrace();
                response.getWriter().println("Error processing return: " + e.getMessage());
            }
    }
}
