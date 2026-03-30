<cfset params="">

<cfif isdefined("Form.Pquien_CT") and Len(Trim(Form.Pquien_CT))>
	<cfset params = params & Iif(Len(Trim(params)), DE("&"), DE("?")) & "pqc=" & Form.Pquien_CT>
<cfelseif isdefined("Form.pqc") and Len(Trim(Form.pqc))>
	<cfset params = params & Iif(Len(Trim(params)), DE("&"), DE("?")) & "pqc=" & Form.pqc>
</cfif>

<cfif isdefined("Form.CTid") and Len(Trim(Form.CTid))>
	<cfset params = params & Iif(Len(Trim(params)), DE("&"), DE("?")) & "cue=" & Form.CTid>
<cfelseif isdefined("Form.cue") and Len(Trim(Form.cue))>
	<cfset params = params & Iif(Len(Trim(params)), DE("&"), DE("?")) & "cue=" & Form.cue>
</cfif>

<cfif isdefined("Form.Contratoid") and Len(Trim(Form.Contratoid))>
	<cfset params = params & Iif(Len(Trim(params)), DE("&"), DE("?")) & "pkg=" & Form.Contratoid>
<cfelseif isdefined("Form.pkg") and Len(Trim(Form.pkg))>
	<cfset params = params & Iif(Len(Trim(params)), DE("&"), DE("?")) & "pkg=" & Form.pkg>
</cfif>

<cfif isdefined("Form.LGnumero") and Len(Trim(Form.LGnumero))>
	<cfset params = params & Iif(Len(Trim(params)), DE("&"), DE("?")) & "logg=" & Form.LGnumero>
<cfelseif isdefined("Form.logg") and Len(Trim(Form.logg))>
	<cfset params = params & Iif(Len(Trim(params)), DE("&"), DE("?")) & "logg=" & Form.logg>
</cfif>

<cfif isdefined("Form.rol") and Len(Trim(Form.rol))>
	<cfset params = params & Iif(Len(Trim(params)), DE("&"), DE("?")) & "rol=" & Form.rol>
</cfif>

<cfif isdefined("Form.cliente") and Len(Trim(Form.cliente))>
	<cfset params = params & Iif(Len(Trim(params)), DE("&"), DE("?")) & "cli=" & Form.cliente>
<cfelseif isdefined("Form.cli") and Len(Trim(Form.cli))>
	<cfset params = params & Iif(Len(Trim(params)), DE("&"), DE("?")) & "cli=" & Form.cli>
</cfif>

<cfif isdefined("Form.paso") and Len(Trim(Form.paso))>
	<cfset params = params & Iif(Len(Trim(params)), DE("&"), DE("?")) & "paso=" & Form.paso>
<cfelseif isdefined("url.paso") and Len(Trim(url.paso))>
	<cfset params = params & Iif(Len(Trim(params)), DE("&"), DE("?")) & "paso=" & url.paso>
</cfif>


<cfif isdefined("ExtraParams") and Len(Trim(ExtraParams))>
	<cfset params = params & Iif(Len(Trim(params)), DE("&"), DE("?"))& ExtraParams>
</cfif>

<cfset location = "gestion.cfm">
<cfset Request.Error.Url="#location#">

<cflocation url="#location##params#">
