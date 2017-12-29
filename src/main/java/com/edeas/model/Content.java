package com.edeas.model;

import javax.persistence.Column;
import javax.persistence.FetchType;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.MappedSuperclass;

@MappedSuperclass
public class Content<T> {
	private int id;
	private T page;
	private String lang;
	private String propertyXml;
	private String contentXm;

	@Id
	public int getId() {
		return id;
	}

	public void setId(int id) {
		this.id = id;
	}
	
	@ManyToOne(fetch=FetchType.LAZY)
	@JoinColumn(name="pageId")
	public T getPage() {
		return page;
	}

	public void setPage(T page) {
		this.page = page;
	}

	@Column(nullable=false)
	public String getLang() {
		return lang;
	}

	public void setLang(String lang) {
		this.lang = lang;
	}

	public String getPropertyXml() {
		return propertyXml;
	}

	public void setPropertyXml(String propertyXml) {
		this.propertyXml = propertyXml;
	}

	public String getContentXm() {
		return contentXm;
	}

	public void setContentXm(String contentXm) {
		this.contentXm = contentXm;
	}

}
