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
            conn.setAutoCommit(false); // Start transaction

            // Step 1: Update copies_rented
            try (PreparedStatement updateStmt = conn.prepareStatement(
                    "UPDATE movies SET copies_rented = GREATEST(copies_rented - 1, 0) WHERE movie_id = ?")) {
                updateStmt.setInt(1, movieId);
                updateStmt.executeUpdate();
            }

            // Step 2: Mark rental as returned
            try (PreparedStatement returnDateStmt = conn.prepareStatement(
                    "UPDATE rentals SET returned_date = ? " +
                    "WHERE ctid = (" +
                    "  SELECT ctid FROM rentals " +
                    "  WHERE movie_id = ? AND customer_id = ? AND returned_date IS NULL LIMIT 1)")) {
                returnDateStmt.setTimestamp(1, now);
                returnDateStmt.setInt(2, movieId);
                returnDateStmt.setInt(3, customerId);
                returnDateStmt.executeUpdate();
            }

            // Step 3: Insert or update rating
            try (PreparedStatement checkStmt = conn.prepareStatement(
                    "SELECT 1 FROM ratings WHERE customer_id = ? AND movie_id = ?")) {
                checkStmt.setInt(1, customerId);
                checkStmt.setInt(2, movieId);
                try (ResultSet rs = checkStmt.executeQuery()) {
                    if (rs.next()) {
                        try (PreparedStatement updateRatingStmt = conn.prepareStatement(
                                "UPDATE ratings SET rating = ? WHERE customer_id = ? AND movie_id = ?")) {
                            updateRatingStmt.setInt(1, rating);
                            updateRatingStmt.setInt(2, customerId);
                            updateRatingStmt.setInt(3, movieId);
                            updateRatingStmt.executeUpdate();
                        }
                    } else {
                        try (PreparedStatement insertStmt = conn.prepareStatement(
                                "INSERT INTO ratings (customer_id, movie_id, rating) VALUES (?, ?, ?)")) {
                            insertStmt.setInt(1, customerId);
                            insertStmt.setInt(2, movieId);
                            insertStmt.setInt(3, rating);
                            insertStmt.executeUpdate();
                        }
                    }
                }
            }

            conn.commit();
            response.sendRedirect("account?customerId=" + customerId);

        } catch (SQLException e) {
            e.printStackTrace();
            response.getWriter().println("Error processing return: " + e.getMessage());
        }
    }
}
