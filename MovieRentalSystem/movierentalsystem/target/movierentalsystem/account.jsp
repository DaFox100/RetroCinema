
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
    .neon {
  text-shadow:
    0 0 5px #f0f,
    0 0 10px #f0f,
    0 0 20px #f0f,
    0 0 40px #0ff,
    0 0 80px #0ff;
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

    .neon-button {
  background-color: #111;
  color: #0ff;
  border: 2px solid #0ff;
  padding: 10px 20px;
  font-size: 1rem;
  border-radius: 10px;
  cursor: pointer;
  box-shadow: 0 0 5px #0ff, 0 0 10px #0ff, 0 0 20px #0ff;
  transition: all 0.3s ease;
}

.neon-button:hover {
  background-color: #0ff;
  color: #111;
  box-shadow: 0 0 10px #0ff, 0 0 20px #0ff, 0 0 30px #0ff;
}

@keyframes neon-glow {
  0%   { box-shadow: 0 0 5px #0f0; }
  50%  { box-shadow: 0 0 20px #0f0, 0 0 30px #0f0; }
  100% { box-shadow: 0 0 5px #0f0; }
}

.glow-flash {
  animation: neon-glow 2s ease-in-out 2;
}


  </style>
</head>
<body>

<!-- Navigation menu -->
<div class="menu-bar">
  <a href="movies">Home</a>
  <a href="account.jsp" class="active">Account</a>
  <a href="about.jsp" class="active">about</a>
</div>

<!-- Main content container -->
<div class="container">
  <h1 class="neon">Account Lookup</h1>

  <!-- Form to lookup account by customer ID -->
  <form action="account" method="get">
    <label for="customerId">Enter your Customer ID:</label><br/>
    <input type="number" placeholder="EX: 123" name="customerId" id="customerId" required />
    <button type="submit">View My Rentals</button>
  </form>

  <%-- Show message if customer ID is invalid --%>
  <% if ("invalid_customer".equals(request.getParameter("error"))) { %>
    <div style="background:#111; border:2px solid #f00; color:#fff; padding:15px; margin:20px auto; width:80%; text-align:center; font-family:'Orbitron', sans-serif;">
      <p style="color:#f00; font-weight:bold;">Invalid Customer ID</p>
      <p>It looks like you don't have an account. Would you like to <a href="createAccount.jsp" style="color:#0ff; text-decoration:underline;">create one now</a>?</p>
    </div>
  <% } %>

  <%-- Show message if account was just created --%>
  <%
    String newCustomer = request.getParameter("new");
    String newCustomerId = request.getParameter("customerId");
    if ("true".equals(newCustomer) && newCustomerId != null) {
  %>
    <div id="newCustomerMessage">
        <p>Account Created Successfully!</p>
        <p>Your Customer ID is: <%= newCustomerId %></p>
        <p>Please use this ID to rent movies in the future.</p>
    </div>
  <%
    }
  %>

  <%-- Show request-scoped error if present --%>
  <% String error = (String) request.getAttribute("error");
     if (error != null) { %>
    <p style="color: red;"><%= error %></p>
  <% 
  } else {
     List<String[]> rentals = (List<String[]>) request.getAttribute("rentals");
     List<String[]> pastRentals = (List<String[]>) request.getAttribute("pastRentals");
     Integer customerId = (Integer) request.getAttribute("customerId");

     // Only show account info if a valid customerId was set
     if (customerId != null) {
  %>

    <!-- Display account information -->
    <h1>Welcome, <%= request.getAttribute("firstName") %> <%= request.getAttribute("lastName") %></h1>
    <h2>Your account information</h2>
    <table>
      <tr>
        <th>Customer ID</th>
        <th>Name</th>
        <th>Email</th>
        <th>Address</th>
      </tr>
      <tr>
        <td><%= request.getAttribute("customerId") %></td>
        <td><%= request.getAttribute("firstName") %><%= request.getAttribute("lastName") %></td>
        <td><%= request.getAttribute("email") %></td>
        <td><%= request.getAttribute("address") %></td>
      </tr>
    </table>

    <!-- Show current rentals -->
    <h2>Your current rental</h2>
    <table>
        <tr>
          <th>Title</th>
          <th>Movie ID</th>  
          <th>Rented Date</th>
          <th>Rate/Return</th>
        </tr>
        <% 
          if (rentals != null && !rentals.isEmpty()) {
          for (String[] row : rentals) { 
        %>
        <tr>
            <td><%= row[0] %></td>
            <td><%= row[1] %></td>
            <td><%= row[2] %></td>
            <td>
                <!-- Return form with rating input -->
                <form method="post" action="ReturnServlet" onsubmit="return showConfirmModal(this,'Are you sure you want to return this movie and submit your rating?');">
                    <input type="hidden" name="movieId" value="<%= row[1] %>" />
                    <input type="hidden" name="customerId" value="<%= customerId %>" />
                    <label for="rating">Rate (0-100):</label>
                    <input type="number" name="rating" min="0" max="100" required />
                    <button type="submit">Return</button>
                </form>
              </td>
        </tr>
        <% 
          } 
        } else {
        %>
        <tr>
          <td colspan="4">No current rentals found.</td>
        </tr>
        <% } %>
    </table>

    <!-- Show past rentals -->
    <h2>Your rental history</h2>
    <table>
      <tr>
        <th>Movie ID</th>
        <th>Title</th>
        <th>Rented Date</th>
        <th>Returned Date</th>
      </tr>
      <% 
        if (pastRentals != null && !pastRentals.isEmpty()) {
          for (String[] row : pastRentals) { 
      %>
        <tr>
          <td><%= row[0] %></td>
          <td><%= row[1] %></td>
          <td><%= row[2] %></td>
          <td><%= row[3] %></td>
        </tr>
      <% 
          }
        } else {
      %>
        <tr>
          <td colspan="4">No past rentals found.</td>
        </tr>
      <% } %>
    </table>

    <!-- Remove rental history form -->
    <form id="removeHistoryForm" action="removeHistory" method="POST"
          onsubmit="return showConfirmModal(this, 'Are you sure you want to delete your rental history? This action cannot be undone.');">
      <input type="hidden" name="customerId" value="<%= request.getAttribute("customerId") %>">
      <button type="submit" class="neon-button">Remove Rental History</button>
    </form>

  <% 
    } else {
  %>
    <h2>No customer account is selected.</h2>
  <% 
    }
  } 
  %>
</div>

<!-- Modal confirmation dialog -->
<div id="confirmModal" style="display:none;">
  <div>
    <h2 class="neon">Confirm Action</h2>
    <p id="confirmText"></p>
    <button id="confirmYes">Yes</button>
    <button id="confirmNo">No</button>
  </div>
</div>

<script>
  // JavaScript for confirmation modal
  let pendingForm = null;

  function showConfirmModal(form, message) {
    pendingForm = form;
    document.getElementById("confirmText").innerText = message;
    document.getElementById("confirmModal").style.display = "flex";
    return false;
  }

  document.addEventListener("DOMContentLoaded", function () {
    document.getElementById("confirmYes").onclick = function () {
      if (pendingForm) pendingForm.submit();
      document.getElementById("confirmModal").style.display = "none";
    };

    document.getElementById("confirmNo").onclick = function () {
      document.getElementById("confirmModal").style.display = "none";
      pendingForm = null;
    };

    // Animate scroll and glow for new account message
    const msg = document.getElementById("newCustomerMessage");
    if (msg) {
      msg.scrollIntoView({ behavior: "smooth", block: "center" });
      msg.classList.add("glow-flash");
    }
  });
</script>

</body>
</html>
