<!---
Codigo: REPOrPag 
Reporte: Reporte de Órdenes de Pago
--->
<cfset titulo = 'Reporte Detallado de Órdenes de Pago'>
<cf_templateheader title="#titulo#">
<cf_web_portlet_start _start border="true" titulo="#titulo#" skin="#Session.Preferences.Skin#">
<!---	<cfif isdefined('form.btnConsultar')>
		<cfinclude template="ReporteOrdenPagoDet-form.cfm">
	<cfelse>
		<cfinclude template="ReporteOrdenPagoDet-filtro.cfm">
	</cfif>--->
	<cfinclude template="ReporteOrdenPagoDet-filtro.cfm">
<cf_web_portlet_start _end>
