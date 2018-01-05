@model System.Xml.XmlNode
@{
    Layout = null;
    System.Xml.XmlNode dataw = (System.Xml.XmlNode)ViewData["dataw"];
    System.Xml.XmlNode wdef = (System.Xml.XmlNode)ViewData["wdef"];
    Dictionary<string, string> fpm = CmsWebCore.Cms.LogicCms.getFieldCommon(Model,wdef);
    string txtval = (dataw == null) ? fpm["fdefval"] : CmsWebCore.Common.Helper.getFieldRaw(dataw, fpm["fname"]);
    txtval = txtval.Replace("\"", "&quot;");
}
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
        var valueElement = $('#@fpm["fname"]');
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
    <td class="label" style="vertical-align:top;">@fpm["flabel"]: </td>
    <td class="field @fpm["ftype"]" fid="@fpm["fname"]">
        <input type='hidden' id="@fpm["fname"]" name="@fpm["fname"]" value="@Html.Raw(txtval)"  />
        <table>
            <tr>
                <td><input onblur="adjustVaule('@fpm["fname"]');" class="multi-values" type='text' style="@fpm["fstyle"]" /></td>
                <td><img onclick="add(this, '@fpm["fname"]');" src="@Url.Content("~/Content/cms/core/images/eplus.png")" class="img-scale" /></td>
                <td><img onclick="del(this, '@fpm["fname"]');" src="@Url.Content("~/Content/cms/core/images/cminus.png")" class="img-scale" /></td>
            </tr>
        </table>        
        @Html.Raw(fpm["fremark"])
    </td>
</tr>