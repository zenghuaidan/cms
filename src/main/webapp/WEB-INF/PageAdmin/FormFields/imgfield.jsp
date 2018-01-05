@model System.Xml.XmlNode
@{
    Layout = null;
    System.Xml.XmlNode dataw = (System.Xml.XmlNode)ViewData["dataw"];
    System.Xml.XmlNode wdef = (System.Xml.XmlNode)ViewData["wdef"];
    Dictionary<string, string> fpm = CmsWebCore.Cms.LogicCms.getFieldCommon(Model,wdef);
    string val = CmsWebCore.Common.Helper.getFieldRaw(dataw, fpm["fname"]);
    string alt = CmsWebCore.Common.Helper.getWidgetFieldAttr(dataw, fpm["fname"],"alt");

    System.Text.StringBuilder imgdesc = new System.Text.StringBuilder("<span style='text-transform:none;'>");
    if (fpm["fattr"].Trim()!="")
    {
        string[] alist = fpm["fattr"].Split(',');
        foreach (string a in alist)
        {
            imgdesc.Append("<br />[ ");
            string[] b = a.Split(':');
            string l = b[0];
            switch (l)
            {
                case "fix": l = "Fix dimenaion"; break;
                case "fixw": l = "Fix width"; break;
                case "fixh": l = "Fix height"; break;
                case "max": l = "Max dimension"; break;
                case "maxw": l = "Max width"; break;
                case "maxh": l = "Max height"; break;
                case "samewh": l = "Same width and height"; break;
            }
            imgdesc.Append(l + (b.Length < 2 ? "" :  " : " + b[1]) + " ]");
        }
    }
    imgdesc.Append("<br />[ " + CmsWebCore.Common.GlobalLibrary.getResourceByKey(Server.MapPath("~/"), "ImageSizeNotMoreThan") + " " + CmsWebCore.Common.GlobalVars.IMAGE_MAX_UPLOAD_SIZE + "M ]</span>");
}
<tr class="datafield">
    <td class="label" style="vertical-align:top;">@fpm["flabel"] @Html.Raw(imgdesc.ToString()): </td>
    <td class="field @fpm["ftype"]" fid="@fpm["fname"]">
        <input type='hidden' id="@fpm["fname"]" name="@fpm["fname"]" value="@val" />
        <input type='file' id="@(fpm["fname"])_file" name="@(fpm["fname"])_file" class='imgfield' value="@val" />
        @if (val.Trim() != "")
        {
            <span id="@(fpm["fname"])_view">
                <input type="button" value="View" onclick="popUrl('@Url.Content("~/Content/uploads/images/source/"+val)');" />
                <input type="button" value="Clear" onclick="clrVal('@(fpm["fname"])'); $('#@(fpm["fname"])_view').hide();" />
            </span>
        }                
        <div>
            @vhelp.renderResource(Html, "AltText"): <input type="text" class="altxt" id="@(fpm["fname"])_alt" name="@(fpm["fname"])_alt"
                             fid="@fpm["fname"]" value="@alt" />
        </div>
        @Html.Raw(fpm["fremark"])
    </td>
</tr>