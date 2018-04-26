package com.edeas.model;

import java.util.Date;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.Id;
import javax.persistence.Table;
import javax.persistence.Temporal;
import javax.persistence.TemporalType;

import org.hibernate.annotations.Generated;
import org.hibernate.annotations.GenerationTime;
import org.hibernate.annotations.GenericGenerator;

@Entity
@Table(name = "Category")
public class Category {
	private Long id;
	private String nameEN;
	private String nameTC;
	private String nameSC;
	private String kind;
	private int corder;
	private Date createTime = new Date();
	private Date updateTime;

	@Id
	@GeneratedValue(generator = "incrementGenerator")
	@GenericGenerator(name = "incrementGenerator", strategy = "increment")
	public Long getId() {
		return id;
	}

	public void setId(Long id) {
		this.id = id;
	}

	public String getNameEN() {
		return nameEN;
	}

	public void setNameEN(String nameEN) {
		this.nameEN = nameEN;
	}

	public String getNameTC() {
		return nameTC;
	}

	public void setNameTC(String nameTC) {
		this.nameTC = nameTC;
	}

	public String getNameSC() {
		return nameSC;
	}

	public void setNameSC(String nameSC) {
		this.nameSC = nameSC;
	}

	public String getKind() {
		return kind;
	}

	public void setKind(String kind) {
		this.kind = kind;
	}

	public int getCorder() {
		return corder;
	}

	public void setCorder(int corder) {
		this.corder = corder;
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
