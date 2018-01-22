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
<%
	Page currentPage = (Page)request.getAttribute("currentPage");
	long pageId = (Long)request.getAttribute("pageid");
	String lang = (String)request.getAttribute("lang");
	String wid = (String)request.getAttribute("wid");
	String wname = (String)request.getAttribute("wname");
	String wxid = (String)request.getAttribute("wxid");
	String parentxid = (String)request.getAttribute("parentxid");
	String caller = (String)request.getAttribute("caller");
	String closejs = "win".endsWith(caller) ? "window.opener.refresh();window.close();" : "parent.TINY.box.hide();";  
	
	Document tempateDocument = XmlUtils.getTemplateDocument(currentPage.getTemplate());
	
    Element widget = (Element)tempateDocument.selectSingleNode("//Widget[@ename='"+wname+"']");
    if (widget == null) { widget = (Element)tempateDocument.selectSingleNode("//AcceptWidget[@ename='"+wname+"']"); }

    Document widgetListDocument = XmlUtils.getWidgetListDocument();
    List<Element> fields = (List<Element>)widgetListDocument.selectNodes("//Widget[@id='"+wid+"']/Field");

    Content content = currentPage.getContent(lang);
    Element dataWidget = null;
    if (content != null) {
    	Document contentDocument = content.getContentXmlDoc();
    	dataWidget = (Element)contentDocument.selectSingleNode("//Widget[@id='" + wxid + "']");    	
    }
%>
<html>
<head>
    <title>WidgetForm</title>
    <%@ include file="/WEB-INF/Shared/commons.jsp" %>
    <link href="${Content}/cms/core/cms.css" rel="stylesheet" type="text/css" />
    <link href="${Content}/cms/cmsstyle.css" rel="stylesheet" type="text/css" />
    <style>
        #widgetformtbl { width: 100%; }
        .ttafield textarea { width: 500px; height: 100px; }
        input.altxt { width: 400px; }
    </style>    
    <script src="//code.jquery.com/jquery-1.12.1.min.js"></script>
    <link rel="stylesheet" type="text/css" href="${Script}/datetimepicker/jquery.datetimepicker.css" />
    <link rel="stylesheet" type="text/css" href="${Script}/datetimepicker/mmnt.css" />
    <script src="${Script}/datetimepicker/jquery.datetimepicker.full.min.js" type="text/javascript"></script>
    <script src="${Script}/cms/common.js" type="text/javascript"></script>
    <script src="${Script}/cms/ueditor/ueditor.config.js" type="text/javascript"></script>
    <script src="${Script}/cms/ueditor/ueditor.all.js" type="text/javascript"></script>
    <script src="${Script}/cms/defineuedit.js" type="text/javascript"></script>
    <script src="${Script}/cms/tinymce/tinymce.min.js" type="text/javascript"></script>
    <script src="${Script}/cms/define-tme.js" type="text/javascript"></script>    
    <script src="${Script}/cms/ajaxform.js" type="text/javascript"></script>    
    
    <script>
        jQuery.browser={};(function(){jQuery.browser.msie=false; jQuery.browser.version=0;if(navigator.userAgent.match(/MSIE ([0-9]+)./)){ jQuery.browser.msie=true;jQuery.browser.version=RegExp.$1;}})();
    </script>
    <script type="text/javascript">
        function submitWidgetForm() {
            $(".xedfield textarea").each(function () { var dummy = $(this).val(); });
            E$("widgetform").submit();
        }

        function closeWidgetForm() { <%=closejs%> }

        $(function () {
            //setupUEditorFields();
            setupRichEditorFields();
            setupDatetimeFields();
            setupDateFields();
            setupTxtDisableTrgChkbox();
            setSelPages();
            setLinkFields();
        });
    </script>
</head>
<body><div id="ajaxform">
    <h1>WidgetForm</h1>
    <form action="<%=Global.getCMSUrl() %>/PageContentAdmin/UpdateWidget" method="post" id="widgetform" name="widgetform"  enctype="multipart/form-data">
        <input type="hidden" name="pageid" value="${ currentPage.id }" />
		<input type="hidden" name="lang" value="${ lang }" />
		<input type="hidden" name="wname" value="${ wname }" />
		<input type="hidden" name="wid" value="${ wid }" />
		<input type="hidden" name="wxid" value="${ wxid }" />
		<input type="hidden" name="parentxid" value="${ parentxid }" />
		<input type="hidden" name="caller" value="${ caller }" />        
        <div class="content">
            <table id="widgetformtbl" cellspacing="1">
            	<%
            		for(Element field : fields) {
            			String fieldType = field.attributeValue("type", "");
            			String fieldPath = "/WEB-INF/PageAdmin/FormFields/" + fieldType + ".jsp";
            			request.setAttribute("fieldData", dataWidget);
    	                request.setAttribute("widgetSchema", widget);
    	                request.setAttribute("fieldSchema", field);
        		%>
        				<jsp:include page="<%=fieldPath %>" />
          		<%
            		}
            	%>
            </table>
            <%
            	if(fields.size() == 0) {
            		out.print("<div style='text-align:center; font-weight:bold; font-size:16px; border-top:3px solid #ccc'>");
            		out.print("NoWidgetConfiguration");
            		out.print("</div>");
            	}
            %>            
            <div class="actionbtns">
                <div class="cmsbtn" onclick="submitWidgetForm();">Save</div>
                <div class="cmsbtn" onclick="closeWidgetForm();">Cancel</div>
            </div>
        </div>
    </form>   
</div></body>
</html>