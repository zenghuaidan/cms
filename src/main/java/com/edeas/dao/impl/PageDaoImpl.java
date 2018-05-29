package com.edeas.dao.impl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.commons.lang3.StringUtils;
import org.hibernate.SQLQuery;

import com.edeas.model.Page;
import com.edeas.web.SiteIdHolder;

public abstract class PageDaoImpl<T extends Page> extends BasicDao<T> {
	public List<T> findByParentId(long parentId, boolean checkActive) {		
		return listByHQL("from " + getClz().getName() + " where parentId=? and siteId=? and del=0 " + (checkActive ? " and active=1 " : "") + " order by pageOrder asc", new Object[]{ parentId, SiteIdHolder.getSiteId() });
	} 
	
	public List<T> findAllTopPage(boolean checkActive) {
		return listByHQL("from " + getClz().getName() + " where siteId=? and parentId=0 and del=0 " + (checkActive ? " and active=1 " : "") + " order by pageOrder asc", new String[]{SiteIdHolder.getSiteId()});
	}

	public List<String> findAvailableTemplates() {
		SQLQuery sqlQuery = getSession().createSQLQuery("select distinct template from " + getTableName() + " where del = 0 and siteId=?");
		sqlQuery.setParameter(0, SiteIdHolder.getSiteId());
		return sqlQuery.list();
	}

	public List<T> findByTemplate(String template, boolean checkActive) {
		return listByHQL("from " + getClz().getName() + " where template=? and siteId=? and del=0 " + (checkActive ? " and active=1 " : "") + " order by pageOrder asc", new String[]{ template, SiteIdHolder.getSiteId() });
	}
	
	public List<T> findByTemplates(String[] templates, boolean checkActive) {
		Map<String, Object> alias = new HashMap<String, Object>();
		alias.put("templates", templates);
		alias.put("siteId", SiteIdHolder.getSiteId());
		return listByHQL("from " + getClz().getName() + " where siteId=:siteId and template in (:templates) and del=0 " + (checkActive ? " and active=1 " : "") + " order by pageOrder asc", alias);
	}

	public List<T> findPageByUrl(String url, boolean checkActive) {
		return listByHQL("from " + getClz().getName() + " where url=? and siteId=? and del=0  " + (checkActive ? " and active=1 " : "") + " order by pageOrder asc", new String[]{ url, SiteIdHolder.getSiteId() });
	}

	public T getFirstChild(long parentId, boolean checkActive, String order) {		
		order = StringUtils.isBlank(order) ? "" : " order by " + order;
		List<T> results = listByHQL("from " + getClz().getName() + " where parentId=? and siteId=? and del=0 " + (checkActive ? " and active=1 " : "") + order + " limit 0,1", new Object[]{ parentId, SiteIdHolder.getSiteId() });		
		return results.size() > 0 ? results.get(0) : null;
	}

	public List<T> findChildrenUnderTemplate(String template, boolean checkActive) {
		return listBySQL("select * from " + getTableName() + " where parentId in (" +
				"select id from " + getTableName() + " where template=? and siteId=? and del = 0 and " + (checkActive ? " and active=1 " : "")
				+ ") and del = 0 and " + (checkActive ? " and active=1 " : "") + " order by pageOrder asc", new String[]{ template, SiteIdHolder.getSiteId() }, getClz(), true);		
	}

	public List<T> getChidrenWithOrder(long parentId, boolean checkActive, List<String> orders) {
		String order = "";
		if (orders != null && orders.size() > 0) {
			order = " order by " + String.join(", ", orders);
		}
		return listByHQL("from " + getClz().getName() + " where parentId=? and siteId=? and del=0 " + (checkActive ? " and active=1 " : "") + order, new Object[]{ parentId, SiteIdHolder.getSiteId() });
	} 
}
