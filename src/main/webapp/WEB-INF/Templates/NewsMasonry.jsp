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
<%@page import="com.edeas.utils.MessageDigestUtils"%>
<%@ include file="/WEB-INF/Shared/commons.jsp" %>

<link href="${Content}/css/filters.css" rel="stylesheet" type="text/css" />
<link href="${Content}/css/masonry.css" rel="stylesheet" type="text/css" />
<link href="${Content}/css/video-player.css" rel="stylesheet" type="text/css" />
<link href="${Content}/css/rev-slider.css" rel="stylesheet" type="text/css" />

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
<c:if test="${isPageAdmin}">
    <style>
        .news-gallery>div.wpform {left:0; z-index:1000; color:white;}        
    </style>
</c:if>
<style>
    .news-gallery>.widget {width:100%;height:100%;}    
</style>
<div class="clearfix"> 
    <div class="full-wrapper clearfix">
        <div class="inner-wrapper">
            <div class="main-masonry-pos">
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
                        </li1-->
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
                            <li class="close">
                                <a href="#"><i class="fa fa-times"></i></a>
                            </li>
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
                           			<li><a data-rel=".cat-<%=category%>" href="#"><%=new String(MessageDigestUtils.decryptBASE64(category))%></a></li>
                          			<%                            			
                           		}
                            %>                                 
                            <li class="close">
                                <a href="#"><i class="fa fa-times"></i></a>
                            </li>
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

<script>
var tpj = jQuery;
var revapi16;
tpj(document).ready(function() {
    if (tpj("#rev_slider_16_2").revolution == undefined) {
        revslider_showDoubleJqueryError("#rev_slider_16_2");
    } else {
        revapi16 = tpj("#rev_slider_16_2").show().revolution({
            sliderType: "standard",
            sliderLayout: "auto",
            dottedOverlay: "none",
            delay: 6000,
            navigation: {
                keyboardNavigation: "off",
                keyboard_direction: "horizontal",
                mouseScrollNavigation: "off",
                onHoverStop: "on",
                touch: {
                    touchenabled: "on",
                    swipe_threshold: 75,
                    swipe_min_touches: 50,
                    swipe_direction: "horizontal",
                    drag_block_vertical: false
                },
                arrows: {
                    style: "uranus",
                    enable: true,
                    hide_onmobile: true,
                    hide_under: 600,
                    hide_onleave: true,
                    hide_delay: 200,
                    hide_delay_mobile: 1200,
                    tmp: '',
                    left: {
                        h_align: "left",
                        v_align: "center",
                        h_offset: 30,
                        v_offset: 0
                    },
                    right: {
                        h_align: "right",
                        v_align: "center",
                        h_offset: 30,
                        v_offset: 0
                    }
                }
            },
            responsiveLevels: [1240, 1024, 778, 480],
            gridwidth: [1240, 1024, 778, 480],
            gridheight: [650, 520, 400, 250],
            lazyType: "smart",
            parallax: {
                type: "mouse",
                origo: "slidercenter",
                speed: 2000,
                levels: [2, 3, 4, 5, 6, 7, 12, 16, 10, 50],
            },
            shadow: 0,
            spinner: "off",
            stopLoop: "off",
            stopAfterLoops: -1,
            stopAtSlide: -1,
            shuffle: "off",
            autoHeight: "off",
            hideThumbsOnMobile: "off",
            hideSliderAtLimit: 0,
            hideCaptionAtLimit: 0,
            hideAllCaptionAtLilmit: 0,
            startWithSlide: 0,
            debugMode: false,
            fallbacks: {
                simplifyAll: "off",
                nextSlideOnWindowFocus: "off",
                disableFocusListener: "off",
            }
        });
    }
});
</script>