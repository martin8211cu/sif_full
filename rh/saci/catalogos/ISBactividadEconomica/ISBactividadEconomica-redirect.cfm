<cfset params="">
<cfset location = "ISBactividadEconomica-edit.cfm">

<cfif isdefined("Form.Pagina") and Len(Trim(Form.Pagina))>
	<cfset params = params & Iif(Len(Trim(params)), DE("&"), DE("?")) & "Pagina=" & Form.Pagina>
</cfif>
<cfif isdefined("Form.filtro_AEactividad") and Len(Trim(Form.filtro_AEactividad))>
	<cfset params = params & Iif(Len(Trim(params)), DE("&"), DE("?")) & "filtro_AEactividad=" & Form.filtro_AEactividad>
	<cfset params = params & Iif(Len(Trim(params)), DE("&"), DE("?")) & "hfiltro_AEactividad=" & Form.filtro_AEactividad>	
</cfif>		
<cfif isdefined("Form.filtro_AEnombre") and Len(Trim(Form.filtro_AEnombre))>
	<cfset params = params & Iif(Len(Trim(params)), DE("&"), DE("?")) & "filtro_AEnombre=" & Form.filtro_AEnombre>
	<cfset params = params & Iif(Len(Trim(params)), DE("&"), DE("?")) & "hfiltro_AEnombre=" & Form.filtro_AEnombre>	
</cfif>

<cfif not IsDefined("form.Regresar") and not IsDefined("form.Baja") and not IsDefined("form.Nuevo")>
	<cfset params = params & Iif(Len(Trim(params)), DE("&"), DE("?")) & "AEactividad="& Form.AEactividad>
<cfelse>
	<cfif not IsDefined("form.Nuevo")>
		<cfset location = "ISBactividadEconomica.cfm">	
	</cfif>
</cfif>

<cfset Request.Error.Url="#location#">
<cflocation url="#location##params#">