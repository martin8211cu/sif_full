$(document).ready(function () {
    $("#demo2 li").hoverIntent( makeTall, makeShort )	
	  jQuery("ul.user-btn").hoverIntent({
				over: makeTall, 
				timeout: 150, 
				out: makeShort
			});	
});		  
  
function makeTall(){   jQuery('ul.the_menu').slideDown("fast");}
function makeShort(){  jQuery('ul.the_menu').slideUp("fast");}
	

$(document).ready(function() {
						   
			 
						   
		$(".topMenuAction").click( function() {
											
											
			if ($("#openCloseIdentifier").is(":hidden")) {
				
				$("#slider").animate({ marginTop: "-130px"}, 500 );
				
				$("#topMenuImage").html('<img src="images/open-menu.png" alt="open" />');
				$("#openCloseIdentifier").show();
			} else {
				$("#slider").animate({ 
					marginTop: "-50px"
					}, 500 );
				$("#topMenuImage").html('<img src="images/close-menu.png" alt="close" />');
				$("#openCloseIdentifier").hide();
			}
		});  
	});