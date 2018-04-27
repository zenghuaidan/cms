<%@page import="com.edeas.common.utils.MessageDigestUtils"%>
<%@page import="org.apache.commons.lang3.StringUtils"%>
<%@page import="org.dom4j.Element"%>
<%@page import="org.dom4j.Node"%>
<%@page import="com.edeas.utils.XmlUtils"%>
<%@page import="java.util.*"%>
<%@page import="com.edeas.controller.cmsadmin.CmsProperties"%>
<%@page import="com.edeas.model.*"%>
<%@page import="com.edeas.service.impl.*"%>
<%@page import="com.edeas.web.InitServlet"%>
<%@page import="org.dom4j.Document"%>
<%@ include file="/WEB-INF/Shared/commons.jsp" %>
<%@page contentType="text/html;charset=UTF-8"%>

<link href="${Content}/css/filters.css" rel="stylesheet" type="text/css" />
<link href="${Content}/css/lightbox.css" rel="stylesheet" type="text/css" />
<link href="${Content}/css/photo-gallery-full-masonry.css" rel="stylesheet" type="text/css" />

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

<c:if test="${isPageAdmin}">
    <style>
        .photo-gallery>div.wpform {left:0; z-index:1000; color:white;}        
    </style>
</c:if>
<style>
    .photo-gallery>.widget {width:100%;height:100%;}    
</style>
<%
	Page currentPage = (Page)request.getAttribute("currentPage");
	boolean iscms = (Boolean)request.getAttribute("iscms");
	String lang = (String)request.getAttribute("lang");
	
	Content content = currentPage.getContent(lang);	
	Document contentDocument = content.getContentXmlDoc();
	List<Element> elements = (List<Element>)contentDocument.selectNodes("/PageContent/Widget[@name='WidgetHolder']/Widget[@name='PhotoAlbums']");
	for(Element element : elements) {
		List<Element> imageNodes = (List<Element>)element.selectNodes("Widget[@name='PhotoAlbum']");
		%>
			<style> 
		        .<%=XmlUtils.getFieldAttr(element, "id") %>:hover:after {
				    content: '<%=imageNodes.size()%> Photo(s)';
				}
			</style>
		<%
	}
	List<Category> categories = InitServlet.getQueryService().getAllCategory();
	String showAll = lang.equals("en") ? "Show all" : (lang.equals("tc") ? "顯示所有" : "显示所有");
%>
<div class="clearfix"> 
    <div class="full-wrapper clearfix bg-darkGrey">
        <div class="column_filters">
            <!--  Filter Area -->
            <div class="inner-wrapper ph-full-masonry">
                <div id="Filters" class="isotope-filters" data-parent="column_filters">
                    <ul class="filters_buttons">
                        <li class="label"><i class="fa fa-filter"></i><%= lang.equals("en") ? "Filter by" : (lang.equals("tc") ? "篩選" : "筛选") %></li>
                        <li class="year">
                            <a class="open" href="#"><%=lang.equals("en") ? "Year" : (lang.equals("tc") ? "年份" : "年份")%></a>
                        </li>
                        <li class="categories">
                            <a class="open" href="#"><i class="icon-tag"></i><%=lang.equals("en") ? "Categories" : (lang.equals("tc") ? "類別" : "类别")%><i class="icon-down-dir"></i></a>
                        </li>
                    </ul>
                    <div class="filters_wrapper">
                        <ul class="year">
                            <li class="reset current-cat"><a class="all" data-rel="*" href="#"><%=showAll%></a></li>
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
                            <li class="reset current-cat"><a class="all" data-rel="*" href="#"><%=showAll%></a></li>                            
                            <%                            	
                           		for(Category category : categories) {
                           			for(Element element : elements) {
                                		String categoryId = XmlUtils.getFieldRaw(element, "Category");
                                		if (!StringUtils.isBlank(categoryId) && categoryId.equals(category.getId() + "")) {    
                                			String name = (Lang.en.getName().equals(lang) ? category.getNameEN()
                									: (Lang.tc.getName().equals(lang) ? category.getNameTC() : category.getNameSC()));
		                          			%>
		                           			<li><a data-rel=".cat-<%=category.getId() %>" href="#"><%=name%></a></li>
		                          			<%                            			
		                          			break;
                                		}
                                	}
                           		}
                            %>   
                            <li class="close"><a href="#"><i class="fa fa-times"></i></a></li>
                        </ul>
                    </div>
                </div>
            </div>

            <div class="isotope_wrapper clearfix">
                <div class="posts_group lm_wrapper col-4 masonry tiles isotope">
					<jsp:include page="/WEB-INF/Shared/WidgetHolder.jsp" />					
                </div>
            </div>
        </div>
    </div>
</div>
