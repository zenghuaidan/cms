//Datetime fields setup
//add datetime picker
function setupDatetimeFields() {
  $(".datetimefield input").each( function() {
    //$(this).attr("readonly","true");
    //var d = $.datepicker.parseDate("dd/mm/yy", $(this).val().substr(0, 10));
    //var d = $.datepicker.parseDate("dd/mm/yy", $(this).val());
    $(this).datetimepicker({ format: 'Y-m-d h:m', value: $(this).val() });    
  });
}

function setupDateFields() {
  $(".datefield input, .datfield input").each( function() {
    //$(this).attr("readonly","true");
    $(this).datetimepicker({
        timepicker: false,
        format: 'Y-m-d',
        value: $(this).val()
    });
  });
}

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
//function setupAutoUrl() {
//  var pid=$("#hidparentid input").val();
//  $("#pgconfigname input").keyup( function() {
//    var txt=$(this).val().replace(/\W/g,' ');
//    $.get("/PageAdmin/UrlRender?parentid="+pid+"&txt="+txt, function(data) {
//      $("#pgconfigurl input").val(data);
//    });
//  });
//  $("#pgconfigname input").focusout( function() {
//    var txt=$(this).val().replace(/\W/g,' ');
//    $.get("/PageAdmin/UrlRender?parentid="+pid+"&txt="+txt, function(data) {
//      $("#pgconfigurl input").val(data);
//    });
//  });    
//}

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