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
<link href="${Content}/css/slider.css" rel="stylesheet" type="text/css" />
<link href="${Content}/css/enlarge-img.css" rel="stylesheet" type="text/css" />
<link href="${Content}/css/accordion.css" rel="stylesheet" type="text/css" />

<script type="text/javascript" src="${Script}/jquery.jplayer.min.js"></script>

<%	
	boolean iscms = (Boolean)request.getAttribute("iscms");
	String lang = (String)request.getAttribute("lang");	
	Page currentPage = (Page)request.getAttribute("currentPage");
	Content pageContent = currentPage.getContent(lang);		
	Element newsNode = (Element)pageContent.getPropertyXmlDoc().selectSingleNode("/Properties");
	String newsNodeXml = newsNode != null ? XmlUtils.getXmlWithoutCRLF(newsNode.asXML()) : "";
	Date newsDate = currentPage.getPageTimeFrom();
%>
<c:if test="${isPageAdmin}">
	<style>
		div.title-col2 h1 { text-align:unset !important}
		h1, h2, h3 { text-align: left !important; }
	</style>
</c:if>
<c:set var="newsNodeXml" value="<%=newsNodeXml %>"></c:set>
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
                    		<c:set var="newsDate" value="<%=newsDate%>"></c:set>	                    	
                    		<fmt:formatDate value="${newsDate}" pattern="yyyy-MM-dd" />
                    	</h3>
	                </div>
	                <div class="clear"></div>
	            </div>	        
	
	            <div>
	               <x:out select="$widget/*/Field[@name='Detail']" escapeXml="false"/>
	            </div>
	            <jsp:include page="/WEB-INF/Shared/WidgetHolder.jsp" />
	        </div>
	    </div>
	</div>
</c:if>