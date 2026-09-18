package com.tap.DAOImpl;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;

import com.tap.DAO.UserDAO;
import com.tap.model.User;
import com.tap.utility.DBConnection;
public class UserDAOImpl implements UserDAO  {
	String INSERT="Insert into user(userName,email,password,address,role,createdDate,lastLoginDate)values(?,?,?,?,?,?,?) ";
	String GETUSER="select * from user where userId=?";
	String GETALL="SELECT * FROM user";
	String DELETE="DELETE FROM user WhERE UserId=?";
	String UPDATE="UPDATE user SET USERNAME=? ,EMAIL=?,PASSWORD=?,ADDRESS=?,LASTLOGINDATE=? WHERE USERID=?";
	String GETUSERBYNAME="select * from user where userName=?";
	String GETUSERBYEMAIL = "SELECT * FROM user WHERE email = ?";

	@Override
	public void addUser(User user) {
		// TODO Auto-generated method stub
		
		try (
			Connection con=DBConnection.getConnection();
			PreparedStatement pst=con.prepareStatement(INSERT);
				){
//			get method should be used to insert values 
			//if directly pst.setString(1,userName)  -error could not find variable
			
			pst.setString(1,user.getUserName());//taking input from user 
			pst.setString(2,user.getEmail());
			pst.setString(3,user.getPassword());
			pst.setString(4, user.getAddress());
			pst.setString(5, user.getRole());
			pst.setTimestamp(6, new Timestamp(System.currentTimeMillis()));//used to store current time
			pst.setTimestamp(7,new Timestamp(System.currentTimeMillis()));
			
			
			
			int i=pst.executeUpdate();
			System.out.println(i+"rows affected");
		}
		catch(Exception e) {
			e.printStackTrace();
		}
		
	}

	@Override
	public User getUser(int userId) {
		// TODO Auto-generated method stub
		try (
				Connection con=DBConnection.getConnection();
				PreparedStatement pst=con.prepareStatement(GETUSER);
				
					){
			pst.setInt(1, userId);
			ResultSet res=pst.executeQuery();
			if(res.next()) {
				int userId1=res.getInt("userId");
				String name=res.getString("userName");
				String email=res.getString("email");
				String password=res.getString("password");
				String address=res.getString("address");
				String role=res.getString("role");
				Timestamp createdDate=res.getTimestamp("createdDate");
				Timestamp lastLoginDate=res.getTimestamp("lastLoginDate");
				
				
				User u=new User(userId1,name,email,password,address,role,createdDate,lastLoginDate);
				return u;
			}
			
			
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return null;
	}

	@Override
	public void   updateUser(User user) {
		// TODO Auto-generated method stub
		try (
				Connection con=DBConnection.getConnection();
				PreparedStatement pst=con.prepareStatement(UPDATE);
				
					){
			
			
				
				pst.setString(1,user.getUserName());//taking input from user 
				pst.setString(2,user.getEmail());
				pst.setString(3,user.getPassword());
				pst.setString(4, user.getAddress());
				pst.setTimestamp(5,new Timestamp(System.currentTimeMillis()));
				pst.setInt(6,user.getUserId());
				
				int  i=pst.executeUpdate();
				System.out.print(i);
			
				
				
			}
			
			
	 catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}


	@Override
	public void deleteUser(int userId) {
		// TODO Auto-generated method stub
		try (
				Connection con=DBConnection.getConnection();
				PreparedStatement pst=con.prepareStatement(DELETE);
				
					){
			pst.setInt(1, userId);
			int res=pst.executeUpdate();
			System.out.print("User Id: "+userId+" deleted ");
			
			
//			if(res.next()) {
//				int userId1=res.getInt("userId");
//				String name=res.getString("userName");
//				String email=res.getString("email");
//				String password=res.getString("password");
//				String address=res.getString("address");
//				String role=res.getString("role");
//				Timestamp createdDate=res.getTimestamp("createdDate");
//				Timestamp lastLoginDate=res.getTimestamp("lastLoginDate");
//				
//				
//				User u=new User(userId1,name,email,password,address,role,createdDate,lastLoginDate);
//				return u;
//			}
			
			
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
		
		
	}

	@Override
	public List<User> getAllUser() {
		// TODO Auto-generated method stub
		try (
				Connection con=DBConnection.getConnection();
			Statement st=con.createStatement();
				
					){
			User u=null;
			List<User> l1=new ArrayList<User>();
			
			ResultSet res=st.executeQuery(GETALL);
			while(res.next()) {
				int userId1=res.getInt("userId");
				String name=res.getString("userName");
				String email=res.getString("email");
				String password=res.getString("password");
				String address=res.getString("address");
				String role=res.getString("role");
				Timestamp createdDate=res.getTimestamp("createdDate");
				Timestamp lastLoginDate=res.getTimestamp("lastLoginDate");
				
				
				 u=new User(userId1,name,email,password,address,role,createdDate,lastLoginDate);
				 l1.add(u);
			}
			
			return l1;
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return null;
	}

	@Override
	public User getUserbyName(String userName) {
		// TODO Auto-generated method stub
		try (
				Connection con=DBConnection.getConnection();
				PreparedStatement pst=con.prepareStatement(GETUSERBYNAME);
				
					){
			pst.setString(1, userName);
			ResultSet res=pst.executeQuery();
			if(res.next()) {
				int userId1=res.getInt("userId");
				String name=res.getString("userName");
				String email=res.getString("email");
				String password=res.getString("password");
				String address=res.getString("address");
				String role=res.getString("role");
				Timestamp createdDate=res.getTimestamp("createdDate");
				Timestamp lastLoginDate=res.getTimestamp("lastLoginDate");
				
				
				User u=new User(userId1,name,email,password,address,role,createdDate,lastLoginDate);
				return u;
			}
			
			
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return null;
		
	}
	@Override
	public User getUserByEmail(String email) {

	    try (
	            Connection con = DBConnection.getConnection();
	            PreparedStatement pst = con.prepareStatement(GETUSERBYEMAIL);

	    ) {

	        pst.setString(1, email);

	        ResultSet res = pst.executeQuery();

	        if (res.next()) {

	            int userId = res.getInt("userId");
	            String name = res.getString("userName");
	            String userEmail = res.getString("email");
	            String password = res.getString("password");
	            String address = res.getString("address");
	            String role = res.getString("role");
	            Timestamp createdDate = res.getTimestamp("createdDate");
	            Timestamp lastLoginDate = res.getTimestamp("lastLoginDate");

	            User user = new User(
	                    userId,
	                    name,
	                    userEmail,
	                    password,
	                    address,
	                    role,
	                    createdDate,
	                    lastLoginDate
	            );

	            return user;
	        }

	    } catch (SQLException e) {
	        e.printStackTrace();
	    }

	    return null;
	}
}
