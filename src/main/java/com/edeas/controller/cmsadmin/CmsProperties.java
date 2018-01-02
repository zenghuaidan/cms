package com.edeas.controller.cmsadmin;

import java.io.IOException;
import java.io.InputStream;
import java.util.Properties;

public class CmsProperties {

	private static Properties properties;
	
	static {
		properties = new Properties();
		InputStream is = null;
		try {
			is = CmsProperties.class.getClassLoader().getResourceAsStream("cms.properties");
			properties.load(is);
		} catch (IOException e) {
			e.printStackTrace();
		} finally {
			try {
				is.close();
			} catch (Exception e) {
			}
		}
	}
	
	public static String getValue(String key) {
		return properties.getProperty(key, "");				
	}
	
	public static String getCMSSiteName() {
		return getValue("CmsSiteName");		
	}
	
	public static int getMaxTopgs() {
		try {
			return Integer.parseInt(getValue("MaxTopgs"));			
		} catch (Exception e) {
			// TODO: handle exception
		}
		return -1;		
	}
}
