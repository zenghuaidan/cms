@model System.Xml.XmlNode
@{

    Layout = null;
    System.Xml.XmlNode dataw = (System.Xml.XmlNode)ViewData["dataw"];
    System.Xml.XmlNode wdef = (System.Xml.XmlNode)ViewData["wdef"];
    Dictionary<string, string> fpm = CmsWebCore.Cms.LogicCms.getFieldCommon(Model,wdef);
    string chkvals = (dataw == null) ? fpm["fdefval"] : CmsWebCore.Common.Helper.getFieldRaw(dataw, fpm["fname"]);   
    List<String> chkvalList = chkvals.Split(new char[] { ';' }).ToList();
    String fieldAttr = String.IsNullOrEmpty((String)ViewData["dbFieldAttr"]) ? Model.Attributes["FieldAttr"].Value : ViewData["dbFieldAttr"].ToString();
}

<tr class="datafield">
    <td class="label" style="vertical-align:top;">@fpm["flabel"]:</td>
    <td class="field @fpm["ftype"]" fid="@fpm["fname"]">
        <input type="hidden" id="@fpm["fname"]" name="@fpm["fname"]" value="@chkvals" />
        @{
            string[] opts = String.IsNullOrEmpty(fieldAttr) ? new string[] { } : fieldAttr.Split(',');
            foreach (string o in opts)
            {
                string[] b = o.Split('^');
                String sel = chkvalList.Contains(b[0]) ? "checked" : string.Empty;
                <input type="checkbox" value='@b[0]' @sel  disabled/>@b[1] 
            }
        }
    </td>
</tr>