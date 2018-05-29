package com.edeas.web;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.servlet.HandlerInterceptor;
import org.springframework.web.servlet.ModelAndView;

import com.edeas.controller.Global;
import com.edeas.controller.cmsadmin.CmsProperties;
import com.edeas.service.impl.UserServiceImpl;

public class SiteIdInterceptor implements HandlerInterceptor {

	protected final Logger logger = Logger.getLogger(SiteIdInterceptor.class);
	
	@Autowired
	UserServiceImpl userService;	
	
	@Override
	public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler)
			throws Exception {
		logger.debug("Url:" + request.getRequestURI());
		logger.debug("Host:" + request.getHeader("Host"));
		if(request.getSession().getAttribute(SiteIdHolder.SITE_ID) == null) {
			if(!request.getRequestURI().contains(Global.getCMSURI())) {			
				for(String site : CmsProperties.getCMSSite()) {
					String[] siteInfo = site.split(":");
					if (siteInfo.length >= 3 && request.getHeader("Host").toLowerCase().contains(siteInfo[2].toLowerCase())) {
						request.getSession().setAttribute(SiteIdHolder.SITE_ID, siteInfo[0]);
						break;
					}
				}
			}
		}
		
		if(request.getSession().getAttribute(SiteIdHolder.SITE_ID) == null) {
			request.getSession().setAttribute(SiteIdHolder.SITE_ID, CmsProperties.getDefaultSiteId());
		}
			
		SiteIdHolder.setSiteId(request.getSession().getAttribute(SiteIdHolder.SITE_ID).toString());
		return true;
	}

	@Override
	public void postHandle(HttpServletRequest request, HttpServletResponse response, Object handler,
			ModelAndView modelAndView) throws Exception {
		// TODO Auto-generated method stub

	}

	@Override
	public void afterCompletion(HttpServletRequest request, HttpServletResponse response, Object handler, Exception ex)
			throws Exception {
		// TODO Auto-generated method stub

	}

}
