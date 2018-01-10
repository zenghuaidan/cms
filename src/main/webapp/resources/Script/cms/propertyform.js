//trigger edit mode
function enterPtyFormEdit() { 
	// $("#propertyform h2 span").text("Properties [Not Saved]"); 
	if ($("#propertyform .btns .notsavewarn").length<=0) {
		var sty='color:red;';
		$("#propertyform h2 span").eq(0).append("<span class='notsavewarn' style='"+sty+"'> [Not Saved]</span>"); 		
		sty+='position:absolute; right:5px; top:7px;font-size:12px;font-weight:bold;';		
		$("#propertyform .btns").append("<div class='notsavewarn' style='"+sty+"'>[Not Saved]</div>");
	}
	showPtyFormBtns(); 
}

function setupPtyFormEditTrigger() {
  $("#propertyformtbl .txtfield input").keyup( function() { enterPtyFormEdit(); } );
  $("#propertyformtbl input,#propertyformtbl select").change( 
    function() { enterPtyFormEdit(); } );
}

//trigger save mode
function enterPtyFormSave() { $("#propertyform h2 span").text("Properties");  hidePtyFormBtns(); }

//setup buttons
function showPtyFormBtns() { $("#propertyform .btns").show(); }
function hidePtyFormBtns() { $("#propertyform .btns").hide(); }

//setup property form ajax submission
function setPtyFormSubmission() {
  //when save button clicked
	$("#propertyform .savebtn").click(function() {
	var options = {
		success: function (data) {
			if(data.success){
				window.location.reload();	        		
			} else {
				alert(data.errorMsg)
			}
		}
	};
   
	$("#propertyform").ajaxForm(options);
   	$("#propertyform").ajaxSubmit(options); 
//    $("#propertyform").submit(); //standard post to support file uploads
    /* AJAX Submit Not Support File Uploads
    $.post("/PageContentAdmin/UpdateProperty",$("#propertyform").serialize(),function(data) {
      if (data.success) { enterPtyFormSave(); refresh(); }
      else alert('Unable to update the properties: '+data.errorMsg);
    });
    */
  });
  //when cancel button clicked
  $("#propertyform .cancelbtn").click(function() {
      //$("#propertyform h2").text("Properties");
      var pgid=$("#pageid").val(); var l=$("#lang").val();
      $("#propertybox").load("/PageContentAdmin/GetPropertyBox?pageid="+pgid+"&lang="+l,function() {
        //initPtyForm();
      });      
  });
}

//setup property form limit
function setPtyFormLimit() {
  $("#propertyform input[name=SeoKeys]").attr("maxlength","64").after(" <span style=''>[Max 64 characters]</span>");
  $("#propertyform input[name=SeoDesc]").attr("maxlength", "256").after(" <span style=''>[Max 256 characters]</span>");
  $("#propertyform input[name=HeadTitle]").attr("maxlength", "128").after(" <span style=''>[Max 128 characters]</span>");
  $("#propertyform input[name=MenuName]").attr("maxlength", "128").after(" <span style=''>[Max 128 characters]</span>");
}

//when page ready
function initPtyForm() { 
  setupPtyFormEditTrigger();
  setPtyFormSubmission();  
  setPtyFormLimit();
}

$(function() { initPtyForm(); });