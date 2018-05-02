<%@include file="/WEB-INF/Shared/commons.jsp" %>
<%@page import="org.dom4j.Element"%>
<%@page contentType="text/html;charset=UTF-8"%>
<%@page import="org.apache.commons.lang3.StringUtils"%>
<%@page import="com.edeas.utils.XmlUtils"%>
<%@page import="org.dom4j.Document"%>
<%@page import="com.edeas.service.impl.QueryServiceImpl"%>
<%@page import="com.edeas.web.InitServlet"%>
<%@page import="com.edeas.model.*"%>
<%@page contentType="text/html;charset=UTF-8"%>
<link href="${Content}/css/general.css" rel="stylesheet" type="text/css" />
<link href="${Content}/css/slider.css" rel="stylesheet" type="text/css" />
<link href="${Content}/css/enlarge-img.css" rel="stylesheet" type="text/css" />
<link href="${Content}/css/accordion.css" rel="stylesheet" type="text/css" />
<link href="${Content}/css/lightgallery.css" rel="stylesheet" type="text/css" />
<link href="${Content}/css/photo.css" rel="stylesheet" type="text/css" />
<link href="${Content}/css/photo-pg.css" rel="stylesheet" type="text/css" />

<script type="text/javascript" src="${Script}/lightgallery.js"></script>
<script type="text/javascript" src="${Script}/lg-fullscreen.js"></script>
<script type="text/javascript" src="${Script}/lg-thumbnail.js"></script>
<script type="text/javascript" src="${Script}/lg-video.js"></script>
<script type="text/javascript" src="${Script}/lg-autoplay.js"></script>
<script type="text/javascript" src="${Script}/lg-zoom.js"></script>
<script type="text/javascript" src="${Script}/lg-hash.js"></script>
<script type="text/javascript" src="${Script}/lg-pager.js"></script>
<c:if test="${not isPageAdmin}">	
	<%-- <script type="text/javascript" src="${Script}/photo.js"></script> --%>
	<script type="text/javascript">
		$(function() {
		   $(".photolist>.list").each(function() {
		      $(this).lightGallery();
		   });
		   $(".photolist .mgal").click(function() {
		      //alert($(this).prev().html());
		      //$(this).prev().data('lightGallery').slide(0);
		      $(this).prev().find("a").eq(0).click();
		   });
		});
	</script>
</c:if>

<style>   
    <c:if test="${isPageAdmin}">
	    h1, h2, h3 { text-align: left !important; } 
    </c:if>
    
    /* fix for light gallery arrow position*/
    .lg-actions .lg-next, .lg-actions .lg-prev { position:fixed; }
        
    .greyBox.photolist { padding-right:0px; padding-bottom:0px; max-height:230px; overflow-y:hidden; }

    .photolist { line-height:0; font-size:0; }
    .photolist img { height:100px; width:auto; display:inline-block; margin:0 15px 15px 0; vertical-align:baseline; }
    .photolist .mgal { display:none; }

    @media only screen and (max-width: 667px) {
        .greyBox.photolist { padding:2%; height:auto; max-height:none; position:relative; }    
        .photolist a { display:none; }
        .photolist .list a { width:100%;}
        .photolist a:first-child { display:inline-block; }
        .photolist img { height:auto; width:100%; margin:0; vertical-align:top; }   
        .photolist .mgal { position:absolute; bottom:0%; right:0; display:block; color:#fff; font-size:30px;
                            padding:5%; overflow:hidden; padding:14px; background:rgba(0,0,0,0.8); }        }
</style>
<div class="general full-wrapper clearfix"> 
    <div class="inner-wrapper">
        <div class="main-content-pos">
        	<jsp:include page="/WEB-INF/Shared/WidgetHolder.jsp" />
    	</div>
    </div>
</div>