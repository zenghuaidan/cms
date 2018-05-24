function setPropertyBox() {
  //set expand | collapse
  $("#propertybox .ec").click( function() {
    var ec=$(this).attr('ec');
    var l=$("#propertybox div.content");
    if (ec=="e") {
        $(this).removeClass("expand").addClass("collapse");
        $(this).attr("ec","c");      
        l.slideDown();
    } else {
        $(this).removeClass("collapse").addClass("expand");
        $(this).attr("ec","e");
        l.slideUp();
    }
  });
}

//define the fix layer widget drawer
function setWidgetBox() {
  $("#widgetbox .ecbar, #widgetbox .bigicon").click( function() {
    var ico=$('#widgetbox .ecbar .ico');
    if (ico.hasClass('leftexpand')) openWidgetBox(); else  closeWidgetBox();
  });
}

function closeWidgetBox() {
  $("#widgetbox .ecbar .ico").removeClass('rightcollapse').addClass('leftexpand');
  var w= $("#widgetbox .frame").width();
  $("#widgetbox .frame,#widgetbox").animate( { width: "-="+w } );
}

function openWidgetBox() {
  $("#widgetbox .ecbar .ico").removeClass('leftexpand').addClass('rightcollapse');
  var w=$(document).width()-$("#widgetbox").width();
  $("#widgetbox .frame,#widgetbox").animate( { width: "+="+w } );
}

/*function setWidgetSortDrop_v0() {
  var pgid=$("#cmspage").attr("pgid");
  var lang=$("#cmspage").attr("lang");
  $(".wSortDrop").sortable( {
    placeholder: "wToBeDrop",    
    //helper: 'clone',    
    cursor: 'move',
    cursorAt: {top: 0, left:0},
    helper: function(e,u) { 
      var wxid="";
      if (u.hasClass("wCEdit")) { wxid=u.attr('pid'); }
      else { wxid=u.attr('wxid'); }
      //console.log('helper wxid='+wxid);      
      return $("<div class='movingWidget' wxid='"+wxid+"' style='width:68px;height:63px;'></div>"); },
    appendTo: 'body',
    //connectWith: '#trashcan',
    update: function(e,ui) {
      var u=ui.item; var wxid=""; var nxid="";
      if (u.hasClass("wCEdit")) { wxid=u.attr('pid'); } else { wxid=u.attr('wxid'); }
      if (u.parents("#trashcan").length<=0) {
        //console.log('widget ('+wxid+') order changed');
        var nxt=u.next('.widget');
        if (nxt.length>0) {
          if (nxt.hasClass("wCEdit")) { nxid=nxt.attr('pid'); } else { nxid=nxt.attr('wxid'); }        
          chgWidgetOrder(pgid,lang,wxid,nxid);      
        }  else chgWidgetOrder(pgid,lang,wxid,'');   
      }      
    },
    zIndex:1000
  });
  $(".wico").draggable( {  
    helper: 'clone',
    appendTo: 'body',
    revert: "invalid",  
    //connectToSortable: ".wSortDrop",
    zIndex: 1000    
  });  
  $(".newWdropbox").droppable( { 
    hoverClass: "newWdropbox_hover",
    drop: function(event,ui) { widgetDropped($(this),event,ui); }
  });
}*/

function setWidgetSortDrop() {
  var pgid=$("#cmspage").attr("pgid");
  var lang=$("#cmspage").attr("lang");
  $(".wholder").sortable( {
    placeholder: "wToBeDrop",    
    cursor: 'move',
    cursorAt: {top: 0, left:0},
    helper: function(e,u) { 
      var wxid="";
      if (u.hasClass("wCEdit")) { wxid=u.attr('pid'); }
      else { wxid=u.attr('wxid'); }
      //console.log('helper wxid='+wxid+">>"+u.html());      
      return $("<div class='movingWidget' wxid='"+wxid+"' style='width:68px;height:63px;'></div>"); },
    appendTo: 'body',
    update: function(e,ui) {
      var u=ui.item; var wxid=""; var nxid="";
      if (u.hasClass("wCEdit")) { wxid=u.attr('pid'); } else { wxid=u.attr('wxid'); }
      if (u.parents("#trashcan").length<=0) {
        //console.log('widget ('+wxid+') order changed');
          //var nxt = u.next('.widget');
          var nxt = u.nextAll('.widget').eq(0);
        if (nxt.length>0) {
          if (nxt.hasClass("wCEdit")) { nxid=nxt.attr('pid'); } else { nxid=nxt.attr('wxid'); }        
            chgWidgetOrder(pgid,lang,wxid,nxid);      
        }  else chgWidgetOrder(pgid,lang,wxid,'');   
      }      
    },
    zIndex:1000
  });
}

