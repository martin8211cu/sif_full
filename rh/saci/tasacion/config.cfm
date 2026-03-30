<cfif IsDefined('form.action') or IsDefined('url.action')>
	<cfinclude template="config-sql.cfm">
<cfelseif IsDefined('url.hostname')>
	<cfinclude template="config-form-host.cfm">
<cfelseif IsDefined('url.servicio')>
	<cfinclude template="config-form-svc.cfm">
<cfelseif IsDefined('url.lista')>
	<cfinclude template="config-page-list.cfm">
<cfelse>
	<cfinclude template="config-page.cfm">
</cfif>
