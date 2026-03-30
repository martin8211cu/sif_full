<cfif IsDefined('form.actualizar')>
	<cflocation url="segconfirmar.cfm">
<cfelseif IsDefined('form.buscar')>
	<cflocation url="segbuscar.cfm">
<cfelse>
	<cflocation url="objbuscar.cfm">
</cfif>
