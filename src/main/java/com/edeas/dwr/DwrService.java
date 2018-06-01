package com.edeas.dwr;

import org.apache.log4j.Logger;
import org.directwebremoting.WebContext;
import org.directwebremoting.WebContextFactory;
import org.directwebremoting.annotations.RemoteMethod;
import org.directwebremoting.annotations.RemoteProxy;

import com.edeas.controller.Global;
import com.edeas.web.InitServlet;
import com.edeas.web.SiteIdHolder;

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
	
	@RemoteMethod
	public void setSiteId(String siteId) {		
		WebContext webContext = WebContextFactory.get();
		webContext.getHttpServletRequest().getSession().setAttribute(SiteIdHolder.CMS_SITE_ID, siteId);		
	}
}
