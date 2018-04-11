function validemail(e) { 
  var filter = /^([a-zA-Z0-9_\.\-])+\@(([a-zA-Z0-9\-])+\.)+([a-zA-Z0-9]{2,4})+$/;
  return filter.test(e);
}

function newuser() {
    var htm="<form id='usrfm' class='userform newusr' method='post'>";
    htm+=$("#layerpool .userform").html()+"</form>";
    TINY.box.show({ html: htm, openjs: function() {clearusr(); $("#usrfm h2").text("NEW USER"); } });
}

function edituser(uid) {
   var udiv=$(".userblock div.inner[usrid$="+uid+"]");
   //var name=udiv.find('div.firstnameval').text().split(', ');
   var name=udiv.find('div.firstnameval').text();
   var email=udiv.find('div.emailval').text();
   var active=udiv.find('div.activeval').text();
   //var fname=name[1]; var lname=name[0]; 
   var roles=udiv.attr('roles').split(',');
   
   var htm="<form id='usrfm' class='userform editusr' method='post'>";
   htm+="<input type='hidden' name='usrid' value='"+uid+"' />";
   htm+=$("#layerpool .userform").html()+"</form>";
   TINY.box.show({ html: htm, openjs: function() {
      clearusr();
      $("#usrfm h2").text("MODIFY USER");
      //set user properties
      //$("#usrfm input[name$=firstname]").val(fname);
      //$("#usrfm input[name$=lastname]").val(lname);
	  $("#usrfm input[name$=username]").val(name);
      $("#usrfm input[name$=email]").val(email);
      var a = (active=="Active")?true:false;
      $("#usrfm input[name$=active]").attr('checked',a);
      //set roles
      for (var i=0; i<roles.length; i++) {
        $("#usrfm input[name$=chkrole"+roles[i]+"]").attr('checked',true);
      }
   } });
}

function closeusr() { TINY.box.hide(); }

function clearusr() {
  $("#usrfm input[type$=text]").val("");
  $("#usrfm input.active").attr('checked',true);
  $("#usrfm div.roleval input,#usrfm div.scopeval input").attr('checked',false);
}

function valideldapusr(usr) {
    var usrexist = false;
    $.ajax({
        type: "POST",
        async: false,
        url: cmsroot + 'Account/ValidateUser',
        data: 'usrid=' + usr,
        success: function (data) {
            if (data) {
                usrexist = true;
                $("#usrfm input[name=firstname]").val(data.displayName);
                $("#usrfm input[name=lastname]").val(data.displayName);
                $("#usrfm input[name=email]").val(data.email);
            } else {
                usrexist = false;
            }
            
        }
    });
    return usrexist;
}

function valideldapemail(email) {
    var emailxist = false;
    $.ajax({
        type: "POST",
        async: false,
        url: cmsroot + 'Account/ValidateEmail',
        data: 'email=' + email,
        success: function (data) {
            if (data) {
                emailxist = true;
                $("#usrfm input[name=firstname]").val(data.displayName);
                $("#usrfm input[name=lastname]").val(data.displayName);
                $("#usrfm input[name=username]").val(data.uid);
            } else {
                emailxist = false;
            }
            
        }
    });
    return emailxist;
}

function validateusrfm(needADCheck) {
    var err = ""; $("#usrfm .errmsg").text(err);

    //Required Text (.reqtxt) Check
    if (err == "") {
        $("#usrfm input.reqtxt").each(function () {
            if ($.trim($(this).val()) == "") { err = $(this).attr('reqmsg'); }
        });
    }

    // Email Exist Check
    if (err == "" && needADCheck) {
        /*
		$("#usrfm input[name=username]").each(function () {
            if (!valideldapusr($(this).val())) { err = $(this).attr('ldapmsg'); }
        });
		*/
		$("#usrfm input[name=email]").each(function () {
            if (!valideldapemail($(this).val().trim())) { err = $(this).attr('emailmsg'); }
        });
    }

    //Email (.email) Format Check	
    if (err == "") {
        $("#usrfm input.email").each(function () {
            if (!validemail($(this).val())) { err = $(this).attr('emailmsg'); }
        });
    }	

    //Require at least one role
    /*
    if (err=="") { 
      //console.log('in role check'); 
      var chk=0; 
      $("#usrfm div.roleval input").each( function() {
      if ($(this).is(':checked')) chk++;
    }); if (chk<=0) err="At least one role must be checked"; }
    */

    //Display error message
    if (err != "") { $("#usrfm .errmsg").text(err); return false; }
    else return true;
}

