<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@page import="com.edeas.service.impl.QueryServiceImpl"%>
<%@page import="com.edeas.controller.cmsadmin.CmsProperties"%>
<%@page import="org.apache.commons.lang3.StringUtils"%>
<%@page import="com.edeas.web.InitServlet"%>
<%@page import="java.util.*"%>
<%@page import="com.edeas.model.Page"%>
<html xmlns="http://www.w3.org/1999/xhtml">
	<head>		
		<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
		<%@include file="/WEB-INF/Shared/commons.jsp" %>
		
	    <title><%=com.edeas.controller.cmsadmin.CmsProperties.getCMSSiteName() %> CMS : ${ title }</title>
    	<link href="${Content}/cms/core/cms.css" rel="stylesheet" type="text/css" />
    	<link href="${Content}/cms/cmsstyle.css" rel="stylesheet" type="text/css" />
    	<link href="${Content}/cms/appcms.css" rel="stylesheet" type="text/css" />
    
    	<script src="//code.jquery.com/jquery-1.12.1.min.js"></script>
    	<script src="//code.jquery.com/ui/1.12.1/jquery-ui.min.js"></script>

    	<script src="${Script}/cms/common.js")" type="text/javascript"></script> 
	    	
		<script type="text/javascript" src="${context}/dwr/engine.js"></script>
		<script type="text/javascript" src="${context}/dwr/interface/dwrService.js"></script> 
	</head>
	<body id="cmsbody" class="">		
	    <div id="cmsheader" class="cmspgw cmstyle">
	        <img id="cmslogo" src="${Content}/cms/core/images/logo-edeas.svg" alt="logo" />
	        <h1 class="bigfont"><%=com.edeas.controller.cmsadmin.CmsProperties.getCMSSiteName() %> Content Management System</h1>
	        <div id="toprightbox">
	            <div class='top cmslightgreybg'>
	                <span class="txtlnk" onclick="openchgpwd();">Change Password</span>
	                |
	                <span class="txtlnk" onclick="goUrl('<%=Global.getCMSUrl() %>/j_spring_security_logout');">Logout</span>
	            </div>
	            <div class='bottom hlcolor'>
	                <sec:authentication property="name"/>
	            </div>
	        </div>
	    </div>
	    <div class="clear" style="height:10px"></div>
	    <c:set var="menuSelected" value="cmstmitm_sel hlgradbg btmshadow bigfont" />
	    <c:set var="menuDeselected" value="cmstmitm bigfont" />
	    <div id="cmstopmenu" class="cmspgw cmstyle cmsdarkgreybg">
	    <%!
	    	public String top(String title, String link, String me, String navigation) {
	    		navigation = StringUtils.isBlank(navigation) ? "Website" : navigation;
	    		boolean selected = me.equals(navigation);
	    		String c = selected ? "cmstmitm_sel hlgradbg btmshadow bigfont" : "cmstmitm bigfont";
	    		return "<div class='" + c + "' onclick='goUrl(\"" + link + "\")'>" + title + "</div>";
	    	}
	    %>
	    <%
	    	QueryServiceImpl queryService = InitServlet.getQueryService();
	    	String navigation = (String)request.getAttribute("navigation");
	    %>
	    	<c:out escapeXml="false" value='<%=top("Website", Global.getCMSUrl() + "/SiteAdmin", "Website", navigation) %>'></c:out>
	    	<%
	    		List<Page> pages = queryService.findPageByTemplates(CmsProperties.articleBaseTpls.keySet().toArray(new String[]{}), true, true);
	    		for(Page _page : pages) {	    			
	    	%>
	    		<c:out escapeXml="false" value='<%=top(_page.getName(), Global.getCMSUrl() + "/PageAdmin/FixPIDArticles?fixpid=" + _page.getId(), "FixPIDArticles-" + _page.getId(), navigation) %>'></c:out>
	    	<%		
	    		}
	    	%>
			<!-- todo -->  		
	    </div>
	    <div class="clear"></div>
	    <div>
	        <sitemesh:write property='body'/> 
	    </div>
	    <div class="clear"></div>
	    <div id="cmsfooter" class="cmspgw">
	        Developed By &copy; Edeas Limited
	    </div>
	    <div id="cmslayerpool" style="display:none;">
	        <div class="chgpwdform">	        
	            <h2>Change Password</h2>
	            <div class="table">
	                <div class="label">Old Password</div> <div class="value"><input name="oldpwd" class="reqtxt" type="password" value="" reqmsg="Old Password is requried"/></div>
	                <div class="clear"></div>
	                <div class="label">New Password</div> <div class="value"><input name="newpwd" class="reqtxt" type="password" value="" reqmsg="New Password is required" /></div>
	                <div class="clear"></div>
	                <div class="label">Retype Password</div> <div class="value"><input name="retypepwd" class="reqtxt" type="password" value="" reqmsg="Please Re-Type New Password" /></div>
	                <div class="clear"></div>
	                <div class="btnrow">
	                    <div class="gradbtn roundall" onclick="submitchgpwd()">Save</div>
	                    <div class="gradbtn roundall" onclick="closechgpwd();">Cancel</div>
	                    <div class="gradbtn roundall" onclick="clearchgpwd();">Clear</div>
	                    <div class="errmsg"></div>
	                </div>
	            </div>
	            <img class="bigicon" src="${Content}/images/spacer.gif" alt="Icon" />
	            <img class="close" src="${Content}/images/spacer.gif" alt="Close" />
	        </div>
	    </div>
	</body>
</html>