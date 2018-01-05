<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@page import="org.dom4j.Element"%>
<%@page import="org.dom4j.Node"%>
<%@page import="com.edeas.utils.XmlUtils"%>
<%@page import="java.util.*"%>
<%@page import="com.edeas.controller.cmsadmin.CmsProperties"%>
<%@page import="com.edeas.model.CmsPage"%>
<%@page import="com.edeas.model.Content"%>
<%@page import="com.edeas.model.Page"%>
<%@page import="com.edeas.service.impl.*"%>
<%@page import="com.edeas.web.InitServlet"%>
<%@page import="org.dom4j.Document"%>
<%@ include file="/WEB-INF/Shared/commons.jspf" %>


<link href="${Script}/datetimepicker/jquery.datetimepicker.css" rel="stylesheet" type="text/css" />
<link href="${Script}/datetimepicker/mmnt.css" rel="stylesheet" type="text/css" />
    
<script src="${Script}/datetimepicker/jquery.datetimepicker.full.min.js" type="text/javascript"></script>
<script src="${Script}/datetimepicker/mmnt.js" type="text/javascript"></script>
<script src="${Script}/cms/ajaxform.js" type="text/javascript"></script>
<script src="${Script}/cms/tinymce/tinymce.min.js" type="text/javascript"></script>
<script src="${Script}/cms/define-tme.js" type="text/javascript"></script>
<script src="${Script}/cms/propertyform.js" type="text/javascript"></script>
<script src="${Script}/cms/mckfield.js" type="text/javascript"></script>

<script type="text/javascript">
    $(function () {
		setupDatetimeFields();
		setupDateFields();
        setupRichEditorFields();
    });
</script>
<%
	String lang = (String)request.getAttribute("lang");
	Page currentPage = (Page)request.getAttribute("currentPage");
	Content currentContent = (Content)currentPage.getContent(lang);
	Document tx = XmlUtils.getTemplateDocument(currentPage.getTemplate());
	List<Element> fieldList = (List<Element>)tx.selectNodes("/Template/Properties/Field");
	Document propDocument = currentContent == null ? null : currentContent.getPropertyXmlDoc();
	Element dataWidget = (propDocument == null) ? null : (Element)propDocument.selectSingleNode("/Properties");
	String ptyerr = (String)request.getAttribute("ptyError");
%>
<form action="PageContentAdmin/UpdateProperty" method="post" id="propertyform" name="propertyform" enctype="multipart/form-data">	
	<input type="hidden" name="pageid" value="${ currentPage.id }" />
	<input type="hidden" name="lang" value="${ lang }" />
	    <h2>
        <span>Properties</span>
        <div class="ico ec collapse gradbtn" ec="c" style="display:none;"><img class="ec" src="${Content}/images/spacer.gif" alt="Collapse" title="Collapse" /></div>
    </h2>
       <div class="content">
        <table id="propertyformtbl">
        	<% 
	            for (Element fieldSchema : fieldList)
	            {
	                String path = "/WEB-INF/PageAdmin/FormFields/" + fieldSchema.attributeValue("type") + ".jsp";
	                request.setAttribute("dataw", dataWidget);
	                request.setAttribute("model", fieldSchema);
            %>            		
                	<jsp:include page="<%=path%>" /> 
            <% 	} %>
        </table>
        <div class="btns">
            <div class="url"><span class="hlbg">URL</span>${url}</div>
            <div class="savecancel">
                <div class="cmsbtn savebtn">Save</div>
                <div class="cmsbtn cancelbtn">Cancel</div>
                <div class="clear"></div>
            </div>
        </div>
        <div class="err">${ptyerr}</div>
    </div>
</form>
    
