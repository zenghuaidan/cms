package com.edeas.service.impl;

import javax.inject.Inject;

import org.apache.log4j.Logger;

import com.edeas.dao.impl.CmsContentDaoImpl;
import com.edeas.dao.impl.CmsPageDaoImpl;
import com.edeas.dao.impl.ContentDaoImpl;
import com.edeas.dao.impl.LiveContentDaoImpl;
import com.edeas.dao.impl.LivePageDaoImpl;
import com.edeas.dao.impl.PageDaoImpl;
import com.edeas.dao.impl.UserDaoImpl;

public abstract class BasicServiceImpl {
	protected final Logger logger = Logger.getLogger(BasicServiceImpl.class);
	protected UserDaoImpl userDao;
	protected LivePageDaoImpl livePageDao;
	protected LiveContentDaoImpl liveContentDao;
	protected CmsPageDaoImpl cmsPageDao;
	protected CmsContentDaoImpl cmsContentDao;	

	public UserDaoImpl getUserDao() {
		return userDao;
	}

	@Inject
	public void setUserDao(UserDaoImpl userDao) {
		this.userDao = userDao;
	}

	public LivePageDaoImpl getLivePageDao() {
		return livePageDao;
	}

	@Inject
	public void setLivePageDao(LivePageDaoImpl livePageDao) {
		this.livePageDao = livePageDao;
	}

	@Inject
	public void setLiveContentDao(LiveContentDaoImpl liveContentDao) {
		this.liveContentDao = liveContentDao;
	}

	@Inject
	public void setCmsPageDao(CmsPageDaoImpl cmsPageDao) {
		this.cmsPageDao = cmsPageDao;
	}

	@Inject
	public void setCmsContentDao(CmsContentDaoImpl cmsContentDao) {
		this.cmsContentDao = cmsContentDao;
	}

	public PageDaoImpl getPageDao(boolean iscms) {
		return iscms ? this.cmsPageDao : this.livePageDao;
	}
	
	public ContentDaoImpl getContentDao(boolean iscms) {
		return iscms ? this.cmsContentDao : this.liveContentDao;
	}
	
}
