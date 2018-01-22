<%@page import="org.apache.commons.lang3.StringUtils"%>
<%@page import="com.edeas.web.InitServlet"%>
<%@page import="com.edeas.model.Lang"%>
<%@page import="com.edeas.utils.XmlUtils"%>
<%@page import="org.dom4j.Document"%>
<%@page import="org.dom4j.Node"%>
<%@page import="org.dom4j.Element"%>
<%@page import="com.edeas.model.Page"%>
<%@page import="com.edeas.model.Content"%>
<%@page import="java.util.*"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@include file="/WEB-INF/Shared/commons.jsp" %>
<!-- Styles -->
<link href="${Content}/cms/core/pageadmin.css" rel="stylesheet" type="text/css" />
<!-- App Web CSS -->
<%@include file="/WEB-INF/Shared/MasterCss.jspf" %>
<!-- App Web Style Adjust -->
<link href="${Content}/cms/adminadjust.css" rel="stylesheet" type="text/css" />
<style>
    .newWdropbox { margin-bottom:30px; }
    #body header { position:absolute; }
    #propertybox h2 { font-size: 12px !important; }
</style>
<!-- Javascripts -->
<script src="${Script}/jquery.form.min.js"></script>
<script src="${Script}/cms/pageadmin.js" type="text/javascript"></script>
<script type="text/javascript">
    var pageid = "${currentPage.id}";
    var tobedel = ${currentPage.reqDelete ? "true" : "false"};
    var isinactive = ${currentPage.active ? "false" : "true"}; 

    function refreshSiteTree() { refresh(); }
    $(document).ready( function() {
        $("body").addClass("fontM");
    })
</script>

<!-- HTML -->
<div class="clear" style="height:10px;"></div>
<!-- STATUS / WORKFLOW BAR -->
<%    
	String lang = (String)request.getAttribute("lang");
    String apply = "Apply";
    String applybtn1 = "btnapplytc"; 
    String applylbl1 = apply + " 繁體";
    String applybtn2 = "btnapplysc"; 
    String applylbl2 = apply + " 简体";
    switch (lang)
    {
        case "tc": applybtn1 = "btnapplyen"; applylbl1 = apply + " English"; applybtn2 = "btnapplysc"; applylbl2 = apply + " 简体"; break;
        case "sc": applybtn1 = "btnapplyen"; applylbl1 = apply + " English"; applybtn2 = "btnapplytc"; applylbl2 = apply + " 繁體"; break;
    }
	Page currentPage = (Page)request.getAttribute("currentPage");
	String templatePath = request.getRequestURL().toString().replaceAll(request.getRequestURI(), "") + Global.getCMSUrl() + "/" + lang + "/viewPage/" + currentPage.getId();	
	Content currentContent = (Content)currentPage.getContent(lang);
%>
<%!
	public String pgbtn(String id, String lbl, boolean isfirst){
		StringBuffer sb = new StringBuffer();
		if(!isfirst) sb.append("<div class='btnsep'></div>");
		sb.append("<div id='" + id + "' class='icobtn whitefontover'>" + lbl + "</div>");
		return sb.toString();
	}
