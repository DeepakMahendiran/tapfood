package com.food.servlet;

import java.io.IOException;
import java.util.List;

import com.tap.DAOImpl.MenuDAOImpl;
import com.tap.DAOImpl.RestaurantDAOImpl;
import com.tap.model.Menu;
import com.tap.model.Restaurant;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/menu")
public class MenuServlet extends HttpServlet  {

	@Override
	protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		String id=req.getParameter("restaurantId");
		int restaurantId=Integer.parseInt(id);
		MenuDAOImpl menuDAOImpl=new MenuDAOImpl();
		List<Menu> menus=menuDAOImpl.getMenuByRestaurantId(restaurantId);
		RestaurantDAOImpl restaurantDAOImpl=new RestaurantDAOImpl();
		Restaurant restaurant = restaurantDAOImpl.getRestaurant(restaurantId);
		for(Menu m:menus) {
			System.out.print(m);
		}
		req.setAttribute("restaurant",restaurant);
		req.setAttribute("menus",menus);
		RequestDispatcher rd=req.getRequestDispatcher("menu.jsp");
		rd.forward(req,resp);
	}

}
