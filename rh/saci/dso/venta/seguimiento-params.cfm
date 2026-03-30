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

<cfif isdefined("url.filtro_CUECUE") and Len(Trim(url.filtro_CUECUE))>
	<cfset form.filtro_CUECUE = url.filtro_CUECUE>
</cfif>
<cfif isdefined("url.filtro_DUENO") and Len(Trim(url.filtro_DUENO))>
	<cfset form.filtro_DUENO = url.filtro_DUENO>
</cfif>
<cfif isdefined("url.filtro_VENDEDOR") and Len(Trim(url.filtro_VENDEDOR))>
	<cfset form.filtro_VENDEDOR = url.filtro_VENDEDOR>
</cfif>
<cfif isdefined('url.AGidp_Agente') and not isdefined('form.AGidp_Agente')>
	<cfset form.AGidp_Agente = url.AGidp_Agente>
</cfif>

<cfset ExistePersona = (isdefined("form.pq") and Len(Trim(form.pq)))or(isdefined("form.Pquien")and Len(Trim(form.Pquien)))>
<cfset ExisteCuenta = (isdefined("form.cue") and Len(Trim(form.cue)))or(isdefined("form.CTid")and Len(Trim(form.CTid)))>
