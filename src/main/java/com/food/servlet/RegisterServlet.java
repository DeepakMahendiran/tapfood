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

@WebServlet("/Registration")
public class RegisterServlet extends HttpServlet {

    @Override
    protected void service(HttpServletRequest req,
                           HttpServletResponse resp)
            throws ServletException, IOException {

        // Get data from register form
        String username = req.getParameter("username");
        String email = req.getParameter("email");
        String password = req.getParameter("password");
        String address = req.getParameter("address");
        String role = req.getParameter("role");

        UserDAOImpl dao = new UserDAOImpl();

        // Check whether the email already exists
        User existingUser = dao.getUserByEmail(email);

        if (existingUser != null) {

            // User already exists
            resp.sendRedirect("Login.jsp?message=exists");
            return;
        }

        // Hash the password
        String hashedPassword = BCrypt.hashpw(password, BCrypt.gensalt(12));

        // Create User object
        User user = new User(
                username,
                email,
                hashedPassword,
                address,
                role
        );

        // Save user
        dao.addUser(user);

        // Redirect to login page
        resp.sendRedirect("Login.jsp?message=registered");
    }
}