%>
<div id='pgtopmenu' class="cmspgw">
    <table width="100%" class="darkbg">
        <tr>
            <td>Release: ${currentPage.release}.${currentPage.edit}</td>
            <td>Status: ${currentPage.status}</td>            
            <td style="text-align: right;">LastUpdateTime: <fmt:formatDate value="${ currentPage.updateTime }" pattern="dd-MM-yyyy HH:mm" /></td>
        </tr>
    </table>
    <div id="pgfuncbar" class="darkbg">
        <div class="left darkgradbg btmshadow">
        	<c:out escapeXml="false" value='<%=pgbtn("btnpublish", "Publish", true) %>'></c:out>
        	<c:choose>
        		<c:when test="${currentPage.release <= 0}">
                	<c:out escapeXml="false" value='<%=pgbtn("btndelete", "Delete", false) %>'></c:out>
        		</c:when>
        		<c:when test="${!currentPage.reqDelete}">
                	<c:out escapeXml="false" value='<%=pgbtn("btnreqdel", "MarkDelete", false) %>'></c:out>
        		</c:when>
        		<c:when test="${currentPage.reqDelete}">
            		<c:out escapeXml="false" value='<%=pgbtn("btnundoreqdel", "UnmarkDelete", false) %>'></c:out>
        		</c:when> 
      		    <c:otherwise>
        		</c:otherwise>        		       		
        	</c:choose>        	
        </div>
        <div class="right darkgradbg btmshadow">
       		<c:out escapeXml="false" value='<%=pgbtn(applybtn1, applylbl1, true) %>'></c:out>
       		<c:out escapeXml="false" value='<%=pgbtn(applybtn2, applylbl2, false) %>'></c:out>
       		<c:if test="${!currentPage.masterPage}">
       			<c:out escapeXml="false" value='<%=pgbtn("btnconfig", "Config", false) %>'></c:out>
       		</c:if>
            <c:if test="${!currentPage.noPreviewTpl}">
            	<c:out escapeXml="false" value='<%=pgbtn("btnpreview", "Preview", false) %>'></c:out>
            </c:if>                    
            </div>
        </div>
</div>
<div class="clear" style="height:20px;"></div>

<!-- LANGUAGE TABS -->
<div id="langtabhdr" class="pgw cmstabhdr" template="${currentPage.template}">
	<%
		for(Lang labbr : Lang.orderList()) {
	        String c = (lang.equals(labbr.getName())) ? "selcmstab" : "cmstab";
	        String a = (lang.equals(labbr.getName())) ? "" : "goUrl(\"" + Global.getCMSUrl() + "/PageAdmin/Index?id=" + currentPage.getId() + "&lang=" + labbr + "\");";	        
	        out.print("<div class='" + c + "' onclick='" + a + "'>" + labbr.getDescription() + "<img class='arrow' src='" + Global.getContentPath() + "/images/spacer.gif' alt='Selected' /></div>");			
		}
	%>
    <div class="clear"></div>
</div>

<!-- Page Admin -->
<div id="langpg" class="pgw">
    <!-- PROPERTY BOX -->
    <div id="propertybox">
 		<jsp:include page="/WEB-INF/PageAdmin/PropertyForm.jsp" />
    </div >

    <!--PAGE-->
    <div id="cmspage" pgid="${currentPage.id}" lang = "${lang}" class="<%=Global.langClass(lang) %> font-aa">
    	<c:choose>
	    	<c:when test="${currentPage.noContentTpl }">
	                <div style = "width: 100%-6px; padding: 80px 0; font-size: 16px; border:dashed 3px #ccc; color:#999; text-align: center; " > NO CONTENT FOR THIS TEMPLATE</div>
	    	</c:when>
	    	<c:otherwise>
                <div id="body">                                	
                	<c:import url="<%=templatePath%>">
                		<c:param name="sessionId" value="<%=request.getSession().getId() %>"/>
                	</c:import> 
                </div>
	    	</c:otherwise>
    	</c:choose>        
    </div>
</div>

