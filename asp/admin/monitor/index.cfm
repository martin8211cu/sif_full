<cfif IsDefined('form.liberar') or IsDefined('form.asignar')>
	<cfinclude template="liberar.cfm">
<cfelse>
	<cfinclude template="monitor.cfm">
</cfif>