<%@page import="com.edeas.controller.cmsadmin.CmsProperties"%>
<%@page import="com.edeas.controller.Global"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@taglib prefix="x" uri="http://java.sun.com/jsp/jstl/xml" %>
<%@taglib prefix="sf" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<c:set var="context" value="${pageContext.request.contextPath}" />
<c:set var="Content" value="<%=Global.getContentPath() %>" />
<c:set var="Script" value="<%=Global.getScriptPath() %>" />
<c:set var="Plugin" value="<%=Global.getPluginsPath() %>" />
<c:set var="cmsUrl" value="<%=Global.getCMSUrl() %>"></c:set>