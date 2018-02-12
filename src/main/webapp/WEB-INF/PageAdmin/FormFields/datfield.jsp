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
    String fid = fpm.getName();
    String txtval = (fieldData == null) ? fpm.getDefaultValue() : fieldData.getTextTrim();
    if ("today".equals(txtval)) {
    	txtval = com.edeas.utils.DateUtils.yyyyMMdd().format(new Date());
    }
%>
<script type="text/javascript">	
	function setDate(fid) {
		var dateStr = $.trim($("#" + fid).val());
		if (dateStr != '') {
			$("input[name='" + fid + "_year']").val(parseInt(dateStr.split('-')[0]));
			$("input[name='" + fid + "_month']").val(parseInt(dateStr.split('-')[1]));
			$("input[name='" + fid + "_day']").val(parseInt(dateStr.split('-')[2]));			
		}		
	}
	$(function() {
		setDate('<%=fid%>');
	});
</script>
<input type="hidden" name="<%=fid%>_year" value="" />
<input type="hidden" name="<%=fid%>_month" value="" />
<input type="hidden" name="<%=fid%>_day" value="" />
<tr class="datafield">
    <td class="label" style="vertical-align:top;"><%=fpm.getLabel() %>: </td>
    <td class="field <%=fpm.getType() %>" fid="<%=fpm.getName() %>">
    	<input id="<%=fid%>" name="<%=fid%>" value="<%=txtval%>" style="<%=fpm.getStyle() %>" onchange="setTime('<%=fid%>')" />
    </td>
</tr>