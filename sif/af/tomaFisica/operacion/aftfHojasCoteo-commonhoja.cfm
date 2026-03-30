<cfsilent>

<cfparam name="request.calledFromSQL" default="false">

<!--- VARIABLE DE Pagina2 PARA CUANDO VIENE DE LA PANTALLA DE MANTENIMIENTO O DEL BORRADO DEL SQL DE LA PANTALLA DE MANTENIMIENTO--->
<cfif isdefined("url.Pagina2") and len(trim(url.Pagina2))>
	<cfset form.Pagina2 = url.Pagina2>
</cfif>
<!--- VARIABLE DE Pagina2 PARA CUANDO VIENE DEL CLICK EN LA NAVEGACION--->
<cfif isdefined("url.PageNum_Lista2") and len(trim(url.PageNum_Lista2))>
	<cfset form.Pagina2 = url.PageNum_Lista2>
</cfif>
<!--- VARIABLE DE Pagina2 PARA CUANDO VIENE DEL CLICK EN LA LISTA--->
<cfif isdefined("form.PageNum2") and len(trim(form.PageNum2))>
	<cfset form.Pagina2 = form.PageNum2>
</cfif>
<cfif isdefined("form.Pagina2") and len(trim(form.Pagina2)) eq 0>
	<!--- CUANDO LE DAN CLICK AL FILTRAR EXISTE EL CAMPO Pagina2 EN EL FORM PERO ESTÁ VACÍO PORQQUE EL CAMPO SE LLENA CUAND LE DAN CLICK A LA LISTA Y NO LE DIERON CLIK --->
	<cfset form.Pagina2 = 1>
</cfif>
<!--- VARIABLES DE FILTROS PARA CUANDO VIENE DE LA PANTALLA O DE LA NAVEGACIÓN --->
<cfif isdefined("url.Filtro_Aplaca") and len(trim(url.Filtro_Aplaca))>
	<cfset form.Filtro_Aplaca = url.Filtro_Aplaca>
</cfif>
<cfif isdefined("url.Filtro_Aserie") and len(trim(url.Filtro_Aserie))>
	<cfset form.Filtro_Aserie = url.Filtro_Aserie>
</cfif>
<cfif isdefined("url.Filtro_Adescripcion") and len(trim(url.Filtro_Adescripcion))>
	<cfset form.Filtro_Adescripcion = url.Filtro_Adescripcion>
</cfif>
<cfif isdefined("url.Filtro_Estatus") and len(trim(url.Filtro_Estatus))>
	<cfset form.Filtro_Estatus = url.Filtro_Estatus>
</cfif>
<cfif isdefined("url.Filtro_DEidentificacion") and len(trim(url.Filtro_DEidentificacion))>
	<cfset form.Filtro_DEidentificacion = url.Filtro_DEidentificacion>
</cfif>
<cfif isdefined("url.Filtro_CFdescripcion") and len(trim(url.Filtro_CFdescripcion))>
	<cfset form.Filtro_CFdescripcion = url.Filtro_CFdescripcion>
</cfif>
<cfif isdefined("url.Filtro_Ver") and len(trim(url.Filtro_Ver))>
	<cfset form.Filtro_Ver = url.Filtro_Ver>
</cfif>

<!--- VALORES POR DEFECTO DE LAS VARIBLES REQUERIDAS PORQUE SIEMPRE SE USAN EN EL FORM PARA ENVIARLAS AL SQL --->
<cfparam name="form.Pagina2" default="1">
<cfparam name="form.Filtro_Aplaca" default="">
<cfparam name="form.Filtro_Aserie" default="">
<cfparam name="form.Filtro_Adescripcion" default="">
<cfparam name="form.Filtro_Estatus" default="">
<cfparam name="form.Filtro_DEidentificacion" default="">
<cfparam name="form.Filtro_CFdescripcion" default="">
<cfparam name="form.Filtro_Ver" default="">

<!--- Variable para enviar navegacion a lista de detalles, en la navegacion y en el filtrar --->
<cfset Gvar_navegacion_Lista2 = "">
<cfset Gvar_navegacion_Lista2=ListAppend(Gvar_navegacion_Lista2,"Pagina2="&Form.Pagina2,"&")>
<cfset Gvar_navegacion_Lista2=ListAppend(Gvar_navegacion_Lista2,"Filtro_Aplaca="&Form.Filtro_Aplaca,"&")>
<cfset Gvar_navegacion_Lista2=ListAppend(Gvar_navegacion_Lista2,"Filtro_Aserie="&Form.Filtro_Aserie,"&")>
<cfset Gvar_navegacion_Lista2=ListAppend(Gvar_navegacion_Lista2,"Filtro_Adescripcion="&Form.Filtro_Adescripcion,"&")>
<cfset Gvar_navegacion_Lista2=ListAppend(Gvar_navegacion_Lista2,"Filtro_Estatus="&Form.Filtro_Estatus,"&")>
<cfset Gvar_navegacion_Lista2=ListAppend(Gvar_navegacion_Lista2,"Filtro_DEidentificacion="&Form.Filtro_DEidentificacion,"&")>
<cfset Gvar_navegacion_Lista2=ListAppend(Gvar_navegacion_Lista2,"Filtro_CFdescripcion="&Form.Filtro_CFdescripcion,"&")>
<cfset Gvar_navegacion_Lista2=ListAppend(Gvar_navegacion_Lista2,"Filtro_Ver="&Form.Filtro_Ver,"&")>

<cfset Gvar_navegacion_Lista2=ListAppend(Gvar_navegacion_Lista2,"HFiltro_Aplaca="&Form.Filtro_Aplaca,"&")>
<cfset Gvar_navegacion_Lista2=ListAppend(Gvar_navegacion_Lista2,"HFiltro_Aserie="&Form.Filtro_Aserie,"&")>
<cfset Gvar_navegacion_Lista2=ListAppend(Gvar_navegacion_Lista2,"HFiltro_Adescripcion="&Form.Filtro_Adescripcion,"&")>
<cfset Gvar_navegacion_Lista2=ListAppend(Gvar_navegacion_Lista2,"HFiltro_Estatus="&Form.Filtro_Estatus,"&")>
<cfset Gvar_navegacion_Lista2=ListAppend(Gvar_navegacion_Lista2,"HFiltro_DEidentificacion="&Form.Filtro_DEidentificacion,"&")>
<cfset Gvar_navegacion_Lista2=ListAppend(Gvar_navegacion_Lista2,"HFiltro_CFdescripcion="&Form.Filtro_CFdescripcion,"&")>
<cfset Gvar_navegacion_Lista2=ListAppend(Gvar_navegacion_Lista2,"HFiltro_Ver="&Form.Filtro_Ver,"&")>

<cfif not request.calledFromSQL>
	<!--- codigo que solo se ejecuta cuando este archivo no fue llamado desde el sql --->
</cfif>

</cfsilent>