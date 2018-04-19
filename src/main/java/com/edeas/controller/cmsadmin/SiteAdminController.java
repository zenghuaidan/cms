package com.edeas.controller.cmsadmin;

import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import com.edeas.model.User;

@Controller
public class SiteAdminController extends CmsController {
	
	@RequestMapping(path = {"SiteAdmin", "SiteAdmin/Index"}, method={RequestMethod.GET})
	public String index(Model model) {
		UserDetails userDetails = (UserDetails) SecurityContextHolder.getContext().getAuthentication().getPrincipal();
		User user = userService.findByUserName(userDetails.getUsername());
		model.addAttribute("user", user);
		return "SiteAdmin/Index";
	}		
}
