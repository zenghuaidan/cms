<%@page import="com.edeas.dwr.SchemaInfo"%>
<%@page import="org.apache.commons.lang3.StringUtils"%>
<%@page import="com.edeas.utils.XmlUtils"%>
<%@page import="java.util.Map"%>
<%@page import="org.dom4j.Element"%>
<%@page import="java.util.*"%>
<%@page import="com.edeas.controller.*"%>

<%
	Element fieldData = (Element)request.getAttribute("fieldData");//data
	Element widgetSchema = (Element)request.getAttribute("widgetSchema");//widget define
	Element fieldSchema = (Element)request.getAttribute("fieldSchema");//file schema
	SchemaInfo fpm = XmlUtils.getSchemaInfo(fieldSchema, widgetSchema);
	String txtval = (fieldData == null) ? fpm.getDefaultValue() : fieldData.getText();	
%>
<tr class="datafield">
    <td class="label" style="vertical-align:top;"><%=fpm.getLabel() %>: </td>
    <td class="field <%=fpm.getType() %>" fid="<%=fpm.getName() %>">
        <textarea id="<%=fpm.getName() %>" name="<%=fpm.getName() %>" style="<%=fpm.getStyle() %>"><%=txtval %></textarea>
        <%=fpm.getRemark() %>
    </td>
</tr>