package com.tap.DAO;

import java.util.ArrayList;

import com.tap.model.Menu;

public interface MenuDAO {
	

	    void addMenu(Menu menu);

	    Menu getMenuById(int menuId);

	    ArrayList<Menu> getAllMenus();
	   ArrayList<Menu> getMenuByRestaurantId(int restaurantId);

	    void updateMenu(Menu menu);

	    void deleteMenu(int menuId);
	}


