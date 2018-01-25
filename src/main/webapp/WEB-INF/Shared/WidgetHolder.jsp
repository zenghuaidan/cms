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
<%@ include file="/WEB-INF/Shared/commons.jsp" %>
<%
	Page currentPage = (Page)request.getAttribute("currentPage");
	boolean iscms = (Boolean)request.getAttribute("iscms");
	String lang = (String)request.getAttribute("lang");
	
	Content content = currentPage.getContent(lang);	
	Document contentDocument = content.getContentXmlDoc();
%>
<x:parse xml="<%=content.getContentXmlWithoutCRLF() %>" var="contentXml"></x:parse>
<% int i = 1; %>
<x:forEach select="$contentXml/PageContent/Widget[@name='WidgetHolder']/Widget" var="widget" varStatus="status">
   	<x:set var="widgetName" select="$widget/@name" />
   	<x:set var="widgetId" select="$widget/@wid" scope="page" /> 
   	<x:if select="$widgetName = 'ScaleImage'">
		<div class='widget'>
			<%
	            Element imageNode = (Element)contentDocument.selectSingleNode("/PageContent/Widget[@name='WidgetHolder']/Widget[" + i + "]/Field[@name='Image']");
				Element scaleNode = (Element)contentDocument.selectSingleNode("/PageContent/Widget[@name='WidgetHolder']/Widget[" + i + "]/Field[@name='Scale']");
	            Map<String, String> classMap = new HashMap<String, String>();
	            if (scaleNode != null)
	            	classMap.put("class", scaleNode.getTextTrim());
	            out.print(XmlUtils.tagimg(imageNode, Global.IMAGE_SOURCE, false, "", classMap));
	        %>
		</div>
   	</x:if>  
   	<x:if select="$widgetName = 'GreyBox'">
   		<div class='widget greyBox'><x:out select="$widget/Field[@name='Content']" escapeXml="false"/></div>
   	</x:if>
   	<x:if select="$widgetName = 'ColorBox'">
   		<div class='widget colorBox'><x:out select="$widget/Field[@name='Content']" escapeXml="false"/></div>	
   	</x:if>
   	<x:if select="$widgetName = 'SpaceBlk'">
   		<div class="widget" style="height:<x:out select="$widget/Field[@name='Text']" escapeXml="false"/>"></div>
   	</x:if>
   	<x:if select="$widgetName = 'LeftRightPhotoBlk'">
   	</x:if>
   	<x:if select="$widgetName = 'xxxxx'">
   	</x:if>
   
	<% i++; %>   
</x:forEach>