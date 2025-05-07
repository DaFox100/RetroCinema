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
        int rating = Integer.parseInt(request.getParameter("rating"));
        Timestamp now = new Timestamp(System.currentTimeMillis());

        try (Connection conn = DatabaseConnection.initializeDatabase()) {
            conn.setAutoCommit(false); // start transaction

            // Step 1: Update movie copies_rented
            PreparedStatement updateStmt = conn.prepareStatement(
                "UPDATE movies SET copies_rented = GREATEST(copies_rented - 1, 0) WHERE movie_id = ?"
            );
            updateStmt.setInt(1, movieId);
            updateStmt.executeUpdate();
            updateStmt.close();

            // Step 2: Mark rental as returned
            PreparedStatement returnDateStmt = conn.prepareStatement(
                "UPDATE rentals SET returned_date = ? " +
                "WHERE ctid = (" +
                "  SELECT ctid FROM rentals " +
                "  WHERE movie_id = ? AND customer_id = ? AND returned_date IS NULL LIMIT 1)"
            );
            returnDateStmt.setTimestamp(1, now);
            returnDateStmt.setInt(2, movieId);
            returnDateStmt.setInt(3, customerId);
            returnDateStmt.executeUpdate();
            returnDateStmt.close();

            // Step 3: Insert rating
            PreparedStatement ratingStmt = conn.prepareStatement(
                "INSERT INTO ratings (customer_id, movie_id, rating) VALUES (?, ?, ?)"
            );
            ratingStmt.setInt(1, customerId);
            ratingStmt.setInt(2, movieId);
            ratingStmt.setInt(3, rating);
            ratingStmt.executeUpdate();
            ratingStmt.close();

            conn.commit();
            response.sendRedirect("account?customerId=" + customerId); // forward correctly to servlet

        } catch (SQLException e) {
            e.printStackTrace();
            response.getWriter().println("Error processing return: " + e.getMessage());
        }
    }
}
