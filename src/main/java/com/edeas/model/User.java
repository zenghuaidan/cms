package com.edeas.model;

import java.util.Date;

public class User {
	private int id;
	private String login;
	private String password;
	private String email;
	private String firstName;
	private String lastName;
	private boolean active;
	private int numFail;
	private Date lastFailTime;
	private Date createTime;
	private Date updateTime;
}
