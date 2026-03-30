<!--- 
	EDITOR HTML
	===========

	ToolBarSet: - Default
				- Basic
				- SIF
				- Pueden crearse nuevos toolbars personalizados
	
	NOTAS: 
		i. Hay dos formas de crearlo
			1. Invocando llamados a javascript que crean el textarea
			2. Crear el text area desde aqui y asociar una funcion al evento onload del window.
			   Este dio problemas cuando se quieren crear mas de 2 campos de esta forma.
			   
		ii. No se como se le puede llegar al objeto para hacerle la validacion de no vacio, si es necesaria
			Revisar esto.

--->

<!--- Parámetros del TAG --->
<cfparam name="Attributes.name" 		default="MyTextArea" type="string" >
<cfparam name="Attributes.toolbarset" 	default="SIF" 		 type="string" >
<cfparam name="Attributes.value" 		default="" 			 type="string" >
<cfparam name="Attributes.indice" 		default="" 			 type="string" >
<cfparam name="Attributes.width"  		default="100%" 		 type="string">
<cfparam name="Attributes.height" 		default="200" 		 type="string">

<cfdump var="#Attributes#">

<cfset Attributes.value = replace(replace(Attributes.value, chr(13), ' ','all'),chr(10),'','all') >



<cfif not isdefined("Request.editorjs") >
	<cfparam name="Request.editorjs" default="true">
	<script type="text/javascript" src="/js/FCKeditor/fckeditor.js"></script>
</cfif>



<script type="text/javascript">
	<!--
	<cfoutput>
	var oFCKeditor_#Attributes.indice# = new FCKeditor( 'oFCKeditor_#attributes.name#' ) ;
	oFCKeditor_#Attributes.indice#.InstanceName	= '#attributes.name#';
	oFCKeditor_#Attributes.indice#.Value = '#JSStringFormat(attributes.value)#';
	
	oFCKeditor_#Attributes.indice#.ToolbarSet = '#attributes.toolbarset#';
	oFCKeditor_#Attributes.indice#.Width  = '#attributes.width#';
	oFCKeditor_#Attributes.indice#.Height = '#attributes.height#';

	oFCKeditor_#Attributes.indice#.Create() ;
	</cfoutput>
	//-->
</script>




