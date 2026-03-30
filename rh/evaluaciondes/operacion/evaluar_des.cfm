<!--- VARIABLES DE TRADUCCION --->
<cfinvoke key="LB_RHAutogestion" default="RH - Autogesti&oacute;n" xmlfile="/rh/generales.xml" returnvariable="LB_RHAutogestion" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_EvaluacionesDelDesempenoPendientes" default="Evaluaciones del Desempe&ntilde;o Pendientes" returnvariable="LB_EvaluacionesDelDesempenoPendientes" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_AutoevaluacionDelDesempeno" default="Autoevaluaci&oacute;n del Desempe&ntilde;o" returnvariable="LB_AutoevaluacionDelDesempeno" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_EvaluacionesDelDesempenoPendientes" default="Evaluaciones del Desempe&ntilde;o Pendientes" returnvariable="LB_EvaluacionesDelDesempenoPendientes" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_AutoevaluacionDelDesempeno" default="Autoevaluaci&oacute;n del Desempe&ntilde;o" returnvariable="LB_AutoevaluacionDelDesempeno" component="sif.Componentes.Translate" method="Translate"/>

<!--- FIN VARIABLES DE TRADUCCION --->

<cfset titulo = LB_EvaluacionesDelDesempenoPendientes >
<cfif isdefined("url.tipo") and not isdefined("form.tipo")>
	<cfset form.tipo = url.tipo >
</cfif>
<cfif ucase(form.tipo) eq 'AUTO'>
	<cfset titulo = LB_AutoevaluacionDelDesempeno>
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
			
					<cfif isdefined("url.RHEEid") and not isdefined("form.RHEEid")>
						<cfset form.RHEEid = url.RHEEid >
					</cfif>

					<cfif isdefined("url.DEid") and not isdefined("form.DEid")>
						<cfset form.DEid = url.DEid >
					</cfif>
			
					<cfif isdefined("url.DEideval") and not isdefined("form.DEideval")>
						<cfset form.DEideval = url.DEideval >
					</cfif>
			
					<cfif isdefined("url.RHPcodigo") and not isdefined("form.RHPcodigo")>
						<cfset form.RHPcodigo = url.RHPcodigo >
					</cfif>
                    
                    <cfif not isdefined("url.RHPcodigo") and not isdefined("form.RHPcodigo")>
                        <cfquery name="rsRHListaEvalDes" datasource="#session.DSN#">
                            select RHPcodigo from RHListaEvalDes
                            where RHEEid    = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHEEid#">
                            and DEid 		= <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DEid#">
                        </cfquery>
						<cfset form.RHPcodigo = rsRHListaEvalDes.RHPcodigo >
					</cfif>
                    
                    
					<cfset titulo = LB_EvaluacionesDelDesempenoPendientes >
					<cfif ucase(form.tipo) eq 'AUTO'>
						<cfset titulo = LB_AutoevaluacionDelDesempeno>
					</cfif>
					
					<script type="text/javascript" language="javascript1.2" src="/cfmx/rh/js/utilesMonto.js"></script> 
			
					<table width="100%" cellpadding="0" cellspacing="0">
						<cfif form.tipo eq 'otros'>
							<cfset regresar = '/cfmx/rh/evaluaciondes/operacion/evaluar_des-lista.cfm?tipo=otros' >
						<cfelse>
							<cfset regresar = '/cfmx/rh/evaluaciondes/operacion/evaluar_des-lista.cfm?tipo=auto' >
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
