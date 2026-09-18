package com.tap.model;

public class OrderItem {
private int orderItemId;
private int orderId;
private int menuId;
private int quantity;
private float price;
private float itemTotal;
public OrderItem() {
	
}
public OrderItem(int orderItemId, int orderId, int menuId, int quantity, float price, float itemTotal) {
	super();
	this.orderItemId = orderItemId;
	this.orderId = orderId;
	this.menuId = menuId;
	this.quantity = quantity;
	this.price = price;
	this.itemTotal = itemTotal;
}
public OrderItem(int orderId, int menuId, int quantity, float price, float itemTotal) {
	super();
	this.orderId = orderId;
	this.menuId = menuId;
	this.quantity = quantity;
	this.price = price;
	this.itemTotal = itemTotal;
}
public int getOrderItemId() {
	return orderItemId;
}
public void setOrderItemId(int orderItemId) {
	this.orderItemId = orderItemId;
}
public int getOrderId() {
	return orderId;
}
public void setOrderId(int orderId) {
	this.orderId = orderId;
}
public int getMenuId() {
	return menuId;
}
public void setMenuId(int menuId) {
	this.menuId = menuId;
}
public int getQuantity() {
	return quantity;
}
public void setQuantity(int quantity) {
	this.quantity = quantity;
}
public float getPrice() {
	return price;
}
public void setPrice(float price) {
	this.price = price;
}
public float getItemTotal() {
	return itemTotal;
}
public void setItemTotal(float itemTotal) {
	this.itemTotal = itemTotal;
}
@Override
public String toString() {
	return "OrderItem [orderItemId=" + orderItemId + ", orderId=" + orderId + ", menuId=" + menuId + ", quantity="
			+ quantity + ", price=" + price + ", itemTotal=" + itemTotal + "]";
}

}
