package com.edeas.dao.impl;

import java.util.List;

import org.springframework.stereotype.Repository;

import com.edeas.model.Category;
import com.edeas.web.SiteIdHolder;

@Repository(value="categoryDao")
public class CategoryDaoImpl extends BasicDao<Category> {
	
	public List<Category> findAllWithOrderAsc() {		
		return listByHQL("from " + getClz().getName() + " where siteId=? order by corder asc", new String[]{ SiteIdHolder.getSiteId() });
	}
	
}
