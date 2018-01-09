<%@page import="com.edeas.dwr.SchemaInfo"%>
<%@page import="org.apache.commons.lang3.StringUtils"%>
<%@page import="com.edeas.utils.XmlUtils"%>
<%@page import="java.util.Map"%>
<%@page import="org.dom4j.Element"%>
<%@page import="java.util.*"%>

<%
	Element fieldData = (Element)request.getAttribute("fieldData");//data
	Element widgetSchema = (Element)request.getAttribute("widgetSchema");//widget define
	Element fieldSchema = (Element)request.getAttribute("fieldSchema");//file schema
	SchemaInfo fpm = XmlUtils.getSchemaInfo(fieldSchema, widgetSchema);
    String fid = fpm.getName();
    String txtval = (fieldData == null) ? fpm.getDefaultValue() : XmlUtils.getFieldRaw(fieldData, fpm.getName());
    if ("today".equals(txtval)) {
    	txtval = com.edeas.utils.DateUtils.yyyyMMdd().format(new Date());
    }
%>

<tr class="datafield">
    <td class="label" style="vertical-align:top;"><%=fpm.getLabel() %>: </td>
    <td class="field <%=fpm.getType() %>" fid="<%=fpm.getName() %>">
    	<input id="<%=fid%>" name="<%=fid%>" value="<%=txtval%>" style="<%=fpm.getStyle() %>" />
    </td>
</tr>