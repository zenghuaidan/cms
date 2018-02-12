<%@page import="com.edeas.dwr.SchemaInfo"%>
<%@page import="org.apache.commons.lang3.StringUtils"%>
<%@page import="com.edeas.utils.XmlUtils"%>
<%@page import="com.edeas.utils.HtmlUtils"%>
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
    if(StringUtils.isBlank(txtval)) {
    	txtval = "00:00-00:00";
    }
    String fromTime = txtval.split("-", 2)[0];
    String toTime = txtval.split("-", 2)[1];
    int fromHour = Integer.parseInt(fromTime.split(":", 2)[0]);
    int fromMinute = Integer.parseInt(fromTime.split(":", 2)[1]);
    
    int toHour = Integer.parseInt(toTime.split(":", 2)[0]);
    int toMinute = Integer.parseInt(toTime.split(":", 2)[1]);
%>

<script type="text/javascript">
	function addZeroPadding(val) {
		if(val.length == 1)
			return "0" + val;
		return val;
	}
	function setTime(fid) {
		$("#" + fid).val(addZeroPadding($("#" + fid + "_fromHour").val()) + ":" 
					+ addZeroPadding($("#" + fid + "_fromMinute").val()) + "-" 
					+ addZeroPadding($("#" + fid + "_toHour").val()) + ":" 
					+ addZeroPadding($("#" + fid + "_toMinute").val()));
		$("input[name='" + fid + "_fromHour']").val($("#" + fid + "_fromHour").val());
		$("input[name='" + fid + "_fromMinute']").val($("#" + fid + "_fromMinute").val());
		$("input[name='" + fid + "_toHour']").val($("#" + fid + "_toHour").val());
		$("input[name='" + fid + "_toMinute']").val($("#" + fid + "_toMinute").val());
	}
	$(function() {
		setTime('<%=fid%>');
	});
</script>

<input type="hidden" id="<%=fid%>" name="<%=fid%>" value="<%=txtval%>" style="<%=fpm.getStyle() %>" />
<input type="hidden" name="<%=fid%>_fromHour" value="" />
<input type="hidden" name="<%=fid%>_fromMinute" value="" />
<input type="hidden" name="<%=fid%>_toHour" value="" />
<input type="hidden" name="<%=fid%>_toMinute" value="" />
<tr class="datafield">
    <td class="label" style="vertical-align:top;"><%=fpm.getLabel() %>: </td>
    <td class="field <%=fpm.getType() %>" fid="<%=fpm.getName() %>">    	    	
		<select id="<%=fid%>_fromHour" onchange="setTime('<%=fid%>')">
		  	<%=HtmlUtils.timeOptions(0, 23, fromHour) %>
		</select>
		<span>:</span>
		<select id="<%=fid%>_fromMinute" onchange="setTime('<%=fid%>')">
			<%=HtmlUtils.timeOptions(0, 59, fromMinute) %>
		</select>
		
		<span>-</span>
		<select id="<%=fid%>_toHour" onchange="setTime('<%=fid%>')">
		   	<%=HtmlUtils.timeOptions(0, 23, toHour) %>
		</select>
		<span>:</span>
		<select id="<%=fid%>_toMinute" onchange="setTime('<%=fid%>')">
			<%=HtmlUtils.timeOptions(0, 59, toMinute) %>
		</select>    	
    </td>
</tr>