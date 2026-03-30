<cf_templateheader title="Aprobación de la Formulación Presupuestaria">
	<cf_web_portlet_start titulo="Lista de Versiones de Presupuesto para Aprobar">
		<cfinclude template="/sif/portlets/pNavegacion.cfm">
		<cfinclude template="versiones_config.cfm">
	
		<cfif isdefined("form.CVid") and form.CVid NEQ "">
			<cfinclude template="aprobacion_form.cfm">
		<cfelse>
			<cfinclude template="aprobacion_lista.cfm">
		</cfif>
	<cf_web_portlet_end>
<cf_templatefooter>