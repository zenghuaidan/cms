package com.edeas.cms.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

@Controller
public class IndexController {
	
	@ResponseBody
	@RequestMapping("test")
	public String test() {
	  return "success";
	}
}
