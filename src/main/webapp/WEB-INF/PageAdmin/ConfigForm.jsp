<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@page import="org.dom4j.Element"%>
<%@page import="org.dom4j.Node"%>
<%@page import="com.edeas.utils.XmlUtils"%>
<%@page import="com.edeas.utils.HtmlUtils"%>
<%@page import="java.util.*"%>
<%@page import="com.edeas.controller.cmsadmin.CmsProperties"%>
<%@page import="com.edeas.model.CmsPage"%>
<%@page import="com.edeas.model.Page"%>
<%@page import="com.edeas.service.impl.*"%>
<%@page import="com.edeas.web.InitServlet"%>
<%@page import="org.dom4j.Document"%>
<html>
<head>
    <title>Config Form</title>
    <%@ include file="/WEB-INF/Shared/commons.jsp" %>
    <link href="${Content}/cms/core/cms.css" rel="stylesheet" type="text/css" />
    <link href="${Content}/cms/core/pageadmin.css" rel="stylesheet" type="text/css" />
    
    <link href="${Content}/cms/cmsstyle.css" rel="stylesheet" type="text/css" />
    <link href="${Content}/cms/appcms.css" rel="stylesheet" type="text/css" />    
    <style>
        #ajaxform { /*width & height*/ }
        div.editor-label { width: 120px; }
        div.editor-field input[type=text] { width: 400px; }
        div.datetimefield input[type=text] { width: 100px; }
        div.datefield input[type=text] { width: 100px; }
        #pgform { padding: 15px 0px; overflow: auto; }
    </style>

    <script src="//code.jquery.com/jquery-1.12.1.min.js"></script>    	
    <link rel="stylesheet" type="text/css" href="${Script}/datetimepicker/jquery.datetimepicker.css" />
    <link rel="stylesheet" type="text/css" href="${Script}/datetimepicker/mmnt.css" />
    <script src="${Script}/datetimepicker/jquery.datetimepicker.full.min.js" type="text/javascript"></script>
    <script src="${Script}/datetimepicker/mmnt.js" type="text/javascript"></script>
    <script src="${Script}/cms/common.js" type="text/javascript"></script>
    <script src="${Script}/cms/fieldslib.js" type="text/javascript"></script>    
    <script src="${Script}/cms/ajaxform.js" type="text/javascript"></script>
    <script src="${Script}/cms/configform.js" type="text/javascript"></script>
    <script type="text/javascript" src="${context}/dwr/engine.js"></script>
	<script type="text/javascript" src="${context}/dwr/interface/dwrService.js"></script>
    <script type="text/javascript">
        function submitPgConfigForm() {
            var u = cmsroot + "PageAdmin/Save";
            $.post(u, $("#pgconfigform").serialize(), function (data) {
                if (data.success) {
                    parent.refreshonclose = true;
                    parent.TINY.box.hide();
                } else alert(data.errorMsg);
            }, "json");
            //E$("pgconfigform").submit();
        }

        $(function () {
            setupAutoUrl();
            setUrlOnConfig();
            setupTemplateSelect();
            setupDatetimeFields();
            setupDateFields();
        });
    </script>
</head>
<%	
	QueryServiceImpl queryService = InitServlet.getQueryService();
	Page currentPage = (Page)request.getAttribute("currentPage");
	Page parentPage = (Page)request.getAttribute("parentPage");
	Long parentid = (Long)request.getAttribute("parentid");
	String paretnTemplate = parentPage == null ? "" : parentPage.getTemplate();
	String template = currentPage.getTemplate();
	boolean enableDTime = CmsProperties.enableDTimeParentTpls.containsKey(paretnTemplate);
	//boolean enableDTime = CmsProperties.enableDTimeTpls.containsKey(template);
	Map<String, String> dtconfig = enableDTime ?  CmsProperties.enableDTimeParentTpls.get(paretnTemplate) : null;
%>

