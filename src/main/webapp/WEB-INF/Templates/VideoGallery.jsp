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
                            <li><a data-rel=".2016" href="#">2016</a></li>
                            <li><a data-rel=".2015" href="#">2015</a></li>
                            <li class="close"><a href="#"><i class="fa fa-times"></i></a></li>
                        </ul>
                        <ul class="categories">
                            <li class="reset current-cat"><a class="all" data-rel="*" href="#">Show all</a></li>
                            <li><a data-rel=".cat-video" href="#">Video</a></li>
                            <li><a data-rel=".cat-detail" href="#">Include Detail Page</a></li>
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