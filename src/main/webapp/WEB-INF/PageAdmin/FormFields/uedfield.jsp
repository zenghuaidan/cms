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
	Map<String, String> fpm = XmlUtils.getSchemaInfo(fieldSchema, widgetSchema);
	String htmval = (fieldData == null) ? fpm.get("fdefval") : XmlUtils.getFieldRaw(fieldData, fpm.get("fname"));	
%>
<tr class="datafield">
    <td colspan="2" class="label" style="text-align:center;"><%=fpm.get("flabel") %></td>
</tr>
<tr class="datafield">
	<td colspan="2" class="field <%=fpm.get("ftype") %>" fid="<%=fpm.get("fname") %>">
		<script id="<%=fpm.get("fname") %>" name="<%=fpm.get("fname") %>" attrs="<%=fpm.get("fattr") %>" style="<%=fpm.get("fstyle") %>"><%=htmval %></script>
	</td>
</tr>