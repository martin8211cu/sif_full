<cfif isdefined("url.PageNum_listaroot") and Len(Trim(url.PageNum_listaroot))>
	<cfset form.PageNum_listaroot = url.PageNum_listaroot>
<cfelseif isdefined("url.PageNumroot") and Len(Trim(url.PageNumroot))>
	<cfset form.PageNum_listaroot = url.PageNumroot>
</cfif>
<cfparam name="form.PageNum_listaroot" default="1">
<cfset params = params & Iif(Len(Trim(params)), DE("&"), DE("")) & "PageNum_listaroot=" & form.PageNum_listaroot>

<cfif isdefined("url.Filtro_Ppersoneria") and Len(Trim(url.Filtro_Ppersoneria))>
	<cfset form.Filtro_Ppersoneria = url.Filtro_Ppersoneria>
</cfif>
<cfparam name="form.Filtro_Ppersoneria" default="">
<cfset params = params & Iif(Len(Trim(params)), DE("&"), DE("")) & "Filtro_Ppersoneria=" & form.Filtro_Ppersoneria>
<cfset params = params & Iif(Len(Trim(params)), DE("&"), DE("")) & "hFiltro_Ppersoneria=" & form.Filtro_Ppersoneria>

<cfif isdefined("url.Filtro_Pid") and Len(Trim(url.Filtro_Pid))>
	<cfset form.Filtro_Pid = url.Filtro_Pid>
</cfif>
<cfparam name="form.Filtro_Pid" default="">
<cfset params = params & Iif(Len(Trim(params)), DE("&"), DE("")) & "Filtro_Pid=" & form.Filtro_Pid>
<cfset params = params & Iif(Len(Trim(params)), DE("&"), DE("")) & "hFiltro_Pid=" & form.Filtro_Pid>

<cfif isdefined("url.Filtro_nom_razon") and Len(Trim(url.Filtro_nom_razon))>
	<cfset form.Filtro_nom_razon = url.Filtro_nom_razon>
</cfif>
<cfparam name="form.Filtro_nom_razon" default="">
<cfset params = params & Iif(Len(Trim(params)), DE("&"), DE("")) & "Filtro_nom_razon=" & form.Filtro_nom_razon>
<cfset params = params & Iif(Len(Trim(params)), DE("&"), DE("")) & "hFiltro_nom_razon=" & form.Filtro_nom_razon>

<cfif isdefined("url.Filtro_Habilitado") and Len(Trim(url.Filtro_Habilitado))>
	<cfset form.Filtro_Habilitado = url.Filtro_Habilitado>
</cfif>
<cfparam name="form.Filtro_Habilitado" default="">
<cfset params = params & Iif(Len(Trim(params)), DE("&"), DE("")) & "Filtro_Habilitado=" & form.Filtro_Habilitado>
<cfset params = params & Iif(Len(Trim(params)), DE("&"), DE("")) & "hFiltro_Habilitado=" & form.Filtro_Habilitado>
