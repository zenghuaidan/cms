package com.edeas.controller.cmsadmin;

import javax.servlet.http.HttpSession;

import org.apache.commons.lang3.StringUtils;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import com.edeas.dto.Result;
import com.edeas.model.User;
import com.edeas.utils.PasswordUtils;

@Controller
public class AuthController extends CmsController {
	
	@RequestMapping(path = {"Login", ""}, method={RequestMethod.GET})
	public String login(){
		return "Auth/Login";
	}
	
	@ResponseBody
	@RequestMapping(path = {"ChgPwd"}, method={RequestMethod.POST})
	public Result changePassword(String oldpwd, String newpwd, String retypepwd, HttpSession session){
		if(StringUtils.isBlank(newpwd)) {
			return new Result("Empty New Password", "New password is not provided");
		} else if(!newpwd.equals(retypepwd)) {
			return new Result("Re-type password is not identical to New password", "Re-type password is not identical to New password");
		} else {
			UserDetails userDetails = (UserDetails) SecurityContextHolder.getContext().getAuthentication().getPrincipal();
			User loginUser = userService.findByUserName(userDetails.getUsername()); 
			String encodedPassword = loginUser.getPassword();
			if(StringUtils.isBlank(oldpwd) || !PasswordUtils.matches(oldpwd, encodedPassword)) {
				return new Result("Old password is incorrect", "Old password is incorrect");
			}
			userService.updatePassword(loginUser.getLogin(), encodedPassword, PasswordUtils.encode(newpwd));
		}					
		return new Result("Password update successfully");
	}
}
