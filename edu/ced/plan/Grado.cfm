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
			<table width="100%" border="0" cellpadding="0" cellspacing="0">
				<tr>
					<td colspan="2">
					<!---  VARIABLE LAVE PARA CUANDO VIENE DEL SQL --->
					<cfif isdefined("url.Ncodigo") and len(trim(url.Ncodigo))>
						<cfset form.Ncodigo = url.Ncodigo>
					</cfif>
					<!--- VARIABLE DE PAGINA PARA CUANDO VIENE DEL SQL--->
					<cfif isdefined("url.Pagina") and len(trim(url.Pagina))>
						<cfset form.Pagina = url.Pagina>
					</cfif>					
					<!--- VARIABLE DE PAGINA PARA CUANDO VIENE DEL CLICK EN LA NAVEGACION--->
					<cfif isdefined("url.PageNum_Lista") and len(trim(url.PageNum_Lista))>
						<cfset form.Pagina = url.PageNum_Lista>
						<!--- RESETEA LA LLAVE CUANDO NAVEGA --->
						<cfset form.Gcodigo = 0>
					</cfif>					
					
					<!--- VARIABLE DE PAGINA PARA CUANDO VIENE DEL CLICK EN LA LISTA--->
					<cfif isdefined("form.PageNum") and len(trim(form.PageNum))>
						<cfset form.Pagina = form.PageNum>
					</cfif>
					<!--- VARIABLES DE FILTROS PARA CUANDO VIENE DEL SQL --->
					<cfif isdefined("url.Filtro_Gdescripcion") and len(trim(url.Filtro_Gdescripcion))>
						<cfset form.Filtro_Gdescripcion = url.Filtro_Gdescripcion>
					</cfif>
					<cfif isdefined("url.Filtro_Gorden") and len(trim(url.Filtro_Gorden))>
						<cfset form.Filtro_Gorden = url.Filtro_Gorden>
					</cfif>
					<!--- VALORES POR DEFECTO DE LAS VARIBLES REQUERIDAS PORQUE SIEMPRE SE USAN EN EL FORM PARA ENVIARLAS AL SQL --->
					<cfparam name="form.Pagina" default="1">					
					<cfparam name="form.MaxRows" default="15">
					<cfparam name="form.Filtro_Gdescripcion" default="">
					<cfparam name="form.Filtro_Gorden" default="0.00">
					
					</td>
				</tr>
				<tr>
					<td valign="top" width="40%">
					  <cfinvoke 
					 component="edu.Componentes.pListas"
					 method="pListaEdu"
					 returnvariable="pListaRet">
					<cfinvokeargument name="tabla" value="Grado b, Nivel a"/>
						<cfinvokeargument name="columnas" value="b.Gcodigo, b.Ncodigo, substring(a.Ndescripcion,1,50) as Ndescripcion, substring(b.Gdescripcion,1,50) as Gdescripcion , b.Gorden, b.Ganual"/>
						<cfinvokeargument name="desplegar" value="Gdescripcion, Gorden"/>
						<cfinvokeargument name="etiquetas" value="Descripción, Orden"/>
						<cfinvokeargument name="formatos" value="S,I"/>
						<cfinvokeargument name="filtro" value=" a.CEcodigo = #Session.Edu.CEcodigo# and a.Ncodigo = b.Ncodigo order by a.Norden, b.Gorden "/>
						<cfinvokeargument name="align" value="left,left"/>
						<cfinvokeargument name="ajustar" value="N,N"/>
						<cfinvokeargument name="irA" value="Grado.cfm"/>
						<cfinvokeargument name="cortes" value="Ndescripcion"/>
						<cfinvokeargument name="mostrar_filtro" value="true"/>
						<cfinvokeargument name="filtrar_automatico" value="true"/>
						<cfinvokeargument name="keys" value="Gcodigo"/>
						<cfinvokeargument name="conexion" value="#Session.Edu.DSN#"/>
						<cfinvokeargument name="MaxRows" value="#form.MaxRows#"/>
					</cfinvoke>
					</td>
					<td valign="top">
						<cfinclude  template="formGrado.cfm"> 
					</td>
				</tr>
			</table>
			</cf_web_portlet>
	</cf_templatearea>
</cf_template>