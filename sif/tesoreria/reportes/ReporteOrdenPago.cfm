<!---
Codigo: REPOrPag 
Reporte: Reporte de Órdenes de Pago
--->
<cfinvoke key="LB_Titulo" default="Reporte de Órdenes de Pago"	returnvariable="LB_Titulo"	method="Translate"
component="sif.Componentes.Translate"  xmlfile="ReporteOrdenPago.xml"/>

<cfset titulo = '#LB_Titulo#'>
<cf_templateheader title="#titulo#">
<cf_web_portlet_start _start border="true" titulo="#titulo#" skin="#Session.Preferences.Skin#">
	<cfif isdefined('url.btnConsultar')>
		<cfinclude template="ReporteOrdenPago-form.cfm">
	<cfelse>
		<cfinclude template="ReporteOrdenPago-filtro.cfm">
	</cfif>
<cf_web_portlet_start _end>
