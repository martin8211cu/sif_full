<cfset params="">
<cfset location = "ISBsolicitudes-edit.cfm">

<cfif isdefined("Form.Pagina") and Len(Trim(Form.Pagina))>
	<cfset params = params & Iif(Len(Trim(params)), DE("&"), DE("?")) & "Pagina=" & Form.Pagina>
</cfif>
<cfif isdefined("Form.filtro_SOfechasol") and Len(Trim(Form.filtro_SOfechasol))>
	<cfset params = params & Iif(Len(Trim(params)), DE("&"), DE("?")) & "filtro_SOfechasol=" & Form.filtro_SOfechasol>
	<cfset params = params & Iif(Len(Trim(params)), DE("&"), DE("?")) & "hfiltro_SOfechasol=" & Form.filtro_SOfechasol>	
</cfif>		
<cfif isdefined("Form.filtro_SOtipo") and Len(Trim(Form.filtro_SOtipo))>
	<cfset params = params & Iif(Len(Trim(params)), DE("&"), DE("?")) & "filtro_SOtipo=" & Form.filtro_SOtipo>
	<cfset params = params & Iif(Len(Trim(params)), DE("&"), DE("?")) & "hfiltro_SOtipo=" & Form.filtro_SOtipo>	
</cfif>
<cfif isdefined("Form.filtro_SOestado") and Len(Trim(Form.filtro_SOestado))>
	<cfset params = params & Iif(Len(Trim(params)), DE("&"), DE("?")) & "filtro_SOestado=" & Form.filtro_SOestado>
	<cfset params = params & Iif(Len(Trim(params)), DE("&"), DE("?")) & "hfiltro_SOestado=" & Form.filtro_SOestado>	
</cfif>
<cfif isdefined("Form.filtro_SOtipoSobre") and Len(Trim(Form.filtro_SOtipoSobre))>
	<cfset params = params & Iif(Len(Trim(params)), DE("&"), DE("?")) & "filtro_SOtipoSobre=" & Form.filtro_SOtipoSobre>
	<cfset params = params & Iif(Len(Trim(params)), DE("&"), DE("?")) & "hfiltro_SOtipoSobre=" & Form.filtro_SOtipoSobre>	
</cfif>
<cfif isdefined("Form.filtro_SOcantidad") and Len(Trim(Form.filtro_SOcantidad))>
	<cfset params = params & Iif(Len(Trim(params)), DE("&"), DE("?")) & "filtro_SOcantidad=" & Form.filtro_SOcantidad>
	<cfset params = params & Iif(Len(Trim(params)), DE("&"), DE("?")) & "hfiltro_SOcantidad=" & Form.filtro_SOcantidad>	
</cfif>

<cfif not IsDefined("form.Regresar") and not IsDefined("form.Baja") and not IsDefined("form.Nuevo")>
	<cfset params = params & Iif(Len(Trim(params)), DE("&"), DE("?")) & "SOid="& Form.SOid>
<cfelse>
	<cfif not IsDefined("form.Nuevo")>
		<cfset location = "ISBsolicitudes.cfm">	
	</cfif>
</cfif>

<cfset Request.Error.Url="#location#">
<cflocation url="#location##params#">