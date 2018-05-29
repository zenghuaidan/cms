package com.edeas.web;


import javax.servlet.ServletConfig;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;

import org.springframework.stereotype.Service;
import org.springframework.web.context.WebApplicationContext;
import org.springframework.web.context.support.WebApplicationContextUtils;

import com.edeas.common.utils.MailUtils;
import com.edeas.controller.cmsadmin.CmsProperties;
import com.edeas.service.impl.QueryServiceImpl;

public class InitServlet extends HttpServlet {

	private static final long serialVersionUID = 1L;
	private static WebApplicationContext wc;
	
	@Override
	public void init(ServletConfig config) throws ServletException {
		super.init(config);
		wc = WebApplicationContextUtils.getWebApplicationContext(this.getServletContext());
		initMail();		
	}
	
	private void initMail() {
		MailUtils.username = CmsProperties.getValue("mail_username");
		MailUtils.password = CmsProperties.getValue("mail_password");
		MailUtils.frommail = CmsProperties.getValue("mail_frommail");
		MailUtils.protocal = CmsProperties.getValue("mail_protocal");
		MailUtils.host = CmsProperties.getValue("mail_host");
		MailUtils.port = CmsProperties.getValue("mail_port");
		MailUtils.socketFactoryPort = CmsProperties.getValue("mail_socketFactoryPort");
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
