function defineConfigYearField() {
	$(".yearfield .yv").each( function() {
		var yv = $(this);
		var yid = yv.attr('yid');		
		$("#"+yid).change( function() {
			yv.val($(this).val()+"-01-01");
		});
	});
}

/* App Specific */
function setAlbumIdxChild() {
	var t = $("#template").val();
	var y = $(".yearfield");
	var l = y.prev(".editor-label");
	if (t=="YearAlbum") {
		l.show(); y.show();
		$("#pgtimei").val($("#pgtimeiy").val()+"-01-01");
	} else { //general
		l.hide(); y.hide();
		$("#pgtimei").val('1970-01-01');
	}
}

function defineAlbumIdxChild() {
	if (parentemplate == "AlbumIndex") {
		$("#template").change( function() {
			setAlbumIdxChild();
		});
		setAlbumIdxChild();
	}
}

/* Page Loaded */
$(function() {
	defineConfigYearField();
	defineAlbumIdxChild();
});