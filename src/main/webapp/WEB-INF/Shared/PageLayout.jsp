<%@include file="/WEB-INF/Shared/commons.jsp" %>
<%@page contentType="text/html;charset=UTF-8"%>
<%@page import="org.apache.commons.lang3.StringUtils"%>
<%@page import="com.edeas.utils.XmlUtils"%>
<%@page import="org.dom4j.Document"%>
<%@page import="com.edeas.service.impl.QueryServiceImpl"%>
<%@page import="com.edeas.web.InitServlet"%>
<%@page import="com.edeas.model.*"%>
<%@page import="java.util.*"%>
<% 
	boolean iscms = (Boolean)request.getAttribute("iscms");
	String lang = (String)request.getAttribute("lang");		
	
	Page masterPage = (Page)request.getAttribute("masterPage");
	Content masterContent = masterPage.getContent(lang);
		
	List<? extends Page> topPages = InitServlet.getQueryService().getAllTopPage(iscms, true);
%>

<!-- JS -->
<script type="text/javascript" src="${Script}/mfn.menu.js"></script>
<script type="text/javascript" src="${Script}/jquery.plugins.js"></script>
<script type="text/javascript" src="${Script}/animations/animations.js"></script>
<script type="text/javascript" src="${Script}/back-to-top.js"></script>
<script type="text/javascript" src="${Script}/scripts.js"></script>
<script type="text/javascript" src="${context}/dwr/engine.js"></script>
<script type="text/javascript" src="${context}/dwr/interface/dwrService.js"></script>    
<div>
    <!-- Header Wrapper -->
    <div id="Header_wrapper">
        <!-- Header -->
        <header id="Header">
            <!-- Header -  Logo and Menu area -->
            <div id="Top_bar">
                <div class="container">
                    <div class="one">
                        <div class="top_bar_left clearfix">
                            <!-- Logo-->
                            <div class="logo">
                                <a id="logo" href="index.html"><img class="img-scale" src="${Content}/css/images/logo-edeas.svg" alt="edeas" /></a>
                            </div>
                            <!-- Main menu-->
                            <div class="menu_wrapper">
                                <nav id="menu">
                                    <ul id="menu-main-menu" class="menu">
                                        <li><a href="index.html"><span>Home</span></a></li>
                       		         	<%
							         		for(Page topPage : topPages) {
							         			String menuName = XmlUtils.getPtyFieldVal(topPage.getContent(lang).getPropertyXmlDoc(), "MenuName", false);
							         			List<Page> subPages = InitServlet.getQueryService().getChidrenByPageOrderAsc(topPage.getId(), iscms, true);
							         			%>
		                                        <li>
		                                            <a href="<%=topPage.getPageUrlForRouteMap() %>"><span><%=menuName%></span></a>
		                                            <ul class="sub-menu">
		                                            	<% 
			                                            	for(Page subPage : subPages) {
			                                            		menuName = XmlUtils.getPtyFieldVal(subPage.getContent(lang).getPropertyXmlDoc(), "MenuName", false);
		                                            			%>
		                                                			<li><a href="general.html"><span><%=menuName%></span></a></li>
		                                            			<%
			                                            	}
		                                            	%>		                                                
		                                            </ul>
		                                        </li>                                        
							         			<%		         			
						         			} 
						         		%>	  
                                    </ul>
                                </nav><a class="responsive-menu-toggle " href="#"></a>
                            </div>
                        </div>
                        <div class="top_bar_right">
                            <span><a href="#">繁</a></span><span><a href="#">簡</a></span><!-- for Desktop/Tablet only -->
                        </div>
                    </div>
                </div>
            </div>
            <div class="lang-m">
                <span><a href="#">繁</a></span><span><a href="#">簡</a></span><!-- for mobile only -->
            </div>

            <jsp:include page="/WEB-INF/Templates/Banner.jsp" />
        </header>
    </div>

	<sitemesh:write property='body'/>

	<x:parse xml="<%=masterContent.getContentXmlWithoutCRLF() %>" var="contentXml"></x:parse>
    <!-- Footer-->
    <footer id="footer" class="font-s">
        <div class="inner-wrapper">
            <x:out select="$contentXml/PageContent/Widget[@name='CopyRight']/Field" escapeXml="fasle" />            
        </div>
    </footer>
    <a href="#0" class="cd-top">Back to top</a>
</div>