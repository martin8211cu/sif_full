<cf_templateheader title="Traslados para Rechazos Presupuestarios (NRPs)">
		<cf_web_portlet_start titulo="Traslados para Rechazos Presupuestarios (NRPs)">
			<cfset LvarTrasladosNRP = true>
			<cfinclude template="/sif/portlets/pNavegacion.cfm">
			<cfinclude template="autorizacionNRP-form.cfm">
			<cfif isdefined("LvarExit")>
				<cfinclude template="../common/NRP-filtro.cfm">
			</cfif>
		<cf_web_portlet_end>
<cf_templatefooter>
