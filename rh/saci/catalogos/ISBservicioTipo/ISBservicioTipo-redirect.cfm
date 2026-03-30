<cfset params="">
<cfset location = "ISBservicioTipo-edit.cfm">

<cfif isdefined("Form.Pagina") and Len(Trim(Form.Pagina))>
	<cfset params = params & Iif(Len(Trim(params)), DE("&"), DE("?")) & "Pagina=" & Form.Pagina>
</cfif>

<cfif isdefined("Form.filtro_TScodigo") and Len(Trim(Form.filtro_TScodigo))>
	<cfset params = params & Iif(Len(Trim(params)), DE("&"), DE("?")) & "filtro_TScodigo=" & Form.filtro_TScodigo>
	<cfset params = params & Iif(Len(Trim(params)), DE("&"), DE("?")) & "hfiltro_TScodigo=" & Form.filtro_TScodigo>	
</cfif>		
<cfif isdefined("Form.filtro_TSnombre") and Len(Trim(Form.filtro_TSnombre))>
	<cfset params = params & Iif(Len(Trim(params)), DE("&"), DE("?")) & "filtro_TSnombre=" & Form.filtro_TSnombre>
	<cfset params = params & Iif(Len(Trim(params)), DE("&"), DE("?")) & "hfiltro_TSnombre=" & Form.filtro_TSnombre>	
</cfif>
<cfif isdefined("Form.filtro_TSdescripcion") and Len(Trim(Form.filtro_TSdescripcion))>
	<cfset params = params & Iif(Len(Trim(params)), DE("&"), DE("?")) & "filtro_TSdescripcion=" & Form.filtro_TSdescripcion>
	<cfset params = params & Iif(Len(Trim(params)), DE("&"), DE("?")) & "hfiltro_TSdescripcion=" & Form.filtro_TSdescripcion>	
</cfif>

<cfif not IsDefined("form.Regresar") and not IsDefined("form.Baja") and not IsDefined("form.Nuevo")>
	<cfset params = params & Iif(Len(Trim(params)), DE("&"), DE("?")) & "TScodigo="& Form.TScodigo>
<cfelse>
	<cfif not IsDefined("form.Nuevo")>
		<cfset location = "ISBservicioTipo.cfm">	
	</cfif>
</cfif>

<cfset Request.Error.Url="#location#">
<cflocation url="#location##params#">