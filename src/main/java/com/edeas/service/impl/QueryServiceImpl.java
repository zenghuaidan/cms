package com.edeas.service.impl;

import java.util.List;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.edeas.model.CmsPage;
import com.edeas.model.LivePage;
import com.edeas.model.Page;

@Service(value="queryService")
@Transactional
@SuppressWarnings(value = {"rawtypes", "unchecked"})
public class QueryServiceImpl extends BasicServiceImpl {
	
	public List<? extends Page> getAllTopPage(boolean iscms) {
		return getPageDao(iscms).findAllTopPage();
	}
	
	public Page getHomePage(boolean iscms) {
		List<Page> pages = findPagesByParentId(Page.HOME_PAGE_PARENT_ID, iscms);
		return pages.size() > 0 ? pages.get(0) : (iscms ? new CmsPage() : new LivePage());
	}
	
	public Page getMasterPage(boolean iscms) {
		List<Page> pages = findPagesByParentId(Page.MASTER_PAGE_PARENT_ID, iscms);
		return pages.size() > 0 ? pages.get(0) : (iscms ? new CmsPage() : new LivePage());
	}
	
	public List<Page> getOtherPages(boolean iscms) {
		return getPageDao(iscms).findByParentId(Page.OTHER_PAGE_PARENT_ID);
	}
	
	public List<Page> findPagesByParentId(long parentId, boolean iscms) {
		return getPageDao(iscms).findByParentId(parentId);
	}
	
	public Page findPageById(long id, boolean iscms) {
		Page page = (Page)getPageDao(iscms).getById(id);
		return page == null ? (iscms ? new CmsPage() : new LivePage()) : page;
	}
	
	public List<String> findActiveTemplates(boolean iscms) {
		return getPageDao(iscms).findActiveTemplates();
	}
	
	public void addOrUpdate(Page page, boolean iscms) {
		if(page.isNew()) getPageDao(iscms).add(page);
		else getPageDao(iscms).update(page);
	}
	
}
