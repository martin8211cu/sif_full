<cfif IsDefined ("url.show_status")>
	<cfinclude template="ShowStatusReverso.cfm">
<cfelseif IsDefined ("url.show_process")>
	<cfinclude template="AplicRevMasivo-sql.cfm" >
</cfif>
