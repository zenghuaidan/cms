@model System.Xml.XmlNode
@{
    Layout = null;
    System.Xml.XmlNode dataw = (System.Xml.XmlNode)ViewData["dataw"];
    System.Xml.XmlNode wdef = (System.Xml.XmlNode)ViewData["wdef"];
    Dictionary<string, string> fpm = CmsWebCore.Cms.LogicCms.getFieldCommon(Model,wdef);
    string txtval = (dataw == null) ? fpm["fdefval"] : CmsWebCore.Common.Helper.getFieldRaw(dataw, fpm["fname"]);
    txtval = txtval.Replace("\"", "&quot;");
}
<tr class="datafield">
    <td class="label" style="vertical-align:top;">@Html.Raw(fpm["flabel"]): </td>
    <td class="field @fpm["ftype"]" fid="@fpm["fname"]">
        <input type='text' id="@fpm["fname"]" name="@fpm["fname"]" value="@Html.Raw(txtval)" style="@fpm["fstyle"]"  />
        @Html.Raw(fpm["fremark"])
    </td>
</tr>