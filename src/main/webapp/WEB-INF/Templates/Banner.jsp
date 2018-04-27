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
<% 
	boolean iscms = (Boolean)request.getAttribute("iscms");
	String lang = (String)request.getAttribute("lang");	
	Page currentPage = (Page)request.getAttribute("currentPage");
	Content pageContent = currentPage.getContent(lang);	
	
	Document ptyDocument = pageContent.getPropertyXmlDoc();
	String headTitle = XmlUtils.getPtyFieldVal(ptyDocument, "HeadTitle", false);		
%>
<c:set var="template" value="<%=currentPage.getTemplate() %>"></c:set>
<x:parse xml="<%=pageContent.getContentXmlWithoutCRLF() %>" var="contentXml"></x:parse>
<c:if test="${ template eq 'Homepage' }">        
	<section class="example">
	    <article class="content">
	        <div id="rev_slider_206_1_wrapper" class="rev_slider_wrapper fullscreen-container" data-alias="creative-freedom" style="background-color:#1f1d24;padding:0px;">
	            <!-- START REVOLUTION SLIDER 5.1.1RC fullscreen mode -->
	            <div id="rev_slider_206_1" class="rev_slider fullscreenbanner" style="display:none;" data-version="5.1.1RC">
	                <ul>	
               			<x:forEach select="$contentXml/PageContent/Widget[@name='HomepageBanners']/Widget[@name='Banner']" var="banner" varStatus="status">
		                     <li data-index="rs-${690+status.index}" data-transition="fadethroughdark" data-slotamount="default" data-easein="default" data-easeout="default" data-masterspeed="2000" 
		                     	data-thumb="<%=Global.getImagesUploadPath() + "/" + Global.IMAGE_SOURCE + "/" %><x:out select="$banner/Field[@name='DesktopImage']" />" data-rotate="0" data-saveperformance="off" 
		                     	data-title="<x:out select="$banner/Field[@name='Title']" escapeXml="fasle" />" 
		                     	data-param1="${status.count < 10 ? '0' : ''}${status.count}" data-description="">
		                        <!-- MAIN IMAGE -->
		                        <img src="<%=Global.getImagesUploadPath() + "/" + Global.IMAGE_SOURCE + "/" %><x:out select="$banner/Field[@name='MobileImage']" />" alt="" data-bgposition="center center" data-bgfit="cover" data-bgrepeat="no-repeat" data-bgparallax="${status.count}" class="rev-slidebg" data-no-retina>
		                        <!-- LAYERS -->
		
		                        <!-- BACKGROUND VIDEO LAYER -->
		                        <div class="rs-background-video-layer" data-forcerewind="on" data-volume="mute" data-videowidth="100%" data-videoheight="100%" data-videomp4="<%=Global.getDocUploadPath() + "/" %><x:out select="$banner/Field[@name='Video']" />" data-videopreload="preload" data-videoloop="loop" data-autoplay="true" data-autoplayonlyfirsttime="false" data-nextslideatend="true"></div>
		
		                        <x:out select="$banner/Field[@name='Content']" escapeXml="false" />
		                    </li>		                	
						</x:forEach>    
	                </ul>
	                <div class="tp-bannertimer tp-bottom" style="visibility: hidden !important;"></div>
	            </div>
	        </div>
	        <!-- END REVOLUTION SLIDER -->	
	    </article>
	</section>
</c:if>

<c:if test="${ template ne 'Homepage' }">
	<div class="hd-blk">
	    <div class="hd-wrapper">
	        <div class="hd-pos">
	        	<c:if test="${ template ne 'NewsListInside' }">
	            	<h1><%=headTitle%></h1>
	            </c:if>
	        </div>
	    </div>
	</div>
</c:if>