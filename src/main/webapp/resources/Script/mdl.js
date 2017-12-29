(function($){ 
	
	
	    
	$.fn.mdl=function(options, callback){     
        
        
        /*
        | ---------------------------
        | value returned for confirm and prompt
        | ---------------------------
        */
        var retour = false;
        
        
        
        /*
        | ---------------------------
        | Calcul number of items for ids & z-index
        | ---------------------------
        */
        if(	$(".mdl").length	){
        	var n = $(".mdl").length + 1;
        }else{
        	var n = 0;
        }
        
        
        
        
        /*
        | ---------------------------
        | default params
        | ---------------------------
        */
    	var defauts=
        {
		'type': "modal",		//dialog,confirm,prompt,modal
		'fullscreen': "true",		//Largeur de la galerie
		'overlayClick':"false",
		'content':''
         };  
         
         
         
         
 		/*
 		| ---------------------------
 		| //On fusionne nos deux objets ! =D
 		| ---------------------------
 		*/
        
        var parametres=$.extend(defauts, options);
		
		
		/*
		| ---------------------------
		| add overlay if is not
		| ---------------------------
		*/
		var overlay = $('<div id="mdl-overlay"></div>');
		if(!$("#mdl-overlay").length){
			$(overlay).appendTo('body');
		}
		
		
		/*
		| ---------------------------
		| global returned objects
		| ---------------------------
		*/
        return this.each(function(){
			
			//On stocke notre élément dans une variable par commodité
			var element=$(this);
			
			/*
			| ---------------------------
			| //default params
			| ---------------------------
			*/
			var fullscreen = parametres.fullscreen;
			var type = parametres.type;
			var overlayClick = parametres.overlayClick;
			
		/*
			| ---------------------------
			| or by data
			| ---------------------------
			*/
			if(
				element.attr('data-type')
			){
				type = element.data("type");
			}
			
			if(
				element.attr('data-fullscreen')
			){
				fullscreen = element.data("fullscreen");
				
			}
			
			if(
				element.attr('data-overlayClick')
			){
				overlayClick = element.data("overlayClick");
			}
			
			
			/*
			| ---------------------------
			| if modal use the modal exist else create one
			| ---------------------------
			*/
			if(type=="modal"){
			
				var cible = element.data("target");
			
			}else{
				
				/*
				| ---------------------------
				| gestion z-index
				| ---------------------------
				*/
				var zindex = 100000+n;
				
				/*
				| ---------------------------
				| addmodal
				| ---------------------------
				*/
				var mymodal = $('<div class="mdl" id="mdl__'+ n +'" style="z-index:'+ zindex +';"><div class="mdl-container"><div class="mdl-content"></div></div></div>');
				
				$(mymodal).appendTo('body');
				
				/*
				| ---------------------------
				| ok we have our id!
				| ---------------------------
				*/
				var cible = '#mdl__' + n;
			}
			
			
			/*
			| ---------------------------
			| confirm & prompt add buttons and result
			| ---------------------------
			*/
			if(type=="confirm" || type=="prompt"){
				
				/*
				| ---------------------------
				| add content
				| ---------------------------
				*/
				$(cible+" .mdl-content").html(parametres.content);
				
				if(type=="prompt"){
					$(cible+" .mdl-content").append("<input type='text' value='' id='response_mdl_"+ n +"' >");
				}
				
				/*
				| ---------------------------
				| add buttons
				| ---------------------------
				*/
				if(type=="confirm"){
					var btns = $('<ul class="mdl-buttons"><li><a href="#0" data-response="false">Non</a></li><li><a href="#0" data-response="true">Oui</a></li></ul>');
					$(btns).appendTo(cible+" .mdl-container");
				}
				
				if(type=="prompt"){
				
					var btns = $('<ul class="mdl-buttons"><li><a href="#0" data-response="false" data-id="'+ n +'">Annuler</a></li><li><a href="#0" data-response="true" data-id="'+ n +'">Valider</a></li></ul>');
					$(btns).appendTo(cible+" .mdl-container");
				}
				
				
				/*
				| ---------------------------
				| medium format
				| ---------------------------
				*/
				$(cible+" .mdl-container").addClass("medium");
				
				/*
				| ---------------------------
				| on click event return response
				| ---------------------------
				*/
				$( "body" ).on( "click",cible + " .mdl-buttons a", function(event) {
					event.preventDefault();
					var response = false;
					
					/*
					| ---------------------------
					| return true or false for confirm
					| ---------------------------
					*/
					
					response = $(this).data("response"); 

					
					/*
					| ---------------------------
					| return value of input for prompt
					| ---------------------------
					*/
					if(type=="prompt"){
						var id = $(this).data("id"); 
						response = $("#response_mdl_"+id).val(); 
					}
					
					close(cible);
					
					
					
					/*
					| ---------------------------
					| return response
					| ---------------------------
					*/
					
					if(response){
						callback.call(this, response);	
					}
					// call the callback and apply the scope:
					

				});
				
			}
			
			
			/*
			| ---------------------------
			| if fullscreen addclass fullscreen
			| ---------------------------
			*/
			if(fullscreen){		$(cible).addClass("mdl-fullscreen");	}
			
			
			/*
			| ---------------------------
			| add close button
			| ---------------------------
			*/
			$(cible).append('<div class="mdl-close" data-target="'+ cible +'"></div>');
	
			/*
			|
			| on click event add open class css
			| 
			*/ 
			element.click( function() {
				open(cible);
				
			});
			
			
			
			/*
			|
			| on click event to close button add close class css
			| 
			*/
			$( "body" ).on( "click", cible + " .mdl-close", function() {
				close(cible);
			});
			
			
			
			
			/*
			|
			| close to but by overlay click
			| 
			*/
			if(overlayClick){
				$( "body" ).on( "click","#mdl-overlay", function() {
					
					close(cible);
					
				});
			}
			

			
			
			
			
		});	
						   
		function open(cible) {
			$(cible).addClass("open");
			$("#mdl-overlay").addClass("active");
			$("#body").addClass("mdl-body");
			setTimeout(function(){ 
				$(cible).addClass("animIn");
				$("#mdl-overlay").addClass("animIn");
			}, 100);
		}
		
		/*
		|
		| close function
		| 
		*/
		function close(cible) {
		

						
						if(	$(cible).hasClass("open")	){
							
							$(cible).removeClass("animIn");
							$(cible).addClass("animOut");
							if(size()==1){
								$("#mdl-overlay").addClass("animOut");
								$("#mdl-overlay").removeClass("animIn");
							}
							
							setTimeout(function(){ 
								
								$(cible).removeClass("open");
								$(cible).removeClass("animOut");
								if(size()==0){
									$("#mdl-overlay").removeClass("animIn");
									$("#mdl-overlay").removeClass("active").removeClass("animOut");
									$("#body").removeClass("mdl-body");
								}
								
							}, 800);
						}
						
			

					
			
		}
		
		
		/*
		|
		| global size of modals
		| 
		*/
		function size() {
			return $(".mdl.open").length;
			
		}
		
		
		
		
	
	
	};
	
	
	
	
	
	
	
})(jQuery);


