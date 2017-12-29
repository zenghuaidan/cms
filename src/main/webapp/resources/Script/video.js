$(function(){
	$(".play-lay").click(function(){
		if($(".pl-overlay").length == 0){
			var overlay = $("<div class='pl-overlay'></div>");
			var video = $("<div class='pl-video'></div>");
			var close = $("<div class='pl-close'></div>");
			overlay.append(video);
			overlay.append(close);
			$("#body").append(overlay);
			close.click(function(){
				$("#body").removeClass("play-video");
				video.html("");
			});
		}
		
		
		
		var datasrc = $(this).attr("data-src");
		var datasource = $(this).attr("data-source");
		var videosrc = "";
		var obj = "";
		if(datasource == "youtube"){
			obj = $('</object><iframe class="obj" width="720" frameborder="0" allowfullscreen></iframe>');
			videosrc = "https://www.youtube.com/embed/"+datasrc+"?rel=0&hd=1&enablejsapi=1&showinfo=0&autoplay=1&wmode=opaque";
			obj.attr("src",videosrc);
		}else if(datasource == "youku"){
			obj = $("<object class='obj' width='720' data=''></object>");
			videosrc = "http://player.youku.com/embed/"+datasrc+"?autoplay=1&allowfullscreen=1&wmode=opaque";
			obj.attr("data",videosrc);
		}else if(datasource == "qqtv"){
			obj = $("<object class='obj' width='720' data=''></object>");
			if(navigator.userAgent.search("Firefox") > -1){
				videosrc = "http://static.video.qq.com/TPout.swf?vid="+datasrc+"&autoplay=1&allowfullscreen=1&wmode=opaque&amp;auto=0";
			}else{
				videosrc = "http://v.qq.com/iframe/player.html?vid="+datasrc+"&autoplay=1&allowfullscreen=1&wmode=opaque";
			}
			obj.attr("data",videosrc);
		}
		var ht = datasource == "qqtv" ? 450 : 405;
		$("#body .pl-overlay .obj").attr("height",ht)
		$("#body .pl-overlay .pl-video").append(obj);
		$("#body").addClass("play-video");
	});
});