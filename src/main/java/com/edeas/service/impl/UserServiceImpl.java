package com.edeas.service.impl;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service(value="userService")
@Transactional
public class UserServiceImpl extends BasicService {

	public void testUser() {
		this.userDao.findAll();
	}
	
}
