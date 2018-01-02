package com.edeas.service.impl;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.edeas.model.User;

@Service(value="userService")
@Transactional
public class UserServiceImpl extends BasicService {

	public void testUser() {
		this.userDao.findAll();
	}

	public User tryLogin(String userName, String password) {
		try {			
			return userDao.findByUserNameAndPassword(userName, User.getEncryptPassword(password));
		} catch (Exception e) {
		}
		return null;
	}
	
}
