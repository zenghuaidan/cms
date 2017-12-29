package com.edeas.controller;

import javax.inject.Inject;

import com.edeas.service.impl.UserServiceImpl;

public abstract class BaseController {
	// put all the service on the basic controller
	protected UserServiceImpl userService;	
	
	@Inject
	public void setUserService(UserServiceImpl userService) {
		this.userService = userService;
	}
}
