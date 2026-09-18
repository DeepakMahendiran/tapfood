package com.food.servlet;

import java.io.IOException;

import com.tap.DAOImpl.OrderDAOImpl;
import com.tap.DAOImpl.OrderItemDAOImpl;
import com.tap.DAOImpl.UserAddressDAOImpl;
import com.tap.model.Cart;
import com.tap.model.CartItem;
import com.tap.model.Order;
import com.tap.model.OrderItem;
import com.tap.model.User;
import com.tap.model.UserAddress;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/placeOrder")
public class OrderServlet extends HttpServlet {

    private static final double DELIVERY_FEE = 40.0;
    private static final double GST_RATE     = 0.05;

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession();
        User user = (User) session.getAttribute("loggedInUser");
        if (user == null) { resp.sendRedirect("Login.jsp"); return; }

        Cart cart = (Cart) session.getAttribute("cart");
        if (cart == null || cart.getItems().isEmpty()) { resp.sendRedirect("cart.jsp"); return; }

        // Delivery address must be one of the user's saved addresses
        UserAddress selected = null;
        try {
            int addressId = Integer.parseInt(req.getParameter("addressId"));
            UserAddress a = new UserAddressDAOImpl().getAddress(addressId);
            if (a != null && a.getUserId() == user.getUserId()) selected = a;
        } catch (NumberFormatException ignored) {
        }
        if (selected == null) {
            resp.sendRedirect("checkout.jsp?error=noaddress");
            return;
        }

        String paymentMode = req.getParameter("paymentMode");
        if (paymentMode == null || paymentMode.trim().isEmpty()) paymentMode = "Cash on Delivery";

        double subtotal    = cart.getTotal();
        double gst         = subtotal * GST_RATE;
        double totalAmount = subtotal + DELIVERY_FEE + gst;
        int    restaurantId = cart.getRestaurantId();

        Order order = new Order(user.getUserId(), restaurantId, (float) totalAmount, "Preparing", paymentMode);
        order.setDeliveryAddress(selected.getLabel() + ": " + selected.toDeliveryString());

        OrderDAOImpl orderDAO = new OrderDAOImpl();
        int orderId = orderDAO.addOrder(order);
        if (orderId <= 0) {
            resp.sendRedirect("checkout.jsp?error=orderfailed");
            return;
        }

        OrderItemDAOImpl orderItemDAO = new OrderItemDAOImpl();
        for (CartItem cartItem : cart.getItems().values()) {
            float itemTotal = (float) (cartItem.getPrice() * cartItem.getQty());
            orderItemDAO.addOrderItem(new OrderItem(orderId, cartItem.getMenuId(),
                    cartItem.getQty(), (float) cartItem.getPrice(), itemTotal));
        }

        session.removeAttribute("cart");
        req.setAttribute("orderId",     orderId);
        req.setAttribute("totalAmount", String.format("%.2f", totalAmount));
        req.setAttribute("paymentMode", paymentMode);
        req.setAttribute("deliveryAddress", order.getDeliveryAddress());
        req.getRequestDispatcher("orderSuccess.jsp").forward(req, resp);
    }
}
