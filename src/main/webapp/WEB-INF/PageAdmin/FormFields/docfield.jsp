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
	String val = (fieldData == null) ? fpm.getDefaultValue() : fieldData.getTextTrim();
%>
<tr class="datafield">
    <td class="label" style="vertical-align:top;"><%=fpm.getLabel() %>: </td>
    <td class="field <%=fpm.getType() %>" fid="<%=fpm.getName() %>">
        <input type='hidden' id="<%=fpm.getName() %>" name="<%=fpm.getName() %>" class='docvalfield' value="<%=val %>" />
        <input type='file' id="<%=fpm.getName() %>_file" name="<%=fpm.getName() %>_file" style="<%=fpm.getStyle() %>"  />
        <% if (!StringUtils.isBlank(val)) { %>
            <div id="<%=fpm.getName() %>_view">
                File: <%=val %>
                <input type="button" value="View" onclick="window.open('<%=Global.getDocUploadPath(val) %>');" />
                <input type="button" value="Clear" onclick="clrVal('<%=fpm.getName() %>'); $('#<%=fpm.getName() %>_view').hide();" />
            </div>
        <% } %>
        <%=fpm.getRemark() %>
    </td>
</tr>