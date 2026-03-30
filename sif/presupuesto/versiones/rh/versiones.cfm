<cf_templateheader title="Rechazo de la Formulación Presupuestaria">
	<cf_web_portlet_start titulo="Lista de Versiones de Formulación Presupuestaria generada desde Escenarios de Planilla Presupuestaria">
		<cfinclude template="/sif/portlets/pNavegacion.cfm">
		<cfinclude template="/sif/presupuesto/versiones/versiones_config.cfm">
	
		<cfif isdefined("form.CVid") and form.CVid NEQ "">
			<cfinclude template="/sif/presupuesto/versiones/versionesComun.cfm">
		<cfelse>
			<cfinclude template="versiones_lista.cfm">
		</cfif>
	<cf_web_portlet_end>
<cf_templatefooter>