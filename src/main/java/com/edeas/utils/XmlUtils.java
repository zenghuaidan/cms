package com.edeas.utils;

import java.io.File;
import java.util.Dictionary;
import java.util.HashMap;
import java.util.Map;

import org.apache.commons.lang3.StringUtils;
import org.dom4j.Document;
import org.dom4j.DocumentException;
import org.dom4j.Element;
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
	
	public static Document loadFromString(String xml) {
		try {
			SAXReader saxReader = new SAXReader();    
			return saxReader.read(xml);
		} catch (DocumentException e) {			
		}		
		return null;
	}
	
	public static Map<String, String> getSchemaInfo(Element fieldSchema, Element widgetSchema)
    {
        Map<String, String> r = new HashMap<String, String>();
        String fname = getFieldAttr(fieldSchema, "name");
        r.put("fname", fname);
        r.put("ftype", getFieldAttr(fieldSchema, "type"));                   
        
        for(String tag : new String[]{"label","style","attr","default","remark"}) {
        	String value = getFieldAttr(fieldSchema, tag);
        	String wValue = XmlUtils.getFieldAttr(widgetSchema, fname + tag.substring(0, 1).toUpperCase() + tag.substring(1));
        	r.put("f" + tag, StringUtils.isBlank(wValue) ? value : wValue);        
        }
        
        return r;
    }
	
	public static String getFieldRaw(Element w, String fieldname)
    {
		Element fnode = (w == null) ? null : (Element)w.selectSingleNode("Field[@name='" + fieldname + "']");
        return (fnode == null) ? "" : fnode.getTextTrim();
    }
	
	public static String getWidgetFieldAttr(Element w, String fieldname, String attrname)
    {
		Element fnode = (w == null) ? null : (Element)w.selectSingleNode("Field[@name='" + fieldname + "']");
        return getFieldAttr(fnode, attrname);
    }
	
	public static String getFieldAttr(Element fnode, String attrname)
    {
        return (fnode == null) ? "" : fnode.attributeValue(attrname, "");
    }
}
