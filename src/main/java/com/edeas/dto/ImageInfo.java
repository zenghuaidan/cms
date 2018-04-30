package com.edeas.dto;

import java.io.File;

public class ImageInfo {
	private File image;
	private String alt;
	private String caption;

	public ImageInfo(File image, String alt, String caption) {
		this.image = image;
		this.alt = alt;
		this.caption = caption;
	}

	public File getImage() {
		return image;
	}

	public void setImage(File image) {
		this.image = image;
	}

	public String getAlt() {
		return alt;
	}

	public void setAlt(String alt) {
		this.alt = alt;
	}

	public String getCaption() {
		return caption;
	}

	public void setCaption(String caption) {
		this.caption = caption;
	}

}
