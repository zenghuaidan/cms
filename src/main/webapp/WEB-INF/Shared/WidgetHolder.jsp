<%@page import="org.apache.commons.lang3.StringUtils"%>
<%@page import="org.dom4j.Element"%>
<%@page import="org.dom4j.Node"%>
<%@page import="com.edeas.utils.XmlUtils"%>
<%@page import="java.util.*"%>
<%@page import="com.edeas.controller.cmsadmin.CmsProperties"%>
<%@page import="com.edeas.model.CmsPage"%>
<%@page import="com.edeas.model.Page"%>
<%@page import="com.edeas.model.Content"%>
<%@page import="com.edeas.service.impl.*"%>
<%@page import="com.edeas.web.InitServlet"%>
<%@page import="org.dom4j.Document"%>
<%@ include file="/WEB-INF/Shared/commons.jspf" %>
<%
	Page currentPage = (Page)request.getAttribute("currentPage");
	boolean iscms = (Boolean)request.getAttribute("iscms");
	String lang = (String)request.getAttribute("lang");
	
	Content content = currentPage.getContent(lang);
	
	Element wholder = content == null ? null : (Element)content.getContentXmlDoc().selectSingleNode("/PageContent/Widget[@name='WidgetHolder']");
	List<Element> widgetList = wholder == null ? null : wholder.selectNodes("Widget");
	
	if (widgetList != null) {
		for(Element widget : widgetList) {
			String widgetName = widget.attributeValue("name");
			String widgetId = widget.attributeValue("wid");
			if("SpaceBlk".equals(widgetName)) {
				out.print("<div class='widget clear' style='height:50px'>dsfdsfdsfsdfsdfsd</div>");
			}
		}
	}
%>