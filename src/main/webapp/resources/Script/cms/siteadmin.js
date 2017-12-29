function setExpandCollapse() {
  $(".ec").click( function() {
    var ec=$(this).attr('ec');
    var l=$(this).parent().next(".grp");
    if (l.size()>0) {
      if (ec=="e") {
        $(this).removeClass("expand").addClass("collapse");
        $(this).attr("ec","c");      
        l.slideDown();
      } else {
        $(this).removeClass("collapse").addClass("expand");
        $(this).attr("ec","e");
        l.slideUp();
      }
    }
  });
}

function newTopSectDropped(event,ui) {
  var t=$("#topsectors .newtopbtn");
  var n=t.next(".topsect");
  if (n.length>0) { openNewPage(0,n.attr("pgid"))} 
  else { openNewPage(0,0);}  
}

function chgPgOrder(pgid,beforeid) {
  $.getJSON(cmsroot+"SiteAdmin/ChgPgOrder?pgid="+pgid+"&beforeid="+beforeid, function(data) {
      refreshSiteTree();
  });
}

function topSectOrderChanged(e,ui) {
  var pgid=parseInt(ui.item.attr('pgid'));
  var next=ui.item.next("div.topsect");
  if (next.length>0) {
    var nxtid=parseInt(next.attr("pgid"));    
    chgPgOrder(pgid,nxtid);
  } else {
    chgPgOrder(pgid,0);
  }
}

function pageOrderChanged(e,ui) {
  var pgid=parseInt(ui.item.children('div.pg').attr('pgid'));
  var next=ui.item.next('div.pgblk');
  if (next.length>0) {
    var nxtid=parseInt(next.children('div.pg').attr('pgid'));    
    //console.log('pgid='+pgid+' would be placed before pgid='+nxtid);
    chgPgOrder(pgid,nxtid);
  } else {
    //console.log('pgid='+pgid+' would be placed at the end');
    chgPgOrder(pgid,0);
  }      
}

function setSortable() {
  $("#topsectors").sortable( {
    placeholder: "topsecthighlight",
    forcePlaceholderSize: true ,
    //set events once dropped
    receive: function(event,ui) { newTopSectDropped(event,ui); },        
    //set events once order changed
    update: function(e,ui) { topSectOrderChanged(e,ui); }
  });  
  $(".newpgdrop").sortable( {
    placeholder: "newpgdrophl",
    //set events once order changed
    update: function(e,ui) { pageOrderChanged(e,ui); }
  } );   
}

var rightCorigin;

function openQAMenu(mitm) {
  //console.log('openQAMenu');
  //define position & width
  var mpos=$("#qamenu").offset();   
  var x=mpos.left; var y=mpos.top+$("#qamenu").height(); var w=$("#qamenu").width();
  //change arrow & highlight class
  setAllQArrowExp();  
  $("#qamenu").find(".itm_sel").removeClass('itm_sel').addClass('itm');
  mitm.removeClass('itm').addClass('itm_sel');
  //define block html
  var bid=mitm.attr('blkid');
  var blk="<div id='qablk' blkid='"+bid+"' style='top:"+y+"px;left:"+x+"px;width:"+w+"px;display:none;'>";
  //blk+=$("#"+mitm.attr('blkid')).html();
  blk+="</div>";
  if ($("#qablk").length>0) {
      closeQAMenu(function() {
        defExpandArrow(mitm);
        $("body").append(blk);
        $("#"+bid).find('div').appendTo($('#qablk'));
        $("#qablk").slideDown();        
      });
  } else {
      defExpandArrow(mitm);
      $("body").append(blk);
      $("#"+bid).find('div').appendTo($('#qablk'));
      $("#qablk").slideDown();  
  }  
}

function setAllQArrowExp() {
  $("#qamenu").find("img.arrow").css('backgroundPosition','top left').attr('alt','Expand').attr('title','Expand');
}
function defExpandArrow(mitm) {
  mitm.find("img.arrow").attr('alt','Collapse').attr('title','Collapse').css('backgroundPosition','bottom left');
}

function closeQAMenu(fn) {
  //change arrow & highlight class
  setAllQArrowExp();
  $("#qamenu").find(".itm_sel").removeClass('itm_sel').addClass('itm');
  $("#qablk").slideUp(function() {
      var pvblkid=$("#qablk").attr('blkid');
      $("#qablk").find('div').appendTo($('#'+pvblkid));
      $("#qablk").remove();
      fn();
   });
}

function setQuickAccessMenu() {
  $("#qamenu div.itm").click( function() {
    if ( $(this).find("img.arrow").attr('alt')=='Collapse') {
      closeQAMenu(function(){});
    } else {
      openQAMenu($(this));
    }
  });
}

function setTopSectorFn() {
  $("#newtopbtn").click( function() {  openNewPage(0,0); } );
}

function setNewSubPgBtn() {
  $("img.newsubpg,img.ecnewsubpg").click( function() {
    var pid=$(this).parent().attr("pgid");
    openNewPage(pid,0);
  });
}

function refreshSiteTree() {
  location.reload();
}

function setEditPage() {
  var adminmode = $("#siteadmin").attr("adminmode");  
  $(".pg span").click( function() {
   var pgid=parseInt($(this).parent().attr("pgid"));
   if($(this).attr("status")=="allow")
        goUrl(cmsroot+"PageAdmin/Index?id="+pgid);
   else alert("You are not allowed to edit the contents of this page.");  
  });
}

function setOtherPages() {
  
}

function setSiteConfigBtn() {
  $("#siteconfigbtn").click( function() {
    TINY.box.show({iframe: cmsroot+'SiteAdmin/SiteParamForm',
                    width: gAjaxFormWidth,height:200,
                    closejs: function() { }
    });    
  });
}

$(function() {
  setExpandCollapse();
  setSortable();
  setQuickAccessMenu();
  setTopSectorFn();
  setSiteConfigBtn();
  setNewSubPgBtn();
  setEditPage();
  setOtherPages();
});