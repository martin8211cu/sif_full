<cfif isdefined("url.PageNum_listaroot") and Len(Trim(url.PageNum_listaroot))>
	<cfset form.PageNum_listaroot = url.PageNum_listaroot>
<cfelseif isdefined("url.PageNumroot") and Len(Trim(url.PageNumroot))>
	<cfset form.PageNum_listaroot = url.PageNumroot>
</cfif>
<cfparam name="form.PageNum_listaroot" default="1">

<cfif isdefined("url.Filtro_Ppersoneria") and Len(Trim(url.Filtro_Ppersoneria))>
	<cfset form.Filtro_Ppersoneria = url.Filtro_Ppersoneria>
</cfif>
<cfparam name="form.Filtro_Ppersoneria" default="">

<cfif isdefined("url.Filtro_Pid") and Len(Trim(url.Filtro_Pid))>
	<cfset form.Filtro_Pid = url.Filtro_Pid>
</cfif>
<cfparam name="form.Filtro_Pid" default="">

<cfif isdefined("url.Filtro_nom_razon") and Len(Trim(url.Filtro_nom_razon))>
	<cfset form.Filtro_nom_razon = url.Filtro_nom_razon>
</cfif>
<cfparam name="form.Filtro_nom_razon" default="">

<cfif isdefined("url.Filtro_Habilitado") and Len(Trim(url.Filtro_Habilitado))>
	<cfset form.Filtro_Habilitado = url.Filtro_Habilitado>
</cfif>
<cfparam name="form.Filtro_Habilitado" default="">


<cfif isdefined("url.Filtro_AAinterno") and Len(Trim(url.Filtro_AAinterno))>
	<cfset form.Filtro_AAinterno = url.Filtro_AAinterno>
</cfif>
<cfparam name="form.Filtro_AAinterno" default="">
