package com.edeas.controller.frontend;

import org.apache.log4j.Logger;
import org.springframework.web.bind.annotation.RequestMapping;

import com.edeas.controller.BaseController;

@RequestMapping("/")
public abstract class FrontController extends BaseController {	
	protected final Logger logger = Logger.getLogger(FrontController.class);
}
