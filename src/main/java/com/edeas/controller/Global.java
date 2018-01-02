package com.edeas.controller;

import com.edeas.web.InitServlet;

public class Global {
	public static String getContentPath() {
		return InitServlet.getWc().getServletContext().getContextPath() + "/resources/Content";
	}
	
	public static String getScriptPath() {
		return InitServlet.getWc().getServletContext().getContextPath() + "/resources/Script";
	} 
}
