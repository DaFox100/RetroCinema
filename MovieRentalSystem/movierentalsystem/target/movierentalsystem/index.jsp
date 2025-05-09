<%@ page import="java.util.*, com.movierental.Movie, java.util.stream.*" %>
<%@ page import="org.apache.commons.lang3.StringEscapeUtils" %>

<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>Retro Cinema</title>
  <link href="https://fonts.googleapis.com/css2?family=Orbitron:wght@500&display=swap" rel="stylesheet">
  <style>
    body {
      margin: 0;
      padding: 0;
      font-family: 'Orbitron', sans-serif;
      background-color: #111;
      color: #fff;
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
      z-index: 1000;
      border-bottom: 2px solid #0ff;
    }
    .menu-bar a {
      color: #0ff;
      font-size: 1.1rem;
      text-decoration: none;
      transition: all 0.3s ease;
    }
    .menu-bar a:hover {
      color: #f0f;
      text-shadow: 0 0 5px #f0f, 0 0 10px #0ff;
    }
    .image-section {
      text-align: center;
      padding: 40px;
    }
    .image-section img {
      max-width: 80%;
      border: 4px solid #f0f;
      box-shadow: 0 0 20px #f0f, 0 0 40px #0ff;
    }
    .Top-Ranked-Movies {
      width: 90%;
      margin: 40px auto;
      border-collapse: collapse;
      background-color: rgba(255, 255, 255, 0.05);
      box-shadow: 0 0 15px #0ff;
    }
    .Top-Ranked-Movies th,
    .Top-Ranked-Movies td {
      border: 1px solid #0ff;
      padding: 20px;
      text-align: center;
      color: #fff;
    }
    .Top-Ranked-Movies th {
      background-color: rgba(0, 255, 255, 0.1);
      font-size: 1.2rem;
      color: #0ff;
      text-shadow: 0 0 5px #0ff;
    }
    .Top-Ranked-Movies tr:hover {
      background-color: rgba(255, 0, 255, 0.1);
    }
    .movie-grid {
      display: grid;
      grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
      gap: 30px;
      margin-top: 30px;
      padding: 0 40px;
    }
    .movie-card {
      background-color: #222;
      border: 2px solid #0ff;
      box-shadow: 0 0 15px #0ff;
      padding: 15px;
      border-radius: 10px;
      text-align: center;
    }
    .movie-card:hover {
    border-color: #f0f; /* color on hover */
  }
    .movie-card img {
      width: 100%;
      max-height: 300px;
      object-fit: cover;
      border-radius: 8px;
      box-shadow: 0 0 10px #f0f;
    }
    .movie-card h2 {
      margin: 10px 0 5px;
      color: #0ff;
    }
    .movie-card p {
      margin: 5px 0;
      font-size: 0.9rem;
    }
    .active {
      color: #0ff;
      text-shadow: 0 0 10px #0ff;
    }
    #searchBar {
  transition: opacity 0.4s ease;
  opacity: 0;
  display: none;
}

#searchBar.show {
  display: block;
  opacity: 1;
}




    .load-button {
      display: block;
      margin: 20px auto;
      padding: 10px 30px;
      font-size: 1.2rem;
      background-color: #0ff;
      color: #000;
      border: none;
      border-radius: 8px;
      cursor: pointer;
      font-family: 'Orbitron', sans-serif;
      box-shadow: 0 0 10px #0ff, 0 0 20px #f0f;
    }

.popup-overlay {
  position: fixed;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  background: rgba(0, 0, 0, 0.85);
  display: flex;
  justify-content: center;
  align-items: center;
  z-index: 1000;
}

.popup-box {
  background-color: #222;
  border: 2px solid #f0f;
  padding: 30px;
  border-radius: 10px;
  text-align: center;
  box-shadow: 0 0 15px #0ff, 0 0 30px #f0f;
}

.neon-border {
  color: #fff;
  text-shadow: 0 0 5px #f0f, 0 0 10px #f0f, 0 0 20px #0ff, 0 0 40px #0ff;
}

.close-btn {
  margin-top: 20px;
  padding: 10px 20px;
  font-family: 'Orbitron', sans-serif;
  font-size: 16px;
  background-color: #000;
  color: #0ff;
  border: 2px solid #0ff;
  border-radius: 5px;
  cursor: pointer;
  box-shadow: 0 0 10px #0ff;
}

