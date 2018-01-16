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
<%@ include file="/WEB-INF/Shared/commons.jspf" %>
<link rel="stylesheet" type="text/css" href="${Content}/css/index.css" />
<link rel="stylesheet" type="text/css" href="${Content}/css/jquery.simplebanner-edit.css" />
<link rel="stylesheet" type="text/css" href="${Content}/css/lg-transitions.css" />
<link rel="stylesheet" type="text/css" href="${Content}/css/lg-fb-comment-box.css" />
<link rel="stylesheet" type="text/css" href="${Content}/css/lightgallery.css" />
<link rel="stylesheet" type="text/css" href="${Content}/css/video.css" />

<script type="text/javascript" src="${Script}/jquery.simplebanner-edit.js"></script>
<script type="text/javascript" src="${Script}/jquery.mousewheel.min.js"></script>
<script type="text/javascript" src="${Script}/lightgallery.js"></script>
<script type="text/javascript" src="${Script}/lg-fullscreen.js"></script>
<script type="text/javascript" src="${Script}/lg-thumbnail.js"></script>
<script type="text/javascript" src="${Script}/lg-video.js"></script>
<script type="text/javascript" src="${Script}/lg-autoplay.js"></script>
<script type="text/javascript" src="${Script}/lg-zoom.js"></script>
<script type="text/javascript" src="${Script}/lg-hash.js"></script>
<script type="text/javascript" src="${Script}/lg-pager.js"></script>
<script type="text/javascript" src="${Script}/video.js"></script>

<style>
    .banner-blk { padding-top: 205px; }
    #propertybox { min-height: 210px; }
</style>

<style>
    .video-cover-gallery { position: absolute; left: 0; top: 0; width: 100%; height: 100%; z-index: 3; }
    .video-cover-gallery .video-cover { width: 100%; height: 100%; background-size: cover; background-position: center; background-repeat: no-repeat; transition: all 0.3s; }
    .video-cover-gallery .play-lay { position: absolute; top: 0; left: 0; width: 100%; height: 100%; transition: all 0.3s; }
    .video-cover-gallery .play-lay:hover { opacity: 1; }
    .video-cover-gallery .play-lay .play-btn { position: absolute; left: 50%; top: 50%; transform: translate(-50%,-50%); cursor: pointer; }
    .video-cover-gallery .play-lay .play-btn .fa-play-circle { font-size: 80px; color: #fff; opacity: 0.8; }
    .video-cover-gallery .play-lay .dark-lay { width: 100%; height: 100%; background: #000; opacity: 0; transition: opacity 0.3s; }
    .video-cover-gallery:hover .play-lay .dark-lay { opacity: 0.5; }
    .video-cover-gallery:hover .video-cover { margin-left: -5%; margin-top: -5%; margin-right: -5%; margin-bottom: -5%; width: 110%; height: 110%; }
</style>
<%
	Page currentPage = (Page)request.getAttribute("currentPage");
	boolean iscms = (Boolean)request.getAttribute("iscms");
	String lang = (String)request.getAttribute("lang");
%>
<div class="container">    
    <div class="tagline-m bg-red">Homepage</div>
    <div class="banner-blk">
        <div class="simpleBanner">
            <div class="bannerListWpr">
                <ul class="bannerList">

                </ul>
            </div>
            <div class="bannerIndicators"><ul></ul></div>
            <div class="captions"></div>
        </div>
        <div class="clear"></div>
		<div id="SectionTitle">BannerList</div>             
    </div>
    <div class="main-content-blk">
        <div class="index-square-wrapper">
            <jsp:include page="/WEB-INF/Shared/WidgetHolder.jsp" />
        </div>
    </div>
</div>
