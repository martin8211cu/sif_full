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
<cfif isdefined("Form.AGid") and Len(Trim(Form.AGid))>
	<cfset params = params & Iif(Len(Trim(params)), DE("&"), DE("?")) & "ag=" & Form.AGid>
</cfif>

<cfif isdefined("Form.quitar") and Len(Trim(Form.quitar)) and form.quitar NEQ '-1'>
	<cfset location = "seguimiento_lista.cfm">
<cfelse>
	<cfset location = "seguimiento.cfm">
</cfif>

<cfset Request.Error.Url="#location#">

<cflocation url="#location##params#">
