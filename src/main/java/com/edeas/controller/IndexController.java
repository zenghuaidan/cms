package com.edeas.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

@Controller
public class IndexController extends BaseController {
	
	@ResponseBody
	@RequestMapping("test")
	public String test() {
		this.userService.testUser();
		return "success";
	}
}
