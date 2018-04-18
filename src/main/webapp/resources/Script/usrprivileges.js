function setPvBtns() {
	rolestr="";
	$(".rolebtn").click( function() {
		if(issa()!=-1)
			alert("Super administrator has all right. You cannot remove right from super administrator");
		else{
			var imgid =$(this).attr("class");
			var imgr = imgid.substr(imgid.indexOf('_')-2,2);
			switch (imgr) {
				case "pb":
				if ($(this).hasClass('pb_inactive'))   
					recursiveActive($(this),imgr);
				else{										
					if($(this).closest('div').parent().hasClass('topsect')){
						recursiveInactive($(this),imgr);
					} else if($(this).closest('div').parent().hasClass('fullsect')){
						$(this).removeClass('pb_active'); 
						$(this).addClass('pb_inactive'); 
						setPgRole(imgr,$(this),"off");
					}
					else{
						if($(this).closest('.topsect').parent().attr("id")=='topsectors')
						{
							setAllInactive($(this),"topsect",imgr);
						} else if($(this).closest('.fullsect').attr("id")=='btmmenu' || $(this).closest('.fullsect').attr("id")=='othmenu')
						{
							setAllInactive($(this),"fullsect",imgr);
						} else {
							$(this).removeClass('pb_active'); 
							$(this).addClass('pb_inactive'); 
							setPgRole(imgr,$(this),"off");
						}
					}
					
				}
				break;
				case "ed":
				if ($(this).hasClass('ed_inactive'))
					recursiveActive($(this),imgr);
				else{										
					if($(this).closest('div').parent().hasClass('topsect')){
						recursiveInactive($(this),imgr);
					} else if($(this).closest('div').parent().hasClass('fullsect')){
						$(this).removeClass('ed_active'); 
						$(this).addClass('ed_inactive'); 
						setPgRole(imgr,$(this),"off");
					} else{
						if($(this).closest('.topsect').parent().attr("id")=='topsectors')
							setAllInactive($(this),"topsect",imgr)
						else if($(this).closest('.fullsect').attr("id")=='btmmenu' || $(this).closest('.fullsect').attr("id")=='othmenu')
							setAllInactive($(this),"fullsect",imgr)
						else {
							$(this).removeClass('ed_active'); 
							$(this).addClass('ed_inactive'); 
							setPgRole(imgr,$(this),"off");
						}
					}
					
				}
				break;
			}            
		}
	});
}
function setAllInactive(imgid,parentclass,imgr){
	if(imgid.closest('div').parent().hasClass("p3"))
	{
		if(imgid.closest('.p2').children(0).find('img').hasClass(imgr+'_inactive')){
		   imgid.removeClass(imgr+'_active'); 
		   imgid.addClass(imgr+'_inactive'); 
		   setPgRole(imgr,imgid,"off");
		} 
		else
		   alert("User has right inherited from the parent page.  You cannot remove the right.");
	}
	else if(imgid.closest('".'+parentclass+'"').children(0).find('img').hasClass(imgr+'_inactive')){
	   imgid.removeClass(imgr+'_active'); 
	   imgid.addClass(imgr+'_inactive'); 
	   setPgRole(imgr,imgid,"off");
	} 
	else
	   alert("User has right inherited from the parent page.  You cannot remove the right.");
}


function getParameterByName(name) {
    name = name.replace(/[\[]/, "\\\[").replace(/[\]]/, "\\\]");
    var regex = new RegExp("[\\?&]" + name + "=([^&#]*)"),
        results = regex.exec(location.search);
    return results == null ? "" : decodeURIComponent(results[1].replace(/\+/g, " "));
}
function recursiveActive(imgid,imgr){
	imgid.removeClass(imgr+'_inactive'); 
	imgid.addClass(imgr+'_active'); 
	imgid.closest('div').parent().children().find('.'+imgr+'_inactive').each( function () {
		$(this).removeClass(imgr+'_inactive'); 
		$(this).addClass(imgr+'_active'); 
		setPgRole(imgr,$(this),"on");
	});        
	setPgRole(imgr,imgid,"on");
}

function recursiveInactive(imgid,imgr){
	imgid.removeClass(imgr+'_active'); 
	imgid.addClass(imgr+'_inactive'); 
	imgid.closest('div').parent().children().find('.'+imgr+'_active').each( function () {
		$(this).removeClass(imgr+'_active'); 
		$(this).addClass(imgr+'_inactive'); 
		setPgRole(imgr,$(this),"off");
	});        
	setPgRole(imgr,imgid,"off");
}

function setPgRole(imgr,imgid,onoff){
	var pvalue = getParameterByName("usr");
	pgid=imgid.parent().attr("pgid");
	$.post(cmsroot+"Account/setUserPgRight", { "usrid":pvalue,"pageid":pgid,"role":imgr,"onoff":onoff},
	function(data){
		//console.log(data); // John
	}, "json");

}

function setallactive() {
	var id_sa=issa()
	if (id_sa!=-1) {
		$(".rolebtn").each( function() { 
			if ($(this).hasClass('ed_inactive'))
			{
				$(this).removeClass('ed_inactive');
				$(this).addClass('ed_active');
			}
		});
		$(".rolebtn").each( function() { 
			if ($(this).hasClass('pb_inactive'))
			{
				$(this).removeClass('pb_inactive');
				$(this).addClass('pb_active');
			}
		
	});
}
}

function issa() { return $(document.getElementById("siteadmin")).attr("roles").indexOf("sa"); }

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

function refreshSiteTree() {
  location.reload();
}

$(function() {
  setExpandCollapse();
  setPvBtns();
  setallactive();
});