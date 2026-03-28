package com.example.demo.util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.sql.Statement;

public class DatabaseCleanup {
    public static void main(String[] args) {
        String url = "jdbc:mysql://localhost:3306/hanfu_cultural_platform?useSSL=false&serverTimezone=Asia/Shanghai";
        String username = "root";
        String password = "123456";

        try (Connection connection = DriverManager.getConnection(url, username, password);
             Statement statement = connection.createStatement()) {

            // Try to drop dynasty_shape table
            try {
                String dropDynastyShapeTable = "DROP TABLE IF EXISTS dynasty_shape";
                statement.executeUpdate(dropDynastyShapeTable);
                System.out.println("Successfully dropped dynasty_shape table");
            } catch (SQLException e) {
                System.out.println("Error dropping dynasty_shape table: " + e.getMessage());
            }

            // Try to drop dynasty table
            try {
                String dropDynastyTable = "DROP TABLE IF EXISTS dynasty";
                statement.executeUpdate(dropDynastyTable);
                System.out.println("Successfully dropped dynasty table");
            } catch (SQLException e) {
                System.out.println("Error dropping dynasty table: " + e.getMessage());
            }

        } catch (SQLException e) {
            System.out.println("Database connection failed: " + e.getMessage());
        }
    }
}