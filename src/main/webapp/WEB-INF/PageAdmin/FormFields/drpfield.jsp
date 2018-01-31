<%@page import="com.edeas.dwr.SchemaInfo"%>
<%@page import="org.apache.commons.lang3.StringUtils"%>
<%@page import="com.edeas.utils.XmlUtils"%>
<%@page import="java.util.Map"%>
<%@page import="org.dom4j.Element"%>
<%@page import="java.util.*"%>
<%@page import="com.edeas.controller.*"%>
<%@include file="/WEB-INF/Shared/commons.jsp" %>
<%
	Element fieldData = (Element)request.getAttribute("fieldData");//data
	Element widgetSchema = (Element)request.getAttribute("widgetSchema");//widget define
	Element fieldSchema = (Element)request.getAttribute("fieldSchema");//file schema
	String formType = (String)request.getAttribute("formType");//form type
	SchemaInfo fpm = XmlUtils.getSchemaInfo(fieldSchema, widgetSchema);
	String val = (fieldData == null) ? fpm.getDefaultValue() : fieldData.getTextTrim();	    
    
    String optStr = "property".equals(formType) ? XmlUtils.getFieldAttr(fieldSchema, "opts") : XmlUtils.getFieldAttr(widgetSchema, fpm.getName() + "Opts");    
    String[] opts = XmlUtils.parseOpts(request, optStr);
%>
<c:set var="opts" value="<%=opts %>"></c:set>
<c:set var="val" value="<%=val %>"></c:set>
<tr class="datafield">
    <td class="label" style="vertical-align:top;"><%=fpm.getLabel() %>: </td>
    <td class="field <%=fpm.getType() %>" fid="<%=fpm.getName() %>">
        <select id="<%=fpm.getName() %>" name="<%=fpm.getName() %>" style="<%=fpm.getStyle() %>">
	        <c:forEach items="${opts }" var="opt">
	        	<option value="${fn:split(opt, '^')[0]}" ${fn:split(opt, '^')[0] eq val ? ' selected' : ''}>${fn:split(opt, '^')[1]}</option>
	        </c:forEach>        
        </select>
        <%=fpm.getRemark() %>
    </td>
</tr>