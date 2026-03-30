<cfif isdefined("form.Eliminar") and not isdefined("url.Eliminar")>
	<cfset url.Eliminar = form.Eliminar>	
</cfif>

<cfif IsDefined('url.cta')>
	<cfinclude template="anexo-cuenta.cfm">
<cfelseif IsDefined('url.copyop')>
	<cfinclude template="anexo-rango-copy.cfm">
<cfelseif IsDefined('url.copyop2')>
	<cfinclude template="anexo-rango-copy2.cfm">
<cfelseif IsDefined('url.Mover')>
	<cfinclude template="anexo-mover.cfm">
<cfelseif IsDefined('url.Mover2')>
	<cfinclude template="anexo-mover2.cfm">
<cfelseif IsDefined('url.Eliminar')>
	<cfinclude template="anexo-borrar_celda.cfm">
<cfelse>
	<cfinclude template="anexo-rango-list.cfm">
</cfif>
