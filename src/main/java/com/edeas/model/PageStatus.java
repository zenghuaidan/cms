package com.edeas.model;

public enum PageStatus {
	NEW("new"), EDIT("edit"), WAIT("wait"), DECLINED("declined"), LIVE("live");
	
	private String name;
	
	PageStatus(String name) {
		this.setName(name);
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}
	
	
}
