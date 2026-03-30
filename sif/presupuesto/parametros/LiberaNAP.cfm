<cf_templateheader title="Liberar NAPS">
	<cf_web_portlet_start titulo="Liberar NAPS">
		<cfinclude template="/sif/portlets/pNavegacion.cfm">
		<cfinclude template="LiberaNAP-form.cfm">
		<cfif isdefined("LvarExit")>
			<cfinclude template="LiberaNAP-filtro.cfm">
		</cfif>		
	<cf_web_portlet_end>
<cf_templatefooter>