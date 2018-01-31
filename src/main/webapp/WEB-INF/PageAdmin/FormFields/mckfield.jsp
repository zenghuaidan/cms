<%@page import="com.google.gson.Gson"%>
<%@page import="com.fasterxml.jackson.databind.util.JSONPObject"%>
<%@page import="com.edeas.dwr.SchemaInfo"%>
<%@page import="org.apache.commons.lang3.StringUtils"%>
<%@page import="com.edeas.utils.XmlUtils"%>
<%@page import="java.util.Map"%>
<%@page import="org.dom4j.Element"%>
<%@page import="java.util.*"%>
<%@page import="com.edeas.controller.*"%>
<%@page import="com.edeas.model.CmsPage"%>
<%@page import="com.edeas.model.Page"%>
<%@page import="com.edeas.model.Content"%>
<%@page import="org.dom4j.Document"%>
<%@page import="com.google.gson.Gson"%>
<%@page import="com.google.gson.GsonBuilder"%>
<%@page import="com.google.gson.reflect.TypeToken"%>
<%@page import="java.lang.reflect.Type"%>
<%@include file="/WEB-INF/Shared/commons.jsp" %>
<%
	Element fieldData = (Element)request.getAttribute("fieldData");//data
	Element widgetSchema = (Element)request.getAttribute("widgetSchema");//widget define
	Element fieldSchema = (Element)request.getAttribute("fieldSchema");//file schema
	String formType = (String)request.getAttribute("formType");//form type	
	SchemaInfo fpm = XmlUtils.getSchemaInfo(fieldSchema, widgetSchema);
	String chkvals = (fieldData == null) ? fpm.getDefaultValue() : fieldData.getTextTrim();
		
	String optStr = "property".equals(formType) ? XmlUtils.getFieldAttr(fieldSchema, "opts") : XmlUtils.getFieldAttr(widgetSchema, fpm.getName() + "Opts");    
    String[] opts = XmlUtils.parseOpts(request, optStr);
%>
<c:set var="opts" value="<%=opts %>"></c:set>
<c:set var="chkvals" value="<%=chkvals %>"></c:set>
<tr class="datafield">
    <td class="label" style="vertical-align:top;"><%=fpm.getLabel() %>:</td>
    <td class="field <%=fpm.getType() %>" fid="<%=fpm.getName() %>">
        <input type="hidden" id="<%=fpm.getName() %>" name="<%=fpm.getName() %>" value="<%=chkvals %>" />
   	    <c:forEach items="${opts }" var="opt">
        	<input type='checkbox' value="${fn:split(opt, '^')[0]}" ${fn:contains(chkvals, fn:split(opt, '^')[0]) ? 'checked' : ''} disabled/>${fn:split(opt, '^')[1]}
        </c:forEach>      
    </td>
</tr>