.close-btn:hover {
  background-color: #0ff;
  color: #000;
}

  </style>
  <script>
    function showPoster(url) {
      const img = document.getElementById('movie-poster');
      img.src = url || 'https://placehold.co/300x400?text=No+Image';
    }

    let selectedMovieId = null;

function selectMovie(id, title) {
    selectedMovieId = id;
    document.getElementById("selectedMovieId").value = id;
    document.getElementById("rentButton").style.display = "block";
    document.getElementById("rentalPrompt").style.display = "none";
    console.log(`Selected movie: ${title} (ID: ${id})`);
}

function showRentalPrompt() {
    const selectedMovieId = document.getElementById("selectedMovieId").value;
    if (!selectedMovieId) {
      alert("Please select a movie before renting.");
      return;
    }
    document.getElementById("rentalPrompt").style.display = "block";
  }

  function toggleSearch() {
  const bar = document.getElementById("searchBar");
  if (bar.classList.contains("show")) {
    bar.classList.remove("show");
    setTimeout(() => bar.style.display = "none", 400);
  } else {
    bar.style.display = "block";
    setTimeout(() => bar.classList.add("show"), 10);
  }
}


  function scrollToPoster() {
    const libraryHeading = document.getElementById("movie-poster");
    if (libraryHeading) {
      libraryHeading.scrollIntoView({ behavior: "smooth" });
    }
  }


  </script>
