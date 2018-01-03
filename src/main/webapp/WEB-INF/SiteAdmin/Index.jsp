<%@page import="com.edeas.controller.cmsadmin.CmsProperties"%>
<%@page import="com.edeas.web.InitServlet"%>
<%@page import="org.springframework.ui.Model"%>
<%@page import="com.edeas.controller.Global"%>
<%@page import="com.edeas.service.impl.*"%>
<%@page import="com.edeas.model.*"%>
<%@page import="java.util.*"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@include file="/WEB-INF/Shared/commons.jspf" %>
<%!	
	QueryServiceImpl queryService = InitServlet.getQueryService();
	private String pgsimg(String status) {
    	if (status == "") { status = "new"; }
	    String pgsc = "pgs" + status;
	    String label = "";
	    switch (status)
	    {
	        case "new": label = "New"; break;
	        case "edit": label = "Editing"; break;
	        case "wait": label = "Waiting for approval"; break;
	        case "live": label = "Live"; break;
	        case "declined": label = "Declined"; break;
	    }	    	    
		return "<img class='pgsdot " + pgsc + "' src='" + Global.getContentPath() + "/images/spacer.gif" + "' alt='" + label + "' title='" + label + "' />";
	} 

	public String icoimg(String icoc, String label) {
		return "<img class='ico " + icoc + "' src='" + Global.getContentPath() + "/images/spacer.gif" + "' alt='" + label + "' title='" + label + "' />";
	}
	
	public String qamenuitm(String icoc, String label) {
		return     
		"<div class='itm' blkid='" + icoc + "'>" + 
        	icoimg(icoc + " qamico", label) +  "<span>" + label + "</span>" +
        	"<img class='arrow' src='" + Global.getContentPath() + "/images/spacer.gif" + "' alt='Expand' title='Expand' />" +
    	"</div>";
	}
	
	//SITEMAP
	public String pgdiv(int lv, long pgid, String status, boolean active, String label)
	{    
	    String roleval = "allow";
	    String pgsc = "pgs" + status;
	    String ico = (active) ? "active" : "inactive";
	    String icolb = (active) ? "Active" : "Inactive";
	    String pglv = "p" + lv;
	    int nxtlv = lv + 1;
	    String drpc = "lv" + nxtlv + "drop";
	    
	    Page page = queryService.findPageById(pgid, true);	    
	    int numsubpg = page.getChildren().size();      
	    String template = page.getTemplate();
		StringBuffer html = new StringBuffer();
		html.append("<div class='" + pglv + " pgblk'>");
		html.append("<div class='pg' pgid='" + pgid + "'>");
		html.append(pgsimg(status));
		html.append(icoimg(ico, icolb));
		html.append("<span status='" + roleval + "'>" + label + "</span>");
        if (!page.isHideSubTpl())
        {
            String nspc = "newsubpg";
            if (numsubpg > 0) { 
                nspc = "ecnewsubpg";
                html.append("<div class='ico ec expand gradbtn' ec='e'>");
                html.append("<img class='ec' src='" + Global.getContentPath() + "/images/spacer.gif" + "' alt='' />");
                html.append("</div>");
            }
           	if ((CmsProperties.getMaxLevel() > lv && lv >=0 )
       			||
                (CmsProperties.getForceChildTpls().containsKey(template) &&
                (CmsProperties.getForceChildTpls().get(template)==-1 || CmsProperties.getForceChildTpls().get(template)>numsubpg))
               )
            {
            	html.append(icoimg(nspc, "New Subpage"));
            }
        }                         
		html.append("</div>");
        if (numsubpg > 0 && !page.isHideSubTpl())
        {            
        	html.append("<div class='grp newpgdrop " + drpc + "' lv='" + nxtlv + "' style='display:none'>");
             if (!CmsProperties.getExcTpls().contains(template))                    
             {
	            for (Page children : (Set<Page>)page.getChildren())
	            {
                	html.append(pgdiv(nxtlv, children.getId(), children.getStatus().getName(), children.isActive(), children.getName()));
                }
            }

        	html.append("</div>");
        }
        else
        { 
        	html.append("<div class='sep'></div>"); 
       	}
        html.append("</div>");
        return html.toString();
	}
