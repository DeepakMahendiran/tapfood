<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List, com.tap.model.User, com.tap.model.UserAddress, com.tap.DAOImpl.UserDAOImpl, com.tap.DAOImpl.UserAddressDAOImpl" %>

<%
User loggedInUser = (User) session.getAttribute("loggedInUser");
if (loggedInUser == null) {
    response.sendRedirect("Login.jsp");
    return;
}

if ("POST".equalsIgnoreCase(request.getMethod())) {
    String newUsername = request.getParameter("username");
    String newEmail = request.getParameter("email");

    loggedInUser.setUserName(newUsername);
    loggedInUser.setEmail(newEmail);

    UserDAOImpl userDAO = new UserDAOImpl();
    userDAO.updateUser(loggedInUser);

    session.setAttribute("loggedInUser", loggedInUser);
    response.sendRedirect("profile.jsp?message=updated");
    return;
}

String messageText = "";
String msg = request.getParameter("message");
if ("updated".equals(msg)) messageText = "Profile updated.";
String addrMsg = request.getParameter("addrMsg");
if ("added".equals(addrMsg))   messageText = "Address saved.";
if ("deleted".equals(addrMsg)) messageText = "Address removed.";
String addrErr = request.getParameter("addrError");

List<UserAddress> addresses = new UserAddressDAOImpl().getAddressesByUser(loggedInUser.getUserId());
boolean canAddMore = addresses.size() < 3;

request.setAttribute("activePage", "profile");

String initials = "";
if (loggedInUser.getUserName() != null && !loggedInUser.getUserName().isEmpty()) {
    String name = loggedInUser.getUserName();
    initials = name.substring(0, Math.min(name.length(), 2)).toUpperCase();
}
%>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>My account — TapFood</title>
<%@ include file="/WEB-INF/jspf/head-assets.jspf" %>

<style>
.profile-wrap {
    max-width: 720px; margin: 34px auto 70px; padding: 0 24px;
    display: flex; flex-direction: column; gap: 20px;
}

.p-card {
    background: var(--card); border: 1px solid var(--line); border-radius: var(--radius);
    padding: 24px 26px;
}
.p-card > h2 {
    font-size: 16px; font-weight: 700; margin-bottom: 16px;
    display: flex; align-items: center; gap: 9px;
}
.p-card > h2 i { color: var(--brand); font-size: 14px; }

.acct-row { display: flex; align-items: center; gap: 16px; margin-bottom: 20px; }
.avatar {
    width: 58px; height: 58px; border-radius: 50%;
    background: var(--brand-soft); color: var(--brand);
    display: flex; align-items: center; justify-content: center;
    font-size: 20px; font-weight: 800;
}
.acct-row .a-name { font-size: 17px; font-weight: 800; }
.acct-row .a-mail { font-size: 13.5px; color: var(--muted); }

.info-grid { display: grid; grid-template-columns: 1fr 1fr; gap: 14px; }
.info-item {
    border: 1px solid var(--line); border-radius: 10px; padding: 12px 14px;
}
.info-item label {
    font-size: 11px; font-weight: 600; color: var(--muted);
    display: block; margin-bottom: 2px;
}
.info-value { font-size: 14px; font-weight: 600; }

.field { display: flex; flex-direction: column; gap: 5px; margin-bottom: 14px; }
.field label { font-size: 12px; font-weight: 600; color: var(--ink-2); }
.field input, .field select, .field textarea {
    padding: 10px 13px; border: 1px solid var(--line); border-radius: 9px;
    font-size: 14px; color: var(--ink); background: #fff; resize: none;
}
.field input:focus, .field select:focus, .field textarea:focus {
    outline: none; border-color: var(--brand);
    box-shadow: 0 0 0 3px rgba(232, 89, 12, 0.1);
}

