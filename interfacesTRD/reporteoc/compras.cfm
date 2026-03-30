<cfset archivo = 'compras.cfm'>
<cfset origen = 'cp'>
<cfif IsDefined('form.btnGenerar') or IsDefined('url.X')>
<cfinclude template="reporte2.cfm">
<cfelse>
<cfinclude template="reporte.cfm">
</cfif>