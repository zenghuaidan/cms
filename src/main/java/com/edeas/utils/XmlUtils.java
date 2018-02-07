package com.edeas.utils;

import java.io.ByteArrayInputStream;
import java.io.File;
import java.io.IOException;
import java.io.StringWriter;
import java.lang.reflect.InvocationTargetException;
import java.lang.reflect.Type;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.apache.commons.beanutils.BeanUtils;
import org.apache.commons.lang3.StringUtils;
import org.apache.log4j.Logger;
import org.dom4j.Document;
import org.dom4j.DocumentException;
import org.dom4j.Element;
import org.dom4j.Node;
import org.dom4j.io.OutputFormat;
import org.dom4j.io.SAXReader;
import org.dom4j.io.XMLWriter;

import com.edeas.controller.Global;
import com.edeas.controller.cmsadmin.CmsController;
import com.edeas.dto.LinkInfo;
import com.edeas.dwr.SchemaInfo;
import com.edeas.model.Content;
import com.edeas.model.Page;
import com.edeas.web.InitServlet;
import com.google.gson.Gson;
import com.google.gson.reflect.TypeToken;

public class XmlUtils {
	protected static final Logger logger = Logger.getLogger(CmsController.class);
	
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
	
	public static Document getWidgetListDocument() {
		String filePath = XmlUtils.class.getClassLoader().getResource("WidgetList.xml").getPath();
		return toDocument(filePath);
	}
	
	public static Document getTemplateDocument(String template) {
		try {
			String filePath = XmlUtils.class.getClassLoader().getResource("Templates/" + template + ".xml").getPath();
			return toDocument(filePath);			
		} catch (Exception e) {
			String templatePath = XmlUtils.class.getClassLoader().getResource("Templates").getPath();
			logger.error("Can not find template=" + template + " under path=" + templatePath);
		}
		return null;
	}
	
