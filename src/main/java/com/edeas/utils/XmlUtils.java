package com.edeas.utils;

import java.io.ByteArrayInputStream;
import java.io.File;
import java.io.IOException;
import java.io.StringWriter;
import java.io.UnsupportedEncodingException;
import java.lang.reflect.InvocationTargetException;
import java.util.HashMap;
import java.util.Map;

import org.apache.commons.beanutils.BeanUtils;
import org.apache.commons.lang3.StringUtils;
import org.dom4j.Document;
import org.dom4j.DocumentException;
import org.dom4j.Element;
import org.dom4j.Node;
import org.dom4j.io.OutputFormat;
import org.dom4j.io.SAXReader;
import org.dom4j.io.XMLWriter;

import com.edeas.dwr.SchemaInfo;

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
			return saxReader.read(new ByteArrayInputStream(xml.getBytes("UTF-8")));
		} catch (DocumentException e) {			
		} catch (UnsupportedEncodingException e) {
		}		
		return null;
	}
	
	public static SchemaInfo getSchemaInfo(Element fieldSchema, Element widgetSchema)
    {
		SchemaInfo schemaInfo = new SchemaInfo();
        
        // attribute set on field
        schemaInfo.setName(getFieldAttr(fieldSchema, "name"));
        schemaInfo.setType(getFieldAttr(fieldSchema, "type"));
        
        //attribute set on widget
        Map<String, String> map = new HashMap<String, String>();
        map.put("label", "label");
        map.put("style", "style");
        map.put("attr", "attribute");
        map.put("default", "defaultValue");
        map.put("remark", "remark");
        try {
	        for(String tag : map.keySet()) {
	        	String value = getFieldAttr(fieldSchema, tag);
	        	String wValue = XmlUtils.getFieldAttr(widgetSchema, schemaInfo.getName() + tag.substring(0, 1).toUpperCase() + tag.substring(1));
					BeanUtils.setProperty(schemaInfo, map.get(tag), StringUtils.isBlank(wValue) ? value : wValue);
	        }
        } catch (IllegalAccessException | InvocationTargetException e) {
        	return null;
        }
        return schemaInfo;
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
	
	public static String formatXml(Document document) {
		OutputFormat format = OutputFormat.createPrettyPrint();
		format.setEncoding("utf-8");
		StringWriter sw = new StringWriter();
		XMLWriter xw = new XMLWriter(sw, format);
		xw.setEscapeText(false);
		try {
			xw.write(document);
			xw.flush();
			xw.close();
		} catch (IOException e) {			
		}
		return sw.toString();
	}
	
	public static String toCDATA(String src) {
		return "<![CDATA[" + src + "]]>";
	}
}
