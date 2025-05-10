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

// Servlet to handle movie returns and optionally update the customer's rating
public class ReturnServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
                
        // Load PostgreSQL JDBC driver

        try {
            Class.forName("org.postgresql.Driver");
        } catch (Exception e) {
            System.err.println(e.toString());
        }
        // Parse request parameters

        int movieId = Integer.parseInt(request.getParameter("movieId"));
        int customerId = Integer.parseInt(request.getParameter("customerId"));
        int rating = Integer.parseInt(request.getParameter("rating"));
        Timestamp now = new Timestamp(System.currentTimeMillis());
        Timestamp defaultUnreturnedDate = Timestamp.valueOf("1000-01-01 00:00:00.0");


        try (Connection conn = DatabaseConnection.initializeDatabase()) {
            conn.setAutoCommit(false);
            // Begin transaction

            PreparedStatement updateStmt = null;
            PreparedStatement returnStmt = null;
            PreparedStatement checkRatingStmt = null;
            PreparedStatement updateRatingStmt = null;
            PreparedStatement insertRatingStmt = null;
            ResultSet rs = null;

            try {
                // Step 1: Decrement copies_rented
                updateStmt = conn.prepareStatement("UPDATE movies SET copies_rented = GREATEST(copies_rented - 1, 0) WHERE movie_id = ?");
                updateStmt.setInt(1, movieId);
                updateStmt.executeUpdate();

                // Step 2: Mark rental as returned
                String returnSql =
                "WITH target AS (" +
                "  SELECT movie_id, customer_id, rented_date FROM rentals " +
                "  WHERE movie_id = ? AND customer_id = ? AND returned_date = ? " +
                "  ORDER BY rented_date DESC LIMIT 1" +
                ") " +
                "UPDATE rentals SET returned_date = ? FROM target " +
                "WHERE rentals.movie_id = target.movie_id AND rentals.customer_id = target.customer_id " +
                "AND rentals.rented_date = target.rented_date";

            returnStmt = conn.prepareStatement(returnSql);
            returnStmt.setInt(1, movieId);
            returnStmt.setInt(2, customerId);
            returnStmt.setTimestamp(3, defaultUnreturnedDate);
            returnStmt.setTimestamp(4, now);  
            returnStmt.executeUpdate();

                

                // Step 3: Handle rating insert/update
                checkRatingStmt = conn.prepareStatement("SELECT 1 FROM ratings WHERE customer_id = ? AND movie_id = ?");
                checkRatingStmt.setInt(1, customerId);
                checkRatingStmt.setInt(2, movieId);
                rs = checkRatingStmt.executeQuery();

                if (rs.next()) {
                    // If a rating exists, update it
                    updateRatingStmt = conn.prepareStatement("UPDATE ratings SET rating = ? WHERE customer_id = ? AND movie_id = ?");
                    updateRatingStmt.setInt(1, rating);
                    updateRatingStmt.setInt(2, customerId);
                    updateRatingStmt.setInt(3, movieId);
                    updateRatingStmt.executeUpdate();
                } else {
                     // Otherwise insert a new rating
                    insertRatingStmt = conn.prepareStatement("INSERT INTO ratings (customer_id, movie_id, rating) VALUES (?, ?, ?)");
                    insertRatingStmt.setInt(1, customerId);
                    insertRatingStmt.setInt(2, movieId);
                    insertRatingStmt.setInt(3, rating);
                    insertRatingStmt.executeUpdate();
                }
                // Commit transaction on success
                conn.commit();
                response.sendRedirect("account?customerId=" + customerId);

            } catch (SQLException e) {
                conn.rollback();// Rollback transaction on failure
                throw e;
            } finally {
                //Clean up all JDBC resources
                if (rs != null) rs.close();
                if (updateStmt != null) updateStmt.close();
                if (returnStmt != null) returnStmt.close();
                if (checkRatingStmt != null) checkRatingStmt.close();
                if (updateRatingStmt != null) updateRatingStmt.close();
                if (insertRatingStmt != null) insertRatingStmt.close();
            }

        } catch (SQLException e) {
            e.printStackTrace();
            response.getWriter().println("Error processing return: " + e.getMessage());
        }
    }
}
