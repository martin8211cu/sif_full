<cf_template template="#session.sitio.template#">
	<cf_templatearea name="title">
		Cuentas Contables
	</cf_templatearea>
	
	<cf_templatearea name="body">
			<cfif isdefined("session.modulo") and session.modulo EQ "CG">
				<cfinclude template="/sif/portlets/pNavegacionCG.cfm">
			<cfelseif isdefined("session.modulo") and session.modulo EQ "AD">
				<cfinclude template="/sif/portlets/pNavegacionAD.cfm">
			</cfif>
		<cfset Request.ConCuentasFinancieras = true>
		<cfinclude template="ConlisCuentasFinancieras.cfm">
	</cf_templatearea>
</cf_template>