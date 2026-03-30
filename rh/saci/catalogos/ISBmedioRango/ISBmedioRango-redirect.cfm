<cfset params="">
<cfset location = "ISBmedioRango-edit.cfm">

<cfif isdefined("Form.Pagina") and Len(Trim(Form.Pagina))>
	<cfset params = params & Iif(Len(Trim(params)), DE("&"), DE("?")) & "Pagina=" & Form.Pagina>
</cfif>
<cfif isdefined("Form.filtro_access_server") and Len(Trim(Form.filtro_access_server))>
	<cfset params = params & Iif(Len(Trim(params)), DE("&"), DE("?")) & "filtro_access_server=" & Form.filtro_access_server>
	<cfset params = params & Iif(Len(Trim(params)), DE("&"), DE("?")) & "hfiltro_access_server=" & Form.filtro_access_server>	
</cfif>		
<cfif isdefined("Form.filtro_MRdesde") and Len(Trim(Form.filtro_MRdesde))>
	<cfset params = params & Iif(Len(Trim(params)), DE("&"), DE("?")) & "filtro_MRdesde=" & Form.filtro_MRdesde>
	<cfset params = params & Iif(Len(Trim(params)), DE("&"), DE("?")) & "hfiltro_MRdesde=" & Form.filtro_MRdesde>	
</cfif>
<cfif isdefined("Form.filtro_MRhasta") and Len(Trim(Form.filtro_MRhasta))>
	<cfset params = params & Iif(Len(Trim(params)), DE("&"), DE("?")) & "filtro_MRhasta=" & Form.filtro_MRhasta>
	<cfset params = params & Iif(Len(Trim(params)), DE("&"), DE("?")) & "hfiltro_MRhasta=" & Form.filtro_MRhasta>	
</cfif>

<cfif not IsDefined("form.Regresar") and not IsDefined("form.Baja") and not IsDefined("form.Nuevo")>
	<cfset params = params & Iif(Len(Trim(params)), DE("&"), DE("?")) & "MRid="& Form.MRid>
<cfelse>
	<cfif not IsDefined("form.Nuevo")>
		<cfset location = "ISBmedioRango.cfm">	
	</cfif>
</cfif>

<cfset Request.Error.Url="#location#">
<cflocation url="#location##params#">