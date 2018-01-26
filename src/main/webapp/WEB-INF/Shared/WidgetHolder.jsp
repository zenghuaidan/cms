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
   
	<% i++; %>   
</x:forEach>