package com.edeas.service.impl;

import java.util.ArrayList;
import java.util.List;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.edeas.model.User;

@Service(value="userService")
@Transactional
public class UserServiceImpl extends BasicServiceImpl {
	
//	public User findByUserNameAndPassword(String userName, String password) {
//		try {			
//			return userDao.findByUserNameAndPassword(userName, password);
//		} catch (Exception e) {
//		}
//		return null;
//	}
	
	public User findByUserName(String userName) {
		try {			
			return userDao.findByUserName(userName);
		} catch (Exception e) {
		}
		return null;
	}
	
	public List<User> findByUserNameOrEmail(String userName, String email) {
		try {			
			return userDao.findByUserNameOrEmail(userName, email);
		} catch (Exception e) {
		}
		return new ArrayList<User>();
	}
	
	public List<User> findAll() {		
		return userDao.findAll();
	}
	
	public void updatePassword(String userName, String oldPassword, String newPassword) {
		userDao.updatePassword(userName, oldPassword, newPassword);
	}
	
	public User addUser(User user) {
		return userDao.add(user);
	}

	public User findById(Long id) {
		return userDao.getById(id);
	}

	public void update(User user) {
		userDao.update(user);
	}
	
}
