package com.food.servlet;

import java.io.IOException;
import org.mindrot.jbcrypt.BCrypt;

import com.tap.DAOImpl.UserDAOImpl;
import com.tap.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/Login")
public class LoginServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String usernameOrEmail = req.getParameter("username");
        String password = req.getParameter("password");

        if (usernameOrEmail != null) {
            usernameOrEmail = usernameOrEmail.trim();
        }
        if (password == null) {
            password = "";
        }

        UserDAOImpl userDAO = new UserDAOImpl();
        User user = null;

        // Try lookup by Email first (unique identifier)
        if (usernameOrEmail != null && usernameOrEmail.contains("@")) {
            user = userDAO.getUserByEmail(usernameOrEmail);
        }

        // If not found by email, try lookup by Username
        if (user == null && usernameOrEmail != null) {
            user = userDAO.getUserbyName(usernameOrEmail);
        }

        if (user == null) {
            resp.sendRedirect("Login.jsp?message=notfound");
            return;
        }

        boolean passMatch = false;
        String storedPass = user.getPassword();

        if (storedPass != null && (storedPass.startsWith("$2a$") || storedPass.startsWith("$2b$") || storedPass.startsWith("$2y$"))) {
            try {
                passMatch = BCrypt.checkpw(password, storedPass);
            } catch (Exception e) {
                passMatch = false;
            }
        } else if (storedPass != null) {
            passMatch = password.equals(storedPass);
        }

        if (passMatch) {
            HttpSession session = req.getSession();
            session.setAttribute("loggedInUser", user);
            resp.sendRedirect("restaurant");
        } else {
            resp.sendRedirect("Login.jsp?message=invalid");
        }
    }
}