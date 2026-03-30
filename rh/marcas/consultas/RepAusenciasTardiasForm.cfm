<!--- VARIABLES DE TRADUCCION --->
<cfinvoke key="LB_RecursosHumanos" default="Recursos Humanos" xmlfile="/rh/generales.xml" returnvariable="LB_RecursosHumanos" component="sif.Componentes.Translate" method="Translate"/>	
<cfinvoke key="LB_ReporteDeInconsistenciasDeMarcas" default="Reporte de Inconsistencias de Marcas" returnvariable="LB_ReporteDeInconsistenciasDeMarcas" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="MSG_TipodeNomina" default="Tipo de Nmina" returnvariable="MSG_TipodeNomina" component="sif.Componentes.Translate" method="Translate"/> 
<cfinvoke key="MSG_NominaAplicada" default="Nmina Aplicada" returnvariable="MSG_NominaAplicada" component="sif.Componentes.Translate" method="Translate"/> 
<cfinvoke key="MSG_NominaNoAplicada" default="Nmina no Aplicada" returnvariable="MSG_NominaNoAplicada" component="sif.Componentes.Translate" method="Translate"/> 
<cfinvoke key="MSG_ElTipoDeCambioDebeSerMayorACero" default="El tipo de cambio debe ser mayor a cero" returnvariable="MSG_ElTipoDeCambioDebeSerMayorACero" component="sif.Componentes.Translate" method="Translate"/> 
<!--- FIN VARIABLES DE TRADUCCION --->
<cf_templateheader title="#LB_ReporteDeInconsistenciasDeMarcas#">
	<script  language="JavaScript" src="/cfmx/rh/js/DHTMLMenu/stm31.js"></script>

	<cf_templatecss>
	<link href="/cfmx/rh/css/rh.css" rel="stylesheet" type="text/css">
	<cf_web_portlet_start border="true" titulo="#LB_ReporteDeInconsistenciasDeMarcas#" skin="#Session.Preferences.Skin#">
	  	<cfinclude template="/rh/Utiles/params.cfm">
		<table width="100%" cellpadding="2" cellspacing="0" border="0">
			<tr>
				<td valign="top" colspan="2">
					<cfset params = ''>
                    <cfif isdefined('form.CFid')>
						<cfset params = params & '&CFid=' & form.CFid>
					</cfif>
                    <cfif isdefined('form.DEid')>
						<cfset params = params & '&DEid=' & form.DEid>
					</cfif>
                    <cfif isdefined('form.Fdesde')>
						<cfset params = params & '&Fdesde=' & form.Fdesde>
					</cfif>
                    <cfif isdefined('form.Fhasta')>
						<cfset params = params & '&Fhasta=' & form.Fhasta>
					</cfif>
                    <cfif isdefined('form.Ingreso')>
						<cfset params = params & '&Ingreso=' & form.Ingreso>
					</cfif>
                    <cfif isdefined('form.Salida')>
						<cfset params = params & '&Salida=' & form.Salida>
					</cfif>
					<cfif isdefined('form.Orden')>
						<cfset params = params & '&Orden=' & form.Orden>
					</cfif>
					<!--- <cfinclude template="RepAusenciasTardiasRes.cfm"> --->
					<cfset LvarFileName = "RepAusenciasTardias#Session.Usucodigo#-#DateFormat(Now(),'yyyymmdd')#-#TimeFormat(Now(),'hhmmss')#.xls">
					<cf_htmlReportsHeaders 
						title="#LB_ReporteDeInconsistenciasDeMarcas#" 
						filename="#LvarFileName#"
						irA="RepAusenciasTardias.cfm" 
						>
					<cfinclude template="RepAusenciasTardiasRes.cfm">
					
					
					
 	                <!--- <cf_reportWFormat url="/rh/marcas/consultas/RepAusenciasTardiasRes.cfm" orientacion="portrait" regresar="RepAusenciasTardias.cfm" params="#params#"> --->
			</td>	
			</tr>
		</table>	
    <cf_web_portlet_end>		
<cf_templatefooter>