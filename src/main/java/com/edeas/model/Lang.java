package com.edeas.model;

import java.util.Arrays;
import java.util.Comparator;
import java.util.List;

public enum Lang {
	en("en", "English", 1), tc("tc", "繁體", 2), sc("sc", "简体", 3);
	
	private String name;
	private String description;
	private int order;
	
	Lang(String name, String description, int order) {
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

	public int getOrder() {
		return order;
	}

	public void setOrder(int order) {
		this.order = order;
	}
	
	public static Lang getByName(String name) {
		for (Lang lang : Lang.values()) {
			if (lang.getName().equals(name))
				return lang;
		}
		return null;
	}
	
	public static boolean exists(String name) {
		return getByName(name) != null;
	}
	
	public static List<Lang> orderList() {		
		List<Lang> orderList = Arrays.asList(Lang.values());
		orderList.sort(new Comparator<Lang>() {
			@Override
			public int compare(Lang o1, Lang o2) {
				return ((Integer)o1.getOrder()).compareTo(o2.getOrder());
			}
			
		});
		return orderList;
	}
}
