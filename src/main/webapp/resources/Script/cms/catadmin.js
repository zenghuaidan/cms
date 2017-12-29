function closecat() { TINY.box.hide(); }

function clearcat() {
	$("#catfm input[type=text]").val("");
}

function newcat() {
    var htm="<form id='catfm' method='post'>";
	htm+="<input type='hidden' name='catid' value='' />";
    htm+=$("#layerpool .catform").html()+"</form>";
    TINY.box.show({ html: htm, openjs: function() { clearcat();  } });
}

function editcat(cid) {
	var c = $("#cat-"+cid);	
    var htm="<form id='catfm' method='post'>";
	htm+="<input type='hidden' name='catid' value='"+cid+"' />";
    htm+=$("#layerpool .catform").html()+"</form>";
    TINY.box.show({ html: htm, openjs: function() { 
		var fm = $("#catfm");
		clearcat();  
		fm.find("input[name=name_en]").val(c.attr('name_en'));
		fm.find("input[name=name_tc]").val(c.attr('name_tc'));
		fm.find("input[name=name_sc]").val(c.attr('name_sc'));
	} });	
}

function delcat(cid) {
	
	if (confirm("You are going to delete a category that cannot be rollback. Do you want to continue?")) {
		var pms = ""; //"?catid="+cid
		var u = cmsroot+"/CategoryAdmin/Delete"+pms;
		$.post(u,{"catid":cid},function(data) {
		  if (data.Success=="True") {
			location.reload(); 
		  } else alert(data.Message);
		},"json");	
	}
}

function submitcat() {
	var fm = $("#catfm");
	var pms = ""; //"?catid="+pgid+"&lang="+lang+"&xid="+xid;
	var u = cmsroot+"/CategoryAdmin/Save"+pms;
	//fm.attr("action",u);	
    $.post(u,fm.serialize(),function(data) {
      if (data.Success=="True") {
		location.reload(); 
      } else alert(data.Message);
    },"json");	
}

//Ordering
function chgCatOrder(catid,beforeid) {
	var c = $("#catlist");
	var pms = ""; //?catid=catid&beforeid=beforeid
	var u = cmsroot+"/CategoryAdmin/ChgOrder"+pms;
	//console.log('u='+u);
 
	$.post(u,{"catid":catid,"beforeid":beforeid,"kind":c.attr('kind'),"pid":c.attr('parentid')},function(data) {
	  if (data.Success=="True") {
		location.reload(); 
	  } else alert(data.Message);
	},"json");	  
}	

function orderchg(e,ui) {
	var catid=parseInt(ui.item.attr('catid'));
	var next=ui.item.next('div.cat');
	if (next.length>0) {
		var nxtid=parseInt(next.attr('catid'));    
		//console.log('catid='+catid+' would be placed before catid='+nxtid);
		chgCatOrder(catid,nxtid);
	} else {
		//console.log('catid='+catid+' would be placed at the end');
		chgCatOrder(catid,0);
	}   		
}

//Page Loaded
$(function() {
	$("#catlist").sortable( {
		//set events once order changed
		update: function(e,ui) { orderchg(e,ui); }
	} );	
});
