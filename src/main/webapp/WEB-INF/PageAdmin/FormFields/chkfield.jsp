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
    String chkval = (fieldData == null) ? fpm.get("fdefval") : XmlUtils.getFieldRaw(fieldData, fpm.get("fname"));
    boolean isChk = !StringUtils.isBlank(chkval) && Boolean.getBoolean(chkval.toLowerCase());
    String sel = isChk ? "checked" : "";
%>
<tr class="datafield">
    <td class="label" style="vertical-align:top;"><%=fpm.get("flabel") %>: </td>
    <td class="field <%=fpm.get("ftype") %>" fid="<%=fpm.get("fname") %>">
        <input type='checkbox' <%=sel %> style="<%=fpm.get("fstyle") %>" onclick="javascript: $('#<%=fpm.get("fname") %>').val(this.checked);" />
        <input type="hidden" id="<%=fpm.get("fname") %>" name="<%=fpm.get("fname") %>" value="<%= Boolean.toString(isChk).toLowerCase() %>" />
        <%=fpm.get("fremark") %>
    </td>
</tr>