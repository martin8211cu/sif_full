<cf_templateheader title="Consulta Documentos de Autorizacion Presupuestaria">
	<cf_web_portlet_start titulo="Autorizacion Presupuestaria">
		<cfinclude template="/sif/portlets/pNavegacion.cfm">
		<cfinclude template="ConsNAP-form.cfm">
		<cfif isdefined("LvarExit")>
			<cfinclude template="ConsNAP-filtro.cfm">
		</cfif>
	<cf_web_portlet_end>
<cf_templatefooter>