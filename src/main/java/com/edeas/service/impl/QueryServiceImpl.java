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
		List<Page> pages = getPageDao(iscms).findByParentId(-1);
		return pages.size() > 0 ? pages.get(0) : null;
	}
	
	public Page getMasterPage(boolean iscms) {
		List<Page> pages = getPageDao(iscms).findByParentId(-2);
		return pages.size() > 0 ? pages.get(0) : null;
	}
	
}
