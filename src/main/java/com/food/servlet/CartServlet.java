package com.food.servlet;

import java.io.IOException;

import com.tap.DAOImpl.MenuDAOImpl;
import com.tap.model.Cart;
import com.tap.model.Menu;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/cart")
public class CartServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        Cart cart = (Cart) req.getSession().getAttribute("cart");
        if (cart == null) {
            cart = new Cart();
            req.getSession().setAttribute("cart", cart);
        }
        String action = req.getParameter("action");
        if ("add".equals(action)) {
            addItemToCart(req, resp, cart);
        } else if ("update".equals(action)) {
            updateItemInCart(req, resp, cart);
        } else if ("remove".equals(action)) {
            removeItemFromCart(req, resp, cart);
        } else {
            resp.sendRedirect("cart.jsp");
        }
    }

    /**
     * When the request came from a restaurant menu page ("from=menu"), stay on that
     * page so the user can keep adding items - like a real ordering flow.
     */
    private String backTo(HttpServletRequest req, int restaurantId, boolean added) {
        if ("menu".equals(req.getParameter("from")) && restaurantId > 0) {
            return "menu?restaurantId=" + restaurantId + (added ? "&added=1" : "");
        }
        return "cart.jsp";
    }

    private void addItemToCart(HttpServletRequest req, HttpServletResponse resp, Cart cart) throws IOException {
        int restaurantId = 0;
        try {
            int menuId   = Integer.parseInt(req.getParameter("menuId"));
            int quantity = Integer.parseInt(req.getParameter("quantity"));
            MenuDAOImpl menuDAO = new MenuDAOImpl();
            Menu menu = menuDAO.getMenuById(menuId);

            if (menu != null) {
                restaurantId = menu.getRestaurantId();
                // Single-restaurant check
                int currentRestId = cart.getRestaurantId();
                if (currentRestId != 0 && currentRestId != menu.getRestaurantId()) {
                    resp.sendRedirect("menu?restaurantId=" + menu.getRestaurantId() + "&error=diff_restaurant");
                    return;
                }
                cart.addItem(menu, quantity);
                req.getSession().setAttribute("cart", cart);
            }
        } catch (Exception e) { e.printStackTrace(); }
        resp.sendRedirect(backTo(req, restaurantId, true));
    }

    private void updateItemInCart(HttpServletRequest req, HttpServletResponse resp, Cart cart) throws IOException {
        int restaurantId = 0;
        try {
            int menuId = Integer.parseInt(req.getParameter("menuId"));
            int qty    = Integer.parseInt(req.getParameter("qty"));
            restaurantId = cart.getRestaurantId();
            cart.updateItem(menuId, qty);
            req.getSession().setAttribute("cart", cart);
        } catch (Exception e) { e.printStackTrace(); }
        resp.sendRedirect(backTo(req, restaurantId, false));
    }

    private void removeItemFromCart(HttpServletRequest req, HttpServletResponse resp, Cart cart) throws IOException {
        try {
            int menuId = Integer.parseInt(req.getParameter("menuId"));
            cart.remove(menuId);
            req.getSession().setAttribute("cart", cart);
        } catch (Exception e) { e.printStackTrace(); }
        resp.sendRedirect("cart.jsp");
    }
}
