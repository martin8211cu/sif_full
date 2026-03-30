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
			<cfif isdefined("url.PageNum_Lista") and len(trim(url.PageNum_Lista)) neq 0>
				<cfset form.Pagina = url.PageNum_Lista>
			</cfif>
			<!--- VARIABLES DE FILTROS PARA CUANDO VIENE DE LA PANTALLA O DE LA NAVEGACIÓN --->
			<cfif isdefined("url.Filtro_Mnombre") and len(trim(url.Filtro_Mnombre))>
				<cfset form.Filtro_Mnombre = url.Filtro_Mnombre>
			</cfif>
			<cfif isdefined("url.Filtro_Mhoras") and len(trim(url.Filtro_Mhoras))>
				<cfset form.Filtro_Mhoras = url.Filtro_Mhoras>
			</cfif>
			<cfif isdefined("url.Filtro_Mcreditos") and len(trim(url.Filtro_Mcreditos))>
				<cfset form.Filtro_Mcreditos = url.Filtro_Mcreditos>
			</cfif>
			<!--- VALORES POR DEFECTO DE LAS VARIBLES REQUERIDAS PORQUE SIEMPRE SE USAN EN EL FORM PARA ENVIARLAS AL SQL --->
			<cfparam name="form.Pagina" default="1">
			<cfparam name="form.Filtro_Mnombre" default="">
			<cfparam name="form.Filtro_Mhoras" default="0.00">
			<cfparam name="form.Filtro_Mcreditos" default="0">
			
			<cfif len(trim(form.Pagina)) eq 0>
				<!--- CUANDO LE DAN CLICK AL FILTRAR EXISTE EL CAMPO PAGINA EN EL FORM PERO ESTÁ VACÍO PORQQUE EL CAMPO SE LLENA CUAND LE DAN CLICK A LA LISTA Y NO LE DIERON CLIK --->
				<cfset form.Pagina = 1>
			</cfif>
			
			<!--- LISTA--->
			<!--- SE DEFINE LA NAVEGACION DE LA NAVEGACION EXTERNA. --->
			<cfset nav = "">
			<cfif isdefined("form.Filtro_Mnombre") and len(trim(form.Filtro_Mnombre))>
				<cfset nav = nav & "&Filtro_Mnombre="&form.Filtro_Mnombre>
			</cfif>
			<cfif isdefined("form.Filtro_Mhoras") and len(trim(form.Filtro_Mhoras))>
				<cfset nav = nav & "&Filtro_Mhoras="&Replace(form.Filtro_Mhoras,",","","all")>
			</cfif>
			<cfif isdefined("form.Filtro_Mcreditos") and len(trim(form.Filtro_Mcreditos))>
				<cfset nav = nav & "&Filtro_Mcreditos="&form.Filtro_Mcreditos>
			</cfif>
			<!--- Define la página de la lista --->
			<cfif isdefined("Form.Pagina") and Form.Pagina NEQ "">
				<cfset Pagenum_lista = #Form.Pagina#>
			</cfif>
			<!--- Lista --->
			<cfinvoke 
			 component="edu.Componentes.pListas"
			 method="pListaEdu"
			 returnvariable="pListaEduRet">
				<cfinvokeargument name="tabla" value="Materia a, Nivel b, Grado c"/>
				<cfinvokeargument name="columnas" value="#form.pagina# as pagina,a.Mconsecutivo, substring(a.Mnombre,1,50) as Mnombre, substring(c.Gdescripcion,1,50) as Gdescripcion,  substring(b.Ndescripcion,1,50) as Ndescripcion,a.Mhoras, a.Mcreditos, convert(varchar, a.Ncodigo) as Ncodigo, convert(varchar, a.Gcodigo) as Gcodigo, b.Ndescripcion+': '+c.Gdescripcion as Grado "/>
				<cfinvokeargument name="desplegar" value="Mnombre, Mhoras, Mcreditos"/>
				<cfinvokeargument name="etiquetas" value="Descripci&oacute;n, Horas mayor a , Cr&eacute;ditos mayor a"/>
				<cfinvokeargument name="filtro" value="b.CEcodigo = #Session.Edu.CEcodigo# and a.Ncodigo = b.Ncodigo and a.Ncodigo = c.Ncodigo and a.Gcodigo = c.Gcodigo  and b.Ncodigo = c.Ncodigo  and Melectiva = 'E' and a.Mactiva = 1 order by b.Norden, c.Gorden,a.Morden"/>
				<cfinvokeargument name="align" value="left, right, right"/>
				<cfinvokeargument name="ajustar" value="N,N,N"/>
				<cfinvokeargument name="irA" value="MateriasElectivas.cfm"/>
				<cfinvokeargument name="cortes" value="Grado"/>
				<cfinvokeargument name="debug" value="N"/>
				<cfinvokeargument name="conexion" value="#session.Edu.DSN#"/>
				<cfinvokeargument name="keys" value="Mconsecutivo,Ncodigo"/>
				<cfinvokeargument name="formatos" value="S,N,N"/>
				<cfinvokeargument name="MaxRows" value="20"/>
				<cfinvokeargument name="mostrar_filtro" value="true"/>
				<cfinvokeargument name="filtrar_automatico" value="true"/>
				<cfinvokeargument name="filtrar_por" value="a.Mnombre,a.Mhoras,a.Mcreditos"/>
				<cfinvokeargument name="navegacion" value="#nav#"/>
			</cfinvoke>	
		</cf_web_portlet>
	</cf_templatearea>
</cf_template>