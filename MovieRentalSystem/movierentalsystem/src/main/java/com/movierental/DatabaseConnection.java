package com.movierental;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

// Utility class for initializing a database connection to Supabase PostgreSQL
public class DatabaseConnection {

    public static Connection initializeDatabase() throws SQLException {
        try {
            // Correct JDBC driver class for PostgreSQL
            Class.forName("org.postgresql.Driver");
        } catch (ClassNotFoundException e) {
            System.out.println("Error: Failed to load PostgreSQL JDBC Driver.");
            e.printStackTrace();
        }

        // Supabase database credentials and URL
        String url = "jdbc:postgresql://aws-0-us-west-1.pooler.supabase.com:6543/postgres?sslmode=require";
        String user = "postgres.fnvoefvmbaknmhryrxuj";
        String password = "CS157A052025";

        // Establish and return the database connection
        return DriverManager.getConnection(url, user, password);
    }
}
