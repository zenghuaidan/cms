<%@page import="com.edeas.dwr.SchemaInfo"%>
<%@page import="org.apache.commons.lang3.StringUtils"%>
<%@page import="com.edeas.utils.XmlUtils"%>
<%@page import="java.util.Map"%>
<%@page import="org.dom4j.Element"%>
<%@page import="java.util.*"%>
<%@page import="com.edeas.controller.*"%>
<%@include file="/WEB-INF/Shared/commons.jsp" %>
<%
	Element fieldData = (Element)request.getAttribute("fieldData");//data
	Element widgetSchema = (Element)request.getAttribute("widgetSchema");//widget define
	Element fieldSchema = (Element)request.getAttribute("fieldSchema");//file schema
	String formType = (String)request.getAttribute("formType");//form type
	SchemaInfo fpm = XmlUtils.getSchemaInfo(fieldSchema, widgetSchema);
	String val = (fieldData == null) ? fpm.getDefaultValue() : fieldData.getTextTrim();	    
    
    String optStr = "property".equals(formType) ? XmlUtils.getFieldAttr(fieldSchema, "opts") : XmlUtils.getFieldAttr(widgetSchema, fpm.getName() + "Opts");    
    String[] opts = XmlUtils.parseOpts(request, optStr);
%>

<tr class="datafield">
    <td class="label" style="vertical-align:top;"><%=fpm.getLabel() %>: </td>
    <td class="field <%=fpm.getType() %>" fid="<%=fpm.getName() %>">
        <select id="<%=fpm.getName() %>" name="<%=fpm.getName() %>" style="<%=fpm.getStyle() %>">
        	<%
        		for(String opt : opts) {
        			String[] options = opt.split("\\^", -1);
        			%>
			        	<option value="<%=options[1] %>" <%=options[0].equals(val) ? "selected" : "" %>><%=options[0] %></option>
        			<%
        		}
        	%>    
        </select>
        <%=fpm.getRemark() %>
    </td>
</tr>