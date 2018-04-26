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
<%@page contentType="text/html;charset=UTF-8"%>
<%
	Page currentPage = (Page)request.getAttribute("currentPage");
	long pageId = (Long)request.getAttribute("pageid");
	String lang = (String)request.getAttribute("lang");
	String mgrxid = (String)request.getAttribute("mgrxid");
	String mgrname = (String)request.getAttribute("mgrname");
	String mgrtype = (String)request.getAttribute("mgrtype");
	String mgrattr = (String)request.getAttribute("mgrattr");
	
	Document tempateDocument = XmlUtils.getTemplateDocument(currentPage.getTemplate());
	Element templateMgrNode = (Element)tempateDocument.selectSingleNode("//Widget[@ename='"+mgrname+"']");
	if (templateMgrNode == null) templateMgrNode = (Element)tempateDocument.selectSingleNode("//AcceptWidget[@ename='"+mgrname+"']");
	Element templateChildrenNode = (templateMgrNode == null) ? null : (Element)templateMgrNode.selectSingleNode("Widget");
    String childWidgetId = XmlUtils.getFieldAttr(templateChildrenNode, "wid");
	String childWidgetName = XmlUtils.getFieldAttr(templateChildrenNode, "ename");

	Content content = currentPage.getContent(lang);
    Element mgrnode = null;
    if (content != null && !content.isNew())
    	mgrnode = (Element)content.getContentXmlDoc().selectSingleNode("//Widget[@id='"+mgrxid+"']");