/*
|
| waaaw it's very ugly that !!!!  ... I dont care...it work!
| 
*/
function mdl_open(cible) {
	$(cible).addClass("open");
	$("#mdl-overlay").addClass("active");
	setTimeout(function(){ 
		$(cible).addClass("animIn");
		$("#mdl-overlay").addClass("animIn");
	}, 100);
}





function mdl_close(cible) {
	
	if( $(cible).hasClass("open")	){
		
		$(cible).removeClass("animIn");
		$(cible).addClass("animOut");
		if( $(".mdl.open").length == 0){
			$("#mdl-overlay").addClass("animOut");
		}
		
		setTimeout(function(){ 
			
			$(cible).removeClass("open");
			$(cible).removeClass("animOut");
			if( $(".mdl.open").length == 0){
				$("#mdl-overlay").removeClass("animIn");
				$("#mdl-overlay").removeClass("active").removeClass("animOut");
			}
			
		}, 800);
	}

}

/*--------------------------------------
****** MODAL *****
--------------------------------------*/


	
	
	    
	function lunch_mdl(options, callback){     
        
        
        /*
        | ---------------------------
        | value returned for confirm and prompt
        | ---------------------------
        */
        var retour = false;
        
        
        
        /*
        | ---------------------------
        | Calcul number of items for ids & z-index
        | ---------------------------
        */
        if(	$(".mdl").length	){
        	var n = $(".mdl").length + 1;
        }else{
        	var n = 0;
        }
        
        
        
        
        /*
        | ---------------------------
        | default params
        | ---------------------------
        */
    	var defauts=
        {
		'type': "modal",		//dialog,confirm,prompt,modal
		'fullscreen': "true",		//Largeur de la galerie
		'overlayClick':"false",
		'content':''
         };  
         
         
         
         
 		/*
 		| ---------------------------
 		| //On fusionne nos deux objets ! =D
 		| ---------------------------
 		*/
        
        var parametres=$.extend(defauts, options);
		
		
		/*
		| ---------------------------
		| add overlay if is not
		| ---------------------------
		*/
		var overlay = $('<div id="mdl-overlay"></div>');
		if(!$("#mdl-overlay").length){
			$(overlay).appendTo('body');
		}
		
		
		/*
		| ---------------------------
		| global returned objects
		| ---------------------------
		*/
        //return this.each(function(){
			
			//On stocke notre élément dans une variable par commodité
			//var element=$(this);
			
			/*
			| ---------------------------
			| //default params
			| ---------------------------
			*/
			var fullscreen = parametres.fullscreen;
			var type = parametres.type;
			var overlayClick = parametres.overlayClick;
			
		
			
			
			/*
			| ---------------------------
			| if modal use the modal exist else create one
			| ---------------------------
			*/
			//if(type=="modal"){
			
			//	var cible = element.data("target");
			
			//}else{
				
				/*
				| ---------------------------
				| gestion z-index
				| ---------------------------
				*/
				var zindex = 100000+n;
				
				/*
				| ---------------------------
				| addmodal
				| ---------------------------
				*/
				var mymodal = $('<div class="mdl" id="mdl__'+ n +'" style="z-index:'+ zindex +';"><div class="mdl-container"><div class="mdl-content"></div></div></div>');
				
				$(mymodal).appendTo('body');
				
				/*
				| ---------------------------
				| ok we have our id!
				| ---------------------------
				*/
				var cible = '#mdl__' + n;
			//}
			
			
			/*
			| ---------------------------
			| confirm & prompt add buttons and result
			| ---------------------------
			*/
			if(type=="confirm" || type=="prompt"){
				
				/*
				| ---------------------------
				| add content
				| ---------------------------
				*/
				$(cible+" .mdl-content").html(parametres.content);
				
				if(type=="prompt"){
					$(cible+" .mdl-content").append("<input type='text' value='' id='response_mdl_"+ n +"' >");
				}
				
				/*
				| ---------------------------
				| add buttons
				| ---------------------------
				*/
				if(type=="confirm"){
					var btns = $('<ul class="mdl-buttons"><li><a href="#0" data-response="false">Non</a></li><li><a href="#0" data-response="true">Oui</a></li></ul>');
					$(btns).appendTo(cible+" .mdl-container");
				}
				
				if(type=="prompt"){
				
					var btns = $('<ul class="mdl-buttons"><li><a href="#0" data-response="false" data-id="'+ n +'">Annuler</a></li><li><a href="#0" data-response="true" data-id="'+ n +'">Valider</a></li></ul>');
					$(btns).appendTo(cible+" .mdl-container");
				}
				
				
				/*
				| ---------------------------
				| medium format
				| ---------------------------
				*/
				$(cible+" .mdl-container").addClass("medium");
				
				/*
				| ---------------------------
				| on click event return response
				| ---------------------------
				*/
				$( "body" ).on( "click",cible + " .mdl-buttons a", function(event) {
					event.preventDefault();
					var response = false;
					
					/*
					| ---------------------------
					| return true or false for confirm
					| ---------------------------
					*/
					
					response = $(this).data("response"); 

					
					/*
					| ---------------------------
					| return value of input for prompt
					| ---------------------------
					*/
					if(type=="prompt"){
						var id = $(this).data("id"); 
						response = $("#response_mdl_"+id).val(); 
					}
					
					close(cible);
					
					
					
					/*
					| ---------------------------
					| return response
					| ---------------------------
					*/
					
					if(response){
						callback.call(this, response);	
					}
					// call the callback and apply the scope:
					

				});
				
			}
			
			
			/*
			| ---------------------------
			| if fullscreen addclass fullscreen
			| ---------------------------
			*/
			if(fullscreen){		$(cible).addClass("mdl-fullscreen");	}
			
			
			/*
			| ---------------------------
			| add close button
			| ---------------------------
			*/
			$(cible).append('<div class="mdl-close" data-target="'+ cible +'"></div>');
	
			/*
			|
			| on click event add open class css
			| 
			*/ 
			//element.click( function() {
				open(cible);
				
			//});
			
			
			
			/*
			|
			| on click event to close button add close class css
			| 
			*/
			$( "body" ).on( "click", cible + " .mdl-close", function() {
				close(cible);
			});
			
			
			
			
			/*
			|
			| close to but by overlay click
			| 
			*/
			if(overlayClick){
				$( "body" ).on( "click","#mdl-overlay", function() {
					
					close(cible);
					
				});
			}
			

			
			
			
			
		//});	
						   
		function open(cible) {
			$(cible).addClass("open");
			$("#mdl-overlay").addClass("active");
			setTimeout(function(){ 
				$(cible).addClass("animIn");
				$("#mdl-overlay").addClass("animIn");
			}, 100);
		}
		
		/*
		|
		| close function
		| 
		*/
		function close(cible) {
		

						
						if(	$(cible).hasClass("open")	){
							
							$(cible).removeClass("animIn");
							$(cible).addClass("animOut");
							if(size()==1){
								$("#mdl-overlay").addClass("animOut");
								$("#mdl-overlay").removeClass("animIn");
							}
							
							setTimeout(function(){ 
								
								$(cible).removeClass("open");
								$(cible).removeClass("animOut");
								if(size()==0){
									$("#mdl-overlay").removeClass("animIn");
									$("#mdl-overlay").removeClass("active").removeClass("animOut");
								}
								
							}, 800);
						}
						
			

					
			
		}
		
		
		/*
		|
		| global size of modals
		| 
		*/
		function size() {
			return $(".mdl.open").length;
			
		}
		
		
		
		
	
	
};

