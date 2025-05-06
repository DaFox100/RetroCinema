<%@ page import="java.util.*, java.sql.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>Account Lookup</title>
  <link href="https://fonts.googleapis.com/css2?family=Orbitron:wght@500&display=swap" rel="stylesheet">
  <style>
    body {
      margin: 0;
      padding: 0;
      background-color: #111;
      color: #fff;
      font-family: 'Orbitron', sans-serif;
    }

    .neon {
      text-shadow: 0 0 5px #f0f, 0 0 10px #f0f, 0 0 20px #f0f, 0 0 40px #0ff, 0 0 80px #0ff;
    }

    .menu-bar {
      background-color: #000;
      padding: 15px 0;
      display: flex;
      justify-content: center;
      gap: 60px;
      position: sticky;
      top: 0;
      z-index: 100;
    }

    .menu-bar a {
      color: #fff;
      text-decoration: none;
      font-size: 20px;
      transition: color 0.3s ease;
    }

    .menu-bar a:hover,
    .menu-bar a.active {
      color: #0ff;
      text-shadow: 0 0 10px #0ff, 0 0 20px #0ff;
    }

    .container {
      max-width: 900px;
      margin: auto;
      padding: 40px 20px;
      text-align: center;
    }

    form {
      margin-bottom: 30px;
    }

    input[type="number"], button {
      padding: 12px 18px;
      font-size: 16px;
      margin: 5px;
      border: none;
      border-radius: 5px;
    }

    input[type="number"] {
      width: 250px;
    }

    button {
      background-color: #0ff;
      color: #111;
      cursor: pointer;
      font-weight: bold;
    }

    table {
      width: 100%;
      border-collapse: collapse;
      margin-top: 30px;
    }

    th, td {
      border: 1px solid #0ff;
      padding: 10px;
      text-align: center;
    }

    th {
      background-color: #222;
      color: #0ff;
    }

    h1, h2, p {
      margin-bottom: 20px;
    }
  </style>
</head>
<body>

<div class="menu-bar">
  <a href="movies">Home</a>
  <a href="account.jsp" class="active">Account</a>
</div>

<div class="container">
  <h1 class="neon">Account Lookup</h1>

  <form method="get">
    <label for="customerId">Enter your Customer ID:</label><br/>
    <input type="number" name="customerId" id="customerId" required />
    <button type="submit">View My Rentals</button>
  </form>

<%
  String customerIdParam = request.getParameter("customerId");

  if (customerIdParam != null && !customerIdParam.isEmpty()) {
      int customerId = Integer.parseInt(customerIdParam);
      List<String[]> rentals = new ArrayList<>();

      try {
        Class.forName("org.postgresql.Driver");
    } catch (Exception e) {
        System.err.println(e.toString());
    } 
      try (Connection conn = com.movierental.DatabaseConnection.initializeDatabase()) {
          String sql = "SELECT r.movie_id, m.title, r.rented_date " +
                       "FROM rentals r JOIN movies m ON r.movie_id = m.movie_id " +
                       "WHERE r.customer_id = ? ORDER BY r.rented_date DESC";
          PreparedStatement stmt = conn.prepareStatement(sql);
          stmt.setInt(1, customerId);
          ResultSet rs = stmt.executeQuery();

          while (rs.next()) {
              String[] row = {
                  rs.getString("title"),
                  String.valueOf(rs.getInt("movie_id")),
                  String.valueOf(rs.getTimestamp("rented_date"))
              };
              rentals.add(row);
          }

          if (!rentals.isEmpty()) {
%>
            <h2 class="neon">Rentals for Customer ID: <%= customerId %></h2>
            <table>
              <tr>
                <th>Movie Title</th>
                <th>Movie ID</th>
                <th>Rental Date</th>
              </tr>
              <% for (String[] row : rentals) { %>
                <tr>
                  <td><%= row[0] %></td>
                  <td><%= row[1] %></td>
                  <td><%= row[2] %></td>
                  <td>
                    <form method="post" action="ReturnServlet" 
                         style="margin: 0;"
                         onsubmit="return confirm('Are you sure you want to return this movie?');">
                        <input type="hidden" name="movieId" value="<%= row[1] %>" />
                        <input type="hidden" name="customerId" value="<%= customerId %>" />
                         <button type="submit"
                                     style="padding: 6px 12px; font-family: 'Orbitron'; background: #f00; color: #fff;
                                      border: none; border-radius: 5px; cursor: pointer;
                                    text-shadow: 0 0 5px #f00, 0 0 10px #f00;">
                     Return
                         </button>
                    </form>

                  </td>
                </tr>
              <% } %>
            </table>
<%
          } else {
%>
            <p>No rentals found for this customer ID.</p>
<%
          }

      } catch (SQLException e) {
          out.println("<p>Error: " + e.getMessage() + "</p>");
      }
  }
%>

</div>
</body>
</html>
