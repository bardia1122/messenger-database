import java.sql.*;
import java.util.HashMap;

public class Query {
    public static Connection getConnection() {
        String url = "jdbc:postgresql://localhost:5432/postgres";
        String username = "myuser";
        String password = "mypassword";
        try {
            Class.forName("org.postgresql.Driver");

            Connection connection = DriverManager.getConnection(url, username, password);
            return connection;
        } catch (Exception ex) {
            System.out.println(ex.toString());
        }
        return null;
    }
    public static void insert(String table, HashMap<Object, Object> queries) {
        Connection connection = null;
        PreparedStatement preparedStatement = null;
        try {
            connection = getConnection();

            StringBuilder pedaret = new StringBuilder();
            pedaret.append("INSERT INTO ").append(table).append(" (");
            for (Object o : queries.keySet()) {
                pedaret.append(o).append(", ");
            }
            pedaret.delete(pedaret.length() - 2, pedaret.length() - 1);
            pedaret.append(") VALUES (");
            pedaret.append("?, ".repeat(queries.size()));
            pedaret.delete(pedaret.length() - 2, pedaret.length() - 1);
            pedaret.append(")");

            assert connection != null;
            preparedStatement = connection.prepareStatement(pedaret.toString());
            int k = 1;
            for (Object o : queries.values()) {
                preparedStatement.setObject(k, o);
                k++;
            }
            System.out.println(preparedStatement);
            int rowsAffected = preparedStatement.executeUpdate();
            if (rowsAffected > 0) {
                System.out.println("Data inserted successfully.");
            } else {
                System.out.println("Failed to insert data.");
            }
        } catch (SQLException e) {
            System.err.println("SQL exception occurred: " + e.getMessage());
        } catch (Exception e) {
            System.err.println("An error occurred: " + e.getMessage());
        } finally {
            try {
                if (preparedStatement != null) {
                    preparedStatement.close();
                }
                if (connection != null) {
                    connection.close();
                }
            } catch (SQLException e) {
                System.err.println("Error closing resources: " + e.getMessage());
            }
        }
    }

    public static void update(String table, HashMap<Object, Object> updates, HashMap<Object, Object> conditions) {
        Connection connection = null;
        PreparedStatement preparedStatement = null;
        try {
            connection = getConnection();

            StringBuilder pedaret = new StringBuilder();
            pedaret.append("UPDATE ").append(table).append(" SET ");
            for (Object key : updates.keySet()) {
                pedaret.append(key).append(" = ?, ");
            }
            pedaret.delete(pedaret.length() - 2, pedaret.length());
            if (conditions != null && !conditions.isEmpty()) {
                pedaret.append(" WHERE ");
                for (Object key : conditions.keySet()) {
                    pedaret.append(key).append(" = ? AND ");
                }
                pedaret.delete(pedaret.length() - 5, pedaret.length());
            }

            assert connection != null;
            preparedStatement = connection.prepareStatement(pedaret.toString());
            int k = 1;
            for (Object value : updates.values()) {
                preparedStatement.setObject(k++, value);
            }
            if (conditions != null) {
                for (Object value : conditions.values()) {
                    preparedStatement.setObject(k++, value);
                }
            }

            System.out.println(preparedStatement);
            int rowsAffected = preparedStatement.executeUpdate();
            if (rowsAffected > 0) {
                System.out.println("Data updated successfully.");
            } else {
                System.out.println("Failed to update data.");
            }
        } catch (SQLException e) {
            System.err.println("SQL exception occurred: " + e.getMessage());
        } catch (Exception e) {
            System.err.println("An error occurred: " + e.getMessage());
        } finally {
            try {
                if (preparedStatement != null) {
                    preparedStatement.close();
                }
                if (connection != null) {
                    connection.close();
                }
            } catch (SQLException e) {
                System.err.println("Error closing resources: " + e.getMessage());
            }
        }
    }
    public static void delete(String table, HashMap<Object, Object> conditions) {
        Connection connection = null;
        PreparedStatement preparedStatement = null;
        try {
            connection = getConnection();

            StringBuilder pedaret = new StringBuilder();
            pedaret.append("DELETE FROM ").append(table);
            if (conditions != null && !conditions.isEmpty()) {
                pedaret.append(" WHERE ");
                for (Object key : conditions.keySet()) {
                    pedaret.append(key).append(" = ? AND ");
                }
                pedaret.delete(pedaret.length() - 5, pedaret.length());
            }

            assert connection != null;
            preparedStatement = connection.prepareStatement(pedaret.toString());

            if (conditions != null) {
                int k = 1;
                for (Object value : conditions.values()) {
                    preparedStatement.setObject(k++, value);
                }
            }

            System.out.println(preparedStatement);
            int rowsAffected = preparedStatement.executeUpdate();
            if (rowsAffected > 0) {
                System.out.println("Data deleted successfully.");
            } else {
                System.out.println("Failed to delete data.");
            }
        } catch (SQLException e) {
            System.err.println("SQL exception occurred: " + e.getMessage());
        } catch (Exception e) {
            System.err.println("An error occurred: " + e.getMessage());
        } finally {
            try {
                if (preparedStatement != null) {
                    preparedStatement.close();
                }
                if (connection != null) {
                    connection.close();
                }
            } catch (SQLException e) {
                System.err.println("Error closing resources: " + e.getMessage());
            }
        }
    }
    public static void selectAll(String table) {
        Connection connection = null;
        PreparedStatement preparedStatement = null;
        ResultSet resultSet = null;
        try {
            connection = getConnection();
            String query = "SELECT * FROM " + table;

            assert connection != null;
            preparedStatement = connection.prepareStatement(query);
            resultSet = preparedStatement.executeQuery();

            int columnCount = resultSet.getMetaData().getColumnCount();
            while (resultSet.next()) {
                for (int i = 1; i <= columnCount; i++) {
                    System.out.print(resultSet.getString(i) + " ");
                }
                System.out.println();
            }
        } catch (SQLException e) {
            System.err.println("SQL exception occurred: " + e.getMessage());
        } catch (Exception e) {
            System.err.println("An error occurred: " + e.getMessage());
        } finally {
            try {
                if (resultSet != null) {
                    resultSet.close();
                }
                if (preparedStatement != null) {
                    preparedStatement.close();
                }
                if (connection != null) {
                    connection.close();
                }
            } catch (SQLException e) {
                System.err.println("Error closing resources: " + e.getMessage());
            }
        }
    }


}
