package com.edeas.dwr;

import org.directwebremoting.annotations.RemoteMethod;
import org.directwebremoting.annotations.RemoteProxy;

import com.edeas.controller.cmsadmin.CmsController;
import com.edeas.service.impl.BasicServiceImpl;

@RemoteProxy(name="dwrService")
public class DwrService extends BasicServiceImpl {
	
	@RemoteMethod
	public String getCMSUrl() {		
		return CmsController.getCMSUrl();
	}
}
