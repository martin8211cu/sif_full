<cfset params="">
<cfset location = "ISBinconsistencias-edit.cfm">

<cfif isdefined("Form.Pagina") and Len(Trim(Form.Pagina))>
	<cfset params = params & Iif(Len(Trim(params)), DE("&"), DE("?")) & "Pagina=" & Form.Pagina>
</cfif>
<cfif isdefined("Form.filtro_Inombre") and Len(Trim(Form.filtro_Inombre))>
	<cfset params = params & Iif(Len(Trim(params)), DE("&"), DE("?")) & "filtro_Inombre=" & Form.filtro_Inombre>
	<cfset params = params & Iif(Len(Trim(params)), DE("&"), DE("?")) & "hfiltro_Inombre=" & Form.filtro_Inombre>	
</cfif>
<cfif isdefined("Form.filtro_Idescripcion") and Len(Trim(Form.filtro_Idescripcion))>
	<cfset params = params & Iif(Len(Trim(params)), DE("&"), DE("?")) & "filtro_Idescripcion=" & Form.filtro_Idescripcion>
	<cfset params = params & Iif(Len(Trim(params)), DE("&"), DE("?")) & "hfiltro_Idescripcion=" & Form.filtro_Idescripcion>	
</cfif>		

<cfif not IsDefined("form.Regresar") and not IsDefined("form.Baja") and not IsDefined("form.Nuevo")>
	<cfset params = params & Iif(Len(Trim(params)), DE("&"), DE("?")) & "Iid="& Form.Iid>
<cfelse>
	<cfif not IsDefined("form.Nuevo")>
		<cfset location = "ISBinconsistencias.cfm">	
	</cfif>
</cfif>

<cfset Request.Error.Url="#location#">
<cflocation url="#location##params#">