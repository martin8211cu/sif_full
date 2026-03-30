<cfparam name="CurrentPage" default="#GetFileFromPath(GetTemplatePath())#">

<cfif isdefined("url.cue") and Len(Trim(url.cue))>
	<cfset form.cue = url.cue>
</cfif>
<cfparam name="form.cue" default="">
<cfif isdefined("form.cue") and Len(Trim(form.cue))>
	<cfset form.CTid = form.cue>
</cfif>
<cfparam name="form.CTid" default="">

<cfif isdefined("url.pqc") and Len(Trim(url.pqc))>
	<cfset form.pqc = url.pqc>
</cfif>
<cfparam name="form.pqc" default="">
<cfif isdefined("form.pqc") and Len(Trim(form.pqc))>
	<cfset form.Pcontacto = form.pqc>
</cfif>
<cfparam name="form.Pcontacto" default="">

<cfif isdefined("url.pkg") and Len(Trim(url.pkg))>
	<cfset form.pkg = url.pkg>
</cfif>
<cfparam name="form.pkg" default="">
<cfif isdefined("form.pkg") and Len(Trim(form.pkg))>
	<cfset form.Contratoid = form.pkg>
</cfif>
<cfparam name="form.Contratoid" default="">

<cfif isdefined("url.traf") and Len(Trim(url.traf))>
	<cfset form.traf = url.traf>
</cfif>
<cfparam name="form.traf" default="">
<cfif isdefined("form.traf") and Len(Trim(form.traf))>
	<cfset form.trafico = form.traf>
</cfif>
<cfparam name="form.trafico" default="">

<cfif isdefined("url.logg") and Len(Trim(url.logg))>
	<cfset form.logg = url.logg>
</cfif>
<cfparam name="form.logg" default="">
<cfif isdefined("form.logg") and Len(Trim(form.logg))>
	<cfset form.LGnumero = form.logg>
</cfif>
<cfparam name="form.LGnumero" default="">

<cfif isdefined("url.rol") and Len(Trim(url.rol))>
	<cfset form.rol = url.rol>
</cfif>
<cfparam name="form.rol" default="">

<cfif isdefined("url.cli") and Len(Trim(url.cli))>
	<cfset form.cli = url.cli>
</cfif>
<cfparam name="form.cli" default="">
<cfif isdefined("form.cli") and Len(Trim(form.cli))>
	<cfset form.cliente = form.cli>
</cfif>
<cfparam name="form.cliente" default="">

<cfif isdefined("url.paso") and Len(Trim(url.paso))>
	<cfset form.paso = url.paso>
</cfif>
<cfparam name="form.paso" default="1">

<cfif isdefined("url.cpass") and Len(Trim(url.cpass))>
	<cfset form.cpass = url.cpass>
</cfif>
<cfparam name="form.cpass" default="">
<cfif isdefined("form.cpass") and Len(Trim(form.cpass))>
	<cfset form.cambioPass = form.cpass>
</cfif>
<cfparam name="form.cambioPass" default="">


<cfset ExisteCuenta = isdefined("form.cue") and Len(Trim(form.cue))>
<cfset ExistePaquete = isdefined("form.pkg") and Len(Trim(form.pkg))>
<cfset ExisteContacto = isdefined("form.pqc") and Len(Trim(form.pqc))>
<cfset ExisteTrafico = isdefined("form.traf") and Len(Trim(form.traf))>
<cfset ExisteLog = isdefined("form.logg") and Len(Trim(form.logg))>
<cfset ExisteCambioPass = isdefined("form.cpass") and Len(Trim(form.cpass))>

