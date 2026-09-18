<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List, com.tap.model.Restaurant, com.tap.model.Menu, com.tap.model.User, com.tap.model.Cart, com.tap.model.CartItem" %>
<%!
// Resolve a usable image for a menu item: DB path if the file really exists,
// otherwise guess from the item name, otherwise a generic placeholder.
private String resolveItemImage(String dbPath, String itemName, jakarta.servlet.ServletContext ctx) {
    if (dbPath != null && !dbPath.trim().isEmpty() && !dbPath.equalsIgnoreCase("null")) {
        String real = ctx.getRealPath("/" + dbPath);
        if (real != null && new java.io.File(real).exists()) return dbPath;
    }
    String name = itemName == null ? "" : itemName.toLowerCase();
    // try a direct file named after the item, e.g. "Masala Dosa" -> images/masaladosa.jpg / images/dosa.jpg
    String slug = name.replaceAll("[^a-z0-9]", "");
    String[] candidates = { "images/" + slug + ".jpg" };
    for (String c : candidates) {
        String real = ctx.getRealPath("/" + c);
        if (real != null && new java.io.File(real).exists()) return c;
    }
    if (name.contains("dosa") || name.contains("idli") || name.contains("pongal") || name.contains("vada") || name.contains("poori")) return "images/south_indian.jpg";
    if (name.contains("pizza")) return "images/pizza.jpg";
    if (name.contains("burger")) return "images/burger.jpg";
    if (name.contains("biryani") || name.contains("rice")) return "images/biryani.jpg";
    if (name.contains("noodle") || name.contains("manchurian")) return "images/chinese.jpg";
    if (name.contains("cake") || name.contains("sweet") || name.contains("ice cream") || name.contains("brownie") || name.contains("sundae")) return "images/dessert.jpg";
    return "images/food.png";
}

