package com.edeas.dao.impl;

import java.util.List;

public abstract class PageDaoImpl<T> extends BasicDao<T> {
	public List<T> findByParentId(long parentId) {
		return listByHQL("from " + getClz().getName() + " where parent.id=? order by pageOrder asc", new Long[]{ parentId });
	} 
	
	public List<T> findAllTopPage() {
		return listByHQL("from " + getClz().getName() + " where parent.id=0 order by pageOrder asc");
	} 
}
