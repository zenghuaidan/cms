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
<link href="${Content}/css/video-player.css" rel="stylesheet" type="text/css" />

<script type="text/javascript" src="${Script}/jquery.jplayer.min.js"></script>

<script type="text/javascript" src="${Plugin}/rs-plugin/js/jquery.themepunch.tools.min.js"></script>
<script type="text/javascript" src="${Plugin}/rs-plugin/js/jquery.themepunch.revolution.min.js"></script>
<script type="text/javascript" src="${Plugin}/rs-plugin/js/extensions/revolution.extension.video.min.js"></script>
<script type="text/javascript" src="${Plugin}/rs-plugin/js/extensions/revolution.extension.slideanims.min.js"></script>
<script type="text/javascript" src="${Plugin}/rs-plugin/js/extensions/revolution.extension.actions.min.js"></script>
<script type="text/javascript" src="${Plugin}/rs-plugin/js/extensions/revolution.extension.layeranimation.min.js"></script>
<script type="text/javascript" src="${Plugin}/rs-plugin/js/extensions/revolution.extension.kenburn.min.js"></script>
<script type="text/javascript" src="${Plugin}/rs-plugin/js/extensions/revolution.extension.navigation.min.js"></script>
<script type="text/javascript" src="${Plugin}/rs-plugin/js/extensions/revolution.extension.migration.min.js"></script>
<script type="text/javascript" src="${Plugin}/rs-plugin/js/extensions/revolution.extension.parallax.min.js"></script>

<%	
	boolean iscms = (Boolean)request.getAttribute("iscms");
	String lang = (String)request.getAttribute("lang");
	String pageIdStr = (String)request.getAttribute("videoPageId");
	String videoId = (String)request.getAttribute("videoId");
	String videoNodeXml = "";
	if (!StringUtils.isBlank(pageIdStr) && !StringUtils.isBlank(videoId)) {
		Long pageId = Long.parseLong(pageIdStr);
		Page videoPage = (Page)InitServlet.getQueryService().findPageById(pageId, iscms);
		Document contentDocument = videoPage.getContent(lang).getContentXmlDoc();
		Element videoNode = (Element)contentDocument.selectSingleNode("/PageContent/Widget[@name='WidgetHolder']/Widget[@id='" + videoId + "']");
		videoNodeXml = videoNode != null ? XmlUtils.getXmlWithoutCRLF(videoNode.asXML()) : "";
	} 
%>
<c:if test="${isPageAdmin}">
	<style>
		div.title-col2 h1 { text-align:unset !important}
	</style>
</c:if>
<c:set var="videoNodeXml" value="<%=videoNodeXml %>"></c:set>
<c:if test="${not empty videoNodeXml }">
	<x:parse xml="<%=videoNodeXml %>" var="widget"></x:parse>
	<div class="general detail full-wrapper clearfix"> 
	    <div class="inner-wrapper">
	        <div class="main-content-pos">
	            <div class="g-title-blk">
	                <div class="title-col1"><div class="btn-back" onclick="history.go(-1);"></div></div>
	                <div class="title-col2">
	                    <h1><x:out select="$widget/Widget/Field[@name='Title']" escapeXml="false"/></h1>
	                    <h3><x:out select="$widget/Widget/Field[@name='Date']" escapeXml="false"/></h3>
	                </div>
	                <div class="clear"></div>
	            </div>
	        
	            <!--Video1-->
	            <div id="jp_container_128" class="jp-video mfn-jcontainer jp-video-360p2" style="">
	                <div class="jp-type-single">
	                    <div class="jp-jplayer mfn-jplayer" data-m4v="<%=Global.getDocUploadPath() %>/<x:out select="$widget/Widget/Field[@name='Video']" escapeXml="false"/>" data-img="<%=Global.getImagesUploadPath(Global.IMAGE_SOURCE) %>/<x:out select="$widget/Widget/Field[@name='Image']" escapeXml="false"/>" style="height:600px"></div>
	                    <%@include file="/WEB-INF/Shared/Video.jsp" %>
	                </div>
	            </div>
	
	            <div class="detail-video-content">
	               <x:out select="$widget/Widget/Field[@name='Detail']" escapeXml="false"/>
	            </div>
	        </div>
	    </div>
	</div>
</c:if>