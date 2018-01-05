@model System.Xml.XmlNode
@{
    Layout = null;
    System.Xml.XmlNode dataw = (System.Xml.XmlNode)ViewData["dataw"];
    System.Xml.XmlNode wdef = (System.Xml.XmlNode)ViewData["wdef"];
    Dictionary<string, string> fpm = CmsWebCore.Cms.LogicCms.getFieldCommon(Model,wdef);
    System.Xml.XmlNode dataf = CmsWebCore.Common.Helper.getWidgetField(dataw, fpm["fname"]);
    string val = CmsWebCore.Common.Helper.getFieldRaw(dataw, fpm["fname"]);

    string lnktype = CmsWebCore.Common.Helper.getFieldAttr(dataf, "lnktype");
    string lnktarget = CmsWebCore.Common.Helper.getFieldAttr(dataf, "target");
    string lnkanchor = CmsWebCore.Common.Helper.getFieldAttr(dataf, "anchor");
    string nwsel = (lnktarget == "_blank") ? " SELECTED" : "";
    string extchk = ""; string intchk = ""; string dochk = "";
    switch (lnktype)
    {
        case "external": extchk = " CHECKED"; break;
        case "internal": intchk = " CHECKED"; break;
        case "document": dochk = " CHECKED"; break;
    }
    string intval = (lnktype == "internal") ? val : "";
    string extval = (lnktype == "external") ? val : "";
    string docval = (lnktype == "document") ? val : "";

    string intattr = (wdef==null || wdef.Attributes[fpm["fname"]+"IntAttr"] == null) ? "" : wdef.Attributes[fpm["fname"] + "IntAttr"].Value;    

}
<tr class="datafield">
    <td class="label" style="vertical-align:top;">@fpm["flabel"] : 
        <br /><select id="@(fpm["fname"])_target" name="@(fpm["fname"])_target">
                <option value="">Standard</option>
                <option value="_blank" @nwsel >New Window</option>
        </select>
        <br />Anchor:
        <br /><input type="text" id="@(fpm["fname"])_anchor" name="@(fpm["fname"])_anchor"
                     value="@lnkanchor" style="width:100px;" />
    </td>
    <td class="field @fpm["ftype"]" fid="@fpm["fname"]">
        <input type='hidden' id="@fpm["fname"]" name="@fpm["fname"]" class="lnkvalfield" value="@val" />
        <input type="radio" id="@(fpm["fname"])_type_document" name="@(fpm["fname"])_type" value="nolink" />
        <span>None</span>
        <br /><input type="radio" id="@(fpm["fname"])_type_internal" name="@(fpm["fname"])_type" value="internal" @intchk />
        <span>Internal:
            <select class="selpages internal_link" id="@(fpm["fname"])_internal_page" name="@(fpm["fname"])_internal_page"
                    fid="@fpm["fname"]" val="@Html.Raw(intval)" attr="@intattr">
            </select>
        </span>
        
        <br /><input type="radio"  id="@(fpm["fname"])_type_external" name="@(fpm["fname"])_type" value="external" @extchk />
        <span>
            External: 
            <input class="external_link" type="text" id="@(fpm["fname"])_external_link" name="@(fpm["fname"])_external_link" fid="@(fpm["fname"])" value="@Html.Raw(extval)" />
        </span>

        <br /><input type="radio" id="@(fpm["fname"])_type_document" name="@(fpm["fname"])_type" value="document" @dochk />
        <span>
            Document: <input class="document_link" type="file" id="@(fpm["fname"])_document_link" name="@(fpm["fname"])_document_link" style="width:200px;" /> 
        </span>
        @if (docval.Trim() != "")
        {
            <input type="button" value="View" onclick="window.open('@vhelp.udoc(Url, docval)');" />
        }
        @Html.Raw(fpm["fremark"])
    </td>
</tr>