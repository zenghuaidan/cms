<%@include file="/WEB-INF/Shared/commons.jsp" %>
<%@page contentType="text/html;charset=UTF-8"%>
<%@page import="org.apache.commons.lang3.StringUtils"%>
<%@page import="com.edeas.service.impl.QueryServiceImpl"%>
<%@page import="com.edeas.web.InitServlet"%>
<%@page import="com.edeas.model.*"%>
<%@page import="java.util.*"%>

<% 		

%>

<link href="${Content}/cms/core/useradmin.css" rel="stylesheet" type="text/css" />
<style>
    .tbox .tinner { padding:0px; }
    .tclose { top:8px; right:8px; width:21px; height:21px; background: url("${Content}/core/images/btn-close.png");}
    .tclose:hover { background-position:bottom left; }
    .gradbtn {line-height:18px}
    #admintopheader .sep {
	    height: 31px;
	    margin: 2px 10px 0px 10px;
	    background: #777;
	    float: left;
	    width: 1px;
	}
	#newbtn {
	    height: 35px;
	    line-height: 35px;
	    padding: 0px 0px 0px 40px;
	    margin: 0px 0px 0px 20px;
	    float: left;
	    cursor: pointer;
	    left: 0px;
	}
</style>
<script src="${Script}/jquery-ui-dragdropsort.min.js" type="text/javascript"></script>
<script src="${Script}/useradmin.js" type="text/javascript"></script>

<script type="text/javascript"> 
var id_sa="";
</script>
<!-- TOP FUNC HEADER -->
<div id="admintopheader" class="cmspgw hlgradbg" style="">
    <div id="leftuserfnbar" class="leftblock">
        <div id="newbtn" onclick="newuser();">New User</div>
        <div class="sep"></div>
        <div id="finduser" class="search">
            <img class="icosearch" src="${Content}/images/spacer.gif" alt="Icon" />
            <input type="text" value=""  />
            <div id="btnUsrSearch" class="gradlightbtn" >GO</div>
            <div id="btnClrSearch" class="gradlightbtn" >CLEAR SEARCH</div>
        </div>
    </div> 
    <div id="rightuserfnbar" class="rightblock">
        Status: <select id="selusrstatus">
            <option value="ALL">All</option>
            <option value="Active">Active</option>
            <option value="Inactive">Inactive</option>
        </select>
    </div>
</div>

<!-- USER LISTING -->
<div id="userlist">
	<c:forEach items="${users}" var="user" >
	    <div class="userblock">
	        <div class="band"></div>
	        <div class="inner" usrid='${user.id}' roles="">
	            <div class="table">
	                <div class="label">LOGIN NAME</div> <div class="loginnameval value">${user.login}</div>
	                <div class='clear'></div>
	            	<div class="label">FIRST NAME</div> <div class="firstnameval value">${user.firstName}</div>
	                <div class='clear'></div>
	                <div class="label">LAST NAME</div> <div class="lastnameval value">${user.lastName}</div>
	                <div class='clear'></div>
	                <div class="label">EMAIL</div> <div class="emailval value">${user.email}</div>
	                <div class='clear'></div>
	                <div class="label">STATUS</div> <div class="activeval value">${user.active ? "Active" : "Inactive"}</div>
	                <div class="clear"></div>
	                <div class="btnrow">
	                    <div class="gradbtn roundall" onclick="edituser(${user.id})">Edit</div>
	                    <div class="gradbtn roundall btnresetpwd" onclick="resetpwd(${user.id})">Reset Pwd</div>
	                    <div class="gradbtn roundall btnafn ${user.active ? 'inactivebtn' : 'activebtn'}" onclick="trgactive(${user.id})">${user.active ? "Inactivate" : "Activate"}</div>                    
	                </div>
	           	</div>             
	            <img class="icon" src="${Content}/images/spacer.gif" alt="Icon" />
	        </div>
	    </div>		                        		
	</c:forEach>
</div>  

<div class="clear"></div>
<div id="layerpool" style="display:none;">
    <!-- NO USER -->
    <div id='nousrdiv'><div class='nousr cmspgw'>No User Found</div></div>
    <!-- UESR FORM -->
    <div class="userform">
        <h2></h2>
        <div class="table">            
            <div class="label">SCOPE</div> 
			<div class="value scopeval">
                <input type="checkbox" name="chkrolesa" value="yes" />Super Admin
            </div>
             
            <div class='clear'></div>
            <div class="label">ROLE</div> 
            <div class="value roleval">
            	<input type="checkbox" name="iname" value="yes"/>Test   
            </div>
            <div class='clear'></div>            
            <div class="label">LOGIN NAME</div> <div class="value"><input name="login" type="text" value="" reqmsg="LDAP name is requried" /></div>            
            <div class='clear'></div>
            <div class="label">FIRST NAME</div> <div class="value"><input name="firstName" class="reqtxt" type="text" value="" reqmsg="First name is requried"/></div>
            <div class='clear'></div>
            <div class="label">LAST NAME</div> <div class="value"><input name="lastName" class="reqtxt" type="text" value="" reqmsg="Last name is required" /></div>
            <div class='clear'></div>
            <div class="label">EMAIL</div> <div class="value"><input name="email" class="reqtxt email" type="text" value="" reqmsg="Email is required" emailmsg="Invalid email address" /></div>                        
            <div class='clear'></div>
            <div class="label">ACTIVE</div> <div class="value"><input name="active" class="active" type="checkbox" value="yes" /></div>
            <div class="clear"></div>
            <div class="btnrow">
                <div class="gradbtn roundall" onclick="submitusrfm(false)">Save</div>
                <div class="gradbtn roundall" onclick="closeusr();">Cancel</div>
                <div class="gradbtn roundall" onclick="clearusr();">Clear</div>
                <div class="errmsg"></div>
            </div>
        </div>
        <img class="bigicon" src="${Content}/images/spacer.gif" alt="Icon" />
        <img class="close" src="${Content}/images/spacer.gif" alt="Close" />
    </div>

</div>