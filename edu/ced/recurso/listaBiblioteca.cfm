<!--- Rodolfo Jimenez Jara, Soluciones Integrales S.A., Costa Rica, America Central, 21/04/2003 --->
<!--- Modificado el 23/01/2006 por Karol Rodríguez Solórzano--->

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
			
			<!--- Toma el id de la Biblioteca --->
			<cfquery datasource="#Session.Edu.DSN#" name="rsBibliotecas">
				set nocount on
				declare @id numeric
				if not exists ( select 1 from BibliotecaCentroE BCE, MABiblioteca MAB
					where BCE.CEcodigo = <cfqueryparam value="#Session.Edu.CEcodigo#" cfsqltype="cf_sql_numeric">
					  and MAB.id_biblioteca = BCE.id_biblioteca
				)
				begin
					insert into MABiblioteca (nombre_biblio)
					values('Biblioteca')
				
					select @id = @@identity
					
					insert into BibliotecaCentroE (CEcodigo, id_biblioteca)
					values(<cfqueryparam value="#Session.Edu.CEcodigo#" cfsqltype="cf_sql_numeric">,@id)
				end
				else  
					select 1
				set nocount off
			</cfquery>
			<!--- VARIABLE DE PAGINA PARA CUANDO VIENE DE LA PANTALLA DE MANTENIMIENTO O DEL BORRADO DEL SQL DE LA PANTALLA DE MANTENIMIENTO--->
			<cfif isdefined("url.Pagina") and len(trim(url.Pagina))>
				<cfset form.Pagina = url.Pagina>
			</cfif>
			<!--- VARIABLE DE PAGINA PARA CUANDO VIENE DEL CLICK EN LA NAVEGACION--->
			<cfif isdefined("url.PageNum_Lista") and len(trim(url.PageNum_Lista)) neq 0>
				<cfset form.Pagina = url.PageNum_Lista>
			</cfif>
			<!--- VARIABLES DE FILTROS PARA CUANDO VIENE DE LA PANTALLA O DE LA NAVEGACIÓN --->
			<cfif isdefined("url.Filtro_nombre_tipo") and len(trim(url.Filtro_nombre_tipo))>
				<cfset form.Filtro_nombre_tipo = url.Filtro_nombre_tipo>
			</cfif>
			<!--- VALORES POR DEFECTO DE LAS VARIBLES REQUERIDAS PORQUE SIEMPRE SE USAN EN EL FORM PARA ENVIARLAS AL SQL --->
			<cfparam name="form.Pagina" default="1">
			<cfparam name="form.Filtro_nombre_tipo" default="">
			<cfif len(trim(form.Pagina)) eq 0>
				<!--- CUANDO LE DAN CLICK AL FILTRAR EXISTE EL CAMPO PAGINA EN EL FORM PERO ESTÁ VACÍO PORQQUE EL CAMPO SE LLENA CUAND LE DAN CLICK A LA LISTA Y NO LE DIERON CLIK --->
				<cfset form.Pagina = 1>
			</cfif>
			
			<!--- LISTA--->
			<!--- SE DEFINE LA NAVEGACION DE LA NAVEGACION EXTERNA. --->
			<cfset nav = "">
			<cfif isdefined("form.Filtro_nombre_tipo") and len(trim(form.Filtro_nombre_tipo))>
				<cfset nav = nav & "&Filtro_nombre_tipo="&form.Filtro_nombre_tipo>
			</cfif>
			<!--- Lista --->
			<cfinvoke 
			 component="edu.Componentes.pListas"
			 method="pListaEdu"
			 returnvariable="pListaEduRet">
				<cfinvokeargument name="tabla" value="BibliotecaCentroE BCE, MATipoDocumento MATD"/>
				<cfinvokeargument name="columnas" value="MATD.id_tipo, substring(MATD.nombre_tipo,1,35) as nombre_tipo, 'listaBiblioteca.cfm' as RegresarURL, #form.Pagina# as Pagina "/>
				<cfinvokeargument name="desplegar" value="nombre_tipo"/>
				<cfinvokeargument name="etiquetas" value="Nombre del Tipo de Documento"/>
				<cfinvokeargument name="formatos" value="V"/>
				<cfinvokeargument name="filtro" value=" BCE.CEcodigo = #Session.Edu.CEcodigo#  and BCE.id_biblioteca = MATD.id_biblioteca  order by nombre_tipo "/>
				<cfinvokeargument name="align" value="left"/>
				<cfinvokeargument name="ajustar" value="N"/>
				<cfinvokeargument name="irA" value="Biblioteca.cfm"/>
				<cfinvokeargument name="botones" value="Nuevo"/>
				<cfinvokeargument name="corte" value="nombre_tipo"/>
				<cfinvokeargument name="debug" value="N"/>
				<cfinvokeargument name="conexion" value="#session.Edu.DSN#"/>
				<cfinvokeargument name="keys" value="id_tipo"/>
				<cfinvokeargument name="formatos" value="S"/>
				<cfinvokeargument name="MaxRows" value="20"/>
				<cfinvokeargument name="mostrar_filtro" value="true"/>
				<cfinvokeargument name="filtrar_automatico" value="true"/>
				<cfinvokeargument name="filtrar_por" value="MATD.nombre_tipo"/>
				<cfinvokeargument name="navegacion" value="#nav#"/>
			</cfinvoke>
				
		</cf_web_portlet>
	</cf_templatearea>
</cf_template>