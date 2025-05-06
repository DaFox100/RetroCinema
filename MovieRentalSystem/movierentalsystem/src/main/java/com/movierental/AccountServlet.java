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

        int customerId = Integer.parseInt(request.getParameter("customerId"));
        List<String> rentals = new ArrayList<>();

        try (Connection conn = DatabaseConnection.initializeDatabase()) {

            try {
                Class.forName("org.postgresql.Driver");
            } catch (Exception e) {
                System.err.println(e.toString());
            }                

            String sql = "SELECT r.movie_id, m.title, r.rented_date " +
                         "FROM rentals r JOIN movies m ON r.movie_id = m.movie_id " +
                         "WHERE r.customer_id = ? ORDER BY r.rented_date DESC";

            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setInt(1, customerId);
            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                String row = "Movie: " + rs.getString("title") +
                             " | Movie ID: " + rs.getInt("movie_id") +
                             " | Date: " + rs.getTimestamp("rented_date");
                rentals.add(row);
            }

            request.setAttribute("rentals", rentals);
            request.setAttribute("customerId", customerId);
            RequestDispatcher dispatcher = request.getRequestDispatcher("accountResults.jsp");
            dispatcher.forward(request, response);

        } catch (SQLException e) {
            e.printStackTrace();
            response.getWriter().println("Error retrieving rentals: " + e.getMessage());
        }
    }
}
