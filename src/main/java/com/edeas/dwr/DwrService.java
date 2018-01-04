package com.edeas.dwr;

import org.directwebremoting.annotations.RemoteMethod;
import org.directwebremoting.annotations.RemoteProxy;

import com.edeas.controller.cmsadmin.CmsController;
import com.edeas.web.InitServlet;

@RemoteProxy(name="dwrService")
public class DwrService {
	
	@RemoteMethod
	public String getCMSUrl() {		
		return CmsController.getCMSUrl();
	}
	
	@RemoteMethod
	public String getContextPath() {		
		return InitServlet.getWc().getServletContext().getContextPath();
	}
}
