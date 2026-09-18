<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List, com.tap.model.User, com.tap.model.Cart, com.tap.model.CartItem, com.tap.model.UserAddress, com.tap.DAOImpl.UserAddressDAOImpl" %>
<%
User loggedInUser = (User) session.getAttribute("loggedInUser");
if (loggedInUser == null) {
    response.sendRedirect("Login.jsp");
    return;
}
Cart cart = (Cart) session.getAttribute("cart");
if (cart == null || cart.getItems().isEmpty()) {
    response.sendRedirect("cart.jsp");
    return;
}

List<UserAddress> addresses = new UserAddressDAOImpl().getAddressesByUser(loggedInUser.getUserId());
boolean canAddMore = addresses.size() < 3;

double subtotal    = cart.getTotal();
double deliveryFee = 40.0;
double gst         = subtotal * 0.05;
double total       = subtotal + deliveryFee + gst;
String formattedTotal = String.format("%.2f", total);

String error   = request.getParameter("error");
String addrMsg = request.getParameter("addrMsg");
String addrErr = request.getParameter("addrError");
request.setAttribute("activePage", "cart");
%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Checkout — TapFood</title>
<meta name="description" content="Choose delivery address and payment method.">
<%@ include file="/WEB-INF/jspf/head-assets.jspf" %>
<style>
  .co-layout {
    max-width: 1120px; margin: 34px auto 70px; padding: 0 24px;
    display: flex; gap: 28px; align-items: flex-start;
  }

  .co-main { flex: 2; display: flex; flex-direction: column; gap: 20px; }

  .co-card {
    background: var(--card); border: 1px solid var(--line); border-radius: var(--radius);
    padding: 24px 26px;
  }
  .co-card > h2 {
    font-size: 16px; font-weight: 700; margin-bottom: 4px;
    display: flex; align-items: center; gap: 9px;
  }
  .co-card > h2 i { color: var(--brand); font-size: 14px; }
  .co-card .sub { font-size: 13px; color: var(--muted); margin-bottom: 16px; }

  /* Address cards */
  .addr-list { display: flex; flex-direction: column; gap: 10px; }
  .addr-opt {
    display: flex; gap: 12px; align-items: flex-start;
    border: 1px solid var(--line); border-radius: 10px; padding: 14px 16px;
    cursor: pointer; transition: border-color 0.15s ease, background 0.15s ease;
  }
  .addr-opt:hover { border-color: #cfd2d8; }
  .addr-opt.selected { border-color: var(--brand); background: var(--brand-soft); }
  .addr-opt input[type="radio"] { accent-color: var(--brand); margin-top: 3px; width: 16px; height: 16px; }
  .addr-opt .a-label {
    font-size: 11px; font-weight: 700; text-transform: uppercase; letter-spacing: 0.6px;
    color: var(--brand); background: #fff; border: 1px solid var(--brand);
    border-radius: 5px; padding: 1px 7px; display: inline-block; margin-bottom: 4px;
  }
  .addr-opt .a-line  { font-size: 14px; color: var(--ink-2); line-height: 1.5; }
  .addr-opt .a-phone { font-size: 12.5px; color: var(--muted); margin-top: 2px; }
  .addr-del {
    margin-left: auto; background: none; border: none; color: #c2c7cf;
    cursor: pointer; font-size: 13px; padding: 5px; border-radius: 6px; align-self: flex-start;
  }
  .addr-del:hover { color: var(--red); background: #fdf0f0; }

  .no-addr {
    font-size: 14px; color: var(--muted); padding: 6px 0 2px;
  }

  /* Add address form */
  .add-addr-toggle {
    margin-top: 14px; font-size: 13.5px; font-weight: 600; color: var(--brand);
    background: none; border: none; cursor: pointer; padding: 0;
  }
  .add-addr-toggle:hover { text-decoration: underline; }

  .add-addr-form { display: none; margin-top: 16px; border-top: 1px dashed var(--line); padding-top: 16px; }
  .add-addr-form.open { display: block; }
  .fa-grid { display: grid; grid-template-columns: 1fr 1fr; gap: 14px; }
  .fa-grid .full { grid-column: 1 / -1; }
  .field { display: flex; flex-direction: column; gap: 5px; }
  .field label { font-size: 12px; font-weight: 600; color: var(--ink-2); }
  .field input, .field select, .field textarea {
    padding: 10px 13px; border: 1px solid var(--line); border-radius: 9px;
    font-size: 14px; color: var(--ink); background: #fff; resize: none;
  }
  .field input:focus, .field select:focus, .field textarea:focus {
    outline: none; border-color: var(--brand);
    box-shadow: 0 0 0 3px rgba(232, 89, 12, 0.1);
  }

  /* Payment */
  .payment-opts { display: flex; flex-direction: column; gap: 10px; }
  .payment-opt {
    display: flex; align-items: center; gap: 13px;
    border: 1px solid var(--line); border-radius: 10px; padding: 13px 16px;
    cursor: pointer; transition: border-color 0.15s ease, background 0.15s ease;
  }
  .payment-opt:hover { border-color: #cfd2d8; }
  .payment-opt.selected { border-color: var(--brand); background: var(--brand-soft); }
  .payment-opt input[type="radio"] { accent-color: var(--brand); width: 16px; height: 16px; }
  .payment-opt .pay-icon {
    width: 36px; height: 36px; border-radius: 9px; background: #f1f2f4;
    display: flex; align-items: center; justify-content: center;
    color: var(--ink-2); font-size: 15px;
  }
  .payment-opt.selected .pay-icon { background: #fff; color: var(--brand); }
  .payment-opt .pay-label { font-size: 14px; font-weight: 600; }
  .payment-opt .pay-desc  { font-size: 12px; color: var(--muted); }

  #upi-field { display: none; margin-top: 12px; }
  #upi-field.open { display: block; }

  /* Summary */
  .co-summary {
    flex: 1; position: sticky; top: 84px;
    background: var(--card); border: 1px solid var(--line); border-radius: var(--radius);
    padding: 22px 24px;
  }
  .co-summary h2 { font-size: 16px; font-weight: 700; margin-bottom: 14px; }
  .order-item-row {
    display: flex; justify-content: space-between; align-items: center;
    padding: 8px 0; font-size: 13.5px;
  }
  .order-item-row .oi-name { color: var(--ink-2); flex: 1; }
  .order-item-row .oi-qty  { color: #9aa1ad; font-size: 12px; margin: 0 10px; }
  .order-item-row .oi-amt  { font-weight: 600; }
  .co-bill-row { display: flex; justify-content: space-between; font-size: 13.5px; color: var(--muted); margin: 8px 0; }
  .co-divider { border: 0; height: 1px; background: var(--line); margin: 12px 0; }
  .co-total { display: flex; justify-content: space-between; font-size: 17px; font-weight: 800; margin-top: 4px; }

  @media (max-width: 900px) {
    .co-layout { flex-direction: column; }
    .co-summary { position: static; width: 100%; }
    .fa-grid { grid-template-columns: 1fr; }
  }
</style>
</head>
<body>

<%@ include file="/WEB-INF/jspf/header.jspf" %>

<div class="page-head">
  <h1>Checkout</h1>
  <p>Choose where to deliver and how you'd like to pay</p>
</div>

<% if ("noaddress".equals(error)) { %>
<div class="alert warn" style="margin-left:24px;margin-right:24px;">
  <div><i class="fa-solid fa-circle-exclamation" style="margin-right:8px;"></i>Please select a delivery address before placing the order.</div>
</div>
<% } else if ("orderfailed".equals(error)) { %>
<div class="alert warn" style="margin-left:24px;margin-right:24px;">
  <div><i class="fa-solid fa-circle-exclamation" style="margin-right:8px;"></i>Something went wrong while placing your order. Please try again.</div>
</div>
<% } else if ("limit".equals(addrErr)) { %>
<div class="alert warn" style="margin-left:24px;margin-right:24px;">
  <div><i class="fa-solid fa-circle-exclamation" style="margin-right:8px;"></i>You can save up to 3 addresses. Delete one to add another.</div>
</div>
<% } else if ("added".equals(addrMsg)) { %>
<div class="alert ok" style="margin-left:24px;margin-right:24px;">
  <div><i class="fa-solid fa-circle-check" style="margin-right:8px;"></i>Address saved.</div>
</div>
<% } %>

<div class="co-layout">

  <div class="co-main">

    <!-- Delivery address -->
    <div class="co-card">
      <h2><i class="fa-solid fa-location-dot"></i>Delivery address</h2>
      <p class="sub">Deliveries go to one of your saved addresses (max 3).</p>

      <div class="addr-list">
        <% if (addresses.isEmpty()) { %>
          <p class="no-addr">No saved addresses yet — add your first one below.</p>
        <% } else {
             int aIdx = 0;
             for (UserAddress a : addresses) { %>
        <label class="addr-opt <%=aIdx == 0 ? "selected" : ""%>">
          <input type="radio" name="addressRadio" form="checkoutForm"
                 value="<%=a.getAddressId()%>" <%=aIdx == 0 ? "checked" : ""%>
                 onchange="selectAddr(this)">
          <div>
            <span class="a-label"><%=a.getLabel()%></span>
            <div class="a-line"><%=a.getAddressLine()%><%=a.getCity() != null ? ", " + a.getCity() : ""%></div>
            <% if (a.getPhone() != null) { %><div class="a-phone"><i class="fa-solid fa-phone" style="font-size:10px;margin-right:4px;"></i><%=a.getPhone()%></div><% } %>
          </div>
          <button type="button" class="addr-del" title="Delete address"
                  onclick="deleteAddr(<%=a.getAddressId()%>)"><i class="fa-regular fa-trash-can"></i></button>
        </label>
        <%   aIdx++;
             }
           } %>
      </div>

      <% if (canAddMore) { %>
      <button type="button" class="add-addr-toggle" id="addAddrToggle" onclick="toggleAddrForm()">+ Add new address</button>

      <form action="address" method="post" class="add-addr-form <%=addresses.isEmpty() ? "open" : ""%>" id="addAddrForm">
        <input type="hidden" name="action" value="add">
        <input type="hidden" name="from" value="checkout">
        <div class="fa-grid">
          <div class="field">
            <label>Save as</label>
            <select name="label">
              <option>Home</option>
              <option>Work</option>
              <option>Other</option>
            </select>
          </div>
          <div class="field">
            <label>Phone</label>
            <input type="tel" name="phone" placeholder="10-digit mobile number" pattern="[0-9]{10}">
          </div>
          <div class="field full">
            <label>Address</label>
            <textarea name="addressLine" rows="2" placeholder="House / flat no., street, area" required></textarea>
          </div>
          <div class="field">
            <label>City</label>
            <input type="text" name="city" placeholder="City">
          </div>
        </div>
        <button type="submit" class="btn" style="margin-top:14px;padding:9px 18px;font-size:13.5px;">Save address</button>
      </form>
      <% } %>

      <!-- hidden delete form -->
      <form action="address" method="post" id="delAddrForm" style="display:none;">
        <input type="hidden" name="action" value="delete">
        <input type="hidden" name="from" value="checkout">
        <input type="hidden" name="addressId" id="delAddrId" value="">
      </form>
    </div>

    <!-- Payment -->
    <div class="co-card">
      <h2><i class="fa-regular fa-credit-card"></i>Payment method</h2>
      <p class="sub">Pick how you want to pay for this order.</p>

      <div class="payment-opts">
        <label class="payment-opt selected" id="opt-cod">
          <input type="radio" name="paymentMode" form="checkoutForm" value="Cash on Delivery" checked
                 onchange="selectPayment(this,'opt-cod')">
          <span class="pay-icon"><i class="fa-solid fa-money-bill-wave"></i></span>
          <div>
            <div class="pay-label">Cash on Delivery</div>
            <div class="pay-desc">Pay in cash when the order arrives</div>
          </div>
        </label>

        <label class="payment-opt" id="opt-upi">
          <input type="radio" name="paymentMode" form="checkoutForm" value="UPI"
                 onchange="selectPayment(this,'opt-upi')">
          <span class="pay-icon"><i class="fa-solid fa-mobile-screen-button"></i></span>
          <div>
            <div class="pay-label">UPI</div>
            <div class="pay-desc">GPay, PhonePe, Paytm or any UPI app</div>
          </div>
        </label>

        <label class="payment-opt" id="opt-card">
          <input type="radio" name="paymentMode" form="checkoutForm" value="Card"
                 onchange="selectPayment(this,'opt-card')">
          <span class="pay-icon"><i class="fa-regular fa-credit-card"></i></span>
          <div>
            <div class="pay-label">Credit / Debit card</div>
            <div class="pay-desc">Visa, Mastercard, RuPay — pay on delivery via card machine</div>
          </div>
        </label>
      </div>

      <div id="upi-field">
        <div class="field">
          <label>UPI ID</label>
          <input type="text" id="upiId" placeholder="yourname@okaxis" form="checkoutForm">
          <span style="font-size:12px;color:var(--muted);">A collect request will be sent to this UPI ID.</span>
        </div>
      </div>
    </div>

  </div>

  <!-- Summary + place order -->
  <div class="co-summary">
    <h2>Order summary</h2>

    <% for (CartItem item : cart.getItems().values()) { %>
    <div class="order-item-row">
      <span class="oi-name"><%=item.getItemName()%></span>
      <span class="oi-qty">&times;<%=item.getQty()%></span>
      <span class="oi-amt">&#8377;<%=String.format("%.0f", item.getPrice()*item.getQty())%></span>
    </div>
    <% } %>

    <hr class="co-divider">

    <div class="co-bill-row">
      <span>Item total</span>
      <span>&#8377;<%=String.format("%.2f", subtotal)%></span>
    </div>
    <div class="co-bill-row">
      <span>Delivery fee</span>
      <span>&#8377;<%=String.format("%.2f", deliveryFee)%></span>
    </div>
    <div class="co-bill-row">
      <span>GST (5%)</span>
      <span>&#8377;<%=String.format("%.2f", gst)%></span>
    </div>

    <hr class="co-divider">

    <div class="co-total">
      <span>To pay</span>
      <span>&#8377;<%=formattedTotal%></span>
    </div>

    <form action="placeOrder" method="post" id="checkoutForm">
      <input type="hidden" name="addressId" id="addressIdInput" value="<%=addresses.isEmpty() ? "" : String.valueOf(addresses.get(0).getAddressId())%>">
      <button type="submit" class="btn block" id="placeBtn" style="margin-top:18px;">Place order</button>
    </form>
  </div>

</div>

<%@ include file="/WEB-INF/jspf/footer.jspf" %>

<script>
function selectAddr(radio) {
  document.querySelectorAll('.addr-opt').forEach(function (el) { el.classList.remove('selected'); });
  radio.closest('.addr-opt').classList.add('selected');
  document.getElementById('addressIdInput').value = radio.value;
}

function deleteAddr(id) {
  Swal.fire({
    title: 'Delete this address?',
    icon: 'question',
    showCancelButton: true,
    confirmButtonColor: '#e8590c',
    cancelButtonColor: '#a0aec0',
    confirmButtonText: 'Delete'
  }).then(function (result) {
    if (result.isConfirmed) {
      document.getElementById('delAddrId').value = id;
      document.getElementById('delAddrForm').submit();
    }
  });
}

function toggleAddrForm() {
  document.getElementById('addAddrForm').classList.toggle('open');
}

function selectPayment(radio, optId) {
  document.querySelectorAll('.payment-opt').forEach(function (el) { el.classList.remove('selected'); });
  document.getElementById(optId).classList.add('selected');
  document.getElementById('upi-field').classList.toggle('open', radio.value === 'UPI');
}

document.getElementById('checkoutForm').addEventListener('submit', function (e) {
  var addrId = document.getElementById('addressIdInput').value;
  if (!addrId) {
    e.preventDefault();
    Swal.fire({
      icon: 'warning',
      title: 'No delivery address',
      text: 'Please add and select a delivery address first.',
      confirmButtonColor: '#e8590c'
    });
    return;
  }

  var pay = document.querySelector('input[name="paymentMode"]:checked').value;
  if (pay === 'UPI') {
    var upi = document.getElementById('upiId').value.trim();
    if (upi && !/^[\w.\-]+@[\w.\-]+$/.test(upi)) {
      e.preventDefault();
      Swal.fire({
        icon: 'warning',
        title: 'Invalid UPI ID',
        text: 'Enter a valid UPI ID like name@okaxis, or leave it blank to pay via QR at delivery.',
        confirmButtonColor: '#e8590c'
      });
      return;
    }
  }

  var btn = document.getElementById('placeBtn');
  btn.disabled = true;
  btn.textContent = 'Placing order...';
});
</script>

</body>
</html>
