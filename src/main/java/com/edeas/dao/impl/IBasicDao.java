package com.edeas.dao.impl;

import java.util.List;

public interface IBasicDao<T> {
	public T add(T t);
	
	public T getById(Long id);
	
	public List<T> getByIds(Long[] ids);
	
	public void update(T t);
	
	public void delete(Long id);
	
	public List<T> findAll();
}
