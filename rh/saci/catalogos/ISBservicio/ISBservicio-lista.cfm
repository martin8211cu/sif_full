<cfset CurrentPage = GetFileFromPath(GetTemplatePath())>

<cfsavecontent variable="pNavegacion">
	<cfinclude template="/home/menu/pNavegacion.cfm">
</cfsavecontent>

<cf_templateheader title="#nav__SPdescripcion#">
	<cfoutput>#pNavegacion#</cfoutput>

	<cf_web_portlet_start titulo="<cfoutput>#nav__SPdescripcion#</cfoutput>">
	
			<!--- VARIABLE DE PAGINA PARA CUANDO VIENE DE LA PANTALLA DE MANTENIMIENTO O DEL BORRADO DEL SQL DE LA PANTALLA DE MANTENIMIENTO--->
			<cfif isdefined("url.Pagina") and len(trim(url.Pagina))>
				<cfset form.Pagina = url.Pagina>
			</cfif>
			<!--- VARIABLE DE PAGINA PARA CUANDO VIENE DEL CLICK EN LA NAVEGACION--->
			<cfif isdefined("url.PageNum_Lista") and len(trim(url.PageNum_Lista)) neq 0>
				<cfset form.Pagina = url.PageNum_Lista>
			</cfif>
			<!--- VARIABLES DE FILTROS PARA CUANDO VIENE DE LA PANTALLA O DE LA NAVEGACIÓN --->
			<cfif isdefined("url.Filtro_PQnombre") and len(trim(url.Filtro_PQnombre))>
				<cfset form.Filtro_PQnombre = url.Filtro_PQnombre>
			</cfif>
			<cfif isdefined("url.Filtro_PQdescripcion") and len(trim(url.Filtro_PQdescripcion))>
				<cfset form.Filtro_PQdescripcion = url.Filtro_PQdescripcion>
			</cfif>
			
			<!--- VALORES POR DEFECTO DE LAS VARIBLES REQUERIDAS PORQUE SIEMPRE SE USAN EN EL FORM PARA ENVIARLAS AL SQL --->
			<cfparam name="form.Pagina" default="1">
			<cfparam name="form.Filtro_PQnombre" default="">
			<cfparam name="form.Filtro_PQdescripcion" default="">
			
			<cfif len(trim(form.Pagina)) eq 0>
				<!--- CUANDO LE DAN CLICK AL FILTRAR EXISTE EL CAMPO PAGINA EN EL FORM PERO ESTÁ VACÍO PORQQUE EL CAMPO SE LLENA CUAND LE DAN CLICK A LA LISTA Y NO LE DIERON CLIK --->
				<cfset form.Pagina = 1>
			</cfif>
			
			<!--- LISTA--->
			<!--- SE DEFINE LA NAVEGACION DE LA NAVEGACION EXTERNA. --->
			<cfset nav = "">
			<cfif isdefined("form.Filtro_PQnombre") and len(trim(form.Filtro_PQnombre))>
				<cfset nav = nav & "&Filtro_PQnombre="&form.Filtro_PQnombre>
			</cfif>
			<cfif isdefined("form.Filtro_PQdescripcion") and len(trim(form.Filtro_PQdescripcion))>
				<cfset nav = nav & "&Filtro_PQdescripcion="&Replace(form.Filtro_PQdescripcion,",","","all")>
			</cfif>
			
			<!--- Define la página de la lista --->
			<cfif isdefined("Form.Pagina") and Form.Pagina NEQ "">
				<cfset Pagenum_lista = #Form.Pagina#>
			</cfif>
			<!--- Lista --->
			<cfinvoke 
			 component="sif.Componentes.pListas"
			 method="pLista">
				<cfinvokeargument name="tabla" value="ISBpaquete"/>
				<cfinvokeargument name="columnas" value="#form.pagina# as pagina,PQcodigo,PQnombre, PQdescripcion,PQinterfaz"/>
				<cfinvokeargument name="desplegar" value="PQnombre,PQdescripcion"/>
				<cfinvokeargument name="etiquetas" value="Nombre,Descripci&oacute;n"/>
				<cfinvokeargument name="filtro" value=" Ecodigo= #Session.Ecodigo#"/>
				<cfinvokeargument name="ajustar" value="N"/>
				<cfinvokeargument name="formatos" value="S,S"/>
				<cfinvokeargument name="align" value="left,left"/>
				<cfinvokeargument name="ira" value="ISBservicio.cfm">
				<cfinvokeargument name="conexion" value="#session.DSN#"/>
				<cfinvokeargument name="keys" value="PQcodigo"/>
				<cfinvokeargument name="MaxRows" value="20"/>
				<cfinvokeargument name="mostrar_filtro" value="true"/>
				<cfinvokeargument name="filtrar_automatico" value="true"/>
				<cfinvokeargument name="filtrar_por" value="PQnombre, PQdescripcion"/>
				<cfinvokeargument name="navegacion" value="#nav#"/>
			</cfinvoke>
				
		<cf_web_portlet_end>
<cf_templatefooter>