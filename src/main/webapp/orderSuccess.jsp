<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.tap.model.User" %>
<%
User loggedInUser = (User) session.getAttribute("loggedInUser");
Object orderIdAttr     = request.getAttribute("orderId");
Object totalAmountAttr = request.getAttribute("totalAmount");
Object paymentModeAttr = request.getAttribute("paymentMode");
Object addressAttr     = request.getAttribute("deliveryAddress");

String orderId      = (orderIdAttr     != null) ? orderIdAttr.toString()     : "—";
String totalAmount  = (totalAmountAttr != null) ? totalAmountAttr.toString() : "—";
String paymentMode  = (paymentModeAttr != null) ? paymentModeAttr.toString() : "—";
String deliveryAddr = (addressAttr     != null) ? addressAttr.toString()    : null;
%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Order placed — TapFood</title>
<meta name="description" content="Your TapFood order has been placed.">
<%@ include file="/WEB-INF/jspf/head-assets.jspf" %>
<style>
  .success-bg {
    min-height: 78vh; display: flex; align-items: center; justify-content: center;
    padding: 44px 20px;
  }

  .success-card {
    background: var(--card); border: 1px solid var(--line); border-radius: 18px;
    padding: 44px 42px; text-align: center; max-width: 470px; width: 100%;
    box-shadow: var(--shadow-md);
  }

  .check-ring {
    width: 72px; height: 72px; border-radius: 50%; margin: 0 auto 20px;
    background: var(--green-soft); color: var(--green);
    display: flex; align-items: center; justify-content: center;
    font-size: 30px;
    animation: pop-in 0.45s cubic-bezier(0.175, 0.885, 0.32, 1.275) both;
  }
  @keyframes pop-in {
    0%   { transform: scale(0.4); opacity: 0; }
    100% { transform: scale(1); opacity: 1; }
  }

  .success-title { font-size: 22px; font-weight: 800; letter-spacing: -0.4px; margin-bottom: 6px; }
  .success-subtitle { font-size: 14px; color: var(--muted); margin-bottom: 26px; }

  .info-tiles {
    display: grid; grid-template-columns: 1fr 1fr 1fr; gap: 10px; margin-bottom: 18px;
  }
  .tile {
    background: #fafafa; border: 1px solid var(--line); border-radius: 10px;
    padding: 12px 10px; text-align: center;
  }
  .tile .t-label { font-size: 11px; font-weight: 600; color: var(--muted); margin-bottom: 2px; }
  .tile .t-value { font-size: 14px; font-weight: 700; }

  .deliver-to {
    text-align: left; background: #fafafa; border: 1px solid var(--line);
    border-radius: 10px; padding: 12px 14px; margin-bottom: 18px;
    font-size: 13px; color: var(--ink-2); display: flex; gap: 9px;
  }
  .deliver-to i { color: var(--brand); margin-top: 2px; font-size: 12px; }

  .eta-banner {
    border: 1px dashed #f0b48a; background: var(--brand-soft); border-radius: 10px;
    padding: 12px 16px; font-size: 14px; font-weight: 600; margin-bottom: 24px;
  }
  .eta-banner span { color: var(--brand-dark); }

  .action-btns { display: flex; gap: 10px; }
  .action-btns .btn { flex: 1; }
</style>
</head>
<body>

<%@ include file="/WEB-INF/jspf/header.jspf" %>

<div class="success-bg">
  <div class="success-card">

    <div class="check-ring"><i class="fa-solid fa-check"></i></div>

    <h1 class="success-title">Order placed</h1>
    <p class="success-subtitle">Your order has been sent to the restaurant and is being prepared.</p>

    <div class="info-tiles">
      <div class="tile">
        <div class="t-label">Order ID</div>
        <div class="t-value">#<%=orderId%></div>
      </div>
      <div class="tile">
        <div class="t-label">Amount</div>
        <div class="t-value">&#8377;<%=totalAmount%></div>
      </div>
      <div class="tile">
        <div class="t-label">Payment</div>
        <div class="t-value" style="font-size:12px;"><%=paymentMode%></div>
      </div>
    </div>

    <% if (deliveryAddr != null) { %>
    <div class="deliver-to">
      <i class="fa-solid fa-location-dot"></i>
      <span><%=deliveryAddr%></span>
    </div>
    <% } %>

    <div class="eta-banner">
      Estimated delivery: <span>25 – 35 min</span>
    </div>

    <div class="action-btns">
      <a href="orderHistory.jsp" class="btn">Track order</a>
      <a href="restaurant" class="btn ghost">Keep browsing</a>
    </div>

  </div>
</div>

<%@ include file="/WEB-INF/jspf/footer.jspf" %>

</body>
</html>
