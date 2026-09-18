package com.tap.model;

import java.sql.Timestamp;

public class Order {
private int orderId;
private int userId;
private int restaurantId;
private Timestamp orderDate;
private float totalAmount;
private String status;
private String paymentMode;
private String deliveryAddress;
public Order() {
	
}
public Order(int orderId, int userId, int restaurantId, Timestamp orderDate, float totalAmount, String status,
		String paymentMode) {
	super();
	this.orderId = orderId;
	this.userId = userId;
	this.restaurantId = restaurantId;
	this.orderDate = orderDate;
	this.totalAmount = totalAmount;
	this.status = status;
	this.paymentMode = paymentMode;
}
public Order(int userId, int restaurantId, Timestamp orderDate, float totalAmount, String status, String paymentMode) {
	super();
	this.userId = userId;
	this.restaurantId = restaurantId;
	this.orderDate = orderDate;
	this.totalAmount = totalAmount;
	this.status = status;
	this.paymentMode = paymentMode;
}
public Order(int userId, int restaurantId,
        float totalAmount,
        String status,
        String paymentMode) {
this.userId = userId;
this.restaurantId = restaurantId;
this.totalAmount = totalAmount;
this.status = status;
this.paymentMode = paymentMode;
}

public int getOrderId() {
	return orderId;
}
public void setOrderId(int orderId) {
	this.orderId = orderId;
}
public int getUserId() {
	return userId;
}
public void setUserId(int userId) {
	this.userId = userId;
}
public int getRestaurantId() {
	return restaurantId;
}
public void setRestaurantId(int restaurantId) {
	this.restaurantId = restaurantId;
}
public Timestamp getOrderDate() {
	return orderDate;
}
public void setOrderDate(Timestamp orderDate) {
	this.orderDate = orderDate;
}
public float getTotalAmount() {
	return totalAmount;
}
public void setTotalAmount(float totalAmount) {
	this.totalAmount = totalAmount;
}
public String getStatus() {
	return status;
}
public void setStatus(String status) {
	this.status = status;
}
public String getPaymentMode() {
	return paymentMode;
}
public void setPaymentMode(String paymentMode) {
	this.paymentMode = paymentMode;
}
public String getDeliveryAddress() {
	return deliveryAddress;
}
public void setDeliveryAddress(String deliveryAddress) {
	this.deliveryAddress = deliveryAddress;
}
@Override
public String toString() {
	return "Order [orderId=" + orderId + ", userId=" + userId + ", restaurantId=" + restaurantId + ", orderDate="
			+ orderDate + ", totalAmount=" + totalAmount + ", status=" + status + ", paymentMode=" + paymentMode + "]";
}






}
