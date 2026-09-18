<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
String message = request.getParameter("message");
String messageText = "";
String messageType = "";

if ("logout".equals(message)) {
    session.removeAttribute("loggedInUser");
    session.invalidate();
    messageText = "You have been logged out successfully.";
    messageType = "warning";
} else if ("registered".equals(message)) {
    messageText = "Registration Successful! Please login below.";
    messageType = "success";
} else if ("exists".equals(message)) {
    messageText = "Account already exists with that email. Please login.";
    messageType = "warning";
} else if ("invalid".equals(message)) {
    messageText = "Invalid username/email or password. Please try again.";
    messageType = "error";
} else if ("notfound".equals(message)) {
    messageText = "No account found with that username or email.";
    messageType = "error";
} else if ("reset_success".equals(message)) {
    messageText = "Password reset successful! Please login with your new password.";
    messageType = "success";
}
%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Login — TapFood</title>
<meta name="description" content="Login to TapFood to order delicious food from top restaurants near you.">
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
  width: 940px; max-width: 100%; display:flex; background:white;
  border-radius: 28px; overflow:hidden;
  box-shadow: 0 24px 64px rgba(0,0,0,0.08), 0 4px 16px rgba(0,0,0,0.04);
}

/* Left panel */
.panel-left {
  width: 42%;
  background: linear-gradient(145deg, #ff6b35 0%, #ff914d 60%, #ffb347 100%);
  color: white; padding: 56px 44px;
  display: flex; flex-direction: column; justify-content: center;
  position: relative; overflow: hidden;
}
.panel-left::before {
  content: ''; position: absolute; top: -80px; right: -80px;
  width: 250px; height: 250px; background: rgba(255,255,255,0.08);
  border-radius: 50%;
}
.panel-left::after {
  content: ''; position: absolute; bottom: -60px; left: -60px;
  width: 200px; height: 200px; background: rgba(255,255,255,0.06);
  border-radius: 50%;
}
.brand { font-size: 32px; font-weight: 800; margin-bottom: 32px; position: relative; z-index: 1; }
.panel-left h2 { font-size: 26px; font-weight: 700; margin-bottom: 10px; position: relative; z-index: 1; }
.panel-left p { font-size: 14px; line-height: 1.8; opacity: 0.92; margin-bottom: 32px; position: relative; z-index: 1; }
.feature-list { list-style: none; position: relative; z-index: 1; }
.feature-list li {
  background: rgba(255,255,255,0.14); backdrop-filter: blur(10px);
  border: 1px solid rgba(255,255,255,0.25); border-radius: 14px;
  padding: 13px 18px; margin-bottom: 10px; font-size: 14px; font-weight: 500;
  display: flex; align-items: center; gap: 12px;
  transition: all 0.3s ease;
}
.feature-list li:hover { background: rgba(255,255,255,0.22); transform: translateX(6px); }

/* Right panel */
.panel-right {
  width: 58%; padding: 56px 50px;
  display: flex; flex-direction: column; justify-content: center;
}
.panel-right h2 { font-size: 28px; font-weight: 800; color: #1a202c; margin-bottom: 6px; }
.panel-right .subtitle { font-size: 14px; color: #718096; margin-bottom: 28px; }

/* Message banner */
.msg-banner {
  display: flex; align-items: center; gap: 10px;
  padding: 13px 16px; border-radius: 14px;
  font-size: 14px; font-weight: 600; margin-bottom: 22px;
}
.msg-banner.success { background: #f0fff4; color: #276749; border: 1px solid #c6f6d5; }
.msg-banner.error   { background: #fff5f5; color: #c53030; border: 1px solid #fed7d7; }
.msg-banner.warning { background: #fffbeb; color: #b45309; border: 1px solid #fde68a; }

/* Form */
.form-group { margin-bottom: 20px; }
.form-group label {
  display: block; font-size: 11px; font-weight: 700;
  text-transform: uppercase; letter-spacing: 0.8px; color: #718096; margin-bottom: 8px;
}
.input-wrap { position: relative; }
.input-wrap input {
  width: 100%; padding: 13px 44px 13px 16px;
  border: 1.5px solid #e2e8f0; background: #f8fafc;
  border-radius: 12px; font-size: 15px; color: #2d3748;
  font-family: 'Poppins', sans-serif;
  transition: all 0.25s ease;
}
.input-wrap input:focus {
  outline: none; border-color: #ff6b35; background: white;
  box-shadow: 0 0 0 4px rgba(255,107,53,0.12);
}
.input-wrap input.error-field { border-color: #e53e3e; background: #fff5f5; }
.input-wrap input.valid-field { border-color: #10b981; background: #f0fff4; }

.toggle-pass {
  position: absolute; right: 14px; top: 50%; transform: translateY(-50%);
  background: none; border: none; cursor: pointer; font-size: 18px;
  color: #a0aec0; padding: 0; width: auto; margin-top: 0;
  box-shadow: none; transition: color 0.2s ease;
}
.toggle-pass:hover { color: #ff6b35; }

.field-error { font-size: 12px; color: #e53e3e; margin-top: 5px; font-weight: 500; display: none; }
.field-error.visible { display: block; }

.forgot-row { display: flex; justify-content: flex-end; margin-top: -10px; margin-bottom: 16px; }
.forgot-row a { font-size: 13px; color: #ff6b35; font-weight: 600; text-decoration: none; }
.forgot-row a:hover { text-decoration: underline; }

/* Submit button */
.submit-btn {
  width: 100%; padding: 14px; border: none;
  background: linear-gradient(135deg, #ff6b35, #f05a1a);
  color: white; font-size: 16px; font-weight: 700;
  border-radius: 14px; cursor: pointer; margin-top: 8px;
  box-shadow: 0 5px 18px rgba(255,107,53,0.35);
  transition: all 0.25s ease; font-family: 'Poppins', sans-serif;
}
.submit-btn:hover { transform: translateY(-2px); box-shadow: 0 8px 24px rgba(255,107,53,0.45); }
.submit-btn:active { transform: translateY(0); }
.submit-btn:disabled { opacity: 0.6; cursor: not-allowed; transform: none; }

.divider { display: flex; align-items: center; gap: 12px; margin: 20px 0; color: #cbd5e0; font-size: 13px; }
.divider::before, .divider::after { content:''; flex:1; height:1px; background:#e2e8f0; }

.footer-link { text-align: center; color: #718096; font-size: 14px; margin-top: 20px; }
.footer-link a { color: #ff6b35; font-weight: 700; text-decoration: none; transition: color 0.2s; }
.footer-link a:hover { color: #e6501b; text-decoration: underline; }

@media (max-width: 820px) {
  .card { flex-direction: column; border-radius: 20px; }
  .panel-left, .panel-right { width: 100%; }
  .panel-left { padding: 40px 32px; }
  .panel-right { padding: 36px 32px; }
}
</style>
</head>
<body>

<div class="card">

  <!-- Left -->
  <div class="panel-left">
    <div class="brand"><i class="fa-solid fa-burger"></i> TapFood</div>
    <h2>Welcome Back!</h2>
    <p>Login to explore delicious food from hundreds of restaurants. Fast delivery, great offers, and amazing dining experience.</p>
    <ul class="feature-list">
      <li>🍕 Thousands of Restaurants</li>
      <li>🚀 30-min Fast Delivery</li>
      <li>💳 100% Secure Payments</li>
      <li>🎁 Daily Exclusive Offers</li>
      <li>⭐ Real-time Order Tracking</li>
    </ul>
  </div>

  <!-- Right -->
  <div class="panel-right">
    <h2>Sign In</h2>
    <p class="subtitle">Enter your credentials to continue ordering</p>

    <% if (!messageText.isEmpty()) { %>
    <div class="msg-banner <%=messageType%>">
      <% if("success".equals(messageType)) { %>✅<% } else if("error".equals(messageType)) { %>❌<% } else { %>⚠️<% } %>
      <%=messageText%>
    </div>
    <% } %>

    <form id="loginForm" action="Login" method="post" autocomplete="off" novalidate>

      <div class="form-group">
        <label for="username">Username or Email</label>
        <div class="input-wrap">
          <input type="text" id="username" name="username" placeholder="Enter username or email" autocomplete="off">
        </div>
        <div class="field-error" id="err-username">Please enter your username or email.</div>
      </div>

      <div class="form-group">
        <label for="password">Password</label>
        <div class="input-wrap">
          <input type="password" id="password" name="password" placeholder="Enter your password" autocomplete="new-password">
          <button type="button" class="toggle-pass" onclick="togglePass('password','eyePass')" id="eyePass"><i class="fa-solid fa-eye"></i></button>
        </div>
        <div class="field-error" id="err-password">Please enter your password.</div>
      </div>

      <div class="forgot-row">
        <a href="forgotPassword.jsp"><i class="fa-solid fa-key"></i> Forgot Password?</a>
      </div>

      <button type="submit" class="submit-btn" id="loginBtn">Login →</button>
    </form>

    <div class="divider">or</div>

    <div class="footer-link">
      Don't have an account? <a href="register.html">Create Account</a>
    </div>
  </div>

</div>

<script>
function togglePass(fieldId, btnId) {
  const field = document.getElementById(fieldId);
  const btn   = document.getElementById(btnId);
  if (field.type === 'password') {
    field.type = 'text';
    btn.innerHTML = '<i class="fa-solid fa-eye-slash"></i>';
  } else {
    field.type = 'password';
    btn.innerHTML = '<i class="fa-solid fa-eye"></i>';
  }
}

document.getElementById('loginForm').addEventListener('submit', function(e) {
  let valid = true;

  const username = document.getElementById('username').value.trim();
  const password = document.getElementById('password').value.trim();

  // Clear errors
  document.querySelectorAll('.field-error').forEach(el => el.classList.remove('visible'));
  document.querySelectorAll('input').forEach(el => { el.classList.remove('error-field'); el.classList.remove('valid-field'); });

  if (!username) {
    document.getElementById('err-username').classList.add('visible');
    document.getElementById('username').classList.add('error-field');
    valid = false;
  } else {
    document.getElementById('username').classList.add('valid-field');
  }

  if (!password || password.length < 4) {
    document.getElementById('err-password').textContent = password.length === 0
      ? 'Please enter your password.'
      : 'Password must be at least 4 characters.';
    document.getElementById('err-password').classList.add('visible');
    document.getElementById('password').classList.add('error-field');
    valid = false;
  } else {
    document.getElementById('password').classList.add('valid-field');
  }

  if (!valid) { e.preventDefault(); return; }

  // Show loading state
  const btn = document.getElementById('loginBtn');
  btn.disabled = true;
  btn.textContent = 'Logging in...';
});

// Real-time validation
document.getElementById('username').addEventListener('input', function() {
  if (this.value.trim()) {
    this.classList.remove('error-field'); this.classList.add('valid-field');
    document.getElementById('err-username').classList.remove('visible');
  }
});
document.getElementById('password').addEventListener('input', function() {
  if (this.value.trim().length >= 4) {
    this.classList.remove('error-field'); this.classList.add('valid-field');
    document.getElementById('err-password').classList.remove('visible');
  }
});
</script>
</body>
</html>