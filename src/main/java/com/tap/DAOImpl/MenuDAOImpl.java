package com.tap.DAOImpl;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;

import com.tap.DAO.MenuDAO;
import com.tap.model.Menu;
import com.tap.utility.DBConnection;

public class MenuDAOImpl implements MenuDAO {
String insert="insert into menu(restaurantId,itemName,description,price,isAvailable,imagePath)values(?,?,?,?,?,?)";
String getmenu="select * from menu where menuId=?";
String getAll="select * from menu";
String update="update menu set restaurantID=?, itemName=?, description=?, price=? , isAvailable=?, imagePath=? where menuId=?";
String delete="delete from menu where menuId=?";
String getmenubyresid="select * from menu where restaurantId=?";
	@Override
	public void addMenu(Menu menu) {
		// TODO Auto-generated method stub
		try(Connection con=DBConnection.getConnection();
				PreparedStatement pst=con.prepareStatement(insert);){
			pst.setInt(1, menu.getRestaurantId());
			pst.setString(2,menu.getItemName() );
			pst.setString(3,menu.getDescription());
			pst.setFloat(4, menu.getPrice());
			pst.setBoolean(5, menu.isAvailable());
			pst.setString(6,menu.getImagePath());
			int i=pst.executeUpdate();
			System.out.print(i+"row(s) affected");
			
		}
		catch(SQLException e) {
			e.printStackTrace();
		}
	}

	@Override
	public Menu getMenuById(int menuId) {
		try(Connection con=DBConnection.getConnection();
				PreparedStatement pst=con.prepareStatement(getmenu);){
			pst.setInt(1, menuId);
			ResultSet res=pst.executeQuery();
			if(res.next()) {
				int menuId1=res.getInt("menuId");
				int restaurantId=res.getInt("restaurantId");
			String itemName=res.getString("itemName");
			String description=res.getString("description");
			float price=res.getFloat("price");
			boolean isAvailable=res.getBoolean("isAvailable");
			String imagePath=res.getString("imagePath");
			return new Menu(menuId1,restaurantId, itemName,description,price,isAvailable,imagePath);	
			}
		}
		catch(SQLException e) {
			e.printStackTrace();
		}
		return null;
	}

	@Override
	public ArrayList<Menu> getAllMenus() {
		try(Connection con=DBConnection.getConnection();
				Statement st=con.createStatement();){
			
			ArrayList<Menu> menus=new ArrayList<Menu>();
 			ResultSet res=st.executeQuery(getAll);
			while(res.next()) {
				int menuId=res.getInt("menuId");
				int restaurantId=res.getInt("restaurantId");
			String itemName=res.getString("itemName");
			String description=res.getString("description");
			float price=res.getFloat("price");
			boolean isAvailable=res.getBoolean("isAvailable");
         	String imagePath=res.getString("imagePath");
	
Menu m=new Menu(menuId,restaurantId, itemName,description,price,isAvailable,imagePath);	
menus.add(m);
			}
			return menus;
		}
		catch(SQLException e) {
			e.printStackTrace();
		}
		return null;
	}

	@Override
	public void updateMenu(Menu menu) {
		// TODO Auto-generated method stub
		try(Connection con=DBConnection.getConnection();
				PreparedStatement pst=con.prepareStatement(update);){
			
			pst.setInt(1, menu.getRestaurantId());
			pst.setString(2,menu.getItemName() );
			pst.setString(3,menu.getDescription());
			pst.setFloat(4, menu.getPrice());
			pst.setBoolean(5, menu.isAvailable());
			pst.setString(6,menu.getImagePath());
			pst.setInt(7, menu.getMenuId());
			int i=pst.executeUpdate();
			System.out.print(i+"row(s) affected");
		}
		
	
		catch(SQLException e) {
			e.printStackTrace();
		}
	}

	@Override
	public void deleteMenu(int menuId) {
		// TODO Auto-generated method stub
		try(Connection con=DBConnection.getConnection();
				PreparedStatement pst=con.prepareStatement(delete);){
			pst.setInt(1,menuId);
			int i=pst.executeUpdate();
			System.out.print(i+"row(s) deleted");
		
		
	}
		catch(SQLException e) {
			e.printStackTrace();
		}
		

}

	@Override
	public ArrayList<Menu> getMenuByRestaurantId(int restaurantId) {
		try(Connection con=DBConnection.getConnection();
				PreparedStatement pst=con.prepareStatement(getmenubyresid);
				){
		pst.setInt(1, restaurantId);
		ResultSet res=pst.executeQuery();
		ArrayList<Menu> menuList=new ArrayList<>();
		while(res.next()) {
			 int menuId = res.getInt("menuId");
			    int restaurantId1 = res.getInt("restaurantId");
			    String itemName = res.getString("itemName");
			    String description = res.getString("description");
			    float price = res.getFloat("price");
			    boolean isAvailable = res.getBoolean("isAvailable");
			    String imagePath = res.getString("imagePath");

			    Menu menu = new Menu(
			            menuId,
			            restaurantId1,
			            itemName,
			            description,
			            price,
			            isAvailable,
			            imagePath);

			    menuList.add(menu);
		}
		return menuList;
			
		}
		catch(Exception e) {
			e.printStackTrace();
		}
		return new ArrayList<>();
	}
}
