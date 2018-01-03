package com.edeas.model;

import java.util.Date;
import java.util.HashSet;
import java.util.Set;

import javax.persistence.Column;
import javax.persistence.EnumType;
import javax.persistence.Enumerated;
import javax.persistence.FetchType;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.MappedSuperclass;
import javax.persistence.OneToMany;
import javax.persistence.OrderBy;
import javax.persistence.Temporal;
import javax.persistence.TemporalType;
import javax.persistence.Transient;

import org.hibernate.annotations.Generated;
import org.hibernate.annotations.GenerationTime;

import com.edeas.controller.cmsadmin.CmsProperties;

@MappedSuperclass
public class Page<T, E> {
	private long id;
	private T parent;
	private int rootId;
	private int pageLevel;
	private int release;
	private int edit;
	private String template;
	private PageStatus status;
	private boolean active;
	private boolean delete;
	private boolean reqDelete;
	private Date publishTime;
	private Date expireTime;
	private boolean neverExpire;
	private Date pageTimeFrom;
	private Date pageTimeTo;
	private String pageTimeDisplay;
	private int pageOrder;
	private String name;
	private String url;
	private String commonxml;
	private Date createTime;
	private Date updateTime;
	private Set<E> contents = new HashSet<E>();
	private Set<T> children = new HashSet<T>();

	@Id
	public long getId() {
		return id;
	}

	public void setId(long id) {
		this.id = id;
	}	

	@ManyToOne(fetch=FetchType.LAZY)
	@JoinColumn(name="pid")
	public T getParent() {
		return parent;
	}

	public void setParent(T parent) {
		this.parent = parent;
	}

	@Column(nullable=false)
	public int getRootId() {
		return rootId;
	}

	public void setRootId(int rootId) {
		this.rootId = rootId;
	}

	@Column(nullable=false)
	public int getPageLevel() {
		return pageLevel;
	}

	public void setPageLevel(int pageLevel) {
		this.pageLevel = pageLevel;
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

	@Column(nullable=false)
	public String getUrl() {
		return url;
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
	public Set<T> getChildren(boolean isDelete) {
		Set<T> elements = new HashSet<T>();
		for(T page : this.children) {
			if(((Page)page).isDelete()== isDelete) {
				elements.add(page);
			}
		}
		return elements;
	}
	
	@Transient
	public boolean isHideSubTpl() {
		return CmsProperties.getHideSubTpls().contains(this.template);
	}
	
	@Transient
	public boolean isExcTpl() {
		return CmsProperties.getExcTpls().contains(this.template);
	}
}
