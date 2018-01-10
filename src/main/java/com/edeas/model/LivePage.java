package com.edeas.model;

import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.Id;
import javax.persistence.Inheritance;
import javax.persistence.InheritanceType;
import javax.persistence.JoinColumn;
import javax.persistence.OneToOne;
import javax.persistence.Table;

import org.hibernate.annotations.Parameter;

@Entity
@Inheritance(strategy = InheritanceType.SINGLE_TABLE)
@Table(name="LivePage")
public class LivePage extends Page<LivePage, LiveContent> {
	private Long id;
	private CmsPage cmsPage;
	
    @Id  
    @GeneratedValue(generator="pageForeignGenerator")  
    @org.hibernate.annotations.GenericGenerator(name="pageForeignGenerator",  
            strategy="foreign",  
            parameters=@Parameter(name="property",value="cmsPage"))
	public Long getId() {
		return this.id;
	}

	public void setId(Long id) {
		this.id = id;
	}

	@OneToOne
	@JoinColumn(name="id", unique=true, nullable=false, updatable=false)
	public CmsPage getCmsPage() {
		return cmsPage;
	}

	public void setCmsPage(CmsPage cmsPage) {
		this.cmsPage = cmsPage;
	}
    
}
