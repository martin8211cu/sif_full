<cf_templateheader title="Lista de Traslados de Presupuesto">
	  <cf_web_portlet_start titulo="Lista de Traslados de Presupuesto para Aprobar">
			<cfinclude template="/sif/portlets/pNavegacion.cfm">
			<cfset session.CPformTipo = "aprobacion">
			<cfinclude template="traslado-lista.cfm">
		<cf_web_portlet_end>
<cf_templatefooter>