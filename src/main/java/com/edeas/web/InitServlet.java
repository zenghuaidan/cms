package com.edeas.web;


import javax.servlet.ServletConfig;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;

import org.springframework.stereotype.Service;
import org.springframework.web.context.WebApplicationContext;
import org.springframework.web.context.support.WebApplicationContextUtils;

import com.edeas.service.impl.ContentServiceImpl;
import com.edeas.service.impl.PageServiceImpl;
import com.edeas.service.impl.QueryServiceImpl;
import com.edeas.service.impl.UserServiceImpl;

public class InitServlet extends HttpServlet {

	private static final long serialVersionUID = 1L;
	private static WebApplicationContext wc;
	
	@Override
	public void init(ServletConfig config) throws ServletException {
		super.init(config);
		wc = WebApplicationContextUtils.getWebApplicationContext(this.getServletContext());
	}
	
	public static WebApplicationContext getWc() {
		return wc;
	}		

	public static String getWebappsPath() {
		String temp = wc.getServletContext().getRealPath("/");
		return temp.substring(0, temp.substring(0, temp.length() - 1).lastIndexOf("\\"));
	}	
	
//	public static UserServiceImpl getUserService() {
//		Service rm = UserServiceImpl.class.getAnnotation(Service.class);
//		return (UserServiceImpl)InitServlet.getWc().getBean(rm.value());
//	}
//	
//	public static PageServiceImpl getPageService() {
//		Service rm = PageServiceImpl.class.getAnnotation(Service.class);
//		return (PageServiceImpl)InitServlet.getWc().getBean(rm.value());
//	}
//	
//	public static ContentServiceImpl getContentService() {
//		Service rm = ContentServiceImpl.class.getAnnotation(Service.class);
//		return (ContentServiceImpl)InitServlet.getWc().getBean(rm.value());
//	}
	
	public static QueryServiceImpl getQueryService() {
		Service rm = QueryServiceImpl.class.getAnnotation(Service.class);
		return (QueryServiceImpl)InitServlet.getWc().getBean(rm.value());
	}
	
}
