package com.tap.DAOImpl;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
//import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
//import java.util.List;

import com.tap.DAO.RestaurantDAO;
import com.tap.model.Restaurant;
import com.tap.utility.DBConnection;

public class RestaurantDAOImpl implements RestaurantDAO {
	
	String insert="insert into Restaurant(name,cuisineType,DeliveryTime,Address,adminUserId,Rating,IsActive,ImagePath)values(?,?,?,?,?,?,?,?)";
	String GETRESTAURANT="select * from Restaurant where restaurantId=?";
	String getall="select  * from restaurant";
	String update="update restaurant set name=?, cuisineType=?, DeliveryTime=?, Address=?, adminUserId=?, Rating=?, IsActive=?, ImagePath=? where restaurantId=?";
	String delete="delete from restaurant where restaurantId=?";

	@Override
	public void addRestaurant(Restaurant restaurant) {
		// TODO Auto-generated method stub
		try(Connection con=DBConnection.getConnection();
				PreparedStatement pst=con.prepareStatement(insert);
				
				)
		{
			pst.setString(1,restaurant.getName());
			pst.setString(2, restaurant.getCuisineType());
			pst.setInt(3,restaurant.getDeliveryTime());
			pst.setString(4, restaurant.getAddress());
			pst.setInt(5, restaurant.getAdminUserId());
			pst.setFloat(6,restaurant.getRating());
			pst.setBoolean(7, restaurant.isActive());
			pst.setString(8,restaurant.getImagePath());
			
			int i=pst.executeUpdate();
			System.out.println(i+"rows affected");
			
		}
		catch(Exception e) {
			e.printStackTrace();
		}
		
	}

	@Override
	public Restaurant getRestaurant(int restaurantId) {
		// TODO Auto-generated method stub
		try (
				Connection con=DBConnection.getConnection();
				PreparedStatement pst=con.prepareStatement(GETRESTAURANT);
				
					){
			pst.setInt(1,restaurantId );
			ResultSet res=pst.executeQuery();
			if(res.next()) {
				int restaurantId1=res.getInt("restaurantId");
			String name=res.getString("name");
				String cuisineType=res.getString("cuisineType");
				int deliveryTime=res.getInt("deliveryTime");
				String address=res.getString("address");
				int adminUserId=res.getInt("adminUserId");
				float rating=res.getFloat("rating");
				boolean isActive=res.getBoolean("isActive");
				String imagePath=res.getString("imagePath");
				
				
				Restaurant r=new Restaurant(restaurantId1,name,cuisineType,deliveryTime,address,adminUserId,rating,isActive,imagePath);
				return r;
			}
		}
			catch(Exception e) {
				e.printStackTrace();
			}
		return null;
	
	}

	@Override
	public ArrayList<Restaurant> getAllRestaurants() {
		// TODO Auto-generated method stub
		try(Connection con=DBConnection.getConnection();
				Statement st=con.createStatement();){
			
			ArrayList<Restaurant> restaurants=new ArrayList<>();
			ResultSet res=st.executeQuery(getall);
			while(res.next()) {
				int restaurantId1=res.getInt("restaurantId");
				String name=res.getString("name");
					String cuisineType=res.getString("cuisineType");
					int deliveryTime=res.getInt("deliveryTime");
					String address=res.getString("address");
					int adminUserId=res.getInt("adminUserId");
					float rating=res.getFloat("rating");
					boolean isActive=res.getBoolean("isActive");
					String imagePath=res.getString("imagePath");
					Restaurant r2=new Restaurant(restaurantId1,name,cuisineType,deliveryTime,address,adminUserId,rating,isActive,imagePath);
					restaurants.add(r2);
			}
			return  restaurants;
			
			
		}
		catch(Exception e) {
			e.printStackTrace();
		}
		return null;
	}

	@Override
	public void updateRestaurant(Restaurant restaurant) {
		// TODO Auto-generated method stub
		try(Connection con=DBConnection.getConnection();
				PreparedStatement pst=con.prepareStatement(update);)
		{
			pst.setString(1,restaurant.getName());
			pst.setString(2, restaurant.getCuisineType());
			pst.setInt(3,restaurant.getDeliveryTime());
			pst.setString(4, restaurant.getAddress());
			pst.setInt(5, restaurant.getAdminUserId());
			pst.setFloat(6, restaurant.getRating());
			pst.setBoolean(7, restaurant.isActive());
			pst.setString(8, restaurant.getImagePath());
			pst.setInt(9, restaurant.getRestaurantId());
			
			int i=pst.executeUpdate();
			System.out.println(i+"rows affected");
			
		}
		catch(Exception e) {
			e.printStackTrace();
		}

	}

	@Override
	public void deleteRestaurant(int restaurantId) {
		// TODO Auto-generated method stub
		try(Connection con=DBConnection.getConnection();
		PreparedStatement pst=con.prepareStatement(delete);){
			pst.setInt(1, restaurantId);
			int i=pst.executeUpdate();
			System.out.print(i+" row(s) deleted");
		}
		catch(Exception e) {
			e.printStackTrace();
		}
		
	}

}
