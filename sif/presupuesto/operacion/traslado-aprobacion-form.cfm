<cf_templateheader title="Aprobación de Traslados de Presupuesto">
	<cf_web_portlet_start titulo="Aprobacion de Traslados de Presupuesto">
		<cfinclude template="/sif/portlets/pNavegacion.cfm">
		<cfset session.CPformTipo = "aprobacion">
		<cfinclude template="traslado-form.cfm">
	<cf_web_portlet_end>
<cf_templatefooter>