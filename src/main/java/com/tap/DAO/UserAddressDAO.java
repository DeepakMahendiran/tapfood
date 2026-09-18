package com.tap.DAO;

import java.util.List;

import com.tap.model.UserAddress;

public interface UserAddressDAO {

    void addAddress(UserAddress address);

    UserAddress getAddress(int addressId);

    List<UserAddress> getAddressesByUser(int userId);

    void updateAddress(UserAddress address);

    void deleteAddress(int addressId, int userId);
}
