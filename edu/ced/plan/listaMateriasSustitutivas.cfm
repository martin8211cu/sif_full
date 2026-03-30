
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
			<cfparam name="form.Filtro_Mhoras" default="">
			<cfparam name="form.Filtro_Mcreditos" default="">
			
			<cfif len(trim(form.Pagina)) eq 0>
				<!--- CUANDO LE DAN CLICK AL FILTRAR EXISTE EL CAMPO PAGINA EN EL FORM PERO ESTÁ VACÍO PORQQUE EL CAMPO SE LLENA CUAND LE DAN CLICK A LA LISTA Y NO LE DIERON CLIK --->
				<cfset form.Pagina = 1>
			</cfif>
			
			<!--- SE DEFINE LA NAVEGACION --->
			<cfset nav = "">
			
			<cfif isdefined("form.Filtro_Mnombre") and len(trim(form.Filtro_Mnombre))>
				<cfset nav = nav & "&Filtro_Mnombre="&form.Filtro_Mnombre>
			</cfif>
			<cfif isdefined("form.Filtro_Mhoras") and len(trim(form.Filtro_Mhoras))>
				<cfset nav = nav & "&Filtro_Mhoras="&form.Filtro_Mhoras>
			</cfif>
			<cfif isdefined("form.Filtro_Mcreditos") and len(trim(form.Filtro_Mcreditos))>
				<cfset nav = nav & "&Filtro_Mcreditos="&form.Filtro_Mcreditos>
			</cfif>
			
			<cfinvoke 
			 component="edu.Componentes.pListas"
			 method="pListaEdu"
			 returnvariable="pListaEduRet">
				<cfinvokeargument name="tabla" value="Materia a, Nivel b "/>
				<cfinvokeargument name="columnas" value="a.Mconsecutivo, a.Melectiva, substring(a.Mnombre,1,50) as Mnombre, a.Mhoras, a.Mcreditos, convert(varchar, a.Ncodigo) as Ncodigo, convert(varchar, a.Gcodigo) as Gcodigo, b.Ndescripcion, #form.pagina# as pagina"/>
				<cfinvokeargument name="desplegar" value="Mnombre, Mhoras, Mcreditos"/>
				<cfinvokeargument name="etiquetas" value="Descripci&oacute;n, Horas mayor a, Cr&eacute;ditos mayor a"/>
				<cfinvokeargument name="formatos" value="V,M,M"/>
				<cfinvokeargument name="filtro" value=" b.CEcodigo = #Session.Edu.CEcodigo#  
														 and a.Melectiva = 'S' 
														 and a.Ncodigo = b.Ncodigo 
														 and a.Ncodigo = b.Ncodigo 
														 and a.Mactiva = 1
														 order by b.Norden, a.Morden, a.Mnombre "/>
				<cfinvokeargument name="align" value="left,right,right"/>
				<cfinvokeargument name="ajustar" value="N,N,N"/>
				<cfinvokeargument name="irA" value="MateriasSustitutivas.cfm"/>
				<cfinvokeargument name="checkboxes" value="N"/>
				<cfinvokeargument name="debug" value="N"/>
				<cfinvokeargument name="cortes" value="Ndescripcion"/>
				<cfinvokeargument name="keys" value="Mconsecutivo"/>
				<cfinvokeargument name="mostrar_filtro" value="true"/>
				<cfinvokeargument name="filtrar_automatico" value="true"/>
				<cfinvokeargument name="filtrar_por" value="a.Mnombre,a.Mhoras,a.Mcreditos"/>
				<cfinvokeargument name="conexion" value="#session.Edu.DSN#"/>
				<cfinvokeargument name="maxrows" value="20"/>
				<cfinvokeargument name="navegacion" value="#nav#"/>
			</cfinvoke>
			
		</cf_web_portlet>
	</cf_templatearea>
</cf_template>