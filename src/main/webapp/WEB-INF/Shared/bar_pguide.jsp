<%@page import="com.edeas.web.SiteIdHolder"%>
<%@include file="/WEB-INF/Shared/commons.jsp" %>
<div id="saguide" class="guideline">
    <div class="block cmsgreybg">
        <div class="lbl">Web Status </div>
        <div class="itm">
            <img class="pgsdot pgsnew" src="${Content}/images/spacer.gif" alt="New" title="New">
            New
        </div>

        <div class="itm">
            <img class="pgsdot pgsedit" src="${Content}/images/spacer.gif" alt="Editing" title="Editing">
            Editing
        </div>        

        <div class="itm">
            <img class="pgsdot pgslive" src="${Content}/images/spacer.gif" alt="Live" title="Live">
            Live
        </div>

        <div style="float:left; height:1px; width:50px;"></div>
        <div class="itm">
            <img class="ico active" src="${Content}/images/spacer.gif" alt="Active" title="Active">
            Active
        </div>

        <div class="itm">
            <img class="ico inactive" src="${Content}/images/spacer.gif" alt="Inactive" title="Inactive">
            Inactive
        </div>

        <div class="itm" style="float:right">
	        Site: 
	        <select onchange="dwrService.setSiteId($(this).val(),function(){window.location.reload();})">
	        	<%for(String site : CmsProperties.getCMSSite()) {%>
            		<option value="<%=site.split(":")[0] %>" <%=site.split(":")[0].equals(SiteIdHolder.getSiteId()) ? "selected" : "" %> ><%=site.split(":")[1] %></option>
       			<%}%>
	        </select>
        </div>
        <div class="clear"></div>
    </div>
    <div class="clear" style="height:1px;"></div>
</div>
