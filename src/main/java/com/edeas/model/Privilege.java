package com.edeas.model;

import java.util.Arrays;
import java.util.Comparator;
import java.util.List;

public enum Privilege {
	editor("ed", "Editor", false, true, 1), publisher("pb", "Publisher", true, false, 2);
	
	private String name;
	private String description;
	private boolean publish;
	private boolean edit;
	private int order;
	
	Privilege(String name, String description, boolean publish, boolean edit, int order) {
		this.setName(name);
		this.setDescription(description);
		this.setOrder(order);
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public String getDescription() {
		return description;
	}

	public void setDescription(String description) {
		this.description = description;
	}

	public boolean isPublish() {
		return publish;
	}

	public void setPublish(boolean publish) {
		this.publish = publish;
	}

	public boolean isEdit() {
		return edit;
	}

	public void setEdit(boolean edit) {
		this.edit = edit;
	}

	public int getOrder() {
		return order;
	}

	public void setOrder(int order) {
		this.order = order;
	}
	
	public static Privilege getByName(String name) {
		for (Privilege lang : Privilege.values()) {
			if (lang.getName().equals(name))
				return lang;
		}
		return null;
	}
	
	public static boolean exists(String name) {
		return getByName(name) != null;
	}
	
	public static List<Privilege> orderList() {		
		List<Privilege> orderList = Arrays.asList(Privilege.values());
		orderList.sort(new Comparator<Privilege>() {
			@Override
			public int compare(Privilege o1, Privilege o2) {
				return ((Integer)o1.getOrder()).compareTo(o2.getOrder());
			}
			
		});
		return orderList;
	}
}
