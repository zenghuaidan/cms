package com.edeas.utils;

import java.io.File;

import org.dom4j.Document;
import org.dom4j.DocumentException;
import org.dom4j.Node;
import org.dom4j.io.SAXReader;

public class XmlUtils {
	public static Node selectNodes(Document doc, String xpath) {
		return doc.selectSingleNode(xpath);		
	}
	
	public static Document toDocument(String filePath) {
		try {
			SAXReader saxReader = new SAXReader();    
			return saxReader.read(new File(filePath));
		} catch (DocumentException e) {			
		}		
		return null;
	}
	
	public static Document getTemplateListDocument() {
		String filePath = XmlUtils.class.getClassLoader().getResource("TemplateList.xml").getPath();
		return toDocument(filePath);
	}
	
	public static Document getTemplateDocument(String template) {
		String filePath = XmlUtils.class.getClassLoader().getResource("Templates/" + template + ".xml").getPath();
		return toDocument(filePath);
	}
	
	public static Document getStringDocument(String xml) {
		try {
			SAXReader saxReader = new SAXReader();    
			return saxReader.read(xml);
		} catch (DocumentException e) {			
		}		
		return null;
	}
}
