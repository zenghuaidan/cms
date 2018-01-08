<%@page import="org.apache.commons.lang3.StringUtils"%>
<%@page import="com.edeas.utils.XmlUtils"%>
<%@page import="java.util.Map"%>
<%@page import="org.dom4j.Element"%>
<%@page import="java.util.*"%>

<%
	Element fieldData = (Element)request.getAttribute("fieldData");//data
	Element widgetSchema = (Element)request.getAttribute("widgetSchema");//widget define
	Element fieldSchema = (Element)request.getAttribute("fieldSchema");//file schema
	Map<String, String> fpm = XmlUtils.getSchemaInfo(fieldSchema, widgetSchema);
    String fid = fpm.get("fname");
    String txtval = (fieldData == null) ? fpm.get("fdefval") : XmlUtils.getFieldRaw(fieldData, fpm.get("fname"));
%>

<tr class="datafield">
    <td class="label" style="vertical-align:top;"><%=fpm.get("flabel") %>: </td>
    <td class="field <%=fpm.get("ftype") %>" fid="<%=fpm.get("fname") %>">
    	<input id="<%=fid%>" name="<%=fid%>" value="<%=txtval%>" style="<%=fpm.get("fstyle") %>" />
    </td>
</tr>