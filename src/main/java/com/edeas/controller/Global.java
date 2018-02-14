package com.edeas.controller;

import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.commons.io.FilenameUtils;

import com.edeas.controller.cmsadmin.CmsController;
import com.edeas.web.InitServlet;

@SuppressWarnings("serial")
public class Global {
	public static final String IMAGE_EDITOR = "editor";
	public static final String IMAGE_SOURCE = "source";
	public static final String IMAGE_RESIZE = "resize";
	public static final String IMAGE_CMGR = "cmgr";
	public static final String IMAGE_THUMB = "thumb";
	public static final String WEBPAGEEXT = ".html";
	
	public static final Map<Long, String> fixUrlPrefix = new HashMap<Long, String>() {		
		{
			put(-3l, "Others/");
		}
    };
    
	public static final Map<String, String> goChildTemplates = new HashMap<String, String>() {		
		{
			put("TopSector", "pageOrder asc");
			put("Sector", "pageOrder asc");
		}
    };
    
    public static final List<String> excludeSubMenuList = Arrays.asList(new String[]{""});
    
	public static String getContentPath() {
		return InitServlet.getWc().getServletContext().getContextPath() + "/resources/Content";
	}
	
	public static String getScriptPath() {
		return InitServlet.getWc().getServletContext().getContextPath() + "/resources/Script";
	}
	
	public static String getPluginsPath() {
		return InitServlet.getWc().getServletContext().getContextPath() + "/resources/plugins";
	}
	
	public static String getDocUploadPath() {
		return getContentPath() + "/uploads/docs";
	}
	
	public static String getDocUploadPath(String val) {
		return getDocUploadPath() + "/" + val;
	}
	
	public static String getImagesUploadPath(String type, String val) {
		return getImagesUploadPath(type) + "/" + val;
	}
	
	public static String getImagesUploadPath(String type) {
		return getImagesUploadPath() + "/" + type;
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
	
	public static String getWebUrl() {		
		return InitServlet.getWc().getServletContext().getContextPath();
	}
	
	public static String langClass(String lang) {
		return (lang.equals("en")) ? "en" : "cn";
	}
	
	private static String getPhysicalPath(String path) {
		return InitServlet.getWc().getServletContext().getRealPath(path);
	}

	public static String getDocUploadPhysicalPath() {
		return getPhysicalPath("/resources/Content/uploads/docs");
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
