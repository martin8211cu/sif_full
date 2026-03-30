<cf_templateheader title="Lista de Traslados de Presupuesto a Registrar">
	<cf_web_portlet_start titulo="Lista de Traslados de Presupuesto a Registrar">
		<cfinclude template="/sif/portlets/pNavegacion.cfm">
		<cfset session.CPformTipo = "registro">
		<cfinclude template="traslado-lista.cfm">
	<cf_web_portlet_end>
<cf_templatefooter>