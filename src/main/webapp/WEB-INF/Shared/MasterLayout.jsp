<%@page import="org.apache.commons.lang3.StringUtils"%>
<%@page import="com.edeas.utils.XmlUtils"%>
<%@page import="org.dom4j.Document"%>
<%@page import="com.edeas.service.impl.QueryServiceImpl"%>
<%@page import="com.edeas.web.InitServlet"%>
<%@page import="com.edeas.model.*"%>
<%@page contentType="text/html;charset=UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<!--[if lt IE 7]><html class="no-js lt-ie10 lt-ie9 lt-ie8 lt-ie7 "> <![endif]-->
<!--[if IE 7]><html class="no-js lt-ie10 lt-ie9 lt-ie8"> <![endif]-->
<!--[if IE 8]><html class="no-js lt-ie10 lt-ie9"> <![endif]-->
<!--[if IE 9]><html class="no-js lt-ie10"> <![endif]-->
<!--[if gt IE 8]><!-->
<html class="no-js">
<!--<![endif]-->
<% 
	boolean iscms = (Boolean)request.getAttribute("iscms");
	String lang = (String)request.getAttribute("lang");
	Page masterPage = (Page)request.getAttribute("masterPage");
	Content masterContent = masterPage.getContent(lang);
	Page currentPage = (Page)request.getAttribute("currentPage");
	Content pageContent = currentPage.getContent(lang);
	
	Document ptyDocument = masterContent.getPropertyXmlDoc();
	String headTitle = XmlUtils.getPtyFieldVal(ptyDocument, "HeadTitle", false);
	String image = XmlUtils.getPtyFieldVal(ptyDocument, "Image", false);
	String imageUrl = "";	
	if (!StringUtils.isBlank(image)) {
		String host = request.getRequestURL().substring(0, request.getRequestURL().indexOf(request.getRequestURI()));
		imageUrl = host + Global.getImagesUploadPath(Global.IMAGE_SOURCE, image);
	}
	
	Document contentDocument = pageContent.getPropertyXmlDoc();
	String seoDesc = XmlUtils.getPtyFieldVal(contentDocument, "SeoDesc", false);
	String seoKeys = XmlUtils.getPtyFieldVal(contentDocument, "SeoKeys", false);
%>
<head>
    <title><%=imageUrl%></title>    
	<%@include file="/WEB-INF/Shared/commons.jsp" %>
    <meta name="viewport" content="initial-scale=1.0, maximum-scale=1.0, user-scalable=no, width=device-width" />
    <meta name="description" content="<%=seoDesc%>" />
    <meta name="keywords" content="<%=seoKeys%>" />

    <!-- Mobile Specific Metas -->
    <meta name="format-detection" content="telephone=no" />

	<!-- can refer to bookfair -->
    <meta http-equiv='X-UA-Compatible' content='IE=edge,chrome=1' />
    <meta property="og:type" content="article" />
    <meta property="og:image" content="<%=imageUrl%>" />
    <meta property="og:title" content="<%=headTitle%>" />
    <meta property="og:description" content="<%=headTitle%>" />
    <meta itemscope=itemscope itemtype="http://schema.org/Article" />
    <meta itemprop="name" content="<%=headTitle%>" />
    <meta itemprop="description" content="<%=headTitle%>" />
    <meta itemprop="image" content="<%=imageUrl%>" />
    
    
    <!-- ICO -->
    <link rel="shortcut icon" href="${Content }/images/favicon.png" />
    <link rel="apple-touch-icon" href="${Content }/images/apple-touch-icon.png" />
    <link rel="apple-touch-icon" sizes="72x72" href="${Content }/images/apple-touch-icon-72x72.png" />
    <link rel="apple-touch-icon" sizes="114x114" href="${Content }/images/apple-touch-icon-114x114.png" />

    <!-- CSS -->
    <%@include file="/WEB-INF/Shared/MasterCss.jsp" %>
    
    <script type="text/javascript" src="//ajax.googleapis.com/ajax/libs/jquery/2.1.4/jquery.min.js"></script>
    <!--script type="text/javascript" src="//ajax.googleapis.com/ajax/libs/jquery/1.12.0/jquery.min.js"></script-->
</head>
<body id="body" class="<%=lang%> <%=Global.langClass(lang)%> sticky-header nice-scroll-on">    

	<sitemesh:write property='body'/>
   
    <script type="text/javascript">
        var gaJsHost = (("https:" == document.location.protocol) ? "https://ssl." : "http://www.");
        document.write(unescape("%3Cscript src='" + gaJsHost + "google-analytics.com/ga.js' type='text/javascript'%3E%3C/script%3E"));
        $(function () {
            try {
                pageTracker = _gat._getTracker("");
                pageTracker._trackPageview();             
            } catch (err) { }
        });
    </script>
</body>
</html>	        