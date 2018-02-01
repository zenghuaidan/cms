package com.edeas.service.impl;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.edeas.model.User;

@Service(value="userService")
@Transactional
public class UserServiceImpl extends BasicServiceImpl {

	public User tryLogin(String userName, String password) {
		try {			
			return userDao.findByUserNameAndPassword(userName, User.getEncryptPassword(password));
		} catch (Exception e) {
		}
		return null;
	}
	
	public User tryLogin(String userName) {
		try {			
			return userDao.findByUserName(userName);
		} catch (Exception e) {
		}
		return null;
	}
	
	public void updatePassword(String userName, String oldPassword, String newPassword) {
		userDao.updatePassword(userName, User.getEncryptPassword(oldPassword), User.getEncryptPassword(newPassword));
	}
	
}
