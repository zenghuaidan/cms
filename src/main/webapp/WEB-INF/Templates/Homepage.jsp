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
<script type="text/javascript" src="${Plugin}/rs-plugin/js/extensions/revolution.extension.carousel.min.js"></script>

<link rel='stylesheet' href='${Content}/css/index.css'>

<!-- Revolution Slider -->
<link rel="stylesheet" type="text/css" href="${Plugin}/rs-plugin/css/settings.css">
<link rel="stylesheet" type="text/css" href="${Plugin}/rs-plugin/css/layers.css">
<link rel="stylesheet" type="text/css" href="${Plugin}/rs-plugin/css/navigation.css">
<% 
	boolean iscms = (Boolean)request.getAttribute("iscms");
	String lang = (String)request.getAttribute("lang");	
	Page currentPage = (Page)request.getAttribute("currentPage");
	Content pageContent = currentPage.getContent(lang);
	Document contentDocument = pageContent.getContentXmlDoc();
%>
<c:set var="template" value="<%=currentPage.getTemplate() %>"></c:set>
<x:parse xml="<%=pageContent.getContentXmlWithoutCRLF() %>" var="contentXml"></x:parse>
<div id="promo" class="clearfix full-wrapper"> 
     <div class="inner-wrapper">
         <div class="main-index-pos">
             <div class="intro">
                 <h2><x:out select="$contentXml/PageContent/Widget[@name='Introduction']/Field[@name='Title']" escapeXml="false" /></h2>
                 <h3><x:out select="$contentXml/PageContent/Widget[@name='Introduction']/Field[@name='SubTitle']" escapeXml="false" /></h3>
                 <div><x:out select="$contentXml/PageContent/Widget[@name='Introduction']/Field[@name='Content']" escapeXml="false" /></div>
             </div>

             <div class="news">
                 <div class="news-pos">
                     <h2><%= lang.equals("en") ? "Latest News" : (lang.equals("tc") ? "最新消息" : "最新消息") %></h2>
                     <div class="recent-posts">
                         <ul>
                         	<% int i = 1; %>
                         	<x:forEach select="$contentXml/PageContent/Widget[@name='HomepageNews']/Widget[@name='News']" var="news" varStatus="status">
	                         	<%
	                         		Element newsPageElement = (Element)contentDocument.selectSingleNode("/PageContent/Widget[@name='HomepageNews']/Widget[@name='News'][" + i++ + "]/Field[@name='Page']");	                         		
	                         		long newsPageId = Long.parseLong(XmlUtils.getFieldAttr(newsPageElement, "pgid", "0"));
	                         		Page newsPage = InitServlet.getQueryService().findPageById(newsPageId, iscms);
	                         		Content newsContent = newsPage.getContent(lang);
	                         		Document ptyDocument = newsContent.getPropertyXmlDoc();
	                         		String titleStr = XmlUtils.getPtyFieldVal(ptyDocument, "Title", true);
	                         	%>
	                         	<c:set var="newsDate" value="<%=newsPage.getPageTimeFrom() %>"></c:set>
	                             <li class="post">
	                                 <a <%=XmlUtils.getLinkAttr(XmlUtils.getPageLink(newsPage.getParent(), lang, iscms), lang, iscms, null) %>>
	                               		<x:if select="$news/Field[@name='Image']">
	                                    	<div class="photo"><img src="<%=Global.getImagesUploadPath(Global.IMAGE_SOURCE) %>/<x:out select="$news/Field[@name='Image']" escapeXml="false"/>" class="img-scale" /></div>
	                                    </x:if>
	                                     <div class="desc">
	                                         <div class="post-intro"><c:out value="<%=titleStr%>" escapeXml="false"></c:out></div>
	                                         <div class="date"><fmt:formatDate value="${newsDate}" pattern="MMMM dd, yyyy" /></div>
	                                     </div>
	                                 </a>
	                             </li>
                         	</x:forEach>
                         </ul>
                     </div>
                 </div>
             </div>

             <div class="links">
                 <div class="links-pos">
                     <h2><%= lang.equals("en") ? "Quick Links" : (lang.equals("tc") ? "快速導航" : "快速导航") %></h2>
                     <ul>
                         <% i = 1; %>
                         <x:forEach select="$contentXml/PageContent/Widget[@name='HomepageQuickLinks']/Widget[@name='QuickLink']" var="quickLink" varStatus="status">
                         	<%
                         		Element quickLink = (Element)contentDocument.selectSingleNode("/PageContent/Widget[@name='HomepageQuickLinks']/Widget[@name='QuickLink'][" + i++ + "]/Field[@name='Link']");
                         	%>
							<a <%=XmlUtils.getLinkAttr(quickLink, lang, iscms) %> ><li><x:out select="$quickLink/Field[@name='Text']" escapeXml="false" /></li></a>		                	
						</x:forEach>
                     </ul>
                 </div>
             </div>
             <div class="clear"></div>
         </div>
     </div>
 </div>

