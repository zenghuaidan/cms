package com.edeas.controller.cmsadmin;

import java.util.ArrayList;
import java.util.Enumeration;
import java.util.HashSet;
import java.util.List;
import java.util.Set;
import java.util.UUID;

import javax.servlet.http.HttpServletRequest;
import javax.validation.Valid;

import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.validation.FieldError;
import org.springframework.validation.ObjectError;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import com.edeas.dto.Result;
import com.edeas.model.User;
import com.edeas.model.UserRole;
import com.edeas.utils.MailUtils;
import com.edeas.utils.PasswordUtils;

@Controller
public class UserAdminController extends CmsController {
	
	@RequestMapping(path = {"UserAdmin", "UserAdmin/Index"}, method={RequestMethod.GET})
	public String index(Model model) {
		model.addAttribute("navigation", "UserAdmin");
		model.addAttribute("users", userService.findAll());
		model.addAttribute("roles", userRoleService.findAll());		
		return "UserAdmin/Index";
	}
	
	@RequestMapping(path = {"UserAdmin/NewUser"}, method={RequestMethod.POST})
	@ResponseBody
	@PreAuthorize("hasRole('Admin')")
	public Result newUser(@Valid User user, BindingResult bindingResult, HttpServletRequest request,  Model model) {
		
		if(bindingResult.hasErrors()) {
			List<ObjectError> allErrors = bindingResult.getAllErrors();
			List<String> errors = new ArrayList<String>();
			for(ObjectError error : allErrors) {
				FieldError fieldError = (FieldError)error;
				errors.add(fieldError.getField() + " : " + fieldError.getDefaultMessage());
			}
			return new Result("Invalid user", String.join(",", errors));
		}
		
		List<String> errors = checkExists(user, false);
		if (errors.size() > 0) {
			return new Result("Duplicate user", String.join(",", errors));
		}
		
		String newPassword = UUID.randomUUID().toString().substring(0, 6);
		user.setUserRoles(getUIUserRoles(request));		
		user.setPassword(PasswordUtils.encode(newPassword));
		userService.addUser(user);
		
		MailUtils.sendmail(user.getFirstName(), user.getEmail(), "Init Passowrd", "Your init password is : " + newPassword, false, true);
		return new Result();
	}
	
	public List<String> checkExists(User user, boolean exclude) {
		List<User> users = userService.findByUserNameOrEmail(user.getLogin(), user.getEmail());
		List<String> errors = new ArrayList<String>();
		for(User _user : users) {
			if(exclude && user.getId() == _user.getId())
				continue;
			if(user.getLogin().equals(_user.getLogin())) {
				errors.add("Login exists");
			}
			if(user.getEmail().equals(_user.getEmail())) {
				errors.add("Email exists");
			}
		}
		return errors;
	}
	
	@RequestMapping(path = {"UserAdmin/ModifyUser"}, method={RequestMethod.POST})
	@ResponseBody
	@PreAuthorize("hasRole('Admin')")
	public Result modifyUser(@Valid User user, BindingResult bindingResult, HttpServletRequest request,  Model model) {
		List<String> errors = new ArrayList<String>();
		if(user.getId() == null) {
			errors.add("id : should not be empty");
		}
		
		if(bindingResult.hasErrors()) {
			List<ObjectError> allErrors = bindingResult.getAllErrors();
			for(ObjectError error : allErrors) {
				FieldError fieldError = (FieldError)error;
				errors.add(fieldError.getField() + " : " + fieldError.getDefaultMessage());
			}
			return new Result("Invalid user", String.join(",", errors));
		}
		
		User _user = userService.findById(user.getId());
		
		if(_user == null) {
			return new Result("User not exists", "Could not find user for update");
		}
		
		errors = checkExists(user, true);
		if (errors.size() > 0) {
			return new Result("Duplicate user", String.join(",", errors));
		}
		
		_user.setUserRoles(getUIUserRoles(request));		
		_user.setLogin(user.getLogin());
		_user.setFirstName(user.getFirstName());
		_user.setLastName(user.getLastName());
		_user.setEmail(user.getEmail());
		_user.setActive(user.isActive());
		userService.update(_user);
		return new Result();
	}

	private Set<UserRole> getUIUserRoles(HttpServletRequest request) {
		List<UserRole> userRoles = userRoleService.findAll();
		Set<UserRole> _userRoles = new HashSet<UserRole>();
		Enumeration parameterNames = request.getParameterNames();		
		while(parameterNames.hasMoreElements()) {
			String parameterName = (String)parameterNames.nextElement();
			for(UserRole userRole : userRoles) {
				if (parameterName.indexOf(userRole.getName()) >= 0) {
					_userRoles.add(userRole);
				}
			}
		}
		return _userRoles;
	}
	
	@RequestMapping(path = {"UserAdmin/ResetPwd"}, method={RequestMethod.POST})
	@ResponseBody
	@PreAuthorize("hasRole('Admin')")
	public Result resetPwd(Long id) {
		List<String> errors = new ArrayList<String>();
		if(id == null) {
			errors.add("id : should not be empty");
		}			
		
		User user = userService.findById(id);		
		if(user == null) {
			return new Result("User not exists", "Could not find user for reset password");
		}				
		
		String newPassword = UUID.randomUUID().toString().substring(0, 6);
		
		userService.updatePassword(user.getLogin(), user.getPassword(), PasswordUtils.encode(newPassword));
		MailUtils.sendmail(user.getFirstName(), user.getEmail(), "Reset Passowrd", "Your new password is : " + newPassword, false, true);
		return new Result();
	}
		
}