	public static Document loadFromString(String xml) {
		try {
			SAXReader saxReader = new SAXReader();    
			return saxReader.read(new ByteArrayInputStream(xml.getBytes("UTF-8")));
		} catch (Exception e) {
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
        return (fnode == null) ? "" : fnode.getText();
    }
	
	public static String getWidgetFieldAttr(Element w, String fieldname, String attrname)
    {
		Element fnode = (w == null) ? null : (Element)w.selectSingleNode("Field[@name='" + fieldname + "']");
        return getFieldAttr(fnode, attrname);
    }
	
	public static String getFieldAttr(Element fnode, String attrname)
    {
        return getFieldAttr(fnode, attrname, "");
    }
	
	public static String getFieldAttr(Element fnode, String attrname, String defaultValue)
    {
        return (fnode == null) ? defaultValue : fnode.attributeValue(attrname, defaultValue);
    }
	
    public static Element getPtyField(Document document, String fieldeName)
    {
        return (document == null) ? null : (Element)document.selectSingleNode("/Properties/Field[@name='" + fieldeName + "']");
    }
    
    public static String getPtyFieldVal(Document document, String fieldeName, Boolean isTta)
    {
        Element fieldNode = getPtyField(document, fieldeName);
        String val = (fieldNode == null) ? "" : fieldNode.getText();
        if (isTta) { val = getXmlWithoutCRLF(val); }
        return val;
    }
    
    public static String getXmlWithoutCRLF(String xml) {
    	return xml.replaceAll("\r\n", "<br />").replace("\n", "<br />");
    }
	
	public static String formatXml(Document document) {
		OutputFormat format = new OutputFormat();
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
	
	public static String tagimg(Element imgNode, String subdir, boolean setWH, String defaultAlt, Map<String, String> otherAttrs) {
		if (imgNode != null && !StringUtils.isBlank(imgNode.getTextTrim())) {
			String alt = getFieldAttr(imgNode, "alt", defaultAlt);
			StringBuilder sb = new StringBuilder("<img src=\"");
			sb.append(Global.getContentPath() + "/uploads/images/" + subdir + "/" + imgNode.getTextTrim() + "\"");
			if (setWH) {
				String pw = "srcw";
				String ph = "srch";
				if (!"source".equals(subdir)) {
					pw = subdir + "w";
					ph = subdir + "h";
				}
				sb.append(" width=\"" + getFieldAttr(imgNode, pw) + "\"");
				sb.append(" height=\"" + getFieldAttr(imgNode, ph) + "\"");
			}

			sb.append(" alt=\"" + alt + "\"");
			sb.append(" title=\"" + alt + "\"");

			if (otherAttrs != null) {
				for (String k : otherAttrs.keySet()) {
					sb.append(" " + k + "=\"" + otherAttrs.get(k) + "\"");
				}
			}
			sb.append(" />");
			return sb.toString();
		} else
			return "";
	}
	
	public static String getLinkAttr(Element lnk, String lang, boolean iscms) {
		return getLinkAttr(lnk, lang, iscms, null);
	}

	public static String getLinkAttr(LinkInfo linkInfo, String lang, boolean iscms, Map<String, String> othattrs) {
		if (linkInfo != null && !StringUtils.isBlank(linkInfo.getLink())) {
			StringBuilder sb = new StringBuilder(linkInfo.getLink());
			
			if (!StringUtils.isBlank(linkInfo.getAnchor())) {
				sb.append("#" + linkInfo.getAnchor());
			}
			sb.insert(0, " href=\"").append("\"");
			
			if (!StringUtils.isBlank(linkInfo.getType()) && !linkInfo.getType().equals("none") && !StringUtils.isBlank(linkInfo.getTarget()))
			{
				sb.append(" target='" + linkInfo.getTarget() + "'");
			}
			
			if (othattrs != null) {
				for (String k : othattrs.keySet())
				{
					sb.append(" " + k + "=\"" + othattrs.get(k) + "\"");
				}
			}
			return sb.toString();
		}
		return "#";
	}
	
	public static String getLinkAttr(Element lnk, String lang, boolean iscms, Map<String, String> othattrs) {
		LinkInfo linkInfo = getLinkInfo(lnk, lang, iscms);
		return getLinkAttr(linkInfo, lang, iscms, othattrs);
	}
	
	public static LinkInfo getLinkInfo(Element lnk, String lang, boolean iscms)
	{
		if (lnk != null) {
			LinkInfo linkInfo = new LinkInfo();
			linkInfo.setType(getFieldAttr(lnk, "lnktype"));
			linkInfo.setTarget(getFieldAttr(lnk, "target"));			
			linkInfo.setAnchor(getFieldAttr(lnk, "anchor"));
			switch (linkInfo.getType()) {
				case "external": linkInfo.setLink(lnk.getText()); break;
				case "internal":
					Page page = InitServlet.getQueryService().findPageById(Long.parseLong(lnk.getText()), iscms);
					linkInfo.setLink(getPageLink(page, lang, iscms).getLink());
					break;
				case "document": linkInfo.setLink(Global.getDocUploadPath(lnk.getText())); break;
			}					
			return linkInfo;
		}
		return null;
	}
	
	public static LinkInfo getPageLink(long pageid, String lang, boolean iscms){
		Page page = InitServlet.getQueryService().findPageById(pageid, iscms);
		return getPageLink(page, lang, iscms, false);
	}
	
	public static LinkInfo getPageLink(Page page, String lang, boolean iscms){
		return getPageLink(page, lang, iscms, false);
	}
	
	 public static LinkInfo getPageLink(Page page, String lang, boolean iscms, boolean isptyurl)
     {
		 LinkInfo linkInfo = new LinkInfo();
         if (page != null && !page.isNew()) {
             if (page.getTemplate().endsWith("Link")) {              
                 Element lnk = XmlUtils.getPtyField(page.getContent(lang).getPropertyXmlDoc(), "Link");
                 if (lnk != null) {
                	 linkInfo = getLinkInfo(lnk, lang, iscms);
                 }                 
             } else if (iscms && !isptyurl) { //if cms and not getting the property url
                 if (Global.goChildTemplates.containsKey(page.getTemplate())) {
                     Page firstChild = InitServlet.getQueryService().getFirstChild(page.getId(), iscms, true, Global.goChildTemplates.get(page.getTemplate()));
                     if (firstChild != null && !firstChild.isNew())
                         linkInfo = getPageLink(firstChild, lang, iscms);
                 } else {
                     linkInfo.setLink(Global.getCMSUrl() + "/PageAdmin/Preview?lang=" + lang + "&pgid=" + page.getId());
                 }
             } else { // if not cms or gettting property url
                 StringBuilder sb = new StringBuilder(page.getUrl());
                 if (page.getTemplate().equals("Sector") || page.getTemplate().equals("TopSector")) sb.append("/");
                 long parentId = page.getParentId();
                 if (Global.fixUrlPrefix.containsKey(parentId))
                 {
                     sb.insert(0, Global.fixUrlPrefix.get(parentId));
                     linkInfo.setLink(Global.getWebUrl() + "/" + lang + "/" + sb.toString() + Global.WEBPAGEEXT);
                 } else {
                     if (Global.goChildTemplates.containsKey(page.getTemplate())) {
                         Page firstChild = InitServlet.getQueryService().getFirstChild(page.getId(), iscms, true, Global.goChildTemplates.get(page.getTemplate()));
                         if (firstChild != null && !firstChild.isNew())
                             linkInfo = getPageLink(firstChild, lang, iscms);
                     } else {
                    	 while (parentId > 0) {
                    		 Page parent = InitServlet.getQueryService().findPageById(parentId, iscms);
                    		 sb.insert(0, parent.getUrl() + "/");
                    		 parentId = parent.getParentId();
                    	 }
                    	 linkInfo.setLink(Global.getWebUrl() + "/" + lang + "/" + sb.toString() + Global.WEBPAGEEXT); 
                     }
                 }
             }
         }
         return linkInfo;
     }

	public static String[] parseOpts(HttpServletRequest request, String optStr) throws Exception {
		//FromPropertyMtxtfield:Category:encryptValue=true,otherVlue=xxx
		if (!StringUtils.isBlank(optStr) && optStr.contains("FromPropertyMtxtfield")) {
			List<String> valueList = new ArrayList<String>();
			String[] settings = optStr.split(":", 2);
			if (settings.length == 2 && !StringUtils.isBlank(settings[1])) {
				String[] filedNameAndItsSetting = settings[1].split(":", 2);
				String fieldeName = filedNameAndItsSetting[0];
				boolean encryptValue = false;
				if (filedNameAndItsSetting.length == 2) {
					String[] fieldSettings = filedNameAndItsSetting[1].split(",");
					for(String filedSetting : fieldSettings) {
						String settingName = filedSetting.split("=", 2)[0];
						switch (settingName) {
						case "encryptValue":
							encryptValue = filedSetting.split("=", 2).length == 2 ? Boolean.parseBoolean(filedSetting.split("=", 2)[1]) : false;
							break;
						default:
							break;
						}
					}
				}				
				Page currentPage = (Page) request.getAttribute("currentPage");
				String lang = (String) request.getAttribute("lang");

				Content content = currentPage.getContent(lang);
				Document propertyDocument = content.getPropertyXmlDoc();
				String values = XmlUtils.getPtyFieldVal(propertyDocument, fieldeName, false);
				if (!StringUtils.isBlank(values)) {
					Type type = new TypeToken<String[]>(){}.getType();
					String[] opts = new Gson().fromJson(values, type);
					for(int i = 0; i < opts.length; i++) {
						String value = encryptValue ? MessageDigestUtils.encryptBASE64(opts[i].getBytes()) : opts[i];
						String displayValue = opts[i];
						String result = value + "^" + displayValue;
						if (!valueList.contains(result)) {
							valueList.add(result);
						}
					}					
				}
			}
			return valueList.toArray(new String[]{});
		} else {
			return optStr.split(",");
		}
	}
	 
}