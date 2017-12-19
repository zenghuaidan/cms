<%@ tag language="java" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@attribute name="headScript" fragment="true" %>
<html>
	<head>		
		<%@ include file="/WEB-INF/public/commons.jspf" %>		
		<jsp:invoke fragment="headScript"/>
		<script>
			var root = '${pageContext.request.contextPath}';
		</script>
	</head>
	<body id="cmsbody" class="cmsbody">		
	    <div id="cmsheader" class="cmspgw cmstyle">
	        <img id="cmslogo" src="<%=request.getContextPath() %>/resources/css/images/logo.gif" alt="logo" />
	        <!-- h1 class="bigfont">Admango 網站內容管理系統</h1-->
	        <div id="toprightbox">
	            <div class='top cmslightgreybg'>
	                <span class="txtlnk" onclick="openchgpwd();">Change Password</span>
	                |
	                <span class="txtlnk" onclick="logout('<%=request.getContextPath() %>/logout');">Logout</span>
	            </div>
	            <div class='bottom hlcolor'>
	                ${pageContext.request.remoteUser}
	            </div>
	        </div>
	    </div>
	    <div class="clear" style="height:10px"></div>
	    <c:set var="menuSelected" value="cmstmitm_sel hlgradbg btmshadow bigfont" />
	    <c:set var="menuDeselected" value="cmstmitm bigfont" />
	    <div id="cmstopmenu" class="cmspgw cmstyle cmsdarkgreybg">
    		<div class="${menu eq 'Index' ? menuSelected : menuDeselected}" onclick="location.href='<%=request.getContextPath() %>/admin/index';">Index</div>
    		<sec:authorize access="hasRole('Admin')">
    			<div class="${menu eq 'ManageMaster' ? menuSelected : menuDeselected}" onclick="location.href='<%=request.getContextPath() %>/admin/show/Chain';">Manage Master</div>
    			<div class="${menu eq 'Product' ? menuSelected : menuDeselected}" onclick="location.href='<%=request.getContextPath() %>/admin/product';">Manage SKU</div>
    			<!--div class="${menu eq 'Template' ? menuSelected : menuDeselected}" onclick="location.href='<%=request.getContextPath() %>/admin/template';">Manage SKU Template</div-->
    			<div class="${menu eq 'PDAAdmin' ? menuSelected : menuDeselected}" onclick="location.href='<%=request.getContextPath() %>/admin/pdaadmin';">PDA Admin</div>
    			<div class="${menu eq 'Admango' ? menuSelected : menuDeselected}" onclick="location.href='<%=request.getContextPath() %>/admin/admango';">Admango Admin</div>
    			<div class="${menu eq 'Image' ? menuSelected : menuDeselected}" onclick="location.href='<%=request.getContextPath() %>/admin/image';">Image Admin</div>    			
			</sec:authorize>
			<div class="${menu eq 'CR' ? menuSelected : menuDeselected}" onclick="location.href='<%=request.getContextPath() %>/admin/cr';">CR</div>
    		<div class="${menu eq 'User' ? menuSelected : menuDeselected}" onclick="location.href='<%=request.getContextPath() %>/admin/users';">User</div>    		
	    </div>
	    <div class="clear"></div>
	    <div>
	        <jsp:doBody/>
	    </div>
	    <div class="clear"></div>
	    <div id="cmsfooter" class="cmspgw">
	        Developed By &copy; Edeas Limited
	    </div>
	    <div id="cmslayerpool" style="display:none;">
	        <div class="chgpwdform">	        
	            <h2>Change Password</h2>
	            <div class="table">
	                <div class="label">Old Password</div> <div class="value"><input name="oldpwd" class="reqtxt" type="password" value="" reqmsg="Old Password is requried"/></div>
	                <div class="clear"></div>
	                <div class="label">New Password</div> <div class="value"><input name="newpwd" class="reqtxt" type="password" value="" reqmsg="New Password is required" /></div>
	                <div class="clear"></div>
	                <div class="label">Retype Password</div> <div class="value"><input name="retypepwd" class="reqtxt" type="password" value="" reqmsg="Please Re-Type New Password" /></div>
	                <div class="clear"></div>
	                <div class="btnrow">
	                    <div class="gradbtn roundall" onclick="submitchgpwd()">Save</div>
	                    <div class="gradbtn roundall" onclick="closechgpwd();">Cancel</div>
	                    <div class="gradbtn roundall" onclick="clearchgpwd();">Clear</div>
	                    <div class="errmsg"></div>
	                </div>
	            </div>
	            <img class="bigicon" src="<%=request.getContextPath() %>/resources/css/images/spacer.gif" alt="Icon" />
	            <img class="close" src="<%=request.getContextPath() %>/resources/css/images/spacer.gif" alt="Close" />
	        </div>
	    </div>
	</body>
</html>