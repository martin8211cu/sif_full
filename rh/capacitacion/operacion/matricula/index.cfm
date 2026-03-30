﻿<!--- VARIABLES DE TRADUCCION --->
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_RecursosHumanos"
	Default="Recursos Humanos"
	XmlFile="/rh/generales.xml"
	returnvariable="LB_RecursosHumanos"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_MatriculaAdministrativa"
	Default="Matr&iacute;cula Administrativa"
	returnvariable="LB_MatriculaAdministrativa"/>
<!--- FIN VARIABLES DE TRADUCCION --->

﻿<cf_templateheader title="#LB_RecursosHumanos#">
<cfset request.autogestion=0>
	
<script  language="JavaScript" src="/cfmx/rh/js/DHTMLMenu/stm31.js"></script>
<link href="../../../css/rh.css" rel="stylesheet" type="text/css">
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

	<cf_web_portlet_start border="true" titulo="#LB_MatriculaAdministrativa#" skin="#Session.Preferences.Skin#">
		<cfinclude template="/home/menu/pNavegacion.cfm">
		<cfif isdefined("url.sel") and len(trim(url.sel)) gt 0><cfset form.sel = url.sel></cfif>
		<cfif isdefined("url.RHRCid") and len(trim(url.RHRCid)) gt 0><cfset form.RHRCid = url.RHRCid></cfif>
		<cfif isdefined("url.DEid") and len(trim(url.DEid)) gt 0><cfset form.DEid = url.DEid></cfif>
		<cfif isdefined("url.modo") and len(trim(url.modo)) gt 0><cfset form.modo = url.modo></cfif>
		<cfif isdefined("url.Nuevo") and len(trim(url.Nuevo)) gt 0><cfset form.Nuevo = url.Nuevo></cfif>
		<cfparam name="form.sel" default="1" type="numeric">
		<cfif (form.sel gt 0) and (isdefined("form.Nuevo") or (isdefined("form.RHRCid") and len(trim(form.RHRCid)) gt 0))>
			<cfset Regresar  = "/cfmx/rh/evaluaciondes/operacion/index.cfm">
			<table width="100%"  border="0" cellspacing="0" cellpadding="0">
			  <tr>
				<td width="2%" rowspan="3">&nbsp;</td>
				<td width="74%">&nbsp;</td>
				<td width="2%">&nbsp;</td>
				<td width="20%">&nbsp;</td>
				<td width="2%" rowspan="3">&nbsp;</td>
			  </tr>
			  <tr>
				<td valign="top" align="center">
					<cfinclude template="index_header.cfm">
					<cfswitch expression="#sel#">
						<cfcase value="1"><cfinclude template="index_form.cfm"></cfcase>
						<cfcase value="2"><cfinclude template="registro_criterios_empleados.cfm"></cfcase>
						<cfcase value="3"><cfinclude template="registro_criterios_empleados_lista.cfm"></cfcase>
						<cfcase value="4"><cfinclude template="aprobacion.cfm"></cfcase>
					</cfswitch>
				</td>
				<td>&nbsp;</td>
				<td valign="top" align="center">
					<cfinclude template="index_pasos.cfm">
					<cfif isdefined("EVAL_RIGHT")>
					<br><cfoutput>#EVAL_RIGHT#</cfoutput>
					</cfif>
				</td>
			  </tr>
			  <tr>
				<td>&nbsp;</td>
			  </tr>
			</table>
		<cfelse>
			<cfset Regresar  = "/cfmx/rh/capacitacion/operacion/matricula/index.cfm">
<!--- 			<cfinclude template="index_filtro.cfm"><br>
			<cfset filtro = " and a.RHRCestado in (10,30) " & filtro> --->
			<cfinclude template="index_lista.cfm">
		</cfif>
	<cf_web_portlet_end>

<cf_templatefooter>