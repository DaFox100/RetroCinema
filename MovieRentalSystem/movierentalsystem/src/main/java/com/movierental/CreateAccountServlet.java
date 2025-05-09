package com.movierental;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public class CreateAccountServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {

            String firstName = request.getParameter("firstName");
            String lastName  = request.getParameter("lastName");
            String email     = request.getParameter("email");
            String address   = request.getParameter("address");
    
            try (Connection conn = DatabaseConnection.initializeDatabase()) {
    
                // ✅ Step 1: Get current max customer_id
                int newCustomerId = 1;
                String maxSql = "SELECT MAX(customer_id) FROM customers";
    
                try (PreparedStatement maxStmt = conn.prepareStatement(maxSql);
                     ResultSet rs = maxStmt.executeQuery()) {
    
                    if (rs.next()) {
                        newCustomerId = rs.getInt(1) + 1;
                    }
                }
    
                // ✅ Step 2: Insert new customer with custom ID
                String insertSql = "INSERT INTO customers (customer_id, first_name, last_name, email, address) VALUES (?, ?, ?, ?, ?)";
    
                try (PreparedStatement insertStmt = conn.prepareStatement(insertSql)) {
                    insertStmt.setInt(1, newCustomerId);
                    insertStmt.setString(2, firstName);
                    insertStmt.setString(3, lastName);
                    insertStmt.setString(4, email);
                    insertStmt.setString(5, address);
                    insertStmt.executeUpdate();
                }
    
                // ✅ Step 3: Redirect to account.jsp with new ID
                response.sendRedirect("account.jsp?customerId=" + newCustomerId + "&new=true");

        } catch (SQLException e) {
            e.printStackTrace();
            response.getWriter().println("DB Error: " + e.getMessage());
        }
    }
}
