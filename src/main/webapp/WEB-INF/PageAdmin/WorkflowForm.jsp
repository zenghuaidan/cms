<%@page contentType="text/html;charset=UTF-8"%>
<%@include file="/WEB-INF/Shared/commons.jsp" %>

<!DOCTYPE html>
<html>
<head>   
	<link href="${Content}/cms/core/cms.css" rel="stylesheet" type="text/css" />
	<link href="${Content}/cms/core/pageadmin.css" rel="stylesheet" type="text/css" />
	<link href="${Content}/cms/core/jquery-ui-widgets.css" rel="stylesheet" type="text/css" />	
	<link href="${Content}/cms/cmsstyle.css" rel="stylesheet" type="text/css" />
	<link href="${Content}/cms/editorstyles.css" rel="stylesheet" type="text/css" />
	
	<script src="//code.jquery.com/jquery-1.12.1.min.js"></script>    
    <script src="${Script}/cms/common.js" type="text/javascript"></script>
    <script src="${Script}/cms/ajaxform.js" type="text/javascript"></script>
    <script type="text/javascript" src="${context}/dwr/engine.js"></script>
	<script type="text/javascript" src="${context}/dwr/interface/dwrService.js"></script>    

	<style>
		#ajaxform { width:760px; height:300px; }
	    #wkflwform { padding:5px 10px; overflow:auto; }
	    #wkflwform textarea { width:99%; }  
	    #loading { text-align:center;  padding:50px 0 0 0; }  
	    #loading b { font-size:24px; font-weight:bold; }
	</style>
	<script type="text/javascript">
	    function submitWorkflowForm() {
	        var u = "<%=Global.getCMSUrl() %>/PageAdmin/${action}"        
	        $.post(u, $("#workflowform").serialize(), function (data) {
	            if (data.Success == "True") {
	                if (data.IsDel === "True") parent.goUrl('<%=Global.getCMSUrl() %>/SiteAdmin');
	                else {
	                    parent.refreshonclose = true;
	                    parent.TINY.box.hide();
	                }
	            } else alert(data.Message);
	        }, "json");
	        //$("#workflowform").attr("action",u).attr("method","post").submit();
	        $("#wfwform").html("<h2 class='darkbg'>&nbsp;</h2><div id='loading'> <b>Processing</b> <br /> Please be patient and do not close this layer <br /> Once compeleted, your page will auto refresh</div>");
	    }
	
	    function cancelWorkflowForm() {
	        parent.refreshonclose = false;
	        parent.TINY.box.hide();
	    }
	</script>
</head>
<body>
	<div id="ajaxform">
  		<h1>${ title }</h1>
  		<div>
			<div id="wfwform">
				<form action="<%=Global.getCMSUrl() %>/PageAdmin/${action}" method="post" id="workflowform" name="workflowform">
				    <h2 class="darkbg">Your message:</h2>
				    <div id="wkflwform">
				        <input type="hidden" name="pgid" value="${ pageid }" />
				        <textarea name="message" rows="5"></textarea>
				        <c:if test="${ action == 'doReqPublish' }">
				            <div>Approver : <select name="approver">  </select></div>
				        </c:if>                
				    </div>
				    
				    <div class="clear"></div>
				    <div class="actionbtns">
				        <div class="cmsbtn" onclick="cancelWorkflowForm();">Cancel</div>
				        <div class="cmsbtn" onclick="submitWorkflowForm();">Submit</div>     
				    </div>				
				</form>				
			</div>
  		</div>
	</div>
</body>
</html>

