<%@include file="/WEB-INF/Shared/commons.jsp" %>
<%@page import="org.dom4j.Element"%>
<%@page contentType="text/html;charset=UTF-8"%>
<%@page import="org.apache.commons.lang3.StringUtils"%>
<%@page import="com.edeas.utils.XmlUtils"%>
<%@page import="org.dom4j.Document"%>
<%@page import="com.edeas.service.impl.QueryServiceImpl"%>
<%@page import="com.edeas.web.InitServlet"%>
<%@page import="com.edeas.model.*"%>
<%@page import="java.util.*"%>
<link href="${Content}/css/timeline.css" rel="stylesheet" type="text/css" />
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

<style>
	.col-sm-height.col-2 .col2-sm1>div {
		height : 20px;
	}
	.end-dot {	    
	    height: 25px;
	    margin-left: -5px !important;
	}
</style>

<%
	Page currentPage = (Page)request.getAttribute("currentPage");
	boolean iscms = (Boolean)request.getAttribute("iscms");
	boolean isPageAdmin = (Boolean)request.getAttribute("isPageAdmin");
	String lang = (String)request.getAttribute("lang");
	
	Content content = currentPage.getContent(lang);	
	Document contentDocument = content.getContentXmlDoc();
	
	List<Element> elements = (List<Element>)contentDocument.selectNodes("/PageContent/Widget[@name='WidgetHolder']/Widget");
	if (!isPageAdmin) {
		// if web, do sorting
		Map<Integer, List<Element>> elementWithDateMap = new TreeMap<Integer, List<Element>>(new Comparator<Integer>() {          
	       public int compare(Integer a,Integer b) {  
	           return b-a;           
	       }  
	    });
		List<Element> elementWithoutDate = new ArrayList<Element>();
		for(Element element : elements) {
			String date = XmlUtils.getFieldRaw(element, "Date");
			if(StringUtils.isBlank(date)) {
				elementWithoutDate.add(element);
			} else {
				int dateInt = Integer.parseInt(date.replaceAll("-", ""));
				if (elementWithDateMap.containsKey(dateInt)) {
					elementWithDateMap.get(dateInt).add(element);
				} else {
					List<Element> elementWithDateList = new ArrayList<Element>();
					elementWithDateList.add(element);
					elementWithDateMap.put(dateInt, elementWithDateList);
				}
			}
		}
		if (elementWithoutDate.size() > 0) {
			elementWithDateMap.put(Integer.MAX_VALUE, elementWithoutDate);
		}
		
		elements.clear();
		for(Integer key : elementWithDateMap.keySet()) {
			for(Element element : elementWithDateMap.get(key)) {
				elements.add(element);		
			}
		}		
	}
%>

