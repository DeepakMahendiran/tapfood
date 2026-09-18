package com.tap.model;

import java.sql.Timestamp;

public class User {
private int userId;
private String userName;
 private String email;
  private String password;
  private String address;
  private String role;
  private Timestamp createdDate;
   private Timestamp lastLoginDate;
   
   public User(String userName, String email, String password, String address, String role) {
	super();
	this.userName = userName;
	this.email = email;
	this.password = password;
	this.address = address;
	this.role = role;
}
   public User(int userId, String userName, String email, String password, String address, String role,
		Timestamp createdDate, Timestamp lastLoginDate) {
	super();
	this.userId = userId;
	this.userName = userName;
	this.email = email;
	this.password = password;
	this.address = address;
	this.role = role;
	this.createdDate = createdDate;
	this.lastLoginDate = lastLoginDate;
}
   public User(String userName, String email, String password, String address, String role, Timestamp createdDate,
		Timestamp lastLoginDate) {
	super();
	this.userName = userName;
	this.email = email;
	this.password = password;
	this.address = address;
	this.role = role;
	this.createdDate = createdDate;
	this.lastLoginDate = lastLoginDate;
   }
   public int getUserId() {
	return userId;
   }
   public void setUserId(int userId) {
	this.userId = userId;
   }
   public String getUserName() {
	return userName;
   }
   public void setUserName(String userName) {
	this.userName = userName;
   }
   public String getEmail() {
	return email;
   }
   public void setEmail(String email) {
	this.email = email;
   }
   public String getPassword() {
	return password;
   }
   public void setPassword(String password) {
	this.password = password;
   }
   public String getAddress() {
	return address;
   }
   public void setAddress(String address) {
	this.address = address;
   }
   public String getRole() {
	return role;
   }
   public void setRole(String role) {
	this.role = role;
   }
   public Timestamp getCreatedDate() {
	return createdDate;
   }
   public void setCreatedDate(Timestamp createdDate) {
	this.createdDate = createdDate;
   }
   public Timestamp getLastLoginDate() {
	return lastLoginDate;
   }
   public void setLastLoginDate(Timestamp lastLoginDate) {
	this.lastLoginDate = lastLoginDate;
   }
   @Override
   public String toString() {
	return "User [userId=" + userId + ", userName=" + userName + ", email=" + email + ", password=" + password
			+ ", address=" + address + ", role=" + role + ", createdDate=" + createdDate + ", lastLoginDate="
			+ lastLoginDate + "]";
   }
}
