<%@page import="com.edeas.dwr.SchemaInfo"%>
<%@page import="org.apache.commons.lang3.StringUtils"%>
<%@page import="com.edeas.utils.XmlUtils"%>
<%@page import="java.util.Map"%>
<%@page import="org.dom4j.Element"%>
<%@page import="java.util.*"%>
<%@page import="com.edeas.controller.*"%>
<%@page import="com.edeas.service.impl.*"%>
<%@page import="com.edeas.web.InitServlet"%>
<%@page import="com.edeas.model.*"%>
<%
	QueryServiceImpl queryService = InitServlet.getQueryService();
	Element fieldData = (Element)request.getAttribute("fieldData");//data
	Element widgetSchema = (Element)request.getAttribute("widgetSchema");//widget define
	Element fieldSchema = (Element)request.getAttribute("fieldSchema");//file schema
	SchemaInfo fpm = XmlUtils.getSchemaInfo(fieldSchema, widgetSchema);
	String txtval = (fieldData == null) ? fpm.getDefaultValue() : XmlUtils.getFieldRaw(fieldData, fpm.getName());
	String topOption = "";
	String selPageId = XmlUtils.getWidgetFieldAttr(fieldData, fpm.getName(), "pgid");
	List<Page> pages = null;
	if(!StringUtils.isBlank(fpm.getAttribute())) {
		String[] attrs = fpm.getAttribute().split(",");
		for(String attr : attrs) {
			String[] typeAndValue = attr.split(":");
			if ("Parent".equals(typeAndValue[0])) {
				String[] subtypeAndValue = typeAndValue[1].split("=");
				if("PageID".equals(subtypeAndValue[0])) {
					long pageid = Long.valueOf(subtypeAndValue[1]);
					pages = queryService.findPagesByParentId(pageid, true, true);
				} else if("Template".equals(subtypeAndValue[0])) {
					String template = subtypeAndValue[1];
					pages = queryService.findPageByTemplate(template, true, true);
				} else {
					// not support...
				}
			} else if("TopOpt".equals(typeAndValue[0])) {
				String[] options = typeAndValue[1].split("^");
				topOption = "<option value='"+options[1]+"'>" + options[0] + "</option>";
			}
			
		}
	}
%>
<tr class="datafield">
    <td class="label" style="vertical-align:top;"><%=fpm.getLabel() %>: </td>
    <td class="field <%=fpm.getType() %>" fid="<%=fpm.getName() %>">
        <select id="<%=fpm.getName() %>" name="<%=fpm.getName() %>" class="spgsel">
            <%=topOption %>
            <%
            	if(pages != null) {
            		for(Page _page : pages) {
            			String sel = _page.getId().toString().equals(selPageId) ? " selected" : "";
            			out.print("<option value='" + _page.getId() + "' " + sel + ">" + _page.getName() + "</option>");
            		}
            	}
            %>            
        </select>
    </td>
</tr>