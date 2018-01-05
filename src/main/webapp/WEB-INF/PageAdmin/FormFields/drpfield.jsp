@model System.Xml.XmlNode
@{
    Layout = null;
    System.Xml.XmlNode dataw = (System.Xml.XmlNode)ViewData["dataw"];
    System.Xml.XmlNode wdef = (System.Xml.XmlNode)ViewData["wdef"];
    Dictionary<string, string> fpm = CmsWebCore.Cms.LogicCms.getFieldCommon(Model,wdef);

    string val = (dataw == null) ? fpm["fdefval"] : CmsWebCore.Common.Helper.getFieldRaw(dataw, fpm["fname"]);

    string fopts = (Model.Attributes["opts"] == null) ? "" : Model.Attributes["opts"].Value;
    if (wdef != null && wdef.Attributes[fpm["fname"] + "Opts"] != null) { fopts = wdef.Attributes[fpm["fname"] + "Opts"].Value; }
    fopts = !String.IsNullOrEmpty((String)ViewData["dbFieldAttr"]) ? ViewData["dbFieldAttr"].ToString() : fopts;
    string[] opts = String.IsNullOrEmpty(fopts) ? new string[] { } : fopts.Split(',');

    List<String> _opts = opts.ToList();
    _opts.Sort((x, y) =>
    {
        if (x.Contains("--Please Select--"))
            return -1;
        if (y.Contains("--Please Select--"))
            return 1;
        return x.Split('^')[1].CompareTo(y.Split('^')[1]);
    });
}
<tr class="datafield">
    <td class="label" style="vertical-align:top;">@fpm["flabel"]: </td>
    <td class="field @fpm["ftype"]" fid="@fpm["fname"]">
        <select id="@fpm["fname"]" name="@fpm["fname"]" style="@fpm["fstyle"]">
        @foreach (string ot in _opts)
        {
            string[] o = ot.Split('^');
            string sel = (val == o[0]) ? " selected" : "";
            <option value="@o[0]" @sel>@o[1]</option>
        }
        </select>
        @Html.Raw(fpm["fremark"])
    </td>
</tr>