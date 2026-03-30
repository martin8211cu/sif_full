<cfset params="">
<cfset location = "ISBinterfazMensaje-edit.cfm">

<cfif isdefined("Form.Pagina") and Len(Trim(Form.Pagina))>
	<cfset params = params & Iif(Len(Trim(params)), DE("&"), DE("?")) & "Pagina=" & Form.Pagina>
</cfif>

<cfif isdefined("Form.filtro_codMensaje") and Len(Trim(Form.filtro_codMensaje))>
	<cfset params = params & Iif(Len(Trim(params)), DE("&"), DE("?")) & "filtro_codMensaje=" & Form.filtro_codMensaje>
	<cfset params = params & Iif(Len(Trim(params)), DE("&"), DE("?")) & "hfiltro_codMensaje=" & Form.filtro_codMensaje>	
</cfif>		
<cfif isdefined("Form.filtro_mensaje") and Len(Trim(Form.filtro_mensaje))>
	<cfset params = params & Iif(Len(Trim(params)), DE("&"), DE("?")) & "filtro_mensaje=" & Form.filtro_mensaje>
	<cfset params = params & Iif(Len(Trim(params)), DE("&"), DE("?")) & "hfiltro_mensaje=" & Form.filtro_mensaje>	
</cfif>		

<cfif not IsDefined("form.Regresar") and not IsDefined("form.Baja") and not IsDefined("form.Nuevo")>
	<cfset params = params & Iif(Len(Trim(params)), DE("&"), DE("?")) & "codMensaje="& Form.codMensaje>
<cfelse>
	<cfif not IsDefined("form.Nuevo")>
		<cfset location = "ISBinterfazMensaje.cfm">	
	</cfif>
</cfif>

<cfset Request.Error.Url="#location#">
<cflocation url="#location##params#">