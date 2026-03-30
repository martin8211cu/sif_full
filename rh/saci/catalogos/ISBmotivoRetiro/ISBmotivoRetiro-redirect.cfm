<cfset params="">
<cfset location = "ISBmotivoRetiro-edit.cfm">

<cfif isdefined("Form.Pagina") and Len(Trim(Form.Pagina))>
	<cfset params = params & Iif(Len(Trim(params)), DE("&"), DE("?")) & "Pagina=" & Form.Pagina>
</cfif>

<cfif isdefined("Form.filtro_MRcodigo") and Len(Trim(Form.filtro_MRcodigo))>
	<cfset params = params & Iif(Len(Trim(params)), DE("&"), DE("?")) & "filtro_MRcodigo=" & Form.filtro_MRcodigo>
	<cfset params = params & Iif(Len(Trim(params)), DE("&"), DE("?")) & "hfiltro_MRcodigo=" & Form.filtro_MRcodigo>	
</cfif>		
<cfif isdefined("Form.filtro_MRnombre") and Len(Trim(Form.filtro_MRnombre))>
	<cfset params = params & Iif(Len(Trim(params)), DE("&"), DE("?")) & "filtro_MRnombre=" & Form.filtro_MRnombre>
	<cfset params = params & Iif(Len(Trim(params)), DE("&"), DE("?")) & "hfiltro_MRnombre=" & Form.filtro_MRnombre>	
</cfif>

<cfif not IsDefined("form.Regresar") and not IsDefined("form.Baja") and not IsDefined("form.Nuevo")>
	<cfset params = params & Iif(Len(Trim(params)), DE("&"), DE("?")) & "MRid="& Form.MRid>
<cfelse>
	<cfif not IsDefined("form.Nuevo")>
		<cfset location = "ISBmotivoRetiro.cfm">	
	</cfif>
</cfif>

<cfset Request.Error.Url="#location#">
<cflocation url="#location##params#">