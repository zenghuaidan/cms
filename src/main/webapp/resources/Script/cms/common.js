//global variable//
var gAjaxFormWidth=760;
var gPgConfigFormHeight=390;
var gWorkflowFormHeight=300;
var gWidgetFormHeight=500;
var gPopLayerWidthPerc=0.9;
var gPopLayerHeightPerc=0.75;
var refreshonclose = false;
var webroot = "";
var cmsroot = "";
$(function() {	
	dwrService.getContextPath(function(path) {
		webroot = path;
		dwrService.getCMSURI(function(url) {
			cmsroot = webroot + ((url.lastIndexOf("/") == url.length + 1) ? url : (url + "/"));
		});
	});	
})
var msgdelwconfirm = "You are going to DELETE a widget which cannot be undo.  Do you want to proceed?";
var msgdelpgconfirm = "You are going to DELETE a page which cannot be undo.  Do you want to proceed?";


function E$(e) { return document.getElementById(e); }
function U$(u) { return cmsroot + u; }
function RU$(u) { return "/" + u; }
function goUrl(u) { location.href=u; }
function popUrl(u) { window.open(u); }
function refresh() { window.location.reload(); }
function xssclean(s) {  var r=s; r=r.replace(/['"<>\(\)]+/g,''); return r; }

function isiphone() { if ((navigator.userAgent.match(/iPhone/i))) return true; else return false; }
function isipad() { if ((navigator.userAgent.match(/iPad/i))) return true; else return false; }
function isiphoneipad() { if ((navigator.userAgent.match(/iPhone/i)) || (navigator.userAgent.match(/iPad/i)))                             return true; else return false; }
function isios() { return navigator.userAgent.match(/iPhone|iPad|iPod/i); }
function isandroid() { return navigator.userAgent.match(/Android/i); }
function ismobile() { return (isios()||isandroid()); } 

function validemail(e) {
    var filter = /^([a-zA-Z0-9_\.\-])+\@(([a-zA-Z0-9\-])+\.)+([a-zA-Z0-9]{2,4})+$/;
    return filter.test(e);
}

$.fn.hasAttr = function(name) {  return this.attr(name) !== undefined; };

function switchcms() {
	var chgto="www";
	if ($("body").hasClass("wwwcms")) { chgto="lan"; } 
	$.post(cmsroot+"SiteAdmin/SwitchCms",{"chgto":chgto},function(data) {
		//if (data.success) location.reload();
		if (data.success) location.href=cmsroot+"SiteAdmin/Index";
		else alert(data.errorMsg); 
	},"json");
}

/* Change Password */
function openchgpwd() {
    var htm="<form id='chgpwdfm' class='chgpwdform' method='post'>";
    htm+=$("#cmslayerpool .chgpwdform").html()+"</form>";
    TINY.box.show({ html: htm, openjs: function() {clearchgpwd(); } });
}

function closechgpwd() { TINY.box.hide(); }

function clearchgpwd() { $("#chgpwdfm input[type$=password]").val(""); }

function validatechgpwdfm() {
  var err=""; $("#chgpwdfm .errmsg").text(err);
  
  //Required Text (.reqtxt) Check
  if (err=="") { $("#chgpwdfm input.reqtxt").each( function() {
      if ($.trim($(this).val())=="") { err=$(this).attr('reqmsg'); }
  }); }
  
  //New Password Must Be Equal to Re-Type Password
  if ( err=="") {
      if ($("#chgpwdfm input[name$=newpwd]").val()!=$("#chgpwdfm input[name$=retypepwd]").val()) {
        err="Re-type password is not identical to New password"; }    
  }
  
  //Display error message
  if (err!="") { $("#chgpwdfm .errmsg").text(err); return false; }
  else return true;
}

function submitchgpwd() {
  if (validatechgpwdfm()) { 
    var u = cmsroot + "ChgPwd";
    $.post(u,$("#chgpwdfm").serialize(),function(data) {
      if (data.success) {
        closechgpwd();
      } else alert(data.errorMsg);
    },"json");
  }
}

/* CMS Features : Image Manager*/
var imgmgr=new Array();
//function openImgMgr(domid,dbid,pgid,lang,xid,attr) {
function openImgMgr(domid,attr) {
  dbid=$("#"+domid).val();
  var param="retid="+domid+"&dbid="+dbid+"&attr="+attr;
  //console.log("openImgMgr: "+param);
  window.open(cmsroot+"PageContentAdmin/ImgMgr?" + param, target = "new", "width=720,height=620,status=no,toolbar=no,menubar=no,location=no");
}

function openImgBlkMgr(domid,attr) {
  dbid=$("#"+domid).val();
  var param="retid="+domid+"&dbid="+dbid+"&attr="+attr+"&caller=imgblk";
  //console.log("openImgBlkMgr: "+param);
  window.open(cmsroot+"PageContentAdmin/ImgMgr?"+param,null,"width=720,height=620,status=no,toolbar=no,menubar=no,location=no");
}

function defmsgbox() {
  var attr=$("#imgattr").val();  
  var reqs=$.trim(attr).split(';');
  var htm="";
  for (var i=0; i<reqs.length; i++) {
    var r = reqs[i];
    var st = $.trim(r).split(':');
    var func=$.trim(st[0]);
    var params=$.trim(st[1]);
    if (func=="fix" || func=="fixw" || func=="fixh" ||func=="cropto"
        || func=="max" || func=="maxw" || func=="maxh" 
        ||func=="min" || func=="minw"
        || func=="resize" || func=="ref") {
      var p=params.split('x'); var w=parseInt(p[0]); var h=parseInt(p[1]);
      if (htm!="") htm+="<br />";
      if (func=="ref") { p=params.split(',');  w=p[0]; }
      htm+=imgmsg(func,w,h);
    }
  }
  $("#msgbox").html(htm);
}

function imgmsg(f,w,h) {
  switch (f) {
    case "fix": return "Dimension of the image must be "+w+" x "+h;
    case "fixw": return "Width of the image must be "+w+"px";
    case "fixh": return "Height of the image must be "+w+"px";
    case "maxw": return "Width of the image must not exceed "+w+"px";
    case "minw": return "Width of the image must exceed "+w+"px";
    case "maxh": return "Height of the image must not exceed "+w+"px";
    case "max": return "Dimension of the image must not exceed "+w+" x "+h;
    case "min": return "Dimension of the image must not smaller than "+w+" x "+h;
    case "cropto": return "Dimension of the image must not smaller than "+w+" x "+h;
    case "resize": return "Image will automatically be resized within "+w+"x"+h;
    case "ref": return "A '"+w+"' image will be automatically rendered";
    default: return "";
  }
}

function verifyImg() {
  var attr=$("#imgattr").val();  
  var reqs=$.trim(attr).split(';');  
  imgmgr["validimg"]=true;
  imgmgr["errmsg"]=new Array();  
  for (var i=0; i<reqs.length; i++) {
    var r=reqs[i];    
    var st = $.trim(r).split(':');
    var func=$.trim(st[0]);
    var params=$.trim(st[1]);    
    switch (func) {
      case "fix":        
        var p=params.split('x'); var fixw=parseInt(p[0]); var fixh=parseInt(p[1]);
        //console.log("verifyImg: "+func+">fixw="+fixw+",fixh="+fixh);
        if (fixw!=imgmgr["imgw"] || fixh!=imgmgr["imgh"]) {
          imgmgr["validimg"]=false;
          var idx=imgmgr["errmsg"]
          imgmgr["errmsg"].push(imgmsg(func,fixw,fixh));
        }
        break;
       case "fixw":
        var maxw=parseInt(params);
        if (maxw!=imgmgr["imgw"]) {
          imgmgr["validimg"]=false;
          var idx=imgmgr["errmsg"];
          imgmgr["errmsg"].push(imgmsg(func,params,0));
        }
        break;           
        case "fixh":
        var maxh=parseInt(params);
        if (maxh!=imgmgr["imgh"]) {
          imgmgr["validimg"]=false;
          var idx=imgmgr["errmsg"];
          imgmgr["errmsg"].push(imgmsg(func,params,0));
        }
        break;  
       case "minw":
        var minw=parseInt(params);
        if (minw>imgmgr["imgw"]) {
          imgmgr["validimg"]=false;
          var idx=imgmgr["errmsg"];
          imgmgr["errmsg"].push(imgmsg(func,params,0));
        }
        break;         
       case "maxw":
        var maxw=parseInt(params);
        if (maxw<imgmgr["imgw"]) {
          imgmgr["validimg"]=false;
          var idx=imgmgr["errmsg"];
          imgmgr["errmsg"].push(imgmsg(func,params,0));
        }
        break;        
       case "maxh":
        var maxh=parseInt(params);
        if (maxh<imgmgr["imgh"]) {
          imgmgr["validimg"]=false;
          var idx=imgmgr["errmsg"];
          imgmgr["errmsg"].push(imgmsg(func,params,0));
        }
        break;            
       case "max":
        var p=params.split('x'); var maxw=parseInt(p[0]); var maxh=parseInt(p[1]);
        if (maxw<imgmgr["imgw"] || maxh<imgmgr["imgh"]) {
          imgmgr["validimg"]=false;
          var idx=imgmgr["errmsg"]
          imgmgr["errmsg"].push(imgmsg(func,maxw,maxh));
        }
        break;       
       case "min":
        var p=params.split('x'); var minw=parseInt(p[0]); var minh=parseInt(p[1]);
        if (minw>imgmgr["imgw"] || minh>imgmgr["imgh"]) {
          imgmgr["validimg"]=false;
          var idx=imgmgr["errmsg"]
          imgmgr["errmsg"].push(imgmsg(func,minw,minh));
        }
        break;   
       case "resize":
         var p=params.split('x'); var maxw=parseInt(p[0]); var maxh=parseInt(p[1]);     
         imgmgr["errmsg"].push(imgmsg(func,minw,minh));        
       break;
       case "ref":
         var p=params.split(','); var rname=p[0]; 
         //console.log("verifyImg: ref > p="+p+",rname="+rname);
         imgmgr["errmsg"].push(imgmsg(func,rname,""));        
       break;
    }
  }
  return imgmgr["validimg"];
}

function ImgMgrLoadImg(dbid) {      
  if (dbid!="") {
    var panelw=596; var panelh=320;
    var g="<img src='/PageContentAdmin/ViewImg?dbid="+dbid+"&maxw=140&maxh=0' />";
    //console.log("ImgMgrLoadImg: "+dbid);
    $("#fileid").val(dbid);        
    $.getJSON("/PageContentAdmin/getImgInfo?dbid="+dbid,function(data) {
      imgmgr["imgw"]=parseInt(data.width);
      imgmgr["imgh"]=parseInt(data.height);
      if (verifyImg()) {
        //$("#tbimg").css("padding","0px").removeClass('noimg').html(g);
        $("#tbimg").removeClass('noimg').html(g);
        //$("#imgpanel").css("backgroundImage","url(/PageContentAdmin/ViewImg?dbid="+dbid+"&maxw="+panelw+"&maxh="+panelh+")");      
        $("#imgpanel img").attr("src","/PageContentAdmin/ViewImg?dbid="+dbid+"&maxw="+panelw+"&maxh="+panelh);
        $(".imgwt").text(data.width);
        $(".imght").text(data.height);
        $("#fileid").attr("w",data.width).attr("h",data.height);
        var wp=panelw/parseFloat(data.width)*100;
        var hp=panelh/parseFloat(data.height)*100;
        var p=(hp<wp)?hp:wp;
        if (p>100) p=100;
        $(".imgp").text(p.toFixed(2));
      } else alert("Invalid Image");
    });
  }
}

function setImgResize() {
  //width height sync
  $("#rszw,#rszh").keyup( function() {    
    var w =$("#fileid").attr("w");
    if (typeof w!== 'undefined' && w!== false) {
      var whp=parseFloat(w)/parseFloat($("#fileid").attr("h"));
      var neww; var newh;
      if ($(this).attr("id")=="rszw") {        
        neww=parseInt($(this).val());
        newh=Math.round(neww/whp);
        $("#rszh").val(newh);
      } else {
        newh=parseInt($(this).val());
        neww=Math.round(newh*whp);
        $("#rszw").val(neww);
      }      
    }
  });
  
  //click action
  $("#btnresize").click(function() {
    var dbid=$("#fileid").val();
    $.post("/PageContentAdmin/ResizeImg?dbid="+dbid+"&w="+$("#rszw").val()+"&h="+$("#rszh").val(),function(data) {
      if (data.success) {
        ImgMgrLoadImg(dbid);
      } else {
        //console.log("ResizeImg: Failure");
      }
    },"json");
  });
}

function setImageValue(retid,imgid) {
  if ($("#"+retid).parents("#propertyformtbl").length>0) enterPtyFormEdit();
  $("#"+retid).val(imgid);
}

/* CMS Features : Image Library*/
function openImgLib(domid,attr) {	
	dbid=$("#"+domid).val();
	var param="retid="+domid+"&dbid="+dbid+"&attr="+attr+"&caller=imgblk";
	//console.log("openImgLib: "+param);
	window.open(cmsroot+"PageContentAdmin/ImgLib?"+param,"imglibwin","width=720,height=620,status=no,toolbar=no,menubar=no,location=no");
}

function openXheImgLib(domid,attr) {	
	dbid=$("#"+domid).val();
	var param="retid="+domid+"&dbid="+dbid+"&attr="+attr+"&caller=xheblk";
	//console.log("openXheImgLib: "+param);
	window.open(cmsroot+"PageContentAdmin/ImgLib?"+param,"imglibwin","width=720,height=620,status=no,toolbar=no,menubar=no,location=no");
}

function setImgValue(retid,v,org,ver) {
	//console.log("setImgValue: retid="+retid+",v="+v+",org="+org+",ver="+ver);	
	$("#"+retid).val(v);
	$("#"+retid+"_org").val(org);
	$("#"+retid+"_ver").val(ver);
	$("#"+retid+"_label").val(org+" ("+ver+")");
	$("#"+retid+"_btns").show();	
	if ($("#"+retid).parents("#propertyformtbl").length>0) enterPtyFormEdit();
}

function setXheImgValue(retid,v,org,ver) {
	var u = cmsroot+"Images/source/"+v;
	console.log("setXheImgValue : retid="+retid+",u="+u+",org="+org+",ver="+ver);	
	$("#"+retid+"_url").val(u);
	//$("#"+retid+"_label").text(org+" ("+ver+")");	
	if ($("#"+retid+"_url").parents("#propertyformtbl").length>0) enterPtyFormEdit();
}

function openImgField(fid) {
	var f= $("#"+fid).val();
    popUrl(cmsroot+"Images/source/"+f);
}

function clearImgField(fid) {
	$("#"+fid).val("");
	$("#"+fid+"_org").val("");
	$("#"+fid+"_ver").val("");
	$("#"+fid+"_label").val("");
	$("#"+fid+"_btns").hide();
	if ($("#"+fid).parents("#propertyformtbl").length>0) enterPtyFormEdit();
}


/* CMS Features : Document Library*/
function openDocLib(domid) {	
	dbid=$("#"+domid).val();
	var param="retid="+domid+"&dbid="+dbid+"&caller=docblk";
	//console.log("openDocLib: "+param);
	window.open(cmsroot+"PageContentAdmin/DocLib?"+param,"doclibwin","width=720,height=620,status=no,toolbar=no,menubar=no,location=no");
}

function openXheDocLib(domid) {	
	dbid=$("#"+domid).val();
	var param="retid="+domid+"&dbid="+dbid+"&caller=xheblk";
	//console.log("openXheDocLib: "+param);
	window.open(cmsroot+"PageContentAdmin/DocLib?"+param,"doclibwin","width=720,height=620,status=no,toolbar=no,menubar=no,location=no");
}

function setDocValue(retid,v,org,ver) {
	console.log("retid="+retid+",v="+v+",org="+org+",ver="+ver);	
	$("#"+retid).val(v);
	$("#"+retid+"_org").val(org);
	$("#"+retid+"_ver").val(ver);
	$("#"+retid+"_label").val(org+" ("+ver+")");
	$("#"+retid+"_view").show();
	$("#"+retid+"_clr").show();
	if ($("#"+retid).parents("#propertyformtbl").length>0) enterPtyFormEdit();
}

function setXheDocValue(retid,v,org,ver) {
	//console.log("setXheDocValue : retid="+retid+",v="+v+",org="+org+",ver="+ver);	
	var u = cmsroot+"Docs/"+v;
	$("#"+retid+"_url").val(u);
	//$("#"+retid+"_label").text(org+" ("+ver+")");
	if ($("#"+retid+"_url").parents("#propertyformtbl").length>0) enterPtyFormEdit();
}

function openDocField(fid) {
	var f= $("#"+fid).val();
    popUrl(cmsroot+"Docs/"+f);
}

function clearDocField(fid) {
	$("#"+fid).val("");
	$("#"+fid+"_org").val("");
	$("#"+fid+"_ver").val("");
	$("#"+fid+"_label").val("");
	$("#"+fid+"_view").hide();
	$("#"+fid+"_clr").hide();
	if ($("#"+fid).parents("#propertyformtbl").length>0) enterPtyFormEdit();
}

/* Widget */
function deleteWidget(pgid,lang,xid,closing,cfn) {
    var u=cmsroot+"PageContentAdmin/DeleteWidget?pgid="+pgid+"&lang="+lang+"&xid="+xid;
    $.getJSON(u,function (data) { 
        if (data.success) { 
          switch (closing) {
            case "function": cfn(); break;
            default: refresh(); break;
          }          
        } else { alert(data.errorMsg); } 
    } );
}

function openWidgetForm(pgid,lang,wxid,wid,wname,parentxid,close) {
    var u=cmsroot+"PageContentAdmin/WidgetForm?pageid="+pgid+"&lang="+lang;
    u+="&wxid="+wxid+"&wid="+wid+"&wname="+wname+"&parentxid="+parentxid;
    u+="&caller=layer";
	
	//var framew = gAjaxFormWidth;
	var framew = Math.floor($(window).width()*gPopLayerWidthPerc);
	if (framew < gAjaxFormWidth) framew = gAjaxFormWidth;
	if (framew > 990) framew = 990;
	//var frameh = gWidgetFormHeight;
	var frameh = Math.floor($(window).height()*gPopLayerHeightPerc);
	if (frameh < gWidgetFormHeight) frameh = gWidgetFormHeight;	
	
    TINY.box.show({iframe: u, animate: false,width:framew,height:frameh, closejs: function() {                   
        switch (close) {
          case "refresh": if (refreshonclose) refresh(); break;
          case "openerrefresh": window.opener.refresh(); break;
        }
    }});
}

function openWidgetFormWin(pgid,lang,wxid,wid,wname,parentxid,close) {
    var u=cmsroot+"PageContentAdmin/WidgetForm?pageid="+pgid+"&lang="+lang;
    u+="&wxid="+wxid+"&wid="+wid+"&wname="+wname+"&parentxid="+parentxid;
    u+="&caller=win";
    window.open(u,null,"width=980,height=620,status=no,toolbar=no,menubar=no,location=no");
}

function chgWidgetOrder(pgid,lang,xid,beforeid) {
var u=cmsroot+"PageContentAdmin/ChangeWidgetOrder?pgid="+pgid+"&lang="+lang+"&xid="+xid+"&beforeid="+beforeid;
    $.getJSON(u,function (data) { 
        if (data.success) { 
            //alert('Order changed success!');
            location.reload();
        } else { alert(data.errorMsg); } 
    } );  
}

/* Fields */
function setSelPages() {
	var pgid= $("#pageid").val();
    $(".selpages").each( function() {
		var attr = $(this).attr("attr");
		//console.log("setSelPages: "+cmsroot+"/PageAdmin/getPageOptions?pgid="+pgid+"&attr="+attr);
		$(this).load(cmsroot+"PageAdmin/getPageOptions?pgid="+pgid+"&attr="+attr,function() {	
			$(this).val($(this).attr("val"));
		});
	})
}
function setLinkFields() {
    $('.lnkfield').each( function() {
        var fid= $(this).attr("fid");
        if ($("input:radio[name="+fid+"_type]:checked").length<=0)
            $("input:radio[name="+fid+"_type]")[0].checked=true;
    });
}

function clrVal(d) { $("#"+d).val(''); }

/* Page Setup */
function configPg(pageid,caller) {
  TINY.box.show({iframe:cmsroot+'PageAdmin/Config?pageid='+pageid,
                  width:gAjaxFormWidth,height:gPgConfigFormHeight,
                  closejs: function() {  if (refreshonclose) refresh(); }
  });
}

function openNewPage(parentid,beforeid) {
  TINY.box.show({iframe:cmsroot+'PageAdmin/New?parentid='+parentid+'&beforeid='+beforeid,
                  width:gAjaxFormWidth,height:gPgConfigFormHeight,
                  closejs: function() { if (refreshonclose) refreshSiteTree(); }
  });
}

function deletePg(pgid) {
  $.getJSON(cmsroot+"/PageAdmin/Delete?id="+pgid,function(data) {
    if (data.success) { 
      switch(data.Message) {      
        case "backsiteadmin": goUrl(cmsroot+'/SiteAdmin'); break;
        case "refresh": refresh(); break;
        default: refresh(); break;
      }  
    } else { alert(data.errorMsg); }
  });
}

function initBackToTop() {
    // Back to Top 
    $("#back-to-top").hide();

    $(window).scroll(function () {
        if ($(window).scrollTop() > 100) {
            $("#back-to-top").fadeIn(1500);
        } else {
            $("#back-to-top").fadeOut(1500);
        }
    });
    //back to top
    $("#back-to-top").click(function () {
        $('body,html').animate({ scrollTop: 0 }, 1000);
        return false;
    });
}

/* TINYBOX 2*/
TINY={};TINY.box=function(){var j,m,b,g,v,p=0;return{show:function(o){v={opacity:70,close:1,animate:1,fixed:1,mask:1,maskid:'',boxid:'',topsplit:2,url:0,post:0,height:0,width:0,html:0,iframe:0};for(s in o){v[s]=o[s]}if(!p){j=document.createElement('div');j.className='tbox';p=document.createElement('div');p.className='tinner';b=document.createElement('div');b.className='tcontent';m=document.createElement('div');m.className='tmask';g=document.createElement('div');g.className='tclose';g.v=0;document.body.appendChild(m);document.body.appendChild(j);j.appendChild(p);p.appendChild(b);m.onclick=g.onclick=TINY.box.hide;window.onresize=TINY.box.resize}else{j.style.display='none';clearTimeout(p.ah);if(g.v){p.removeChild(g);g.v=0}}p.id=v.boxid;m.id=v.maskid;j.style.position=v.fixed?'fixed':'absolute';if(v.html&&!v.animate){p.style.backgroundImage='none';b.innerHTML=v.html;b.style.display='';p.style.width=v.width?v.width+'px':'auto';p.style.height=v.height?v.height+'px':'auto'}else{b.style.display='none';if(!v.animate&&v.width&&v.height){p.style.width=v.width+'px';p.style.height=v.height+'px'}else{p.style.width=p.style.height='100px'}}if(v.mask){this.mask();this.alpha(m,1,v.opacity)}else{this.alpha(j,1,100)}if(v.autohide){p.ah=setTimeout(TINY.box.hide,1000*v.autohide)}else{document.onkeyup=TINY.box.esc}},fill:function(c,u,k,a,w,h){if(u){if(v.image){var i=new Image();i.onload=function(){w=w||i.width;h=h||i.height;TINY.box.psh(i,a,w,h)};i.src=v.image}else if(v.iframe){this.psh('<iframe src="'+v.iframe+'" width="'+v.width+'" frameborder="0" height="'+v.height+'"></iframe>',a,w,h)}else{var x=window.XMLHttpRequest?new XMLHttpRequest():new ActiveXObject('Microsoft.XMLHTTP');x.onreadystatechange=function(){if(x.readyState==4&&x.status==200){p.style.backgroundImage='';TINY.box.psh(x.responseText,a,w,h)}};if(k){x.open('POST',c,true);x.setRequestHeader('Content-type','application/x-www-form-urlencoded');x.send(k)}else{x.open('GET',c,true);x.send(null)}}}else{this.psh(c,a,w,h)}},psh:function(c,a,w,h){if(typeof c=='object'){b.appendChild(c)}else{b.innerHTML=c}var x=p.style.width,y=p.style.height;if(!w||!h){p.style.width=w?w+'px':'';p.style.height=h?h+'px':'';b.style.display='';if(!h){h=parseInt(b.offsetHeight)}if(!w){w=parseInt(b.offsetWidth)}b.style.display='none'}p.style.width=x;p.style.height=y;this.size(w,h,a)},esc:function(e){e=e||window.event;if(e.keyCode==27){TINY.box.hide()}},hide:function(){TINY.box.alpha(j,-1,0,3);document.onkeypress=null;if(v.closejs){v.closejs()}},resize:function(){TINY.box.pos();TINY.box.mask()},mask:function(){m.style.height=this.total(1)+'px';m.style.width=this.total(0)+'px'},pos:function(){var t;if(typeof v.top!='undefined'){t=v.top}else{t=(this.height()/v.topsplit)-(j.offsetHeight/2);t=t<20?20:t}if(!v.fixed&&!v.top){t+=this.top()}j.style.top=t+'px';j.style.left=typeof v.left!='undefined'?v.left+'px':(this.width()/2)-(j.offsetWidth/2)+'px'},alpha:function(e,d,a){clearInterval(e.ai);if(d){e.style.opacity=0;e.style.filter='alpha(opacity=0)';e.style.display='block';TINY.box.pos()}e.ai=setInterval(function(){TINY.box.ta(e,a,d)},20)},ta:function(e,a,d){var o=Math.round(e.style.opacity*100);if(o==a){clearInterval(e.ai);if(d==-1){e.style.display='none';e==j?TINY.box.alpha(m,-1,0,2):b.innerHTML=p.style.backgroundImage=''}else{if(e==m){this.alpha(j,1,100)}else{j.style.filter='';TINY.box.fill(v.html||v.url,v.url||v.iframe||v.image,v.post,v.animate,v.width,v.height)}}}else{var n=a-Math.floor(Math.abs(a-o)*.5)*d;e.style.opacity=n/100;e.style.filter='alpha(opacity='+n+')'}},size:function(w,h,a){if(a){clearInterval(p.si);var wd=parseInt(p.style.width)>w?-1:1,hd=parseInt(p.style.height)>h?-1:1;p.si=setInterval(function(){TINY.box.ts(w,wd,h,hd)},20)}else{p.style.backgroundImage='none';if(v.close){p.appendChild(g);g.v=1}p.style.width=w+'px';p.style.height=h+'px';b.style.display='';this.pos();if(v.openjs){v.openjs()}}},ts:function(w,wd,h,hd){var cw=parseInt(p.style.width),ch=parseInt(p.style.height);if(cw==w&&ch==h){clearInterval(p.si);p.style.backgroundImage='none';b.style.display='block';if(v.close){p.appendChild(g);g.v=1}if(v.openjs){v.openjs()}}else{if(cw!=w){p.style.width=(w-Math.floor(Math.abs(w-cw)*.6)*wd)+'px'}if(ch!=h){p.style.height=(h-Math.floor(Math.abs(h-ch)*.6)*hd)+'px'}this.pos()}},top:function(){return document.documentElement.scrollTop||document.body.scrollTop},width:function(){return self.innerWidth||document.documentElement.clientWidth||document.body.clientWidth},height:function(){return self.innerHeight||document.documentElement.clientHeight||document.body.clientHeight},total:function(d){var b=document.body,e=document.documentElement;return d?Math.max(Math.max(b.scrollHeight,e.scrollHeight),Math.max(b.clientHeight,e.clientHeight)):Math.max(Math.max(b.scrollWidth,e.scrollWidth),Math.max(b.clientWidth,e.clientWidth))}}}();

/************** Document Ready ***************/
$(document).ready(function () {
    initBackToTop();
});
