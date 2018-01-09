package com.edeas.controller;

import java.util.HashMap;
import java.util.Map;

import org.apache.commons.io.FilenameUtils;

import com.edeas.controller.cmsadmin.CmsController;
import com.edeas.web.InitServlet;

@SuppressWarnings("serial")
public class Global {
	public static final String IMAGE_SOURCE = "source";
	public static final String IMAGE_RESIZE = "resize";
	public static final String IMAGE_CMGR = "cmgr";
	public static final String IMAGE_THUMB = "thumb";
	
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
		return getDocUploadPath() + "/" + val;
	}
	
	public static String getImagesUploadPath(String type, String val) {
		return getImagesUploadPath() + "/" + type + "/" + val;
	}
	
	public static String getImagesUploadPath() {
		return getContentPath() + "/uploads/images";
	}
	
	public static String getCMSURI() {		
		return CmsController.getCMSURI();
	}
	
	public static String getCMSUrl() {		
		return InitServlet.getWc().getServletContext().getContextPath() + CmsController.getCMSURI();
	}
	
	public static String langClass(String lang) {
		return (lang.equals("en")) ? "en" : "cn";
	}
	
	private static String getPhysicalPath(String path) {
		return InitServlet.getWc().getServletContext().getRealPath(path);
	}

	public static String getDocUploadPhysicalPath() {
		return getPhysicalPath("/resources/Content/uploads/doc");
	}
	
	public static String getDocUploadPhysicalPath(String val) {
		return FilenameUtils.concat(getDocUploadPhysicalPath(), val);
	}
	
	public static String getImagesUploadPhysicalPath(String type, String val) {
		return FilenameUtils.concat(getImagesUploadPhysicalPath(type), val);
	}
	
	public static String getImagesUploadPhysicalPath(String type) {
		return FilenameUtils.concat(getImagesUploadPhysicalPath(), type);
	}
	
	public static String getImagesUploadPhysicalPath() {
		return getPhysicalPath("/resources/Content/uploads/images");
	}
}
