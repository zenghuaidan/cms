package com.edeas.model;

import javax.persistence.Column;
import javax.persistence.FetchType;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.MappedSuperclass;
import javax.persistence.TableGenerator;

@MappedSuperclass
public class Content<T> {
	private Long id;
	private T page;
	private String lang;
	private String propertyXml;
	private String contentXm;

	@Id
	@GeneratedValue(strategy=GenerationType.TABLE,generator="contentTableGenerator")
	@TableGenerator(name="contentTableGenerator",initialValue=1,allocationSize=1)
	public Long getId() {
		return id;
	}

	public void setId(Long id) {
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
