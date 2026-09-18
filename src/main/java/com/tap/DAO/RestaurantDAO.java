package com.tap.DAO;

import java.util.ArrayList;

import com.tap.model.Restaurant;

public interface RestaurantDAO {
	void addRestaurant(Restaurant restaurant);

	Restaurant getRestaurant(int restaurantId);

	ArrayList<Restaurant> getAllRestaurants();

	void updateRestaurant(Restaurant restaurant);

	void deleteRestaurant(int restaurantId);
}
