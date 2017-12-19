package com.edeas.web;

import javax.servlet.ServletConfig;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;

import org.springframework.web.context.WebApplicationContext;
import org.springframework.web.context.support.WebApplicationContextUtils;

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
}
