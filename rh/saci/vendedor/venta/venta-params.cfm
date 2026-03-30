<cfparam name="CurrentPage" default="#GetFileFromPath(GetTemplatePath())#">

<cfif isdefined("url.tab") and Len(Trim(url.tab))>
	<cfset form.tab = url.tab>
</cfif>
<cfparam name="form.tab" default="1">

<cfif isdefined("url.paso") and Len(Trim(url.paso))>
	<cfset form.paso = url.paso>
</cfif>
<cfif isdefined("form.paso") and Len(Trim(form.paso))>
	<cfset url.paso = form.paso>
</cfif>
<cfparam name="form.paso" default="0">

<cfif isdefined("url.pq") and Len(Trim(url.pq))>
	<cfset form.pq = url.pq>
</cfif>
<cfparam name="form.pq" default="">
<cfif isdefined("form.pq") and Len(Trim(form.pq))>
	<cfset form.Pquien = form.pq>
</cfif>
<cfif isdefined("url.Pquien") and Len(Trim(url.Pquien))>
	<cfset form.Pquien = url.Pquien>
</cfif>
<cfparam name="form.Pquien" default="">
<cfset ExistePersona = isdefined("form.Pquien") and Len(Trim(form.Pquien))>

<cfif isdefined("url.cue") and Len(Trim(url.cue))>
	<cfset form.cue = url.cue>
</cfif>
<cfparam name="form.cue" default="">
<cfif isdefined("form.cue") and Len(Trim(form.cue))>
	<cfset form.CTid = form.cue>
</cfif>
<cfif isdefined("url.CTid") and Len(Trim(url.CTid))>
	<cfset form.CTid = url.CTid>
</cfif>
<cfparam name="form.CTid" default="">
<cfset ExisteCuenta = isdefined("form.CTid") and Len(Trim(form.CTid))>

<cfinclude template="venta-paramsvar.cfm">

<cfif ExistePersona>
	<cfquery name="rsDatosPersona" datasource="#Session.DSN#">
		select b.Pquien, b.Pid, b.Ppersoneria,
			   case when b.Ppersoneria = 'J' then rtrim(b.PrazonSocial) else rtrim(rtrim(b.Pnombre) || ' ' || rtrim(b.Papellido) || ' ' || b.Papellido2) end as NombreCompleto
		from ISBpersona b
		where b.Pquien = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Pquien#">
	</cfquery>
</cfif>
