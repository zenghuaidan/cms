<%@page import="org.apache.commons.lang3.StringUtils"%>
<%@page import="com.edeas.controller.cmsadmin.CmsProperties"%>
<%@page import="com.edeas.web.InitServlet"%>
<%@page import="org.springframework.ui.Model"%>
<%@page import="com.edeas.controller.Global"%>
<%@page import="com.edeas.service.impl.*"%>
<%@page import="com.edeas.model.*"%>
<%@page import="java.util.*"%>
<%@include file="/WEB-INF/Shared/commons.jsp" %>
<%@page contentType="text/html;charset=UTF-8"%>
<link href="${Content}/cms/core/siteadmin.css" rel="stylesheet" type="text/css" />
<script src="${Script}/usrprivileges.js" type="text/javascript"></script>

<%	
	QueryServiceImpl queryService = InitServlet.getQueryService();
	Page homePage = queryService.getHomePage(true);	
	List<? extends Page> bottomPages = queryService.getBottomPages(true);	
	List<? extends Page> topPages = queryService.getAllTopPage(true, true);	
	List<? extends Page> otherPages = queryService.getOtherPages(true);	
	User user = (User)request.getAttribute("user");
	List<Privilege> privileges = (List<Privilege>)request.getAttribute("privileges");
%>

<style>
#cmsheader, #cmstopmenu, #admintopheader, #pgtopmenu, #langtabhdr, #propertybox {
    font-size: 13px;
    font-family: Arial;
    letter-spacing: normal;
}
#admintopheader {
    padding: 5px !important;    
}
</style>
<input type="hidden" id="currentUserId" value="${ user.id }"/>
<div id="admintopheader" class="cmspgw hlgradbg" style="">
       <div style="float:left;"><a href="<%=Global.getCMSUrl() + "/UserAdmin/Index" %>" style="margin-left:20px;">Back to User Admin</a></div>
       <div style="float:right; margin-right:20px;">Privileges for user: ${ user.login }</div>
       <div class="clear"></div>
</div>

