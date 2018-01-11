package com.edeas.web;

import java.io.IOException;

import javax.servlet.Filter;
import javax.servlet.FilterChain;
import javax.servlet.FilterConfig;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.commons.lang3.StringUtils;

import com.edeas.controller.Global;
import com.edeas.controller.cmsadmin.AuthController;
import com.edeas.model.User;

public class LoginFilter implements Filter {
	
	@Override
	public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
			throws IOException, ServletException {
		HttpServletRequest _request = (HttpServletRequest) request;   
		HttpServletResponse _response = (HttpServletResponse) response;
				
		String cmsurl = Global.getCMSURI();
		HttpSession session = getSession(_request);
		User user = (User)session.getAttribute(AuthController.LOGIN_USER);
		if (!isCmsLoginPage(cmsurl, _request) && user == null) {
			_response.sendRedirect(_request.getContextPath() + cmsurl);
		} else {
			chain.doFilter(request, response);
		}
	}
	
	private HttpSession getSession(HttpServletRequest request) {
		String sessionId = (String)request.getParameter("sessionId");
		HttpSession session = request.getSession();
		//if has sessionId, the request is come from c:import, need to obtain the original session
		if (!StringUtils.isBlank(sessionId)) {
			session = SystemSessionContext.getSession(sessionId);
		}
		return session;
	}
	
	public boolean isCmsLoginPage(String cmsurl, HttpServletRequest request) {
		return isCmsLoginPage(new String[]{ cmsurl }, request);
	}
	
	public boolean isCmsLoginPage(String[] values, HttpServletRequest request) {
		for(String value : values) {
			if (request.getRequestURI().toString().equals(request.getContextPath() + value) || request.getRequestURI().toString().equals(request.getContextPath() + value + "/")) {
				return true;
			}
		}
		return false;
	}

	@Override
	public void init(FilterConfig filterConfig) throws ServletException {
		// The InitServlet is not init yet, should use filterConfig to get the servletContext
//		userService = (IUserService)WebApplicationContextUtils.getWebApplicationContext(filterConfig.getServletContext()).getBean("userService");
	}

	@Override
	public void destroy() {
		
	}

}
