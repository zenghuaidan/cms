package com.edeas.web;

public class SiteIdHolder {
	private static ThreadLocal<String> siteId;
	
	public static String SITE_ID = "SITE_ID";

	public static String getSiteId() {
		return SiteIdHolder.siteId.get();
	}

	public static void setSiteId(String siteId) {
		if(SiteIdHolder.siteId == null)
			SiteIdHolder.siteId = new ThreadLocal<String>();
		SiteIdHolder.siteId.set(siteId);
	}
	
	
}
