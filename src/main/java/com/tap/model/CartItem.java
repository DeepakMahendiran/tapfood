package com.tap.model;

public class CartItem {
private int menuId;
private int restaurantId;
private String itemName;
private double price;
private int qty;
private String imagePath;
public CartItem() {
	
}
public CartItem(int menuId, int restaurantId, String itemName, double price, int qty,String imagePath) {
	
	this.menuId = menuId;
	this.restaurantId = restaurantId;
	this.itemName = itemName;
	this.price = price;
	this.qty = qty;
	this.imagePath=imagePath;}
public int getMenuId() {
	return menuId;
}
public void setMenuId(int menuId) {
	this.menuId = menuId;
}
public int getRestaurantId() {
	return restaurantId;
}
public void setRestaurantId(int restaurantId) {
	this.restaurantId = restaurantId;
}

public double getPrice() {
	return price;
}
public void setPrice(double price) {
	this.price = price;
}
public int getQty() {
	return qty;
}
public void setQty(int qty) {
	this.qty = qty;
}
public String getItemName() {
	return itemName;
}
public void setItemName(String itemName) {
	this.itemName = itemName;
}
@Override
public String toString() {
	return "CartItem [menuId=" + menuId + ", restaurantId=" + restaurantId + ", itemName=" + itemName + ", price="
			+ price + ", qty=" + qty + ", imagePath=" + imagePath + "]";
}
public String getImagePath() {
	return imagePath;
}
public void setImagePath(String imagePath) {
	this.imagePath = imagePath;
}


}
