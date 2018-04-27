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
<x:parse xml="<%=pageContent.getContentXmlWithoutCRLF() %>" var="contentXml"></x:parse>

<link href="${Content}/css/gallery-guide-effect-top.css" rel="stylesheet" type="text/css" />
<link href="${Content}/css/gallery-guide-effect.css" rel="stylesheet" type="text/css" />

<script type="text/javascript" src="${Script}/gallery-guide-effect/modernizr-custom.js"></script>
<script type="text/javascript" src="${Script}/gallery-guide-effect/imagesloaded.pkgd.min.js"></script>
<script type="text/javascript" src="${Script}/gallery-guide-effect/masonry.pkgd.min.js"></script>
<script type="text/javascript" src="${Script}/gallery-guide-effect/classie.js"></script>
<script type="text/javascript" src="${Script}/gallery-guide-effect/main-gallery.js"></script>
<script>
    $(function(){
        $(".preview").bind('DOMSubtreeModified',function(){
            var dts = $(this).find(".details");
            if(dts.length > 0){
                var btn = dts.find(".more-detail");
                var ct = btn.closest("li").find(".more-detail-content").html();
                var txt = $(".detail-preview").find(".d-p-c-c-text");
                if(ct.length > 0){
                    txt.html(ct);
                    btn.click(function(){
                        $(".detail-preview").addClass("show");
                    });
                }
                
                $(".detail-preview .detail-preview-bg, .detail-preview .fa-times").click(function(){
                    var dp = $(this).closest(".detail-preview");
                    if(dp.length > 0){
                        dp.removeClass("show");
                    }
                });
            }
        });
	    (function() {
	        var support = { transitions: Modernizr.csstransitions },
	            // transition end event name
	            transEndEventNames = { 'WebkitTransition': 'webkitTransitionEnd', 'MozTransition': 'transitionend', 'OTransition': 'oTransitionEnd', 'msTransition': 'MSTransitionEnd', 'transition': 'transitionend' },
	            transEndEventName = transEndEventNames[ Modernizr.prefixed( 'transition' ) ],
	            onEndTransition = function( el, callback ) {
	                var onEndCallbackFn = function( ev ) {
	                    if( support.transitions ) {
	                        if( ev.target != this ) return;
	                        this.removeEventListener( transEndEventName, onEndCallbackFn );
	                    }
	                    if( callback && typeof callback === 'function' ) { callback.call(this); }
	                };
	                if( support.transitions ) {
	                    el.addEventListener( transEndEventName, onEndCallbackFn );
	                }
	                else {
	                    onEndCallbackFn();
	                }
	            };
	
	        new GridFx(document.querySelector('.grid'), {
	            imgPosition : {
	                x : -0.5,
	                y : 1
	            },
	            onOpenItem : function(instance, item) {
	                instance.items.forEach(function(el) {
	                    if(item != el) {
	                        var delay = Math.floor(Math.random() * 50);
	                        el.style.WebkitTransition = 'opacity .5s ' + delay + 'ms cubic-bezier(.7,0,.3,1), -webkit-transform .5s ' + delay + 'ms cubic-bezier(.7,0,.3,1)';
	                        el.style.transition = 'opacity .5s ' + delay + 'ms cubic-bezier(.7,0,.3,1), transform .5s ' + delay + 'ms cubic-bezier(.7,0,.3,1)';
	                        el.style.WebkitTransform = 'scale3d(0.1,0.1,1)';
	                        el.style.transform = 'scale3d(0.1,0.1,1)';
	                        el.style.opacity = 0;
	                    }
	                });
	            },
	            onCloseItem : function(instance, item) {
	                instance.items.forEach(function(el) {
	                    if(item != el) {
	                        el.style.WebkitTransition = 'opacity .4s, -webkit-transform .4s';
	                        el.style.transition = 'opacity .4s, transform .4s';
	                        el.style.WebkitTransform = 'scale3d(1,1,1)';
	                        el.style.transform = 'scale3d(1,1,1)';
	                        el.style.opacity = 1;
	
	                        onEndTransition(el, function() {
	                            el.style.transition = 'none';
	                            el.style.WebkitTransform = 'none';
	                        });
	                    }
	                });
	            }
	        });
	    })();
    });
