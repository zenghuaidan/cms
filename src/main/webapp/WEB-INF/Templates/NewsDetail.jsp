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

<link href="${Content}/css/general.css" rel="stylesheet" type="text/css" />

<script type="text/javascript" src="${Script}/jquery.jplayer.min.js"></script>

<%	
	boolean iscms = (Boolean)request.getAttribute("iscms");
	String lang = (String)request.getAttribute("lang");
	String pageIdStr = (String)request.getAttribute("newsPageId");
	String newsId = (String)request.getAttribute("newsId");
	String newsNodeXml = "";
	if (!StringUtils.isBlank(pageIdStr) && !StringUtils.isBlank(newsId)) {
		Long pageId = Long.parseLong(pageIdStr);
		Page videoPage = (Page)InitServlet.getQueryService().findPageById(pageId, iscms);
		Document contentDocument = videoPage.getContent(lang).getContentXmlDoc();
		Element newsNode = (Element)contentDocument.selectSingleNode("/PageContent/Widget[@name='WidgetHolder']/Widget[@id='" + newsId + "']");
		newsNodeXml = newsNode != null ? XmlUtils.getXmlWithoutCRLF(newsNode.asXML()) : "";
	} 
%>
<c:if test="${isPageAdmin}">
	<style>
		div.title-col2 h1 { text-align:unset !important}
	</style>
</c:if>
<c:set var="newsNodeXml" value="<%=newsNodeXml %>"></c:set>
<c:if test="${not empty newsNodeXml }">
	<x:parse xml="<%=newsNodeXml %>" var="widget"></x:parse>
	<div class="general detail full-wrapper clearfix"> 
	    <div class="inner-wrapper">
	        <div class="main-content-pos">
	            <div class="g-title-blk">
	                <div class="title-col1"><div class="btn-back"></div></div>
	                <div class="title-col2">
	                    <h1><x:out select="$widget/Widget/Field[@name='Title']" escapeXml="false"/></h1>
	                    <h3><x:out select="$widget/Widget/Field[@name='Date']" escapeXml="false"/></h3>
	                </div>
	                <div class="clear"></div>
	            </div>	        
	
	            <div>
	               <x:out select="$widget/Widget/Field[@name='Detail']" escapeXml="false"/>
	            </div>
	        </div>
	    </div>
	</div>
</c:if>