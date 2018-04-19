package com.edeas.model;

import java.util.ArrayList;
import java.util.Collections;
import java.util.Comparator;
import java.util.Date;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

import javax.persistence.Column;
import javax.persistence.EnumType;
import javax.persistence.Enumerated;
import javax.persistence.FetchType;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.MappedSuperclass;
import javax.persistence.OneToMany;
import javax.persistence.OrderBy;
import javax.persistence.Temporal;
import javax.persistence.TemporalType;
import javax.persistence.Transient;

import org.apache.commons.lang3.StringUtils;
import org.hibernate.annotations.Generated;
import org.hibernate.annotations.GenerationTime;

import com.edeas.controller.Global;
import com.edeas.controller.cmsadmin.CmsProperties;

@MappedSuperclass
public class Page<T extends Page, E extends Content> {
	private T parent;
	private Long parentId = 0l;
	private Long rootId = 0l;
	private int pageLevel;
	private int approveLevel;
	private int release;
	private int edit;
	private String template;
	private PageStatus status = PageStatus.NEW;
	private boolean active = true;
	private boolean delete;
	private boolean reqDelete;
	private Date publishTime = new Date();
	private Date expireTime = new Date();
	private boolean neverExpire = true;
	private Date pageTimeFrom = new Date();
	private Date pageTimeTo = new Date();
	private String pageTimeDisplay;
	private int pageOrder;
	private String name;
	private String url;
	private String commonxml;
	private Date createTime = new Date();;
	private Date updateTime;
	private Set<E> contents = new HashSet<E>();
	private Set<T> children = new HashSet<T>();

	@Transient
	public Long getId() {
		if(this instanceof CmsPage) return ((CmsPage)this).getId();
		if(this instanceof LivePage) return ((LivePage)this).getId();
		return -1l;
	}
	
	public void setId(Long id) {
		if(this instanceof CmsPage)
			((CmsPage)this).setId(id);
		if(this instanceof LivePage)
			((LivePage)this).setId(id);
	}

	@ManyToOne(fetch=FetchType.LAZY)
	@JoinColumn(name="pid")
	public T getParent() {
		return parent;
	}

	public void setParent(T parent) {
		if (parent != null && !((Page)parent).isNew()) {
			this.parent = parent;
			this.parentId = ((Page)parent).getId();			
		}
	}	
	
	@Column(nullable=false)
	public Long getParentId() {
		return parentId;
	}

	public void setParentId(Long parentId) {
		this.parentId = parentId;
	}

	@Column(nullable=false)
	public Long getRootId() {
		return rootId;
	}

	public void setRootId(Long rootId) {
		this.rootId = rootId;
	}

	@Column(nullable=false)
	public int getPageLevel() {
		return pageLevel;
	}

	public void setPageLevel(int pageLevel) {
		this.pageLevel = pageLevel;
	}

	@Column(nullable=false)
	public int getApproveLevel() {
		return approveLevel;
	}

	public void setApproveLevel(int approveLevel) {
		this.approveLevel = approveLevel;
	}

	@Column(nullable=false, name="rel")//must rename the column name form 'release' to 'rel', as 'release' is mysql keyword
	public int getRelease() {
		return release;
	}

	public void setRelease(int release) {
		this.release = release;
	}

	@Column(nullable=false)
	public int getEdit() {
		return edit;
	}

	public void setEdit(int edit) {
		this.edit = edit;
	}

	@Column(nullable=false)
	public String getTemplate() {
		return template;
	}

	public void setTemplate(String template) {
		this.template = template;
	}
	
	@Enumerated(EnumType.STRING)
	@Column(nullable=false)
	public PageStatus getStatus() {
		return status;
	}

	public void setStatus(PageStatus status) {
		this.status = status;
	}

	@Column(nullable=false)
	public boolean isActive() {
		return active;
	}

	public void setActive(boolean active) {
		this.active = active;
	}

	@Column(nullable=false, name="del")//must rename the column name form 'delete' to 'del', as 'delete' is mysql keyword
	public boolean isDelete() {
		return delete;
	}

	public void setDelete(boolean delete) {
		this.delete = delete;
	}

	@Column(nullable=false)
	public boolean isReqDelete() {
		return reqDelete;
	}

	public void setReqDelete(boolean reqDelete) {
		this.reqDelete = reqDelete;
	}

	@Temporal(TemporalType.TIMESTAMP)
	public Date getPublishTime() {
		return publishTime;
	}

