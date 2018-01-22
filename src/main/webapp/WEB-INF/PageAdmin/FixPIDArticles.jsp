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
<%@include file="/WEB-INF/Shared/commons.jsp" %>
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

<%@include file="/WEB-INF/Shared/bar_pguide.jsp"%>
<%
	QueryServiceImpl queryService = InitServlet.getQueryService();
	Page currentPage = (Page)request.getAttribute("currentPage");
	List<Page> children = queryService.findPagesByParentId(currentPage.getId(), true, false);
	Map<String, String> configMap = CmsProperties.articleBaseTpls.get(currentPage.getTemplate());
%>
<c:set var="configMap" value="<%=configMap %>"></c:set>
<c:set var="children" value="<%=children %>"></c:set>
<!-- TOP FUNC BAR -->
<div id="admintopheader" class="cmspgw hlgradbg">
    <div id="leftuserfnbar" class="leftblock">
        <div id="newbtn" onclick="openNewPage(${currentPage.id},0);">New</div>
        <div class="sep"></div>
        <div id="configbtn" class="btn" onclick="goUrl('<%=Global.getCMSUrl() + "/PageAdmin/Index?id=" + currentPage.getId() %>');">Modify Index Page</div>               
        <c:if test="${not 'nodate' eq configMap['datefield']}">
			<div id="rightuserfnbar" class="rightblock">
	            Year: <select id="selarticleyr"></select>
	        </div>	
		</c:if>         
    </div>
</div>

<!-- ARTICLE LISTING -->
<div id="articlelist" class="cmspgw">
	<table id='articlestbl' cellpadding='0' cellspacing='0'>
		<tr>
			<th class='colico'></th>
			<th class='colid'>ID</th>
			<c:if test="${not empty configMap['pgorderlabel']}">
				<th class='colpgo'>${configMap['pgorderlabel']}</th>
			</c:if>
			<c:if test="${not 'nodate' eq configMap['datefield']}">
				<th class='coldate' datype='daterange'>${configMap['datelabel']}</th>	
			</c:if>
			<th class='coltitle'>${configMap['itmlabel']}</th>
			<th class='colfns'></th>
		</tr>
		<c:forEach items="${children }" var="child">
			<c:set var="dateStr" value=""></c:set>
			<c:if test="${'daterange' eq configMap['datefield']}">
				<c:set var="dateStr" value="<fmt:formatDate value='${ child.pageTimeFrom }' pattern='yyyy-MM-dd' />-<fmt:formatDate value='${ child.pageTimeTo }' pattern='yyyy-MM-dd' />"></c:set>	
			</c:if>
			<c:if test="${'singleyear' eq configMap['datefield']}">
				<c:set var="dateStr" value="<fmt:formatDate value='${ child.pageTimeFrom }' pattern='yyyy' />"></c:set>
			</c:if> 			
			<tr class='data' yri='<fmt:formatDate value="${ child.pageTimeFrom }" pattern="yyyy" />' yrf='<fmt:formatDate value="${ child.pageTimeTo }" pattern="yyyy" />'>
				<td class='colico'>
					<img class='pgsdot pgs${child.status.name }' src='${Content}/images/spacer.gif' alt='${child.status.name }' title='${child.status.name }' />
					<img class='ico ${child.active ? 'active' : 'inactive' }' src='${Content}/images/spacer.gif' alt='${child.active ? 'active' : 'inactive' }' title='${child.active ? 'active' : 'inactive' }' />
				</td>
				<td class='colid'>${child.id }</td>			
				<c:if test="${not empty configMap['pgorderlabel']}">
					<td class='colpgo'>${child.pageOrder}</td>
				</c:if>
				<c:if test="${not 'nodate' eq configMap['datefield']}">
					<td class='coldate'>${dateStr}</td>	
				</c:if>
				<td class='coltitle'>${child.name}</td>
				<td class='colfns'>
					<div class="cmsbtn" onclick="goUrl('<%=Global.getCMSUrl() + "/PageAdmin/Index?id=" %>${child.id}');">Edit</div>    
				</td>
			</tr>
		</c:forEach>
	</table>
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
