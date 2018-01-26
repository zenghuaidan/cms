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
    String chkval = (fieldData == null) ? fpm.getDefaultValue() : fieldData.getTextTrim();
    boolean isChk = !StringUtils.isBlank(chkval) && Boolean.valueOf(chkval.toLowerCase());
    String sel = isChk ? "checked" : "";
%>
<tr class="datafield">
    <td class="label" style="vertical-align:top;"><%=fpm.getLabel() %>: </td>
    <td class="field <%=fpm.getType() %>" fid="<%=fpm.getName() %>">
        <input type='checkbox' <%=sel %> style="<%=fpm.getStyle() %>" onclick="javascript: $('#<%=fpm.getName() %>').val(this.checked);" />
        <input type="hidden" id="<%=fpm.getName() %>" name="<%=fpm.getName() %>" value="<%= Boolean.toString(isChk).toLowerCase() %>" />
        <%=fpm.getRemark() %>
    </td>
</tr>