function widgetDropped(t,e,ui) {
  var pgid=$("#cmspage").attr("pgid");
  var lang=$("#cmspage").attr("lang");
  var newwid=ui.helper.attr("wid");
  var newwname=ui.helper.attr("wname");
  var holderxid=t.parent().attr("xid");
  var holderwname=t.parent().attr("wname");
  var holderwid=t.parent().attr("wid");
  //console.log("widgetDropped:");
  var logstr="pgid="+pgid+"&lang="+lang+"&newwid="+newwid+"&newwname="+newwname;
  logstr+="&holderxid="+holderxid+"&holderwname="+holderwname+"&holderwid="+holderwid;
  //console.log(logstr);
  
  if (newwid=="TextBlock") {
    //console.log("TextBlock is dropped");
    var u=cmsroot+"PageContentAdmin/AddWidget?pgid="+pgid+"&lang="+lang;    
    $.post(u,{ hxid:holderxid,hwname:holderwname,wid:newwid,wname:newwname },function(data) { 
      if (data.success) {
        refresh();
      } else { alert("Error:"+data.errorMsg); }
    },"json");
  } else {
    //console.log("Non TextBlock is dropped");
    closeWidgetBox();
    if (holderxid=="new") {
      //console.log("Try creating new holder");
      var getxidu=cmsroot+"PageContentAdmin/GetOrNewWidgetXid?pageid="+pgid+"&lang="+lang+"&wname="+holderwname+"&wid="+holderwid;
      //console.log(getxidu);
      $.getJSON(getxidu,function(data) {
        holderxid=data.WidgetXid;
        //console.log("Holder xid retreived ("+holderxid+"). Try open widget form");
        openWidgetForm(pgid,lang,"new",newwid,newwname,holderxid,"refresh");
      });
    } else {
        //console.log("Try open widget form");
        openWidgetForm(pgid,lang,"new",newwid,newwname,holderxid,"refresh");
    }
  }
}

function setWidgetTrash() {
  //console.log('setWidgetTrash() called');
  //$("#trashcan").sortable();
  $("#trashcan").droppable( {
    hoverClass: "trashcan_hover",
    drop: function(event,ui) { widgetTrashed($(this),event,ui); }
  });
}

function widgetTrashed(t,e,ui) {
  //console.log('widget trashed: xid='+ui.helper.attr('wxid') );
  var wxid=ui.helper.attr('wxid');
  var pgid=$("#cmspage").attr("pgid");
  var lang=$("#cmspage").attr("lang");
  deleteWidget(pgid,lang,wxid,"function",function() { 
    $("#trashcan").html("");
    refresh();
  });  
}


function movWidget(pgid,lang,xid,beforeid,mfn) {
	/*var pms = [{name:"pgid",value:pgid},{name:"lang",value:lang},{name:"xid",value:xid}
				,{name:"beforeid",value:beforeid}];
	//var u = getYiiUrl("cmsadmin/PageContentAdmin/ChangeWidgetOrder",pms);*/
	var pms = "?pgid="+pgid+"&lang="+lang+"&xid="+xid+"&beforeid="+beforeid;
	var u = cmsroot+"PageContentAdmin/ChangeWidgetOrder"+pms;
    $.getJSON(u,function (data) { 
        if (data.success) { 
		  mfn();
        } else { alert(data.errorMsg); } 
    } );  
}

