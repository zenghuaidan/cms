package com.edeas.controller.cmsadmin;

import org.apache.log4j.Logger;
import org.springframework.web.bind.annotation.RequestMapping;

import com.edeas.controller.BaseController;

@RequestMapping("/cmsadmin")
public abstract class CmsController extends BaseController {	
	protected final Logger logger = Logger.getLogger(CmsController.class);
	public static String getCMSURI() {
		RequestMapping rm = CmsController.class.getAnnotation(RequestMapping.class);
		return rm.value().length > 0 ? rm.value()[0] : "";
	}
}
