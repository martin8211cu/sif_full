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
			<!--- VARIABLE DE PAGINA PARA CUANDO VIENE DE LA PANTALLA DE MANTENIMIENTO O DEL BORRADO DEL SQL DE LA PANTALLA DE MANTENIMIENTO--->
			<cfif isdefined("url.Pagina") and len(trim(url.Pagina))>
				<cfset form.Pagina = url.Pagina>
			</cfif>
			<!--- VARIABLE DE PAGINA PARA CUANDO VIENE DEL CLICK EN LA NAVEGACION--->
			<cfif isdefined("url.PageNum_Lista") and len(trim(url.PageNum_Lista))>
				<cfset form.Pagina = url.PageNum_Lista>
			</cfif>
			<!--- VARIABLES DE FILTROS PARA CUANDO VIENE DE LA PANTALLA O DE LA NAVEGACIÓN --->
			<cfif isdefined("url.Filtro_EVTnombre") and len(trim(url.Filtro_EVTnombre))>
				<cfset form.Filtro_EVTnombre = url.Filtro_EVTnombre>
			</cfif>
			<!--- VALORES POR DEFECTO DE LAS VARIBLES REQUERIDAS PORQUE SIEMPRE SE USAN EN EL FORM PARA ENVIARLAS AL SQL --->
			<cfparam name="form.Pagina" default="1">
			<cfparam name="form.Filtro_EVTnombre" default="">
			<cfparam name="form.MaxRows" default="15">
			<cfif len(trim(form.Pagina)) eq 0>
				<!--- CUANDO LE DAN CLICK AL FILTRAR EXISTE EL CAMPO PAGINA EN EL FORM PERO ESTÁ VACÍO PORQQUE EL CAMPO SE LLENA CUAND LE DAN CLICK A LA LISTA Y NO LE DIERON CLIK --->
				<cfset form.Pagina = 1>
			</cfif>
			<!--- LISTA DE PLANES DE EVALUACIÓN --->
			<!--- SE DEFINE EL FILTRO A PAR PORQUE EL FILTRO DE UN CAMPO QUE AGRUPA DATOS DEBE IR CON UN HAVING, Y ESTA FUNCIONALIDAD NO LA MANEJA EL COMPONENTE DE LISTAS Y NO DEBE PORQUE NO ES TÍPICA, ES UNA FUNCIONALIDAD POCO COMÚN. --->
			<cfset filtro = "1=1">
			<cfset nav = "">
			<cfset filtro = filtro & " and CEcodigo = #session.edu.cecodigo#">
			<cfif isdefined("form.Filtro_EVTnombre") and len(trim(form.Filtro_EVTnombre))>
				<cfset filtro = filtro & " AND upper(rtrim(ltrim(EVTnombre))) like '%#Ucase(Trim(form.Filtro_EVTnombre))#%'">
				<cfset nav = nav & "&Filtro_EVTnombre="&form.Filtro_EVTnombre>
			</cfif>
			<cfset filtro = filtro & " ORDER BY EVTnombre">
			<cfinvoke 
			 component="edu.Componentes.pListas"
			 method="pListaEdu"
			 returnvariable="pListaEduRet">
				<cfinvokeargument name="tabla" value="EvaluacionValoresTabla"/>
				<cfinvokeargument name="columnas" value=" EVTcodigo, substring(EVTnombre,1,50) as EVTnombre, #Form.Pagina# as Pagina, '' as e"/>
				<cfinvokeargument name="desplegar" value="EVTnombre, e"/>
				<cfinvokeargument name="etiquetas" value="Descripci&oacute;n, "/>
				<cfinvokeargument name="formatos" value="S,U"/>
				<cfinvokeargument name="filtro" value="#filtro#"/>
				<cfinvokeargument name="filtrar_por" value="EVTnombre, ''"/>
				<cfinvokeargument name="align" value="left, left"/>
				<cfinvokeargument name="ajustar" value="N"/>
				<cfinvokeargument name="irA" value="tablaEvaluac.cfm"/>
				<cfinvokeargument name="botones" value="Nuevo"/>
				<cfinvokeargument name="conexion" value="#Session.Edu.DSN#"/>
				<cfinvokeargument name="mostrar_filtro" value="true"/>
				<cfinvokeargument name="filtrar_automatico" value="true"/>
				<cfinvokeargument name="navegacion" value="#nav#"/>
				<cfinvokeargument name="keys" value="EVTcodigo"/>
				<cfinvokeargument name="maxrows" value="#form.MaxRows#"/>
			</cfinvoke>
		</cf_web_portlet>
	</cf_templatearea>
</cf_template>