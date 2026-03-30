<cftry>
<cfinvoke component="home.Componentes.aspmonitor" method="MonitoreoEnd">
</cfinvoke>
<cfcatch type="any">
	<cflog file="monitoreo" text="Error en monitoreo: #cfcatch.Message# - #cfcatch.Detail#">
	<cfif IsDefined('session.sitio.ip') and session.sitio.ip is '10.7.7.30'>
		<cfthrow message="#cfcatch.Message# - #cfcatch.Detail#">
	</cfif>
</cfcatch>
</cftry>