package com.edeas.dao.impl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.hibernate.SQLQuery;

import com.edeas.model.Page;

public abstract class PageDaoImpl<T extends Page> extends BasicDao<T> {
	public List<T> findByParentId(long parentId, boolean checkActive) {		
		return listByHQL("from " + getClz().getName() + " where parentId=? and del=0  " + (checkActive ? " and active=1 " : "") + " order by pageOrder asc", new Long[]{ parentId });
	} 
	
	public List<T> findAllTopPage(boolean checkActive) {
		return listByHQL("from " + getClz().getName() + " where parentId=0 and del=0  " + (checkActive ? " and active=1 " : "") + " order by pageOrder asc");
	}

	public List<String> findAvailableTemplates() {
		SQLQuery sqlQuery = getSession().createSQLQuery("select distinct template from " + getTableName() + " where del = 0");
		return sqlQuery.list();
	}

	public List<T> findByTemplate(String template, boolean checkActive) {
		return listByHQL("from " + getClz().getName() + " where template=? and del=0  " + (checkActive ? " and active=1 " : "") + " order by pageOrder asc", new String[]{ template });
	}
	
	public List<T> findByTemplates(String[] templates, boolean checkActive) {
		Map<String, Object> alias = new HashMap<String, Object>();
		alias.put("templates", templates);
		return listByHQL("from " + getClz().getName() + " where template in (:templates) and del=0  " + (checkActive ? " and active=1 " : "") + " order by pageOrder asc", alias);
	}

	public List<T> findPageByUrl(String url, boolean checkActive) {
		return listByHQL("from " + getClz().getName() + " where url=? and del=0  " + (checkActive ? " and active=1 " : "") + " order by pageOrder asc", new String[]{ url });
	}

	public T getFirstChild(long parentId, boolean iscms, boolean checkActive, Map<String, String> orderInfo) {
		List<T> results = listByHQL("from " + getClz().getName() + " where parentId=? and del=0  " + (checkActive ? " and active=1 " : "") + " order by " + orderInfo.get("column") + " " + orderInfo.get("order") + " limit 0,1", new Long[]{ parentId });		
		return results.size() == 1 ? results.get(0) : null;
	}

	public List<T> findChildrenUnderTemplate(String template, boolean checkActive) {
		return listBySQL("select * from " + getTableName() + " where parentId in (" +
				"select id from " + getTableName() + " where template=? and del = 0 and " + (checkActive ? " and active=1 " : "")
				+ ") and del = 0 and " + (checkActive ? " and active=1 " : "") + " order by pageOrder asc", new String[]{ template }, getClz(), true);		
	} 
}
