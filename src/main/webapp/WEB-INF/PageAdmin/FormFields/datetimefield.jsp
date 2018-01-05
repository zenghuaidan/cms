@model System.Xml.XmlNode
@{
    Layout = null;
    System.Xml.XmlNode dataw = (System.Xml.XmlNode)ViewData["dataw"];
    System.Xml.XmlNode wdef = (System.Xml.XmlNode)ViewData["wdef"];
    Dictionary<string, string> fpm = CmsWebCore.Cms.LogicCms.getFieldCommon(Model, wdef);
    string fid = fpm["fname"];
    string txtval = (dataw == null) ? fpm["fdefval"] : CmsWebCore.Common.Helper.getFieldRaw(dataw, fpm["fname"]);
}

<tr class="datafield">
    <td class="label" style="vertical-align:top;">@fpm["flabel"]: </td>
    <td class="field @fpm["ftype"]" fid="@fpm["fname"]">
        @Html.TextBox(fid, txtval, new { id = fid, style = "width:150px" })
    </td>
</tr>