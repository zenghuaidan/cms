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
<%@page contentType="text/html;charset=UTF-8"%>
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
<!-- TOP FUNC BAR -->
<div id="admintopheader" class="cmspgw hlgradbg">
    <div id="leftuserfnbar" class="leftblock">
        <div id="newbtn" style="background:none"></div>
        <div id="configbtn" class="btn" ></div>                        
    </div>
</div>

<!-- ARTICLE LISTING -->
<div id="articlelist" class="cmspgw">
	<table id='articlestbl' cellpadding='0' cellspacing='0'>
		<tr>
			<th class='colid'>ID</th>
			<th class='coltitle'>Date</th>						
			<th class='coltitle'>Form</th>
			<th class='coltitle'>Donors</th>
			<th class='coltitle'>Amount</th>
			<th class='coltitle'>Status</th>
			<th class='colfns'></th>
		</tr>
		<c:forEach items="${donations }" var="donation">
			<tr class='data'>				
				<td class='colid'>${donation.id }</td>			
				<td class='coltitle'><fmt:formatDate value='${ donation.updateTime }' pattern='yyyy-MM-dd' />	</td>				
				<td class='coltitle'>${donation.cmsPage.name}</td>
				<td class='coltitle'>${donation.firstName} ${donation.lastName}</td>
				<td class='coltitle'>${donation.amount}</td>
				<td class='coltitle'>${donation.success ? 'Success' : 'Fail'}</td>
				<td class='colfns'>
					<div class="cmsbtn" onclick="Void(${donation.id})">Void</div>  
				</td>
			</tr>
		</c:forEach>
	</table>
</div>

<script type="text/javascript">
    function Void(id) {
        var u = '<%=Global.getCMSUrl() + "/DonationAdmin/Void/" %>' + id;       
        $.get(u, function (data) {
            if (data.success) {
                window.location.reload();
            } else alert(data.errorMsg);
        }, "json");        
    }

</script>
