package com.movierental;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

// Servlet to handle movie rental operations
public class RentServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

            // Parse input parameters
            int movieId = Integer.parseInt(request.getParameter("movieId"));
            int customerId = Integer.parseInt(request.getParameter("customerId"));
            Timestamp now = new Timestamp(System.currentTimeMillis());

        try (Connection conn = DatabaseConnection.initializeDatabase()) {

            //Check that valid Customer ID exists
            String checkCustomerSql = "SELECT 1 FROM customers WHERE customer_id = ?";
            try (PreparedStatement custStmt = conn.prepareStatement(checkCustomerSql)) {
                custStmt.setInt(1, customerId);
                try (ResultSet custRs = custStmt.executeQuery()) {
                    if (!custRs.next()) {
                        // Invalid customer; redirect with error
                        response.sendRedirect("account.jsp?error=invalid_customer");
                        return;
                    }
                    
                }
            }
        


             // Check if the movie is in stock
            String checkSql = "SELECT total_copies, copies_rented FROM movies WHERE movie_id = ?";
            PreparedStatement checkStmt = conn.prepareStatement(checkSql);
            checkStmt.setInt(1, movieId);
            ResultSet rs = checkStmt.executeQuery();

        if (rs.next()) {
            int totalCopies = rs.getInt("total_copies");
            int rentedCopies = rs.getInt("copies_rented");

            if (rentedCopies >= totalCopies) {
                // Out of stock; redirect with error
                response.sendRedirect("index.jsp?error=outofstock");
               
                
                return;
            }
        } else {
            // Movie not found
            response.getWriter().println("Error: Movie not found.");
            return;
        }


            //Update movie's rented count
            String sql = "UPDATE movies SET copies_rented = copies_rented + 1 WHERE movie_id = ?";
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setInt(1, movieId);
            int rows = stmt.executeUpdate();

            //Step 4: Record the rental transaction
            String insertRental = "INSERT INTO rentals (movie_id, customer_id, rented_date) VALUES (?, ?, ?)";
            PreparedStatement insertStmt = conn.prepareStatement(insertRental); 
            insertStmt.setInt(1, movieId);
            insertStmt.setInt(2, customerId);  
            insertStmt.setTimestamp(3, now);
            
            insertStmt.executeUpdate();

            //Confirm success or failure
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
