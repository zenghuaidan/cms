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
	String val = (fieldData == null) ? fpm.getDefaultValue() : XmlUtils.getFieldRaw(fieldData, fpm.getName());
	
    String fopts = XmlUtils.getFieldAttr(fieldSchema, "opts");
    String wopts = XmlUtils.getFieldAttr(widgetSchema, fpm.getName() + "Opts");
    if (!StringUtils.isBlank(wopts)) { fopts = wopts; }
    String[] opts = StringUtils.isBlank(fopts) ? new String[]{} :  fopts.split(",");
%>
<tr class="datafield">
    <td class="label" style="vertical-align:top;"><%=fpm.getLabel() %>: </td>
    <td class="field <%=fpm.getType() %>" fid="<%=fpm.getName() %>">
        <select id="<%=fpm.getName() %>" name="<%=fpm.getName() %>" style="<%=fpm.getType() %>">
        <%
        	for(String opt : opts) {
	            String[] o = opt.split("^");
	            String sel = o[0].equals(val) ? " selected" : "";
	            out.print("<option value='" + o[0] + "' @sel>" + o[1] + "</option>");
        		
        	}
        %>
        </select>
        <%=fpm.getRemark() %>
    </td>
</tr>