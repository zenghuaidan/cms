package com.edeas.controller;

import java.util.HashMap;
import java.util.Map;

import com.edeas.controller.cmsadmin.CmsController;
import com.edeas.web.InitServlet;

@SuppressWarnings("serial")
public class Global {
	public static final Map<String, String> LANGS = new HashMap<String, String>() {		
		{
			put("en", "English");
			put("tc", "繁體");
			put("sc", "简体");
		}
    };
    
	public static String getContentPath() {
		return InitServlet.getWc().getServletContext().getContextPath() + "/resources/Content";
	}
	
	public static String getScriptPath() {
		return InitServlet.getWc().getServletContext().getContextPath() + "/resources/Script";
	} 
	
	public static String getDocUploadPath() {
		return getContentPath() + "/uploads/docs";
	}
	
	public static String getDocUploadPath(String val) {
		return getContentPath() + "/uploads/docs/" + val;
	}
	
	public static String getImagesUploadPath(String type, String val) {
		return getContentPath() + "/uploads/images/" + type + "/" + val;
	}
	
	public static String getImagesUploadPath() {
		return getContentPath() + "/uploads/images";
	}
	
	public static String getCMSUrl() {		
		return CmsController.getCMSUrl();
	}
	
	public static String langClass(String lang) {
		return (lang.equals("en")) ? "en" : "cn";
		
	}
}