function movupWidget(pgid,lang,xid,mfn) {
	/*var pms = [ {name:"pgid",value:pgid},{name:"lang",value:lang},{name:"xid",value:xid} ];
	var u = getYiiUrl("cmsadmin/PageContentAdmin/MovWidgetUp",pms);*/
	var pms = "?pgid="+pgid+"&lang="+lang+"&xid="+xid;
	var u = cmsroot+"PageContentAdmin/MovWidgetUp"+pms;
    $.getJSON(u,function (data) { 
        if (data.success) { 
		  mfn();
        } else { alert(data.errorMsg); } 
    } );  
}

function movdownWidget(pgid,lang,xid,mfn) {
	/*var pms = [ {name:"pgid",value:pgid},{name:"lang",value:lang},{name:"xid",value:xid} ];
	var u = getYiiUrl("cmsadmin/PageContentAdmin/MovWidgetDown",pms);*/
	var pms = "?pgid="+pgid+"&lang="+lang+"&xid="+xid;
	var u = cmsroot+"PageContentAdmin/MovWidgetDown"+pms;
    $.getJSON(u,function (data) { 
        if (data.success) { 
		  mfn();
        } else { alert(data.errorMsg); } 
    } );  
}


var leftrightwnames=";DummyLeftRightBlock;";
function setWidgetPopForm() {
  /* Ver4.0 - Layer on widget + button box */
  $(".wpform").mouseenter( function() {  
      $("#wcmask").remove();
	  var widget = $(this);
      var pgid=$("#cmspage").attr("pgid"); var lang=$("#cmspage").attr("lang");    
      var wxid=$(this).attr("wxid"); var wid=$(this).attr("wid"); var wname=$(this).attr("wname");
	  var ptop = parseInt($(this).css("paddingTop")); var pbtm = parseInt($(this).css("paddingBottom"));
	  var pleft = parseInt($(this).css("paddingLeft")); var pright = parseInt($(this).css("paddingRight"));
      var w=$(this).width()+pleft+pright-2; var h=$(this).height()+ptop+pbtm-2;
      var s="top:0px;left:0px;width:"+w+"px;height:"+h+"px;";
	  
	  var box="&nbsp;";
	  if ($(this).closest(".wholder").length>0) { //from widget holder
		box="<div class='btnbox'>";
		box+="<div class='btn btndel'></div>";
		if (leftrightwnames.indexOf(";"+wname+";")>=0) {
			box+="<div class='btn btnleft'></div>";
			box+="<div class='btn btnright'></div>";		
		} else {
			box+="<div class='btn btnup'></div>";
			box+="<div class='btn btndown'></div>";
		}
		box+="</div>";
	  } 	  
	  
      //var h="<div id='wcmask' wxid='"+wxid+"' class='halfalpha_whitebg' style='"+s+"' onclick=\""+j+"\">"+box+"</div>";    
	  var h="<div id='wcmask' wxid='"+wxid+"' class='halfalpha_whitebg' style='"+s+"'>"+box+"</div>";    
      $(this).append(h);
	  
	  //define form pop up
	  $("#wcmask").click( function(e) {
			openWidgetForm(pgid,lang,wxid,wid,wname,'','refresh'); 
	  });
	  
	  //define del widget
	  $("#wcmask .btndel").click( function(e) {		
			e.stopPropagation();
			if (confirm(msgdelwconfirm)) {
				deleteWidget(pgid,lang,wxid,"function",function() { 
					$("#trashcan").html("");
					refresh();
				}); 
			}
	  });
	  
	  //define up widget
	  $("#wcmask .btnup,#wcmask .btnleft").click( function(e) {
			e.stopPropagation();
			movupWidget(pgid,lang,wxid,function() { refresh(); });
	  });

	  //define down widget
	  $("#wcmask .btndown,#wcmask .btnright").click( function(e) {	  
			e.stopPropagation();
			movdownWidget(pgid,lang,wxid,function() { refresh(); });
	  });	  
	  
  }).mouseleave( function() {
	  $("#wcmask,#wcmask .btn").unbind('click').remove();
  });  	
	
  /* Ver3.0 - Layer on widget
  $(".wpform").mouseenter( function() {  
      $("#wcmask").remove();
      var pgid=$("#cmspage").attr("pgid"); var lang=$("#cmspage").attr("lang");    
      var wxid=$(this).attr("wxid"); var wid=$(this).attr("wid"); var wname=$(this).attr("wname");
      var w=$(this).width()-2; var h=$(this).height()-2;
      var s="top:0px;left:0px;width:"+w+"px;height:"+h+"px;";
      var j="openWidgetForm("+pgid+",'"+lang+"','"+wxid+"','"+wid+"','"+wname+"','','refresh');";     
      var h="<div id='wcmask' wxid='"+wxid+"' class='halfalpha_whitebg' style='"+s+"' onclick=\""+j+"\">&nbsp;</div>";    
      $(this).append(h);
  });  */  
}

