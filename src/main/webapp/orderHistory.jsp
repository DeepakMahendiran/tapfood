<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*, java.text.SimpleDateFormat,
                 com.tap.model.User, com.tap.model.Order, com.tap.model.OrderItem, com.tap.model.Menu, com.tap.model.Restaurant,
                 com.tap.DAOImpl.OrderDAOImpl, com.tap.DAOImpl.OrderItemDAOImpl, com.tap.DAOImpl.MenuDAOImpl, com.tap.DAOImpl.RestaurantDAOImpl" %>
<%
User loggedInUser = (User) session.getAttribute("loggedInUser");
if (loggedInUser == null) {
    response.sendRedirect("Login.jsp");
    return;
}

ArrayList<Order> allOrders = new OrderDAOImpl().getAllOrders();
ArrayList<Order> myOrders = new ArrayList<>();
if (allOrders != null) {
    for (Order o : allOrders) {
        if (o.getUserId() == loggedInUser.getUserId()) myOrders.add(o);
    }
}

// Look-up maps so each card can show real names instead of raw IDs
Map<Integer, List<OrderItem>> itemsByOrder = new HashMap<>();
ArrayList<OrderItem> allItems = new OrderItemDAOImpl().getAllOrderItems();
if (allItems != null) {
    for (OrderItem oi : allItems) {
        itemsByOrder.computeIfAbsent(oi.getOrderId(), k -> new ArrayList<>()).add(oi);
    }
}
Map<Integer, String> menuNames = new HashMap<>();
ArrayList<Menu> allMenus = new MenuDAOImpl().getAllMenus();
if (allMenus != null) {
    for (Menu m : allMenus) menuNames.put(m.getMenuId(), m.getItemName());
}
Map<Integer, Restaurant> restCache = new HashMap<>();
RestaurantDAOImpl restDAO = new RestaurantDAOImpl();

