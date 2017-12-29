package com.edeas.service.impl;

import javax.inject.Inject;

import com.edeas.dao.impl.UserDaoImpl;

public abstract class BasicService {
	protected UserDaoImpl userDao;

	public UserDaoImpl getUserDao() {
		return userDao;
	}

	@Inject
	public void setUserDao(UserDaoImpl userDao) {
		this.userDao = userDao;
	}

	
}
