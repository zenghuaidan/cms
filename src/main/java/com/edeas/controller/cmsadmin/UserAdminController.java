package com.edeas.controller.cmsadmin;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

@Controller
public class UserAdminController extends CmsController {
	
	@RequestMapping(path = {"UserAdmin", "UserAdmin/Index"}, method={RequestMethod.GET})
	public String index(Model model) {
		
		model.addAttribute("users", userService.findAll());
		return "UserAdmin/Index";
	}		
}
