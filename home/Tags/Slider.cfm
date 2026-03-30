<cfparam name="Attributes.URLMenu" 	default=""     type="string">
<cfparam name="Attributes.width" 	default="200"  type="numeric">
<cfparam name="Attributes.top" 		default="20"   type="numeric">

<script type="text/javascript">

$(document).ready(function(){
						   
$(".overlay").css("height", $(document).height()).hide();

$(".menu-vert-Payroll").click(function(){
		$(".panel").toggle("fast");
		$(".overlay").fadeToggle("normal", "linear");
		$(this).toggleClass("active");
		return false;
		
	});
	
$(".overlay").click(function(){
		$(".panel").toggle("fast");
		$(".overlay").fadeToggle("normal", "linear");
		return false;
		
	});	
	
$(".triggerbigger").click(function(){
		$(".panelbigger").toggle("fast");
		$(this).toggleClass("active");
return false;
	});	
	
$(".tabla-header-right-arrow").click(function(){	
		$(".tabla-content").fadeToggle("normal", "linear");;
		$(this).toggleClass("active");

	});	
	
});

    $(document).ready(function() {  
        $('input[type="text"]').addClass("idleField");  
        $('input[type="text"]').focus(function() {  
            $(this).removeClass("idleField").addClass("focusField");  
            if (this.value == this.defaultValue){  
                this.value = '';  
            }  
            if(this.value != this.defaultValue){  
                this.select();  
            }  
        });  
        $('input[type="text"]').blur(function() {  
            $(this).removeClass("focusField").addClass("idleField");  
            if ($.trim(this.value == '')){  
                this.value = (this.defaultValue ? this.defaultValue : '');  
            }  
        });  
    });  

 
</script>

<body>

<div class="overlay"></div>
	<a href="#" class="menu-vert-Payroll"></a>
<div class="panel">
    	<cfinclude template="#Attributes.URLMenu#">
</div>