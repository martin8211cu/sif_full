<cfif (not isdefined("session.usucodigo")) or session.usucodigo is 0>
	<cfinclude template="login-form2.cfm">
<cfelse>
	<cflocation url="#Url.uri#">
</cfif>