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
	String htmval = (fieldData == null) ? fpm.getDefaultValue() : fieldData.getTextTrim();	
%>
<tr class="datafield">
    <td colspan="2" class="label" style="text-align:center;"><%=fpm.getLabel() %></td>
</tr>
<tr class="datafield">
	<td colspan="2" class="field <%=fpm.getType() %>" fid="<%=fpm.getName() %>">
		<script id="<%=fpm.getName() %>" name="<%=fpm.getName() %>" attrs="<%=fpm.getAttribute() %>" style="<%=fpm.getStyle() %>"><%=htmval %></script>
	</td>
</tr>