package com.edeas.dwr;

import org.apache.log4j.Logger;
import org.directwebremoting.annotations.RemoteMethod;
import org.directwebremoting.annotations.RemoteProxy;

import com.edeas.controller.Global;
import com.edeas.web.InitServlet;

@RemoteProxy(name="dwrService")
public class DwrService {
	protected final Logger logger = Logger.getLogger(DwrService.class);
	@RemoteMethod
	public String getCMSURI() {		
		return Global.getCMSURI();
	}
	
	@RemoteMethod
	public String getContextPath() {		
		return InitServlet.getWc().getServletContext().getContextPath();
	}
}
