//---General
//Datetime fields setup
/* >>> Old Datetime field
//add datetime picker
function setupDatetimeFields() {
  var datfmt="yy-mm-dd"; //dd/mm/yy
  $(".datetimefield input").each( function() {
    $(this).attr("readonly","true");
    var d=$.datepicker.parseDate( datfmt, $(this).val().substr(0,10));
    $(this).datetimepicker({ "dateFormat":datfmt,defaultDate:d });    
  });
}

function setupDateFields() { 
  var datfmt="yy-mm-dd"; //dd/mm/yy
  //single date
  $(".datefield input, .datfield input").each( function() {
    $(this).attr("readonly","true");
    var d=$.datepicker.parseDate( datfmt, $(this).val());
    $(this).datepicker({ "dateFormat":datfmt,buttonImage:cmsroot+"/Content/cms/core/images/calendar.png"
                          ,buttonImageOnly:true,showOn:"button",defaultDate:d });
  });
  //date range
  $(".datrngfield input.date").each( function() {
    $(this).attr("readonly","true");
    var d=$.datepicker.parseDate( datfmt, $(this).val());
    $(this).datepicker({ "dateFormat":datfmt,buttonImage:cmsroot+"/Content/cms/core/images/calendar.png"
                          ,buttonImageOnly:true,showOn:"button",defaultDate:d									 
						  ,onSelect: function(datxt,obj) {		
							var f = $(this);
							var ifdfclass = (f.hasClass("datefieldi"))?"datefieldf":"datefieldi";							
							var d = f.siblings("input."+ifdfclass);
							if (d.val()=="") d.val(datxt);
						  }
					   });
  });
}
*/

//Document fields
function clearDocField (fid) {
  $("#"+fid).val(''); $("#"+fid+"_view").remove();
  $("#"+fid+"_span").html("<input type='file' id='"+fid+"_file' name='"+fid+"_file' style='width:200px;' />");
}

//Setup checkbox trigger for disabling textbox
//Sample: neverexpire checkbox to expiredate textbox
function setupTxtDisableTrgChkbox() {
  $(".trgtxtdisable input").click( function() {   
      var txt=$("#"+$(this).parent().attr("txt")+" input");
      if ($(this).is(':checked')) txt.attr('disabled','true');
      else txt.removeAttr('disabled');
  });
}

//---Page Config Specific

//auto fill the url when user input or change the page name
function setupAutoUrl() {
  var pid=$("#parentid").val();
  $("#pgconfigname input").keyup( function() {
    var txt=$(this).val().replace(/\W/g,' ');
    $.get(cmsroot+"PageAdmin/UrlRender?parentid="+pid+"&txt="+txt, function(data) {
      $("#pgconfigurl input").val(data);
    });
  });
  $("#pgconfigname input").focusout( function() {
    var txt=$(this).val().replace(/\W/g,' ');
    $.get(cmsroot+"PageAdmin/UrlRender?parentid="+pid+"&txt="+txt, function(data) {
      $("#pgconfigurl input").val(data);
    });
  });    
}

//apply logic when template get changed
function setupTemplateSelect() {
  $("#templatefield select").change( function() { setUrlOnConfig(); });
}

//Adjust Url prefix / suffix / display on template selected
function setUrlOnConfig() {
  var tv=$("#templatefield select").val();
  if (tv=="Sector") {
    $("#urlsuffix").text("");
    $("#pgconfigurl,#lbpgconfigurl").show();
  } else if (tv=="Link") {
    $("#pgconfigurl,#lbpgconfigurl").hide();
  } else {
    $("#urlsuffix").text(".html");
    $("#pgconfigurl,#lbpgconfigurl").show();  
  }
}

//Define google fonts
function defineGoogleFont() {
    /*
    WebFontConfig = {
        google: { families: ['Oswald'] },
        fontactive: function (fontFamily, fontDescription) {
            //resizeBg();
        }
    };

    var wf = document.createElement('script');
    //wf.src = ('https:' == document.location.protocol ? 'https' : 'http') + '://ajax.googleapis.com/ajax/libs/webfont/1/webfont.js';
    wf.src = '../js/webfont.js';
    wf.type = 'text/javascript';
    wf.async = 'true';
    var s = document.getElementsByTagName('script')[0];
    s.parentNode.insertBefore(wf, s);
    */
}

//Document Ready
/*$(function() {
  setupXHEditorFields();
  setupDatetimeFields();  
  setupDateFields();
  setupTxtDisableTrgChkbox();  
  //page config specific
  setupAutoUrl();
  setUrlOnConfig();
  setupTemplateSelect();  
});*/