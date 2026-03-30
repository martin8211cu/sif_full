<!--- no poner el application.cfm aqui.  Si hace falta para alguna pantalla, incluya lo siguiente:
<cfinclude template="../Application.cfm">
---><cfsetting enablecfoutputonly="yes"><cfset hdrs = GetHTTPRequestData().headers>
<cfset host = "undefined">
<cfif StructKeyExists(hdrs, "X-Forwarded-Host")>
    <cfset host = hdrs["X-Forwarded-Host"]>
<cfelse>
    <cfset host = hdrs.Host>
</cfif><cfsetting enablecfoutputonly="no">