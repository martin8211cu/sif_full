<cf_templateheader title="Aprobación de Rechazos Presupuestarios (NRPs)">
		<cf_web_portlet_start titulo="Aprobación de Rechazos Presupuestarios (NRPs)">
			<cfset LvarAprobacionNRP = true>
			<cfinclude template="/sif/portlets/pNavegacion.cfm">
			<cfinclude template="autorizacionNRP-form.cfm">
			<cfif isdefined("LvarExit")>
				<cfinclude template="../common/NRP-filtro.cfm">
			</cfif>
		<cf_web_portlet_end>
<cf_templatefooter>