//Widget List Manager
function openWidgetMgr(t,xid) {
    var mgru=$(t).attr('mgru');
    if (xid=="new" || xid=="") {    
      var gnxu=$(t).attr('gnxu');
      $.getJSON(gnxu,function(data) {
          var wxid=data.successMsg;        
          var popu=mgru+"&mgrxid="+wxid;
          TINY.box.show({iframe:popu,width:gAjaxFormWidth,height:gPgConfigFormHeight,
                          closejs: function() { refresh(); }
          });
      });     
    } else {
        var popu=mgru+"&mgrxid="+xid;
        TINY.box.show({iframe:popu,width:gAjaxFormWidth,height:gPgConfigFormHeight,
                        closejs: function() { refresh(); }
        });
    }
}

/* Ver3.0 - Layer on widget*/
function setWidgetListMgr() {
    $(".wWidgetListMgr").mouseenter(function () {
        $("#wcmask").remove();
        var pgid = $("#cmspage").attr("pgid"); var lang = $("#cmspage").attr("lang");
        var mgr = $(this);
        var wname = mgr.attr("wname"); var wid = "WidgetListMgr";
        var mgrtype = mgr.attr("mgrtype"); var mgrattr = mgr.attr("mgrattr");
        var mgrpwxid = (mgr.hasAttr("mgrpwxid")) ? mgr.attr("mgrpwxid") : "";
        var mgru = cmsroot+"PageContentAdmin/WListMgr?pageid=" + pgid + "&lang=" + lang + "&mgrname=" + wname;
       // alert(wname);
        mgru += "&mgrtype=" + mgrtype + "&mgrattr=" + mgrattr;
        var gnxu = cmsroot+"PageContentAdmin/GetOrNewWidgetXid?pageid=" + pgid + "&lang=" + lang + "&wname=" + wname + "&wid=" + wid;
        gnxu += "&pwxid=" + mgrpwxid;

        var w = $(this).width() - 2; var h = $(this).height() - 2;
        var s = "top:0px;left:0px;width:" + w + "px;height:" + h + "px;";

        var j = "openWidgetMgr(this,'" + mgr.attr("xid") + "');";

        var h = "<div id='wcmask' class='halfalpha_whitebg' mgru=\"" + mgru + "\" gnxu=\"" + gnxu + "\" ";
        h += " style='" + s + "' onclick=\"" + j + "\"></div>";

        $(this).append(h);
    });
  
  //$(".wWidgetListMgr").mouseleave( function() {  $(this).find("#wcmask").remove(); } );
}

//Image Manager
function setImgBlkPopMgr() {
  var pgid=$("#cmspage").attr("pgid"); var lang=$("#cmspage").attr("lang");
  $(".wImgBlock").click( function() {
    var wxid = $(this).attr("wxid"); var wid = $(this).attr("wid"); var wname = $(this).attr("wname");
    openWidgetForm(pgid,lang,wxid,wid,wname,'','refresh');
    //openImgBlkMgr(domid,attr);
  });
}

//Subages Manager
function openSubpgsMgr(t,xid) {
    var mgru=$(t).attr('mgru');
    TINY.box.show({iframe:mgru,width:gAjaxFormWidth,height:gPgConfigFormHeight,
                    closejs: function() { refresh(); }
    });
}

