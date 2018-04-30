package com.edeas.dwr;

import org.apache.commons.lang3.StringUtils;

public class SchemaInfo {
	private String name;
	private String type;
	private String label;
	private String style;
	private String attribute;
	private String defaultValue;
	private String remark;

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public String getType() {
		return type;
	}

	public void setType(String type) {
		this.type = type;
	}

	public String getLabel() {
		return label;
	}

	public void setLabel(String label) {
		this.label = label;
	}

	public String getStyle() {
		return style;
	}

	public void setStyle(String style) {
		this.style = style;
	}

	public String getAttribute() {
		return attribute;
	}

	public void setAttribute(String attribute) {
		this.attribute = attribute;
	}

	public String getDefaultValue() {
		return defaultValue;
	}

	public void setDefaultValue(String defaultValue) {
		this.defaultValue = defaultValue;
	}

	public String getRemark() {
		return remark;
	}

	public void setRemark(String remark) {
		this.remark = remark;
	}
	
	public boolean canZipUpload() {		
		if (!StringUtils.isBlank(attribute))
		{
			String[] ra = attribute.split(",");
			for (String r : ra) {
				String[] _ra = r.split(":");
				if (_ra[0].equals("zipUpload")) {
					return _ra[1].toLowerCase().equals("yes");
				}
			}
		}
		return false;
	}

}
