<cfif isdefined("url.CPPid")>
	<cfset form.CPPid = url.CPPid>
</cfif>
<cfif isdefined("url.Mcodigo")>
	<cfset form.Mcodigo = url.Mcodigo>
</cfif>
<cf_templateheader title="Variación de Tipos de Cambio Proyectados por Mes">
	<cf_web_portlet_start titulo="Variación de Tipos de Cambio Proyectados por Mes">
		<cfinclude template="/sif/portlets/pNavegacion.cfm">
		<!--- mantenimiento_Meses --->
		<cfinclude template="tiposCambio_form.cfm">
	<cf_web_portlet_end>		
<cf_templatefooter>