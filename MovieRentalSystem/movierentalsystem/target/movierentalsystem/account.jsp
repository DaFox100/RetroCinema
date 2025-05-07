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
  </style>
</head>
<body>

<div class="menu-bar">
  <a href="movies">Home</a>
  <a href="account.jsp" class="active">Account</a>
</div>

<div class="container">
  <h1 class="neon">Account Lookup</h1>

  <form action="account" method="get">
    <label for="customerId">Enter your Customer ID:</label><br/>
    <input type="number" placeholder="EX: 123" name="customerId" id="customerId" required />
    <button type="submit" style="padding: 12px 30px; font-size: 1.1rem; background: #0ff; border: none; color: #000; cursor: pointer;
    font-family: 'Orbitron', sans-serif;
    text-shadow: 0 0 5px #0ff, 0 0 10px #0ff;
    box-shadow: 0 0 10px #0ff, 0 0 20px #f0f; border-radius: 5px;">View My Rentals</button>
  </form>
 



<% String error = (String) request.getAttribute("error");
   if (error != null) { %>
    <p style="color: red;"><%= error %></p>
<% } else {
   List<String[]> rentals = (List<String[]>) request.getAttribute("rentals");
   Integer customerId = (Integer) request.getAttribute("customerId");

   if (rentals != null && !rentals.isEmpty()) { %>
    <h1>Customer <%= customerId %>'s Current Rentals</h1>
    <table>
        <tr>
            <th>Title</th>
            <th>Movie ID</th>
            <th>Rented Date</th>
        </tr>
        <% for (String[] row : rentals) { %>
        <tr>
            <td><%= row[0] %></td>
            <td><%= row[1] %></td>
            <td><%= row[2] %></td>
            <td>
                <form method="post" action="ReturnServlet" style="margin: 0;"
                    onsubmit="return showConfirmModal(this);">
                    <input type="hidden" name="movieId" value="<%= row[1] %>" />
                    <input type="hidden" name="customerId" value="<%= customerId %>" />

                    <label for="rating" style="color:#fff; font-size: 0.9rem;">Rate (0-100):</label>
                    <input type="number" name="rating" min="0" max="100" required
                                 style="width: 60px; padding: 5px; margin-right: 10px;" />

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
<% } else if (customerId != null) { %>
    <h2>No current rentals found for customer <%= customerId %>.</h2>
<% } } %>

</div>
<!-- Custom Return Confirmation Modal -->
<div id="confirmModal" style="display:none; position:fixed; top:0; left:0; width:100%; height:100%;
     background:rgba(0,0,0,0.8); z-index:1000; justify-content:center; align-items:center; font-family:'Orbitron', sans-serif;">
  <div style="background:#111; padding:30px; border:2px solid #0ff; border-radius:10px; text-align:center; box-shadow: 0 0 20px #0ff;">
    <h2 class="neon">Confirm Return</h2>
    <p style="color:#fff;">Are you sure you want to return this movie and submit your rating?</p>
    <div style="margin-top: 20px;">
      <button id="confirmYes" style="padding:10px 20px; background:#0ff; border:none; color:#000; font-weight:bold; margin-right:10px; cursor:pointer;">
        Yes
      </button>
      <button id="confirmNo" style="padding:10px 20px; background:#f00; border:none; color:#fff; font-weight:bold; cursor:pointer;">
        No
      </button>
    </div> 
  </div>
</div>


  


<script>
    let pendingForm = null;
  
    function showConfirmModal(form) {
      pendingForm = form;
      document.getElementById('confirmModal').style.display = 'flex';
      return false; // Prevent default submit
    }
  
    document.getElementById('confirmYes').onclick = function() {
      if (pendingForm) pendingForm.submit();
      document.getElementById('confirmModal').style.display = 'none';
    };
  
    document.getElementById('confirmNo').onclick = function() {
      document.getElementById('confirmModal').style.display = 'none';
      pendingForm = null;
    };
  </script>
  
</body>
</html>