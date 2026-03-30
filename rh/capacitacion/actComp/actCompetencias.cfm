
<!--- VARIABLES DE TRADUCCION --->
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_ActualizacionDeCompetencias"
	Default="Actualizaci&oacute;n de Competencias"
	returnvariable="LB_ActualizacionDeCompetencias"/>	


<!--- FIN VARIABLES DE TRADUCCION --->
<cf_templateheader title="Recursos Humanos">
<cf_templatecss>
<script  language="JavaScript" src="/cfmx/rh/js/DHTMLMenu/stm31.js"></script>
<link href="../../evaluaciondes/operacion/STYLE.CSS" rel="stylesheet" type="text/css">

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
		<table width="100%" cellpadding="2" cellspacing="0">
			<tr>
				<td valign="top">
                  <cf_web_portlet_start border="true" titulo="#LB_ActualizacionDeCompetencias#" skin="#Session.Preferences.Skin#">
						<cfif isdefined("url.sel") and len(trim(url.sel)) gt 0><cfset form.sel = url.sel></cfif>
 						<cfif isdefined("url.RHRCid") and len(trim(url.RHRCid)) gt 0><cfset form.RHRCid = url.RHRCid></cfif>
						<cfif isdefined("url.DEid") and len(trim(url.DEid)) gt 0><cfset form.DEid = url.DEid></cfif>						
						<cfif isdefined("url.modo") and len(trim(url.modo)) gt 0><cfset form.modo = url.modo></cfif>
						<cfif isdefined("url.btnNuevo") and len(trim(url.btnNuevo)) gt 0><cfset form.btnNuevo = url.btnNuevo></cfif>
						
						<cfparam name="form.sel" default="1">
						
						<cfif (form.sel gt 0) and (isdefined("form.btnNuevo") or (isdefined("form.RHRCid") and len(trim(form.RHRCid)) gt 0))>
							<cfset Regresar  = "/cfmx/rh/capacitacion/actComp/actCompetencias.cfm">
							<cfinclude template="/rh/portlets/pNavegacion.cfm">
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
 									<cfinclude template="actCompetencias_header.cfm">
									<cfswitch expression="#form.sel#">
										<cfcase value="1"><cfinclude template="actCompetencias_form.cfm"></cfcase>
										<cfcase value="2"><cfinclude template="actCompe_evaluadores.cfm"></cfcase>
										<cfcase value="3"><cfinclude template="actCompe_evaluadores_lista.cfm"></cfcase>
										<cfcase value="4"><cfinclude template="actCompe_evaluadores_CF.cfm"></cfcase>
										<cfcase value="5"><cfinclude template="actCompe_empleados_lista.cfm"></cfcase>
										<cfcase value="6"><cfinclude template="actCompeFinalizar.cfm"></cfcase>
									</cfswitch> 
								</td>
								<td>&nbsp;</td>
								<td valign="top" align="center">
									<cfinclude template="actCompetencias_pasos.cfm">
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
							<cfset Regresar  = "/cfmx/rh/capacitacion/indexCapacitacion.cfm">
							<cfinclude template="/rh/portlets/pNavegacion.cfm"><br>
							 <!--- <cfinclude template="actCompetencias_filtro.cfm"><br> --->
							<cfinclude template="actCompetencias_lista.cfm">
						</cfif>
	                <cf_web_portlet_end>
				</td>	
			</tr>
		</table>	
<cf_templatefooter>