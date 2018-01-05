@model System.Xml.XmlNode
@{
    Layout = null;
    System.Xml.XmlNode dataw = (System.Xml.XmlNode)ViewData["dataw"];
    System.Xml.XmlNode wdef = (System.Xml.XmlNode)ViewData["wdef"];
    Dictionary<string, string> fpm = CmsWebCore.Cms.LogicCms.getFieldCommon(Model,wdef);
    string txtval = (dataw == null) ? fpm["fdefval"] : CmsWebCore.Common.Helper.getFieldRaw(dataw, fpm["fname"]);
    txtval = txtval.Replace("\"", "&quot;");
    int ptid = int.Parse(Request.QueryString["pageid"]);
    string selpgid = vfunc.wfattr(dataw, fpm["fname"], "pgid");
    CmsWebCore.Models.CmsWebEntities db = new CmsWebCore.Models.CmsWebEntities();
    CmsWebCore.Models.CmsPage pg = db.CmsPage.Find(ptid);
    string topopt = ""; System.Text.StringBuilder spopts = new System.Text.StringBuilder("");
    bool ispecial = false;
    IEnumerable<CmsWebCore.Models.CmsPage> subpgs = null;
    if (fpm["fattr"].Trim() != "")
    {
        string[] alist = fpm["fattr"].Split(',');
        bool setsgs = false;
        foreach (string a in alist)
        {
            string[] b = a.Split(':');
            switch (b[0])
            {
                case "Parent":
                    string[] po = b[1].Split('=');

                    switch (po[0])
                    {
                        case "ThisPg":
                            ptid = pg.PageID;
                            if (b.Length>3 && b[2]=="FixTemplate")
                            {
                                string ftpl = b[3];
                                subpgs = db.CmsPage.Where(g => g.ParentID == ptid && g.template==ftpl && g.isActive && !g.isDel).OrderBy(g => g.pgorder);
                                setsgs = true;
                            }
                            break;
                        case "PageID": ptid = int.Parse(po[1]); break;
                        case "Template":
                            string  template = po[1];
                            subpgs = db.CmsPage.Where(g => g.template == template && g.isActive && !g.isDel).OrderBy(g => g.name);
                            setsgs = true;
                            break;
                        case "TemplateAfterSpecifyYears":
                            string template1 = po[1].Split('^')[0];
                            int year = int.Parse(po[1].Split('^')[1]);
                            DateTime twoYearsBefore = DateTime.Now.AddYears(year);
                            subpgs = db.CmsPage.Where(g => g.template == template1 && g.isActive && !g.isDel && twoYearsBefore.CompareTo(g.pgtimei) <= 0).OrderBy(g => g.name);
                            setsgs = true;
                            break;
                    }
                    break;
                case "Special":
                    ispecial = true;
                    //TODO
                    break;
                case "TopOpt":
                    string[] to = b[1].Split('^');
                    topopt = "<option value='"+to[1]+"'>"+to[0]+"</option>";
                    break;
            }

            if (!ispecial && !setsgs)
            {
                subpgs = db.CmsPage.Where(g => g.ParentID == ptid && g.isActive && !g.isDel).OrderBy(g=>g.pgorder);
            }
        }
    }
    }
<tr class="datafield">
    <td class="label" style="vertical-align:top;">@Html.Raw(fpm["flabel"]): </td>
    <td class="field @fpm["ftype"]" fid="@fpm["fname"]">
        <select id="@fpm["fname"]" name="@fpm["fname"]" class="spgsel">
            @Html.Raw(topopt)
            @if (ispecial) { //TODO
                @Html.Raw(spopts.ToString())
            } else if (subpgs!=null)  {
                foreach (CmsWebCore.Models.CmsPage subpg in subpgs) {
                    string sel = (selpgid==subpg.PageID.ToString())?" selected":"";
                    <option value="@(subpg.PageID)" @sel>@(subpg.name)</option>
                }
            }
        </select>
    </td>
</tr>