// Simple veg / non-veg detection from the item name.
private boolean isNonVeg(String itemName) {
    String n = itemName == null ? "" : itemName.toLowerCase();
    return n.contains("chicken") || n.contains("mutton") || n.contains("egg") || n.contains("fish")
        || n.contains("prawn") || n.contains("shawarma") || n.contains("pepperoni") || n.contains("bbq")
        || n.contains("tandoori") || n.contains("grill") || n.contains("kebab") || n.contains("meat");
}
%>
<%
User loggedInUser = (User) session.getAttribute("loggedInUser");
Restaurant restaurant = (Restaurant) request.getAttribute("restaurant");
List<Menu> allmenu = (List<Menu>) request.getAttribute("menus");
Cart c = (Cart) session.getAttribute("cart");
int cartCount = 0;
double cartTotal = 0;
if (c != null) {
    cartCount = c.getItems().size();
    cartTotal = c.getTotal();
}
request.setAttribute("activePage", "restaurant");
%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title><%=restaurant != null ? restaurant.getName() : "Menu"%> — TapFood</title>
<meta name="description" content="Order from <%=restaurant != null ? restaurant.getName() : "TapFood"%> on TapFood.">
<%@ include file="/WEB-INF/jspf/head-assets.jspf" %>
<style>
  /* ── Restaurant header ── */
  .rest-head {
    background: var(--card);
    border-bottom: 1px solid var(--line);
  }
  .rest-head-inner {
    max-width: 1120px; margin: 0 auto; padding: 26px 24px 30px;
  }
  .crumb {
    font-size: 13px; color: var(--muted); margin-bottom: 18px;
  }
  .crumb a { color: var(--muted); text-decoration: none; }
  .crumb a:hover { color: var(--brand); }
  .crumb span { margin: 0 6px; }

  .rest-card {
    display: flex; justify-content: space-between; gap: 30px; align-items: flex-start;
  }
  .rest-details h1 {
    font-size: 27px; font-weight: 800; letter-spacing: -0.6px; margin-bottom: 4px;
  }
  .rest-details .cuisine { font-size: 14.5px; color: var(--muted); margin-bottom: 2px; }
  .rest-details .addr    { font-size: 13.5px; color: #9aa1ad; margin-bottom: 14px; }

  .rest-meta {
    display: inline-flex; align-items: center; gap: 0;
    border: 1px solid var(--line); border-radius: 10px; overflow: hidden;
  }
  .rest-meta .m {
    padding: 10px 18px; font-size: 13px; color: var(--muted);
    border-right: 1px solid var(--line);
  }
  .rest-meta .m:last-child { border-right: none; }
  .rest-meta .m b {
    display: block; font-size: 14.5px; color: var(--ink); font-weight: 700; margin-bottom: 1px;
  }
  .rest-meta .m b i { font-size: 12px; }
  .rest-meta .m b .star { color: var(--green); }

  .rest-photo {
    width: 240px; height: 160px; border-radius: 14px; overflow: hidden;
    flex-shrink: 0; border: 1px solid var(--line);
  }
  .rest-photo img { width: 100%; height: 100%; object-fit: cover; }

  /* ── Menu section ── */
  .menu-wrap { max-width: 1120px; margin: 0 auto; padding: 28px 24px 90px; }
  .menu-title {
    font-size: 18px; font-weight: 700; letter-spacing: -0.3px; margin-bottom: 18px;
  }
  .menu-title span { font-size: 13px; font-weight: 500; color: var(--muted); margin-left: 6px; }

  .menu-grid {
    display: grid;
    grid-template-columns: repeat(auto-fill, minmax(280px, 1fr));
    gap: 20px;
  }

  .dish-card {
    background: var(--card); border: 1px solid var(--line); border-radius: var(--radius);
    overflow: hidden; display: flex; flex-direction: column;
    transition: transform 0.2s ease, box-shadow 0.2s ease;
  }
  .dish-card:hover { transform: translateY(-3px); box-shadow: var(--shadow-md); }

  .dish-img { position: relative; height: 170px; overflow: hidden; }
  .dish-img img {
    width: 100%; height: 100%; object-fit: cover; transition: transform 0.35s ease;
  }
  .dish-card:hover .dish-img img { transform: scale(1.04); }

  .diet-mark {
    position: absolute; top: 10px; left: 10px;
    background: #fff; border-radius: 4px; width: 18px; height: 18px;
    display: flex; align-items: center; justify-content: center;
    box-shadow: 0 1px 4px rgba(0,0,0,0.15);
  }
  .diet-mark.veg    { border: 1.5px solid #1e7e34; }
  .diet-mark.nonveg { border: 1.5px solid #c92a2a; }
  .diet-mark .dot   { width: 8px; height: 8px; border-radius: 50%; }
  .diet-mark.veg .dot    { background: #1e7e34; }
  .diet-mark.nonveg .dot { background: #c92a2a; }

  .dish-body { padding: 14px 16px 16px; flex: 1; display: flex; flex-direction: column; }
  .dish-name { font-size: 15.5px; font-weight: 700; margin-bottom: 4px; }
  .dish-desc {
    font-size: 13px; color: var(--muted); line-height: 1.55; flex: 1; margin-bottom: 14px;
    display: -webkit-box; -webkit-line-clamp: 2; -webkit-box-orient: vertical; overflow: hidden;
  }
  .dish-foot { display: flex; align-items: center; justify-content: space-between; }
  .dish-price { font-size: 17px; font-weight: 800; letter-spacing: -0.3px; }

  .add-btn {
    background: #fff; color: var(--brand); border: 1px solid var(--brand);
    padding: 8px 22px; border-radius: 9px; font-size: 13.5px; font-weight: 700;
    font-family: inherit; cursor: pointer; transition: all 0.15s ease;
  }
  .add-btn:hover { background: var(--brand); color: #fff; }

  .qty-counter {
    display: flex; align-items: center; border: 1px solid var(--brand);
    border-radius: 9px; overflow: hidden; background: #fff;
  }
  .counter-btn {
    background: #fff; border: none; color: var(--brand); font-size: 15px; font-weight: 700;
    width: 32px; height: 34px; cursor: pointer;
    display: flex; align-items: center; justify-content: center;
    transition: background 0.15s ease;
  }
  .counter-btn:hover { background: var(--brand-soft); }
  .counter-count { padding: 0 8px; font-size: 14px; font-weight: 700; min-width: 22px; text-align: center; }

  .login-prompt-btn {
    color: var(--brand); border: 1px solid var(--brand); background: #fff;
    padding: 8px 14px; border-radius: 9px; font-size: 12.5px; font-weight: 600;
    text-decoration: none; transition: all 0.15s ease;
  }
  .login-prompt-btn:hover { background: var(--brand); color: #fff; }

  /* ── Sticky cart bar ── */
  .cart-bar {
    position: fixed; bottom: 0; left: 0; right: 0; z-index: 999;
    background: var(--ink); color: #fff;
    display: flex; align-items: center; justify-content: space-between;
    padding: 13px 6%;
    transform: translateY(100%);
    animation: bar-in 0.3s ease forwards;
  }
  @keyframes bar-in { to { transform: translateY(0); } }
  .cart-bar .info { font-size: 14px; font-weight: 600; }
  .cart-bar .info span { color: #b6bcc7; font-weight: 500; margin-left: 8px; font-size: 13px; }
  .cart-bar a {
    background: var(--brand); color: #fff; text-decoration: none;
    padding: 10px 22px; border-radius: 9px; font-size: 14px; font-weight: 700;
    transition: background 0.15s ease;
  }
  .cart-bar a:hover { background: var(--brand-dark); }

  /* ── Toast ── */
  .toast {
    position: fixed; bottom: 84px; left: 50%; transform: translateX(-50%) translateY(16px);
    background: #fff; color: var(--ink); border: 1px solid var(--line);
    padding: 11px 20px; border-radius: 10px; box-shadow: var(--shadow-md);
    font-size: 13.5px; font-weight: 600; opacity: 0; pointer-events: none;
    transition: all 0.3s ease; z-index: 9999; white-space: nowrap;
  }
  .toast i { color: var(--green); margin-right: 7px; }
  .toast.show { opacity: 1; transform: translateX(-50%) translateY(0); }

  @media (max-width: 800px) {
    .rest-card { flex-direction: column-reverse; }
    .rest-photo { width: 100%; height: 180px; }
    .menu-grid { grid-template-columns: 1fr; }
  }
</style>
</head>
<body>

<%@ include file="/WEB-INF/jspf/header.jspf" %>

<% if (restaurant != null) { %>
<!-- Restaurant header -->
<div class="rest-head">
  <div class="rest-head-inner">

    <div class="crumb">
      <a href="restaurant">Restaurants</a><span>/</span><%=restaurant.getName()%>
    </div>

    <div class="rest-card">
      <div class="rest-details">
        <h1><%=restaurant.getName()%></h1>
        <p class="cuisine"><%=restaurant.getCuisineType()%></p>
        <p class="addr"><i class="fa-solid fa-location-dot" style="margin-right:5px;"></i><%=restaurant.getAddress()%></p>

        <div class="rest-meta">
          <div class="m"><b><i class="fa-solid fa-star star"></i> <%=restaurant.getRating()%></b>Rating</div>
          <div class="m"><b><%=restaurant.getDeliveryTime()%> min</b>Delivery time</div>
          <div class="m"><b>&#8377;40</b>Delivery fee</div>
        </div>
      </div>

      <div class="rest-photo">
        <img src="<%=restaurant.getImagePath() != null ? restaurant.getImagePath() : "images/restaurant.jpg"%>"
             onerror="this.src='images/restaurant.jpg'" alt="<%=restaurant.getName()%>">
      </div>
    </div>

  </div>
</div>
<% } %>

<%
String errParam = request.getParameter("error");
if ("diff_restaurant".equals(errParam)) {
%>
<div class="alert warn" style="margin-left:24px;margin-right:24px;">
  <div><i class="fa-solid fa-circle-exclamation" style="margin-right:8px;"></i>
    Your cart has items from another restaurant. Clear it before ordering from here.</div>
  <a href="cart.jsp" class="btn" style="padding:8px 16px;font-size:13px;">Go to cart</a>
</div>
<% } %>

<!-- Menu -->
<div class="menu-wrap">
  <div class="menu-title">Menu <span><%=allmenu != null ? allmenu.size() : 0%> items</span></div>

  <div class="menu-grid">
  <% if (allmenu != null) {
     int mIndex = 0;
     for (Menu menu : allmenu) {
        String itemImg = resolveItemImage(menu.getImagePath(), menu.getItemName(), application);
        boolean nonVeg = isNonVeg(menu.getItemName());

        int itemQtyInCart = 0;
        if (c != null && c.getItems().containsKey(menu.getMenuId())) {
            itemQtyInCart = c.getItems().get(menu.getMenuId()).getQty();
        }
  %>
    <div class="dish-card" data-aos="fade-up" data-aos-delay="<%=(mIndex%4)*60%>">
      <div class="dish-img">
        <img src="<%=itemImg%>" alt="<%=menu.getItemName()%>" onerror="this.src='images/food.png'">
        <div class="diet-mark <%=nonVeg ? "nonveg" : "veg"%>"><div class="dot"></div></div>
      </div>
      <div class="dish-body">
        <div class="dish-name"><%=menu.getItemName()%></div>
        <div class="dish-desc"><%=menu.getDescription() != null ? menu.getDescription() : "Freshly prepared to order"%></div>
        <div class="dish-foot">
          <div class="dish-price">&#8377;<%=String.format("%.0f", menu.getPrice())%></div>
          <% if (loggedInUser != null) { %>
            <% if (itemQtyInCart == 0) { %>
              <form action="cart" method="post">
                <input type="hidden" name="menuId" value="<%=menu.getMenuId()%>">
                <input type="hidden" name="action" value="add">
                <input type="hidden" name="quantity" value="1">
                <input type="hidden" name="from" value="menu">
                <button type="submit" class="add-btn">ADD</button>
              </form>
            <% } else { %>
              <div class="qty-counter">
                <form action="cart" method="post">
                  <input type="hidden" name="menuId" value="<%=menu.getMenuId()%>">
                  <input type="hidden" name="action" value="update">
                  <input type="hidden" name="qty" value="<%=itemQtyInCart - 1%>">
                  <input type="hidden" name="from" value="menu">
                  <button type="submit" class="counter-btn">&minus;</button>
                </form>
                <span class="counter-count"><%=itemQtyInCart%></span>
                <form action="cart" method="post">
                  <input type="hidden" name="menuId" value="<%=menu.getMenuId()%>">
                  <input type="hidden" name="action" value="update">
                  <input type="hidden" name="qty" value="<%=itemQtyInCart + 1%>">
                  <input type="hidden" name="from" value="menu">
                  <button type="submit" class="counter-btn">+</button>
                </form>
              </div>
            <% } %>
          <% } else { %>
            <a href="Login.jsp" class="login-prompt-btn">Login to order</a>
          <% } %>
        </div>
      </div>
    </div>
  <% mIndex++; } } %>
  </div>
</div>

<!-- Sticky cart bar -->
<% if (loggedInUser != null && cartCount > 0) { %>
<div class="cart-bar">
  <div class="info"><%=cartCount%> item<%=cartCount > 1 ? "s" : ""%> in cart<span>&#8377;<%=String.format("%.0f", cartTotal)%> + taxes</span></div>
  <a href="cart.jsp">View Cart <i class="fa-solid fa-arrow-right" style="margin-left:6px;font-size:12px;"></i></a>
</div>
<% } %>

<!-- Toast -->
<div class="toast" id="toast"><i class="fa-solid fa-circle-check"></i>Added to cart</div>

<%@ include file="/WEB-INF/jspf/footer.jspf" %>

<script>
(function () {
  var params = new URLSearchParams(window.location.search);
  if (params.get('added') === '1') {
    var t = document.getElementById('toast');
    t.classList.add('show');
    setTimeout(function () { t.classList.remove('show'); }, 2200);
    // strip the flag so a refresh doesn't re-show the toast
    params.delete('added');
    history.replaceState(null, '', 'menu?' + params.toString());
  }
})();
</script>

</body>
</html>
