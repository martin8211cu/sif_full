<cfset params="">
<cfset location = "ISBmedioCia-edit.cfm">

<cfif isdefined("Form.Pagina") and Len(Trim(Form.Pagina))>
	<cfset params = params & Iif(Len(Trim(params)), DE("&"), DE("?")) & "Pagina=" & Form.Pagina>
</cfif>

<cfif isdefined("Form.filtro_EMnombre") and Len(Trim(Form.filtro_EMnombre))>
	<cfset params = params & Iif(Len(Trim(params)), DE("&"), DE("?")) & "filtro_EMnombre=" & Form.filtro_EMnombre>
	<cfset params = params & Iif(Len(Trim(params)), DE("&"), DE("?")) & "hfiltro_EMnombre=" & Form.filtro_EMnombre>	
</cfif>		

<cfif not IsDefined("form.Regresar") and not IsDefined("form.Baja") and not IsDefined("form.Nuevo")>
	<cfset params = params & Iif(Len(Trim(params)), DE("&"), DE("?")) & "EMid="& Form.EMid>
<cfelse>
	<cfif not IsDefined("form.Nuevo")>
		<cfset location = "ISBmedioCia.cfm">	
	</cfif>
</cfif>

<cfset Request.Error.Url="#location#">
<cflocation url="#location##params#">