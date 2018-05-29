package com.edeas.controller.cmsadmin;

import java.io.IOException;
import java.io.InputStream;
import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Properties;

import org.apache.commons.lang3.StringUtils;

import com.edeas.web.SiteIdHolder;

@SuppressWarnings("serial")
public class CmsProperties {

	private static Properties properties;
	
	public static final Map<String, Map<String, String>> articleBaseTpls = new HashMap<String, Map<String, String>>() {		
		{
			put("NewsListIdx", new HashMap<String, String>(){ 
				{
					put("order", "pgtimei");
					put("datefield", "singledate");
					put("datelabel", "日期");
					put("itmlabel", "News");
				} 
			});
			put("NewsMasonryIdx", new HashMap<String, String>(){ 
				{
					put("order", "pgtimei");
					put("datefield", "nodate");
					put("datelabel", "日期");
					put("itmlabel", "News");
				} 
			});
		}
    };
	
	public static final Map<String, Map<String, String>> enableAutoNameParentTpls = new HashMap<String, Map<String, String>>() {		
		{
			put("TrainIdx", new HashMap<String, String>(){ {put("namealg", "daterange");} });
			put("GrantIdx", new HashMap<String, String>(){ {put("namealg", "pgorder");} });
		}
    };
    
	public static final Map<String, Map<String, String>> enableDTimeParentTpls = new HashMap<String, Map<String, String>>() {		
		{
			put("NewsListIdx", new HashMap<String, String>(){ {put("format", "dat");put("labeldate", "Date");} });
			put("ConcertIdx", new HashMap<String, String>(){ {put("format", "dat tim");put("labeldate", "Date");put("labeltime", "Time");} });
			put("NewWorksIdx", new HashMap<String, String>(){ {put("format", "dat tim");put("labeldate", "Date");put("labeltime", "Time");} });
		}
    };
    
//    public static final Map<String, Map<String, String>> enableDTimeTpls = new HashMap<String, Map<String, String>>() {		
//		{
//			put("NewsListInside", new HashMap<String, String>(){ {put("format", "yr");put("labeldate", "Date");put("pastyr", "10");put("upcomingyr", "5");} });			
//		}
//    };
    
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
		String[] sites = getCMSSite();
		Map<String, String> siteMap = new HashMap<String, String>();
		for(String site : sites) {
			siteMap.put(site.split(":")[0], site.split(":")[1]);
		}
		return siteMap.get(SiteIdHolder.getSiteId());		
	}

	public static String[] getCMSSite() {
		String value = getValue("CmsSiteName");
		String[] sites = value.split(",");
		return sites;
	}
	
	public static String getDefaultSiteId() {
		String[] sites = getCMSSite();
		return sites[0].split(":")[0];		
	}
	
	public static String getDefaultLanguage() {
		return getValue("DefaultLanguage");		
	}
	
	public static int getMaxTopgs() {		
		return getIntValue("MaxTopgs");
	}
	
	public static int getMaxLevel() {		
		return getIntValue("MaxLevel");
	}
	
	public static String getGACode() {		
		return getValue("GACode");
	}
	
	public static String getHost() {		
		return getValue("HOST");
	}
	
	// size in M unit
	public static int getImageMaxUploadSize() {
		return getIntValue("ImageMaxUploadSize");		
	}

	private static int getIntValue(String key) {
		try {
			return Integer.parseInt(getValue(key));			
		} catch (Exception e) {
		}
		return -1;
	}
	
	public static List<String> getHideSubTpls() {		
		return toList("SAHideSubTpls");
	}
	
	public static List<String> getExcTpls() {		
		return toList("SAExcTpls");
	}
	
	public static List<String> getNoPreviewTpls() {		
		return toList("NoPreviewTpls");
	}
	
	public static List<String> getNoContentTpls() {
		return toList("NoContentTpls");
	}

	private static List<String> toList(String key) {
		String templateStr = getValue(key);
		String[] templates = templateStr.split(",");
		return Arrays.asList(templates);
	}
	
	public static boolean isExcTpl(String template) {		
		return getExcTpls().contains(template);
	}
	
	public static boolean isHideSubTpl(String template) {		
		return getHideSubTpls().contains(template);
	}
	
	public static boolean isNoPreviewTpl(String template) {		
		return getNoPreviewTpls().contains(template);
	}
	
	public static boolean isNoContentTpl(String template) {		
		return getNoContentTpls().contains(template);
	}
	
	public static boolean isDevMode() {
		String devMode = getValue("devMode");
		return !StringUtils.isBlank(devMode) && (devMode.toLowerCase().equals("on") || devMode.toLowerCase().equals("yes"));
	}
	
	public static String getDevLoginUser() {
		return getValue("devLoginUser");
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
