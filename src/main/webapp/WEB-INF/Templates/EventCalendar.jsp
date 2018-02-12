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
<%@page import="com.google.gson.Gson"%>
<%@page import="com.google.gson.Gson"%>
<%@page import="com.google.gson.GsonBuilder"%>
<%@page import="com.google.gson.reflect.TypeToken"%>
<%@page import="com.google.gson.annotations.Expose"%>
<%@page import="java.lang.reflect.InvocationTargetException"%>
<%@page import="java.lang.reflect.Type"%>
<%@page import="com.edeas.dto.*"%>
<link href="${Content}/css/calendar.css" rel="stylesheet" type="text/css" />
<%
	boolean iscms = (Boolean)request.getAttribute("iscms");
	String lang = (String)request.getAttribute("lang");	
	Page currentPage = (Page)request.getAttribute("currentPage");
	Content pageContent = currentPage.getContent(lang);
	Document contentDocument = pageContent.getContentXmlDoc();
	List<Element> eventElements = (List<Element>)contentDocument.selectNodes("/PageContent/Widget[@name='EventCalendarInfos']/Widget[@name='EventCalendarInfo']");
	List<CalendarEvent> events = new ArrayList<CalendarEvent>();
	for (Element eventElement : eventElements) {
		CalendarEvent event = new CalendarEvent();
		event.date = XmlUtils.getFieldRaw(eventElement, "Date");
		event.jobTime = XmlUtils.getFieldRaw(eventElement, "JobTime");
		event.jobDesc = XmlUtils.getFieldRaw(eventElement, "JobDesc");
		event.leisureTime = XmlUtils.getFieldRaw(eventElement, "LeisureTime");
		event.leisureDesc = XmlUtils.getFieldRaw(eventElement, "LeisureDesc");
		events.add(event);
	}	
	Type type = new TypeToken<List<CalendarEvent>>(){}.getType();
	String eventJson = new Gson().toJson(events, type);
