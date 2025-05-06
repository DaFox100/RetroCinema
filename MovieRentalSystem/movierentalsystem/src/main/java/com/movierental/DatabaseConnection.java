package com.movierental;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DatabaseConnection {
    public static Connection initializeDatabase() throws SQLException {
        try {
            Class.forName("org.postgresSQL.Driver");
        } catch (ClassNotFoundException e) {
            System.out.println("!!!!!!Error has Occurred connected to DB!!!!!!");
            e.printStackTrace();
        }
        String url = "jdbc:postgresql://aws-0-us-west-1.pooler.supabase.com:6543/postgres?sslmode=require";
        String user = "postgres.fnvoefvmbaknmhryrxuj";
        String password = "CS157A052025";
        return DriverManager.getConnection(url, user, password);
    }
}