<%@page import="org.apache.commons.lang3.StringUtils"%>
<%@page import="com.edeas.utils.XmlUtils"%>
<%@page import="java.util.Map"%>
<%@page import="org.dom4j.Element"%>
<%@page import="org.dom4j.Node"%>
<%@page import="java.util.*"%>
<%@page import="org.dom4j.Document"%>

<%
	Element dataw = (Element)request.getAttribute("dataw");//data
	Element wdef = (Element)request.getAttribute("wdef");//widget define
	Element model = (Element)request.getAttribute("model");//file schema
	Map<String, String> fpm = XmlUtils.getFieldCommon(model, wdef);
    String chkval = (dataw == null) ? fpm.get("fdefval") : XmlUtils.getFieldRaw(dataw, fpm.get("fname"));
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