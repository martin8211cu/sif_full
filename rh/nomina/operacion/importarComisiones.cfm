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
<!----=========== TRADUCCION ==========---->
<!---Boton regresar ---->
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="BTN_Regresar"
	Default="Regresar"
	XmlFile="/rh/generales.xml"
	returnvariable="BTN_Regresar"/>

	<cfinclude template="/rh/Utiles/params.cfm">
	<cfset Session.Params.ModoDespliegue = 1>
	<cfset Session.cache_empresarial = 0>

	<table width="100%" cellpadding="2" cellspacing="0">
		<tr>
			<td valign="top">
				<cfinvoke component="sif.Componentes.TranslateDB"
					method="Translate"
					VSvalor="#session.monitoreo.SScodigo#.#session.monitoreo.SMcodigo#.#session.monitoreo.SPcodigo#"
					Default="Importar Comisiones"
					VSgrupo="103"
					returnvariable="nombre_proceso"/>                 
				<cf_web_portlet_start border="true" titulo="#nombre_proceso#" skin="#Session.Preferences.Skin#">
					<table width="100%"  border="0" cellspacing="0" cellpadding="0" align="center">
						<tr><td colspan="3" align="center">
							<cfset regresar = '/cfmx/rh/nomina/operacion/ResultadoCalculo-comisiones.cfm?CPid=#form.CPid#' >
							<cfinclude template="/rh/portlets/pNavegacion.cfm">
						</td></tr>
						<tr><td colspan="3" align="center">&nbsp;</td></tr>
						<tr>
							<td align="center" width="2%">&nbsp;</td>
							<td align="center" valign="top" width="60%">
								<cfquery name="rs" datasource="#session.DSN#">
									select Pvalor
									from RHParametros
									where Ecodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
									  and Pcodigo=370
								</cfquery>
								<cf_sifFormatoArchivoImpr EIcodigo = "#trim(rs.Pvalor)#">
							</td>
							<td align="center" style="padding-left: 15px " valign="top">
								<cfif rs.RecordCount gt 0 and len(trim(rs.Pvalor))>
									<cf_sifimportar EIcodigo="#trim(rs.Pvalor)#" mode="in" />
								<cfelse>
									<cf_translate key="No_se_ha_definido_el_Script_de_Importacion_de_Comisiones_en_Parametros_Generales">
										No se ha definido el Script de Importaci&oacute;n de Comisiones en Par&aacute;metros Generales.
									</cf_translate>
								</cfif>
							</td>
						</tr>
						<tr><td colspan="3" align="center"><input type="button" name="Regresar" value="<cfoutput>#BTN_Regresar#</cfoutput>" onClick="javascript:location.href='ResultadoCalculo-comisiones.cfm?CPid=<cfoutput>#form.CPid#</cfoutput>'"></td></tr>
						<tr><td colspan="3" align="center">&nbsp;</td></tr>
					</table>
				<cf_web_portlet_end>
			</td>	
		</tr>
	</table>	
<cf_templatefooter>