<cfset params="">
<cfif isdefined("Form.AGidp_Agente") and Len(Trim(Form.AGidp_Agente))>
	<cfset params = params & Iif(Len(Trim(params)), DE("&"), DE("?")) & "ag=" & Form.AGidp_Agente>
</cfif>
<cfif isdefined("Form.filtro_CUECUE") and Len(Trim(Form.filtro_CUECUE))>
	<cfset params = params & Iif(Len(Trim(params)), DE("&"), DE("?")) & "filtro_CUECUE=" & Form.filtro_CUECUE>
</cfif>
<cfif isdefined("Form.filtro_DUENO") and Len(Trim(Form.filtro_DUENO))>
	<cfset params = params & Iif(Len(Trim(params)), DE("&"), DE("?")) & "filtro_DUENO=" & Form.filtro_DUENO>
</cfif>
<cfif isdefined("Form.filtro_VENDEDOR") and Len(Trim(Form.filtro_VENDEDOR))>
	<cfset params = params & Iif(Len(Trim(params)), DE("&"), DE("?")) & "filtro_VENDEDOR=" & Form.filtro_VENDEDOR>
</cfif>
<cfif isdefined("Form.pagina") and Len(Trim(Form.pagina))>
	<cfset params = params & Iif(Len(Trim(params)), DE("&"), DE("?")) & "pagina=" & Form.pagina>
</cfif>

<cfif isdefined("Form.quitar") and Len(Trim(Form.quitar)) and form.quitar NEQ '-1'>
	<cfset location = "seguimiento_lista.cfm">
<cfelse>
	<cfset location = "seguimiento.cfm">
</cfif>

<cfset Request.Error.Url="#location#">

<cflocation url="#location##params#">
