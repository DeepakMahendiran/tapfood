package com.tap.DAOImpl;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;

import com.tap.DAO.OrderItemDAO;
import com.tap.model.OrderItem;
import com.tap.utility.DBConnection;

public class OrderItemDAOImpl  implements OrderItemDAO{
	String INSERT =
            "INSERT INTO OrderItem(orderId, menuId, quantity, price, itemTotal) VALUES(?,?,?,?,?)";

    String GET =
            "SELECT * FROM OrderItem WHERE orderItemId=?";

    String GETALL =
            "SELECT * FROM OrderItem";

    String UPDATE =
            "UPDATE OrderItem SET orderId=?, menuId=?, quantity=?, price=?, itemTotal=? WHERE orderItemId=?";

    String DELETE =
            "DELETE FROM OrderItem WHERE orderItemId=?";
    @Override
    public void addOrderItem(OrderItem orderItem) {

        try(Connection con = DBConnection.getConnection();
            PreparedStatement pst = con.prepareStatement(INSERT))
        {

            pst.setInt(1, orderItem.getOrderId());
            pst.setInt(2, orderItem.getMenuId());
            pst.setInt(3, orderItem.getQuantity());
            pst.setFloat(4, orderItem.getPrice());
            pst.setFloat(5, orderItem.getItemTotal());

            int i = pst.executeUpdate();

            System.out.println(i + " row(s) affected");

        }
        catch(SQLException e) {
            e.printStackTrace();
        }
    }
    @Override
    public OrderItem getOrderItem(int orderItemId) {

        try(Connection con = DBConnection.getConnection();
            PreparedStatement pst = con.prepareStatement(GET))
        {

            pst.setInt(1, orderItemId);

            ResultSet res = pst.executeQuery();

            if(res.next()) {

                int orderItemId1 = res.getInt("orderItemId");
                int orderId = res.getInt("orderId");
                int menuId = res.getInt("menuId");
                int quantity = res.getInt("quantity");
                float price = res.getFloat("price");
                float itemTotal = res.getFloat("itemTotal");

                return new OrderItem(
                        orderItemId1,
                        orderId,
                        menuId,
                        quantity,
                        price,
                        itemTotal);

            }

        }
        catch(SQLException e) {
            e.printStackTrace();
        }

        return null;
    }
    @Override
    public ArrayList<OrderItem> getAllOrderItems() {

        try(Connection con = DBConnection.getConnection();
            Statement st = con.createStatement())
        {

            ArrayList<OrderItem> list = new ArrayList<>();

            ResultSet res = st.executeQuery(GETALL);

            while(res.next()) {

                int orderItemId = res.getInt("orderItemId");
                int orderId = res.getInt("orderId");
                int menuId = res.getInt("menuId");
                int quantity = res.getInt("quantity");
                float price = res.getFloat("price");
                float itemTotal = res.getFloat("itemTotal");

                OrderItem oi = new OrderItem(
                        orderItemId,
                        orderId,
                        menuId,
                        quantity,
                        price,
                        itemTotal);

                list.add(oi);

            }

            return list;

        }
        catch(SQLException e) {
            e.printStackTrace();
        }

        return null;
    }
    @Override
    public void updateOrderItem(OrderItem orderItem) {

        try(Connection con = DBConnection.getConnection();
            PreparedStatement pst = con.prepareStatement(UPDATE))
        {

            pst.setInt(1, orderItem.getOrderId());
            pst.setInt(2, orderItem.getMenuId());
            pst.setInt(3, orderItem.getQuantity());
            pst.setFloat(4, orderItem.getPrice());
            pst.setFloat(5, orderItem.getItemTotal());
            pst.setInt(6, orderItem.getOrderItemId());

            int i = pst.executeUpdate();

            System.out.println(i + " row(s) affected");

        }
        catch(SQLException e) {
            e.printStackTrace();
        }

    }
    @Override
    public void deleteOrderItem(int orderItemId) {

        try(Connection con = DBConnection.getConnection();
            PreparedStatement pst = con.prepareStatement(DELETE))
        {

            pst.setInt(1, orderItemId);

            int i = pst.executeUpdate();

            System.out.println(i + " row(s) deleted");

        }
        catch(SQLException e) {
            e.printStackTrace();
        }

    }

}
    

