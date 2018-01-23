/*
@Name:		Horizontal Multilevel Menu with WP MegaMenu Support
@Author:    Muffin Group
@WWW:       www.muffingroup.com
@Version:   2.0
*/
//browser mobile check
function isiphone() { if ((navigator.userAgent.match(/iPhone/i))) return true; else return false; }
function isipad() { if ((navigator.userAgent.match(/iPad/i))) return true; else return false; }
function isiphoneipad() { if ((navigator.userAgent.match(/iPhone/i)) || (navigator.userAgent.match(/iPad/i))) return true; else return false; }
function isios(v) {	
	var re = new RegExp("OS "+v,"i");
	if ((navigator.userAgent.match(re)) ) return true;
	else return false;
}
function isandroid() { 
	var ua = navigator.userAgent.toLowerCase();
	return (ua.indexOf("android") > -1); 
}

/*function ismobdev() { return (isipad()||isandroid()); }*/
/*function ismobdev() { return (isiphone() || isandroid()); }*/
function ismobdev() { return (isiphoneipad() || isandroid()); }

;(function($){
	$.fn.extend({
		muffingroup_menu: function(options) {
			var menu = $(this);
			
			var defaults = {
				addLast		: false,
				animation   : 'fade',	
				arrows      : false,
				delay       : 100,
				hoverClass  : 'hover'
			};
			options = $.extend(defaults, options);
			
			// .submenu --------------------------
			menu.find("li:has(ul)")
				.addClass("submenu")
				.append("<span class='menu-toggle'>") // responsive menu toggle
			;	
			
			// .mfn-megamenu-parent -------------
			menu.children("li:has(ul.mfn-megamenu)").addClass("mfn-megamenu-parent");	

			// .last-item - submenu -------------
			$(".submenu ul li:last-child", menu).addClass("last-item");
			
			// options.addLast ------------------
			if(options.addLast) {
				$("> li:last-child", menu)
					.addClass("last")
					.prev()
						.addClass("last");
			}
			
			// options.arrows -------------------
			if( options.arrows ) {
				menu.find( "li ul li:has(ul) > a" ).append( "<i class='menu-arrow icon-right-open'></i>" );
			}
			
			// .hover() -------------------------
                        // menu.find("> li, ul:not(.mfn-megamenu) li").hover(function() {
                        if(ismobdev()){
                            menu.find("> li").click(function() {
                                    $(this).stop(true,true).toggleClass(options.hoverClass);
                                    chkmobileupdown($(this));
                            });
                        }else{
                            menu.find("> li").hover(function() {
                                    $(this).stop(true,true).addClass(options.hoverClass);
                                    if (options.animation === "fade") {
                                            $(this).children("ul").stop(true,true).fadeIn(options.delay);
                                    } else if (options.animation === "toggle") {
                                            $(this).children("ul").stop(true,true).slideDown(options.delay);
                                    }
                            }, function(){
                                    $(this).stop(true,true).removeClass(options.hoverClass);
                                    if (options.animation === "fade") {
                                            $(this).children("ul").stop(true,true).fadeOut(options.delay);
                                    } else if (options.animation === "toggle") {
                                            $(this).children("ul").stop(true,true).slideUp(options.delay);
                                    }
                            });
                        }
			
                        
                        
                        function chkmobileupdown(el){
                            if($(el).hasClass("hover")){
                                   el.children("ul").stop(true,true).fadeIn(options.delay);
                                   el.children("ul").stop(true,true).slideDown(options.delay);
                               }else{
                                   el.children("ul").stop(true,true).slideUp(options.delay);
                               }
                               return null;
                        }
                        
                        
                        menu.find(".submenu > a").click(function(e){
                            // find sub-menu
                            var n = $(this).closest(".submenu").find(".menu-toggle");
                            if(n.length > 0 && n.is(":visible")){
                                e.preventDefault();
                            }
                        });
//                        $("#Top_bar #menu::before").click(function(){
//                        });
		}
	});
})(jQuery);