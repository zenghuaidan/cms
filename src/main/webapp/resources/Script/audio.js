$(function(){
	var nowplayad;
	$(".audio-btn").each(function(){
		var _this = $(this);
		_this.click(function(){
			$(".audio-btn.pm").not($(this)).removeClass("pm");
			$(this).toggleClass("pm");
			var tf = $(this).hasClass("pm") ? true : false;
			playAd($(this).attr('data-audio'),tf);
		});
	});
	function playAd(mysrc,tf){
		if(!($(nowplayad).length > 0)){
			nowplayad = new Audio();
		}
		if(tf){
			if(nowplayad.paused){
				$(nowplayad).attr("src","");
			}
			$(nowplayad).attr("src",mysrc);
			nowplayad.load();
			nowplayad.play();
		}else{
			if(!(nowplayad.paused)){
				nowplayad.pause();
			}
		}
		
	}
});

