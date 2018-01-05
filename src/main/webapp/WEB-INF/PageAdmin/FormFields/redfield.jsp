@model System.Xml.XmlNode
@{
    Layout = null;
    System.Xml.XmlNode dataw = (System.Xml.XmlNode)ViewData["dataw"];
    System.Xml.XmlNode wdef = (System.Xml.XmlNode)ViewData["wdef"];
    Dictionary<string, string> fpm = CmsWebCore.Cms.LogicCms.getFieldCommon(Model,wdef);
    string htmval = (dataw == null) ? fpm["fdefval"] : CmsWebCore.Common.Helper.getFieldRaw(dataw, fpm["fname"]);
}
<tr class="datafield">
    <td colspan="2" class="label" style="text-align:center;">@fpm["flabel"]</td>
</tr>
<tr class="datafield">
	<td colspan="2" class="field @fpm["ftype"]" fid="@fpm["fname"]">
        <textarea id="@fpm["fname"]" name="@fpm["fname"]" attrs="@fpm["fattr"]" style="@fpm["fstyle"]">@Html.Raw(htmval)</textarea>
	</td>
</tr>