	public void setPublishTime(Date publishTime) {
		this.publishTime = publishTime;
	}

	@Temporal(TemporalType.TIMESTAMP)
	public Date getExpireTime() {
		return expireTime;
	}

	public void setExpireTime(Date expireTime) {
		this.expireTime = expireTime;
	}

	@Column(nullable=false)
	public boolean isNeverExpire() {
		return neverExpire;
	}

	public void setNeverExpire(boolean neverExpire) {
		this.neverExpire = neverExpire;
	}

	@Temporal(TemporalType.TIMESTAMP)
	public Date getPageTimeFrom() {
		return pageTimeFrom;
	}

	public void setPageTimeFrom(Date pageTimeFrom) {
		this.pageTimeFrom = pageTimeFrom;
	}

	@Temporal(TemporalType.TIMESTAMP)
	public Date getPageTimeTo() {
		return pageTimeTo;
	}

	public void setPageTimeTo(Date pageTimeTo) {
		this.pageTimeTo = pageTimeTo;
	}

	public String getPageTimeDisplay() {
		return pageTimeDisplay;
	}

	public void setPageTimeDisplay(String pageTimeDisplay) {
		this.pageTimeDisplay = pageTimeDisplay;
	}

	@Column(nullable=false)
	public int getPageOrder() {
		return pageOrder;
	}

	public void setPageOrder(int pageOrder) {
		this.pageOrder = pageOrder;
	}

	@Column(nullable=false)
	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public String getUrl() {
		return StringUtils.isBlank(url) ? "" : url;
	}

	public void setUrl(String url) {
		this.url = url;
	}

	public String getCommonxml() {
		return commonxml;
	}

	public void setCommonxml(String commonxml) {
		this.commonxml = commonxml;
	}

	@Temporal(TemporalType.TIMESTAMP)
	@Column(nullable = false, updatable = false)
	public Date getCreateTime() {
		return createTime;
	}

	public void setCreateTime(Date createTime) {
		this.createTime = createTime;
	}

	@Temporal(TemporalType.TIMESTAMP)
	// The column type in mysql will be DATETIME, should use columnDefinition to limit it to TIMESTAMP to make it auto updatable
	@Column(nullable=false, insertable = false, updatable = false, columnDefinition="TIMESTAMP")  
	@Generated(GenerationTime.ALWAYS)
	public Date getUpdateTime() {
		return updateTime;
	}

	public void setUpdateTime(Date updateTime) {
		this.updateTime = updateTime;
	}

	@OneToMany(mappedBy="page")
	public Set<E> getContents() {
		return contents;
	}

	public void setContents(Set<E> contents) {
		this.contents = contents;
	}

	@OneToMany(mappedBy="parent")
	@OrderBy("pageOrder asc")
	public Set<T> getChildren() {
		return children;
	}

	public void setChildren(Set<T> children) {
		this.children = children;
	}

	@Transient
	public List<T> getChildren(boolean isDelete) {
		List<T> elements = new ArrayList<T>();
		for(T page : this.children) {
			if(((Page)page).isDelete()== isDelete) {
				elements.add(page);
			}
		}
		Collections.sort(elements, new Comparator<T>() {
			@Override
			public int compare(T o1, T o2) {
				return ((Page)o1).getPageOrder() - ((Page)o2).getPageOrder();
			}
		});
		return elements;
	}
	
	@Transient
	public boolean isHideSubTpl() {
		return CmsProperties.isHideSubTpl(this.template);
	}
	
	@Transient
	public boolean isExcTpl() {
		return CmsProperties.isExcTpl(this.template);
	}
	
	@Transient
	public boolean isNoPreviewTpl() {
		return CmsProperties.isNoPreviewTpl(this.template);
	}
	
	@Transient
	public boolean isNoContentTpl() {
		return CmsProperties.isNoContentTpl(this.template);
	}
	
	@Transient
	public boolean isNew() {
		return this.getId() == null || this.getId() <= 0;
	}
	
	@Transient
	public boolean isHomePage() {
		return this.getTemplate().equals(HOME_PAGE_TEMPLATE);
	}
	
	@Transient
	public boolean isMasterPage() {
		return this.getTemplate().equals(MASTER_PAGE_TEMPLATE);
	}
	
	public void increateEdit() {
		this.edit++;
	}
	
	public void increateRelease() {
		this.release++;
	}
	
