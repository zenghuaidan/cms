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
	String txtval = (fieldData == null) ? fpm.getDefaultValue() : fieldData.getTextTrim();	   
%>
<script>
    function adjustVaule(id) {
        var elements = $("#" + id).parent().find(".multi-values");
        var values = new Array();
        for (var i = 0; i < elements.length; i++) {
            if ($.trim(elements.eq(i).val()) != "") {
                values.push($.trim(elements.eq(i).val()));
            }
        }
        $("#" + id).val(JSON.stringify(values));
        console.log($("#" + id).val());
    }
    function add(e, id) {
        var tr = $(e).parent().parent().clone();
        tr.find(".multi-values").val("");
        $(e).parent().parent().after(tr);
        adjustVaule(id);
    }
    function del(e, id) {
        if ($(e).parent().parent().parent().find('tr').length > 1) {
            $(e).parent().parent().remove();
        } else {
            $(e).parent().parent().find(".multi-values").val("");
        }
        adjustVaule(id);
    }
    $(function () {
        var valueElement = $('#<%=fpm.getName() %>');
        var value = valueElement.val();
        if ($.trim(value) != "") {
            var elements = eval(value);
            var rowTemplate = valueElement.parent().find("tr");
            for (var i = 1; i < elements.length; i++) {
                valueElement.next("table").append(rowTemplate.clone());
            }
            for (var i = 0; i < elements.length; i++) {
                valueElement.parent().find(".multi-values").eq(i).val(elements[i]);
            }
        }
    });
</script>
<tr class="datafield">
    <td class="label" style="vertical-align:top;"><%=fpm.getLabel() %>: </td>
    <td class="field <%=fpm.getType() %>" fid="<%=fpm.getName() %>">
        <input type='hidden' id="<%=fpm.getName() %>" name="<%=fpm.getName() %>" value="@Html.Raw(txtval)"  />
        <table>
            <tr>
                <td><input onblur="adjustVaule('<%=fpm.getName() %>');" class="multi-values" type='text' style="<%=fpm.getStyle() %>" /></td>
                <td><img onclick="add(this, '<%=fpm.getName() %>');" src="${Content}/cms/core/images/eplus.png" class="img-scale" /></td>
                <td><img onclick="del(this, '<%=fpm.getName() %>');" src="${Content}/cms/core/images/cminus.png" class="img-scale" /></td>
            </tr>
        </table>        
        <%=fpm.getRemark() %>
    </td>
</tr>