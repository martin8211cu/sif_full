<cfset params = "tab=" & form.tab>
<cfset params = params & Iif(Len(Trim(params)), DE("&"), DE("")) & "paso=" & form.paso>
<cfset params = params & Iif(Len(Trim(params)), DE("&"), DE("")) & "ag=" & form.AGid>

<cfif isdefined('form.CTid')>
	<cfset params = params & Iif(Len(Trim(params)), DE("&"), DE("")) & "cue=" & form.CTid>
</cfif>
<cfset params = params & Iif(Len(Trim(params)), DE("&"), DE("")) & "tipo=" & form.tipo>

<cfif isdefined('form.ANid') and form.ANid NEQ ''>
	<cfset params = params & Iif(Len(Trim(params)), DE("&"), DE("")) & "ANid=" & form.ANid>
</cfif>
<cfset params = params & Iif(Len(Trim(params)), DE("&"), DE("")) & "PageNum_listaroot=" & form.PageNum_listaroot>
<cfset params = params & Iif(Len(Trim(params)), DE("&"), DE("")) & "Filtro_Ppersoneria=" & form.Filtro_Ppersoneria>
<cfset params = params & Iif(Len(Trim(params)), DE("&"), DE("")) & "hFiltro_Ppersoneria=" & form.Filtro_Ppersoneria>
<cfset params = params & Iif(Len(Trim(params)), DE("&"), DE("")) & "Filtro_Pid=" & form.Filtro_Pid>
<cfset params = params & Iif(Len(Trim(params)), DE("&"), DE("")) & "hFiltro_Pid=" & form.Filtro_Pid>
<cfset params = params & Iif(Len(Trim(params)), DE("&"), DE("")) & "Filtro_nom_razon=" & form.Filtro_nom_razon>
<cfset params = params & Iif(Len(Trim(params)), DE("&"), DE("")) & "hFiltro_nom_razon=" & form.Filtro_nom_razon>
<cfset params = params & Iif(Len(Trim(params)), DE("&"), DE("")) & "Filtro_Habilitado=" & form.Filtro_Habilitado>
<cfset params = params & Iif(Len(Trim(params)), DE("&"), DE("")) & "hFiltro_Habilitado=" & form.Filtro_Habilitado>

<cfif isdefined("ExtraParams") and len(trim(ExtraParams))>
	<cfset params = params & Iif(Len(Trim(params)), DE("&"), DE("")) & ExtraParams>
</cfif>

<cfif isdefined("Form.Eliminar") and tab eq 1>
	<cfset params = "">
</cfif>
<cfif isdefined("form.tipo") and form.tipo eq 'Externo'>
	<cfset Request.Error.Url = "agente.cfm?#params#">
	<cfset Request.redirect = "agente.cfm?#params#">
<cfelse>
	<cfset Request.Error.Url = "agente_interno.cfm?#params#">
	<cfset Request.redirect = "agente_interno.cfm?#params#">
	
</cfif>