</head>
<body>
  <nav class="menu-bar neon">
    <a href="movies" class="<%= request.getParameter("query") == null ? "active" : "" %>">Home</a>
    <a href="#movie-library">Movies</a>
    <a href="#" onclick="toggleSearch()" id="searchToggle">Search</a>
    <a href="account.jsp">Account</a>
    <a href="about.jsp">About</a>
    
  </nav>

  <% String error = request.getParameter("error"); %>
  <% if ("outofstock".equals(error)) { %>
    <div id="popup" class="popup-overlay">
      <div class="popup-box neon-border">
        <h2 class="neon">Out of Stock</h2>
        <p>Sorry, this movie is currently out of stock!</p>
        <button onclick="document.getElementById('popup').style.display='none'" class="close-btn">Close</button>
      </div>
    </div>
  <% } %>
  
  <%
    List<Movie> movies = (List<Movie>) request.getAttribute("movies");
    Movie topMovie = null;
    try {
      if (movies != null && !movies.isEmpty()) {
        topMovie = movies.stream().max(Comparator.comparingDouble(Movie::getRating)).orElse(null);
      }
    } catch (Exception e) {
      topMovie = null;
    }
  %>
  <div id="searchBar" style="display: none; text-align: center; margin-top: 20px;">
    <form action="movies" method="get">
      <input type="text" name="query" placeholder="Search by title or genre..."
             value="<%= request.getParameter("query") != null ? request.getParameter("query") : "" %>"
             style="padding: 10px; width: 300px; font-family: 'Orbitron'; border-radius: 5px; border: 1px solid #0ff;
                    background: #111; color: #fff; box-shadow: 0 0 10px #0ff;">
      <button type="submit"
              style="padding: 10px 25px; background: #0ff; color: #000; font-family: 'Orbitron'; font-weight: bold;
                     border: none; border-radius: 5px; cursor: pointer; box-shadow: 0 0 10px #0ff, 0 0 20px #f0f;">
        Go
      </button>
    </form>
  </div>
  
  <h2 class="neon" style="text-align: center; margin-top: 40px;">All Movies Rent Free!!!</h2>
  <h3 class="neon" style="text-align: center; margin-top: 40px;">You're Welcome!</h3>
  <div class="image-section">
    <img id="banner-image"
         src="<%= (topMovie != null && topMovie.getUrl() != null && !topMovie.getUrl().isEmpty()) 
                 ? topMovie.getUrl() 
                 : "https://placehold.co/1000x400?text=Retro+Cinema" %>"
         alt="Top Ranked Movie Poster">
  </div>
  <%
    if (movies != null && !movies.isEmpty()) {
      List<Movie> sorted = new ArrayList<>(movies);
      sorted.sort((a, b) -> Double.compare(b.getRating(), a.getRating()));
  %>


 <h2 class="neon" style="text-align: center; margin-top: 40px;">Top Rated Movies</h2>
  <table class="Top-Ranked-Movies">
    <thead>
      <tr><th>ID</th><th>Title</th><th>Rating</th></tr>
    </thead>
    <tbody >
      <% for (int i = 0; i < Math.min(5, sorted.size()); i++) {
           Movie m = sorted.get(i); %>
        <tr onclick="selectMovie('<%= m.getId() %>', '<%= StringEscapeUtils.escapeEcmaScript(m.getTitle()) %>'),showPoster('<%= m.getUrl()%>'),scrollToPoster()">
          <td><%= m.getId() %></td>
          <td><%= m.getTitle() %></td>
          <td><%= m.getRating() %></td>
        </tr>
      <% } %>
    </tbody>
  </table>

  
  <div id="movie-library" style="padding: 40px; display: flex; justify-content: center; gap: 50px;">
  <div style="flex: 1; max-height: 900px; overflow-y: auto;">
    <table class="Top-Ranked-Movies">
      <h2 class="neon" style="text-align: center; margin-top: 40px;">Movies</h2>
      <thead>
        <tr><th>ID</th><th>Title</th><th>Genre</th><th>Total Copies</th><th>Copies Rented</th></tr>
      </thead>
      <tbody>
        <% for (Movie m : movies) { %>
          <tr onclick="selectMovie('<%= m.getId() %>', '<%= StringEscapeUtils.escapeEcmaScript(m.getTitle()) %>'),showPoster('<%= m.getUrl()%>')">
            <td><%= m.getId() %></td>
            <td><%= m.getTitle() %></td>
            <td><%= m.getGenre() %></td>
            <td><%= m.getTotalCopies() %></td>
            <td><%= m.getCopiesRented() %></td>
          </tr>
        <% } %>
      </tbody>
    </table>
  </div>
  <div style="flex: 0.6; text-align: center;">
  <img id="movie-poster" src="https://placehold.co/300x400?text=Select+Movie" alt="Movie Poster" style="width: 100%; border: 4px solid #f0f; box-shadow: 0 0 20px #f0f;">
  <br><br>
 
  <div id="rentButton" style="text-align: center; margin-top: 20px;">
    <button onclick="showRentalPrompt()" 
            style="padding: 12px 30px; font-size: 1.1rem; background: #0ff; border: none; color: #000; cursor: pointer;
                   font-family: 'Orbitron', sans-serif;
                   text-shadow: 0 0 5px #0ff, 0 0 10px #0ff;
                   box-shadow: 0 0 10px #0ff, 0 0 20px #f0f; border-radius: 5px;">
      Rent
    </button>
  </div>
  
  <div id="rentalPrompt" style="display: none; text-align: center; margin-top: 30px;">
    <form action="RentServlet" method="POST" style="display: inline-block; background-color: #222; padding: 20px; border-radius: 10px; box-shadow: 0 0 10px #0ff;">
      <input type="hidden" name="movieId" id="selectedMovieId">
  
      <label for="customerId" style="display: block; margin-bottom: 10px; font-family: 'Orbitron', sans-serif; color: #fff;">
        Enter Customer ID:
      </label>
  
      <input type="number" name="customerId" required min="0"
             style="padding: 10px; width: 200px; border: 1px solid #0ff; background-color: #111; color: #fff;
                    font-family: 'Orbitron', sans-serif; border-radius: 4px; margin-bottom: 15px;">
  
      <br>
  
      <button type="submit"
              style="padding: 10px 25px; font-size: 1rem; background: #0ff; border: none; color: #000; cursor: pointer;
                     font-family: 'Orbitron', sans-serif;
                     text-shadow: 0 0 5px #0ff, 0 0 10px #0ff;
                     box-shadow: 0 0 10px #0ff, 0 0 20px #f0f; border-radius: 5px;">
        Confirm Rental
      </button>
    </form>
  </div>
  
</div>
</div>  


  <h2 class="neon" style="text-align: center; margin-top: 40px;">Movie Library</h2>
  <div class="movie-grid">
    <% for (Movie m : movies) { %>
      <div class="movie-card" onclick="selectMovie('<%= m.getId() %>', '<%= StringEscapeUtils.escapeEcmaScript(m.getTitle()) %>'),showPoster('<%= m.getUrl()%>'), scrollToPoster()">
        <img src="<%= m.getUrl() %>" alt="Movie Poster">
        <h2><%= m.getTitle() %></h2>
        <p><strong>Genre:</strong> <%= m.getGenre() %></p>
        <p><strong>Total Copies:</strong> <%= m.getTotalCopies() %></p>
        <p><strong>Rating:</strong> <%= String.format("%.1f", m.getRating()) %></p>
      </div>
    <% } %>
  </div>
  <% } %>


<script>
     
</script>
</body>
</html>