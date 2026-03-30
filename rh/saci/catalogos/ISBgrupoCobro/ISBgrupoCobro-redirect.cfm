<cfset params="">
<cfset location = "ISBgrupoCobro-edit.cfm">

<cfif isdefined("Form.Pagina") and Len(Trim(Form.Pagina))>
	<cfset params = params & Iif(Len(Trim(params)), DE("&"), DE("?")) & "Pagina=" & Form.Pagina>
</cfif>

<cfif isdefined("Form.filtro_GCcodigo") and Len(Trim(Form.filtro_GCcodigo))>
	<cfset params = params & Iif(Len(Trim(params)), DE("&"), DE("?")) & "filtro_GCcodigo=" & Form.filtro_GCcodigo>
	<cfset params = params & Iif(Len(Trim(params)), DE("&"), DE("?")) & "hfiltro_GCcodigo=" & Form.filtro_GCcodigo>	
</cfif>		
<cfif isdefined("Form.filtro_GCnombre") and Len(Trim(Form.filtro_GCnombre))>
	<cfset params = params & Iif(Len(Trim(params)), DE("&"), DE("?")) & "filtro_GCnombre=" & Form.filtro_GCnombre>
	<cfset params = params & Iif(Len(Trim(params)), DE("&"), DE("?")) & "hfiltro_GCnombre=" & Form.filtro_GCnombre>	
</cfif>

<cfif not IsDefined("form.Regresar") and not IsDefined("form.Baja") and not IsDefined("form.Nuevo")>
	<cfset params = params & Iif(Len(Trim(params)), DE("&"), DE("?")) & "GCcodigo="& Form.GCcodigo>
<cfelse>
	<cfif not IsDefined("form.Nuevo")>
		<cfset location = "ISBgrupoCobro.cfm">	
	</cfif>
</cfif>

<cfset Request.Error.Url="#location#">
<cflocation url="#location##params#">