function setSubPagesMgr() {
  $(".wSubPagesMgr").mouseenter( function() {
      $("#wcmask").remove();
      var parentid=$("#cmspage").attr("pgid"); var lang=$("#cmspage").attr("lang");
      var mgr=$(this);
      var wname=mgr.attr("wname"); var wid="WidgetListMgr"; 
      var mgrtype=mgr.attr("mgrtype"); var mgrattr=mgr.attr("mgrattr");
      var mgru=cmsroot+"PageAdmin/WSubPagesMgr?parentid="+parentid;
      mgru+="&mgrtype="+mgrtype+"&mgrattr="+mgrattr;  
    
      var p=$(this).offset(); var w=$(this).width(); var h=$(this).height();
      var s="top:"+p.top+"px;left:"+p.left+"px;width:"+w+"px;height:"+h+"px;";
      
      var j="openSubpgsMgr(this,'"+mgr.attr("xid")+"');";     
      
      var h="<div id='wcmask' class='halfalpha_whitebg' mgru=\""+mgru+"\" ";
      h+=" style='"+s+"' onclick=\""+j+"\"></div>";    
      
      $("body").append(h);
  });
}

//Workflows & Page Functions
function doWorkflow(pgid,action) {
  TINY.box.show({iframe:cmsroot+'PageAdmin/'+action+'?pageid='+pageid,
                  width:gAjaxFormWidth,height:gWorkflowFormHeight,
                  closejs: function() { if (refreshonclose) refresh(); }
  });
}
function doAjaxWFAct(pgid,action) {
    var u=cmsroot+"PageAdmin/"+action;
    $.post(u,{ "pgid":pgid },function(data) { 
      if (data.success) {
        refresh();
      } else { alert("Error:"+data.errorMsg); }
    },"json");
}

function publishPg(pgid) { 
	doWorkflow(pgid,"publish"); 
//	if (confirm("You are going to publish the page live which cannot be undo.  Do you want to continue?")) {
//		doAjaxWFAct(pgid,"DoPublish");
//	}
}
function reqPublishPg(pgid) { doWorkflow(pgid,"reqPublish"); }
function declinePg(pgid) { doWorkflow(pgid,"declinePg"); }

function reqDelete(pgid) { doAjaxWFAct(pgid,"markDelete"); }
function undoReqDelete(pgid) { doAjaxWFAct(pgid,"unMarkDelete"); }

function applyLangContent(srclang) {
  var pgid=$("#cmspage").attr("pgid");
  var pglang=$("#cmspage").attr("lang");
  var u=cmsroot+"PageContentAdmin/ApplyLang?pageid="+pgid+"&pglang="+pglang+"&applylang="+srclang;
  $.getJSON(u,function(data) {
    if (data.success) {
      refresh();
    } else { alert("Error:"+data.errorMsg); }
  });
}

function applyVer(v) {
  var pgid=$("#cmspage").attr("pgid");
  var u=cmsroot+"PageAdmin/ApplyVer?pageid="+pgid+"&ver="+v;
  $.getJSON(u,function(data) {
    if (data.success) {
      refresh();
    } else { alert("Error:"+data.errorMsg); }
  });
}

//Workflows & Page Function Buttons Setup
function setWorkflowBtns() {
  var pglang=$("#cmspage").attr("lang");
  $("#btnpublish").click( function() { publishPg($("#cmspage").attr("pgid")); } );
  $("#btnconfig").click( function() { configPg($("#cmspage").attr("pgid")); } );
  $("#btndelete").click( function() { 
	if (confirm("You are going to delete this page which cannot be undo.  Do you want to continue?")) { 
		deletePg($("#cmspage").attr("pgid")); } 
  } );
  $("#btnpreview").click( function() { popUrl(cmsroot+"PageAdmin/Preview?lang="+pglang+"&pgid="+pageid); } );
  $("#btnreqpublish").click( function() { reqPublishPg($("#cmspage").attr("pgid")); } );
  $("#btndecline").click( function() { declinePg($("#cmspage").attr("pgid")); } );
  $("#btnreqdel").click( function() { reqDelete($("#cmspage").attr("pgid")); } );
  $("#btnundoreqdel").click( function() { undoReqDelete($("#cmspage").attr("pgid")); } );
  var applym="All your current content for this language will be lost.  Do you want to continue?";
  $("#btnapplytc").click( function() { if (confirm(applym)) applyLangContent("tc"); } );
  $("#btnapplysc").click( function() { if (confirm(applym)) applyLangContent("sc"); } );
  $("#btnapplyen").click( function() { if (confirm(applym)) applyLangContent("en"); } );
  $("#btnapplycn").click( function() { if (confirm(applym)) applyLangContent("cn"); } );
  var apyverm = "By applying the previous version, your current content for all languages will be replaced. Do you want to continue?";
  $("#applyver").click( function() { if (confirm(apyverm)) applyVer($("#versel").val()); } );
}

