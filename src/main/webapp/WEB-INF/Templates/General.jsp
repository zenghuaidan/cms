<%@include file="/WEB-INF/Shared/commons.jsp" %>
<%@page import="org.dom4j.Element"%>
<%@page contentType="text/html;charset=UTF-8"%>
<%@page import="org.apache.commons.lang3.StringUtils"%>
<%@page import="com.edeas.utils.XmlUtils"%>
<%@page import="org.dom4j.Document"%>
<%@page import="com.edeas.service.impl.QueryServiceImpl"%>
<%@page import="com.edeas.web.InitServlet"%>
<%@page import="com.edeas.model.*"%>
<link href="${Content}/css/general.css" rel="stylesheet" type="text/css" />
<link href="${Content}/css/slider.css" rel="stylesheet" type="text/css" />
<link href="${Content}/css/enlarge-img.css" rel="stylesheet" type="text/css" />
<link href="${Content}/css/accordion.css" rel="stylesheet" type="text/css" />
<style>   
    <c:if test="${isPageAdmin}">
	    h1, h2, h3 { text-align: left !important; } 
    </c:if>
</style>
<div class="general full-wrapper clearfix"> 
    <div class="inner-wrapper">
        <div class="main-content-pos">
        	<jsp:include page="/WEB-INF/Shared/WidgetHolder.jsp" />
    	</div>
    </div>
</div>