<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
String message = request.getParameter("message");
String messageText = "";
String messageType = "";

if ("notfound".equals(message)) {
    messageText = "No user found with that email address.";
    messageType = "error";
}
%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Forgot Password — TapFood</title>
<link rel="preconnect" href="https://fonts.googleapis.com">
<link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css">
<style>
* { margin:0; padding:0; box-sizing:border-box; font-family:'Poppins',sans-serif; }

body {
  background: radial-gradient(circle at 15% 50%, rgba(255,107,53,0.08) 0%, transparent 50%),
              radial-gradient(circle at 85% 20%, rgba(255,145,77,0.06) 0%, transparent 50%),
              #f7f5f2;
  min-height: 100vh; display:flex; justify-content:center; align-items:center; padding: 20px;
}

.card {
  width: 480px; max-width: 100%; background:white;
  border-radius: 28px; padding: 48px 40px;
  box-shadow: 0 24px 64px rgba(0,0,0,0.08), 0 4px 16px rgba(0,0,0,0.04);
}

.brand { font-size: 28px; font-weight: 800; color: #ff6b35; margin-bottom: 8px; text-align: center; }
.subtitle { font-size: 14px; color: #718096; text-align: center; margin-bottom: 28px; }

.msg-banner {
  display: flex; align-items: center; gap: 10px;
  padding: 13px 16px; border-radius: 14px;
  font-size: 14px; font-weight: 600; margin-bottom: 22px;
}
.msg-banner.error { background: #fff5f5; color: #c53030; border: 1px solid #fed7d7; }

.form-group { margin-bottom: 20px; }
.form-group label {
  display: block; font-size: 11px; font-weight: 700;
  text-transform: uppercase; letter-spacing: 0.8px; color: #718096; margin-bottom: 8px;
}
.input-wrap { position: relative; }
.input-wrap input {
  width: 100%; padding: 13px 16px;
  border: 1.5px solid #e2e8f0; background: #f8fafc;
  border-radius: 12px; font-size: 15px; color: #2d3748;
  transition: all 0.25s ease;
}
.input-wrap input:focus {
  outline: none; border-color: #ff6b35; background: white;
  box-shadow: 0 0 0 4px rgba(255,107,53,0.12);
}

.submit-btn {
  width: 100%; padding: 14px; border: none;
  background: linear-gradient(135deg, #ff6b35, #f05a1a);
  color: white; font-size: 16px; font-weight: 700;
  border-radius: 14px; cursor: pointer; margin-top: 8px;
  box-shadow: 0 5px 18px rgba(255,107,53,0.35);
  transition: all 0.25s ease;
}
.submit-btn:hover { transform: translateY(-2px); box-shadow: 0 8px 24px rgba(255,107,53,0.45); }

.back-link { text-align: center; margin-top: 24px; font-size: 14px; }
.back-link a { color: #ff6b35; font-weight: 700; text-decoration: none; }
.back-link a:hover { text-decoration: underline; }
</style>
</head>
<body>

<div class="card">
  <div class="brand"><i class="fa-solid fa-burger"></i> TapFood</div>
  <p class="subtitle">Reset Your Password</p>

  <% if (!messageText.isEmpty()) { %>
  <div class="msg-banner <%=messageType%>">
    ❌ <%=messageText%>
  </div>
  <% } %>

  <form action="ResetPassword" method="post" id="resetForm">
    <div class="form-group">
      <label for="email">Registered Email Address *</label>
      <div class="input-wrap">
        <input type="email" id="email" name="email" placeholder="Enter your registered email" required>
      </div>
    </div>

    <div class="form-group">
      <label for="newPassword">New Password *</label>
      <div class="input-wrap">
        <input type="password" id="newPassword" name="newPassword" placeholder="Enter new password (min. 6 chars)" minlength="6" required>
      </div>
    </div>

    <button type="submit" class="submit-btn">Reset Password →</button>
  </form>

  <div class="back-link">
    Remembered your password? <a href="Login.jsp">Back to Sign In</a>
  </div>
</div>

</body>
</html>