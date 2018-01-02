package com.edeas.controller.cmsadmin;

import javax.servlet.http.HttpSession;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import com.edeas.model.User;

@Controller
public class AuthController extends CmsController {
	
	public static final String LOGIN_USER = "LOGIN_USER";
	
	@RequestMapping(path = {"Login", ""}, method={RequestMethod.GET})
	public String login(){
		return "Auth/Login";
	}
	
	@RequestMapping(path = {"Login", ""}, method={RequestMethod.POST})
	public String doLogin(Model model, String userName, String password, HttpSession session) {
		User user = userService.tryLogin(userName, password);
		if(user == null) {
			return "Auth/Login";	
		}
		session.setAttribute(LOGIN_USER, user);
		return "redirect:" + CmsController.getCMSUrl() + "/SiteAdmin";
	}
	
	@RequestMapping(path = {"Logout"}, method={RequestMethod.GET})
	public String logout(HttpSession session){
		session.removeAttribute(LOGIN_USER);
		return "Auth/Login";
	}
	
}
