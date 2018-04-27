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
<link href="${Content}/css/contact-us.css" rel="stylesheet" type="text/css" />

<script type="text/javascript" src="${Script}/form-step/modernizr.custom.js"></script>
<script async defer src="https://maps.googleapis.com/maps/api/js?key=AIzaSyCaswVF0mKq0nw3dfItQVeVtr3x6GbBO_g&callback=initMap" type="text/javascript"></script>

<script type="text/javascript" src="${Script}/google-map.js"></script>

<% 
	boolean iscms = (Boolean)request.getAttribute("iscms");
	String lang = (String)request.getAttribute("lang");	
	Page currentPage = (Page)request.getAttribute("currentPage");
	Content pageContent = currentPage.getContent(lang);
	Document contentDocument = pageContent.getContentXmlDoc();
%>
<x:parse xml="<%=pageContent.getContentXmlWithoutCRLF() %>" var="contentXml"></x:parse>

<script type="text/javascript">
	function initMap() {
	    var myLatLng = {lat: <x:out select="$contentXml/PageContent/Widget[@name='GoogleMap']/Field[@name='Latitude']" escapeXml="false"/>, lng: <x:out select="$contentXml/PageContent/Widget[@name='GoogleMap']/Field[@name='Longitude']" escapeXml="false"/>};
	
	    var map = new google.maps.Map(document.getElementById('map'), {
	        zoom: 18,
	        center: myLatLng,
	        scrollwheel: false,
	        disableDoubleClickZoom: true,
	        zoomControl: false,
	        disableDefaultUI: true, // a way to quickly hide all controls
	        mapTypeControl: false,
	        styles: gmapOldStyle // the style is defined here
	      });
	
	    var image = '<%=Global.getDocUploadPath() %>/<x:out select="$contentXml/PageContent/Widget[@name='GoogleMap']/Field[@name='Image']" escapeXml="false"/>';
	    var beachMarker = new google.maps.Marker({
	      position: {lat: <x:out select="$contentXml/PageContent/Widget[@name='GoogleMap']/Field[@name='Latitude']" escapeXml="false"/>, lng: <x:out select="$contentXml/PageContent/Widget[@name='GoogleMap']/Field[@name='Longitude']" escapeXml="false"/>},
	      map: map,
	      icon: image
	    });
	
	    beachMarker.setAnimation(google.maps.Animation.BOUNCE);
	}
	
	$(function() {
		//initMap();
	})
</script>

<div class="general full-wrapper clearfix"> 
    <div class="inner-wrapper">
        <div class="main-contact-pos">
            <div class="map-blk">
                <div id="map"></div>
                <div class="overlay"></div>
            </div>
            <c:if test="${isPageAdmin}">
            	<div id="GoogleMapInfos">
            </c:if>
            <x:forEach select="$contentXml/PageContent/Widget[@name='GoogleMapInfos']/Widget[@name='GoogleMapInfo']" var="GoogleMapInfo" varStatus="status">
	            <div class="col2-table-row">
	                <div class="table-col field"><x:out select="$GoogleMapInfo/Field[@name='Title']" escapeXml="false"/></div>
	                <div class="table-col detail"><x:out select="$GoogleMapInfo/Field[@name='Content']" escapeXml="false"/></div>
	            </div>            	                         
			</x:forEach>            
            <c:if test="${isPageAdmin}">
            	</div>
            </c:if>
        </div>
    </div>
</div>
 