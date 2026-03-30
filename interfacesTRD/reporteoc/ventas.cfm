<cfset archivo = 'ventas.cfm'>
<cfset origen = 'cc'>
<cfif IsDefined('form.btnGenerar') or IsDefined('url.X')>
<cfinclude template="reporte2.cfm">
<cfelse>
<cfinclude template="reporte.cfm">
</cfif>