<cfparam name="CurrentPage" default="#GetFileFromPath(GetTemplatePath())#">

<cfif isdefined("url.paso") and Len(Trim(url.paso))>
	<cfset form.paso = url.paso>
</cfif>
<cfparam name="form.paso" default="1">

<cfif isdefined("url.cue") and Len(Trim(url.cue))>
	<cfset form.cue = url.cue>
</cfif>
<cfparam name="form.cue" default="">
<cfparam name="form.CTid" default="#form.cue#">

<cfif isdefined("url.contra") and Len(Trim(url.contra))>
	<cfset form.contra = url.contra>
</cfif>
<cfparam name="form.contra" default="">
<cfparam name="form.Contratoid" default="#form.contra#">

<cfif isdefined("url.pq") and Len(Trim(url.pq))>
	<cfset form.pq = url.pq>
</cfif>
<cfparam name="form.pq" default="">
<cfparam name="form.Pquien" default="#form.pq#">

<cfif isdefined("url.ag") and Len(Trim(url.ag))>
	<cfset form.ag = url.ag>
</cfif>
<cfparam name="form.ag" default="">
<cfparam name="form.AGid" default="#form.ag#">

<cfif isdefined("url.fact") and Len(Trim(url.fact))>
	<cfset form.fact = url.fact>
</cfif>
<cfparam name="form.fact" default="">
<cfparam name="form.CTidFactura" default="#form.fact#">

<cfif isdefined("url.paq") and Len(Trim(url.paq))>
	<cfset form.paq = url.paq>
</cfif>

<cfparam name="form.paq" default="">
<cfparam name="form.PQcodigo" default="#form.paq#">

<cfset ExistePersona = (isdefined("form.pq") and Len(Trim(form.pq)))or(isdefined("form.Pquien")and Len(Trim(form.Pquien)))>
<cfset ExisteCuenta = (isdefined("form.cue") and Len(Trim(form.cue)))or(isdefined("form.CTid")and Len(Trim(form.CTid)))>
