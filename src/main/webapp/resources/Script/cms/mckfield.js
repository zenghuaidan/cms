function mck2val(td) {
	var v = $("#"+td.attr('fid'));
	var s = ""; var p=";";
	td.find("input[type=checkbox]").each( function() {
		if ($(this).is(":checked")) {
			if (s.length>0) s+=p;
			s+=$(this).val();
		}
	});
	v.val(s);
}

function val2mck(td) {
	var p = ";";
	var a = p+$("#"+td.attr('fid')).val()+p;
	td.find("input[type=checkbox]").each( function() {
		var b = (a.indexOf(p+$(this).val()+p)>=0)?true:false;
		$(this).attr('checked',b);
		$(this).attr('disabled',false);		
	});
}

function initmck() {	
	$("td.mckfield input[type=checkbox]").change(function() {
		mck2val($(this).closest("td.mckfield"));
	});	
	$("td.mckfield").each(function() {
		val2mck($(this));
	});
}

$(document).ready( function() {
	initmck();
});