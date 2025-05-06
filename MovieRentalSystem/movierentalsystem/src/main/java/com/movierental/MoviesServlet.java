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

public class MoviesServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {

    List<Movie> movies = new ArrayList<>();
    
    try {
        Class.forName("org.postgresql.Driver");
    } catch (Exception e) {
        System.err.println(e.toString());
    }

    try (Connection conn = DatabaseConnection.initializeDatabase()) {
        String searchQuery = request.getParameter("query");  // Get user input (can be null)
        String sql;
        PreparedStatement stmt;

        if (searchQuery != null && !searchQuery.trim().isEmpty()) {
            sql = "SELECT m.movie_id, m.title, m.genre, m.total_copies, m.copies_rented, m.price, m.url, " +
                  "COALESCE(AVG(r.rating), 0) AS avg_rating " +
                  "FROM movies m LEFT JOIN ratings r ON m.movie_id = r.movie_id " +
                  "WHERE LOWER(m.title) LIKE ? OR LOWER(m.genre) LIKE ? " +
                  "GROUP BY m.movie_id, m.title, m.genre, m.total_copies, m.price, m.url";
            stmt = conn.prepareStatement(sql);
            String keyword = "%" + searchQuery.toLowerCase() + "%";
            stmt.setString(1, keyword);
            stmt.setString(2, keyword);
        }
         else {
            sql = "SELECT m.movie_id, m.title, m.genre, m.total_copies, m.copies_rented, m.price, m.url, " +
             "COALESCE(AVG(r.rating), 0) AS avg_rating " +
             "FROM movies m LEFT JOIN ratings r ON m.movie_id = r.movie_id " +
             "GROUP BY m.movie_id, m.title, m.genre, m.total_copies, m.copies_rented, m.price, m.url " +
             "ORDER BY m.movie_id ASC";

            stmt = conn.prepareStatement(sql);
        }

        ResultSet rs = stmt.executeQuery();
        while (rs.next()) {
            movies.add(new Movie(
                rs.getInt("movie_id"),
                rs.getString("title"),
                rs.getString("genre"),
                rs.getInt("total_copies"),
                rs.getInt("copies_rented"),
                rs.getDouble("price"),
                rs.getString("url"),
                rs.getDouble("avg_rating")
            ));
        }

        request.setAttribute("movies", movies);
        RequestDispatcher dispatcher = request.getRequestDispatcher("index.jsp");
        dispatcher.forward(request, response);

    }   catch (SQLException e) {
            e.printStackTrace();
            response.setContentType("text/plain");
            response.getWriter().println("DB Error: " + e.getMessage());
        }
    }
}
