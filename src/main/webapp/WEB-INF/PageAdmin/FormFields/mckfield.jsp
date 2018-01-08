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
	String chkvals = (fieldData == null) ? fpm.get("fdefval") : XmlUtils.getFieldRaw(fieldData, fpm.get("fname"));
	List<String> chkvalList = Arrays.asList(StringUtils.isBlank(chkvals) ? new String[]{} : chkvals.split(";"));
	
	String fattr = XmlUtils.getFieldAttr(fieldSchema, "attr");
    String wattr = XmlUtils.getFieldAttr(widgetSchema, fpm.get("fname") + "Attr");
    if (!StringUtils.isBlank(wattr)) { fattr = wattr; }
    String[] opts = StringUtils.isBlank(fattr) ? new String[]{} :  fattr.split(",");
%>

<tr class="datafield">
    <td class="label" style="vertical-align:top;"><%=fpm.get("flabel") %>:</td>
    <td class="field <%=fpm.get("ftype") %>" fid="<%=fpm.get("fname") %>">
        <input type="hidden" id="<%=fpm.get("fname") %>" name="<%=fpm.get("fname") %>" value="<%=chkvals %>" />
        <%
            for (String o : opts)
            {
                String[] b = o.split("^");
                String sel = chkvalList.contains(b[0]) ? "checked" : "";
                out.print("<input type='checkbox' value='" + b[0] + "' " + sel + "  disabled/>" + b[1]); 
            }
        %>        
    </td>
</tr>