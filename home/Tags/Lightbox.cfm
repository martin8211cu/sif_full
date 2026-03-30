<cfif ThisTag.ExecutionMode is 'start'>

    <cfparam name="Attributes.name"   			default="lightBoxID">
    <cfparam name="Attributes.width"  		   	default="70"><!---Ancho del lightBox, esta dada en porcentaje, maximo valor 100--->
    <cfparam name="Attributes.height" 		   	default="90"><!---Alto del lightBox, esta dada en porcentaje, maximo valor 100--->
    <cfparam name="Attributes.Titulo" 		   	default="">
    <cfparam name="Attributes.link"   		   	default="open">
    <cfparam name="Attributes.titlePosition"   	default="outside"><!---Posibles valores outside,inside--->
    <cfparam name="Attributes.transition"      	default="elastic"><!---elastic, none, fade--->
    <cfparam name="Attributes.overlayShow"     	default="true">
    <cfparam name="Attributes.autoScale"       	default="false"> 
    <cfparam name="Attributes.opacity"       	default="true"> 
    <cfparam name="Attributes.overlayOpacity"   default="0.5"> 
    <cfparam name="Attributes.padding"       	default="0"> 
    <cfparam name="Attributes.FnonStart"        default=""><!---Funcion a ejecutar antes de abrir el lightBox (return window.confirm('Abrir el pop-up?');)---> 
    <cfparam name="Attributes.FnonCancel"       default=""><!---Funcion a ejecutar al cancelar la apertura del lightBox(alert('Canceled!');)---> 
    <cfparam name="Attributes.FnonComplete"     default=""><!---Funcion a ejecutar despues de abrir el lightBox(alert('Completed!');)---> 
    <cfparam name="Attributes.FnonCleanup"      default=""><!---Funcion a ejecutar antes de cerrar el lightBox (return window.confirm('Close?');)---> 
    <cfparam name="Attributes.FnonClosed"       default=""><!---Funcion a ejecutar despues de cerrar el lightBox(alert('Closed!');)--->    
    <cfparam name="Attributes.url"       		default="">
   
</cfif>

<cfif ThisTag.ExecutionMode is 'end'>
	<cfset ThisTag.Contenido        = ThisTag.GeneratedContent/>
    <cfset ThisTag.GeneratedContent = "" />
	<script>
		!window.jQuery && document.write('<script src="/cfmx/jquery/Core/jquery-1.6.js"><\/script>');
	</script>
    <cfif not isdefined ('request.mousewheel')>
    	<script type="text/javascript" src="/cfmx/jquery/librerias/jquery.mousewheel-3.0.4.pack.js"></script>
        <cfset request.mousewheel =true>
    </cfif>
      <cfif not isdefined ('request.fancybox')>
    	<script type="text/javascript" src="/cfmx/jquery/librerias/jquery.fancybox-1.3.4.pack.js"></script>
        <cfset request.fancybox =true>
    </cfif>
    <cfif not isdefined ('request.styleligthbox')>
    	<link rel="stylesheet" type="text/css" href="/cfmx/jquery/estilos/lightbox.css" />
    	<cfset request.styleligthbox =true>
    </cfif>
	<script type="text/javascript">
		$(document).ready(function() {
			$("#<cfoutput>#Attributes.name#</cfoutput>").fancybox({
				'width'				: '<cfoutput>#Attributes.width#</cfoutput>%',
				'height'			: '<cfoutput>#Attributes.height#</cfoutput>%',
				'autoScale'			:  <cfoutput>#Attributes.overlayShow#</cfoutput>,
				'transitionIn'		: '<cfoutput>#Attributes.transition#</cfoutput>', 
				'transitionOut'		: '<cfoutput>#Attributes.transition#</cfoutput>',
				'titlePosition'		: '<cfoutput>#Attributes.titlePosition#</cfoutput>',
				'overlayShow'	    :  <cfoutput>#Attributes.overlayShow#</cfoutput>,
				'opacity'		    :  <cfoutput>#Attributes.opacity#</cfoutput>,
				'overlayOpacity'	:  <cfoutput>#Attributes.overlayOpacity#</cfoutput>,
				'overlayColor'		:  '#000',
				'scrolling' :'auto',
				'padding'			:  <cfoutput>#Attributes.padding#</cfoutput>
				<cfif len(trim(Attributes.url))>
				,'type'				:  'iframe'
				</cfif> 
			});
		});
		
		function fnLightBoxClose_<cfoutput>#Attributes.name#</cfoutput>(){
			$.fancybox.close();
		}
		
		<cfif len(trim(Attributes.url))>
		function fnLightBoxSetURL_<cfoutput>#Attributes.name#</cfoutput>(url){
			obj = document.getElementById("<cfoutput>#Attributes.name#</cfoutput>");
			obj.href = url;
		}
		function fnLightBoxOpen_<cfoutput>#Attributes.name#</cfoutput>(){
			$("#<cfoutput>#Attributes.name#</cfoutput>").click();
		}
		<cfelse>
		function fnLightBoxOpen_<cfoutput>#Attributes.name#</cfoutput>(id){
			obj = document.getElementById("<cfoutput>#Attributes.name#</cfoutput>");
			if("<cfoutput>#Attributes.url#</cfoutput>".indexOf("?") > 0)
				obj.href = "<cfoutput>#Attributes.url#</cfoutput>&id="+id;
			else
				obj.href = "<cfoutput>#Attributes.url#</cfoutput>?id="+id;
			$("#<cfoutput>#Attributes.name#</cfoutput>").click();
		}
		</cfif>
	</script>
    <a id="<cfoutput>#Attributes.name#</cfoutput>" href="<cfoutput><cfif len(trim(Attributes.url))>#Attributes.url#<cfelse>##lightBoxhref#Attributes.name#</cfif></cfoutput>"><cfoutput>#Attributes.link#</cfoutput></a>
    <cfif not len(trim(Attributes.url))>
        <div style="display: none;">
            
            <div id="lightBoxhref<cfoutput>#Attributes.name#</cfoutput>" style="width:800px;overflow:auto;">
            <h1 id="h1_ligthBox"><cfoutput>#Attributes.Titulo#</cfoutput></h1>
                <cfoutput>#ThisTag.Contenido#</cfoutput>
            </div>
        </div>
    </cfif>
</cfif>