%>
<%	
	Page homePage = queryService.getHomePage(true);
	String hpstatus = (homePage == null) ? "new" : homePage.getStatus().getName();
	
	Page masterPage = queryService.getMasterPage(true);
	String masterpgstatus = (masterPage == null) ? "new" : masterPage.getStatus().toString();
	
	List<? extends Page> topPages = queryService.getAllTopPage(true);
	
	List<? extends Page> otherPages = queryService.getOtherPages(true);
	
	boolean moreTopLevel = topPages.size() < CmsProperties.getMaxTopgs();
%>
<c:set var="moreTopLevel" value="<%=moreTopLevel %>"/>
<link href="${Content}/cms/core/siteadmin.css" rel="stylesheet" type="text/css" />
<script src="${Script}/cms/siteadmin.js" type="text/javascript"></script>
<div class="clear" style="height:10px;"></div>
<div id="siteadmin" class="cmspgw" >
	<%@include file="/WEB-INF/Shared/bar_pguide.jspf"%>
	<div class="clear" style="height:12px;"></div>
	<!-- HEADER & HOMEPAGE -->
    <div id="saheader">
        <div class="pg">
            <div id="homepage" class="roundall darkgradbg btmshadow" pgid="-1">
      			<c:out escapeXml="false" value='<%=pgsimg(hpstatus) %>'></c:out>
                <span status="allow">Homepage</span>
            </div>
        </div>
        <div id="sitebtnblk">
            <div id="masterpgbtn" class="cmsbtn" onclick="goUrl('@Url.Content("~/cmsadmin/PageAdmin/Index?id=-2")');">
                <c:out escapeXml="false" value='<%=pgsimg(masterpgstatus) %>'></c:out>             
                <span status="allow">Masterpage</span>
            </div> 
        </div>
        <div id="satopleft">	            
            <c:if test="${ moreTopLevel }">
	            <div id="newtopbtn" class="cmsbtn newtopbtn">New Top Level Page</div>
            </c:if> 	            
        </div>
    </div> 
    <div class="clear" style="height:12px;"></div>         
    
    <!-- Top Blocks -->
    <div id="topsectors">
	    <% 
	    	int i = 0;
	    	for(Page topPage : topPages){
	        	String ico = topPage.isActive() ? "active" : "inactive";
	        	String icolb = topPage.isActive() ? "Active" : "Inactive";        	
	        	Set<Page> subPages = topPage.getChildren(false);
	        	i++;        	
	   	%>    
         <c:set var="i" value="<%=i %>"/>
         <c:set var="topPage" value="<%=topPage %>"/>
	     <div class='topsect' pgid='<%=topPage.getId() %>'>
	         <div class='pg p1' pgid='<%=topPage.getId() %>'>
	         	<c:out escapeXml="false" value='<%=pgsimg(topPage.getStatus().getName()) %>'></c:out>
	         	<c:out escapeXml="false" value='<%=icoimg(ico, icolb) %>'></c:out>                          
	            <span status="allow"><%=topPage.getName() %></span>
	            <c:if test="${!topPage.hideSubTpl}">
	            	<c:out escapeXml="false" value='<%=icoimg("newsubpg", "New Subpage") %>'></c:out>
	            </c:if>                        
	         </div>
	         <c:if test="${!topPage.hideSubTpls}">
		         <div class='sectionpglist newpgdrop lv2drop' lv='2'>
		         	<%
		         		for(Page subPage : subPages) {
		         			if(!subPage.isHideSubTpl()) {
		         				out.print(pgdiv(2, subPage.getId(), subPage.getStatus().getName(), subPage.isActive(), subPage.getName()));
		         			}
	         			} 
	         		%>	             
		         </div>
	         </c:if>   
	          
	     </div>
	     <c:if test="${ i % 3 == 0 && i != 0 }">
	     	<div class='clear tsclear'></div>
	     </c:if>        
    	<% } %>
    </div> <!-- End of topsectors div -->
    <!-- Other Pages -->
    <div class='clear' style="height:15px;"></div>
    <div id="btmmenu" class="fullsect">
        <div class='header' pgid="-3">
            <span>Other Pages</span>
            <c:out escapeXml="false" value='<%=icoimg("newsubpg", "New Subpage") %>'></c:out>
        </div>
        <div class='grp newpgdrop'>
        <%
    		for(Page otherPage : otherPages) {
    			if(!otherPage.isDelete()) {
    				out.print(pgdiv(-3, otherPage.getId(), otherPage.getStatus().getName(), otherPage.isActive(), otherPage.getName()));
    			}
   			} 
   		%>	
        </div>
    </div>
</div>	
	