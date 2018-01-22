<%@page import="com.edeas.service.impl.QueryServiceImpl"%>
<%@page import="com.edeas.model.*"%>
<%@page import="com.edeas.web.InitServlet"%>
<%@page import="java.util.HashMap"%>
<%@page import="java.util.Map"%>
<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<%@include file="/WEB-INF/Shared/commons.jsp" %>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title>${ title }</title>
<script type="text/javascript">
</script>
<link rel="stylesheet" type="text/css" href="<%=request.getContextPath()%>/resources/script/jquery.datetimepicker.css"/>
<link rel="stylesheet" type="text/css" href="<%=request.getContextPath()%>/resources/script/mmnt.css"/>
<link rel="stylesheet" type="text/css" href="<%=request.getContextPath()%>/resources/css/index.css"/>
<script src="<%=request.getContextPath()%>/resources/script/jquery.js"></script>
<script src="<%=request.getContextPath()%>/resources/script/jquery.datetimepicker.full.min.js"></script>
<script src="<%=request.getContextPath()%>/resources/script/mmnt.js"></script>
<script src="<%=request.getContextPath()%>/resources/script/index.js"></script>
<script src="<%=request.getContextPath()%>/resources/script/jquery.form.min.js"></script>
</head>
<body>
<%
	Map<String, String> map = new HashMap<String, String>();
	//map.put("abc", "123456");
	QueryServiceImpl queryServiceImpl = InitServlet.getQueryService();
	Page _page = queryServiceImpl.getHomePage(true);
	String lang = "en";
%>
<c:set var="map" value="<%=map %>"></c:set>
<c:out value="${map['abc'] }"></c:out>
<c:if test="${empty map['abc'] }">
	hello
</c:if>
<x:parse xml="<%=_page.getContent(lang).getContentXml() %>" var="contentXml"></x:parse>
<x:out select="$contentXml/PageContent/Widget[@name='SectionTitle']/Field" escapeXml="false" />
</body>
</html>