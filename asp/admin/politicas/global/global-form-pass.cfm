<cfif IsDefined('url.test') and url.test is 'yes'>
	<cfinclude template="global-form-passtest.cfm">
<cfelse>
	<cfinclude template="global-form-passedit.cfm">
</cfif>