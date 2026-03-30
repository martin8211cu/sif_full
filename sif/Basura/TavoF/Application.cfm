<!--- no poner el application.cfm aqui.  Si hace falta para alguna pantalla, incluya lo siguiente:
<cfinclude template="../Application.cfm">
---><!--- <cfsetting enablecfoutputonly="yes"><cfset hdrs = GetHTTPRequestData().headers>
<cfset host = "undefined">
<cfif StructKeyExists(hdrs, "X-Forwarded-Host")>
    <cfset host = hdrs["X-Forwarded-Host"]>
<cfelse>
    <cfset host = hdrs.Host>
</cfif>
<cfif ListFindNoCase('websdc,desarrollo,10.7.7.195,10.7.7.198,oracle.des.soin.net,hawk,10.7.7.15,100.1.1.24,localhost,127.0.0.1', ListFirst(host,':')) is 0>
  <cfthrow detail="Server Inválido: #host#">
</cfif><cfsetting enablecfoutputonly="no"> --->
<cfinclude template="../../Application.cfm">