package com.tap.DAOImpl;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import com.tap.DAO.UserAddressDAO;
import com.tap.model.UserAddress;
import com.tap.utility.DBConnection;

public class UserAddressDAOImpl implements UserAddressDAO {

    String INSERT = "insert into user_address(userId,label,addressLine,city,phone)values(?,?,?,?,?)";
    String GET = "select * from user_address where addressId=?";
    String GETBYUSER = "select * from user_address where userId=? order by addressId";
    String UPDATE = "update user_address set label=?,addressLine=?,city=?,phone=? where addressId=? and userId=?";
    String DELETE = "delete from user_address where addressId=? and userId=?";

    @Override
    public void addAddress(UserAddress address) {
        try (Connection con = DBConnection.getConnection();
             PreparedStatement pst = con.prepareStatement(INSERT)) {

            pst.setInt(1, address.getUserId());
            pst.setString(2, address.getLabel());
            pst.setString(3, address.getAddressLine());
            pst.setString(4, address.getCity());
            pst.setString(5, address.getPhone());

            int i = pst.executeUpdate();
            System.out.println(i + " row(s) affected");
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    @Override
    public UserAddress getAddress(int addressId) {
        try (Connection con = DBConnection.getConnection();
             PreparedStatement pst = con.prepareStatement(GET)) {

            pst.setInt(1, addressId);
            ResultSet res = pst.executeQuery();
            if (res.next()) {
                return mapRow(res);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    @Override
    public List<UserAddress> getAddressesByUser(int userId) {
        List<UserAddress> list = new ArrayList<>();
        try (Connection con = DBConnection.getConnection();
             PreparedStatement pst = con.prepareStatement(GETBYUSER)) {

            pst.setInt(1, userId);
            ResultSet res = pst.executeQuery();
            while (res.next()) {
                list.add(mapRow(res));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    @Override
    public void updateAddress(UserAddress address) {
        try (Connection con = DBConnection.getConnection();
             PreparedStatement pst = con.prepareStatement(UPDATE)) {

            pst.setString(1, address.getLabel());
            pst.setString(2, address.getAddressLine());
            pst.setString(3, address.getCity());
            pst.setString(4, address.getPhone());
            pst.setInt(5, address.getAddressId());
            pst.setInt(6, address.getUserId());

            int i = pst.executeUpdate();
            System.out.println(i + " row(s) affected");
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    @Override
    public void deleteAddress(int addressId, int userId) {
        try (Connection con = DBConnection.getConnection();
             PreparedStatement pst = con.prepareStatement(DELETE)) {

            pst.setInt(1, addressId);
            pst.setInt(2, userId);
            int i = pst.executeUpdate();
            System.out.println(i + " row(s) deleted");
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    private UserAddress mapRow(ResultSet res) throws SQLException {
        return new UserAddress(
                res.getInt("addressId"),
                res.getInt("userId"),
                res.getString("label"),
                res.getString("addressLine"),
                res.getString("city"),
                res.getString("phone"));
    }
}
