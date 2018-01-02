package com.edeas.controller;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import com.edeas.model.User;

@Controller
public class AuthController extends CmsController {
	
	public static final String LOGIN_USER = "LOGIN_USER";
	
	@RequestMapping(path = {"login", ""}, method={RequestMethod.GET})
	public String login(){
		return "Auth/Login";
	}
	
	@RequestMapping(path = {"login", ""}, method={RequestMethod.POST})
	public String doLogin(Model model, String userName, String password) {
		User user = userService.tryLogin(userName, password);
		if(user == null) {
			return "Auth/Login";	
		}
		return "SiteAdmin/Index";
	}
	
}
