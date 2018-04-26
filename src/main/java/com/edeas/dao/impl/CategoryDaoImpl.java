package com.edeas.dao.impl;

import java.util.List;

import org.springframework.stereotype.Repository;

import com.edeas.model.Category;

@Repository(value="categoryDao")
public class CategoryDaoImpl extends BasicDao<Category> {
	
	public List<Category> findAllWithOrderAsc() {
		return getSession().createQuery("from Category order by corder asc").list();
	}
	
}