//Quick Jump Select Box
function setQuickSel() {
  $("#pgsearchdrop").change( function() {
    goUrl('/PageAdmin/Index?id='+$(this).val());
  });
}

//Adjustments
function adjustBg() { if ($("#bg").length>0) { 
  $("#bg").css("height",$("#cmspage").height()+"px"); 
  //console.log('CMS Bg adjusted'); 
} }

//Set Disable Icon
function setDisableIcon(c) {
  var tlpos=$("#propertybox").offset();
  var w = $("#propertybox").width();
  var h = $("#cmspage").offset().top+$("#cmspage").height()-tlpos.top;
  var style="style='position:absolute;color:#fff;z-index:3000;background-image:url(" + webroot + "/resources/Content/images/spacer.gif);";  //IE transparent access via issue
  style+="top:"+tlpos.top+"px;left:"+tlpos.left+"px;width:"+w+"px;height:"+h+"px;'";
  var lbl=""; var icoh=0;
  switch (c) {
    case "tobedel":
      lbl="To Be<br />Deleted"; icoh=172;
    break;
    case "inactive":
      lbl="Inactive"; icoh=183;
    break;
    case "hasPR":
      lbl="Publisher"; icoh=183;
    break;
  }
  var icot=h/2-(icoh/2);
  var htm="<div id='disablemask' class='darkalpha_blackbg' "+style+">";
  htm+="<div class='icolbl "+c+"' style='margin-top:"+icot+"px;'>";
  htm+="<div>"+lbl+"</div></div></div>";
  $("body").append(htm);
}

//Set Widgets

function setWysWidgetBtn(jsel,wxid,wname,wid,newlb) {	
	if ($(jsel).length>0 && $(jsel)[0].tagName.toLowerCase()=="a") { $(jsel).removeAttr('href'); }
	$(jsel).attr('wxid',wxid).attr('wname',wname).attr('wid',wid);
	if (!$(jsel).hasClass('wpform')) $(jsel).addClass('wpform');
	if (wxid=="new" || $.trim($(jsel).html())=="") { 
		var nlb=(newlb==null)?"#"+wname+"#":newlb;
		$(jsel).append("<div class='newlb' style='width:100%; height:30px; text-align:center;'>"+nlb+"</div>"); 
	}
}

function setWysWidgetListBtn(jsel,wxid,wname,mgrtype,mgrattr,newlb) {
    $(jsel).attr('wxid', wxid).attr('xid', wxid).attr('wname', wname).attr('mgrtype', mgrtype).attr('mgrattr', mgrattr);
	if (!$(jsel).hasClass('wWidgetListMgr')) $(jsel).addClass('wWidgetListMgr');
	if (!$(jsel).hasClass('wSortDrop')) $(jsel).addClass('wSortDrop');
	if (wxid=="new" || $.trim($(jsel).html())=="") { 
		var nlb=(newlb==null)?"#"+wname+"#":newlb;
		$(jsel).append("<div class='newlb' style='width:100%; height:30px; text-align:center;'>"+nlb+"</div>"); 
	}
}

