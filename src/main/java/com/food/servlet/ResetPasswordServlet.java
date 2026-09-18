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

@WebServlet("/ResetPassword")
public class ResetPasswordServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String email = req.getParameter("email");
        String newPassword = req.getParameter("newPassword");

        if (email != null) email = email.trim();

        UserDAOImpl dao = new UserDAOImpl();
        User user = dao.getUserByEmail(email);

        if (user == null) {
            resp.sendRedirect("forgotPassword.jsp?message=notfound");
            return;
        }

        // Hash new password and update user in DB
        String hashedPassword = BCrypt.hashpw(newPassword, BCrypt.gensalt(12));
        user.setPassword(hashedPassword);
        dao.updateUser(user);

        resp.sendRedirect("Login.jsp?message=reset_success");
    }
}