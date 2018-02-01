<%@include file="/WEB-INF/Shared/commons.jsp" %>
<%@page contentType="text/html;charset=UTF-8"%>
<%@page import="org.apache.commons.lang3.StringUtils"%>
<%@page import="com.edeas.utils.XmlUtils"%>
<%@page import="org.dom4j.Document"%>
<%@page import="com.edeas.service.impl.QueryServiceImpl"%>
<%@page import="com.edeas.web.InitServlet"%>
<%@page import="com.edeas.model.*"%>
<% 
	boolean iscms = (Boolean)request.getAttribute("iscms");
	String lang = (String)request.getAttribute("lang");		
	
	Page masterPage = (Page)request.getAttribute("masterPage");
	Content masterContent = masterPage.getContent(lang);
		
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
                                        <li>
                                            <a href="general.html"><span>General Template</span></a>
                                            <ul class="sub-menu">
                                                <li><a href="general.html"><span>General Widget</span></a></li>
                                                <li><a href="general-special.html"><span>Special Widget</span></a></li>
                                                <li><a href="#"><span>Demo 1</span></a></li>
                                                <li><a href="#"><span>Demo 2</span></a></li>
                                                <li><a href="#"><span>Demo 3</span></a></li>
                                            </ul>
                                        </li>
                                        <li class="current-menu-item"><a href="news.html"><span>News</span></a>
                                            <ul class="sub-menu">
                                                <li><a href="news.html"><span>List</span></a></li>
                                                <li><a href="news-masonry.html">Masonry<span></span></a></li>
                                            </ul>
                                        </li>
                                        <li>
                                            <a href="photo-gallery.html"><span>Gallery</span></a>
                                            <ul class="sub-menu">
                                                <li><a href="photo-gallery.html"><span>Full width Masonry Gallery (Enlarge photo include caption detail)</span></a></li>
                                                <li><a href="photo-gallery-full-masonry.html"><span>Full width Masonry Gallery (jQuery Filtering)</span></a></li>
                                                <li><a href="photo-gallery-guide.html"><span>Fix width Masonry Gallery (Carousel popup effect)</span></a></li>
                                                <li><a href="video-gallery.html"><span>Video Gallery</span></a></li>
                                            </ul>
                                        </li>
                                        <li><a href="form-general.html"><span>Form</span></a>
                                            <ul class="sub-menu">
                                                <li><a href="form-general.html"><span>General Form</span></a></li>
                                                <li><a href="form-special.html"><span>Special Form Style</span></a></li>
                                            </ul>
                                        </li>
                                        <li>
                                            <a href="event-calendar.html"><span>Special Template</span></a>
                                            <ul class="sub-menu">
                                                <li><a href="event-calendar.html"><span>Event Calendar</span></a></li>
                                                <li><a href="timeline.html"><span>Timeline (Vertical)</span></a></li>
                                                <li><a href="timeline-vertical.html"><span>Timeline (Vertical animation timeline)</span></a></li>
                                                <li><a href="timeline-horizontal.html"><span>Timeline (Horizontal)</span></a></li>
                                                <li><a href="google-map.html"><span>Contact Page with Google map</span></a></li>
                                           </ul>
                                        </li>
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