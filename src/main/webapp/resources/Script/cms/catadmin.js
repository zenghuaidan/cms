function closecat() { TINY.box.hide(); }

function clearcat() {
	$("#catfm input[type=text]").val("");
}

function newcat() {
    var htm="<form id='catfm' method='post'>";
	htm+="<input type='hidden' name='id' value='' />";
    htm+=$("#layerpool .catform").html()+"</form>";
    TINY.box.show({ html: htm, openjs: function() { clearcat();  } });
}

function editcat(cid) {
	var c = $("#cat-"+cid);	
    var htm="<form id='catfm' method='post'>";
	htm+="<input type='hidden' name='id' value='"+cid+"' />";
    htm+=$("#layerpool .catform").html()+"</form>";
    TINY.box.show({ html: htm, openjs: function() { 
		var fm = $("#catfm");
		clearcat();  
		fm.find("input[name=nameEN]").val(c.attr('name_en'));
		fm.find("input[name=nameTC]").val(c.attr('name_tc'));
		//fm.find("input[name=kind]").val(c.attr('kind'));
	} });	
}

function delcat(cid) {
	
	if (confirm("You are going to delete a category that cannot be rollback. Do you want to continue?")) {
		var u = cmsroot+"CategoryAdmin/Delete";
		$.post(u,{"id":cid},function(data) {
		  if (data.success) {
			location.reload(); 
		  } else alert(data.errorMsg);
		},"json");	
	}
}

function submitcat() {
	var fm = $("#catfm");
	var u = cmsroot+"CategoryAdmin/Save";
    $.post(u,fm.serialize(),function(data) {
      if (data.success) {
		location.reload(); 
      } else alert(data.errorMsg);
    },"json");	
}

//Ordering
function chgCatOrder(catid,beforeid) {
	var c = $("#catlist");
	var u = cmsroot+"CategoryAdmin/ChgOrder";
	//console.log('u='+u);
 
	$.post(u,{"id":catid,"beforeId":beforeid},function(data) {
	  if (data.success) {
		location.reload(); 
	  } else alert(data.errorMsg);
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
