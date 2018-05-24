package com.edeas.model;


import java.io.Serializable;
import java.util.Date;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.GeneratedValue;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.Table;
import javax.persistence.Temporal;
import javax.persistence.TemporalType;

import org.hibernate.annotations.Generated;
import org.hibernate.annotations.GenerationTime;
import org.hibernate.annotations.GenericGenerator;

@Entity
@Table(name = "WorkflowMsg")
public class WorkflowMsg implements Serializable {
	private static final long serialVersionUID = -5051085506032468813L;
	private Long id;
	private User user;
	private CmsPage cmsPage;
	private int release;
	private int edit;
	private boolean publishRequest;
	private boolean declineRequest;
	private boolean acceptRequest;
	private String message;	
	private Date createTime = new Date();
	private Date updateTime;	
	
	public WorkflowMsg() {		
	}
	
	public WorkflowMsg(User user, CmsPage cmsPage, int release, int edit, boolean publishRequest,
			boolean declineRequest, boolean acceptRequest, String message) {
		super();
		this.user = user;
		this.cmsPage = cmsPage;
		this.release = release;
		this.edit = edit;
		this.publishRequest = publishRequest;
		this.declineRequest = declineRequest;
		this.acceptRequest = acceptRequest;
		this.message = message;
	}

	@Id
	@GeneratedValue(generator = "incrementGenerator") 
	@GenericGenerator(name = "incrementGenerator", strategy = "increment")
	public Long getId() {
		return id;
	}

	public void setId(Long id) {
		this.id = id;
	}

	@ManyToOne(fetch=FetchType.LAZY)
	@JoinColumn(name="userid")
	public User getUser() {
		return user;
	}

	public void setUser(User user) {
		this.user = user;
	}

	@ManyToOne(fetch=FetchType.LAZY)
	@JoinColumn(name="pageid")
	public CmsPage getCmsPage() {
		return cmsPage;
	}

	public void setCmsPage(CmsPage cmsPage) {
		this.cmsPage = cmsPage;
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

	public boolean isPublishRequest() {
		return publishRequest;
	}

	public void setPublishRequest(boolean publishRequest) {
		this.publishRequest = publishRequest;
	}

	public boolean isDeclineRequest() {
		return declineRequest;
	}

	public void setDeclineRequest(boolean declineRequest) {
		this.declineRequest = declineRequest;
	}

	public boolean isAcceptRequest() {
		return acceptRequest;
	}

	public void setAcceptRequest(boolean acceptRequest) {
		this.acceptRequest = acceptRequest;
	}

	public String getMessage() {
		return message;
	}

	public void setMessage(String message) {
		this.message = message;
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
}
