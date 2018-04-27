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
<%@include file="/WEB-INF/Shared/commons.jsp" %>
<%
	QueryServiceImpl queryService = InitServlet.getQueryService();
	Element fieldData = (Element)request.getAttribute("fieldData");//data
	Element widgetSchema = (Element)request.getAttribute("widgetSchema");//widget define
	Element fieldSchema = (Element)request.getAttribute("fieldSchema");//file schema
	SchemaInfo fpm = XmlUtils.getSchemaInfo(fieldSchema, widgetSchema);
	String txtval = (fieldData == null) ? fpm.getDefaultValue() : fieldData.getTextTrim();
	String topOption = "";
	String selPageId = XmlUtils.getFieldAttr(fieldData, "pgid");
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
					if ("NewsListInside".equals(template)) {
						Collections.sort(pages, new Comparator<Page>() {
							@Override
							public int compare(Page o1, Page o2) {
								return o2.getPageTimeFrom().compareTo(o1.getPageTimeFrom());
							}
						});						
					}
				} else {
					// not support...
				}
			} else if("TopOpt".equals(typeAndValue[0])) {
				String[] options = typeAndValue[1].split("\\^");
				topOption = "<option value='" + (options.length == 2 ? options[1] : "") + "'>" + options[0] + "</option>";
			}
			
		}
	}
%>
<c:set var="pages" value="<%=pages %>"></c:set>
<c:set var="selPageId" value="<%=selPageId %>"></c:set>
<tr class="datafield">
    <td class="label" style="vertical-align:top;"><%=fpm.getLabel() %>: </td>
    <td class="field <%=fpm.getType() %>" fid="<%=fpm.getName() %>">
        <select id="<%=fpm.getName() %>" name="<%=fpm.getName() %>" class="spgsel">
            <%=topOption %>
            <c:forEach items="${pages}" var="_page">
            	<option value='${_page.id}' ${_page.id eq selPageId ? ' selected' : '' }>${_page.name}</option>
            </c:forEach>         
        </select>
    </td>
</tr>