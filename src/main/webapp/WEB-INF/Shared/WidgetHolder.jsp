<%@page import="com.edeas.dto.LinkInfo"%>
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
<%
	Page currentPage = (Page)request.getAttribute("currentPage");
	boolean iscms = (Boolean)request.getAttribute("iscms");
	String lang = (String)request.getAttribute("lang");
	
	Content content = currentPage.getContent(lang);	
	Document contentDocument = content.getContentXmlDoc();
	String detailPageUrl = "";
	boolean isVideoGallery = "VideoGallery".equals(currentPage.getTemplate());
	boolean isNewsMasonry = "NewsMasonry".equals(currentPage.getTemplate());
	if (isVideoGallery || isNewsMasonry) {
		List<Page> detailPages = (List<Page>)InitServlet.getQueryService().findPageByTemplate(isVideoGallery ? "VideoDetail" : "NewsDetail", iscms, true);
		if (detailPages != null && detailPages.size() > 0) {
			Page detailPage = detailPages.get(0);
			detailPageUrl = XmlUtils.getPageLink(detailPage, lang, iscms, false).getLink();
			detailPageUrl += (detailPageUrl.indexOf("?") != -1 ? "&" : "?"); 
		}
	}
%>
<x:parse xml="<%=content.getContentXmlWithoutCRLF() %>" var="contentXml"></x:parse>
<% int i = 1; %>
<x:forEach select="$contentXml/PageContent/Widget[@name='WidgetHolder']/Widget" var="widget" varStatus="status">
   	<x:set var="widgetName" select="$widget/@name" />
   	<x:set var="widgetId" select="$widget/@wid" scope="page" /> 
   	<x:if select="$widgetName = 'ScaleImage'">
		<div class='widget'>
			<%
	            Element imageNode = (Element)contentDocument.selectSingleNode("/PageContent/Widget[@name='WidgetHolder']/Widget[" + i + "]/Field[@name='Image']");
				Element scaleNode = (Element)contentDocument.selectSingleNode("/PageContent/Widget[@name='WidgetHolder']/Widget[" + i + "]/Field[@name='Scale']");
	            Map<String, String> classMap = new HashMap<String, String>();
	            if (scaleNode != null)
	            	classMap.put("class", scaleNode.getTextTrim());
	            out.print(XmlUtils.tagimg(imageNode, Global.IMAGE_SOURCE, false, "", classMap));
	        %>
		</div>
   	</x:if>  
   	<x:if select="$widgetName = 'GreyBox'">
   		<div class='widget greyBox'><x:out select="$widget/Field[@name='Content']" escapeXml="false"/></div>
   	</x:if>
   	<x:if select="$widgetName = 'ColorBox'">
   		<div class='widget colorBox'><x:out select="$widget/Field[@name='Content']" escapeXml="false"/></div>	
   	</x:if>
   	<x:if select="$widgetName = 'SpaceBlk'">
   		<div class="widget" style="height:<x:out select="$widget/Field[@name='Text']" escapeXml="false"/>"></div>
   	</x:if>
   	<x:if select="$widgetName = 'HRBlk'">
   		<div class="widget" ${isPageAdmin ? 'style=height:25px;' : '' }>
   			<hr/>
   		</div>
   	</x:if>   	
   	<x:if select="$widgetName = 'LeftRightPhotoBlk'">
		<%
           	Element imageNode = (Element)contentDocument.selectSingleNode("/PageContent/Widget[@name='WidgetHolder']/Widget[" + i + "]/Field[@name='Image']");
			String image = XmlUtils.tagimg(imageNode, Global.IMAGE_SOURCE, false, "", null);
			
			Element enlargeNode = (Element)contentDocument.selectSingleNode("/PageContent/Widget[@name='WidgetHolder']/Widget[" + i + "]/Field[@name='Enlarge']");
			String chkval = (enlargeNode == null) ? "false" : enlargeNode.getTextTrim();
		    boolean enlarge = !StringUtils.isBlank(chkval) && Boolean.valueOf(chkval.toLowerCase());
       	%>
   		<x:if select="$widget/Field[@name='ImageAlign'] = 'LeftPhoto'">
   			<div class="widget content-right">
        		<div class="cr-left">
	                <div class="enlarge-img-blk">
	                    <%
                        	if(enlarge) {
                        		%>
				                    <a class="lightbox" href="#enlarge<%=i %>">
				                        <div>
				                            <%=image%>
	                            			<div class="enlarge-icon"><i class="fa fa-expand"></i></div>				                            
				                        </div>
				                    </a> 
				                    <div class="lightbox-target" id="enlarge<%=i %>">
				                        <%=image%>
				                       <a class="lightbox-close" href="#"></a>
				                    </div>                        			
                        		<%
                        	} else {
                        		%>
                        			<div>
			                            <%=image%>				                            
			                        </div>
                        		<%
                        	}
                        %>
	                </div>
	
	                <div class="caption font-s">
	                    <x:out select="$widget/Field[@name='Caption']" escapeXml="false"/>
	                </div>
	            </div>
	            <div class="cr-right"><x:out select="$widget/Field[@name='Content']" escapeXml="false"/></div>
	            <div class="clear"></div>
	        </div>
   		</x:if>
   		<x:if select="$widget/Field[@name='ImageAlign'] = 'RightPhoto'">
	        <div class="widget content-left">
	            <div class="cl-left"><x:out select="$widget/Field[@name='Content']" escapeXml="false"/></div>
	            <div class="cl-right">
	                <div class="enlarge-img-blk">
	                    <%
                        	if(enlarge) {
                        		%>
				                    <a class="lightbox" href="#enlarge<%=i %>">
				                        <div>
				                            <%=image%>
	                            			<div class="enlarge-icon"><i class="fa fa-expand"></i></div>				                            
				                        </div>
				                    </a> 
				                    <div class="lightbox-target" id="enlarge<%=i %>">
				                        <%=image%>
				                       <a class="lightbox-close" href="#"></a>
				                    </div>                        			
                        		<%
                        	} else {
                        		%>
                        			<div>
			                            <%=image%>	                            							                            
			                        </div>
                        		<%
                        	}
                        %>
	                </div>
	                <div class="caption font-s">
	                    <x:out select="$widget/Field[@name='Caption']" escapeXml="false"/> 
	                </div>
	            </div>
	            <div class="clear"></div>
	        </div>
   		</x:if>	
   	</x:if>
   	<x:if select="$widgetName = 'RichContent'">
   		<%
           	Element contentWidget = (Element)contentDocument.selectSingleNode("/PageContent/Widget[@name='WidgetHolder']/Widget[" + i + "]");			
       	%>
   		<div class='widget rec'>
   			<%= XmlUtils.getFieldRaw(contentWidget, "Content") %>
   			
   			<!-- Using below will have issue when insert table, it will auto gen many <br> before the table, don't know the reason  -->
   			<!--x:out select="$widget/Field[@name='Content']" escapeXml="false" /-->
   		</div>
   	</x:if>
   	<x:if select="$widgetName = 'PhotoSliders'">
   		<c:if test="${isPageAdmin}">
   			<div class="widget">   
   		</c:if>
   			<x:if select="$widget/Widget[@name='PhotoSlider']">
		        <div class="content_slider">
		            <ul class="content_slider_ul">
		            	<% int j = 1; %>
				   		<x:forEach select="$widget/Widget[@name='PhotoSlider']" var="slider" varStatus="status">
					   		<%
					           	Element imageNode = (Element)contentDocument.selectSingleNode("/PageContent/Widget[@name='WidgetHolder']/Widget[" + i + "]/Widget[" + j + "]/Field[@name='Image']");
								String image = XmlUtils.tagimg(imageNode, Global.IMAGE_SOURCE, true, "", null);
								
								Element linkNode = (Element)contentDocument.selectSingleNode("/PageContent/Widget[@name='WidgetHolder']/Widget[" + i + "]/Widget[" + j + "]/Field[@name='Link']");						
								String linkAttr = XmlUtils.getLinkAttr(linkNode, lang, iscms);
								
								String imageHtml = StringUtils.isBlank(linkAttr) ? image : ("<a " + linkAttr + ">" + image + "</a>");
					       	%>
		                	<li class="content_slider_li_<%=j%>"><%=imageHtml %></li>
				   			
				   			<% j++; %>
				   		</x:forEach>                
		            </ul>
		            <a class="button button_js slider_prev" href="#"><span class="button_icon"><i class="fa fa-angle-left"></i></span></a>
		            <a class="button button_js slider_next" href="#"><span class="button_icon"><i class="fa fa-angle-right"></i></span></a>
		            <div class="slider_pagination"></div>
		        </div>
   			</x:if>	
        <c:if test="${isPageAdmin}">
   			</div>   
   		</c:if>        
   	</x:if>
   	
   	<x:if select="$widgetName = 'ColumnImages'">
       	<div class="widget sm-img group">
           	<% int j = 1; %>
	   		<x:forEach select="$widget/Widget[@name='ColumnImage']" var="imageItem" varStatus="status">
		   		<%
		           	Element imageNode = (Element)contentDocument.selectSingleNode("/PageContent/Widget[@name='WidgetHolder']/Widget[" + i + "]/Widget[" + j + "]/Field[@name='Image']");					
          			String imageUrl = Global.getImagesUploadPath(Global.IMAGE_SOURCE, imageNode.getTextTrim());
		       	%>
            	<div class="col span_1_of_4" style="background: url('<%=imageUrl%>') #ececec no-repeat center center; background-size: contain;"></div>	   			
	   			<% j++; %>
	   		</x:forEach>
	   		<%
	   			if(j == 1) {
	   				%>
	   					<c:if test="${ isPageAdmin }">
	       					<div style="text-align:center"># Configure Column Image Item</div>
	   					</c:if>
	   				<%
	   			}
	   		%>       
            <div class="clear"></div>
    	</div>
   	</x:if>
   	<x:if select="$widgetName = 'ActionButton'">   			
       	<%
            Element linkNode = (Element)contentDocument.selectSingleNode("/PageContent/Widget[@name='WidgetHolder']/Widget[" + i + "]/Field[@name='Link']");
			Element textNode = (Element)contentDocument.selectSingleNode("/PageContent/Widget[@name='WidgetHolder']/Widget[" + i + "]/Field[@name='Text']");
			Map<String, String> othattrs = new HashMap<String, String>();
			othattrs.put("class", "button");
			String linkAttr = XmlUtils.getLinkAttr(linkNode, lang, iscms, othattrs);				
			if(!StringUtils.isBlank(textNode.getTextTrim()) || iscms) {
				%>
        			<a class="button" <%=linkAttr %>><span class="widget g-btn"><%=textNode.getTextTrim() %></span></a>
				<%
			}
        %>        
   	</x:if>  
   	<x:if select="$widgetName = 'PhotoAlbums'">
       	<%
       		Element widget = (Element)contentDocument.selectSingleNode("/PageContent/Widget[@name='WidgetHolder']/Widget[" + i + "]");
            Element linkNode = (Element)widget.selectSingleNode("Field[@name='Link']");			
			String linkAttr = XmlUtils.getLinkAttr(linkNode, lang, iscms);			
			String year = XmlUtils.getFieldRaw(widget, "Date").split("-")[0];
			
			List<Element> imageNodes = (List<Element>)widget.selectNodes("Widget[@name='PhotoAlbum']");
			boolean hasImage = imageNodes != null && imageNodes.size() > 0;
			String noImageClass = hasImage ? "" : "no-img";
			String noImageBackground = hasImage ? "" : "style='background-color:#17bbce;'";
        %>           	
        <c:set var="hasImage" value="<%=hasImage%>"></c:set>
    	<div <%=noImageBackground%> class="photo-gallery post-item isotope-item clearfix <%=noImageClass%> <%=year%> cat-<x:out select="$widget/Field[@name='Category']" escapeXml="false"/>">
   			<div class="widget">
		        <div class="post-photo-wrapper">
		        	<c:if test="${hasImage}">		        	
		            	<img src="<%=Global.getImagesUploadPath(Global.IMAGE_SOURCE) %>/<x:out select="$widget/Widget[@name='PhotoAlbum'][1]/Field[@name='Image']" escapeXml="false"/>"/>
		            </c:if>		         
		        </div>
		        <div class="post-desc-wrapper">
            		<c:if test="${hasImage}"> 
			            <div class="post-desc dark">
			                <div class="post-head">
			                    <div class="post-meta clearfix">
			                        <div class="author-date"><span><x:out select="$widget/Field[@name='Date']" escapeXml="false"/></span></div>
			                    </div>
			                </div>
			                <div class="post-title">
			                    <h2 class="entry-title"><a <%=linkAttr%>><x:out select="$widget/Field[@name='Title']" escapeXml="false"/></a></h2>
			                </div>
			                <div class="links-wrappper clearfix" >
			                	<c:set var="first" value="true"></c:set>
						   		<x:forEach select="$widget/Widget[@name='PhotoAlbum']" var="album" varStatus="status">
				                    <c:if test="${not first}">
				                    	<a href="<%=Global.getImagesUploadPath(Global.IMAGE_SOURCE) %>/<x:out select="$album/Field[@name='Image']" escapeXml="false"/>" rel="prettyPhoto[gallery2]"  style="display:none;"></a>
				                    </c:if>						   			
						   			<c:if test="${first}">
				                    	<a href="<%=Global.getImagesUploadPath(Global.IMAGE_SOURCE) %>/<x:out select="$album/Field[@name='Image']" escapeXml="false"/>" rel="prettyPhoto[gallery2]"><i class="fa fa-expand <%=XmlUtils.getFieldAttr(widget, "id") %>"></i></a>
				                    	<c:set var="first" value="first"></c:set>
				                    </c:if>				                   
								</x:forEach> 		      
			                </div>
			            </div>
	            	</c:if>
		            <c:if test="${not hasImage}">                    
	                    <div class="post-desc">
	                        <div class="post-title">
	                            <h2 class="entry-title"><a <%=linkAttr%>><x:out select="$widget/Field[@name='Title']" escapeXml="false"/></a></h2>
	                        </div>
	                    </div>
		            </c:if>
		        </div>
   			</div>
       	</div>	   
   	</x:if>    	
   	
  	<x:if select="$widgetName = 'Html5VideoStyleGallery'">
  	    <%
       		Element widget = (Element)contentDocument.selectSingleNode("/PageContent/Widget[@name='WidgetHolder']/Widget[" + i + "]");
  	  		Element linkNode = (Element)widget.selectSingleNode("Field[@name='Link']");			
			String linkAttr = XmlUtils.getLinkAttr(linkNode, lang, iscms);	
			String year = XmlUtils.getFieldRaw(widget, "Date").split("-")[0];
			String youTubeID = XmlUtils.getFieldRaw(widget, "YouTubeID");
			String categoryStr = "";
			for(String category : XmlUtils.getFieldRaw(widget, "Category").split(";")) {
				if(!StringUtils.isBlank(category))
					categoryStr += ("cat-" + category.replaceAll("=", "") + " ");
			}
        %>
		<div class="widget format-video <%=year%> <%=categoryStr%> post-item isotope-item clearfix">
			<x:choose>
			   <x:when select="$widget/Field[@name='Video'] != ''">
			        <div id="jp_container_<%=i %>" class="jp-video mfn-jcontainer jp-video-360p">
			            <div class="jp-type-single">
			                <div id="jquery_jplayer_<%=i %>" class="jp-jplayer mfn-jplayer" data-m4v="<%=Global.getDocUploadPath() %>/<x:out select="$widget/Field[@name='Video']" escapeXml="false"/>" data-img="<%=Global.getImagesUploadPath(Global.IMAGE_SOURCE) %>/<x:out select="$widget/Field[@name='Image']" escapeXml="false"/>"></div>
			                <%@ include file="/WEB-INF/Shared/Video.jsp" %>
			            </div>
			        </div>			      
			   </x:when>
			   <x:when select="$widget/Field[@name='YouTubeID'] != ''">		      
			   		<iframe width="576" height="450" src="http://www.youtube.com/embed/<%=youTubeID %>?rel=0&amp;hd=1" frameborder="0" allowfullscreen=""></iframe>
			   </x:when>			   
			   <x:otherwise>
			   		<a <%=linkAttr%>><img width="576" height="450" src="<%=Global.getImagesUploadPath(Global.IMAGE_SOURCE) %>/<x:out select="$widget/Field[@name='Image']" escapeXml="false"/>" class="img-scale"/></a>			      
			   </x:otherwise>
			</x:choose>
	        <div class="post-desc-wrapper">
	            <div class="post-desc">
	                <div class="post-date font-s"><x:out select="$widget/Field[@name='Date']" escapeXml="false"/></div>
	                <h3 class="txt-red"><x:out select="$widget/Field[@name='Title']" escapeXml="false"/></h3>
	                <div class="post-content"><x:out select="$widget/Field[@name='Content']" escapeXml="false"/></div>
	            </div>
	        </div>
	    </div>          	
   	</x:if>
	<%--
	<x:if select="$widgetName = 'YoutubeStyleGallery'">
       	<%
       		Element widget = (Element)contentDocument.selectSingleNode("/PageContent/Widget[@name='WidgetHolder']/Widget[" + i + "]");
            Element linkNode = (Element)widget.selectSingleNode("Field[@name='Link']");			
			String linkAttr = XmlUtils.getLinkAttr(linkNode, lang, iscms);
			String year = XmlUtils.getFieldRaw(widget, "Date").split("-")[0];
			String categoryStr = "";
			for(String category : XmlUtils.getFieldRaw(widget, "Category").split(";")) {
				if(!StringUtils.isBlank(category))
					categoryStr += ("cat-" + category.replaceAll("=", "") + " ");
			}
        %> 
	    <div class="widget <%=year%> <%=categoryStr%> post-item isotope-item clearfix">
	        <a <%=linkAttr%>><img width="576" height="450" src="<%=Global.getImagesUploadPath(Global.IMAGE_SOURCE) %>/<x:out select="$widget/Field[@name='Image']" escapeXml="false"/>" class="img-scale"/></a>
	        <div class="post-desc-wrapper">
	            <div class="post-desc">
	                <div class="post-date font-s"><x:out select="$widget/Field[@name='Date']" escapeXml="false"/></div>
	                <h3 class="txt-red"><x:out select="$widget/Field[@name='Title']" escapeXml="false"/></h3>
	                <div class="post-content"><x:out select="$widget/Field[@name='Content']" escapeXml="false"/></div>
	            </div>
	        </div>
	    </div>
   	</x:if> 
   	--%>
   	<%--
   	<x:if select="$widgetName = 'DescriptionStyleGallery'">
   	  	<%
       		Element widget = (Element)contentDocument.selectSingleNode("/PageContent/Widget[@name='WidgetHolder']/Widget[" + i + "]");
			String year = XmlUtils.getFieldRaw(widget, "Date").split("-")[0];
			String categoryStr = "";
			for(String category : XmlUtils.getFieldRaw(widget, "Category").split(";")) {
				if(!StringUtils.isBlank(category))
					categoryStr += ("cat-" + category.replaceAll("=", "") + " ");
			}
        %>
		<div class="widget <%=year%> <%=categoryStr%> post-item isotope-item clearfix">
            <div class="post-desc-wrapper">
                <div class="post-desc">
                    <div class="post-date font-s"><x:out select="$widget/Field[@name='Date']" escapeXml="false"/></div>
                    <h3 class="txt-red"><x:out select="$widget/Field[@name='Title']" escapeXml="false"/></h3>
                    <div class="post-content"><x:out select="$widget/Field[@name='Content']" escapeXml="false"/></div>
                </div>
            </div>
    	</div>
   	</x:if>
   	--%>
   	<x:if select="$widgetName = 'ImageStyleGallery'">
   		<%
       		Element widget = (Element)contentDocument.selectSingleNode("/PageContent/Widget[@name='WidgetHolder']/Widget[" + i + "]");
   			Element linkNode = (Element)widget.selectSingleNode("Field[@name='Link']");			
			String linkAttr = XmlUtils.getLinkAttr(linkNode, lang, iscms);	
			String year = XmlUtils.getFieldRaw(widget, "Date").split("-")[0];
			String categoryStr = "";
			for(String category : XmlUtils.getFieldRaw(widget, "Category").split(";")) {
				if(!StringUtils.isBlank(category))
					categoryStr += ("cat-" + category.replaceAll("=", "") + " ");
			}
        %>
	 	<div class="widget <%=year%> <%=categoryStr%> post-item isotope-item clearfix">
        	<a <%=linkAttr%>>	 		
        		<x:if select="$widget/Field[@name='Image'] != ''">
		            <div class="withlink-blk">
		                <div class="box-row">  <!-- btn for desktop only!-->
		                    <div class="box"><i class="fa fa-external-link"></i></div>
		                </div>
		                <img width="576" height="450" src="<%=Global.getImagesUploadPath(Global.IMAGE_SOURCE) %>/<x:out select="$widget/Field[@name='Image']" escapeXml="false"/>" class="img-scale"/>
		            </div>
	            </x:if>
	     
	            <div class="post-desc-wrapper">
	                <div class="post-desc">
	                    <div class="post-date font-s"><x:out select="$widget/Field[@name='Date']" escapeXml="false"/></div>
	                    <h3 class="txt-red"><x:out select="$widget/Field[@name='Title']" escapeXml="false"/></h3>
	                    <div class="post-content"><x:out select="$widget/Field[@name='Content']" escapeXml="false"/></div>
	                    
               	 		<x:if select="$widget/Field[@name='Link'] != ''">
		                    <div class="post-footer link-blk-m"> <!-- btn for tablet & mobile!-->
		                        <div class="box"><i class="fa fa-external-link"></i></div>
		                        <div class="clear"></div>
		                    </div>
        				</x:if>
	                </div>
	            </div>	        
        	</a>	        
	    </div>
   	</x:if>
   	<x:if select="$widgetName = 'ImageDetailStyleGallery'">
   	  	<%
       		Element widget = (Element)contentDocument.selectSingleNode("/PageContent/Widget[@name='WidgetHolder']/Widget[" + i + "]");
			String year = XmlUtils.getFieldRaw(widget, "Date").split("-")[0];
			String categoryStr = "";
			for(String category : XmlUtils.getFieldRaw(widget, "Category").split(";")) {
				if(!StringUtils.isBlank(category))
					categoryStr += ("cat-" + category.replaceAll("=", "") + " ");
			}
        %>
        <div class="widget <%=year%> <%=categoryStr%> post-item isotope-item clearfix">
	        <a href="<%=detailPageUrl%>videoPageId=<%=currentPage.getId() %>&videoId=<x:out select="$widget/@id" escapeXml="false"/>">
	            <div class="withlink-blk">
	                <div class="box-row">  <!-- btn for desktop only!-->
	                    <div class="box"><i class="gi gi-more"></i></div>
	                </div>
	                <img width="576" height="450" src="<%=Global.getImagesUploadPath(Global.IMAGE_SOURCE) %>/<x:out select="$widget/Field[@name='Image']" escapeXml="false"/>" class="img-scale"/>
	            </div>
	     
	            <div class="post-desc-wrapper">
	                <div class="post-desc">
	                    <div class="post-date font-s"><x:out select="$widget/Field[@name='Date']" escapeXml="false"/></div>
	                    <h3 class="txt-red"><x:out select="$widget/Field[@name='Title']" escapeXml="false"/></h3>
	                    <div class="post-content"><x:out select="$widget/Field[@name='Content']" escapeXml="false"/></div>
	                    
	                    <div class="post-footer link-blk-m"> <!-- btn for tablet & mobile!-->
	                        <div class="box"><i class="gi gi-more"></i></div>
	                        <div class="clear"></div>
	                    </div>
	                </div>
	            </div>
	        </a>
	    </div>
   	</x:if>
   	<x:if select="$widgetName = 'ImageDocumentAndDetailStyleGallery'">
   	  	<%
       		Element widget = (Element)contentDocument.selectSingleNode("/PageContent/Widget[@name='WidgetHolder']/Widget[" + i + "]");
			String year = XmlUtils.getFieldRaw(widget, "Date").split("-")[0];
			String categoryStr = "";
			for(String category : XmlUtils.getFieldRaw(widget, "Category").split(";")) {
				if(!StringUtils.isBlank(category))
					categoryStr += ("cat-" + category.replaceAll("=", "") + " ");
			}
        %>
		<div class="widget <%=year%> <%=categoryStr%> post-item isotope-item clearfix">
        	<a href="<%=detailPageUrl%>newsPageId=<%=currentPage.getId() %>&newsId=<x:out select="$widget/@id" escapeXml="false"/>"><img width="576" height="450" src="<%=Global.getImagesUploadPath(Global.IMAGE_SOURCE) %>/<x:out select="$widget/Field[@name='Image']" escapeXml="false"/>" class="img-scale"/></a>

            <div class="post-desc-wrapper">
	            <div class="post-desc">
	                <div class="post-date font-s"><x:out select="$widget/Field[@name='Date']" escapeXml="false"/></div>
	                <a href="news-detail.html">
	                    <h3 class="txt-red"><x:out select="$widget/Field[@name='Title']" escapeXml="false"/></h3>
	                    <div class="post-content"><x:out select="$widget/Field[@name='Content']" escapeXml="false"/></div>
	                </a>
	                <div class="post-footer">
	                    <a href="<%=detailPageUrl%>newsPageId=<%=currentPage.getId() %>&newsId=<x:out select="$widget/@id" escapeXml="false"/>"><div class="box"><i class="gi gi-more"></i></div></a>
	                    <a href="<%=Global.getDocUploadPath() %>/<x:out select="$widget/Field[@name='Document']" escapeXml="false"/>"> <div class="box"><i class="fa fa-download"></i></div></a>
	                    <div class="clear"></div>
	                </div>
	            </div>
        	</div>
    	</div>
   	</x:if> 
   	<x:if select="$widgetName = 'SliderStyleGallery'">
   	  	<%
       		Element widget = (Element)contentDocument.selectSingleNode("/PageContent/Widget[@name='WidgetHolder']/Widget[" + i + "]");
			String year = XmlUtils.getFieldRaw(widget, "Date").split("-")[0];
			String categoryStr = "";
			for(String category : XmlUtils.getFieldRaw(widget, "Category").split(";")) {
				if(!StringUtils.isBlank(category))
					categoryStr += ("cat-" + category.replaceAll("=", "") + " ");
			}
        %>
		<div class="news-gallery <%=year%> <%=categoryStr%> post-item isotope-item clearfix">
			<div class="widget">
		        <div class="image_frame post-photo-wrapper">
		            <div class="image_wrapper">
		                <div id="rev_slider_16_2_wrapper" class="rev_slider_wrapper">
		                    <div id="rev_slider_16_2" class="rev_slider" data-version="5.0.4.1">
		                        <ul>		                        
	   						   		<x:forEach select="$widget/Widget[@name='Slider']" var="slider" varStatus="status">				                    			                  
			                            <li data-index="rs-21" data-transition="fade" data-slotamount="7" data-easein="default" data-easeout="default" data-masterspeed="300" data-rotate="0" data-saveperformance="off" data-title="Slide" data-description="">
			                                <img src="<%=Global.getImagesUploadPath(Global.IMAGE_SOURCE) %>/<x:out select="$slider/Field[@name='Image']" escapeXml="false"/>"  alt="<x:out select="$slider/Field[@name='Image']/alt" escapeXml="false"/>" data-lazyload="<%=Global.getImagesUploadPath(Global.IMAGE_SOURCE) %>/<x:out select="$slider/Field[@name='Image']" escapeXml="false"/>" data-bgposition="center top" data-bgfit="100%" data-bgrepeat="no-repeat" data-bgparallax="off" class="rev-slidebg" data-no-retina  >
			                            </li>
									</x:forEach> 	                        
		                        </ul>
		                        <div class="tp-bannertimer flv_rev_21"></div>
		                    </div>
		                </div>
		            </div>
		        </div>
		        <div class="post-desc-wrapper">
		            <div class="post-desc">
		                <div class="post-date font-s"><x:out select="$widget/Field[@name='Date']" escapeXml="false"/></div>
		                <h3 class="txt-red"><x:out select="$widget/Field[@name='Title']" escapeXml="false"/></h3>
		                <div class="post-content"><x:out select="$widget/Field[@name='Content']" escapeXml="false"/></div>
		            </div>
		        </div>
	        </div>
    	</div>
   	</x:if>
   	
   	<x:if select="$widgetName = 'AccordionOrToggles'">  
		<div class="col2-table-halfRow widget">                        
	        <h2><x:out select="$widget/Field[@name='Title']" escapeXml="false"/></h2>
	        <div class="accordion">	        	
	            <div class="mfn-acc accordion_wrapper open1st <x:out select="$widget/Field[@name='Type']" escapeXml="false"/>">
              		<x:forEach select="$widget/Widget[@name='AccordionOrToggle']" var="item" varStatus="status">
		                <div class="question">
		                    <div class="title">
		                        <i class="fa fa-plus acc-icon-plus"></i><i class="fa fa-minus acc-icon-minus"></i><x:out select="$item/Field[@name='Title']" escapeXml="false"/>
		                    </div>
		                    <div class="answer">
		                        <x:out select="$item/Field[@name='Content']" escapeXml="false"/>
		                    </div>
		                </div>	   		   			
   					</x:forEach>	                
	            </div>
	        </div>                        
		</div>
   	</x:if>	
   	
	<% i++; %>
</x:forEach>