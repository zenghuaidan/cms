package com.edeas.controller;

import javax.inject.Inject;

import com.edeas.service.impl.QueryServiceImpl;
import com.edeas.service.impl.UserServiceImpl;

public abstract class BaseController {
	// put all the service on the basic controller
	protected UserServiceImpl userService;	
	
	protected QueryServiceImpl queryService;	
		
	@Inject
	public void setQueryService(QueryServiceImpl queryService) {
		this.queryService = queryService;
	}
	
	@Inject
	public void setUserService(UserServiceImpl userService) {
		this.userService = userService;
	}
}