</script>
<style>
    .top-bg-photo { background-image:url(<%=Global.getImagesUploadPath(Global.IMAGE_SOURCE) %>/<x:out select="$contentXml/PageContent/Widget[@name='FullWidthMasonryGalleryContent']/Field[@name='Image']" escapeXml="false" />); }
    .details .more-detail { cursor:pointer; }
    .details .more-detail-content { display:none; }
    
    /* detail preview */    
    .detail-preview .fa-times { position: absolute; top: calc(-20px - 9.5px); right: -20px; font-size: 1.5em; color: #ba2950; cursor: pointer; opacity: 0; visibility: hidden; transition: visibility 0s linear 0.2s, opacity 0.2s linear; }    
    .detail-preview { position:fixed; bottom:0; right:0; z-index:1000; width:100vw; height:100vh; visibility: hidden; opacity: 0; transition:0s linear 0.6s; }
    .detail-preview .detail-preview-bg { position:absolute; bottom:0; right:0; width:0; height:0; background:#000; opacity: 0; transform: translate(-50vw, -50vh); transition: 0.4s ease-out 0.2s; }
    .detail-preview .detail-preview-contents .d-p-c-bg { position:absolute; max-width:0; max-height:0; background:#333; left: 50%; top: 50%; transform: translate(-50%, -50%); transition: 0.4s; }
    .detail-preview .detail-preview-contents .d-p-c-content { position:relative; padding: 40px; }
    .d-p-c-content .d-p-c-c-text { opacity: 0; color:#fff; transform: translateY(10px); transition: 0s; }
    
    
    /* show */
    .detail-preview.show { opacity: 1; visibility: visible; transition: 0.4s; }
    .detail-preview.show .fa-times { opacity: 1; visibility: visible; transition: visibility 0s linear 0.6s, opacity 0.4s ease-out 0.6s; }
    
    .detail-preview.show .detail-preview-bg {opacity: 0.8; width: 100vw; height: 100vh; transform: translate(0, 0); transition: 0.4s; }
    .detail-preview.show .detail-preview-contents .d-p-c-bg { max-width:calc(100vw - 40px); max-height:calc(100vh - 80px); transition: 0.4s ease-out 0.2s; }
    .detail-preview.show .d-p-c-content .d-p-c-c-text{ opacity: 1; visibility: visible; transform: translateY(0px); transition: 0.2s ease-out 0.4s; }
</style>

<div class="clearfix"> 
    <div class="full-wrapper clearfix">
        <div id="Content">
            <div class="content_wrapper clearfix">
                <div class="sections_group">
                    <div class="entry-content">                        
                        <div class="section full-screen top-bg-photo" id="start">
                            <div class="section_wrapper clearfix">
                                <div class="items_group clearfix">
                                    <!-- One Second (1/2) Column -->
                                    <div class="inner-wrapper">
                                        <div class="main-content-pos">
                                            <div class="column_attr animate" data-anim-type="fadeInLeft">
                                                <h2 class="gallery"><x:out select="$contentXml/PageContent/Widget[@name='FullWidthMasonryGalleryContent']/Field[@name='Title']" escapeXml="false" /></h2>
                                                <h3 class="gallery-sub"><x:out select="$contentXml/PageContent/Widget[@name='FullWidthMasonryGalleryContent']/Field[@name='Content']" escapeXml="false" /></h3>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>                                 
                    </div>
                </div>
            </div>
        </div>

        <div class="photo-container">
            <div class="grid">            	
		   		<x:choose>
				 <x:when select="$contentXml/PageContent/Widget[@name='FullWidthMasonryGallery']/Widget[@name='FullWidthMasonryGalleryItem']">
	       	   		<x:forEach select="$contentXml/PageContent/Widget[@name='FullWidthMasonryGallery']/Widget[@name='FullWidthMasonryGalleryItem']" var="imageItem" varStatus="status">			   		
		                <!--Post !-->
		                <div class="grid__item" data-size="<x:out select="$imageItem/Field[@name='Image']/@srcw" escapeXml="false"/>x<x:out select="$imageItem/Field[@name='Image']/@srch" escapeXml="false"/>">
		                    <a href="<%=Global.getImagesUploadPath(Global.IMAGE_SOURCE) %>/<x:out select="$imageItem/Field[@name='Image']" escapeXml="false"/>" class="img-wrap">
		                    	<img src="<%=Global.getImagesUploadPath(Global.IMAGE_SOURCE) %>/<x:out select="$imageItem/Field[@name='Image']" escapeXml="false"/>" alt="<x:out select="$imageItem/Field[@name='Image']/@alt" escapeXml="false"/>" />
		                        <c:if test="${not isPageAdmin }">
		                        <div class="description description--grid">
		                            <div>
		                                <h2><x:out select="$imageItem/Field[@name='Title']" escapeXml="false"/></h2>
		                                <p><x:out select="$imageItem/Field[@name='Content']" escapeXml="false"/></p>
		                                <div class="details">
		                                    <ul>
		                                        <li><i class="fa fa-calendar"></i><span><x:out select="$imageItem/Field[@name='Date']" escapeXml="false"/></span></li>
		                                        <li><i class="fa fa-user"></i><span><x:out select="$imageItem/Field[@name='Name']" escapeXml="false"/></span></li>	                                        
		                                        <li><i class="fa fa-external-link"></i><span class="more-detail"><%= lang.equals("en") ? "More Detail" : (lang.equals("tc") ? "更多詳情" : "更多详情") %></span><div class="more-detail-content"><x:out select="$imageItem/Field[@name='Detail']" escapeXml="false"/></div></li>
		                                    </ul>
		                                </div>
		                            </div>
		                        </div>
		                        </c:if>
		                    </a>
		                </div>
			   		</x:forEach>
				 </x:when>
				 <x:otherwise>
				 	<c:if test="${ isPageAdmin }">
					 	<div style="text-align:center">#FullWidthMasonryGallery#</div>
					 	<script>
					 		$(function() {
					 			setTimeout(function(){
					 				$("div.grid").css("height", "25px");
					 			}, 1000);				 							 			
					 		});
					 	</script>
				 	</c:if>
				 </x:otherwise>
				</x:choose>
            </div>
            <!-- /grid -->
            <div class="preview">
                <button class="action action--close"><i class="fa fa-times"></i><span class="text-hidden">Close</span></button>
                <div class="description description--preview"></div>
            </div>
            <!-- /preview -->
            <div class="detail-preview">
                <div class="detail-preview-bg"></div>
                <div class="detail-preview-contents">
                    <div class="d-p-c-bg">
                        <div class="d-p-c-content">
                            <p class="d-p-c-c-text"></p>
                        </div>
                        <div class="fa fa-times"></div>
                    </div>
                </div>
            </div>
            <!-- /preview -> more detail -->
        </div>
    </div>
</div>