<div class="clear" style="height:10px;"></div>
<div id="siteadmin" class="cmspgw" roles="${ user.roles }">
    <div id="saguide" class="guideline">
      <div class="block cmsgreybg">
          <div class="lbl">User Privileges </div>
          <c:forEach items="${privileges}" var="privilege" >
          	<div class='itm'>
          		<img class="ico rolebtn ${privilege.name }_active" src="${Content}/images/spacer.gif" alt="${privilege.description}" title="${privilege.description}" /> ${privilege.description}
          	</div>
          </c:forEach>          
         <div style="float:left; height:1px; width:50px;"></div>
          <!-- for other icons if necessary -->
          <div class="clear"></div>
      </div>
      <div class="clear" style="height:1px;"></div>
    </div>

    <div class="clear" style="height:12px;"></div>
	<!-- HEADER & HOMEPAGE -->
    <div id="saheader">
      <div class="pg">
        <div id="homepage" class="roundall darkgradbg btmshadow" pgid="<%=homePage.getId() %>" style="width:155px;">
		    <%
		    for(Privilege privilege : privileges) {
		    	%>
		    	<c:out escapeXml="false" value="<%=roleico(privilege.getName(), user.hasPageRole(homePage.getId(), privilege), privilege.getDescription()) %>"></c:out>
		    	<%
		    }		       			  
		    %>
		    Homepage
     	</div>
      </div>
    </div>   
    
	<!-- SITEMAP -->
	<%!
		public String roleico(String r, boolean active, String label) {		
	    	String a = (active) ? "active" : "inactive";    
			return "<img class=\"ico rolebtn " + r + "_" + a + "\" src=\"" + Global.getContentPath() + "/images/spacer.gif\" alt=\"" + label + "\" title=\"" + label + "\" />";
		}		
		
		public String pgdiv(int lv, Page page, User pvusr, List<Privilege> pvlist)
	    {
		    String pglv = "p" + lv;
		    int nxtlv = lv + 1;
		    String drpc = "lv" + nxtlv + "drop";
		    int numsubpg = page.getChildren(false).size();
		    StringBuffer html = new StringBuffer();
		    html.append("<div class='" + pglv + " pgblk'>");
		    html.append("<div class='pg' pgid='" + page.getId() + "'>");
		    for(Privilege privilege : pvlist) {
		    	html.append(roleico(privilege.getName(), pvusr.hasPageRole(page.getId(), privilege), privilege.getDescription()));
		    }		        
		    html.append(page.getName());            
	        if (numsubpg > 0) {
	        	html.append("<div class='ico ec expand gradbtn' ec='e'><img class='ec' src='" + Global.getContentPath() + "/images/spacer.gif' alt='' /></div>");
	        }
	        html.append("</div>");
	      	if (numsubpg > 0) {
	      		html.append("<div class='grp newpgdrop " + drpc + "' lv='" + nxtlv + "' style='display: none;'>");      
	      		for(Page sub : (List<Page>)page.getChildren(false)) {
	      			html.append(pgdiv(nxtlv, sub, pvusr, pvlist));
	      		}		        
		        html.append("</div>");   
	      	} else { 	      		
	      		html.append("<div class='sep'></div>");
      		}
	      	html.append("</div>"); 
	      	return html.toString();
		}
	%>
    <div id="topsectors">
    	<%
    		int i = 1;
			for (Page top : topPages)
			{
			    String ico = (top.isActive()) ? "active" : "inactive";
			    String icolb = (top.isActive()) ? "Active" : "Inactive";
			    %>
				<div class="topsect" pgid="<%=top.getId() %>">
				<div class='pg p1' pgid="<%=top.getId() %>">
			    <%
			    for(Privilege privilege : privileges) {
			    	%>
			    	<c:out escapeXml="false" value="<%=roleico(privilege.getName(), user.hasPageRole(top.getId(), privilege), privilege.getDescription()) %>"></c:out>
			    	<%
			    }		       			  
			    %>
			    <%=top.getName() %>
				</div>
				<div class='sectionpglist newpgdrop lv2drop' lv="2">
			    <%
				for (Page sec : (List<Page>)top.getChildren(false))
				{     
			    	%>
			    	<c:out escapeXml="false" value='<%=pgdiv(2, sec, user, privileges) %>'></c:out>
			    	<%
				}
			    %>
			    	</div>
				</div>
			    <%
			  	if (i % 3 == 0 && i != 0) { 
			  		%>
			  			<div class='clear tsclear'></div>
			  		<% 
		  		}
			  	i++;
			}
    	%>
    </div>    
    
	<!-- BOTTOM MENU -->
    <div class='clear'></div>
    <div id="btmmenu" class="fullsect">
      <div class='header' pgid="-2">           
        <%
		    for(Privilege privilege : privileges) {
		    	%>
		    	<c:out escapeXml="false" value="<%=roleico(privilege.getName(), user.hasPageRole(-2, privilege), privilege.getDescription()) %>"></c:out>
		    	<%
		    }
        %>
        Bottom Menu
      </div>
      <div class='grp newpgdrop'>
      	<% 
	        for (Page btmpg : bottomPages)
	        {
	      	%>
	    	<c:out escapeXml="false" value='<%=pgdiv(-2, btmpg, user, privileges) %>'></c:out>
	    	<%
	        }        
      	%>       
      </div>
    </div>

	<!-- OTHER PAGES -->
    <div class='clear' style="height:30px;"></div>
    <div id="othmenu" class="fullsect">
      <div class='header' pgid="-3">           
       <%
		    for(Privilege privilege : privileges) {
		    	%>
		    	<c:out escapeXml="false" value="<%=roleico(privilege.getName(), user.hasPageRole(-3, privilege), privilege.getDescription()) %>"></c:out>
		    	<%
		    }
        %>
        Other Pages
     </div>
      <div class='grp newpgdrop'>
       	<% 
	        for (Page othpg : otherPages)
	        {
	      	%>
	    	<c:out escapeXml="false" value='<%=pgdiv(-2, othpg, user, privileges) %>'></c:out>
	    	<%
	        }        
      	%>
      </div>
      </div>
    </div>

</div>