%>
<script>
	var eventJson = eval('<%=eventJson%>');
	
	function getCalendarDates(year, month) {
		var dates = new Array();
		
		var firstDateOfMonth = new Date(year, month - 1, 1);
		var firstDay = firstDateOfMonth.getDay();
		if (firstDay != 0) {			
			for(var i = firstDay; i > 0; i--) {
				var dateOfPrevMonth = new Date(year, month - 1, 1);
				dateOfPrevMonth.setDate(dateOfPrevMonth.getDate() - i);
				dates.push(dateOfPrevMonth);	
			}	
		}				
		
		var lastDateOfMonth = new Date(year, month, 1);
		lastDateOfMonth.setDate(lastDateOfMonth.getDate() - 1);
		for(var i = 0; i < lastDateOfMonth.getDate(); i++) {
			var dateOfCurrentMonth = new Date(year, month - 1, 1);
			dateOfCurrentMonth.setDate(dateOfCurrentMonth.getDate() + i);
			dates.push(dateOfCurrentMonth);
		}		
		
		var lastDay = lastDateOfMonth.getDay();
		if (lastDay != 6) {
			for(var i = 0; i < 6 - lastDay; i++) {
				var dateOfNextMonth = new Date(year, month, 1);
				dateOfNextMonth.setDate(dateOfNextMonth.getDate() + i);
				dates.push(dateOfNextMonth);	
			}
		}
		return dates;
	}
	
	function getMonth(month) {
		return ["January", "February", "March", "April", "May", "June", "July", "Aguest", "September", "October", "November", "December"][month];
	}
	
	function initCalendar(year, month) {
		var dates = getCalendarDates(year, month);
		var html = "";
		for(var i = 0; i < dates.length; i++) {
			if (i % 7 == 0) {
				html += "<ul class='days'>";
			}
			var isSameMonth = (dates[i].getYear() + 1900) == year && dates[i].getMonth() == (month - 1);
			var isToday = dates[i].getYear() == new Date().getYear() && dates[i].getMonth() == new Date().getMonth() && dates[i].getDate() == new Date().getDate();
			html += "<li class='day" + (isSameMonth ? "" : " other-month") + (isToday ? " today" : "") + "'>" +
            			"<div class='date'>" + dates[i].getDate() + "</div>" +   
            			renderDateDesc(dates[i]) + 
            		"</li>";
			if ((i + 1) % 7 == 0) {
				html += "</ul>";
			}
		}
		$("ul.days").remove();
		$("#calendar").append($(html));
		$("#currentMonth").attr("year", year);
		$("#currentMonth").attr("month", month);
		$("#currentMonth label").text(getMonth(month - 1) + " " + year);
	}
	
	function renderDateDesc(current) {
		for(var i = 0; i < eventJson.length; i++) {
			var date = eventJson[i]["date"];
			if (date != "") {
				var year = parseInt(date.split("-")[0]);
				var month = parseInt(date.split("-")[1]);
				var day = parseInt(date.split("-")[2]);
				if (year == (current.getYear() + 1900) && month == (current.getMonth() + 1) && day == current.getDate()) {
					var html = "";
					if (eventJson[i]["jobDesc"] != '') {
                        html += "<div class='event legend1'>" + 
			                        "<div class='event-desc'>" +
			                        	eventJson[i]["jobDesc"] + 
			                        "</div>" +
			                        "<div class='event-time'>" +
			                        	renderTimeRange(eventJson[i]["jobTime"]) + 
			                        "</div>" +
			                    "</div>";
					}
					if (eventJson[i]["leisureDesc"] != '') {
						html += "<div class='event legend2'>" + 
			                        "<div class='event-desc'>" +
			                        	eventJson[i]["leisureDesc"] + 
			                        "</div>" +
			                        "<div class='event-time'>" +
			                        	renderTimeRange(eventJson[i]["leisureTime"]) + 
			                        "</div>" +
			                    "</div>";
					}
					return html;
				}
			}
		}
		return "";
	}
	
	function renderTimeRange(timeRange) {
		var fromHour = parseInt(timeRange.split("-")[0].split(":")[0]);
		var fromMinute = timeRange.split("-")[0].split(":")[1];
		var toHour = parseInt(timeRange.split("-")[1].split(":")[0]);
		var toMinute = timeRange.split("-")[1].split(":")[0];
		
		return (fromHour > 12 ? fromHour - 12 : fromHour) + ":" + fromMinute + (fromHour > 12 ? "pm" : "am") + " to "
			+ (toHour > 12 ? toHour - 12 : toHour) + ":" + toMinute + (toHour > 12 ? "pm" : "am");
	}
	
	$(function() {		
		$(".previousMonth").click(function() {
			var year = parseInt($("#currentMonth").attr("year"));
			var month = parseInt($("#currentMonth").attr("month"));
			if (month == 1) {
				year = year - 1;
				month = 12;
			} else {
				month--;
			}			
			initCalendar(year, month);
		});
		$(".nextMonth").click(function() {
			var year = parseInt($("#currentMonth").attr("year"));
			var month = parseInt($("#currentMonth").attr("month"));
			if (month == 12) {
				year = year + 1;
				month = 1;
			} else {
				month++;
			}			
			initCalendar(year, month);
		});
		initCalendar(new Date().getYear() + 1900, new Date().getMonth() + 1);
	});

</script>

<style>
	.previousMonth {
	    content: url('${Content}/css/images/icon-calendar-arrow-left.svg');
	    padding-right: 20px;
	    cursor: pointer;
	}
	.nextMonth {
	    content: url('${Content}/css/images/icon-calendar-arrow-right.svg');
	    padding-left: 20px;
	    cursor: pointer;
	}
	#calendar-wrap h1:after {
	    content: unset !important;
	    padding-left: 20px;
	    cursor: pointer;
	}
	#calendar-wrap h1:before {
	    content: unset !important;
	    padding-right: 20px;
	    cursor: pointer;
	}
</style>

<div class="full-wrapper clearfix full-calendar"> 
     <div class="inner-wrapper" style="overflow:hidden; padding-bottom:50px">
         <div class="main-calendar-pos">
             <!-- Calendar here !-->
             <div id="calendar-wrap">
                 <h1 id="currentMonth" year="" month=""><i class="previousMonth"></i><label></label><i class="nextMonth"></i></h1>
                 <div class="legend-blk">
                     <div class="legend">
                         <div>Job</div>
                         <div>Leisure</div>
                     </div>
                 </div>
                 <div class="clear"></div>
                 <div id="calendar">
                     <ul class="weekdays">
                         <li>Sunday</li>
                         <li>Monday</li>
                         <li>Tuesday</li>
                         <li>Wednesday</li>
                         <li>Thursday</li>
                         <li>Friday</li>
                         <li>Saturday</li>
                     </ul>
                 </div>
             </div>
         </div>
     </div>
 </div>
 