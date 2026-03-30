<cfcookie name = "expMedico_registrar" value = "Expediente-lista.cfm"	>	
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_RecursosHumanos"
	Default="Recursos Humanos"
	XmlFile="/rh/generales.xml"
	returnvariable="LB_RecursosHumanos"/>
<cf_templateheader title="#LB_RecursosHumanos#" template="#session.sitio.template#">

<cf_templatecss>
<link href="../css/rh.css" rel="stylesheet" type="text/css">
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
	<cfinclude template="/rh/Utiles/params.cfm">
	<cfset Session.Params.ModoDespliegue = 1>
	<cfset Session.cache_empresarial = 0>
	<table width="100%" cellpadding="2" cellspacing="0">
		<tr>
			<td valign="top">
			<!----=================== TRADUCCION ========================---->
			<cfinvoke component="sif.Componentes.TranslateDB"
				method="Translate"
				VSvalor="#session.monitoreo.SScodigo#.#session.monitoreo.SMcodigo#.#session.monitoreo.SPcodigo#"
				Default="Lista de Expedientes pendientes por Aplicar"
				VSgrupo="103"
				returnvariable="nombre_proceso"/>
	
			<cfinvoke component="sif.Componentes.Translate"
				method="Translate"
				Key="LB_Expediete_Medico"
				Default="Expediete M&eacute;dico"	
				returnvariable="LB_Expediete_Medico"/>
				
			  <cf_web_portlet_start border="true" titulo="#nombre_proceso#" skin="#Session.Preferences.Skin#">
				 <cfset navBarLinks[1] = "/cfmx/rh/expedientemng/Expediente-lista.cfm">
				 <cfset navBarItems[1] = "#LB_Expediete_Medico#">
				 <cfset navBarStatusText[1] = "#LB_Expediete_Medico#">		 
				 <cfinclude template="/rh/portlets/pNavegacion.cfm">
				 <cfinclude template="frame-listaExpedientes.cfm">
				<cf_web_portlet_end>
			</td>	
		</tr>
	</table>	
<cf_templatefooter>