/* address list */
.addr-item {
    display: flex; gap: 12px; align-items: flex-start;
    border: 1px solid var(--line); border-radius: 10px; padding: 13px 15px;
    margin-bottom: 10px;
}
.addr-item .a-label {
    font-size: 11px; font-weight: 700; text-transform: uppercase; letter-spacing: 0.6px;
    color: var(--brand); border: 1px solid var(--brand); border-radius: 5px;
    padding: 1px 7px; display: inline-block; margin-bottom: 4px;
}
.addr-item .a-line  { font-size: 14px; color: var(--ink-2); }
.addr-item .a-phone { font-size: 12.5px; color: var(--muted); margin-top: 2px; }
.addr-del {
    margin-left: auto; background: none; border: none; color: #c2c7cf;
    cursor: pointer; font-size: 13px; padding: 5px; border-radius: 6px;
}
.addr-del:hover { color: var(--red); background: #fdf0f0; }

.fa-grid { display: grid; grid-template-columns: 1fr 1fr; gap: 14px; }
.fa-grid .full { grid-column: 1 / -1; }
.fa-grid .field { margin-bottom: 0; }

.add-addr-form { display: none; margin-top: 14px; border-top: 1px dashed var(--line); padding-top: 16px; }
.add-addr-form.open { display: block; }
.add-addr-toggle {
    font-size: 13.5px; font-weight: 600; color: var(--brand);
    background: none; border: none; cursor: pointer; padding: 0;
}
.add-addr-toggle:hover { text-decoration: underline; }

@media (max-width: 640px) {
    .info-grid, .fa-grid { grid-template-columns: 1fr; }
}
</style>
</head>
<body>

<%@ include file="/WEB-INF/jspf/header.jspf" %>

<div class="page-head">
  <h1>My account</h1>
  <p>Your details and saved delivery addresses</p>
</div>

<div class="profile-wrap">

    <% if (!messageText.isEmpty()) { %>
    <div class="alert ok" style="margin:0;">
      <div><i class="fa-solid fa-circle-check" style="margin-right:8px;"></i><%=messageText%></div>
    </div>
    <% } %>
    <% if ("limit".equals(addrErr)) { %>
    <div class="alert warn" style="margin:0;">
      <div><i class="fa-solid fa-circle-exclamation" style="margin-right:8px;"></i>You can save up to 3 addresses. Delete one to add another.</div>
    </div>
    <% } %>

    <!-- Account details -->
    <div class="p-card">
        <h2><i class="fa-regular fa-user"></i>Account</h2>

        <div id="viewPanel">
            <div class="acct-row">
                <div class="avatar"><%=initials%></div>
                <div>
                    <div class="a-name"><%=loggedInUser.getUserName()%></div>
                    <div class="a-mail"><%=loggedInUser.getEmail()%></div>
                </div>
            </div>

            <div class="info-grid">
                <div class="info-item">
                    <label>Username</label>
                    <div class="info-value"><%=loggedInUser.getUserName()%></div>
                </div>
                <div class="info-item">
                    <label>Email</label>
                    <div class="info-value"><%=loggedInUser.getEmail()%></div>
                </div>
            </div>

            <button class="btn ghost" style="margin-top:16px;" onclick="showEditPanel()">Edit details</button>
        </div>

        <div id="editPanel" style="display:none;">
            <form action="profile.jsp" method="post">
                <div class="field">
                    <label>Username</label>
                    <input type="text" name="username" value="<%=loggedInUser.getUserName()%>" required>
                </div>
                <div class="field">
                    <label>Email</label>
                    <input type="email" name="email" value="<%=loggedInUser.getEmail()%>" required>
                </div>
                <div style="display:flex;gap:10px;">
                    <button type="submit" class="btn">Save changes</button>
                    <button type="button" class="btn ghost" onclick="showViewPanel()">Cancel</button>
                </div>
            </form>
        </div>
    </div>

    <!-- Saved addresses -->
    <div class="p-card">
        <h2><i class="fa-solid fa-location-dot"></i>Saved addresses <span style="font-size:12px;font-weight:500;color:var(--muted);margin-left:2px;">(<%=addresses.size()%>/3)</span></h2>

        <% if (addresses.isEmpty()) { %>
          <p style="font-size:14px;color:var(--muted);margin-bottom:12px;">No saved addresses. Add one so checkout is one tap.</p>
        <% } else {
             for (UserAddress a : addresses) { %>
        <div class="addr-item">
          <div>
            <span class="a-label"><%=a.getLabel()%></span>
            <div class="a-line"><%=a.getAddressLine()%><%=a.getCity() != null ? ", " + a.getCity() : ""%></div>
            <% if (a.getPhone() != null) { %><div class="a-phone"><i class="fa-solid fa-phone" style="font-size:10px;margin-right:4px;"></i><%=a.getPhone()%></div><% } %>
          </div>
          <button type="button" class="addr-del" title="Delete address" onclick="deleteAddr(<%=a.getAddressId()%>)">
            <i class="fa-regular fa-trash-can"></i>
          </button>
        </div>
        <%   }
           } %>

        <% if (canAddMore) { %>
        <button type="button" class="add-addr-toggle" onclick="document.getElementById('addAddrForm').classList.toggle('open')">+ Add new address</button>

        <form action="address" method="post" class="add-addr-form <%=addresses.isEmpty() ? "open" : ""%>" id="addAddrForm">
          <input type="hidden" name="action" value="add">
          <input type="hidden" name="from" value="profile">
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

        <form action="address" method="post" id="delAddrForm" style="display:none;">
          <input type="hidden" name="action" value="delete">
          <input type="hidden" name="from" value="profile">
          <input type="hidden" name="addressId" id="delAddrId" value="">
        </form>
    </div>

</div>

<%@ include file="/WEB-INF/jspf/footer.jspf" %>

<script>
function showEditPanel() {
    document.getElementById("viewPanel").style.display = "none";
    document.getElementById("editPanel").style.display = "block";
}
function showViewPanel() {
    document.getElementById("viewPanel").style.display = "block";
    document.getElementById("editPanel").style.display = "none";
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
</script>

</body>
</html>