<!-- Dynamic Scripts -->
<%
	Document txml = XmlUtils.getTemplateDocument(currentPage.getTemplate());
    List<Element> wlist = (List<Element>)txml.selectNodes("/Template/Widgets/Widget");    
    Document cxml = (currentContent == null) ? null : currentContent.getContentXmlDoc();

    int holderc = 0; 
    String tab = "    ";
    StringBuilder jsb = new StringBuilder("");
    for (Element w : wlist)
    {
        String jsel = w.attributeValue("jsel");
        String wname = w.attributeValue("ename");
        String wid = w.attributeValue("wid");        
        Element wgt = (cxml == null) ? null : (Element)cxml.selectSingleNode("/PageContent/Widget[@name='" + wname + "']");
        String wxid = XmlUtils.getFieldAttr(wgt, "id", "new");
        String newlb = (StringUtils.isBlank(XmlUtils.getFieldAttr(w, "newlb"))) ? "null" : "'" + XmlUtils.getFieldAttr(w, "newlb") + "'";
        String mgrtype = ""; 
        String mgrattr = "";
        if ("WidgetListMgr".equals(wid))
        {
            mgrtype = w.attributeValue("mgrtype");
            mgrattr = w.attributeValue("mgrattr");
            jsb.append(tab + "setWysWidgetListBtn('" + jsel + "','" + wxid + "','" + wname + "','" + mgrtype + "','" + mgrattr + "'," + newlb + ");\r\n");
        }
        else if ("yes".equals(XmlUtils.getFieldAttr(w, "isDynLst").toLowerCase()))
        {
        	mgrtype = w.attributeValue("mgrtype");
            mgrattr = w.attributeValue("mgrattr");
            jsb.append(tab + "setDynWysWidgetListBtn('" + jsel + "','" + wid + "','" + wxid + "','" + wname + "','" + mgrtype + "','" + mgrattr + "'," + newlb + ");\r\n");
        }
        else if ("WidgetHolder".equals(wid))
        {
            String pid = (wgt == null || StringUtils.isBlank(XmlUtils.getFieldAttr(wgt.getParent(), "id"))) ? "root" : XmlUtils.getFieldAttr(wgt.getParent(), "id");
            String widclass = "wholder-" + wname;
            List<Element> achilds = (List<Element>)w.selectNodes("AcceptWidget");
            StringBuilder acj = new StringBuilder("[");
            for (Element ac : achilds)
            {
                String acwid = ac.attributeValue("wid");
                String acenm = ac.attributeValue("ename");
                String aclbl = ac.attributeValue("label");
                if (!acj.toString().equals("[")) { acj.append(","); }
                acj.append("{ \"wid\":\"" + acwid + "\", \"wname\":\"" + acenm + "\", \"label\":\"" + aclbl + "\" }");
            }
            acj.append("]");
            jsb.append("setWysNewWidgetBoxBtn('" + jsel + "','" + wxid + "','" + wname + "','" + pid + "'," + acj.toString() + ");\r\n");            
            Element hdnode = (cxml == null) ? null : (Element)cxml.selectSingleNode("/PageContent/Widget[@name='" + wname + "']");
            List<Element> wdnodes = (hdnode == null) ? null : (List<Element>)hdnode.selectNodes("Widget");
            int hwc = 0;            
            if (wdnodes != null && wdnodes.size() > 0)
            {
                for (Element wd : wdnodes)
                {
                    jsel = "." + widclass + " .widget:eq(" + hwc + ")";
                    wxid = wd.attributeValue("id");
                    wname = wd.attributeValue("name");
                    wid = wd.attributeValue("wid");
                    newlb = "null";
                    Element aw = (Element)w.selectSingleNode("AcceptWidget[@ename='" + wname + "']");                   
                    if (aw.attributeValue("isDynLst", "").toLowerCase() == "yes")
                    {                        
                        mgrtype = aw.attributeValue("mgrtype");
                        mgrattr = aw.attributeValue("mgrattr");
                        jsb.append("setDynWysWidgetListBtn('" + jsel + "','" + wid + "','" + wxid + "','" + wname + "','" + mgrtype + "','" + mgrattr + "'," + newlb + ");\r\n");
                    }
                    else
                    {
                        jsb.append("setWysWidgetBtn('" + jsel + "','" + wxid + "','" + wname + "','" + wid + "'," + newlb + ");\r\n");
                    }
                    hwc++;
                }
            }
            holderc++;
        }
        else
        {
            jsb.append("setWysWidgetBtn('" + jsel + "','" + wxid + "','" + wname + "','" + wid + "'," + newlb + ");\r\n");
        }
    }
%>


<!-- JAVASCRIPT -->
<script type="text/javascript">

	$(document).ready( function() {
	    <%=jsb%>
		runPgAdminJSetup();
	});
</script>