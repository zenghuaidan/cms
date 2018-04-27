<%@page import="org.apache.commons.lang3.StringUtils"%>
<%@page import="org.dom4j.Element"%>
<%@page import="org.dom4j.Node"%>
<%@page import="com.edeas.utils.XmlUtils"%>
<%@page import="java.util.*"%>
<%@page import="com.edeas.controller.cmsadmin.CmsProperties"%>
<%@page import="com.edeas.model.CmsPage"%>
<%@page import="com.edeas.model.Page"%>
<%@page import="com.edeas.model.Content"%>
<%@page import="com.edeas.service.impl.*"%>
<%@page import="com.edeas.web.InitServlet"%>
<%@page import="org.dom4j.Document"%>
<%@page contentType="text/html;charset=UTF-8"%>
<%@ include file="/WEB-INF/Shared/commons.jsp" %>
<link href="${Content}/css/news-list.css" rel="stylesheet" type="text/css" />
<link href="${Content}/css/pagination.css" rel="stylesheet" type="text/css" />

<% 
	boolean iscms = (Boolean)request.getAttribute("iscms");
	String lang = (String)request.getAttribute("lang");	
	Page currentPage = (Page)request.getAttribute("currentPage");
	List<Page> children = InitServlet.getQueryService().getChidrenByPageTimeFromDesc(currentPage.getId(), iscms, true);
		
%>

<div class="full-wrapper clearfix"> 
    <div class="inner-wrapper">
        <div class="main-content-pos">
            <select class="news">
            	<%            		
					Set<Integer> years = new HashSet<Integer>();
					for(Page child : children) {
						int year = child.getPageTimeFrom().getYear() + 1900;
						if (!years.contains(year)) {
							String selected = years.size() > 0 ? "" : "selected='selected'"; 
							years.add(year);
							%>
                				<option value="<%=year%>" <%=selected%>><%=year%></option>
							<%
						}
					}
            	%>
            </select>

           	<%            		
				for(Page child : children) {
					int year = child.getPageTimeFrom().getYear() + 1900;	
					Content content = child.getContent(lang);
					Document ptyDocument = content.getPropertyXmlDoc();
					Element imageField = XmlUtils.getPtyField(ptyDocument, "Image");
					String imageVal = XmlUtils.getPtyFieldVal(ptyDocument, "Image", false);
					String titleVal = XmlUtils.getPtyFieldVal(ptyDocument, "Title", true);
					String contentVal = XmlUtils.getPtyFieldVal(ptyDocument, "Content", true);									
					
					boolean hasImage = !StringUtils.isBlank(imageVal);
		            Map<String, String> classMap = new HashMap<String, String>();
	            	classMap.put("class", "img-scale");
					String noImageClass = hasImage ? "" : "m-pos";
					%>
			            <!--post!-->
			            <c:set var="pageTimeFrom" value='<%= child.getPageTimeFrom() %>' />
			            <c:set var="hasImage" value='<%= hasImage %>' />
			            <div class="news-list" year="<%=year%>">
			                <div class="col-sm col-left">
			                    <div>
			                        <div class="news-list-date"><fmt:formatDate value="${ pageTimeFrom }" pattern="dd" /></div>
			                        <div class="news-list-month"><fmt:formatDate value="${ pageTimeFrom }" pattern="MMM" /></div>
			                        <%-- <div class="news-list-week"><fmt:formatDate value="${ pageTimeFrom }" pattern="E" /></div> --%>
			                    </div>
			                </div>
			                <a href="<%=XmlUtils.getPageLink(child, lang, iscms, false).getLink() %>">
				                <div class="col-sm col-right <%=noImageClass%>">
				                    <div>
				                    	<c:if test="${hasImage}">
	           		                        <div class="inner-list-blk">
					                            <div class="in-col-sm cover">
					                            	<%=XmlUtils.tagimg(imageField, Global.IMAGE_SOURCE, false, "", classMap) %>
					                            </div>
					                            <div class="in-col-sm intro">   
				                    	</c:if>
				                        <h3><%=titleVal %></h3>
				                        <%=contentVal%>
	  			                    	<c:if test="${hasImage}"> 
	                  	                        </div>
					                            <div class="clear"></div>
					                        </div>  
				                    	</c:if>
				                    </div>
				                </div>
			                </a>
			            </div>
						
					<%
				}
           	%>

            <!--pagination!-->

            <div class="pagination">
                <i class="fa fa-chevron-circle-left"></i><%= lang.equals("en") ? "Page" : (lang.equals("tc") ? "頁" : "页") %> <input type="text" class="page">/ <label class="pageNum"></label>  <i class="fa fa-chevron-circle-right"></i>
            </div>
        </div>
    </div>
</div>
<script>
function goToPage(page) {
	var year = $("select.news").val();
	var pageSize = 15;
	if (year != null) {
		var total = $("div[year='" + year + "']").length;
		var pageCount = Math.floor((total + pageSize - 1) / pageSize);
		if (!isNaN(page)) {
			var currentPageNum = parseInt(page);
			if (currentPageNum < 1 || currentPageNum > pageCount) {
				currentPageNum = 1;
			}
		} else {
			currentPageNum = 1;
		}
			
		$("input.page").val(currentPageNum);
		$("label.pageNum").text(pageCount);
		$("div.news-list").hide();
       	for (i = (currentPageNum - 1) * pageSize; i <= currentPageNum * pageSize - 1; i++) {  
       		$("div[year='" + year + "']").eq(i).show();  
      	} 
	}
	
}
$(function() {
	$("select.news").change(function() {
		goToPage(1);
	});
    $("input.page").keypress(function (event) {        
        if (event.which == 13) {
            goToPage($(this).val());
        }
    });
    $(".fa-chevron-circle-left").click(function () {
    	goToPage(parseInt($("input.page").val()) - 1);
    });
    $(".fa-chevron-circle-right").click(function () {
    	goToPage(parseInt($("input.page").val()) + 1);
    });
    goToPage(1);
});
</script>
