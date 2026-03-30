
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_RHAutogestion"
	Default="RH - Autogesti&oacute;n"
	XmlFile="/rh/generales.xml"
	returnvariable="LB_RHAutogestion"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_EvaluacionesDeGestionDeTalento"
	Default="Evaluaciones de Gesti&oacute;n de talento"
	returnvariable="LB_EvaluacionesDeGestionDeTalento"/>	

<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_AutoevaluacionDeltalento"
	Default="Autoevaluaci&oacute;n del Talento"
	returnvariable="LB_AutoevaluacionDeltalento"/>
<cfset titulo = LB_EvaluacionesDeGestionDeTalento >
<cfif isdefined("url.tipo") and not isdefined("form.tipo")>
	<cfset form.tipo = url.tipo >
</cfif>
<cfif ucase(form.tipo) eq 'AUTO'>
	<cfset titulo = LB_AutoevaluacionDeltalento>
</cfif>

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

<cf_templateheader title="#LB_RHAutogestion#">

	<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='#titulo#'>		
 		<cfinclude template="/rh/Utiles/params.cfm">
	 	<cfset Session.Params.ModoDespliegue = 0>
	 	<cfset Session.cache_empresarial = 0>

		<table width="100%" cellpadding="2"  cellspacing="0">
			<tr>
				<td valign="top">
					<cfinclude template="/rh/Utiles/consulta-Empleado.cfm">
					<cfif isdefined("url.tipo") and not isdefined("form.tipo")>
						<cfset form.tipo = url.tipo >
					</cfif>
			
					<cfif isdefined("url.RHRSEid") and not isdefined("form.RHRSEid")>
						<cfset form.RHRSEid = url.RHRSEid >
					</cfif>

					<cfset titulo = LB_EvaluacionesDeGestionDeTalento >
					<cfif ucase(form.tipo) eq 'AUTO'>
						<cfset titulo = LB_AutoevaluacionDeltalento>
					</cfif>
					
					<script type="text/javascript" language="javascript1.2" src="/cfmx/rh/js/utilesMonto.js"></script> 
			
					<table width="100%" cellpadding="0" cellspacing="0">
						<cfif form.tipo eq 'otros'>
							<cfset regresar = '/cfmx/rh/admintalento/evaluacion/evaluar_des-lista.cfm?tipo=otros' >
						<cfelse>
							<cfset regresar = '/cfmx/rh/admintalento/evaluacion/evaluar_des-lista.cfm?tipo=auto' >
						</cfif>
						<tr><td><cfinclude template="/rh/portlets/pNavegacion.cfm"></td></tr>
						<tr><td><cfinclude template="evaluar_des-form.cfm"></td></tr>
						 <tr><td><cfinclude template="pccontestar.cfm"></td></tr> 
					<table>	
				</td>	
			</tr>
		</table>	
	<cf_web_portlet_end>
<cf_templatefooter>
