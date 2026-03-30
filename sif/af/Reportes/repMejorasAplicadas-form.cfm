<cf_templateheader title="<cfoutput>Mejoras de Activos Aplicadas</cfoutput>">
		<cfinclude template="/sif/portlets/pNavegacion.cfm">							
		<cf_web_portlet_start titulo='Mejoras de Activos Aplicadas'>
			<cfset params = ''>
			<cfif isdefined('url.TAmes') and not isdefined('form.TAmes')>
				<cfset params = params & "&TAmes=#url.TAmes#">
			<cfelseif isdefined('form.TAmes') and len(trim(form.TAmes))>
				<cfset params = params & "&TAmes=#form.TAmes#">
			</cfif>
			<cfif isdefined('url.TAperiodo') and not isdefined('form.TAperiodo')>
				<cfset params = params & "&TAperiodo=#url.TAperiodo#">
			<cfelseif isdefined('form.TAperiodo') and len(trim(form.TAperiodo))>
				<cfset params = params & "&TAperiodo=#form.TAperiodo#">
			</cfif>
			<cfif isdefined('url.TAfecha') and not isdefined('form.TAfecha')>
				<cfset params = params & "&TAfecha=#url.TAfecha#">
			<cfelseif isdefined('form.TAfecha') and len(trim(form.TAfecha))>
				<cfset params = params & "&TAfecha=#form.TAfecha#">
			</cfif>			
			<cf_rhimprime datos="/sif/af/Reportes/repMejorasAplicadas-rep.cfm" paramsuri=""> 
			<cf_sifHTML2Word>
				<cfinclude template="repMejorasAplicadas-rep.cfm">
			</cf_sifHTML2Word>		
		<cf_web_portlet_end>
	<cf_templatefooter>