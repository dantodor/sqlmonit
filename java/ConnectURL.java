/*=====================================================================
File: 	 ConnectURL.java
Summary: This Microsoft JDBC Driver for SQL Server sample application
         demonstrates how to connect to a SQL Server database by using 
		 a connection URL. It also demonstrates how to retrieve data 
		 from a SQL Server database by using an SQL statement.
---------------------------------------------------------------------
This file is part of the Microsoft JDBC Driver for SQL Server Code Samples.
Copyright (C) Microsoft Corporation.  All rights reserved.
 
This source code is intended only as a supplement to Microsoft
Development Tools and/or on-line documentation.  See these other
materials for detailed information regarding Microsoft code samples.
 
THIS CODE AND INFORMATION ARE PROVIDED "AS IS" WITHOUT WARRANTY OF
ANY KIND, EITHER EXPRESSED OR IMPLIED, INCLUDING BUT NOT LIMITED TO
THE IMPLIED WARRANTIES OF MERCHANTABILITY AND/OR FITNESS FOR A
PARTICULAR PURPOSE.
=====================================================================*/
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

public class ConnectURL {
    public static void main(String[] args) {

        // Create a variable for the connection string.
        String connectionUrl = "jdbc:sqlserver://localhost:4040;databaseName=tempdb;user=sa;password=Hulkhulk2k";

        try (Connection con = DriverManager.getConnection(connectionUrl); Statement stmt = con.createStatement();) {
            String SQL = "SELECT @@SERVERNAME AS 'Server'";
            ResultSet rs = stmt.executeQuery(SQL);

            // Iterate through the data in the result set and display it.
            while (rs.next()) {
                System.out.println(rs.getString("Server"));
            }
            rs = stmt.executeQuery(SQL);

            // Iterate through the data in the result set and display it.
            while (rs.next()) {
                System.out.println(rs.getString("Server"));
            }
            rs = stmt.executeQuery(SQL);

            // Iterate through the data in the result set and display it.
            while (rs.next()) {
                System.out.println(rs.getString("Server"));
            }
        }
        // Handle any errors that may have occurred.
        catch (SQLException e) {
            e.printStackTrace();
        }
    }
}