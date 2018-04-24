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
<%@page import="com.edeas.common.utils.MessageDigestUtils"%>
<%@ include file="/WEB-INF/Shared/commons.jsp" %>

<link href="${Content}/css/filters.css" rel="stylesheet" type="text/css" />
<link href="${Content}/css/masonry.css" rel="stylesheet" type="text/css" />
<link href="${Content}/css/video-player.css" rel="stylesheet" type="text/css" />

<script type="text/javascript" src="${Script}/jquery.jplayer.min.js"></script>

<script type="text/javascript" src="${Plugin}/rs-plugin/js/jquery.themepunch.tools.min.js"></script>
<script type="text/javascript" src="${Plugin}/rs-plugin/js/jquery.themepunch.revolution.min.js"></script>
<script type="text/javascript" src="${Plugin}/rs-plugin/js/extensions/revolution.extension.video.min.js"></script>
<script type="text/javascript" src="${Plugin}/rs-plugin/js/extensions/revolution.extension.slideanims.min.js"></script>
<script type="text/javascript" src="${Plugin}/rs-plugin/js/extensions/revolution.extension.actions.min.js"></script>
<script type="text/javascript" src="${Plugin}/rs-plugin/js/extensions/revolution.extension.layeranimation.min.js"></script>
<script type="text/javascript" src="${Plugin}/rs-plugin/js/extensions/revolution.extension.kenburn.min.js"></script>
<script type="text/javascript" src="${Plugin}/rs-plugin/js/extensions/revolution.extension.navigation.min.js"></script>
<script type="text/javascript" src="${Plugin}/rs-plugin/js/extensions/revolution.extension.migration.min.js"></script>
<script type="text/javascript" src="${Plugin}/rs-plugin/js/extensions/revolution.extension.parallax.min.js"></script>

<%
	Page currentPage = (Page)request.getAttribute("currentPage");
	boolean iscms = (Boolean)request.getAttribute("iscms");
	String lang = (String)request.getAttribute("lang");
	
	Content content = currentPage.getContent(lang);	
	Document contentDocument = content.getContentXmlDoc();
	List<Element> elements = (List<Element>)contentDocument.selectNodes("/PageContent/Widget[@name='WidgetHolder']/Widget");
%>
<div class="clearfix"> 
    <div class="full-wrapper clearfix">
        <div class="inner-wrapper main-masonry-pos">
             <div class="main-content-pos">
                <!--  Filter Area -->
                <div id="Filters" class="isotope-filters">
                    <ul class="filters_buttons">
                        <li class="label"><i class="fa fa-filter"></i>Filter by</li>
                        <li class="year">
                            <a class="open" href="#">Year</a>
                        </li>
                        <li class="categories">
                            <a class="open" href="#">Categories</a>
                        </li>
                        <!--li class="reset">
                            <a class="close" data-rel="*" href="#"><i class="gi gi-show-thumbnails"></i>Show all</a>
                        </li!-->
                    </ul>
                    <div class="filters_wrapper">
                         <ul class="year">
                            <li class="reset current-cat"><a class="all" data-rel="*" href="#">Show all</a></li>                            
                            <%
                            	List<String> years = new ArrayList<String>();
                            	for(Element element : elements) {
                            		String[] dateInfo = XmlUtils.getFieldRaw(element, "Date").split("-");
                            		String year = dateInfo.length > 0 ? dateInfo[0] : "";
                            		if (!StringUtils.isBlank(year) && !years.contains(year)) {
                            			years.add(year);                          			
                            		}
                            	}
                           		years.sort(new Comparator<String>() {			
                           			@Override
                           			public int compare(String o1, String o2) {
                           				return o1.compareTo(o2);
                           			}
                           		});
                           		for(String year : years) {
                          			%>
                          				<li><a data-rel=".<%=year%>" href="#"><%=year%></a></li>
                          			<%                            			
                           		}
                            %>
                            <li class="close"><a href="#"><i class="fa fa-times"></i></a></li>
                        </ul>
                        <ul class="categories">
                            <li class="reset current-cat"><a class="all" data-rel="*" href="#">Show all</a></li>
                            <%
                            	List<String> categories = new ArrayList<String>();
                            	for(Element element : elements) {                            		
                            		for(String category : XmlUtils.getFieldRaw(element, "Category").split(";")) {
	                            		if (!StringUtils.isBlank(category) && !categories.contains(category)) {
	                            			categories.add(category);                            			
	                            		}                            			
                            		}
                            	}
                           		for(String category : categories) {
                          			%>
                           			<li><a data-rel=".cat-<%=category.replaceAll("=", "") %>" href="#"><%=new String(MessageDigestUtils.decryptBASE64(category))%></a></li>
                          			<%                            			
                           		}
                            %>                             
                            <li class="close"><a href="#"><i class="fa fa-times"></i></a></li>
                        </ul>
                    </div>
                </div>
                <!-- masonry post-->
                <div class="masonry">
                	<c:if test="${isPageAdmin}">
                		<div class="widgetHolder">
                	</c:if>
	                    <div class="posts_group lm_wrapper masonry isotope">
	                        <jsp:include page="/WEB-INF/Shared/WidgetHolder.jsp" />
	                    </div>
                    <c:if test="${isPageAdmin}">
                		</div>
                	</c:if>
                </div>
            </div>
        </div>
    </div>
</div>