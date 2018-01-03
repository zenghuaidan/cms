package com.edeas.service.impl;

import java.util.List;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.edeas.model.Page;

@Service(value="queryService")
@Transactional
@SuppressWarnings(value = {"rawtypes", "unchecked"})
public class QueryServiceImpl extends BasicServiceImpl {
	
	public List<? extends Page> getAllTopPage(boolean iscms) {
		return getPageDao(iscms).findAllTopPage();
	}
	
	public Page getHomePage(boolean iscms) {
		List<Page> pages = findPagesByParentId(-1, iscms);
		return pages.size() > 0 ? pages.get(0) : null;
	}
	
	public Page getMasterPage(boolean iscms) {
		List<Page> pages = findPagesByParentId(-2, iscms);
		return pages.size() > 0 ? pages.get(0) : null;
	}
	
	public List<Page> getOtherPages(boolean iscms) {
		return getPageDao(iscms).findByParentId(-3);
	}
	
	public List<Page> findPagesByParentId(long parentId, boolean iscms) {
		return getPageDao(iscms).findByParentId(parentId);
	}
	
	public Page findPageById(long id, boolean iscms) {
		return (Page)getPageDao(iscms).getById(id);
	}
	
}
