<%@include file="/WEB-INF/Shared/commons.jsp" %>
<%@page contentType="text/html;charset=UTF-8"%>
<%@page import="org.apache.commons.lang3.StringUtils"%>
<%@page import="com.edeas.utils.XmlUtils"%>
<%@page import="org.dom4j.Document"%>
<%@page import="com.edeas.service.impl.QueryServiceImpl"%>
<%@page import="com.edeas.web.InitServlet"%>
<%@page import="com.edeas.model.*"%>
<%@page import="java.util.*"%>
<%@page import="org.dom4j.Element"%>
<% 
	boolean iscms = (Boolean)request.getAttribute("iscms");
	String lang = (String)request.getAttribute("lang");		
	
	Page masterPage = (Page)request.getAttribute("masterPage");
	Content masterContent = masterPage.getContent(lang);
		
	List<? extends Page> topPages = InitServlet.getQueryService().getAllTopPage(iscms, true);
	
	Page homePage = InitServlet.getQueryService().getHomePage(iscms);
	
	String homePageLink = XmlUtils.getPageLink(homePage, lang, iscms, false).getLink();
%>

<!-- JS -->
<script type="text/javascript" src="${Script}/mfn.menu.js"></script>
<script type="text/javascript" src="${Script}/jquery.plugins.js"></script>
<script type="text/javascript" src="${Script}/animations/animations.js"></script>
<script type="text/javascript" src="${Script}/back-to-top.js"></script>
<script type="text/javascript" src="${Script}/scripts.js"></script>
<script type="text/javascript" src="${Script}/main.js"></script>
<script type="text/javascript" src="${context}/dwr/engine.js"></script>
<script type="text/javascript" src="${context}/dwr/interface/dwrService.js"></script>    
<div>
    <!-- Header Wrapper -->
    <div id="Header_wrapper">
        <!-- Header -->
        <header id="Header">
            <!-- Header -  Logo and Menu area -->
            <div id="Top_bar">
                <div class="container">
                    <div class="one">
                        <div class="top_bar_left clearfix">
                            <!-- Logo-->
                            <%
					        	Element logoElement = (Element)masterContent.getContentXmlDoc().selectSingleNode("/PageContent/Widget[@name='Logo']/Field");	        	
					        %>
                            <div class="logo">
                                <a id="logo" href="<%=homePageLink %>"><img class="img-scale" src="<%=Global.getDocUploadPath(logoElement == null ? "" : logoElement.getTextTrim())%>" alt="edeas" /></a>
                            </div>
                            <!-- Main menu-->
                            <div class="menu_wrapper">
                                <nav id="menu">
                                    <ul id="menu-main-menu" class="menu">
                                        <%-- <li><a href="<%=homePageLink %>"><span><%=XmlUtils.getPtyFieldVal(homePage.getContent(lang).getPropertyXmlDoc(), "MenuName", false) %></span></a></li> --%>
                       		         	<%
							         		for(Page topPage : topPages) {
							         			String menuName = XmlUtils.getPtyFieldVal(topPage.getContent(lang).getPropertyXmlDoc(), "MenuName", false);
							         			List<Page> subPages = InitServlet.getQueryService().getChidrenByPageOrderAsc(topPage.getId(), iscms, true);
							         			%>
		                                        <li>
		                                            <a href="<%=XmlUtils.getPageLink(topPage, lang, iscms, false).getLink() %>"><span><%=menuName%></span></a>
		                                            <ul class="sub-menu">
		                                            	<% 
			                                            	for(Page subPage : subPages) {
			                                            		menuName = XmlUtils.getPtyFieldVal(subPage.getContent(lang).getPropertyXmlDoc(), "MenuName", false);
		                                            			%>
		                                                			<li><a href="<%=XmlUtils.getPageLink(subPage, lang, iscms, false).getLink() %>"><span><%=menuName%></span></a></li>
		                                            			<%
			                                            	}
		                                            	%>		                                                
		                                            </ul>
		                                        </li>                                        
							         			<%		         			
						         			} 
						         		%>	  
                                    </ul>
                                </nav><a class="responsive-menu-toggle " href="#"></a>
                            </div>
                        </div>
                        <div class="top_bar_right">
                        	<!-- for desktop and pad only -->
                        	<c:if test="${lang ne 'en'}">
                        		<span><a href="javascript:switchlang('${lang}','en');">EN</a></span>
                        	</c:if>                           
                        	<c:if test="${lang ne 'tc'}">
                        		<span><a href="javascript:switchlang('${lang}','tc');">繁</a></span>
                        	</c:if>                           
                        	<c:if test="${lang ne 'sc'}">
                        		<span><a href="javascript:switchlang('${lang}','sc');">简</a></span>
                        	</c:if>
                        </div>
                    </div>
                </div>
            </div>
            <div class="lang-m">
            	<!-- for mobile only -->
                <c:if test="${lang ne 'en'}">
               		<span><a href="javascript:switchlang('${lang}','en');">EN</a></span>
               	</c:if>                           
               	<c:if test="${lang ne 'tc'}">
               		<span><a href="javascript:switchlang('${lang}','tc');">繁</a></span>
               	</c:if>                           
               	<c:if test="${lang ne 'sc'}">
               		<span><a href="javascript:switchlang('${lang}','sc');">简</a></span>
               	</c:if>
            </div>

            <jsp:include page="/WEB-INF/Templates/Banner.jsp" />
        </header>
    </div>

	<sitemesh:write property='body'/>

	<x:parse xml="<%=masterContent.getContentXmlWithoutCRLF() %>" var="contentXml"></x:parse>
    <!-- Footer-->
    <footer id="footer" class="font-s">
        <div class="inner-wrapper">
	        <%
	        	Element copyrightElement = (Element)masterContent.getContentXmlDoc().selectSingleNode("/PageContent/Widget[@name='CopyRight']/Field");	        	
	        %>
	        <%=copyrightElement == null ? "" : copyrightElement.getTextTrim().replace("#year#", (new Date().getYear() + 1900) + "") %>
            <!--x:out select="$contentXml/PageContent/Widget[@name='CopyRight']/Field" escapeXml="fasle" /-->            
        </div>
    </footer>
    <a href="#0" class="cd-top"><%= lang.equals("en") ? "Back to top" : (lang.equals("tc") ? "回到頂部" : "回到顶部") %></a>
</div>