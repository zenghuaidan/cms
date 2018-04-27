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
<%@page contentType="text/html;charset=UTF-8"%>
<%@ include file="/WEB-INF/Shared/commons.jsp" %>

<link href="${Content}/css/general.css" rel="stylesheet" type="text/css" />

<script type="text/javascript" src="${Script}/jquery.jplayer.min.js"></script>

<%	
	boolean iscms = (Boolean)request.getAttribute("iscms");
	String lang = (String)request.getAttribute("lang");
	String pageIdStr = (String)request.getAttribute("newsPageId");
	String newsId = (String)request.getAttribute("newsId");
	String newsNodeXml = "";
	boolean isMasonry = true;
	Date newsDate = null;
	if (!StringUtils.isBlank(pageIdStr)) {
		Long pageId = Long.parseLong(pageIdStr);
		Page newsDetailPage = (Page)InitServlet.getQueryService().findPageById(pageId, iscms);
		if (!StringUtils.isBlank(newsId)) {
			Document contentDocument = newsDetailPage.getContent(lang).getContentXmlDoc();
			Element newsNode = (Element)contentDocument.selectSingleNode("/PageContent/Widget[@name='WidgetHolder']/Widget[@id='" + newsId + "']");
			newsNodeXml = newsNode != null ? XmlUtils.getXmlWithoutCRLF(newsNode.asXML()) : "";			
		} else {
			isMasonry = false;
			Document ptyDocument = newsDetailPage.getContent(lang).getPropertyXmlDoc();
			Element newsNode = (Element)ptyDocument.selectSingleNode("/Properties");
			newsNodeXml = newsNode != null ? XmlUtils.getXmlWithoutCRLF(newsNode.asXML()) : "";
			newsDate = newsDetailPage.getPageTimeFrom();
		}
	}
%>
<c:if test="${isPageAdmin}">
	<style>
		div.title-col2 h1 { text-align:unset !important}
	</style>
</c:if>
<c:set var="newsNodeXml" value="<%=newsNodeXml %>"></c:set>
<c:set var="isMasonry" value="<%=isMasonry %>"></c:set>
<c:if test="${not empty newsNodeXml }">
	<x:parse xml="<%=newsNodeXml %>" var="widget"></x:parse>
	<div class="general detail full-wrapper clearfix"> 
	    <div class="inner-wrapper">
	        <div class="main-content-pos">
	            <div class="g-title-blk">
	                <div class="title-col1"><div class="btn-back" onclick="history.go(-1);"></div></div>
	                <div class="title-col2">
	                    <h1><x:out select="$widget/*/Field[@name='Title']" escapeXml="false"/></h1>
	                    <h3>
	                    	<c:if test="${isMasonry}">
	                    		<x:out select="$widget/*/Field[@name='Date']" escapeXml="false"/>
	                    	</c:if>
	                    	<c:if test="${not isMasonry}">
	                    		<c:set var="newsDate" value="<%=newsDate%>"></c:set>	                    	
	                    		<fmt:formatDate value="${newsDate}" pattern="yyyy-MM-dd" />
	                    	</c:if>
                    	</h3>
	                </div>
	                <div class="clear"></div>
	            </div>	        
	
	            <div>
	               <x:out select="$widget/*/Field[@name='Detail']" escapeXml="false"/>
	            </div>
	        </div>
	    </div>
	</div>
</c:if>