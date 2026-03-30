<cfset params="">
<cfif isdefined("Form.paso") and Len(Trim(Form.paso))>
	<cfset params = params & Iif(Len(Trim(params)), DE("&"), DE("?")) & "paso=" & Form.paso>
</cfif>
<cfif isdefined("Form.CTid") and Len(Trim(Form.CTid))>
	<cfset params = params & Iif(Len(Trim(params)), DE("&"), DE("?")) & "cue=" & Form.CTid>
</cfif>
<cfif isdefined("Form.Pquien") and Len(Trim(Form.Pquien))>
	<cfset params = params & Iif(Len(Trim(params)), DE("&"), DE("?")) & "pq=" & Form.Pquien>
</cfif>
<cfif isdefined("Form.Contratoid") and Len(Trim(Form.Contratoid))>
	<cfset params = params & Iif(Len(Trim(params)), DE("&"), DE("?")) & "contra=" & Form.Contratoid>
</cfif>
<cfif isdefined("Form.AGid") and Len(Trim(Form.AGid))>
	<cfset params = params & Iif(Len(Trim(params)), DE("&"), DE("?")) & "ag=" & Form.AGid>
</cfif>
<cfif isdefined("Form.CTidFactura") and Len(Trim(Form.CTidFactura))>
	<cfset params = params & Iif(Len(Trim(params)), DE("&"), DE("?")) & "fact=" & Form.CTidFactura>
</cfif>
<cfif isdefined("Form.PQcodigo") and Len(Trim(Form.PQcodigo))>
	<cfset params = params & Iif(Len(Trim(params)), DE("&"), DE("?")) & "paq=" & Form.PQcodigo>
</cfif>
<cfif isdefined("Form.filtro_propietario") and Len(Trim(Form.filtro_propietario))>
	<cfset params = params & Iif(Len(Trim(params)), DE("&"), DE("?")) & "filtro_propietario=" & Form.filtro_propietario>
</cfif>
	
<cfif isdefined("ExtraParams") and len(trim(ExtraParams))>
	<cfset params = params & Iif(Len(Trim(params)), DE("&"), DE("?")) & ExtraParams>
</cfif>

<cfset location = "aprobacion.cfm">
<cfset Request.Error.Url="#location#">

<cflocation url="#location##params#">
