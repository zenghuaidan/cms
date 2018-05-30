package com.edeas.service.impl;

import java.io.InputStream;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Set;

import org.apache.commons.io.IOUtils;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.edeas.common.utils.MailUtils;
import com.edeas.controller.Global;
import com.edeas.controller.cmsadmin.CmsProperties;
import com.edeas.dto.Result;
import com.edeas.model.Category;
import com.edeas.model.CmsContent;
import com.edeas.model.CmsPage;
import com.edeas.model.Content;
import com.edeas.model.LiveContent;
import com.edeas.model.LivePage;
import com.edeas.model.Page;
import com.edeas.model.PageRole;
import com.edeas.model.PageStatus;
import com.edeas.model.Privilege;
import com.edeas.model.User;
import com.edeas.model.WorkflowMsg;
import com.edeas.web.SiteIdHolder;

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
	
	public List<Page> getBottomPages(boolean iscms) {
		return findPagesByParentId(Page.MASTER_PAGE_PARENT_ID, iscms, false);
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
		if(page.isNew()){
			page.setSiteId(SiteIdHolder.getSiteId());
			getPageDao(iscms).add(page);	
			UserDetails userDetails = (UserDetails) SecurityContextHolder.getContext().getAuthentication().getPrincipal();
			User login = userDao.findByUserName(userDetails.getUsername());
			List<Privilege> privileges = new ArrayList<Privilege>();
			if(page.getParentId() == 0 || login.isAdmin()) {//
				privileges.add(Privilege.ed);
				privileges.add(Privilege.pb);
			} else {
				if(login.hasEditPagePermission(page.getParentId())) {
					privileges.add(Privilege.ed);
				}
				if(login.hasPublishPagePermission(page.getParentId())) {
					privileges.add(Privilege.pb);
				}
			}
			for(Privilege privilege : privileges) {					
				PageRole pageRole = new PageRole();
				pageRole.setPageId(page.getId());
				pageRole.setPrivilege(privilege);
				pageRole.setUser(login);
				pageRoleDao.add(pageRole);
			}
		}
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
		if(!cmsPage.isNew())
			delete(cmsPage, true);
		if(!livePage.isNew())
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
	
	public Page getFirstChild(long parentId, boolean iscms, boolean checkActive, String order) {//orderInfo: key=property of Page, value=asc|desc
		return getPageDao(iscms).getFirstChild(parentId, checkActive, order);
	}
	
	public List<Page> getChidrenByPageTimeFromDesc(long parentId, boolean iscms, boolean checkActive) {
		return getChidrenWithOrder(parentId, iscms, checkActive, Arrays.asList("pageTimeFrom desc"));
	}
	
	public List<Page> getChidrenByPageOrderAsc(long parentId, boolean iscms, boolean checkActive) {
		return getChidrenWithOrder(parentId, iscms, checkActive, Arrays.asList("pageOrder asc"));
	}
	
	public List<Page> getChidrenWithOrder(long parentId, boolean iscms, boolean checkActive, List<String> orders) {
		return getPageDao(iscms).getChidrenWithOrder(parentId, checkActive, orders);
	}
	
	public User findByUserName(String userName) {
		try {			
			return userDao.findByUserName(userName);
		} catch (Exception e) {
		}
		return null;
	}

	public List<Category> getAllCategory() {
		return categoryDao.findAllWithOrderAsc();
	}
	
	public void chgPgOrder(Long id, Long beforeId) {
		for(boolean iscms : new Boolean[] {true, false}) {
			Page thispg = findPageById(id, iscms);
			Page parent = findPageById(thispg.getParentId(), iscms);
			List<Page> pages = parent.getChildren(false);
			
			if (beforeId > 0)
			{
				Page beforepg = findPageById(beforeId, iscms);
				int newo = beforepg.getPageOrder() - 1;
				
				if (beforepg.getPageOrder() > thispg.getPageOrder())
				{
					for(Page page : pages) {
						if (page.getPageOrder() > thispg.getPageOrder() && page.getPageOrder() < beforepg.getPageOrder())
							page.setPageOrder(page.getPageOrder() - 1);
					}
				}
				else if (beforepg.getPageOrder() < thispg.getPageOrder())
				{
					newo = beforepg.getPageOrder();              
					for(Page page : pages) {                	
						if (page.getPageOrder() >= beforepg.getPageOrder() && page.getPageOrder() < thispg.getPageOrder())
							page.setPageOrder(page.getPageOrder() + 1);
					}
				}     
				thispg.setPageOrder(newo);
			}
			else
			{
				int newo = 1;
				for(Page page : pages) {
					if (page.getPageOrder() > thispg.getPageOrder())
						page.setPageOrder(page.getPageOrder() - 1);
					newo = Math.max(newo, page.getPageOrder());
				}
				thispg.setPageOrder(newo + 1);
			}			
		}
	}
	
	public Result doReqPublish(long pgid, long approverId, String message) {
		CmsPage page = (CmsPage)findPageById(pgid, true);
		 User approver = userDao.getById(approverId);
		 try {
			 if(!page.isNew() && approver != null) {
				 UserDetails userDetails = (UserDetails) SecurityContextHolder.getContext().getAuthentication().getPrincipal();
				 User login = userDao.findByUserName(userDetails.getUsername());
				 
				 InputStream emailContent = this.getClass().getResourceAsStream("/email/reqpublish.tpl");
				 String emailContentStr = IOUtils.toString(emailContent, "utf-8");
				 emailContent.close();
				 Map<String, String> emailContentMap = new HashMap<String, String>();
				 emailContentMap.put("sender", login.getFirstName());
				 emailContentMap.put("reqpage", page.getName());
				 emailContentMap.put("message", message);
				 emailContentMap.put("cmsurl", CmsProperties.getHost() + Global.getCMSUrl() + "/PageAdmin/Index?id=" + page.getId());
				 MailUtils.sendmailWithTemplate(approver.getFirstName(), approver.getEmail(), CmsProperties.getValue("PUBLISHREQ_SUBJECT"), emailContentStr, emailContentMap, false, true);
				 
				 page.setStatus(PageStatus.WAIT);
				 getPageDao(true).update(page);
				 workflowMsgDao.add(new WorkflowMsg(login, page, page.getRelease(), page.getEdit(), true, false, false, message));
			 }			 
		 } catch (Exception e) {
			 return new Result(e.getMessage(), e.getMessage());
		 }
		 return new Result();
	}
	
	public Result doDecline(long pgid, String message) {
		 CmsPage page = (CmsPage)findPageById(pgid, true);
		 try {
			 if(!page.isNew()) {
				 UserDetails userDetails = (UserDetails) SecurityContextHolder.getContext().getAuthentication().getPrincipal();
				 User login = userDao.findByUserName(userDetails.getUsername());
				 
				 InputStream emailContent = this.getClass().getResourceAsStream("/email/declinefinal.tpl");
				 String emailContentStr = IOUtils.toString(emailContent, "utf-8");
				 emailContent.close();
				 Map<String, String> emailContentMap = new HashMap<String, String>();
				 emailContentMap.put("sender", login.getFirstName());
				 emailContentMap.put("reqpage", page.getName());
				 emailContentMap.put("message", message);
				 emailContentMap.put("cmsurl", CmsProperties.getHost() + Global.getCMSUrl() + "/PageAdmin/Index?id=" + page.getId());
				 User latestPublishRequestor = page.getLatestPublishRequestor();
				 if (latestPublishRequestor != null)
					 MailUtils.sendmailWithTemplate(latestPublishRequestor.getFirstName(), latestPublishRequestor.getEmail(), CmsProperties.getValue("DECLINE_SUBJECT"), emailContentStr, emailContentMap, false, true);
				 
				 page.setStatus(PageStatus.DECLINED);
//				 page.setReqDelete(false);// set delete request to false in case this is a mark delete request
				 getPageDao(true).update(page);
				 workflowMsgDao.add(new WorkflowMsg(login, page, page.getRelease(), page.getEdit(), false, true, false, message));
			 }			 
		 } catch (Exception e) {
			 return new Result(e.getMessage(), e.getMessage());
		 }
		 return new Result();
	}
	
	public Result doPublish(long pgid, String message) {
		CmsPage cmsPage = (CmsPage)findPageById(pgid, true);
		try {
			if (!cmsPage.isNew()) {
				UserDetails userDetails = (UserDetails) SecurityContextHolder.getContext().getAuthentication().getPrincipal();
				User login = userDao.findByUserName(userDetails.getUsername());
				
				InputStream emailContent = this.getClass().getResourceAsStream("/email/publish.tpl");
				String emailContentStr = IOUtils.toString(emailContent, "utf-8");
				emailContent.close();
				Map<String, String> emailContentMap = new HashMap<String, String>();
				emailContentMap.put("sender", login.getFirstName());
				emailContentMap.put("reqpage", cmsPage.getName());
				emailContentMap.put("message", message);
				emailContentMap.put("cmsurl", CmsProperties.getHost() + Global.getCMSUrl() + "/PageAdmin/Index?id=" + cmsPage.getId());
				User latestPublishRequestor = cmsPage.getLatestPublishRequestor();
				if (latestPublishRequestor != null)
					MailUtils.sendmailWithTemplate(latestPublishRequestor.getFirstName(), latestPublishRequestor.getEmail(), CmsProperties.getValue("PUBLISH_SUBJECT"), emailContentStr, emailContentMap, false, true);
				
				cmsPage.increateRelease();
				cmsPage.setEdit(0);
				cmsPage.setStatus(PageStatus.LIVE);
				cmsPage.setPublishTime(new Date());
				if(cmsPage.isReqDelete()) {
					cmsPage.setDelete(true);
				}
				
				LivePage livePageParent = (LivePage)findPageById(cmsPage.getParentId(), false);
				LivePage livePage = (LivePage)findPageById(pgid, false);
				livePage.copyFrom(cmsPage);
				livePage.setParent(livePageParent);
				livePage.setCmsPage(cmsPage);
				
				for (CmsContent cmsContent : (Set<CmsContent>)cmsPage.getContents()) {
					LiveContent liveContent = livePage.getContent(cmsContent.getLang());
					if (liveContent == null || liveContent.isNew()) {
						liveContent = new LiveContent();
						livePage.getContents().add(liveContent);
					}
					liveContent.copyFrom(cmsContent);
					liveContent.setPage(livePage);				
				}
				addOrUpdate(livePage, false);
				workflowMsgDao.add(new WorkflowMsg(login, cmsPage, cmsPage.getRelease(), cmsPage.getEdit(), false, false, true, ""));
				logger.info("Page=" + pgid + " has been published successfully");
				Result result = new Result();
				result.setDelPage(cmsPage.isReqDelete());
				return result;
			} else {
				logger.warn("Can not find this page=" + pgid + " for publish");
				return new Result("Failed", "Can not find this page for publish");
			}			
		} catch (Exception e) {
			return new Result(e.getMessage(), e.getMessage());
		}
	}
}
