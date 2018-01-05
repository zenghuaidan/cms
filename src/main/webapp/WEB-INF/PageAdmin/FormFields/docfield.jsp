@model System.Xml.XmlNode
@{
    Layout = null;
    System.Xml.XmlNode dataw = (System.Xml.XmlNode)ViewData["dataw"];
    System.Xml.XmlNode wdef = (System.Xml.XmlNode)ViewData["wdef"];
    Dictionary<string, string> fpm = CmsWebCore.Cms.LogicCms.getFieldCommon(Model,wdef);    
    string val = (dataw == null) ? fpm["fdefval"] : CmsWebCore.Common.Helper.getFieldRaw(dataw, fpm["fname"]);
}
<tr class="datafield">
    <td class="label" style="vertical-align:top;">@fpm["flabel"]: </td>
    <td class="field @fpm["ftype"]" fid="@fpm["fname"]">
        <input type='hidden' id="@fpm["fname"]" name="@fpm["fname"]" class='docvalfield' value="@val" />
        <input type='file' id="@(fpm["fname"])_file" name="@(fpm["fname"])_file" style="@fpm["fstyle"]"  />
        @if (val.Trim() != "")
        {
            <div id="@(fpm["fname"])_view">
                File: @val
                <input type="button" value="View" onclick="window.open('@vhelp.udoc(Url,val)');" />
                <input type="button" value="Clear" onclick="clrVal('@fpm["fname"]'); $('#@(fpm["fname"])_view').hide();" />
            </div>
        }
        @Html.Raw(fpm["fremark"])
    </td>
</tr>