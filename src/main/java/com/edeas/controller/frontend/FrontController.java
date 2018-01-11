package com.edeas.controller.frontend;

import org.apache.log4j.Logger;
import org.springframework.web.bind.annotation.RequestMapping;

import com.edeas.controller.BaseController;
import com.edeas.controller.cmsadmin.CmsController;

@RequestMapping("/")
public abstract class FrontController extends BaseController {	
	protected final Logger logger = Logger.getLogger(CmsController.class);
}
