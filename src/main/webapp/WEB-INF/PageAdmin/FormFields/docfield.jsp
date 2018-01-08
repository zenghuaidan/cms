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
	String val = (fieldData == null) ? fpm.get("fdefval") : XmlUtils.getFieldRaw(fieldData, fpm.get("fname"));
%>
<tr class="datafield">
    <td class="label" style="vertical-align:top;"><%=fpm.get("flabel") %>: </td>
    <td class="field <%=fpm.get("ftype") %>" fid="<%=fpm.get("fname") %>">
        <input type='hidden' id="<%=fpm.get("fname") %>" name="<%=fpm.get("fname") %>" class='docvalfield' value="<%=val %>" />
        <input type='file' id="<%=fpm.get("fname") %>_file" name="<%=fpm.get("fname") %>_file" style="<%=fpm.get("fstyle") %>"  />
        <% if (!StringUtils.isBlank(val)) { %>
            <div id="<%=fpm.get("fname") %>_view">
                File: <%=val %>
                <input type="button" value="View" onclick="window.open('<%=Global.getDocUploadPath(val) %>');" />
                <input type="button" value="Clear" onclick="clrVal('<%=fpm.get("fname") %>'); $('#<%=fpm.get("fname") %>)_view').hide();" />
            </div>
        <% } %>
        <%=fpm.get("fremark") %>
    </td>
</tr>