%>
<html>
<head>
    <title>WidgetManager</title>
    <%@ include file="/WEB-INF/Shared/commons.jsp" %>
    <link href="${Content}/cms/core/cms.css" rel="stylesheet" type="text/css" />
    <link href="${Content}/cms/core/pageadmin.css" rel="stylesheet" type="text/css" />
    <link href="${Content}/cms/cmsstyle.css" rel="stylesheet" type="text/css" />
    <style>
        #wmgrframe { }

        #gallery { padding: 20px 0px 20px 10px; }

        .mgrgallerytb { width: 122px; background: #fff; float: left; margin: 0px 20px 20px 0px; }
        .mgrgallerytb .tbframe { border: solid 1px #ccc; padding: 3px; }
        .mgrgallerytb .tbframe img { width: 114px; margin: 0px; display: block; }
        .mgrgallerytb .fn { overflow: auto; }
        .mgrgallerytb .fn .sep { float: right; width: 1px; height: 18px; margin: 5px; }
        .mgrgallerytb img.del, .mgrgallerytb img.edit { width: 18px; height: 18px;
            cursor: pointer; z-index: 10; padding: 5px 2px; float: right; }

        #wlisting { padding: 8px; }

        .mgrtxtlistitm { cursor: pointer; border-bottom: solid 1px #ccc; padding: 4px 0px; }
        .mgrtxtlistitm:hover { background: #eee; }
        .mgrtxtlistitm img { vertical-align: middle; padding: 3px; /*background:#ccc;*/ }

        .gradlightbtn { }        
    </style>
    <script src="//code.jquery.com/jquery-1.12.1.min.js"></script>
    <script src="//code.jquery.com/ui/1.12.1/jquery-ui.min.js"></script>
    <script src="${Script}/cms/common.js")" type="text/javascript"></script>
    <script type="text/javascript" src="${context}/dwr/engine.js"></script>
	<script type="text/javascript" src="${context}/dwr/interface/dwrService.js"></script>
    <script type="text/javascript">
        function neww() { openWidgetFormWin(<%=pageId%>,'<%=lang%>','new','<%=childWidgetId%>','<%=childWidgetName%>','<%=mgrxid%>','openerrefresh'); }
        function editw(xid) { openWidgetFormWin(<%=pageId%>,'<%=lang%>',xid,'<%=childWidgetId%>','<%=childWidgetName%>','<%=mgrxid%>','openerrefresh'); }
        function delw(xid) {
            if (confirm("You are going to delete a widget which cannot be undo.  Do you want to continue?")) {
                deleteWidget('<%=pageId%>', '<%=lang%>', xid, "");
            }
        }
        function closemgr() { parent.TINY.box.hide(); }
        function widgetOrderChanged(e,ui) {
            var xid=ui.item.attr('xid');
            var next=ui.item.next('div.oitem');
            if (next.length>0) {
                var nxtid=next.attr('xid');
                //console.log('pgid='+pgid+' would be placed before pgid='+nxtid);
                chgWidgetOrder('<%=pageId%>', '<%=lang%>',xid,nxtid);
            } else {
                //console.log('pgid='+pgid+' would be placed at the end');
                chgWidgetOrder('<%=pageId%>', '<%=lang%>',xid,0);
            }
        }
        $(function () {
            $("#gallery,#wlisting").sortable({ update: function(e,ui) { widgetOrderChanged(e,ui); } });
        });
    </script>
</head>
<body>
    <div id="ajaxform">
        <h1>WidgetManager</h1>
        <div id="wmgrframe">
            <h2 class="darkbg fnbar">
                <span>&nbsp;</span>
                <div class="right darkgradbg btmshadow">
                    <div id="btnnewpg" class="icobtn whitefontover" onclick="neww();">New</div>
                </div>
            </h2>
        </div>
        <%
        	if("gallery".equals(mgrtype)) {
        		String[] a = mgrattr.split(":");
        		
        		List<Element> wlist = mgrnode == null ? new ArrayList<Element>() : (List<Element>)mgrnode.selectNodes("Widget[@name='" + a[0] + "']");
        		out.print("<div id='gallery'>");
        		int i = 0;
        		for(Element w : wlist) {
                    Element tbgnode = (Element)w.selectSingleNode("Field[@name='" + a[1] + "']");
                    if (i > 0 && i % 5 == 0) {
                    	out.print("<div class='clear'></div>");
                    }
                   	%>
	                    <div class="mgrgallerytb oitem" xid="<%=XmlUtils.getFieldAttr(w, "id") %>">
	                        <div class="tbframe">	                        
	                        	<%=XmlUtils.tagimg(tbgnode, Global.IMAGE_CMGR, true, "", null) %>
	                        </div>
	                        <div class="fn lightgraybg">
	                            <img class="del" src="${Content}/cms/core/images/icon-x.png" onclick="delw('<%=XmlUtils.getFieldAttr(w, "id") %>');" />
	                            <div class="sep darkbg"></div>
	                            <img class="edit" src="${Content}/cms/core/images/icon-pen.png" onclick="editw('<%=XmlUtils.getFieldAttr(w, "id") %>');" />
	                        </div>
	                    </div>
                   	<%
        			i++;
        		}
        		out.print("</div>");
        	} else if("txtlist".equals(mgrtype)) {
        		String[] a = mgrattr.split(":");
        		List<Element> wlist = mgrnode == null ? new ArrayList<Element>() : (List<Element>)mgrnode.selectNodes("Widget[@name='" + a[0] + "']");
        		out.print("<div id='wlisting'>");
        		for(Element w : wlist) {
        			String[] b = a[1].split(",");
                    String txt = null;
                    for (int i = 0; i < b.length; i++) {
                        Element txtnode = (Element)w.selectSingleNode("Field[@name='" + b[i] + "']");
                        if (txtnode != null && !StringUtils.isBlank(txtnode.getText())) {
                            txt = txtnode.getText();
                            break;                       
                        }
                    }
                    if (txt == null) {
                        txt = "[ Empty ]";
                    }
                    %>
	                    <div class="mgrtxtlistitm oitem" xid="<%=XmlUtils.getFieldAttr(w, "id") %>">
	                        <img class="edit gradlightbtn roundall" src="${Content}/cms/core/images/icon-pen.png" onclick="editw('<%=XmlUtils.getFieldAttr(w, "id") %>');" />
	                        <img class="del gradlightbtn roundall" src="${Content}/cms/core/images/icon-x.png" onclick="delw('<%=XmlUtils.getFieldAttr(w, "id") %>');" />
	                        <span class="txt"><%=txt %></span>
	                    </div>
                    <%
        		}
            	out.print("</div>");	
        	}
        %>
   </div>
</body>
</html>