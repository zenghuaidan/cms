package com.edeas.web;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

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
import org.springframework.web.context.support.WebApplicationContextUtils;

import com.edeas.controller.Global;
import com.edeas.model.User;
import com.edeas.service.impl.UserServiceImpl;
import com.edeas.utils.PasswordUtils;

public class LoginFilter implements Filter {
	
	@Override
	public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
			throws IOException, ServletException {
		// below logic only make sense when you want to customize the error login message
		// login checking is handled by spring security
		HttpServletRequest _request = (HttpServletRequest) request;   
		HttpServletResponse _response = (HttpServletResponse) response;
				
		String cmsurl = Global.getCMSURI();
		if (!isCmsLoginPage(cmsurl, _request)) {
			String userName = (String) request.getParameter("userName");
			String password = (String) request.getParameter("password");
			List<String> errors = new ArrayList<String>();
			if (StringUtils.isBlank(userName)) {
				errors.add("Please input your user name.");	
			} else if (StringUtils.isBlank(password)) {
				errors.add("Please input your password.");	
			} else {
				UserServiceImpl userService = (UserServiceImpl)WebApplicationContextUtils.getWebApplicationContext(_request.getSession().getServletContext()).getBean("userService");
				User user = userService.findByUserName(userName);						
				if (user == null || !PasswordUtils.matches(password, user.getPassword()))
					errors.add("Invalidate user name or password.");
//				else
//					SystemSessionContext.addSession(_request.getSession());
			}
			_request.getSession().setAttribute("errors", errors);
			if (errors.size() > 0) {
				_response.sendRedirect(_request.getContextPath() + cmsurl);
			} else {
				chain.doFilter(request, response);
			}
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