function setDynWysWidgetListBtn(jsel,wid,wxid,wname,mgrtype,mgrattr,newlb) {
    $(jsel).attr('wxid', wxid).attr('xid', wxid).attr('wname', wname).attr('mgrtype', mgrtype).attr('mgrattr', mgrattr);
	if (!$(jsel).hasClass('wWidgetListMgr')) $(jsel).addClass('wWidgetListMgr');
	if (!$(jsel).hasClass('wSortDrop')) $(jsel).addClass('wSortDrop');	
	var conf = "<div class='wpform' style='text-align:center;' wxid='"+wxid+"' wname='"+wname+"' wid='"+wid+"'># Configure "+wname+" #</div>";
	if (wid=="GPhotoWidgetList" && $(jsel).parent().hasClass('paging_container')) $(jsel).unwrap();
	$(jsel).before(conf);	
	if (wxid=="new" || $.trim($(jsel).html())=="") { 
		var nlb=(newlb==null)?"# Manage "+wname+" #":newlb;
		$(jsel).append("<div style='width:100%; height:30px; text-align:center;'>"+nlb+"</div>"); 
	}
}

function setWysWidgetHolderBtn(jsel,wxid,wname,pid) {
	$(jsel).attr('xid',wxid).attr('wname',wname).attr('wid',"WidgetHolder").attr('pid',pid);
	if (!$(jsel).hasClass('wWidgetHolder')) $(jsel).addClass('wWidgetHolder');	
	if (!$(jsel).hasClass('wSortDrop')) $(jsel).addClass('wSortDrop');	
}

function setWysNewWidgetBoxBtn(jsel,wxid,wname,pid,widgets) {
	$(jsel).attr('xid',wxid).attr('wname',wname).attr('wid',"WidgetHolder").attr('pid',pid).addClass('wholder').addClass('wholder-'+wname);
	var nwh = "<div class='newWbox'> Add New Widget <div class='woptlist'>";
	for(var i=0; i<widgets.length; i++) {
		var w = widgets[i];
		nwh+="<div class='nwico nw"+w.wname+"' wid='"+w.wid+"' wname='"+w.wname+"' onclick='newHoldWidget(this);'>";
		nwh+="		<img src='"+webroot+"/resources/Content/images/spacer.gif' />";
		nwh+="		<div class='label'>"+w.label+"</div>";
		nwh+="		<div class='plus'></div>";
		nwh+="</div>";
	}
	nwh+="<div class='clear'></div>";
	nwh+="</div></div>";
	$(jsel).append(nwh);	
}

function newHoldWidget(t) {
	var h = $(t).closest('div.newWbox').parent();
	
	var pgid=$("#cmspage").attr("pgid");
	var lang=$("#cmspage").attr("lang");
	var newwid=$(t).attr("wid");
	var newwname=$(t).attr("wname");
	var holderxid=h.attr("xid");
	var holderwname=h.attr("wname");
	var holderwid=h.attr("wid");
    
    closeWidgetBox();
    if (holderxid=="new") {  
	  //var pms = [{name:"pageid",value:pgid},{name:"lang",value:lang},{name:"wname",value:holderwname},{name:"wid",value:holderwid}];
	  //var getxidu = getYiiUrl(cmsroot+"PageContentAdmin/GetOrNewWidgetXid",pms);
      var getxidu = cmsroot + "PageContentAdmin/GetOrNewWidgetXid?pageid="+pgid+"&lang="+lang+"&wname="+holderwname+"&wid="+holderwid;
      $.getJSON(getxidu,function(data) {
        holderxid=data.successMsg;
        openWidgetForm(pgid,lang,"new",newwid,newwname,holderxid,"refresh");
      });
    } else {
        openWidgetForm(pgid,lang,"new",newwid,newwname,holderxid,"refresh");
    }
}

function disableAtags() {
   $("#cmspage a").removeAttr("href");   
}
//Page Loaded
function runPgAdminJSetup() {
  setPropertyBox();
  setWidgetBox();
  setWidgetTrash();
  setWidgetPopForm();
  setImgBlkPopMgr();  
  setWorkflowBtns();
  setWidgetListMgr();
  setSubPagesMgr();
  setSelPages();
  setLinkFields();
  setQuickSel();
  if (tobedel) setDisableIcon("tobedel");
  else if (isinactive) setDisableIcon("inactive");
  disableAtags();
}

//Page Loaded
$(function() {	
	//already loaded in pageadmin page
	//runPgAdminJSetup(); 
	$("html").addClass($("#cmspage").attr("lang"));
	$("html").addClass($("#cmspage").attr("lang") == 'en' ? 'english' : 'chinese');
});