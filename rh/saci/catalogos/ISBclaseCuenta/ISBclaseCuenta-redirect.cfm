<cfset params="">
<cfset location = "ISBclaseCuenta-edit.cfm">

<cfif isdefined("Form.Pagina") and Len(Trim(Form.Pagina))>
	<cfset params = params & Iif(Len(Trim(params)), DE("&"), DE("?")) & "Pagina=" & Form.Pagina>
</cfif>

<cfif isdefined("Form.filtro_CCclaseCuenta") and Len(Trim(Form.filtro_CCclaseCuenta))>
	<cfset params = params & Iif(Len(Trim(params)), DE("&"), DE("?")) & "filtro_CCclaseCuenta=" & Form.filtro_CCclaseCuenta>
	<cfset params = params & Iif(Len(Trim(params)), DE("&"), DE("?")) & "hfiltro_CCclaseCuenta=" & Form.filtro_CCclaseCuenta>	
</cfif>		
<cfif isdefined("Form.filtro_CCnombre") and Len(Trim(Form.filtro_CCnombre))>
	<cfset params = params & Iif(Len(Trim(params)), DE("&"), DE("?")) & "filtro_CCnombre=" & Form.filtro_CCnombre>
	<cfset params = params & Iif(Len(Trim(params)), DE("&"), DE("?")) & "hfiltro_CCnombre=" & Form.filtro_CCnombre>	
</cfif>

<cfif not IsDefined("form.Regresar") and not IsDefined("form.Baja") and not IsDefined("form.Nuevo")>
	<cfset params = params & Iif(Len(Trim(params)), DE("&"), DE("?")) & "CCclaseCuenta="& Form.CCclaseCuenta>
<cfelse>
	<cfif not IsDefined("form.Nuevo")>
		<cfset location = "ISBclaseCuenta.cfm">	
	</cfif>
</cfif>

<cfset Request.Error.Url="#location#">
<cflocation url="#location##params#">