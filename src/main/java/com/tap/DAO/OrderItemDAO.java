package com.tap.DAO;

import java.util.ArrayList;

import com.tap.model.OrderItem;

public interface OrderItemDAO {
	void addOrderItem(OrderItem orderItem);

    OrderItem getOrderItem(int orderItemId);

    ArrayList<OrderItem> getAllOrderItems();

    void updateOrderItem(OrderItem orderItem);

    void deleteOrderItem(int orderItemId);
}
