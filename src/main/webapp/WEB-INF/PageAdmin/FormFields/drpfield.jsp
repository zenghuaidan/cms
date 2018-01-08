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
	
    String fopts = XmlUtils.getFieldAttr(fieldSchema, "opts");
    String wopts = XmlUtils.getFieldAttr(widgetSchema, fpm.get("fname") + "Opts");
    if (!StringUtils.isBlank(wopts)) { fopts = wopts; }
    String[] opts = fopts.split(",");
%>
<tr class="datafield">
    <td class="label" style="vertical-align:top;"><%=fpm.get("flabel") %>: </td>
    <td class="field <%=fpm.get("ftype") %>" fid="<%=fpm.get("fname") %>">
        <select id="<%=fpm.get("fname") %>" name="<%=fpm.get("fname") %>" style="<%=fpm.get("ftype") %>">
        <%
        	for(String opt : opts) {
	            String[] o = opt.split("^");
	            String sel = val.equals(o[0]) ? " selected" : "";
	            out.print("<option value='" + o[0] + "' @sel>" + o[1] + "</option>");
        		
        	}
        %>
        </select>
        <%=fpm.get("fremark") %>
    </td>
</tr>