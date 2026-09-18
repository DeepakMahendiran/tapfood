package com.tap.DAO;

import java.util.List;

import com.tap.model.User;
public interface UserDAO {
void addUser(User user);
User getUser(int userId);
void  updateUser(User user);
void deleteUser(int userId);
List<User> getAllUser();
User getUserbyName(String userName);
User getUserByEmail(String email);
}