SimpleDateFormat dateFmt = new SimpleDateFormat("dd MMM yyyy, h:mm a");
request.setAttribute("activePage", "orders");
%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>My Orders — TapFood</title>
<meta name="description" content="Your TapFood order history.">
<%@ include file="/WEB-INF/jspf/head-assets.jspf" %>
<style>
  .orders-wrap { max-width: 820px; margin: 34px auto 70px; padding: 0 24px; }

  .order-card {
    background: var(--card); border: 1px solid var(--line); border-radius: var(--radius);
    margin-bottom: 16px; overflow: hidden;
  }

  .order-top {
    display: flex; justify-content: space-between; align-items: center; gap: 14px;
    padding: 16px 22px; border-bottom: 1px solid var(--line); background: #fcfcfd;
  }
  .ot-left { display: flex; align-items: center; gap: 13px; min-width: 0; }
  .ot-left img { width: 46px; height: 46px; border-radius: 9px; object-fit: cover; }
  .ot-rest { font-size: 15px; font-weight: 700; }
  .ot-sub  { font-size: 12.5px; color: var(--muted); }

  .status-pill {
    padding: 5px 12px; border-radius: 100px; font-size: 12px; font-weight: 700;
    white-space: nowrap; flex-shrink: 0;
  }
  .status-preparing { background: #fff8e6; color: #9a6700; }
  .status-delivered { background: var(--green-soft); color: var(--green); }
  .status-out       { background: #e8f0fe; color: #1a56b8; }
  .status-cancelled { background: #fdf0f0; color: var(--red); }
  .status-pending, .status-confirmed { background: #eef0f3; color: var(--ink-2); }

  .order-body { padding: 16px 22px; }

  .oi-line {
    display: flex; justify-content: space-between; font-size: 13.5px;
    color: var(--ink-2); padding: 3px 0;
  }
  .oi-line .q { color: #9aa1ad; margin-right: 8px; }

  .order-addr {
    margin-top: 12px; font-size: 12.5px; color: var(--muted);
    display: flex; gap: 7px; align-items: flex-start;
  }
  .order-addr i { margin-top: 2px; font-size: 11px; }

  .order-foot {
    display: flex; justify-content: space-between; align-items: center;
    padding: 14px 22px; border-top: 1px solid var(--line);
  }
  .of-left { font-size: 12.5px; color: var(--muted); }
  .of-left b { color: var(--ink); font-size: 15px; font-weight: 800; display: block; }
  .of-right { display: flex; align-items: center; gap: 10px; }
  .pay-tag {
    font-size: 12px; color: var(--muted); border: 1px solid var(--line);
    border-radius: 6px; padding: 3px 9px;
  }

  .empty-orders { text-align: center; padding: 70px 20px; }
  .empty-orders .icon {
    width: 68px; height: 68px; margin: 0 auto 18px; border-radius: 50%;
    background: var(--brand-soft); color: var(--brand);
    display: flex; align-items: center; justify-content: center; font-size: 26px;
  }
  .empty-orders h2 { font-size: 20px; font-weight: 800; margin-bottom: 8px; }
  .empty-orders p  { font-size: 14px; color: var(--muted); margin-bottom: 22px; }
</style>
</head>
<body>

<%@ include file="/WEB-INF/jspf/header.jspf" %>

<div class="page-head">
  <h1>My orders</h1>
  <p><%=myOrders.size()%> order<%=myOrders.size() == 1 ? "" : "s"%> so far</p>
</div>

<div class="orders-wrap">
<% if (myOrders.isEmpty()) { %>
  <div class="empty-orders">
    <div class="icon"><i class="fa-solid fa-receipt"></i></div>
    <h2>No orders yet</h2>
    <p>When you place an order it will show up here with live status.</p>
    <a href="restaurant" class="btn">Browse restaurants</a>
  </div>
<% } else {
   for (int i = myOrders.size() - 1; i >= 0; i--) {
       Order o = myOrders.get(i);

       Restaurant rest = restCache.get(o.getRestaurantId());
       if (rest == null) {
           rest = restDAO.getRestaurant(o.getRestaurantId());
           if (rest != null) restCache.put(o.getRestaurantId(), rest);
       }
       String restName = rest != null ? rest.getName() : "Restaurant #" + o.getRestaurantId();
       String restImg  = (rest != null && rest.getImagePath() != null) ? rest.getImagePath() : "images/restaurant.jpg";

       String st = o.getStatus() != null ? o.getStatus() : "Pending";
       String statusClass = "status-preparing";
       if ("Delivered".equalsIgnoreCase(st))              statusClass = "status-delivered";
       else if ("Out for Delivery".equalsIgnoreCase(st))  statusClass = "status-out";
       else if ("Cancelled".equalsIgnoreCase(st))         statusClass = "status-cancelled";
       else if ("Pending".equalsIgnoreCase(st))           statusClass = "status-pending";
       else if ("Confirmed".equalsIgnoreCase(st))         statusClass = "status-confirmed";

       List<OrderItem> lineItems = itemsByOrder.get(o.getOrderId());
%>
  <div class="order-card" data-aos="fade-up">

    <div class="order-top">
      <div class="ot-left">
        <img src="<%=restImg%>" onerror="this.src='images/restaurant.jpg'" alt="<%=restName%>">
        <div>
          <div class="ot-rest"><%=restName%></div>
          <div class="ot-sub">Order #<%=o.getOrderId()%> &middot; <%=o.getOrderDate() != null ? dateFmt.format(o.getOrderDate()) : "—"%></div>
        </div>
      </div>
      <span class="status-pill <%=statusClass%>"><%=st%></span>
    </div>

    <div class="order-body">
      <% if (lineItems != null && !lineItems.isEmpty()) {
           for (OrderItem oi : lineItems) {
             String itemName = menuNames.getOrDefault(oi.getMenuId(), "Item #" + oi.getMenuId());
      %>
      <div class="oi-line">
        <span><span class="q"><%=oi.getQuantity()%> &times;</span><%=itemName%></span>
        <span>&#8377;<%=String.format("%.0f", oi.getItemTotal())%></span>
      </div>
      <%   }
         } else { %>
      <div class="oi-line"><span style="color:var(--muted);">Item details unavailable</span></div>
      <% } %>

      <% if (o.getDeliveryAddress() != null && !o.getDeliveryAddress().trim().isEmpty()) { %>
      <div class="order-addr">
        <i class="fa-solid fa-location-dot"></i>
        <span><%=o.getDeliveryAddress()%></span>
      </div>
      <% } %>
    </div>

    <div class="order-foot">
      <div class="of-left">Total paid<b>&#8377;<%=String.format("%.2f", o.getTotalAmount())%></b></div>
      <div class="of-right">
        <span class="pay-tag"><%=o.getPaymentMode()%></span>
        <a href="menu?restaurantId=<%=o.getRestaurantId()%>" class="btn outline" style="padding:8px 16px;font-size:13px;">Order again</a>
      </div>
    </div>

  </div>
<% } } %>
</div>

<%@ include file="/WEB-INF/jspf/footer.jspf" %>
</body>
</html>
