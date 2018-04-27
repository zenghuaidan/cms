<%@page import="com.edeas.utils.DateUtils"%>
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
<%@page contentType="text/html;charset=UTF-8"%>
<link href="${Content}/css/timeline-vertical.css" rel="stylesheet" type="text/css" />

<script type="text/javascript" src="${Script}/vertical-timeline/modernizr.js"></script>
<script type="text/javascript" src="${Script}/vertical-timeline/main.js"></script>


<%
	Page currentPage = (Page)request.getAttribute("currentPage");
	boolean iscms = (Boolean)request.getAttribute("iscms");
	boolean isPageAdmin = (Boolean)request.getAttribute("isPageAdmin");
	String lang = (String)request.getAttribute("lang");
	
	Content content = currentPage.getContent(lang);		
	Document contentDocument = content.getContentXmlDoc();
	List<Element> elements = (List<Element>)contentDocument.selectNodes("/PageContent/Widget[@name='TimelineBlks']/Widget[@name='TimelineBlk']");
	
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
	
%>
<div class="full-wrapper clearfix bg-teal"> 
    <div class="inner-wrapper">
        <div class="main-content-pos">
           	<section id="cd-timeline" class="cd-container">
           		<%
           			for(Element element : elements) {
           				%>
                        <div class="cd-timeline-block">
                            <div class="cd-timeline-img">
                            </div>

                            <div class="cd-timeline-content">                                
                                <h2><c:out value='<%=XmlUtils.getFieldRaw(element, "Title", true)%>' escapeXml="false"></c:out></h2>
		                        <p><c:out value='<%=XmlUtils.getFieldRaw(element, "Content", true)%>' escapeXml="false"></c:out></p>
                                <!--a href="#0" class="cd-read-more">Read more</a-->
                                <%
                                	String date = XmlUtils.getFieldRaw(element, "Date");
                                	if(!StringUtils.isBlank(date)) {
                                		int month = Integer.parseInt(date.split("-")[1]);
                                		int day = Integer.parseInt(date.split("-")[2]);
                                		%>
                                			<span class="cd-date"><%=DateUtils.toMonth(month, true)%> <%=day%></span>
                                		<%
                                	}
                                %>
                            </div>
                        </div>
           				<%
           			}
           		%>           		
           	</section>
    	</div>
    </div>
</div>