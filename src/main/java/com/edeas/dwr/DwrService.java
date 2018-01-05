package com.edeas.dwr;

import org.directwebremoting.annotations.RemoteMethod;
import org.directwebremoting.annotations.RemoteProxy;

import com.edeas.controller.Global;
import com.edeas.web.InitServlet;

@RemoteProxy(name="dwrService")
public class DwrService {
	
	@RemoteMethod
	public String getCMSUrl() {		
		return Global.getCMSUrl();
	}
	
	@RemoteMethod
	public String getContextPath() {		
		return InitServlet.getWc().getServletContext().getContextPath();
	}
}
