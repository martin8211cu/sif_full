<cfset CurrentPage=GetFileFromPath(GetTemplatePath())>
<cfsavecontent variable="pNavegacion">
	<cfinclude template="/home/menu/pNavegacion.cfm">
</cfsavecontent>
<cf_template template="#session.sitio.template#">
	<cf_templatearea name="title">
		<cfoutput>#nav__SPdescripcion#</cfoutput>
	</cf_templatearea> 
	<cf_templatearea name="body">
		<cf_web_portlet titulo="<cfoutput>#nav__SPdescripcion#</cfoutput>">
			<cfoutput>#pNavegacion#</cfoutput>
			<!--- Aqui se incluye el form --->
		
			<cfset Session.Edu.RegresarUrl = "/cfmx/edu/ced/MenuCED.cfm">
				
			<!--- VARIABLE DE PAGINA PARA CUANDO VIENE DE LA PANTALLA DE MANTENIMIENTO O DEL BORRADO DEL SQL DE LA PANTALLA DE MANTENIMIENTO--->
			<cfif isdefined("url.Pagina") and len(trim(url.Pagina))>
				<cfset form.Pagina = url.Pagina>
			</cfif>
			<!--- VARIABLE DE PAGINA PARA CUANDO VIENE DEL CLICK EN LA NAVEGACION--->
			<cfif isdefined("url.PageNum_Lista") and len(trim(url.PageNum_Lista))>
				<cfset form.Pagina = url.PageNum_Lista>
			</cfif>
			<!--- VARIABLES DE FILTROS PARA CUANDO VIENE DE LA PANTALLA O DE LA NAVEGACIÓN --->
			<cfif isdefined("url.Filtro_Rdescripcion") and len(trim(url.Filtro_Rdescripcion))>
				<cfset form.Filtro_Rdescripcion = url.Filtro_Rdescripcion>
			</cfif>
			<cfif isdefined("url.Filtro_Rcodigo") and len(trim(url.Filtro_Rcodigo))>
				<cfset form.Filtro_Rcodigo = url.Filtro_Rcodigo>
			</cfif>
			<cfif isdefined("url.Filtro_Rcapacidad") and len(trim(url.Filtro_Rcapacidad))>
				<cfset form.Filtro_Rcapacidad = url.Filtro_Rcapacidad>
			</cfif>
			
		
			<!--- VALORES POR DEFECTO DE LAS VARIBLES REQUERIDAS PORQUE SIEMPRE SE USAN EN EL FORM PARA ENVIARLAS AL SQL --->
			<cfparam name="form.Pagina" default="1">
			<cfparam name="form.Filtro_Rdescripcion" default="">
			<cfparam name="form.Filtro_Rcodigo" default="">
			<cfparam name="form.Filtro_Rcapacidad" default="0">
			<cfparam name="form.MaxRows" default="5">
			
			<cfif len(trim(form.Pagina)) eq 0>
				<!--- CUANDO LE DAN CLICK AL FILTRAR EXISTE EL CAMPO PAGINA EN EL FORM PERO ESTÁ VACÍO PORQQUE EL CAMPO SE LLENA CUAND LE DAN CLICK A LA LISTA Y NO LE DIERON CLIK --->
				<cfset form.Pagina = 1>
			</cfif>
			<!--- LISTA DE PLANES DE EVALUACIÓN --->
			<!--- SE DEFINE EL FILTRO A PAR PORQUE EL FILTRO DE UN CAMPO QUE AGRUPA DATOS DEBE IR CON UN HAVING, Y ESTA FUNCIONALIDAD NO LA MANEJA EL COMPONENTE DE LISTAS Y NO DEBE PORQUE NO ES TÍPICA, ES UNA FUNCIONALIDAD POCO COMÚN. --->
			<cfset filtro = "1=1">
			<cfset navegacion = "">
			<cfset filtro = filtro & " and CEcodigo = #session.edu.cecodigo#">
			<cfif isdefined("form.Filtro_Rdescripcion") and len(trim(form.Filtro_Rdescripcion))>
				<cfset filtro = filtro & " AND upper(rtrim(ltrim(Rdescripcion))) like '%#Ucase(Trim(form.Filtro_Rdescripcion))#%'">
				<cfset navegacion = navegacion & "&Filtro_Rdescripcion="&form.Filtro_Rdescripcion>
			</cfif>
			<cfif isdefined("form.Filtro_Rcodigo") and len(trim(form.Filtro_Rcodigo))>
				<cfset filtro = filtro & " AND upper(rtrim(ltrim(Rcodigo))) like '%#Ucase(Trim(form.Filtro_Rcodigo))#%'">
				<cfset navegacion = navegacion & "&Filtro_Rcodigo="&form.Filtro_Rcodigo>
			</cfif>
			<cfif isdefined("form.Filtro_Rcapacidad") and form.Filtro_Rcapacidad GT 0>
				<cfset filtro = filtro & " and Rcapacidad  > = #form.Filtro_Rcapacidad#">
				<cfset navegacion = navegacion & "&Filtro_Rcapacidad="&form.Filtro_Rcapacidad>
			</cfif>
					
			
			<cfset filtro = filtro & "  order by Rdescripcion, Rcapacidad ">
					
			<cfinvoke component="edu.Componentes.pListas" method="pListaEdu" returnvariable="pListaRet">
				<cfinvokeargument name="tabla" value="Recurso"/>
				<cfinvokeargument name="columnas" value="Rconsecutivo, Rcodigo, Rdescripcion, Rcapacidad, 	
				substring(convert(varchar, Robservacion),1, 35 ) as Obs , '' as e"/>
				<cfinvokeargument name="desplegar" value="Rcodigo, Rdescripcion, Rcapacidad,e"/>
				<cfinvokeargument name="etiquetas" value="Código, Descripción, Capacidad, "/>
				<cfinvokeargument name="formatos" value="S,S,I,U"/>
				<cfinvokeargument name="filtro" value="#filtro#"/>
				<cfinvokeargument name="align" value="left,left,right,left"/>
				<cfinvokeargument name="ajustar" value="N"/>
				<cfinvokeargument name="irA" value="Infraestructura.cfm"/>
				<cfinvokeargument name="cortes" value=""/>
				<cfinvokeargument name="mostrar_filtro" value="true"/>
				<cfinvokeargument name="filtrar_automatico" value="true"/>
				<cfinvokeargument name="filtrar_por" value="Rcodigo, Rdescripcion, Rcapacidad, ''"/>
				<cfinvokeargument name="conexion" value="#Session.Edu.DSN#"/>
				<cfinvokeargument name="navegacion" 		value="#navegacion#"/>
				<cfinvokeargument name="botones" value="Nuevo"/>
				<cfinvokeargument name="maxrows" value="#form.MaxRows#"/>
			</cfinvoke>
		</cf_web_portlet>
	</cf_templatearea>
</cf_template>