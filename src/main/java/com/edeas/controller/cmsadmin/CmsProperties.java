package com.edeas.controller.cmsadmin;

import java.io.IOException;
import java.io.InputStream;
import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Properties;

@SuppressWarnings("serial")
public class CmsProperties {

	private static Properties properties;
	public static final Map<String, Map<String, String>> enableAutoNameParentTpls = new HashMap<String, Map<String, String>>() {		
		{
			put("TrainIdx", new HashMap<String, String>(){ {put("namealg", "daterange");} });
			put("GrantIdx", new HashMap<String, String>(){ {put("namealg", "pgorder");} });
		}
    };
    
	public static final Map<String, Map<String, String>> enableDTimeParentTpls = new HashMap<String, Map<String, String>>() {		
		{
			put("ConcertIdx", new HashMap<String, String>(){ {put("format", "dat tim");put("labeldate", "Date");put("labeltime", "Time");} });
			put("NewsIdx", new HashMap<String, String>(){ {put("format", "dat");put("labeldate", "Date");} });
			put("NewWorksIdx", new HashMap<String, String>(){ {put("format", "dat tim");put("labeldate", "Date");put("labeltime", "Time");} });
		}
    };
    
    public static final Map<String, Map<String, String>> enableDTimeTpls = new HashMap<String, Map<String, String>>() {		
		{
			put("ArtistSpeakerIndex", new HashMap<String, String>(){ {put("format", "yr");put("labeldate", "Date");put("pastyr", "10");put("upcomingyr", "5");} });			
		}
    };
    
    public static final Map<String, Map<String, String>> customPgOrderParentTpls = new HashMap<String, Map<String, String>>() {		
		{
			put("GrantIdx", new HashMap<String, String>(){ {put("label", "資助篇號");} });			
		}
    };
	
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
		}
		return -1;		
	}
	
	public static int getMaxLevel() {
		try {
			return Integer.parseInt(getValue("MaxLevel"));			
		} catch (Exception e) {
		}
		return -1;		
	}
	
	public static List<String> getHideSubTpls() {
		String hideSubTplsStr = getValue("SAHideSubTpls");
		String[] hideSubTpls = hideSubTplsStr.split(",");
		return Arrays.asList(hideSubTpls);
	}
	
	public static List<String> getExcTpls() {
		String hideSubTplsStr = getValue("SAExcTpls");
		String[] hideSubTpls = hideSubTplsStr.split(",");
		return Arrays.asList(hideSubTpls);
	}
	
	public static boolean isHideSubTpls(String template) {		
		return getHideSubTpls().contains(template);
	}
	
	// default level is -1, if incorrect level no is set, -1 will be set, if same template occur, the first will be used
	public static Map<String, Integer> getForceChildTpls() {
		String hideSubTplsStr = getValue("ForceChildTpls");
		String[] hideSubTpls = hideSubTplsStr.split(",");
		Map<String, Integer> map = new HashMap<String, Integer>();
		for (String hideSubTpl : hideSubTpls) {
			int level = -1;
			String template = hideSubTpl.trim();
			if(template.contains(":")) {
				String[] values = template.split(":", 2);
				template = values[0].trim();
				try {
					level = Integer.parseInt(values[1].trim());
				} catch (Exception e) {
				}
			}
			if (!map.containsKey(template)){
				map.put(template, level);			
			}
		}
		return map;
	}
}