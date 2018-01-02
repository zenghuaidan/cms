package com.edeas.dao.impl;

import java.util.List;

public abstract class PageDaoImpl<T> extends BasicDao<T> {
	public List<T> findByParentId(int parentId) {
		return listByHQL("from " + getClz().getName() + " where parent.id=?", new Integer[]{ parentId });
	} 
	
	public List<T> findAllTopPage() {
		return listByHQL("from " + getClz().getName() + " where parent.id=0");
	} 
}
