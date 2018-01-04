function defineConfigYearField() {
	$(".yearfield .yv").each( function() {
		var yv = $(this);
		var yid = yv.attr('yid');		
		$("#"+yid).change( function() {
			yv.val($(this).val()+"-01-01");
		});
	});
}

/* Page Loaded */
$(function() {
	defineConfigYearField();
});