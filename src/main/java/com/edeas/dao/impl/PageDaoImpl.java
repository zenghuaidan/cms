package com.edeas.dao.impl;

import java.util.List;

import org.hibernate.SQLQuery;

public abstract class PageDaoImpl<T> extends BasicDao<T> {
	public List<T> findByParentId(long parentId) {
		return listByHQL("from " + getClz().getName() + " where parentId=? order by pageOrder asc", new Long[]{ parentId });
	} 
	
	public List<T> findAllTopPage() {
		return listByHQL("from " + getClz().getName() + " where parentId=0 order by pageOrder asc");
	}

	public List<String> findActiveTemplates() {
		SQLQuery sqlQuery = getSession().createSQLQuery("select distinct template from " + getTableName() + " where del = 0");
		return sqlQuery.list();
	} 
}
