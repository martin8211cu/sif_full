<cfparam name="CurrentPage" default="#GetFileFromPath(GetTemplatePath())#">

<cfif isdefined("url.tab") and Len(Trim(url.tab))>
	<cfset form.tab = url.tab>
</cfif>
<cfparam name="form.tab" default="1">
<cfset params = "tab=" & form.tab>

<cfif isdefined("url.PQcodigo") and Len(Trim(url.PQcodigo))>
	<cfset form.PQcodigo = url.PQcodigo>
</cfif>
<cfparam name="form.PQcodigo" default="">
<cfset params = params & Iif(Len(Trim(params)), DE("&"), DE("")) & "PQcodigo=" & form.PQcodigo>
<cfset ExistePaquete = isdefined("form.PQcodigo") and Len(Trim(form.PQcodigo))>

<cfif isdefined("url.PageNum_listaroot") and Len(Trim(url.PageNum_listaroot))>
	<cfset form.PageNum_listaroot = url.PageNum_listaroot>
<cfelseif isdefined("url.PageNumroot") and Len(Trim(url.PageNumroot))>
	<cfset form.PageNum_listaroot = url.PageNumroot>
</cfif>
<cfparam name="form.PageNum_listaroot" default="1">
<cfset params = params & Iif(Len(Trim(params)), DE("&"), DE("")) & "PageNum_listaroot=" & form.PageNum_listaroot>

<cfif isdefined("url.Filtro_PQnombre") and Len(Trim(url.Filtro_PQnombre))>
	<cfset form.Filtro_PQnombre = url.Filtro_PQnombre>
</cfif>
<cfparam name="form.Filtro_PQnombre" default="">
<cfset params = params & Iif(Len(Trim(params)), DE("&"), DE("")) & "Filtro_PQnombre=" & form.Filtro_PQnombre>
<cfset params = params & Iif(Len(Trim(params)), DE("&"), DE("")) & "hFiltro_PQnombre=" & form.Filtro_PQnombre>

<cfif isdefined("url.Filtro_PQdescripcion") and Len(Trim(url.Filtro_PQdescripcion))>
	<cfset form.Filtro_PQdescripcion = url.Filtro_PQdescripcion>
</cfif>
<cfparam name="form.Filtro_PQdescripcion" default="">
<cfset params = params & Iif(Len(Trim(params)), DE("&"), DE("")) & "Filtro_PQdescripcion=" & form.Filtro_PQdescripcion>
<cfset params = params & Iif(Len(Trim(params)), DE("&"), DE("")) & "hFiltro_PQdescripcion=" & form.Filtro_PQdescripcion>

<cfquery datasource="#session.dsn#" name="data">
	select a.PQcodigo, a.Ecodigo, a.Miso4217, a.MRidMayorista, a.PQnombre, a.PQdescripcion, a.PQinicio, a.PQcierre, a.PQcomisionTipo, 
		   a.PQcomisionPctj, a.PQcomisionMnto, a.PQtoleranciaGarantia, a.PQtarifaBasica, a.PQcompromiso, a.PQhorasBasica, a.PQprecioExc, 
		   a.Habilitado, a.PQroaming, a.PQmailQuota, a.PQinterfaz, a.PQtelefono, a.BMUsucodigo, a.ts_rversion, a.PQmaxSession, a.CINCAT
		   , PQtransaccion, PQagrupa, TRANUC, PQadelanto, PQautogestion	, PQutilizadoagente, coalesce(PQpagodeposito,'F') as PQpagodeposito	   
	from ISBpaquete a
	where a.PQcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#form.PQcodigo#" null="#Len(form.PQcodigo) Is 0#">
</cfquery>
