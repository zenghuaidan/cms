package com.edeas.controller.cmsadmin;

import javax.servlet.http.HttpSession;

import org.apache.commons.lang3.StringUtils;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import com.edeas.controller.Global;
import com.edeas.dto.Result;
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
		return "redirect:" + Global.getCMSURI() + "/SiteAdmin";
	}
	
	@RequestMapping(path = {"Logout"}, method={RequestMethod.GET})
	public String logout(HttpSession session){
		session.removeAttribute(LOGIN_USER);
		return "redirect:Auth/Login";
	}
	
	@ResponseBody
	@RequestMapping(path = {"ChgPwd"}, method={RequestMethod.POST})
	public Result changePassword(String oldpwd, String newpwd, String retypepwd, HttpSession session){
		if(StringUtils.isBlank(newpwd)) {
			return new Result("Empty New Password", "New password is not provided");
		} else if(!newpwd.equals(retypepwd)) {
			return new Result("Re-type password is not identical to New password", "Re-type password is not identical to New password");
		} else {
			User loginUser = (User)session.getAttribute(LOGIN_USER); 
			if(StringUtils.isBlank(oldpwd) || userService.tryLogin(loginUser.getLogin(), oldpwd) == null) {
				return new Result("Old password is incorrect", "Old password is incorrect");
			}
			userService.updatePassword(loginUser.getLogin(), oldpwd, newpwd);
		}
		return new Result("Password update successfully");
	}
}
