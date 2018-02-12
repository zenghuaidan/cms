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
%>
<script type="text/javascript">	
	function setDateTime(fid) {
		var dateTimeStr = $.trim($("#" + fid).val());
		if (dateTimeStr != '') {
			var dateStr = dateTimeStr.split(" ")[0];
			var timeStr = dateTimeStr.split(" ")[1];
			$("input[name='" + fid + "_year']").val(parseInt(dateStr.split('-')[0]));
			$("input[name='" + fid + "_month']").val(parseInt(dateStr.split('-')[1]));
			$("input[name='" + fid + "_day']").val(parseInt(dateStr.split('-')[2]));
			
			$("input[name='" + fid + "_hour']").val(parseInt(timeStr.split(':')[0]));
			$("input[name='" + fid + "_minute']").val(parseInt(timeStr.split(':')[1]));
		}		
	}
	$(function() {
		setDateTime('<%=fid%>');
	});
</script>
<input type="hidden" name="<%=fid%>_year" value="" />
<input type="hidden" name="<%=fid%>_month" value="" />
<input type="hidden" name="<%=fid%>_day" value="" />
<input type="hidden" name="<%=fid%>_hour" value="" />
<input type="hidden" name="<%=fid%>_minute" value="" />
<tr class="datafield">
    <td class="label" style="vertical-align:top;"><%=fpm.getLabel() %>: </td>
    <td class="field <%=fpm.getType() %>" fid="<%=fpm.getName() %>">
    	<input id="<%=fid%>" name="<%=fid%>" value="<%=txtval%>" style="<%=fpm.getStyle() %>" onchange="setDateTime('<%=fid%>')" />
    </td>
</tr>