<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@page import="org.apache.commons.lang3.StringUtils"%>
<%@page import="com.edeas.utils.DateUtils"%>
<%@page import="org.dom4j.Element"%>
<%@page import="org.dom4j.Node"%>
<%@page import="com.edeas.utils.XmlUtils"%>
<%@page import="java.util.*"%>
<%@page import="com.edeas.controller.cmsadmin.CmsProperties"%>
<%@page import="com.edeas.model.CmsPage"%>
<%@page import="com.edeas.model.Page"%>
<%@page import="com.edeas.service.impl.*"%>
<%@page import="com.edeas.web.InitServlet"%>
<%@page import="org.dom4j.Document"%>
<%@include file="/WEB-INF/Shared/commons.jspf" %>
<link href="${Content}/cms/core/articleindex.css" rel="stylesheet" type="text/css" />
<style>
    th.colpgo { width:60px; }
    .label 			{ font-size:11px; font-family:arial; color:#fff; padding:3px 5px;
						-webkit-border-radius: 3px;
						   -moz-border-radius: 3px;
						        border-radius: 3px;
                                display: inline-block;
                                text-align: center;
                                margin-right: 20px;
                                width: 100px;
    }
	.label.blue			{ background-color:#003399}
	.label.red			{ background-color:#b20838}
	.label.cyan			{ background-color:#02a9d3}
	.label.green		{ background-color:#80bb47}
	.label.yellow		{ background-color:#e0b300}
</style>
<div class="clear" style="height:10px;"></div>

<%@include file="/WEB-INF/Shared/bar_pguide.jspf"%>
<%
	QueryServiceImpl queryService = InitServlet.getQueryService();
	Page currentPage = (Page)request.getAttribute("currentPage");
	List<Page> children = queryService.findPagesByParentId(currentPage.getId(), true, false);
	Map<String, String> configMap = CmsProperties.articleBaseTpls.get(currentPage.getTemplate());
%>
<!-- TOP FUNC BAR -->
<div id="admintopheader" class="cmspgw hlgradbg">
    <div id="leftuserfnbar" class="leftblock">
        <div id="newbtn" onclick="openNewPage(${currentPage.id},0);">New</div>
        <div class="sep"></div>
        <div id="configbtn" class="btn"
             onclick="goUrl('<%=Global.getCMSUrl() + "/PageAdmin/Index?id=" + currentPage.getId() %>');">Modify Index Page</div>       
        <%
        	if(!"nodate".equals(configMap.get("datefield"))) {
        		%>
		        <div id="rightuserfnbar" class="rightblock">
		            Year: <select id="selarticleyr"></select>
		        </div>
        		<%
        	}
        %>         
    </div>
</div>

<!-- ARTICLE LISTING -->
<div id="articlelist" class="cmspgw">
	<%
		out.print("<table id='articlestbl' cellpadding='0' cellspacing='0'>");
		out.print("<tr>");
		out.print("<th class='colico'></th>");
		out.print("<th class='colid'>ID</th>");
		if (configMap.containsKey("pgorderlabel") || !StringUtils.isBlank(configMap.get("pgorderlabel"))) {
			out.print("<th class='colpgo'>" + configMap.get("pgorderlabel") + "</th>");
		}
		if(!"nodate".equals(configMap.get("datefield"))) {
			out.print("<th class='coldate' datype='daterange'>" + configMap.get("datelabel") + "</th>");	
		}
		out.print("<th class='coltitle'>" + configMap.get("itmlabel") + "</th>");
		out.print("<th class='colfns'></th>");
		out.print("</tr>");
		for(Page child : children) {			
			String yearFrom = DateUtils.yyyy().format(child.getPageTimeFrom());
			String yearTo = DateUtils.yyyy().format(child.getPageTimeTo());
			String dateStr = DateUtils.yyyyMMdd().format(child.getPageTimeFrom());
			if("daterange".equals(configMap.get("datefield"))) {
				dateStr += "-" + DateUtils.yyyyMMdd().format(child.getPageTimeTo());
			} else if("singleyear".equals(configMap.get("datefield"))) {
				dateStr = DateUtils.yyyy().format(child.getPageTimeFrom());
			}
			String status = child.getStatus().getName();
			String activeStr = child.isActive() ? "active" : "inactive";
			out.print("<tr class='data' yri='" + yearFrom + "' yrf='" + yearTo + "'>");
			out.print("<td class='colico'>");
			out.print("<img class='pgsdot pgs" + status + "' src='" + Global.getContentPath() + "/images/spacer.gif' alt='" + status + "' title='" + status + "'>");
			out.print("<img class='ico " + activeStr + "' src='" + Global.getContentPath() + "/images/spacer.gif' alt='" + activeStr + "' title='" + activeStr + "'>");
			out.print("</td>");
			out.print("<td class='colid'>" + child.getId() + "</td>");
			if (configMap.containsKey("pgorderlabel") || !StringUtils.isBlank(configMap.get("pgorderlabel"))) {
				out.print("<td class='colpgo'>" + child.getPageOrder() + "</td>");				
			}
			if(!"nodate".equals(configMap.get("datefield"))) {
				out.print("<td class='coldate'>" + dateStr + "</td>");	
			}
			out.print("<td class='coltitle'>" + child.getName() + "</td>");
			out.print("<td class='colfns'>");
			out.print("<div class='cmsbtn' onclick=\"goUrl('" + Global.getCMSUrl() + "/PageAdmin/Index?id=" + child.getId() + "')\">Edit</div>");
			out.print("</td>");
			out.print("</tr>");
		}
		out.print("</table>");
	%>       
</div>

<script type="text/javascript">
    function refreshSiteTree() { location.reload(); }

	function defineYrFilter() {
		var sel = $("#selarticleyr");
		var ya = [];
		$("#articlelist table tr.data").each( function () {
			var yri = parseInt($(this).attr('yri'));
			var yrf = parseInt($(this).attr('yrf'));
			var template = $(this).attr('template');
			if ($.inArray(yri,ya)<0) { ya.push(yri); }

			for (var y=yri+1; y<=yrf && yrf!=9999; y++) {
				if ($.inArray(y,ya)<0) { ya.push(y); }
			}
			ya.sort(function(a, b){return b-a}); //descending order

		    var opt="";
			for (var i=0; i<ya.length; i++) {
			    var y = ya[i];			   
			    opt += "<option value='" + y + "'>" + y + "</option>";
			}
			sel.html(opt);

		} );
	}

	function setYearFilter() {
	  $("#selarticleyr").change( function() {
		var s=$(this).val();
		var dtype = $("th.coldate").attr('datype');

		$("#articlelist .noarticle").remove();
		if (s=="all") {
		  $("#articlelist table tr").show();
		} else {
		  var n=0; var v= parseInt(s);
		  $("#articlelist table tr.data").each( function() {
			  var yri = parseInt($(this).attr('yri'));
			  var yrf = parseInt($(this).attr('yrf'));
			  if ((v>=yri && yrf!=9999 && v<=yrf) || (v==yri)) { $(this).show(); n++; } else { $(this).hide(); }
		  });
		  if (n<=0) { $("#articlelist").append($("#noartilcediv").html()); }
		}
		 resetColor();

	  });
	}

	function resetColor() {
		var color='#eee';
		$("#articlelist table tr.data:visible").each( function() {
			color=(color=="#eee")?"#fafafa":"#eee";
			$(this).css('background',color);
		});
	}


	$(document).ready( function() {
		defineYrFilter();
		setYearFilter();
		$("#selarticleyr").change();
	});
</script>	
