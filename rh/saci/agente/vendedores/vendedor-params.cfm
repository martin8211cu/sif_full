<cfparam name="CurrentPage" default="#GetFileFromPath(GetTemplatePath())#">

<cfif isdefined("url.tab") and Len(Trim(url.tab))>
	<cfset form.tab = url.tab>
</cfif>
<cfparam name="form.tab" default="1">
<cfset params = "tab=" & form.tab>

<cfif isdefined("url.ven") and Len(Trim(url.ven))>
	<cfset form.ven = url.ven>
</cfif>
<cfparam name="form.ven" default="">
<cfif isdefined("form.ven") and Len(Trim(form.ven))>
	<cfset form.Vid = form.ven>
</cfif>
<cfif isdefined("url.Vid") and Len(Trim(url.Vid))>
	<cfset form.Vid = url.Vid>
</cfif>
<cfparam name="form.Vid" default="">
<cfset params = params & Iif(Len(Trim(params)), DE("&"), DE("")) & "ven=" & form.Vid>
<cfset ExisteVendedor = isdefined("form.Vid") and Len(Trim(form.Vid))>

<cfinclude template="vendedor-paramslista.cfm">

<cfset Request.Error.Url = "vendedor.cfm?#params#">
<cfset Request.redirect = "vendedor.cfm?#params#">

<cfif ExisteVendedor>
	<cfquery name="rsDatosPersona" datasource="#Session.DSN#">
		select a.Pquien, b.Pid, b.Ppersoneria,
			   case when b.Ppersoneria = 'J' then rtrim(b.PrazonSocial) else rtrim(rtrim(b.Pnombre) || ' ' || rtrim(b.Papellido) || ' ' || b.Papellido2) end as NombreCompleto
		from ISBvendedor a
			inner join ISBpersona b
				on b.Pquien = a.Pquien
		where a.Vid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Vid#">
	</cfquery>
	<cfset Form.Pquien = rsDatosPersona.Pquien>
</cfif>
