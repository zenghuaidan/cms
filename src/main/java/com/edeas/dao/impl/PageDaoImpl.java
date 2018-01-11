package com.edeas.dao.impl;

import java.util.List;

import org.hibernate.SQLQuery;

import com.edeas.model.Page;

public abstract class PageDaoImpl<T extends Page> extends BasicDao<T> {
	public List<T> findByParentId(long parentId, boolean checkActive) {		
		return listByHQL("from " + getClz().getName() + " where parentId=? " + (checkActive ? " and del=0 and active=1 " : "") + " order by pageOrder asc", new Long[]{ parentId });
	} 
	
	public List<T> findAllTopPage(boolean checkActive) {
		return listByHQL("from " + getClz().getName() + " where parentId=0 " + (checkActive ? " and del=0 and active=1 " : "") + " order by pageOrder asc");
	}

	public List<String> findActiveTemplates() {
		SQLQuery sqlQuery = getSession().createSQLQuery("select distinct template from " + getTableName() + " where del = 0");
		return sqlQuery.list();
	}

	public List<T> findByTemplate(String template, boolean checkActive) {
		return listByHQL("from " + getClz().getName() + " where template=? " + (checkActive ? " and del=0 and active=1 " : "") + " order by pageOrder asc", new String[]{ template });
	}

	public List<T> findPageByUrl(String url, boolean checkActive) {
		return listByHQL("from " + getClz().getName() + " where url=? " + (checkActive ? " and del=0 and active=1 " : "") + " order by pageOrder asc", new String[]{ url });
	} 
}
