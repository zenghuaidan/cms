function validemail(e) { 
  var filter = /^([a-zA-Z0-9_\.\-])+\@(([a-zA-Z0-9\-])+\.)+([a-zA-Z0-9]{2,4})+$/;
  return filter.test(e);
}

function newuser() {
    var htm="<form id='usrfm' class='userform newusr' method='post'>";
    htm+=$("#layerpool .userform").html()+"</form>";
    TINY.box.show({ html: htm, openjs: function() {
    	clearusr(); 
    	$("#usrfm h2").text("NEW USER");
    	$("#usrfm input[name$=activeChk]").prop('checked', false);
        $("#usrfm input[name$=active]").val($("#usrfm input[name$=activeChk]").prop('checked'));
	} 
    });
}

function edituser(uid) {
   var udiv=$(".userblock div.inner[usrid$="+uid+"]");
   var login=udiv.find('div.loginnameval').text();
   var firstName=udiv.find('div.firstnameval').text();
   var lastName=udiv.find('div.lastnameval').text();
   var email=udiv.find('div.emailval').text();
   var active=udiv.find('div.activeval').text(); 
   var roles=udiv.attr('roles').split(',');
   
   var htm="<form id='usrfm' class='userform editusr' method='post'>";
   htm+="<input type='hidden' name='id' value='"+uid+"' />";
   htm+=$("#layerpool .userform").html()+"</form>";
   TINY.box.show({ html: htm, openjs: function() {
      clearusr();
      $("#usrfm h2").text("MODIFY USER");
      //set user properties
      $("#usrfm input[name$=login]").val(login);
      $("#usrfm input[name$=firstName]").val(firstName);
      $("#usrfm input[name$=lastName]").val(lastName);
      $("#usrfm input[name$=email]").val(email);	  
      $("#usrfm input[name$=activeChk]").prop('checked',active=="Active");
      $("#usrfm input[name$=active]").val($("#usrfm input[name$=activeChk]").prop('checked'));
      //set roles
      for (var i=0; i<roles.length; i++) {
        $("#usrfm input[name$=chkrole"+roles[i]+"]").prop('checked',true);
      }
   } });
}

function closeusr() { TINY.box.hide(); }

function clearusr() {
  $("#usrfm input[type$=text]").val("");
  $("#usrfm input.active").attr('checked',true);
  $("#usrfm div.roleval input,#usrfm div.scopeval input").attr('checked',false);
}

function validateusrfm() {
    var err = ""; $("#usrfm .errmsg").text(err);

    //Required Text (.reqtxt) Check
    if (err == "") {
        $("#usrfm input.reqtxt").each(function () {
            if ($.trim($(this).val()) == "") { err = $(this).attr('reqmsg'); }
        });
    }

    //Email (.email) Format Check	
    if (err == "") {
        $("#usrfm input.email").each(function () {
            if (!validemail($(this).val())) { err = $(this).attr('emailmsg'); }
        });
    }	

    //Display error message
    if (err != "") { $("#usrfm .errmsg").text(err); return false; }
    else return true;
}

function submitusrfm() {
    if (validateusrfm()) {
    var u=($("#usrfm").hasClass('newusr'))?cmsroot+"UserAdmin/NewUser":cmsroot+"UserAdmin/ModifyUser";
    $.post(u,$("#usrfm").serialize(),function(data) {
        if (data.success) {
            refresh();
        } else {
            $("#usrfm .errmsg").text(data.errorMsg);
        }
    },"json");
  }
}

function resetpwd(uid) {
 var l=webroot+"/resources/Content/images/spacer.gif";
 var udiv=$(".userblock div.inner[usrid$="+uid+"]");
 var url=cmsroot+"UserAdmin/ResetPwd";
 udiv.find(".btnresetpwd").append("<img class='smbtnload' src='"+l+"' alt='loading' />");
 $.post(url,{id:uid},function(data) {
      if (data.success) {
        udiv.find(".btnresetpwd img").remove();
      } else alert(data.errorMsg);
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
    if (k==defsearchtxt.toLowerCase() || $.trim(k)=="") { 
    	$(".userblock").show(); 
	} else {
		$(".userblock").each( function() {
			var t = $(this).find('.loginnameval').text().toLowerCase()+" "+$(this).find('.firstnameval').text().toLowerCase()+" "+$(this).find('.lastnameval').text().toLowerCase()+" "+$(this).find('.emailval').text().toLowerCase();
			if (t.indexOf(k)>=0) { $(this).show(); n++; } else $(this).hide();
		});
		if (n<=0) { $("#userlist").append($("#nousrdiv").html()); }		
	}
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