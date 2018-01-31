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
   	<x:if select="$widgetName = 'LeftRightPhotoBlk'">
		<%
           	Element imageNode = (Element)contentDocument.selectSingleNode("/PageContent/Widget[@name='WidgetHolder']/Widget[" + i + "]/Field[@name='Image']");
			String image = XmlUtils.tagimg(imageNode, Global.IMAGE_SOURCE, false, "", null);
       	%>
   		<x:if select="$widget/Field[@name='ImageLeft'] = 'true'">
   			<div class="widget content-right">
        		<div class="cr-left">
	                <div class="enlarge-img-blk">
	                    <a class="lightbox" href="#enlarge">
	                        <div>
	                            <%=image%>
	                            <div class="enlarge-icon"><i class="fa fa-expand"></i></div>
	                        </div>
	                    </a> 
	                    <div class="lightbox-target" id="enlarge">
	                        <%=image%>
	                       <a class="lightbox-close" href="#"></a>
	                    </div>
	                </div>
	
	                <div class="caption font-s">
	                    <x:out select="$widget/Field[@name='Caption']" escapeXml="false"/>
	                </div>
	            </div>
	            <div class="cr-right"><x:out select="$widget/Field[@name='Content']" escapeXml="false"/></div>
	            <div class="clear"></div>
	        </div>
   		</x:if>
   		<x:if select="$widget/Field[@name='ImageLeft'] = 'false'">
	        <div class="widget content-left">
	            <div class="cl-left"><x:out select="$widget/Field[@name='Content']" escapeXml="false"/></div>
	            <div class="cl-right">
	                <div class="enlarge-img-blk">
	                    <a class="lightbox" href="#enlarge">
	                        <div>
	                            <%=image%>
	                            <div class="enlarge-icon"><i class="fa fa-expand"></i></div>
	                        </div>
	                    </a> 
	                    <div class="lightbox-target" id="enlarge">
	                        <%=image%>
	                       <a class="lightbox-close" href="#"></a>
	                    </div>
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
   		<div class='widget rec'><x:out select="$widget/Field[@name='Content']" escapeXml="false"/></div>
   	</x:if>
   	<x:if select="$widgetName = 'PhotoSliders'">
   		<c:if test="${isPageAdmin}">
   			<div class="widget">   
   		</c:if>		
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
            	<div class="col span_1_of_4" style="background: url('<%=imageUrl%>')"></div>	   			
	   			<% j++; %>
	   		</x:forEach>
	   		<%
	   			if(j == 1) {
	   				%>
       					<div style="text-align:center"># Configure Column Image Item</div>
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
			if(!StringUtils.isBlank(textNode.getTextTrim()) && !StringUtils.isBlank(linkAttr)) {
				%>
        			<a <%=linkAttr %>><span class="widget g-btn"><%=textNode.getTextTrim() %></span></a>
				<%
			}
        %>        
   	</x:if>  
   	<x:if select="$widgetName = 'PhotoAlbums'">
       	<%
            Element linkNode = (Element)contentDocument.selectSingleNode("/PageContent/Widget[@name='WidgetHolder']/Widget[" + i + "]/Field[@name='Link']");			
			String linkAttr = XmlUtils.getLinkAttr(linkNode, lang, iscms);			
			Element dateNode = (Element)contentDocument.selectSingleNode("/PageContent/Widget[@name='WidgetHolder']/Widget[" + i + "]/Field[@name='Date']");
			String year = dateNode.getTextTrim().split("-")[0];
			
			List<Element> imageNodes = (List<Element>)contentDocument.selectNodes("/PageContent/Widget[@name='WidgetHolder']/Widget[" + i + "]/Widget[@name='PhotoAlbum']");
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
				                    	<a href="<%=Global.getImagesUploadPath(Global.IMAGE_SOURCE) %>/<x:out select="$album/Field[@name='Image']" escapeXml="false"/>" rel="prettyPhoto[gallery2]"><i class="fa fa-expand"></i></a>
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
   
	<% i++; %>   
</x:forEach>