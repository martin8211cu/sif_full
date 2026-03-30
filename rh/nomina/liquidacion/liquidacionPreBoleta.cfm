<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_nombre_proceso" Default="Pre Boleta de Liquidaci&oacute;n Laboral" returnvariable="nombre_proceso"/> 
<cfset CurrentPage=GetFileFromPath(GetTemplatePath())>
<cfsavecontent variable="pNavegacion">
	<cfinclude template="/rh/portlets/pNavegacion.cfm">
</cfsavecontent>

<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		Key="LB_RecursosHumanos"
		Default="Recursos Humanos"
		XmlFile="/rh/generales.xml"
		returnvariable="LB_RecursosHumanos"/>
	<cf_templateheader title="#LB_RecursosHumanos#" template="#session.sitio.template#">

<cfif isdefined("Url.RHPLPid") and Len(Trim(Url.RHPLPid)) and not isdefined("Form.RHPLPid")>
	<cfset Form.RHPLPid = Url.RHPLPid>
</cfif>

<cfif isdefined("Url.DEid") and Len(Trim(Url.DEid)) and not isdefined("Form.DEid")>
	<cfset Form.DEid = Url.DEid>
</cfif>
	
	<cf_web_portlet_start titulo='#nombre_proceso#'>
		<cfoutput>#pNavegacion#</cfoutput>
		<cfset params = '?RHPLPid=#form.RHPLPid#'>
		<cfif isdefined("form.DEid") and len(trim(form.DEid))>
			<cfset params = params & '&DEid=#form.DEid#'>
		</cfif>
			<cf_rhimprime datos="/rh/nomina/liquidacion/liquidacionPreBoletaMX-form.cfm" paramsuri="#params#">
			<cfinclude template="/rh/nomina/liquidacion/liquidacionPreBoletaMX-form.cfm">
	<cf_web_portlet_end>
<cf_templatefooter>