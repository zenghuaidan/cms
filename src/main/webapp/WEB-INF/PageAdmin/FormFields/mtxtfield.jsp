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
	String txtval = (fieldData == null) ? fpm.get("fdefval") : XmlUtils.getFieldRaw(fieldData, fpm.get("fname"));	   
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
        var valueElement = $('#<%=fpm.get("fname") %>');
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
    <td class="label" style="vertical-align:top;"><%=fpm.get("flabel") %>: </td>
    <td class="field <%=fpm.get("ftype") %>" fid="<%=fpm.get("fname") %>">
        <input type='hidden' id="<%=fpm.get("fname") %>" name="<%=fpm.get("fname") %>" value="@Html.Raw(txtval)"  />
        <table>
            <tr>
                <td><input onblur="adjustVaule('<%=fpm.get("fname") %>');" class="multi-values" type='text' style="<%=fpm.get("ftype") %>" /></td>
                <td><img onclick="add(this, '<%=fpm.get("fname") %>');" src="${Content}/cms/core/images/eplus.png" class="img-scale" /></td>
                <td><img onclick="del(this, '<%=fpm.get("fname") %>');" src="${Content}/cms/core/images/cminus.png" class="img-scale" /></td>
            </tr>
        </table>        
        <%=fpm.get("fremark") %>
    </td>
</tr>