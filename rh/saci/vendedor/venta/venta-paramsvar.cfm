<cfset params = "tab=" & form.tab>
<cfset params = params & Iif(Len(Trim(params)), DE("&"), DE("")) & "paso=" & form.paso>
<cfset params = params & Iif(Len(Trim(params)), DE("&"), DE("")) & "cue=" & form.CTid>
<cfset params = params & Iif(Len(Trim(params)), DE("&"), DE("")) & "pq=" & form.Pquien>
<cfif isdefined("ExtraParams") and len(trim(ExtraParams))>
	<cfset params = params & Iif(Len(Trim(params)), DE("&"), DE("")) & ExtraParams>
</cfif>

<cfset Request.Error.Url = "venta.cfm?#params#">
<cfset Request.redirect = "venta.cfm?#params#">
