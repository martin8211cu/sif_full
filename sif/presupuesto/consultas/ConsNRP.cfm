<cf_templateheader title="Consulta Documentos de Rechazo Presupuestario">
	<cf_web_portlet_start titulo="Documentos de Rechazo Presupuestario">
		<cfinclude template="/sif/portlets/pNavegacion.cfm">
		<cfinclude template="ConsNRP-form.cfm">
		<cfif isdefined("LvarExit")> 
			<cfinclude template="ConsNRP-filtro.cfm">
		</cfif>
	<cf_web_portlet_end>
<cf_templatefooter>