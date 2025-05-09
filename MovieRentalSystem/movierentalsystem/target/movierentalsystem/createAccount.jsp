<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>Create Account</title>
  <link href="https://fonts.googleapis.com/css2?family=Orbitron:wght@500&display=swap" rel="stylesheet">
  <style>
    body {
      margin: 0;
      padding: 0;
      background-color: #111;
      color: #fff;
      font-family: 'Orbitron', sans-serif;
    }

    .container {
      max-width: 500px;
      margin: 80px auto;
      padding: 40px;
      border: 2px solid #0ff;
      border-radius: 15px;
      box-shadow: 0 0 15px #0ff;
      background-color: #222;
      text-align: center;
      box-sizing: border-box;
    }

    h1 {
      color: #0ff;
      text-shadow: 0 0 10px #0ff, 0 0 20px #f0f;
      margin-bottom: 30px;
    }

    .form-group {
      text-align: left;
      margin-bottom: 20px;
    }

    .form-group label {
      display: block;
      margin-bottom: 5px;
    }

    .form-group input {
      display: block;
      width: 100%;
      padding: 12px;
      background-color: #111;
      color: #0ff;
      border: 2px solid #0ff;
      border-radius: 8px;
      font-size: 16px;
      font-family: 'Orbitron', sans-serif;
      box-shadow: 0 0 10px #0ff inset;
      box-sizing: border-box;
    }

    input::placeholder {
      color: #888;
    }

    button {
      width: 100%;
      padding: 12px;
      background-color: #0ff;
      color: #111;
      font-weight: bold;
      border: none;
      border-radius: 8px;
      font-size: 16px;
      cursor: pointer;
      transition: all 0.3s ease;
      box-shadow: 0 0 10px #0ff, 0 0 20px #0ff;
      font-family: 'Orbitron', sans-serif;
    }

    button:hover {
      background-color: #111;
      color: #0ff;
      box-shadow: 0 0 15px #0ff, 0 0 30px #0ff;
    }

    .back-link {
      margin-top: 15px;
      display: inline-block;
      color: #0ff;
      text-decoration: underline;
      font-size: 0.9rem;
    }

    .back-link:hover {
      text-shadow: 0 0 10px #0ff;
    }
  </style>
</head>
<body>

  <div class="container">
    <h1>Create New Account</h1>
    <form action="CreateAccountServlet" method="post">
      <div class="form-group">
        <label for="firstName">First Name</label>
        <input type="text" name="firstName" id="firstName" placeholder="John" required>
      </div>

      <div class="form-group">
        <label for="lastName">Last Name</label>
        <input type="text" name="lastName" id="lastName" placeholder="Doe" required>
      </div>

      <div class="form-group">
        <label for="email">Email</label>
        <input type="email" name="email" id="email" placeholder="example@email.com" required>
      </div>

      <div class="form-group">
        <label for="address">Address</label>
        <input type="text" name="address" id="address" placeholder="123 Movie Lane" required>
      </div>

      <button type="submit">Create Account</button>
    </form>
    <a class="back-link" href="index.jsp">← Back to Home</a>
  </div>

</body>
</html>
