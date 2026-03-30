<cf_templateheader title="Cancelación de Rechazos Presupuestarios (NRPs) Aprobados sin Aplicar">
	  
	
		<cf_web_portlet_start titulo="Cancelación de Rechazos Presupuestarios (NRPs) Aprobados sin Aplicar">
			<cfset LvarCancelacionNRP = true>
			<cfinclude template="/sif/portlets/pNavegacion.cfm">
			<cfinclude template="cancelacionNRP-form.cfm">
			<cfif isdefined("LvarExit")>
				<cfinclude template="../common/NRP-filtro.cfm">
			</cfif>
		<cf_web_portlet_end>
<cf_templatefooter>