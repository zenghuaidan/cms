package com.edeas.model;


import java.nio.charset.Charset;
import java.util.Date;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.Table;
import javax.persistence.Temporal;
import javax.persistence.TemporalType;
import javax.persistence.Transient;

import org.hibernate.annotations.Generated;
import org.hibernate.annotations.GenerationTime;

import com.edeas.utils.MessageDigestUtils;

@Entity
@Table(name = "CmsUser")
public class User {
	private Long id;
	private String login;
	private String password;
	private String email;
	private String firstName;
	private String lastName;
	private boolean active = true;
	private int numFail;
	private Date lastFailTime;
	private Date createTime = new Date();
	private Date updateTime;
	
//INSERT INTO `db_larry_java_cms`.`CmsUser` (`id`, `active`, `createTime`, `email`, `firstName`, `lastFailTime`, `lastName`, `login`, `numFail`, `password`, `updateTime`) VALUES (1, '1', '2018-01-05', 'larry.zeng@edeas.hk', 'larry', '2018-01-05', 'zeng', 'larry', '0', '3HJK8Y+91OWRifX+dopfgxFScFA=', '2018-01-05');
	@Id
	public Long getId() {
		return id;
	}

	public void setId(Long id) {
		this.id = id;
	}

	@Column(nullable=false)
	public String getLogin() {
		return login;
	}

	public void setLogin(String login) {
		this.login = login;
	}

	@Column(nullable=false)
	public String getPassword() {
		return password;
	}

	public void setPassword(String password) {
		this.password = password;
	}

	@Column(nullable=false)
	public String getEmail() {
		return email;
	}

	public void setEmail(String email) {
		this.email = email;
	}

	public String getFirstName() {
		return firstName;
	}

	public void setFirstName(String firstName) {
		this.firstName = firstName;
	}

	public String getLastName() {
		return lastName;
	}

	public void setLastName(String lastName) {
		this.lastName = lastName;
	}

	@Column(nullable=false)
	public boolean isActive() {
		return active;
	}

	public void setActive(boolean active) {
		this.active = active;
	}

	@Column(nullable=false)
	public int getNumFail() {
		return numFail;
	}

	public void setNumFail(int numFail) {
		this.numFail = numFail;
	}

	@Temporal(TemporalType.TIMESTAMP)
	public Date getLastFailTime() {
		return lastFailTime;
	}

	public void setLastFailTime(Date lastFailTime) {
		this.lastFailTime = lastFailTime;
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
	
//	今天做项目的时候想在一个实体类中添加一个属性，不去关联实体类对应的表的任何字段。
//	但是发现按照网上的怎么做都不成功，最后找到了原因。
//	@Transient 在 import的时候要注意引用的是 javax.persistence这个包下的
//	而不是其他的包。我之前一直引用的SpringFramework包的那个注解。
//	而且还需要注意的是这个注解要加在属性的get方法上。
	@Transient
	public String getName() {
		return this.firstName + this.lastName;
	}
	
	@Transient
	public static String getEncryptPassword(String password) {
		try {
			return MessageDigestUtils.encryptBASE64(MessageDigestUtils.encryptSHA(password.getBytes(Charset.forName("utf-8"))));
		} catch (Exception e) {
		}
		return "";
	}
}
