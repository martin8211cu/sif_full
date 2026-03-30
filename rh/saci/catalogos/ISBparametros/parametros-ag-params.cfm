<cfparam name="CurrentPage" default="#GetFileFromPath(GetTemplatePath())#">

<cfparam name="form.tab" default="1">


<cfif isdefined("url.tab") and Len(Trim(url.tab))>
	<cfset form.tab = url.tab>
</cfif>

<cfset params = "tab=" & form.tab>

<cfset Request.Error.Url = "parametros-ag.cfm?#params#">
<cfset Request.redirect = "parametros-ag.cfm?#params#">


