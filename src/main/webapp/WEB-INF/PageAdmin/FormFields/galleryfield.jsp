@model System.Xml.XmlNode
@{
    Layout = null;
    System.Xml.XmlNode dataw = (System.Xml.XmlNode)ViewData["dataw"];
    System.Xml.XmlNode wdef = (System.Xml.XmlNode)ViewData["wdef"];
    Dictionary<string, string> fpm = CmsWebCore.Cms.LogicCms.getFieldCommon(Model,wdef);
    string videoId = (dataw == null) ? fpm["fdefval"] : CmsWebCore.Common.Helper.getFieldRaw(dataw, fpm["fname"]);

    CmsWebCore.Models.CmsWebEntities db = new CmsWebCore.Models.CmsWebEntities();
    CmsWebCore.Models.CmsPage pg = db.CmsPage.Where(p => p.template.Equals("Photo")).FirstOrDefault();
    CmsWebCore.Common.CmsWebContent _cpg = CmsWebCore.Common.AppLib.getContent(pg.PageID, "en", true);

    System.Xml.XmlNodeList photos = (_cpg.ContentXml == null) ? null : _cpg.ContentXml.SelectNodes("//Widget[@name='Photos']");
    Dictionary<String, String> photoDic = new Dictionary<String, String>();
    foreach (System.Xml.XmlNode photo in photos)
    {
        System.Xml.XmlNode title = photo.SelectSingleNode("Field[@name='Text']");
        String titleStr = title == null ? string.Empty : title.InnerText;
        photoDic.Add(photo.Attributes["id"].Value, titleStr);
    }
}
<tr class="datafield">
    <td class="label" style="vertical-align:top;">@fpm["flabel"]: </td>
    <td class="field @fpm["ftype"]" fid="@fpm["fname"]">
        <select id="@fpm["fname"]" name="@fpm["fname"]" class="spgsel">
            <option value="">----Please Select----</option>
            @foreach (string id in photoDic.Keys) {
                string sel = (videoId == id) ?" selected":"";
                <option value="@(id)" @sel>@(photoDic[id])</option>
            }
        </select>
    </td>
</tr>