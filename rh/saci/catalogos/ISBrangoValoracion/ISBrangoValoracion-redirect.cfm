<cfset params="">
<cfset location = "ISBrangoValoracion-edit.cfm">

<cfif isdefined("Form.Pagina") and Len(Trim(Form.Pagina))>
	<cfset params = params & Iif(Len(Trim(params)), DE("&"), DE("?")) & "Pagina=" & Form.Pagina>
</cfif>
<cfif isdefined("Form.filtro_rangodes") and Len(Trim(Form.filtro_rangodes))>
	<cfset params = params & Iif(Len(Trim(params)), DE("&"), DE("?")) & "filtro_rangodes=" & Form.filtro_rangodes>
	<cfset params = params & Iif(Len(Trim(params)), DE("&"), DE("?")) & "hfiltro_rangodes=" & Form.filtro_rangodes>	
</cfif>
<cfif isdefined("Form.filtro_rangotope") and Len(Trim(Form.filtro_rangotope))>
	<cfset params = params & Iif(Len(Trim(params)), DE("&"), DE("?")) & "filtro_rangotope=" & Form.filtro_rangotope>
	<cfset params = params & Iif(Len(Trim(params)), DE("&"), DE("?")) & "hfiltro_rangotope=" & Form.filtro_rangotope>	
</cfif>		

<cfif not IsDefined("form.Regresar") and not IsDefined("form.Baja") and not IsDefined("form.Nuevo")>
	<cfset params = params & Iif(Len(Trim(params)), DE("&"), DE("?")) & "rangoid="& Form.rangoid>
<cfelse>
	<cfif not IsDefined("form.Nuevo")>
		<cfset location = "ISBrangoValoracion.cfm">	
	</cfif>
</cfif>

<cfset Request.Error.Url="#location#">
<cflocation url="#location##params#">