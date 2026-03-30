<cfif isdefined("url.regresar") and len(trim(url.regresar)) GT 0>
	<cfset session.indexReportes.regresar = url.regresar>
</cfif>
<cfif isdefined("session.indexReportes.regresar") and len(trim(session.indexReportes.regresar)) GT 0>
	<cfset request.regresar = session.indexReportes.regresar>
</cfif>

<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_RecursosHumanos"
	Default="Recursos Humanos"
	returnvariable="LB_RecursosHumanos"/>
<cf_templateheader title="#LB_RecursosHumanos#">
	<script  language="JavaScript" src="/cfmx/rh/js/DHTMLMenu/stm31.js"></script>	

<cf_templatecss>
<link href="css/rh.css" rel="stylesheet" type="text/css">
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
					<cfparam name="Session.modulo" default="index">
					<cfparam name="Session.Idioma" default="">
					<cfif isdefined("Form.Idioma")>
						<cfset Session.Idioma = Form.idioma>
					</cfif>
					<cfset Session.modulo = 'index'>
					
					<cfif isdefined("Url.RCNid") and not isdefined("Form.RCNid")>
						<cfparam name="Form.RCNid" default="#Url.RCNid#">
					</cfif>
					<cfif isdefined("Url.nombreFiltro") and not isdefined("Form.nombreFiltro")>
						<cfparam name="Form.nombreFiltro" default="#Url.nombreFiltro#">
					</cfif>
					<cfif isdefined("Url.DEidentificacionFiltro") and not isdefined("Form.DEidentificacionFiltro")>
						<cfparam name="Form.DEidentificacionFiltro" default="#Url.DEidentificacionFiltro#">
					</cfif>		
					<cfif isdefined("Url.fSEcalculado") and not isdefined("form.fSEcalculado")>
						<cfparam name="form.fSEcalculado" default="#Url.fSEcalculado#">
					</cfif>		
					<cfif isdefined("Url.filtrado") and not isdefined("Form.filtrado")>
						<cfparam name="Form.filtrado" default="#Url.filtrado#">
					</cfif>	
					<cfif isdefined("Url.DEid") and not isdefined("Form.DEid")>
						<cfparam name="Form.DEid" default="#Url.DEid#">
					</cfif>
					<cfif isdefined("Url.sel") and not isdefined("Form.sel")>
						<cfparam name="Form.sel" default="#Url.sel#">
					</cfif>
					<cfif isdefined("Url.fecha") and not isdefined("Form.fecha")>
						<cfparam name="Form.fecha" default="#Url.fecha#">
					</cfif>
					<cfif isdefined("Url.Tcodigo") and not isdefined("Form.Tcodigo")>
						<cfparam name="Form.Tcodigo" default="#Url.Tcodigo#">
					</cfif>	
					<cfinvoke component="sif.Componentes.TranslateDB"
						method="Translate"
						VSvalor="#session.monitoreo.SScodigo#.#session.monitoreo.SMcodigo#.#session.monitoreo.SPcodigo#"
						Default="Reportes de Relación de Cálculo de Nómina"
						VSgrupo="103"
						returnvariable="nombre_proceso"/>
				
					  <cf_web_portlet_start titulo="#nombre_proceso#">
						<cfinclude template="/rh/indexReportescont.cfm">
					  <cf_web_portlet_end>
				</td>	
			</tr>
		</table>	
<cf_templatefooter>