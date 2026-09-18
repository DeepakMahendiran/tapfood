<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import ="java.util.List, com.tap.model.Restaurant, com.tap.model.User" %>

<%
List<Restaurant> allRestaurants=(List<Restaurant>)request.getAttribute("allRestaurants");
if (allRestaurants == null) {
    response.sendRedirect("restaurant");
    return;
}
User loggedInUser = (User) session.getAttribute("loggedInUser");
request.setAttribute("activePage", "restaurant");
%>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>TapFood — Food delivery from local restaurants</title>
<meta name="description" content="Order food online from the best restaurants near you.">

<%@ include file="/WEB-INF/jspf/head-assets.jspf" %>

</head>
<body>

<%@ include file="/WEB-INF/jspf/header.jspf" %>

<!-- Hero -->
<section class="hero">
  <div class="hero-inner">

    <div class="hero-copy">
      <span class="eyebrow"><i class="fa-solid fa-bolt"></i> Delivery in 30 minutes or less</span>
      <h1>Good food,<br>delivered <em>fast.</em></h1>
      <p>Order from <%=allRestaurants.size()%>+ restaurants around you — from crispy dosas to loaded biryanis.</p>

      <div class="search-box">
        <i class="fa-solid fa-magnifying-glass"></i>
        <input type="text" id="restaurantSearchInput" placeholder="Search for restaurants or cuisines"
               oninput="filterRestaurants()" onkeydown="if(event.key==='Enter')filterRestaurants()">
        <button type="button" onclick="filterRestaurants()">Search</button>
      </div>

      <div class="hero-stats">
        <div class="hero-stat"><div class="num"><%=allRestaurants.size()%>+</div><div class="lbl">Restaurants</div></div>
        <div class="hero-stat"><div class="num">30 min</div><div class="lbl">Avg. delivery</div></div>
        <div class="hero-stat"><div class="num">4.6</div><div class="lbl">Avg. rating</div></div>
      </div>
    </div>

    <div class="hero-visual">
      <img src="images/hero.jpg" alt="Fresh food spread" onerror="this.src='images/biryani.jpg'">
      <div class="hero-chip tl">
        <i class="fa-solid fa-motorcycle"></i>
        <div>Order on the way<span class="sub">Arriving in 12 min</span></div>
      </div>
      <div class="hero-chip br">
        <i class="fa-solid fa-star"></i>
        <div>4.8 rated<span class="sub">Urban Biryani</span></div>
      </div>
    </div>

  </div>
</section>

<!-- Cuisine filter chips -->
<div class="cuisine-row" id="cuisineRow">
  <span class="cuisine-chip active" data-cuisine="">All</span>
  <span class="cuisine-chip" data-cuisine="south indian">South Indian</span>
  <span class="cuisine-chip" data-cuisine="biryani,mughlai">Biryani</span>
  <span class="cuisine-chip" data-cuisine="pizza,italian">Pizza</span>
  <span class="cuisine-chip" data-cuisine="burger,fast food">Burgers</span>
  <span class="cuisine-chip" data-cuisine="chinese">Chinese</span>
  <span class="cuisine-chip" data-cuisine="north indian,tandoor">North Indian</span>
  <span class="cuisine-chip" data-cuisine="cafe">Cafe</span>
  <span class="cuisine-chip" data-cuisine="ice cream,dessert,sweet">Desserts</span>
</div>

<div class="section-head">
  <h2>Restaurants near you</h2>
  <span id="restCount"><%=allRestaurants.size()%> places</span>
</div>

<section class="restaurant-container" id="restaurantGrid">

<%
int rIndex = 0;
for(Restaurant restaurant:allRestaurants) {
    String imgPath = restaurant.getImagePath();
    if (imgPath == null || imgPath.trim().isEmpty() || imgPath.equalsIgnoreCase("null")) {
        imgPath = "images/restaurant.jpg";
    }
    String cuisine = restaurant.getCuisineType() != null ? restaurant.getCuisineType() : "";
	%>
	<a class="restaurant-card" href="menu?restaurantId=<%=restaurant.getRestaurantId()%>"
	   data-aos="fade-up" data-aos-delay="<%=(rIndex%4)*70%>"
	   data-name="<%=restaurant.getName().toLowerCase()%>"
	   data-cuisine="<%=cuisine.toLowerCase()%>">

		<div class="rc-img">
			<img src="<%= imgPath %>" alt="<%=restaurant.getName()%>" onerror="this.src='images/restaurant.jpg'">
			<span class="rc-time"><i class="fa-regular fa-clock"></i><%= restaurant.getDeliveryTime() %> min</span>
		</div>

		<div class="rc-body">
			<div class="rc-top">
				<h2><%= restaurant.getName()%></h2>
				<span class="rc-rating"><i class="fa-solid fa-star"></i><%= restaurant.getRating() %></span>
			</div>
			<p class="rc-cuisine"><%= cuisine %></p>
			<p class="rc-addr"><%= restaurant.getAddress() %></p>
		</div>

	</a>
	<%
    rIndex++;
}%>

  <div class="no-results" id="noResults">No restaurants match your search. Try a different name or cuisine.</div>

</section>

<script>
function applyFilters() {
  var query  = document.getElementById('restaurantSearchInput').value.trim().toLowerCase();
  var active = document.querySelector('.cuisine-chip.active');
  var cui    = active ? active.getAttribute('data-cuisine') : '';
  var shown  = 0;

  document.querySelectorAll('.restaurant-card').forEach(function(card) {
    var name    = card.getAttribute('data-name') || '';
    var cuisine = card.getAttribute('data-cuisine') || '';
    var matchQ  = !query || name.indexOf(query) !== -1 || cuisine.indexOf(query) !== -1;
    var matchC  = !cui || cui.split(',').some(function (k) {
      k = k.trim();
      return cuisine.indexOf(k) !== -1 || name.indexOf(k) !== -1;
    });
    var show    = matchQ && matchC;
    card.style.display = show ? '' : 'none';
    if (show) shown++;
  });

  document.getElementById('noResults').style.display = shown === 0 ? 'block' : 'none';
  document.getElementById('restCount').textContent = shown + (shown === 1 ? ' place' : ' places');
}

function filterRestaurants() { applyFilters(); }

document.querySelectorAll('.cuisine-chip').forEach(function(chip) {
  chip.addEventListener('click', function() {
    document.querySelectorAll('.cuisine-chip').forEach(function(c) { c.classList.remove('active'); });
    chip.classList.add('active');
    applyFilters();
  });
});
</script>

<%@ include file="/WEB-INF/jspf/footer.jspf" %>

</body>
</html>
