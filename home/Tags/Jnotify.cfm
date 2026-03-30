<cfparam name="Attributes.Titulo"	 		default="" 	 			type="string">
<cfparam name="Attributes.Texto" 	 		default="" 	 			type="string">
<cfparam name="Attributes.Name"  	 		default="JNContainer"  	type="string">
<cfparam name="Attributes.Mostrar"   		default="true"  		type="boolean">
<cfparam name="Attributes.Expira"    		default="0"  			type="numeric"><!--- 0 no expira, 1 > segundos tiempo para expirar--->
<cfparam name="Attributes.Velocidad" 	    default="500"  			type="numeric">
<cfparam name="Attributes.Tipo" 	   		default="Informacion"  	type="string">
<cfparam name="Attributes.mostrarCerrar"   	default="true"  		type="boolean">

<script type="text/javascript">
	!window.jQuery && document.write('<script src="/cfmx/jquery/Core/jquery-1.6.1.js"><\/script>');
</script>

<cfif not isdefined('request.Jnotify')>
	<script src="/cfmx/jquery/librerias/jquery-ui.js" type="text/javascript"></script>
    <script src="/cfmx/jquery/librerias/jquery.notify.js" type="text/javascript"></script>
    <link href="/cfmx/jquery/estilos/notify.css" rel="stylesheet" type="text/css"/>
    <cfset request.Jnotify = true>
</cfif>
<style type="text/css">
	<cfif Attributes.Tipo eq "Informacion">
		<cfset lvarIcon = '/cfmx/jquery/imagenes/Info.png'>
		.jn_<cfoutput>#Attributes.Name#</cfoutput>{
			background-image:url(/cfmx/jquery/imagenes/degradoVerde.jpg);
		}
	</cfif>
	<cfif Attributes.Tipo eq "Alerta">
		<cfset lvarIcon = '/cfmx/jquery/imagenes/alert.png'>
		.jn_<cfoutput>#Attributes.Name#</cfoutput>{
			background-image:url(/cfmx/jquery/imagenes/degradadoRosa.jpg);
			
		}
	</cfif>
</style>
<cfset Attributes.Texto = Replace(Attributes.Texto,"'","\'","ALL")>

<cfset lvarOAuto = ''>
<cfif Attributes.Expira lte 0>
	<cfset lvarOAuto = '<a class="ui-notify-close ui-notify-cross" href="##">x</a>'>
    <cfset Attributes.Expira = false> 
</cfif>
<cfif Attributes.mostrarCerrar>
	<cfset lvarOAuto = '<a class="ui-notify-close ui-notify-cross" href="##">x</a>'>
</cfif>
<cfif isnumeric(Attributes.Expira)>
	<cfset Attributes.Expira = Attributes.Expira * 1000>
</cfif>

<cfset lvarElement = '<div style="display:none" id="jn_#Attributes.Name#" class="jn_#Attributes.Name#">#lvarOAuto#<div style="float:left;margin:0 10px 0 0"><img src="##{icon}" /></div><h1>##{title}</h1><p>##{text}</p></div>'>
<cfsavecontent variable="JnotifySC">fnCreate_Jnotify("jn_<cfoutput>#Attributes.Name#</cfoutput>", {  title : title_<cfoutput>#Attributes.Name#</cfoutput>, text : text_<cfoutput>#Attributes.Name#</cfoutput>, icon:'<cfoutput>#lvarIcon#</cfoutput>' },{expires: <cfoutput>#Attributes.Expira#</cfoutput>, speed: <cfoutput>#Attributes.Velocidad#</cfoutput>});</cfsavecontent>

<cfif isdefined('request.Jnotify')>
<div id="Jnotify"></div>
</cfif>

<script type="text/javascript">
	var title_<cfoutput>#Attributes.Name#</cfoutput> = '<cfoutput>#Attributes.Titulo#</cfoutput>';
	var text_<cfoutput>#Attributes.Name#</cfoutput> = '<cfoutput>#Attributes.Texto#</cfoutput>';
	var jn_<cfoutput>#Attributes.Name#</cfoutput>;
	$("#Jnotify").append('<cfoutput>#lvarElement#</cfoutput>');
	
	<cfif isdefined('request.Jnotify')>
	function fnCreate_Jnotify( template, vars, opts ){
		return $Jnotify.notify("create", template, vars, opts);
	}
	</cfif>
	
	function fnSetTitle_<cfoutput>#Attributes.Name#</cfoutput>(title){
		title_<cfoutput>#Attributes.Name#</cfoutput> = title;
	}
	
	function fnSetText_<cfoutput>#Attributes.Name#</cfoutput>(text){
		text_<cfoutput>#Attributes.Name#</cfoutput> = text;
	}
	
	function fnMostrar_<cfoutput>#Attributes.Name#</cfoutput>(){
		if(jn_<cfoutput>#Attributes.Name#</cfoutput>){
			jn_<cfoutput>#Attributes.Name#</cfoutput>.close();
			jn_<cfoutput>#Attributes.Name#</cfoutput> = <cfoutput>#Evaluate('JnotifySC')#</cfoutput>;
		}else
			jn_<cfoutput>#Attributes.Name#</cfoutput> = <cfoutput>#Evaluate('JnotifySC')#</cfoutput>;
	}
	
	function fnCerrarJnotify_<cfoutput>#Attributes.Name#</cfoutput>(){
		jn_<cfoutput>#Attributes.Name#</cfoutput>.close();
	}
	
	$(document).ready(function(){
		<cfif isdefined('request.Jnotify')>
		$Jnotify = $("#Jnotify").notify();
		</cfif>
		<cfif Attributes.Mostrar>
			jn_<cfoutput>#Attributes.Name#</cfoutput> = <cfoutput>#Evaluate('JnotifySC')#</cfoutput>;
		</cfif>
	});
	
</script>

<cfif not isdefined('request.Jnotify')>
    <cfset request.Jnotify = true>
</cfif>
