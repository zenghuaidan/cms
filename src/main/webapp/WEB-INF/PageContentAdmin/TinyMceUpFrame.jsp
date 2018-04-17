<html>
<head>
	<%@ include file="/WEB-INF/Shared/commons.jsp" %>
	<script src="//code.jquery.com/jquery-1.12.1.min.js"></script>
	<script src="${Script}/jquery.form.js" type="text/javascript"></script>
</head>
<body>
	<form id="mceUploadFrameForm" method='post' action='${ aurl }' enctype='multipart/form-data'>
		<div>
			<input type='file' name='filedata' style='width: 200px;' /> 
			<input type='button' value='Upload' onclick="submitMceUploadFrameForm();" /> 
			<input type='hidden' name='iname' value='${ iname }' />
		</div>
	</form>
</body>
</html>

<script>
	function submitMceUploadFrameForm() {
		var options = {
			success: function (data) {			
				parent.document.getElementById('${ iname }').value= data;
				parent.closeMceUp('${ iname }');
			}
		};
	   
		$("#mceUploadFrameForm").ajaxForm(options);
	   	$("#mceUploadFrameForm").ajaxSubmit(options);		
	}
</script>