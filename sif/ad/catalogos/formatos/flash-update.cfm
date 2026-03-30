<cfsetting enablecfoutputonly="yes">
<cfparam name="url.action" default="">
<cfif Len(url.action) is 0>
	<cf_errorCode	code = "50027" msg = "Especifique action">
</cfif>

<cfif url.action is 'query'>

</cfif>

