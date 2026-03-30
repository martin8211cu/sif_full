<!--- VARIABLES DE TRADUCCION --->
<cfinvoke key="LB_RecursosHumanos" default="Recursos Humanos" xmlfile="/rh/generales.xml" returnvariable="LB_RecursosHumanos" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_RegistroDeRelacionesDeEvaluacion" default="Registro de Relaciones de Evaluaci&oacute;n" returnvariable="LB_RegistroDeRelacionesDeEvaluacion" component="sif.Componentes.Translate" method="Translate"/>		
<cfinvoke key="LB_EvaluaciondelDesempeno" default="Evaluaci&oacute;n del Desempeño" returnvariable="LB_EvaluaciondelDesempeno" component="sif.Componentes.Translate" method="Translate"/>			
<!--- FIN VARIABLES DE TRADUCCION --->
<cf_templateheader title="#LB_RecursosHumanos#">
	<script  language="JavaScript" src="/cfmx/rh/js/DHTMLMenu/stm31.js"></script>
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

	  <cfinclude template="/rh/Utiles/params.cfm">
	  <cfset Session.Params.ModoDespliegue = 1>
	  <cfset Session.cache_empresarial = 0>
		<table width="100%" cellpadding="2" cellspacing="0">
			<tr>
				<td valign="top">
                  	<cf_web_portlet_start border="true" titulo="#LB_RegistroDeRelacionesDeEvaluacion#" skin="#Session.Preferences.Skin#">
						<cfinclude template="DEBUG.CFM">
						<cfset navBarItems[1]  = LB_EvaluaciondelDesempeno>
						<cfset navBarLinks[1]  = "/cfmx/rh/evaluaciondes/indexEvalDesempeno.cfm">
						<cfset navBarStatusText[1]  = LB_EvaluaciondelDesempeno>
						<cfif isdefined("url.sel") and len(trim(url.sel)) gt 0><cfset form.sel = url.sel></cfif>
				
						<cfif isdefined("url.RHEEid") and len(trim(url.RHEEid)) gt 0><cfset form.RHEEid = url.RHEEid></cfif>
						<cfif isdefined("url.DEid") and len(trim(url.DEid)) gt 0><cfset form.DEid = url.DEid></cfif>
						<cfif isdefined("url.modo") and len(trim(url.modo)) gt 0><cfset form.modo = url.modo></cfif>
						<cfif isdefined("url.Nuevo") and len(trim(url.Nuevo)) gt 0><cfset form.Nuevo = url.Nuevo></cfif>
				
						<cfparam name="form.sel" default="1" type="numeric">
						<cfif (form.sel gt 0) and (isdefined("form.Nuevo") or (isdefined("form.RHEEid") and len(trim(form.RHEEid)) gt 0))>
							<cfset Regresar  = "/cfmx/rh/evaluaciondes/operacion/registro_evaluacion.cfm">
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
                                   <!---  <cfdump var="#Form#"> --->

                                    <cfinclude template="registro_evaluacion_header.cfm">
									<cfswitch expression="#sel#">						
										<cfcase value="1"><cfinclude template="registro_evaluacion_form.cfm"></cfcase>
										<cfcase value="2"><cfinclude template="registro_criterios_empleados.cfm"></cfcase>
										<cfcase value="3"><cfinclude template="registro_criterios_empleados_lista.cfm"></cfcase>
										<cfcase value="4"><cfinclude template="registro_criterios_evaluadores.cfm"></cfcase>
										<cfcase value="5"><cfinclude template="registro_criterios_evaluadores_lista.cfm"></cfcase>
									</cfswitch>
								</td>
								<td>&nbsp;</td>
								<td valign="top" align="center">
									<cfinclude template="registro_evaluacion_pasos.cfm">
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

							<cfset Regresar  = "/cfmx/rh/evaluaciondes/indexEvalDesempeno.cfm">
							<cfinclude template="/rh/portlets/pNavegacion.cfm"><br>
							<cfinclude template="registro_evaluacion_filtro.cfm"><br>
							<cfinclude template="registro_evaluacion_lista.cfm">
						</cfif>
	                <cf_web_portlet_end>
				</td>	
			</tr>
		</table>	
<cf_templatefooter>