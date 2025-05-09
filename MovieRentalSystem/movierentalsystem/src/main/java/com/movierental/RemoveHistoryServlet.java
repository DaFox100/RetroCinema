package com.movierental;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public class RemoveHistoryServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int customerId = Integer.parseInt(request.getParameter("customerId"));

        try (Connection conn = DatabaseConnection.initializeDatabase()) {
            String sql = "DELETE FROM rentals WHERE customer_id = ? AND returned_date IS NOT NULL";
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setInt(1, customerId);
            int rows = stmt.executeUpdate();

            System.out.println("Deleted rows: " + rows);
            response.sendRedirect("account?customerId=" + customerId);
        } catch (SQLException e) {
            e.printStackTrace();
            response.getWriter().println("Error removing rental history: " + e.getMessage());
        }
    }
}
