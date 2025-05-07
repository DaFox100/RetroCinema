package com.movierental;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.sql.Timestamp;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public class RentServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

            int movieId = Integer.parseInt(request.getParameter("movieId"));
            int customerId = Integer.parseInt(request.getParameter("customerId"));
            Timestamp now = new Timestamp(System.currentTimeMillis());

        try (Connection conn = DatabaseConnection.initializeDatabase()) {
            String sql = "UPDATE movies SET copies_rented = copies_rented + 1 WHERE movie_id = ?";
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setInt(1, movieId);
            int rows = stmt.executeUpdate();

            String insertRental = "INSERT INTO rentals (movie_id, customer_id, rented_date) VALUES (?, ?, ?)";
            PreparedStatement insertStmt = conn.prepareStatement(insertRental); 
            insertStmt.setInt(1, movieId);
            insertStmt.setInt(2, customerId);  
            insertStmt.setTimestamp(3, now);
            
            insertStmt.executeUpdate();


            if (rows > 0) {
                response.sendRedirect("movies");  // Refresh the movie list
            } else {
                response.getWriter().println("Error: Could not update rental.");
            }

        } catch (SQLException e) {
            e.printStackTrace();
            response.getWriter().println("DB Error: " + e.getMessage());
        }
    }
}