<body>
    <div id="ajaxform">
        <h1><%= currentPage.isNew() ? "NewPage" : "ConfigPage"  %></h1>    
	    <form actoin='PageAdmin/<%= currentPage.isNew() ? "Create" : "Update" %>' id ="pgconfigform" name ="pgconfigform">
	        <h2 class="darkbg">Configuration</h2>
	        <div id="pgform">
	            <input type="hidden" name="pageid" value="<%= currentPage.isNew() ? 0 : currentPage.getId() %>" />
	            <input type="hidden" id="parentid" name="parentid" value="${ parentid }" />
	            <input type="hidden" name="newatfront" value="${ newatfront }" />
				<c:set var="enableAutoName" value="<%=CmsProperties.enableAutoNameParentTpls.containsKey(paretnTemplate) %>" />
	            <!-- Name -->
	            <c:if test="${ enableAutoName }">
	                <input type="hidden" name="name" value="${ currentPage.name }" />
	                <input type="hidden" name="url" value="${ currentPage.name }" />
	                <input type="hidden" name="namealg" value="<%=CmsProperties.enableAutoNameParentTpls.get(paretnTemplate) %>" />
	            </c:if>
	     		<c:if test="${ !enableAutoName }">
		            <div class="editor-label">Name:</div>
		            <div class="editor-field" id="pgconfigname"><input type='text' name="name" value="${ currentPage.name }" /></div>
		            <!-- Url -->
		            <div class="clear"></div>
		            <div class="editor-label" id="lbpgconfigurl">Url:</div>
		            <div class="editor-field" id="pgconfigurl">
		                <span id="urlprefix">${ currentPage.urlPath }</span>
		                <br /><input type="text" readonly name="url" value="${ currentPage.url }" />
		                <span id="urlsuffix">.html</span>
		            </div>
	     		</c:if>
	            
				<c:set var="enableDTime" value="<%=enableDTime %>" />
				<c:if test="${ enableDTime }">
					<c:set var="format" value='<%= dtconfig.get("format") %>' />
					<!-- Single Year Range -->
					<c:if test="${fn:contains(format, 'yr')}">
						<div class="clear"></div>
	                    <input type="hidden" id="pgtimefmt" name="pgtimefmt" value="${ format }" />
	                    <div class="editor-label"><%= dtconfig.get("labeldate") %>:</div>
	                    <div class="editor-field yearfield ${ format }">
	                        <input type="hidden" id="pgtimei" name="pgtimei" class='yv' yid='pgtimeiy' value='<fmt:formatDate value="${ currentPage.pageTimeFrom }" pattern="yyyy" />-01-01' />
	                        <!-- pgtimei:Start Year -->
	                        <select id="pgtimeiy">
	                        	<%
	                        		Calendar calendar = Calendar.getInstance();
	                        		calendar.setTime(currentPage.isNew() ? new Date() : currentPage.getPageTimeFrom());
	                             	int sely = calendar.get(Calendar.YEAR);
	                             	int pastyrs = Integer.parseInt(dtconfig.get("pastyr"));
	                             	int upyrs = Integer.parseInt(dtconfig.get("upcomingyr"));
	                             
	                             	//display defined year if after selection range
	                             	calendar.setTime(new Date());
	                             	int currentYear = calendar.get(Calendar.YEAR);
	                             	if (sely - currentYear > upyrs) { 
	                             		out.print("<option value='" + sely + "' selected>" + sely + "</option>"); 
	                           		}
	                             
		                            //render year selection range
		                            for (int p=upyrs; p>0; p--) {
		                                int y = currentYear + p;
		                                String usel = (sely == y) ? " selected" : "";
		                                out.print("<option value='" + y + "' " + usel + ">" + y + "</option>");
		                            }                             
	                             	String sel = (sely == currentYear) ? " selected" : "";
	                             	out.print("<option value='" + currentYear +"' " + sel + ">" + currentYear + "</option>");
		                            for (int p = 1; p<=pastyrs; p++) {
		                                int y = currentYear - p;
		                                String psel = (sely == y) ? " selected" : "";
		                                out.print("<option value='" + y + "' " + psel + ">" + y + "</option>");
		                            }
	                             
		                            //display defined year if before selection range
		                            if (currentYear - sely > pastyrs) { 
		                            	out.print("<option value='" + sely + "' selected>" + sely + "</option>");
	                            	}
	                        	%>                            
	                        </select>
	                        <c:if test="${fn:contains(format, 'yrr')}">
	                            <span>-</span>
	                            <!-- pgtimef:End Year -->
	                            <input type="hidden" id="pgtimef" name="pgtimef" class='yv' yid='pgtimefy' value="<fmt:formatDate value="${ currentPage.pageTimeFrom }" pattern="yyyy" />-01-01" />
	                            <!-- TODO: ... Not Implemented ... -->
	                        </c:if>                        
	                    </div>
					</c:if>
					
					<!-- Year Month Range -->
					
					<!-- Date Range -->
					<c:if test="${fn:contains(format, 'dat')}">
	                   	<div class="clear"></div>
	                    <input type="hidden" id="pgtimefmt" name="pgtimefmt" value="${ format }" />
	                    <div class="editor-label"><%= dtconfig.get("labeldate") %>:</div>
	                    <div class="editor-field datefield ${ format }">
	                        <!-- pgtimei:Start Date -->
	                        <input type="text" id="pgtimei" name="pgtimei" value="<fmt:formatDate value="${ currentPage.pageTimeFrom }" pattern="yyyy-MM-dd" />" />
	                        <c:if test="${fn:contains(format, 'datr')}">
	                            <span>-</span>
	                        	<!-- pgtimef:End Date -->
	                            <input type="text" id="pgtimef" name="pgtimef" value="<fmt:formatDate value="${ currentPage.pageTimeTo }" pattern="yyyy-MM-dd" />" />
	                        </c:if>                        
	                	</div>
					</c:if>
					
					<!-- Time Range -->
					<c:if test="${fn:contains(format, 'tim')}">
	                    <div class="clear"></div>
	                    <div class="editor-label"><%= dtconfig.get("labeltime") %>:</div>
	                    <div class="editor-field timefield ${ format }">
	                        <!--- pgtimei: Start Time -->
	                        <select id="pgtimeihr" name="pgtimeihr" class="time hr">
	                        	<%=HtmlUtils.timeOptions(0, 23, currentPage.getPageTimeFrom().getHours()) %>
	                       	</select>
	                        <span>:</span>
	                        <select id="pgtimeimin" name="pgtimeimin" class="time min">
	                        	<%=HtmlUtils.timeOptions(0, 59, currentPage.getPageTimeFrom().getMinutes()) %>
	                       	</select>
	                        <!--- pgtimef: End Time -->
	                        <c:if test="${fn:contains(format, 'timr')}">
	                            <span>-</span>
	                            <select id="pgtimefhr" name="pgtimefhr" class="time hr">
	                            	<%=HtmlUtils.timeOptions(0, 23, currentPage.getPageTimeTo().getHours()) %>
	                           	</select>
	                            <span>:</span>
	                            <select id="pgtimefmin" name="pgtimefmin" class="time min">
	                            	<%=HtmlUtils.timeOptions(0, 59, currentPage.getPageTimeTo().getMinutes()) %>
	                           	</select>
	                        </c:if>                        
	                    </div>
					</c:if>
					
					<!-- Hide Day -->
					<c:if test="${fn:contains(format, 'cd')}">
	                    <!-- hide day -->
	                    <div class="clear"></div>
	                    <div class="editor-label">Hide Day?</div>
	                    <div class="editor-field hidedayfield">
	                        <input type="checkbox" id="pgtimedisplay" name="pgtimedisplay" value="hideday" ${currentPage.pageTimeDisplay == "" ? "" : " checked"} />
	                    </div>
					</c:if>
					
				</c:if>
	
				<!-- TODO: Publish / Expire Date Time -->
				
				<!-- Manual Page Order -->
				<c:set var="customPgOrder" value="<%=CmsProperties.customPgOrderParentTpls.containsKey(paretnTemplate) %>" />
				<c:if test="${customPgOrder}">
	                <div class="clear"></div>
	                <div class="editor-label"><%=CmsProperties.customPgOrderParentTpls.get(paretnTemplate).get("label") %>:</div>
	                <div class="editor-field">
	                    <input type="text" name="custompgorder" value="${ currentPage.pageOrder }" style="width:40px;" />
	                </div>
				</c:if>
	
	            <!-- Template -->
	            <div class="clear"></div>
	            <div class="editor-label">Template:</div>
	            <div id="templatefield" class="editor-field">
	            <%
	            	String q = "/TemplateList/Template";
	            	List<String> activeTemplates = queryService.findAvailableTemplates(true);
	            	boolean reftpl = false;
	            	Document document = XmlUtils.getTemplateListDocument();
	            	if (parentid == 0) q += "[@top='yes']";
	            	else if(document.selectNodes("/TemplateList/Template[@fixpid='" + parentid + "']").size() > 0) q += "[@fixpid='" + parentid + "']";
	            	else if(parentid > 0) {
	            		if(!parentPage.isNew()) {
	            			String ptq = "/TemplateList/Template[@id='" + parentPage.getTemplate() + "' and AcceptChildList]";
	            			if (document.selectNodes(ptq).size() > 0) {
	            				reftpl = true;
	            				q += "[@id='" + parentPage.getTemplate() + "']/AcceptChildList/RefTemplate";
	            			}
	            		}
	            	}
	            	Map<String, String> tpla = new HashMap<String, String>();
	            	List<Element> r = (List<Element>)document.selectNodes(q);
	            	for(Element t : r) {
	                    String tidan = (reftpl) ? "refid" : "id";
	                    String v = t.attributeValue(tidan);
	                    String l = t.attributeValue("name");
	                    boolean inctpl = true;
	                    
	                    if (t.attributeValue("isunique", "").equals("yes") && !v.equals(currentPage.getTemplate())) {
	                        if (activeTemplates.contains(v)) {
	                            inctpl=false;
	                        }
	                    }
	                    if (!t.attributeValue("fixpid", "").equals("") && !t.attributeValue("fixpid", "").equals(parentid + "")) {
	                        inctpl = false;
	                    }
	                    if (inctpl) {
	                        tpla.put(v,l);
	                    }
	            	}
	            %>
	                <select id="template" name="template">
	                	<%
	                		for(String key : tpla.keySet()) {
	                			String tsel = key.equals(currentPage.getTemplate()) ? " selected" : "";
	                			out.print("<option value='" + key + "' " + tsel + ">" + tpla.get(key) + "</option>");
	                		}
	                	%>                
			        </select>
	            </div>
	
	            <!-- Active -->            
	            <div class="clear"></div>
	            <div class="editor-label">Active:</div>
	            <div class="editor-field">
	                <input type="checkbox" name="isActive" ${ currentPage.active ? " checked" : "" } />
	            </div>   
	
	            <!-- Buttons -->
	            <div class="clear"></div>
	            <div class="actionbtns">
	                <div class="cmsbtn" onclick="refreshonclose=false; parent.TINY.box.hide();">Cancel</div>
	                <div class="cmsbtn" onclick="submitPgConfigForm();"><%= currentPage.isNew() ? "Create" : "Save" %></div>
	            </div>	
	
	        </div>
	    </form>
    </div>
</body>
</html>
