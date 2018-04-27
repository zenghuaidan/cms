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
<%@page contentType="text/html;charset=UTF-8"%>
<% 
	boolean iscms = (Boolean)request.getAttribute("iscms");
	String lang = (String)request.getAttribute("lang");	
	Page currentPage = (Page)request.getAttribute("currentPage");
	Content pageContent = currentPage.getContent(lang);	
%>

<link href="${Content}/css/photo-gallery-guide/photo-gallery-guide.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="${Script}/photo-gallery-guide/modernizr.custom.js" ></script>

<x:parse xml="<%=pageContent.getContentXmlWithoutCRLF() %>" var="contentXml"></x:parse>
<div class="clearfix"> 
    <div class="full-wrapper clearfix">
        <div class="inner-wrapper" >  
            <div class="main-content-pos">
                <div id="grid-gallery" class="grid-gallery pos">
                    <section class="grid-wrap">
                        <ul class="grid">
                            <li class="grid-sizer"></li><!-- for Masonry column width -->                             
                            <x:forEach select="$contentXml/PageContent/Widget[@name='FixWidthMasonryGallery']/Widget[@name='FixWidthMasonryGalleryItem']" var="imageItem" varStatus="status">
       		                    <li>
       		                    	<figure>
	                                    <img src="<%=Global.getImagesUploadPath(Global.IMAGE_SOURCE) %>/<x:out select="$imageItem/Field[@name='SmallImage']" escapeXml="false"/>" alt="<x:out select="$imageItem/Field[@name='SmallImage']/@alt" escapeXml="false"/>" />
	                                    <figcaption>
	                                    	<h3><x:out select="$imageItem/Field[@name='Title']" escapeXml="false"/></h3>
	                                    	<p><x:out select="$imageItem/Field[@name='Content']" escapeXml="false"/></p>
	                                   	</figcaption>
                                   	</figure>
	                            </li>                                   
					   		</x:forEach>                                                                                                
                        </ul>
                    </section><!-- // grid-wrap -->
                    <section class="slideshow">
                        <ul>
                            <x:forEach select="$contentXml/PageContent/Widget[@name='FixWidthMasonryGallery']/Widget[@name='FixWidthMasonryGalleryItem']" var="imageItem" varStatus="status">                            
	                            <li>
	                                <figure>
	                                    <div>
	                                        <figcaption>
	                                    		<h3><x:out select="$imageItem/Field[@name='Title']" escapeXml="false"/></h3>
	                                    		<p><x:out select="$imageItem/Field[@name='Content']" escapeXml="false"/></p>	                                            
	                                        </figcaption>
	                                        <img src="<%=Global.getImagesUploadPath(Global.IMAGE_SOURCE) %>/<x:out select="$imageItem/Field[@name='LargeImage']" escapeXml="false"/>" alt="<x:out select="$imageItem/Field[@name='LargeImage']/@alt" escapeXml="false"/>" />
	                                    </div>
	                                </figure>
	                            </li>
					   		</x:forEach> 
                        </ul>
                        <nav>
                            <span class="icon nav-prev"><i class="fa fa-chevron-left"></i></span>
                            <span class="icon nav-next"><i class="fa fa-chevron-right"></i></span>
                            <span class="nav-close"><i class="fa fa-times"></i></span>
                        </nav>
                        <div class="info-keys icon">Navigate with arrow keys</div>
                    </section><!-- // slideshow -->
                </div><!-- // grid-gallery -->
            </div>
        </div>
    </div>
</div>

<script src="${Script}/photo-gallery-guide/imagesloaded.pkgd.min.js"></script>
<script src="${Script}/photo-gallery-guide/masonry.pkgd.min.js"></script>
<script src="${Script}/photo-gallery-guide/classie.js"></script>
<script src="${Script}/photo-gallery-guide/cbpGridGallery.js"></script>
<script>
	$(function() {
    	new CBPGridGallery( document.getElementById( 'grid-gallery' ) );		
	});
</script>