package com.food.servlet;

import java.io.IOException;
import java.util.List;

import com.tap.DAOImpl.UserAddressDAOImpl;
import com.tap.model.User;
import com.tap.model.UserAddress;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

/**
 * Manages a user's saved delivery addresses (max 3).
 * Called from checkout.jsp and profile.jsp.
 */
@WebServlet("/address")
public class AddressServlet extends HttpServlet {

    public static final int MAX_ADDRESSES = 3;

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        User user = (User) req.getSession().getAttribute("loggedInUser");
        if (user == null) {
            resp.sendRedirect("Login.jsp");
            return;
        }

        String action = req.getParameter("action");
        // where to go back to after the operation: "checkout" or "profile"
        String from = req.getParameter("from");
        String target = "checkout.jsp".equals(from) || "checkout".equals(from) ? "checkout.jsp" : "profile.jsp";

        UserAddressDAOImpl dao = new UserAddressDAOImpl();

        if ("add".equals(action)) {
            List<UserAddress> existing = dao.getAddressesByUser(user.getUserId());
            if (existing.size() >= MAX_ADDRESSES) {
                resp.sendRedirect(target + "?addrError=limit");
                return;
            }
            String label = trimOrNull(req.getParameter("label"));
            String line  = trimOrNull(req.getParameter("addressLine"));
            String city  = trimOrNull(req.getParameter("city"));
            String phone = trimOrNull(req.getParameter("phone"));

            if (line == null) {
                resp.sendRedirect(target + "?addrError=empty");
                return;
            }
            if (label == null) label = "Home";
            dao.addAddress(new UserAddress(user.getUserId(), label, line, city, phone));
            resp.sendRedirect(target + "?addrMsg=added");

        } else if ("delete".equals(action)) {
            try {
                int addressId = Integer.parseInt(req.getParameter("addressId"));
                dao.deleteAddress(addressId, user.getUserId());
            } catch (NumberFormatException ignored) {
            }
            resp.sendRedirect(target + "?addrMsg=deleted");

        } else {
            resp.sendRedirect(target);
        }
    }

    private String trimOrNull(String s) {
        if (s == null) return null;
        s = s.trim();
        return s.isEmpty() ? null : s;
    }
}
