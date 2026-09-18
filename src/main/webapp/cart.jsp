<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.tap.model.Cart,com.tap.model.CartItem,com.tap.model.User,com.tap.model.Restaurant,com.tap.DAOImpl.RestaurantDAOImpl" %>
<%
User loggedInUser = (User) session.getAttribute("loggedInUser");
Cart cart = (Cart) session.getAttribute("cart");

double subtotal    = 0;
double deliveryFee = 40;
double gst         = 0;
double total       = 0;

if (cart != null && !cart.getItems().isEmpty()) {
    subtotal = cart.getTotal();
    gst      = subtotal * 0.05;
    total    = subtotal + deliveryFee + gst;
}

int itemCount = (cart != null) ? cart.getItems().size() : 0;

Restaurant cartRestaurant = null;
if (cart != null && cart.getRestaurantId() > 0) {
    cartRestaurant = new RestaurantDAOImpl().getRestaurant(cart.getRestaurantId());
}
request.setAttribute("activePage", "cart");
%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Cart — TapFood</title>
<meta name="description" content="Review your order before checkout.">
<%@ include file="/WEB-INF/jspf/head-assets.jspf" %>
<style>
  .cart-layout {
    max-width: 1120px; margin: 34px auto 70px; padding: 0 24px;
    display: flex; gap: 28px; align-items: flex-start;
  }
  .cart-items-col { flex: 2; }
  .cart-bill-col  { flex: 1; position: sticky; top: 84px; }

  .from-rest {
    display: flex; align-items: center; gap: 12px;
    background: var(--card); border: 1px solid var(--line); border-radius: var(--radius);
    padding: 14px 18px; margin-bottom: 16px;
  }
  .from-rest img { width: 46px; height: 46px; border-radius: 9px; object-fit: cover; }
  .from-rest .fr-name { font-size: 15px; font-weight: 700; }
  .from-rest .fr-sub  { font-size: 12.5px; color: var(--muted); }

  .cart-item-card {
    background: var(--card); border: 1px solid var(--line); border-radius: var(--radius);
    padding: 16px 18px; margin-bottom: 12px;
    display: flex; align-items: center; gap: 16px;
  }
  .cart-item-card img {
    width: 74px; height: 74px; border-radius: 10px; object-fit: cover; flex-shrink: 0;
  }
  .cart-item-info { flex: 1; min-width: 0; }
  .cart-item-info h3 { font-size: 15px; font-weight: 700; margin-bottom: 2px; }
  .cart-item-info .unit-price { font-size: 13px; color: var(--muted); }

  .qty-controls {
    display: flex; align-items: center;
    border: 1px solid var(--line); border-radius: 9px; overflow: hidden;
  }
  .qty-btn {
    background: #fff; border: none; width: 32px; height: 34px;
    font-size: 15px; font-weight: 700; cursor: pointer; color: var(--ink-2);
    display: flex; align-items: center; justify-content: center;
    transition: background 0.15s ease, color 0.15s ease;
  }
  .qty-btn:hover { background: var(--brand); color: #fff; }
  .qty-val { width: 34px; text-align: center; font-weight: 700; font-size: 14px; }

  .item-total { font-size: 15.5px; font-weight: 800; min-width: 70px; text-align: right; }

  .remove-btn {
    background: none; border: none; color: #c2c7cf; font-size: 15px; cursor: pointer;
    padding: 8px; border-radius: 8px; transition: all 0.15s ease;
  }
  .remove-btn:hover { color: var(--red); background: #fdf0f0; }

  .bill-card {
    background: var(--card); border: 1px solid var(--line); border-radius: var(--radius);
    padding: 22px 24px;
  }
  .bill-card h2 { font-size: 16px; font-weight: 700; margin-bottom: 16px; }
  .bill-row { display: flex; justify-content: space-between; font-size: 14px; color: var(--muted); margin: 10px 0; }
  .bill-row.bold { font-weight: 600; color: var(--ink-2); }
  .bill-divider { border: 0; height: 1px; background: var(--line); margin: 14px 0; }
  .bill-total { display: flex; justify-content: space-between; font-size: 18px; font-weight: 800; }

  .add-more-link {
    display: block; text-align: center; margin-top: 12px; font-size: 13px;
    color: var(--brand); font-weight: 600; text-decoration: none;
  }
  .add-more-link:hover { text-decoration: underline; }

  .empty-cart-wrapper { max-width: 1120px; margin: 60px auto; padding: 0 24px; display: flex; justify-content: center; }
  .empty-cart-card {
    background: var(--card); border: 1px solid var(--line); border-radius: 16px;
    padding: 50px 46px; text-align: center; max-width: 440px;
  }
  .empty-cart-card .empty-icon {
    width: 68px; height: 68px; margin: 0 auto 18px; border-radius: 50%;
    background: var(--brand-soft); color: var(--brand);
    display: flex; align-items: center; justify-content: center; font-size: 26px;
  }
  .empty-cart-card h2 { font-size: 20px; font-weight: 800; margin-bottom: 8px; }
  .empty-cart-card p { font-size: 14px; color: var(--muted); margin-bottom: 22px; }

  @media (max-width: 900px) {
    .cart-layout { flex-direction: column; }
    .cart-bill-col { position: static; width: 100%; }
  }
</style>
</head>
<body>

<%@ include file="/WEB-INF/jspf/header.jspf" %>

<div class="page-head">
  <h1>Cart</h1>
  <p><%=itemCount > 0 ? itemCount + (itemCount == 1 ? " item" : " items") + " ready for checkout" : "Nothing here yet"%></p>
</div>

<% if (cart == null || cart.getItems().isEmpty()) { %>
<div class="empty-cart-wrapper">
  <div class="empty-cart-card">
    <div class="empty-icon"><i class="fa-solid fa-basket-shopping"></i></div>
    <h2>Your cart is empty</h2>
    <p>Browse restaurants near you and add something you're craving.</p>
    <a href="restaurant" class="btn">Browse restaurants</a>
  </div>
</div>

<% } else { %>

<div class="cart-layout">

  <div class="cart-items-col">

    <% if (cartRestaurant != null) { %>
    <div class="from-rest">
      <img src="<%=cartRestaurant.getImagePath() != null ? cartRestaurant.getImagePath() : "images/restaurant.jpg"%>"
           onerror="this.src='images/restaurant.jpg'" alt="<%=cartRestaurant.getName()%>">
      <div>
        <div class="fr-name"><%=cartRestaurant.getName()%></div>
        <div class="fr-sub"><%=cartRestaurant.getCuisineType()%> &middot; <%=cartRestaurant.getDeliveryTime()%> min delivery</div>
      </div>
    </div>
    <% } %>

    <% for (CartItem item : cart.getItems().values()) {
        String img = item.getImagePath();
        if (img == null || img.trim().isEmpty()) img = "images/food.png";
        double lineTotal = item.getPrice() * item.getQty();
    %>
    <div class="cart-item-card">
      <img src="<%=img%>" alt="<%=item.getItemName()%>" onerror="this.src='images/food.png'">

      <div class="cart-item-info">
        <h3><%=item.getItemName()%></h3>
        <div class="unit-price">&#8377;<%=String.format("%.2f", item.getPrice())%> each</div>
      </div>

      <div class="qty-controls">
        <form action="cart" method="post">
          <input type="hidden" name="action" value="update">
          <input type="hidden" name="menuId" value="<%=item.getMenuId()%>">
          <input type="hidden" name="qty"    value="<%=item.getQty()-1%>">
          <button type="submit" class="qty-btn">&minus;</button>
        </form>
        <span class="qty-val"><%=item.getQty()%></span>
        <form action="cart" method="post">
          <input type="hidden" name="action" value="update">
          <input type="hidden" name="menuId" value="<%=item.getMenuId()%>">
          <input type="hidden" name="qty"    value="<%=item.getQty()+1%>">
          <button type="submit" class="qty-btn">+</button>
        </form>
      </div>

      <div class="item-total">&#8377;<%=String.format("%.0f", lineTotal)%></div>

      <form action="cart" method="post">
        <input type="hidden" name="action" value="remove">
        <input type="hidden" name="menuId" value="<%=item.getMenuId()%>">
        <button type="submit" class="remove-btn" title="Remove item"><i class="fa-regular fa-trash-can"></i></button>
      </form>
    </div>
    <% } %>
  </div>

  <div class="cart-bill-col">
    <div class="bill-card">
      <h2>Bill details</h2>

      <div class="bill-row bold">
        <span>Item total</span>
        <span>&#8377;<%=String.format("%.2f", subtotal)%></span>
      </div>
      <div class="bill-row">
        <span>Delivery fee</span>
        <span>&#8377;<%=String.format("%.2f", deliveryFee)%></span>
      </div>
      <div class="bill-row">
        <span>GST (5%)</span>
        <span>&#8377;<%=String.format("%.2f", gst)%></span>
      </div>

      <hr class="bill-divider">

      <div class="bill-total">
        <span>To pay</span>
        <span>&#8377;<%=String.format("%.2f", total)%></span>
      </div>

      <a href="checkout.jsp" class="btn block" style="margin-top:18px;">Proceed to checkout</a>
      <% if (cart.getRestaurantId() > 0) { %>
      <a href="menu?restaurantId=<%=cart.getRestaurantId()%>" class="add-more-link">+ Add more items</a>
      <% } %>
    </div>
  </div>

</div>
<% } %>

<%@ include file="/WEB-INF/jspf/footer.jspf" %>

</body>
</html>