	@Transient
	public String getUrlPath() {
		StringBuffer sb = new StringBuffer("/");
		Long pid = this.getParent() == null ? null : ((Page)this.getParent()).getId();
		if (pid != null) {
			if(pid == MASTER_PAGE_PARENT_ID) return "/Footer/";
			if(pid == OTHER_PAGE_PARENT_ID) return "/Others/";
			Page page = (Page)this.getParent();
			while(pid > 0) {
				sb.insert(0, "/" + page.getUrl());
				page = (Page)page.getParent();
				pid = page == null || page.getParent() == null ? 0 : ((Page)page.getParent()).getId();
			}
		}
		return sb.toString();
	}
	
	public E getContent(Lang lang) {
		for(E c : this.getContents()) {
			if(((Content)c).getLang().equals(lang))
				return c;
		}
		if(this instanceof CmsPage) return (E)new CmsContent();
		if(this instanceof LivePage) return (E)new LiveContent();
		return null;
	}
	
	public E getContent(String lang) {		
		return getContent(Lang.getByName(lang));
	}
	
	public boolean hasPublished() {
		return this.release > 0;
	}
	
	@Transient
	public String getPageUrl() //the page's url without .html, it use for locate the page using user's url typing on the browser 
    {
        if (!this.isNew())
        {
            StringBuilder sb = new StringBuilder(this.url);
            if ("Sector".equals(this.template) || "TopSector".equals(this.template)) sb.append("/");
            
            if (Global.fixUrlPrefix.containsKey(this.parentId))
            {
                sb.insert(0, Global.fixUrlPrefix.get(this.parentId));
                return sb.toString();
            }
            else
            {
            	Page page = this;
            	while(page.getParent() != null) {
            		page = page.getParent();
            		sb.insert(0, page.getUrl() + "/");
            	}                
                return sb.toString();
            }

        }
        return "";
    }
	
	public static final long MASTER_PAGE_PARENT_ID = -2;
	public static final long HOME_PAGE_PARENT_ID = -1;
	public static final long OTHER_PAGE_PARENT_ID = -3;
	
	public static final String MASTER_PAGE_TEMPLATE = "Masterpage";
	public static final String HOME_PAGE_TEMPLATE = "Homepage";	
	
	public void initNewPage(CmsPage parent) {
		this.initNewPage(parent, false);
	}
	public void initNewPage(CmsPage parent, boolean newAtFront) {		
		Long parentId = parent.getId();	// the id for the parent have already been set before calling this method	
		this.parentId = parentId;
        if (parentId == HOME_PAGE_PARENT_ID) {
            this.rootId = HOME_PAGE_PARENT_ID;            
            this.template = HOME_PAGE_TEMPLATE;
            this.name = HOME_PAGE_TEMPLATE;
            this.url = "index";
        } else if (parentId == MASTER_PAGE_PARENT_ID) {
            this.rootId = MASTER_PAGE_PARENT_ID;
            this.template = MASTER_PAGE_TEMPLATE;
            this.name = MASTER_PAGE_TEMPLATE;
        } else if (parentId < 0) {
            this.rootId = parentId;
        } else if (!parent.isNew()) {
            this.rootId = parent.getRootId();
            this.pageLevel = parent.getPageLevel() + 1;
        } else {
            this.pageLevel = 1;
        }
        if (newAtFront || parent.isNew()) {
        	this.pageOrder = 1;
        } else {
        	int max = 0;
        	for(Page page : parent.getChildren(false)) {
        		max = Math.max(max, page.getPageOrder());
        	}
        	this.pageOrder = max + 1;
        }
	}
	
	public void copyFrom(Page o) {
		this.parentId = o.getParentId();
		this.rootId = o.getRootId();
		this.pageLevel = o.getPageLevel();
		this.release = o.getRelease();
		this.edit = o.getEdit();
		this.template = o.getTemplate();
		this.status = o.getStatus();
		this.active = o.isActive();
		this.delete = o.isDelete();
		this.publishTime = o.getPublishTime();
		this.expireTime = o.getExpireTime();
		this.neverExpire = o.isNeverExpire();
		this.pageTimeFrom = o.getPageTimeFrom();
		this.pageTimeTo = o.getPageTimeTo();
		this.pageTimeDisplay = o.getPageTimeDisplay();
		this.pageOrder = o.getPageOrder();
		this.name = o.getName();
		this.url = o.getUrl();
		this.commonxml = o.getCommonxml();
	}
	
}
