package com.tap.DAO;

import java.util.ArrayList;
import com.tap.model.Order;

public interface OrderDAO {
    int addOrder(Order order);
    Order getOrder(int orderId);
    ArrayList<Order> getAllOrders();
    void updateOrder(Order order);
    void deleteOrder(int orderId);
}