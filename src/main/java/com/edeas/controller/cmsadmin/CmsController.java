package com.edeas.controller.cmsadmin;

import org.springframework.web.bind.annotation.RequestMapping;

import com.edeas.controller.BaseController;

@RequestMapping("/cmsadmin")
public abstract class CmsController extends BaseController {	
	
	public static String getCMSURI() {
		RequestMapping rm = CmsController.class.getAnnotation(RequestMapping.class);
		return rm.value().length > 0 ? rm.value()[0] : "";
	}
}
