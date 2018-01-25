package com.edeas.service.impl;

import java.util.List;
import java.util.Map;
import java.util.Set;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.edeas.model.CmsPage;
import com.edeas.model.Content;
import com.edeas.model.LivePage;
import com.edeas.model.Page;

@Service(value="queryService")
@Transactional
@SuppressWarnings(value = {"rawtypes", "unchecked"})
public class QueryServiceImpl extends BasicServiceImpl {
	
	public List<? extends Page> getAllTopPage(boolean iscms, boolean checkActive) {
		return getPageDao(iscms).findAllTopPage(checkActive);
	}
	
	public Page getHomePage(boolean iscms) {
		List<Page> pages = findPagesByParentId(Page.HOME_PAGE_PARENT_ID, iscms, false); // don't check active for homepage
		return pages.size() > 0 ? pages.get(0) : (iscms ? new CmsPage() : new LivePage());
	}
	
	public Page getMasterPage(boolean iscms) {
		List<Page> pages = findPagesByParentId(Page.MASTER_PAGE_PARENT_ID, iscms, false); // don't check active for masterpage
		return pages.size() > 0 ? pages.get(0) : (iscms ? new CmsPage() : new LivePage());
	}
	
	public List<Page> getOtherPages(boolean iscms) {
		return getPageDao(iscms).findByParentId(Page.OTHER_PAGE_PARENT_ID, true);
	}
	
	public List<Page> findPagesByParentId(long parentId, boolean iscms, boolean checkActive) {
		return getPageDao(iscms).findByParentId(parentId, checkActive);
	}
	
	public Page findPageById(long id, boolean iscms) {
		Page page = (Page)getPageDao(iscms).getById(id);
		return page == null ? (iscms ? new CmsPage() : new LivePage()) : page;
	}
	
	public List<Page> findChildrenUnderTemplate(String template, boolean iscms, boolean checkActive) {
		return getPageDao(iscms).findChildrenUnderTemplate(template, checkActive);
	}
	
	public List<Page> findPageByTemplate(String template, boolean iscms, boolean checkActive) {
		return getPageDao(iscms).findByTemplate(template, checkActive);
	}
	
	public List<Page> findPageByTemplates(String[] templates, boolean iscms, boolean checkActive) {
		return getPageDao(iscms).findByTemplates(templates, checkActive);
	}
	
	public List<Page> findPageByUrl(String url, boolean iscms, boolean checkActive) {
		return getPageDao(iscms).findPageByUrl(url, checkActive);
	}
	
	public List<String> findAvailableTemplates(boolean iscms) {
		return getPageDao(iscms).findAvailableTemplates();
	}
	
	public void addOrUpdate(Page page, boolean iscms) {
		if(page.isNew()) getPageDao(iscms).add(page);
		else getPageDao(iscms).update(page);
		for(Content content : (Set<Content>)page.getContents()) {
			addOrUpdate(content, iscms);
		}
	}
	
	public void addOrUpdate(Content content, boolean iscms) {
		if(content.isNew()) getContentDao(iscms).add(content);
		else getContentDao(iscms).update(content);
	}
	
	public void delete(long pageId) {
		Page cmsPage = findPageById(pageId, true);
		Page livePage = findPageById(pageId, false);
		delete(cmsPage, true);
		delete(livePage, false);
	}
	
	private void delete(Page page, boolean iscms) {
		for(Content content : (Set<Content>)page.getContents()) {
			delete(content, iscms);
		}
		getPageDao(iscms).delete(page.getId());
	}
	
	private void delete(Content content, boolean iscms) {
		getContentDao(iscms).delete(content.getId());
	}
	
	public Page getFirstChild(long parentId, boolean iscms, boolean checkActive, Map<String, String> orderInfo) {
		return getPageDao(iscms).getFirstChild(parentId, iscms, checkActive, orderInfo);
	}
}
