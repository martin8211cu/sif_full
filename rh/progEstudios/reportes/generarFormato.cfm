<cf_templateheader title="Generar Certificaciones">
	<cfset CurrentPage=GetFileFromPath(GetTemplatePath())>
<cfsavecontent variable="pNavegacion">
	<cfinclude template="/rh/portlets/pNavegacion.cfm">
</cfsavecontent>
<cfinvoke component="sif.Componentes.Translate" 
	method="Translate" 
	Key="LB_titulo" 
	Default="Generación de Certificaciones" 
	returnvariable="LB_titulo"/>
	<script language="JavaScript" type="text/JavaScript">
		<!--
			function MM_reloadPage(init) {  //reloads the window if Nav4 resized
			  if (init==true) with (navigator) {if ((appName=="Netscape")&&(parseInt(appVersion)==4)) {
				document.MM_pgW=innerWidth; document.MM_pgH=innerHeight; onresize=MM_reloadPage; }}
			  else if (innerWidth!=document.MM_pgW || innerHeight!=document.MM_pgH) location.reload();
			}
			MM_reloadPage(true);
		//-->
	</script>
	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		Key="LB_RecursosHumanos"
		Default="Recursos Humanos"
		XmlFile="/rh/generales.xml"
		returnvariable="LB_RecursosHumanos"/>
		

		<cf_web_portlet_start titulo="<cfoutput>#LB_titulo#</cfoutput>">
			<cfoutput>#pNavegacion#</cfoutput>
			<cfinclude template="/rh/Utiles/params.cfm">
			<cfset Session.Params.ModoDespliegue = 1>
			<cfset Session.cache_empresarial = 0>
			<cfif isdefined("form.btnNuevo")>
				<cfinclude template="generarFormato-form.cfm">
			<cfelse>
				<cfinclude template="generarFormato-lista.cfm">
			</cfif>
		<cf_web_portlet_end>
	<cf_templatefooter>