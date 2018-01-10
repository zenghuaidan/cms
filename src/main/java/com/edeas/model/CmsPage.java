package com.edeas.model;

import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.Inheritance;
import javax.persistence.InheritanceType;
import javax.persistence.Table;
import javax.persistence.TableGenerator;

@Entity
@Inheritance(strategy = InheritanceType.SINGLE_TABLE)
@Table(name="CmsPage")
public class CmsPage extends Page<CmsPage, CmsContent> {
	private Long id;
	
	@Id
	@GeneratedValue(strategy=GenerationType.TABLE,generator="pageTableGenerator")
	@TableGenerator(name="pageTableGenerator",initialValue=1,allocationSize=1) 
	public Long getId() {
		return this.id;
	}

	public void setId(Long id) {
		this.id = id;
	}
}