<div class="full-wrapper clearfix"> 
    <div class="inner-wrapper">
        <div class="main-content-pos">
        	<%
        		String currentYear = ""; 
       			for(Element element : elements) {
       				String widgetName = XmlUtils.getFieldAttr(element, "name");
       				String date = XmlUtils.getFieldRaw(element, "Date");        				
       				if (!StringUtils.isBlank(date) && !currentYear.equals(date.split("-")[0]) && !isPageAdmin) {
       					currentYear = date.split("-")[0];
       					%>
                    	<div class="row-height">
	                        <div class="col-sm-height col-1">
	                        </div>
	
	                        <div class="col-sm-height col-2">
	                            <div class="row-height mobile-height">
	                                <div class="col2-sm1 year txt-center">
	                                    <span class="year-blk"><%=currentYear%></span>
	                                </div>
	                                <div class="col2-sm2"></div>
	                            </div>      
	                        </div>
	                    </div>
       					<%        					
       				}
       				%>
                    <div class="row-height widget">
                    	<%
                    		if (!StringUtils.isBlank(date)) {
                    			%>
		                        <div class="col-sm-height col-1">
		                            <div class="desktop"> <!-- date for desktop & tablet -->
		                                <div class="date-blk">
		                                    <h1><div><%=date.split("-")[2] %></div></h1>
		                                    <i class="fa fa-calendar-o"></i>
		                                </div>
		                                <div class="month-d font-s"><span><%=date.split("-")[1] + "." + date.split("-")[0] %></span></div>
		                            </div>
		                        
		                            <div class="mobile"> <!-- date for mobile only -->
		                                <i class="gi gi-calendar"></i><div><%=date.split("-")[2] + "." + date.split("-")[1] + "." + date.split("-")[0] %></div>
		                            </div>
		                        </div>
                    			<%
                    		}	                    	
							if("ImageTimelineBlk".equals(widgetName)) {
								%>
		                        <div class="col-sm-height col-2">
		                            <div class="row-height">
		                                <div class="col2-sm1">
		                                    <div><img src="${Content}/images/spacer.png"/></div>
		                                </div>
		                                <div class="col2-sm2">
		                                    <div class="time-cover">
		                                    	<%
		                                    		String image = XmlUtils.getFieldRaw(element, "Image");
		                                    		if(!StringUtils.isBlank(image)) {
		                                    			%>
		                                    				<img src="<%=Global.getImagesUploadPath(Global.IMAGE_SOURCE, image) %>">
		                                    			<%
		                                    		}
		                                    	%>
		                                    </div>
		                                    <div class="detail-col">
		                                        <div>
		                                        	<h2><c:out value='<%=XmlUtils.getFieldRaw(element, "Title")%>' escapeXml="true"></c:out></h2>
		                                        	<c:out value='<%=XmlUtils.getFieldRaw(element, "Content")%>' escapeXml="true"></c:out>
		                                        </div>
		                                    </div>
		                                </div>
		                            </div>      
		                        </div>
								<%
							} else if("TimelineSliderImages".equals(widgetName)) {
								%>
		                        <div class="col-sm-height col-2">
		                            <div class="row-height">
		                                <div class="col2-sm1">
		                                    <div><img src="${Content}/images/spacer.png"/></div>
		                                </div>
		                                <div class="col2-sm2">
		                                    <div class="time-cover">
		                                        <div id="rev_slider_16_2_wrapper" class="rev_slider_wrapper">
		                                            <div id="rev_slider_16_2" class="rev_slider" data-version="5.0.4.1">
		                                                <ul>
		                                                	<%
		                                                		for(Element timelineSliderImage : (List<Element>)element.selectNodes("Widget[@name='TimelineSliderImage']")) {
		                                                			Element image = (Element)timelineSliderImage.selectSingleNode("Field[@name='Image']");
		                                                			%>
				                                                    <li data-index="rs-21" data-transition="fade" data-slotamount="7" data-easein="default" data-easeout="default" data-masterspeed="300" data-rotate="0" data-saveperformance="off" data-title="Slide" data-description="">
				                                                        <img src='<%=Global.getImagesUploadPath(Global.IMAGE_SOURCE, XmlUtils.getFieldRaw(timelineSliderImage, "Image"))%>'  alt="<%=XmlUtils.getFieldAttr(image, "alt") %>" data-lazyload="<%=Global.getImagesUploadPath(Global.IMAGE_SOURCE, XmlUtils.getFieldRaw(timelineSliderImage, "Image"))%>" data-bgposition="center top" data-bgfit="100%" data-bgrepeat="no-repeat" data-bgparallax="off" class="rev-slidebg" data-no-retina  >
				                                                    </li>
		                                                			<%
		                                                		}
		                                                	%>	
		                                                </ul>
		                                                <div class="tp-bannertimer flv_rev_21"></div>
		                                            </div>
		                                        </div>
		                                    </div>
		                                    <div class="detail-col">
		                                        <div>
		                                        	<h2><c:out value='<%=XmlUtils.getFieldRaw(element, "Title")%>' escapeXml="true"></c:out></h2>
		                                        	<c:out value='<%=XmlUtils.getFieldRaw(element, "Content")%>' escapeXml="true"></c:out>
												</div>
		                                    </div>
		                                </div>
		                            </div>      
		                        </div>
								<%
							} else if("Html5VideoTimelineBlk".equals(widgetName)) {
								%>
								<div class="col-sm-height col-2">
		                            <div class="row-height">
		                                <div class="col2-sm1">
		                                    <div><img src="${Content}/images/spacer.png"/></div>
		                                </div>
		                                <div class="col2-sm2">
		                                    <div class="time-cover">
		                                    <div id="jp_container_128" class="jp-video mfn-jcontainer jp-video-360p">
		                                        <div class="jp-type-single">
		                                            <div id="jquery_jplayer_128" class="jp-jplayer mfn-jplayer" data-m4v="<%=Global.getDocUploadPath(XmlUtils.getFieldRaw(element, "Video")) %>" data-img="<%=Global.getImagesUploadPath(Global.IMAGE_SOURCE, XmlUtils.getFieldRaw(element, "Image")) %>"></div>
		                                           	<%@include file="/WEB-INF/Shared/Video.jsp" %>
		                                        </div>
		                                    </div></div>
		                                    <div class="detail-col">
		                                        <div>
		                                        	<h2><c:out value='<%=XmlUtils.getFieldRaw(element, "Title")%>' escapeXml="true"></c:out></h2>
		                                        	<c:out value='<%=XmlUtils.getFieldRaw(element, "Content")%>' escapeXml="true"></c:out>
		                                        </div>
		                                    </div>
		                                </div>
		                            </div>      
		                        </div>
								
								<%
							}
						%>
                    </div>
       				<%
       			}
        	%>
            <div id="end">
                <div class="e-col1"><img src="${Content}/images/spacer.png"/></div>
                <div class="e-col2 end-dot"><img src="${Content}/images/spacer.png"/></div>
                <div class="clear"></div>
            </div>
    	</div>
    </div>
</div>

<script type="text/javascript">
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