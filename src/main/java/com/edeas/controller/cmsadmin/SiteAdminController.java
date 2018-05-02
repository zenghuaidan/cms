package com.edeas.controller.cmsadmin;

import javax.servlet.http.HttpServletRequest;

import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import com.edeas.dto.Result;
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
	
	@ResponseBody
	@RequestMapping(path = {"SiteAdmin/ChgPgOrder"}, method={RequestMethod.GET})
	public Result chgPgOrder(Long pgid, Long beforeid, HttpServletRequest request) {
		queryService.chgPgOrder(pgid, beforeid);
		return new Result();
	}
}
