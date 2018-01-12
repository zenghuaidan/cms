package com.edeas.model;

import javax.persistence.Basic;
import javax.persistence.Column;
import javax.persistence.EnumType;
import javax.persistence.Enumerated;
import javax.persistence.FetchType;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.Lob;
import javax.persistence.ManyToOne;
import javax.persistence.MappedSuperclass;
import javax.persistence.TableGenerator;
import javax.persistence.Transient;

import org.apache.commons.lang3.StringUtils;
import org.dom4j.Document;

import com.edeas.utils.XmlUtils;

@MappedSuperclass
public class Content<T extends Page> {
	private Long id;
	private T page;
	private Lang lang;
	private String propertyXml;
	private String contentXml;

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

	@Enumerated(EnumType.STRING)
	@Column(nullable=false)
	public Lang getLang() {
		return lang;
	}

	public void setLang(Lang lang) {
		this.lang = lang;
	}
	
	@Lob
	@Basic(fetch = FetchType.LAZY)
	//@Column(length=65535) //Hibernate会默认对应到MySQL的Text上去。Text是有65535字节限制的。
	//@Column(length = 16777215) //Hibernate会对应到MySQL的MeduimText上去。MedumnText最大16777215字节。
	//@Column(length = 2147483647) //Hibernate会对应到MySQL的LongText上去。LongText最大2147483647字节
	//以上三个注释点不起左右，而是用了LONGTEXT
	public String getPropertyXml() {
		return StringUtils.isBlank(propertyXml) ? getDefaultContentXml() : propertyXml;
	}

	public void setPropertyXml(String propertyXml) {
		this.propertyXml = propertyXml;
	}

	@Lob
	@Basic(fetch = FetchType.LAZY)
	@Column(length=65535)//不起左右，而是用了LONGTEXT
	public String getContentXml() {
		return StringUtils.isBlank(contentXml) ? getDefaultContentXml() : contentXml;
	}

	public void setContentXml(String contentXml) {
		this.contentXml = contentXml;
	}

	@Transient
	public boolean isNew() {
		return this.getId() == null || this.getId() <= 0;
	}
	
	@Transient
	public Document getPropertyXmlDoc() {
		return XmlUtils.loadFromString(getPropertyXml());
	}
	
	@Transient
	public Document getContentXmlDoc() {
		return XmlUtils.loadFromString(getContentXml());
	}
	
	public void init(T page, Lang lang) {
		if(this.isNew()) {
			this.page = page;
			this.lang = lang;
		}
		if (StringUtils.isBlank(this.propertyXml))
			this.propertyXml = getDefaultPropertyXml();
		if(StringUtils.isBlank(this.contentXml))
			this.contentXml = getDefaultContentXml();
	}
	
	@Transient
	public String getDefaultPropertyXml() {
		return "<?xml version=\"1.0\" encoding=\"utf-8\" ?><Properties pageid='" + ((Page)page).getId() + "' lang='" + lang + "' />";
	}
	
	@Transient
	public String getDefaultContentXml() {
		return "<?xml version=\"1.0\" encoding=\"utf-8\" ?><PageContent pageid='" + ((Page)page).getId() + "' lang='" + lang + "' template='" + page.getTemplate() + "' />";
	}
	
	public void copyFrom(Content content) {
		this.lang = content.getLang();
		this.propertyXml = content.getPropertyXml();
		this.contentXml = content.getContentXml();
	}
}
