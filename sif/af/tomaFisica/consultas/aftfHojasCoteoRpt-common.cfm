<cfsilent>

<!---VARIABLE LLAVE DEL PROCESO --->
<cfif isdefined("url.AFTFid_hoja") and len(trim(url.AFTFid_hoja))>
	<cfset form.AFTFid_hoja = url.AFTFid_hoja>
</cfif>
<!--- VARIABLE DE PAGINA PARA CUANDO VIENE DE LA PANTALLA DE MANTENIMIENTO O DEL BORRADO DEL SQL DE LA PANTALLA DE MANTENIMIENTO--->
<cfif isdefined("url.Pagina") and len(trim(url.Pagina))>
	<cfset form.Pagina = url.Pagina>
</cfif>
<!--- VARIABLE DE PAGINA PARA CUANDO VIENE DEL CLICK EN LA NAVEGACION--->
<cfif isdefined("url.PageNum_Lista") and len(trim(url.PageNum_Lista))>
	<cfset form.Pagina = url.PageNum_Lista>
</cfif>
<!--- VARIABLE DE PAGINA PARA CUANDO VIENE DEL CLICK EN LA LISTA--->
<cfif isdefined("form.PageNum") and len(trim(form.PageNum))>
	<cfset form.Pagina = form.PageNum>
</cfif>
<cfif isdefined("form.Pagina") and len(trim(form.Pagina)) eq 0>
	<!--- CUANDO LE DAN CLICK AL FILTRAR EXISTE EL CAMPO PAGINA EN EL FORM PERO ESTÁ VACÍO PORQQUE EL CAMPO SE LLENA CUAND LE DAN CLICK A LA LISTA Y NO LE DIERON CLIK --->
	<cfset form.Pagina = 1>
</cfif>
<!--- VARIABLES DE FILTROS PARA CUANDO VIENE DE LA PANTALLA O DE LA NAVEGACIÓN --->
<cfif isdefined("url.Filtro_AFTFdescripcion_hoja") and len(trim(url.Filtro_AFTFdescripcion_hoja))>
	<cfset form.Filtro_AFTFdescripcion_hoja = url.Filtro_AFTFdescripcion_hoja>
</cfif>
<cfif isdefined("url.Filtro_AFTFfecha_hoja") and len(trim(url.Filtro_AFTFfecha_hoja))>
	<cfset form.Filtro_AFTFfecha_hoja = url.Filtro_AFTFfecha_hoja>
</cfif>
<cfif isdefined("url.Filtro_AFTFfecha_conteo_hoja") and len(trim(url.Filtro_AFTFfecha_conteo_hoja))>
	<cfset form.Filtro_AFTFfecha_conteo_hoja = url.Filtro_AFTFfecha_conteo_hoja>
</cfif>
<cfif isdefined("url.Filtro_AFTFestatus_hoja") and len(trim(url.Filtro_AFTFestatus_hoja))>
	<cfset form.Filtro_AFTFestatus_hoja = url.Filtro_AFTFestatus_hoja>
</cfif>
<cfif isdefined("url.Filtro_FechasMayores") and len(trim(url.Filtro_FechasMayores))>
	<cfset form.Filtro_FechasMayores = url.Filtro_FechasMayores>
</cfif>

<!--- VALORES POR DEFECTO DE LAS VARIBLES REQUERIDAS PORQUE SIEMPRE SE USAN EN EL FORM PARA ENVIARLAS AL SQL --->
<cfparam name="form.Pagina" default="1">
<cfparam name="form.Filtro_AFTFdescripcion_hoja" default="">
<cfparam name="form.Filtro_AFTFfecha_hoja" default="">
<cfparam name="form.Filtro_AFTFfecha_conteo_hoja" default="">
<cfparam name="form.Filtro_AFTFestatus_hoja" default="">	

<!--- Variable para enviar navegacion a lista de detalles, en la navegacion y en el filtrar --->
<cfset Gvar_navegacion_Lista1 = "">
<cfset Gvar_navegacion_Lista1=ListAppend(Gvar_navegacion_Lista1,"Pagina="&Form.Pagina,"&")>
<cfset Gvar_navegacion_Lista1=ListAppend(Gvar_navegacion_Lista1,"Filtro_AFTFdescripcion_hoja="&Form.Filtro_AFTFdescripcion_hoja,"&")>
<cfset Gvar_navegacion_Lista1=ListAppend(Gvar_navegacion_Lista1,"Filtro_AFTFfecha_hoja="&Form.Filtro_AFTFfecha_hoja,"&")>
<cfset Gvar_navegacion_Lista1=ListAppend(Gvar_navegacion_Lista1,"Filtro_AFTFfecha_conteo_hoja="&Form.Filtro_AFTFfecha_conteo_hoja,"&")>
<cfset Gvar_navegacion_Lista1=ListAppend(Gvar_navegacion_Lista1,"Filtro_AFTFestatus_hoja="&Form.Filtro_AFTFestatus_hoja,"&")>

