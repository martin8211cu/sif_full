<cfinclude template="ISBpaquete-params.cfm">

<cfset location = "ISBpaquete.cfm">
<cfset Request.Error.Url="#location#?#params#">

<cfif isdefined("extraParams") and Len(Trim(extraParams))>
	<cfset params = params & Iif(Len(Trim(params)), DE("&"), DE("?")) & extraParams>
</cfif>

<cflocation url="#location#?#params#">
