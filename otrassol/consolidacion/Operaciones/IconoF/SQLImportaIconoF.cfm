<cfif IsDefined ("url.show_status")>
	<cfinclude template="status.cfm">
<cfelseif IsDefined ("url.show_process")>
	<cfinclude template="process.cfm">
</cfif>
