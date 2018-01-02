<%@page import="com.edeas.controller.cmsadmin.CmsProperties"%>
<%@page import="com.edeas.web.InitServlet"%>
<%@page import="org.springframework.ui.Model"%>
<%@page import="com.edeas.controller.Global"%>
<%@page import="com.edeas.service.impl.*"%>
<%@page import="com.edeas.model.*"%>
<%@page import="java.util.*"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@include file="/WEB-INF/Shared/commons.jspf" %>
<%!
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
%>
<%
	QueryServiceImpl queryService = InitServlet.getQueryService();
	Page homePage = queryService.getHomePage(true);
	String hpstatus = (homePage == null) ? "new" : homePage.getStatus().toString();
	
	Page masterPage = queryService.getMasterPage(true);
	String masterpgstatus = (masterPage == null) ? "new" : masterPage.getStatus().toString();
	
	List<? extends Page> topPages = queryService.getAllTopPage(true);
	
	boolean moreTopLevel = topPages.size() < CmsProperties.getMaxTopgs();
%>
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
	</div>	
	