<script type="text/javascript">
    var tpj = jQuery;

    var revapi206;
    tpj(document).ready(function() {
    	$("#body").addClass("index page-parent template-slider header-modern subheader-transparent sticky-white");
        if (tpj("#rev_slider_206_1").revolution == undefined) {
            revslider_showDoubleJqueryError("#rev_slider_206_1");
        } else {
            revapi206 = tpj("#rev_slider_206_1").show().revolution({
                sliderType: "standard",
                jsFileLocation: "../../revolution/js/",
                sliderLayout: "fullscreen",
                dottedOverlay: "none",
                delay: 9000,
                navigation: {
                    keyboardNavigation: "off",
                    keyboard_direction: "horizontal",
                    mouseScrollNavigation: "off",
                    onHoverStop: "off",
                    touch: {
                        touchenabled: "on",
                        swipe_threshold: 75,
                        swipe_min_touches: 50,
                        swipe_direction: "horizontal",
                        drag_block_vertical: false
                    },
                    tabs: {
                        style: "metis",
                        enable: true,
                        width: 250,
                        height: 40,
                        min_width: 249,
                        wrapper_padding: 0,
                        wrapper_color: "",
                        wrapper_opacity: "0",
                        tmp: '<div class="tp-tab-wrapper"><div class="tp-tab-number">{{param1}}</div><div class="tp-tab-divider"></div><div class="tp-tab-title-mask"><div class="tp-tab-title">{{title}}</div></div></div>',
                        visibleAmount: 5,
                        hide_onmobile: true,
                        hide_under: 800,
                        hide_onleave: false,
                        hide_delay: 200,
                        direction: "vertical",
                        span: true,
                        position: "inner",
                        space: 0,
                        h_align: "left",
                        v_align: "center",
                        h_offset: 0,
                        v_offset: 0
                    }
                },
                responsiveLevels: [1240, 1024, 778, 480],
                visibilityLevels: [1240, 1024, 778, 480],
                gridwidth: [1240, 1024, 778, 480],
                gridheight: [868, 768, 960, 720],
                lazyType: "none",
                parallax: {
                    type: "3D",
                    origo: "slidercenter",
                    speed: 1000,
                    levels: [2, 4, 6, 8, 10, 12, 14, 16, 45, 50, 47, 48, 49, 50, 0, 50],
                    ddd_shadow: "off",
                    ddd_bgfreeze: "on",
                    ddd_overflow: "hidden",
                    ddd_layer_overflow: "visible",
                    ddd_z_correction: 100,
                },
                spinner: "off",
                stopLoop: "on",
                stopAfterLoops: 0,
                stopAtSlide: 1,
                shuffle: "off",
                autoHeight: "off",
                fullScreenAutoWidth: "off",
                fullScreenAlignForce: "off",
                fullScreenOffsetContainer: "",
                fullScreenOffset: "60px",
                disableProgressBar: "on",
                hideThumbsOnMobile: "off",
                hideSliderAtLimit: 0,
                hideCaptionAtLimit: 0,
                hideAllCaptionAtLilmit: 0,
                debugMode: false,
                fallbacks: {
                    simplifyAll: "off",
                    nextSlideOnWindowFocus: "off",
                    disableFocusListener: false,
                }
            });
        }
    }); /*ready*/
</script>