<!--- <cfdump var="#Form#"> --->
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_RecursosHumanos"
	Default="Recursos Humanos"
	XmlFile="/rh/generales.xml"
	returnvariable="LB_RecursosHumanos"/>

<cf_templateheader title="#LB_RecursosHumanos#">
	<script  language="JavaScript" src="/cfmx/rh/js/DHTMLMenu/stm31.js"></script>
<cf_templatecss>
<link href="/cfmx/rh/css/rh.css" rel="stylesheet" type="text/css">

<script language="javascript1.2" type="text/javascript" src="/cfmx/sif/js/qForms/qforms.js">//</script>
<script src="/cfmx/rh/js/utilesMonto.js"></script>

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
					<cfinvoke component="sif.Componentes.Translate"
						method="Translate"
						Key="LB_RegistroDeRelacionesDeEvaluacion"
						Default="Relaci&oacute;n de Seguimiento del Talento Humano"
						returnvariable="LB_RegistroDeRelacionesDeEvaluacion"/>		
					<cfinvoke component="sif.Componentes.Translate"
						method="Translate"
						Key="LB_EvaluaciondelDesempeno"
						Default="Evaluaci&oacute;n del Desempeño"
						returnvariable="LB_EvaluaciondelDesempeno"/>			
                  	<cf_web_portlet_start border="true" titulo="#LB_RegistroDeRelacionesDeEvaluacion#" skin="#Session.Preferences.Skin#">

						<cfif isdefined("url.sel") and len(trim(url.sel)) gt 0><cfset form.sel = url.sel></cfif>
						<cfif isdefined("url.RHRSid") and len(trim(url.RHRSid)) gt 0><cfset form.RHRSid = url.RHRSid></cfif>
						<cfif isdefined("url.modo") and len(trim(url.modo)) gt 0><cfset form.modo = url.modo></cfif>
						<cfif isdefined("url.Nuevo") and len(trim(url.Nuevo)) gt 0><cfset form.Nuevo = url.Nuevo></cfif>
				
						<cfparam name="form.sel" default="1" type="numeric">
						<cfif (form.sel gt 0) and (isdefined("form.Nuevo") or (isdefined("form.RHRSid") and len(trim(form.RHRSid)) gt 0))>
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
                                    <cfinclude template="registro_evaluacion_header.cfm">
									<cfswitch expression="#sel#">						
										<cfcase value="1"><cfinclude template="registro_evaluacion_form.cfm"></cfcase>
										<cfcase value="2"><cfinclude template="registro_asignar_Item.cfm"></cfcase>
										<cfcase value="3"><cfinclude template="registro_asignar_evaluadores.cfm"></cfcase>
										<cfcase value="4"><cfinclude template="registro_evaluaciones_generadas.cfm"></cfcase>
										<cfcase value="5"><cfinclude template="progreso_evaluaciones.cfm"></cfcase>
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
							<cfinclude template="/rh/portlets/pNavegacion.cfm"><br>
							<cfinclude template="registro_evaluacion_filtro.cfm"><br>
							<cfinclude template="registro_evaluacion_lista.cfm">
						</cfif>
	                <cf_web_portlet_end>
				</td>	
			</tr>
		</table>	
<cf_templatefooter>