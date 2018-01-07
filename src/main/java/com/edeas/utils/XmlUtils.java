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
        String fname = fieldSchema.attributeValue("name");
        r.put("fname",fname);
        r.put("ftype", fieldSchema.attributeValue("type"));
        
        String label = fieldSchema.attributeValue("label", "");
        if (widgetSchema != null && !StringUtils.isBlank(widgetSchema.attributeValue(fname + "Label"))) { label = widgetSchema.attributeValue(fname + "Label"); }
        r.put("flabel", label);
        
        String style = fieldSchema.attributeValue("style", "");
        if (widgetSchema != null && !StringUtils.isBlank(widgetSchema.attributeValue(fname + "Style"))) { style = widgetSchema.attributeValue(fname + "Style"); }        
        r.put("fstyle", style);
        
        String attr = fieldSchema.attributeValue("attr", "");
        if (widgetSchema != null && !StringUtils.isBlank(widgetSchema.attributeValue(fname + "Attr"))) { attr = widgetSchema.attributeValue(fname + "Attr"); }        
        r.put("fattr", attr);
        
        String defval = fieldSchema.attributeValue("default", "");
        if (widgetSchema != null && !StringUtils.isBlank(widgetSchema.attributeValue(fname + "Default"))) { defval = widgetSchema.attributeValue(fname + "Default"); }        
        r.put("fdefval", defval);
        
        String remark = fieldSchema.attributeValue("remark", "");
        if (widgetSchema != null && !StringUtils.isBlank(widgetSchema.attributeValue(fname + "Remark"))) { remark = widgetSchema.attributeValue(fname + "Remark"); }
        r.put("fremark", remark);
        return r;
    }
	
	public static String getFieldRaw(Element w, String fieldname)
    {
		Element fnode = (w == null) ? null : (Element)w.selectSingleNode("Field[@name='" + fieldname + "']");
        return (fnode == null) ? "" : fnode.getTextTrim();
    }
}
