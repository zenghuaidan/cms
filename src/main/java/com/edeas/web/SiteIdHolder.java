package com.edeas.web;

import org.apache.commons.lang3.StringUtils;
import org.springframework.web.context.request.RequestAttributes;
import org.springframework.web.context.request.RequestContextHolder;

import com.edeas.controller.cmsadmin.CmsProperties;

public class SiteIdHolder {
	private static ThreadLocal<Boolean> web = new ThreadLocal<Boolean>();
	public static String CMS_SITE_ID = "CMS_SITE_ID";
	public static String WEB_SITE_ID = "WEB_SITE_ID";
	
	public static Boolean isWeb() {
		return web.get();
	}

	public static void setWeb(Boolean isWeb) {
		SiteIdHolder.web.set(isWeb);;
	}

	public static String getSiteId() {		
		RequestAttributes requestAttributes = RequestContextHolder.currentRequestAttributes();
		String siteId = (String)requestAttributes.getAttribute(isWeb() ? WEB_SITE_ID : CMS_SITE_ID, RequestAttributes.SCOPE_SESSION);
		if (StringUtils.isBlank(siteId)) {
			siteId = CmsProperties.getDefaultSiteId();
		}		
		return siteId;			
	}	
	
}
