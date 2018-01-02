package com.edeas.controller.cmsadmin;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

@Controller
public class SiteAdminController extends CmsController {
	
	@RequestMapping(path = {"SiteAdmin", "SiteAdmin/Index"}, method={RequestMethod.GET})
	public String index(Model model) {
		model.addAttribute("test", "new");
		return "SiteAdmin/Index";
	}		
}