<cfset Gvar_navegacion_Lista1=ListAppend(Gvar_navegacion_Lista1,"HFiltro_AFTFdescripcion_hoja="&Form.Filtro_AFTFdescripcion_hoja,"&")>
<cfset Gvar_navegacion_Lista1=ListAppend(Gvar_navegacion_Lista1,"HFiltro_AFTFfecha_hoja="&Form.Filtro_AFTFfecha_hoja,"&")>
<cfset Gvar_navegacion_Lista1=ListAppend(Gvar_navegacion_Lista1,"HFiltro_AFTFfecha_conteo_hoja="&Form.Filtro_AFTFfecha_conteo_hoja,"&")>
<cfset Gvar_navegacion_Lista1=ListAppend(Gvar_navegacion_Lista1,"HFiltro_AFTFestatus_hoja="&Form.Filtro_AFTFestatus_hoja,"&")>

<cfif isdefined("form.Filtro_FechasMayores") and len(trim(form.Filtro_FechasMayores))>
	<cfset Gvar_navegacion_Lista1=ListAppend(Gvar_navegacion_Lista1,"Filtro_FechasMayores="&Form.Filtro_FechasMayores,"&")>
</cfif>

<!--- QUERY PARA COMBO DE ESTADOS --->
<!--- create a query, specify data types for each column --->
<cfset rsAFTFestatus_hoja = queryNew("value,description", "CF_SQL_INTEGER, CF_SQL_VARCHAR")>

<!--- add rows --->
<cfset newrow = queryaddrow(rsAFTFestatus_hoja, 1)>
<cfset QuerySetCell(rsAFTFestatus_hoja,"value","",rsAFTFestatus_hoja.recordcount)>
<cfset QuerySetCell(rsAFTFestatus_hoja,"description","--Todos--",rsAFTFestatus_hoja.recordcount)>

<cfset newrow = queryaddrow(rsAFTFestatus_hoja, 1)>
<cfset QuerySetCell(rsAFTFestatus_hoja,"value",0,rsAFTFestatus_hoja.recordcount)>
<cfset QuerySetCell(rsAFTFestatus_hoja,"description","En Generación de Hoja",rsAFTFestatus_hoja.recordcount)>

<cfquery name="rsValidaDispositivoMovil" datasource="#session.dsn#">
	select 1 
	from AFTFDispositivo
	where CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.CEcodigo#">
	and AFTFestatus_dispositivo =  1
</cfquery>
<cfif rsValidaDispositivoMovil.recordcount gt 0>
	<cfset newrow = queryaddrow(rsAFTFestatus_hoja, 1)>
	<cfset QuerySetCell(rsAFTFestatus_hoja,"value",1,rsAFTFestatus_hoja.recordcount)>
	<cfset QuerySetCell(rsAFTFestatus_hoja,"description","En Dispositivo Móvil",rsAFTFestatus_hoja.recordcount)>
</cfif>

<cfset newrow = queryaddrow(rsAFTFestatus_hoja, 1)>
<cfset QuerySetCell(rsAFTFestatus_hoja,"value",2,rsAFTFestatus_hoja.recordcount)>
<cfset QuerySetCell(rsAFTFestatus_hoja,"description","En Proceso de Inventario",rsAFTFestatus_hoja.recordcount)>

<cfset newrow = queryaddrow(rsAFTFestatus_hoja, 1)>
<cfset QuerySetCell(rsAFTFestatus_hoja,"value",3,rsAFTFestatus_hoja.recordcount)>
<cfset QuerySetCell(rsAFTFestatus_hoja,"description","Aplicada",rsAFTFestatus_hoja.recordcount)>

<cfset newrow = queryaddrow(rsAFTFestatus_hoja, 1)>
<cfset QuerySetCell(rsAFTFestatus_hoja,"value",9,rsAFTFestatus_hoja.recordcount)>
<cfset QuerySetCell(rsAFTFestatus_hoja,"description","Cancelada",rsAFTFestatus_hoja.recordcount)>

</cfsilent>