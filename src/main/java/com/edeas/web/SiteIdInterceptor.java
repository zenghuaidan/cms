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
		SiteIdHolder.setWeb(false);
		if(!request.getRequestURI().contains(Global.getCMSURI()) 
				&& ( request.getRequestURI().contains("/en/") || request.getRequestURI().contains("/sc/") || request.getRequestURI().contains("/tc/") )) {
			SiteIdHolder.setWeb(true); 
			for(String site : CmsProperties.getCMSSite()) {
				String[] siteInfo = site.split(":");
				if (siteInfo.length >= 3 && siteInfo[2].toLowerCase().contains(request.getHeader("SiteId").toLowerCase())) {
					request.getSession().setAttribute(SiteIdHolder.WEB_SITE_ID, siteInfo[0]);
					break;
				}
			}
		}
						
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
