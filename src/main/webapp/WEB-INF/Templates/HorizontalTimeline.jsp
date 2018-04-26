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
<%@page import="com.edeas.utils.DateUtils"%>
<link href="${Content}/css/flat.css" rel="stylesheet" type="text/css" />
<link href="${Content}/css/lightbox.css" rel="stylesheet" type="text/css" />
<link href="${Content}/css/jquery.mCustomScrollbar.css" rel="stylesheet" type="text/css" />

<script type="text/javascript" src="${Script}/timeline-horizontal/jquery.mCustomScrollbar.js"></script>
<script type="text/javascript" src="${Script}/timeline-horizontal/jquery.easing.1.3.js"></script>
<script type="text/javascript" src="${Script}/timeline-horizontal/jquery.timeline.min.js"></script>
<script type="text/javascript" src="${Script}/timeline-horizontal/image.js"></script>
<script type="text/javascript" src="${Script}/timeline-horizontal/lightbox.js"></script>

<%
	Page currentPage = (Page)request.getAttribute("currentPage");
	boolean iscms = (Boolean)request.getAttribute("iscms");
	boolean isPageAdmin = (Boolean)request.getAttribute("isPageAdmin");
	String lang = (String)request.getAttribute("lang");
	
	Content content = currentPage.getContent(lang);	
	Document contentDocument = content.getContentXmlDoc();
	
	List<Element> elements = (List<Element>)contentDocument.selectNodes("/PageContent/Widget[@name='HorizontalTimelineBlks']/Widget[@name='HorizontalTimelineBlk']");
	
	Map<Integer, Element> elementWithDateMap = new TreeMap<Integer, Element>(new Comparator<Integer>() {          
       public int compare(Integer a,Integer b) {  
           return a-b;           
       }  
    });
	for(Element element : elements) {
		String date = XmlUtils.getFieldRaw(element, "Date");
		if(!StringUtils.isBlank(date)) {		
			int dateInt = Integer.parseInt(date.replaceAll("-", ""));
			if (!elementWithDateMap.containsKey(dateInt)) {
				elementWithDateMap.put(dateInt, element);
			}
		}
	}	
	
	elements.clear();
	for(Integer key : elementWithDateMap.keySet()) {
		elements.add(elementWithDateMap.get(key));				
	}
	
	String startDateId = "";
	String startDate = XmlUtils.getPtyFieldVal(content.getPropertyXmlDoc(), "StartDate", false);
	if (!StringUtils.isBlank(startDate)) {
		String year = startDate.split("-")[0];
		String month = startDate.split("-")[1];
		String day = startDate.split("-")[2];
		startDateId = day + "/" + month + "/" + year;
	}
%>

<script type="text/javascript">
    $(window).load(function() {
        // light
        $('.tl1').timeline({
            openTriggerClass : '.read_more',
            startItem : '<%=startDateId%>',
            closeText : 'x',
            ajaxFailMessage: 'This ajax fail is made on purpose. You can add your own message here, just remember to escape single quotes if you\'re using them.'
        });
        $('.tl1').on('ajaxLoaded.timeline', function(e){
            var height = e.element.height()-60-e.element.find('h2').height();
            e.element.find('.timeline_open_content span').css('max-height', height).mCustomScrollbar({
                autoHideScrollbar:true,
                theme:"light-thin"
            }); 
        });
        
    }); 
</script>
<style>
	.image_roll_zoom { background : unset !important; }
</style>

<div class="full-wrapper timeline-pos clearfix"> 
	<div class="timelineLoader">
    	<img src="${Content}/css/images-timeline-horizontal/loadingAnimation.gif" />
    </div>
    <div class="timelineFlat tl1">
    	<%
    		for(Element element : elements) {
              	String date = XmlUtils.getFieldRaw(element, "Date");
              	String dateId = "";
              	String dateStr = "";
            	if(!StringUtils.isBlank(date)) {
            		String year = date.split("-")[0];
            		String month = date.split("-")[1];
            		String day = date.split("-")[2];
            		dateId = day + "/" + month + "/" + year;
            		dateStr = DateUtils.toMonth(Integer.parseInt(month), true) + ", " + Integer.parseInt(day) + " " + Integer.parseInt(year);
            	}
            	String detail = XmlUtils.getFieldRaw(element, "Detail", false);
    			%>
                <div class="item" data-id="<%=dateId%>" data-description="<c:out value='<%=XmlUtils.getFieldRaw(element, "Description")%>' escapeXml="false"></c:out>">
                    <a class="image_rollover_bottom con_borderImage" data-description="ZOOM IN" href="<%=Global.getImagesUploadPath(Global.IMAGE_SOURCE, XmlUtils.getFieldRaw(element, "Image")) %>" rel="lightbox[timeline]">
                    	<img src="<%=Global.getImagesUploadPath(Global.IMAGE_SOURCE, XmlUtils.getFieldRaw(element, "Image")) %>" alt="<%=XmlUtils.getWidgetFieldAttr(element, "Image", "alt") %>"/>
                    </a>
                    <h2><%=dateStr%></h2>
                    <span><c:out value='<%=XmlUtils.getFieldRaw(element, "Content", false)%>' escapeXml="false"></c:out></span>
                    <%if(!StringUtils.isBlank(detail)) {%>
                    	<div class="read_more" data-id="<%=dateId%>"><%= lang.equals("en") ? "Read more" : (lang.equals("tc") ? "閱讀更多" : "阅读更多") %></div>
                    <%}%>
                </div>
                <div class="item_open" data-id="<%=dateId%>" data-access="<%=Global.getWebUrl() %>/common/timelineDetail?iscms=${iscms}&lang=${lang}&pageId=${currentPage.id}&timelineId=<%=XmlUtils.getFieldAttr(element, "id") %>">
                    <div class="item_open_content">
                        <img class="ajaxloader" src="${Content}/css/images-timeline-horizontal/loadingAnimation.gif" alt="" />
                    </div>
                </div>
    			<%
    		}
    	%>
    </div>
</div>