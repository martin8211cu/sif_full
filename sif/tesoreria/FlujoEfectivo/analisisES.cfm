<cf_templateheader title="Análisis de Entradas y Salidas">
	<cfif isdefined("url.TESid") and not isdefined("form.TESid")>
		<cfset form.TESid = url.TESid >
	</cfif>

	<cfif isdefined("url.Tiempo") and not isdefined("form.Tiempo")>
		<cfset form.Tiempo = url.Tiempo >
	</cfif>

	<cfif isdefined("url.FechaFinal") and not isdefined("form.FechaFinal")>
		<cfset form.FechaFinal = url.FechaFinal>
	</cfif>

	<cfparam name="form.FechaFinal" default="#dateFormat (dateadd('m',3,now()),"dd/mm/yyyy")#">

	<cfset params = '' >
	<cfif isdefined("form.TESid") and len(trim(form.TESid))>
		<cfset params = params & "&TESid=#form.TESid#">
	</cfif>
	<cfif isdefined("form.Tiempo") and len(trim(form.Tiempo))>
		<cfset params = params & "&Tiempo=#form.Tiempo#">
	</cfif>
	<cfif isdefined("form.FechaFinal") and len(trim(form.FechaFinal))>
		<cfset params = params & "&FechaFinal=#form.FechaFinal#">
	</cfif>

	<!---<cf_rhimprime datos="/sif/tesoreria/FlujoEfectivo/analisisES_print.cfm" paramsuri="#params#" formato="flashpaper">--->
	<cf_web_portlet_start border="true" titulo="Reporte de Flujo de Efectivo" skin="#Session.Preferences.Skin#">
		<cfinclude template="analisisES_print.cfm">
	<cf_web_portlet_end>
<cf_templatefooter>