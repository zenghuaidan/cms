<%@page import="com.edeas.controller.cmsadmin.CmsProperties"%>
<%@page import="com.edeas.controller.Global"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@taglib prefix="x" uri="http://java.sun.com/jsp/jstl/xml" %>
<%@taglib prefix="sf" uri="http://www.springframework.org/tags/form" %>
<c:set var="context" value="${pageContext.request.contextPath}" />
<c:set var="Content" value="<%=Global.getContentPath() %>" />
<c:set var="Script" value="<%=Global.getScriptPath() %>" />
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta name="viewport" content="width=device-width" />
<script type="text/javascript" src="${context}/dwr/engine.js"></script>
<script type="text/javascript" src="${context}/dwr/interface/dwrService.js"></script>
<c:set var="cmsUrl" value="<%=Global.getCMSUrl() %>"></c:set>