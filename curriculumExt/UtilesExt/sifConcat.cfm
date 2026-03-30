<cfset _Cat = "+">
<cfif lcase(Application.dsinfo['asp'].type) is 'oracle' or lcase(Application.dsinfo['asp'].type) is 'db2'>
	<cfset _Cat = "||">
</cfif>