function submitusrfm(needADCheck) {
    if (validateusrfm(needADCheck)) {
    var u=($("#usrfm").hasClass('newusr'))?cmsroot+"Account/NewUser":cmsroot+"Account/ModifyUser";
    $.post(u,$("#usrfm").serialize(),function(data) {
        if (data.Success == "True") {
            refresh();
        } else {
            $("#usrfm .errmsg").text(data.Message);
            //alert(data.Message);
        }
    },"json");
  }
}

function resetpwd(uid) {
 var l=cmsroot+"Content/images/spacer.gif";
 var udiv=$(".userblock div.inner[usrid$="+uid+"]");
 var url=cmsroot+"Account/ResetPwd";
 udiv.find(".btnresetpwd").append("<img class='smbtnload' src='"+l+"' alt='loading' />");
 $.post(url,{usrid:uid},function(data) {
      if (data.Success=="True") {
        udiv.find(".btnresetpwd img").remove();
      } else alert(data.Message);
 },"json");
}

//trigger activate / inactivate
function trgactive(uid) {
 var sp=cmsroot+"Content/images/spacer.gif";
 var udiv=$(".userblock div.inner[usrid$="+uid+"]");
 var abtn=udiv.find(".btnafn");
 var url=(abtn.hasClass('activebtn'))?cmsroot+"Account/Activate":cmsroot+"Account/Inactivate";
 abtn.append("<img class='smbtnload' src='"+sp+"' alt='loading' />");
 $.post(url,{usrid:uid},function(data) {
      if (data.Success=="True") {
        if (abtn.hasClass('activebtn')) {
          udiv.find(".activeval").text("Active");
          abtn.text("Inactivate");
          abtn.removeClass('activebtn').addClass('inactivebtn');
        } else {
          udiv.find(".activeval").text("Inactive");
          abtn.text("Activate");
          abtn.removeClass('inactivebtn').addClass('activebtn');        
        }
        udiv.find(".btnresetpwd img").remove();
      } else alert(data.Message);
 },"json");
}

function setStatusFilter() {
  $("#selusrstatus").change( function() {
    $("#finduser input").val(defsearchtxt);
    var s=$(this).val();
    $("#userlist .nousr").remove();
    if (s=="ALL") {
      $(".userblock").show();
    } else {
      var n=0;
      $(".userblock").each( function() {
          var v = $(this).find('.activeval').text();        
          if (s==v) { $(this).show(); n++; } else $(this).hide();
      });      
      if (n<=0) { $("#userlist").append($("#nousrdiv").html()); }
    }
  });
}

var defsearchtxt="=== Search Name or Email ===";

function setClearSearch() {
  $("#btnClrSearch").click(function() { $("#finduser input").val(defsearchtxt); $(".userblock").show(); });
}

function doSearch() {    
    $("#userlist .nousr").remove();
    $("#selusrstatus").val("ALL");
    var sbox=$("#finduser input");
    var k = sbox.val().toLowerCase();
    var n=0;
    if (k==defsearchtxt.toLowerCase() || $.trim(k)=="") { $(".userblock").show(); }
    $(".userblock").each( function() {
      var t = $(this).find('.firstnameval').text().toLowerCase()+" "+$(this).find('.emailval').text().toLowerCase();
      if (t.indexOf(k)>=0) { $(this).show(); n++; } else $(this).hide();
    });
    if (n<=0) { $("#userlist").append($("#nousrdiv").html()); }
}

function setSearch() {
  //set search textbox 
  var sbox=$("#finduser input");
  sbox.val(defsearchtxt);
  sbox.focus( function() { if ($.trim(sbox.val())==defsearchtxt) sbox.val(""); });  
  sbox.blur( function() { if ($.trim(sbox.val())=="") sbox.val(defsearchtxt); });
  sbox.keyup( function(e) { if (e.which==13) { doSearch(); } });
  //do search
  $("#btnUsrSearch").click(function() { doSearch(); });
}

$(document).ready( function() {
  if ($(".userblock").length<=0) $("#userlist").append($("#nousrdiv").html());
  
  setStatusFilter();
  setSearch();
  setClearSearch();
});