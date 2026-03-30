<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_RecursosHumanos"
	Default="Recursos Humanos"
	XmlFile="/rh/generales.xml"
	returnvariable="LB_RecursosHumanos"/>
<cf_templateheader title="#LB_RecursosHumanos#" template="#session.sitio.template#">

<cf_templatecss>
<link href="/cfmx/rh/css/rh.css" rel="stylesheet" type="text/css">
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
	<cfinvoke component="sif.Componentes.TranslateDB"
	method="Translate"
	VSvalor="#session.monitoreo.SScodigo#.#session.monitoreo.SMcodigo#.#session.monitoreo.SPcodigo#"
	Default="Proceso de Anulaci&oacute;n de Acciones"
	VSgrupo="103"
	returnvariable="nombre_proceso"/>

	<cfinclude template="/rh/Utiles/params.cfm">
	<cfset Session.Params.ModoDespliegue = 1>
	<cfset Session.cache_empresarial = 0>
	<table width="100%" cellpadding="2" cellspacing="0">
		<tr>
			<td valign="top">
				<cf_web_portlet_start border="true" titulo="#nombre_proceso#" skin="#Session.Preferences.Skin#">
					<cfset Regresar = "/cfmx/rh/index.cfm">
					<cfinclude template="/rh/portlets/pNavegacion.cfm">
					<cfif isdefined("Form.paso") and Form.paso EQ 3>
						<cfinclude template="AnulaAcciones-form3.cfm">
					<cfelseif isdefined("Form.paso") and Form.paso EQ 2>
						<cfinclude template="AnulaAcciones-form2.cfm">
					<cfelse>
						<cfinclude template="AnulaAcciones-form1.cfm">
					</cfif>
				<cf_web_portlet_end>
			</td>	
		</tr>
	</table>	
<cf_templatefooter>