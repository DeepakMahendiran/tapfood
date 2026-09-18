package com.tap.DAOImpl;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Timestamp;
import java.util.ArrayList;

import com.tap.DAO.OrderDAO;
import com.tap.model.Order;
import com.tap.utility.DBConnection;

public class OrderDAOImpl implements OrderDAO{
String INSERT="insert into OrderTable(userId,restaurantId,totalAmount,status,paymentMode,deliveryAddress)values(?,?,?,?,?,?)";
String GET="select * from orderTable where orderId=?";
String GETALL="select * from orderTable";
String UPDATE="update orderTable set userId=?,restaurantId=?,totalAmount=?,status=?,paymentMode=? where orderId=?";
String DELETE="delete from orderTable where orderId=?";
	@Override
	public int addOrder(Order order) {
		try(Connection con = DBConnection.getConnection();
			PreparedStatement pst = con.prepareStatement(INSERT, Statement.RETURN_GENERATED_KEYS)) {

			pst.setInt(1, order.getUserId());
			pst.setInt(2, order.getRestaurantId());
			pst.setFloat(3, order.getTotalAmount());
			pst.setString(4, order.getStatus());
			pst.setString(5, order.getPaymentMode());
			pst.setString(6, order.getDeliveryAddress());

			int rows = pst.executeUpdate();
			System.out.println(rows + " row(s) affected");

			// Retrieve the auto-generated orderId
			ResultSet generatedKeys = pst.getGeneratedKeys();
			if (generatedKeys.next()) {
				return generatedKeys.getInt(1);
			}
		}
		catch(SQLException e) {
			e.printStackTrace();
		}
		return -1;
	}


	@Override
	public Order getOrder(int orderId) {
		try(Connection con=DBConnection.getConnection();
				PreparedStatement pst=con.prepareStatement(GET);	
					){
			pst.setInt(1, orderId);
			ResultSet res=pst.executeQuery();
			if(res.next()) {
				int orderId1=res.getInt("orderId");
				int userId=res.getInt("userId");
				int restaurantId=res.getInt("restaurantId");
				Timestamp orderDate=res.getTimestamp("orderDate");
				float totalAmount=res.getFloat("totalAmount");
				String status=res.getString("status");
				String paymentMode=res.getString("paymentMode");

				Order order=new Order(orderId1,userId,restaurantId,orderDate,totalAmount,status,paymentMode);
				order.setDeliveryAddress(res.getString("deliveryAddress"));
				return order;
			}
			
		}
		catch(SQLException e) {
			e.printStackTrace();
		}
		
		return null;
	}

	@Override
	public ArrayList<Order> getAllOrders() {
		try(Connection con=DBConnection.getConnection();
				Statement st=con.createStatement();	
					){
			
			ResultSet res=st.executeQuery(GETALL);
			ArrayList<Order> order=new ArrayList<Order>();
			while(res.next()) {
				int orderId1=res.getInt("orderId");
				int userId=res.getInt("userId");
				int restaurantId=res.getInt("restaurantId");
				Timestamp orderDate=res.getTimestamp("orderDate");
				float totalAmount=res.getFloat("totalAmount");
				String status=res.getString("status");
				String paymentMode=res.getString("paymentMode");

				Order ord=new Order(orderId1,userId,restaurantId,orderDate,totalAmount,status,paymentMode);
				ord.setDeliveryAddress(res.getString("deliveryAddress"));
				order.add(ord);
				
			}
			return order;
			
		}
		catch(SQLException e) {
			e.printStackTrace();
		}
		
		return null;
	}

	@Override
	public void updateOrder(Order order) {
		
			try(Connection con=DBConnection.getConnection();
				PreparedStatement pst=con.prepareStatement(UPDATE);	
					){
				pst.setInt(1, order.getUserId());
				pst.setInt(2, order.getRestaurantId());
				
				pst.setFloat(3, order.getTotalAmount());
				pst.setString(4, order.getStatus());
				pst.setString(5, order.getPaymentMode());
				pst.setInt(6, order.getOrderId());
				int i=pst.executeUpdate();
				System.out.print(i+"row(s) affected");
			}
			catch(SQLException e) {
				e.printStackTrace();
			}
			
		
	}

	@Override
	public void deleteOrder(int orderId) {
		try(Connection con=DBConnection.getConnection();
				PreparedStatement pst=con.prepareStatement(DELETE);	
					){
			pst.setInt(1, orderId);
			int i=pst.executeUpdate();
			System.out.print(i+"row(s) deleted");
				
				
		}
		catch(SQLException e) {
			e.printStackTrace();
		}
		
	}

}
