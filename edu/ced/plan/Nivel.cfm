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
			<table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>
				<td valign="top" width="40%">
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
						<cfset form.Ncodigo = 0>
					</cfif>					
					<!--- VARIABLE DE PAGINA PARA CUANDO VIENE DEL CLICK EN LA LISTA--->
					<cfif isdefined("form.PageNum") and len(trim(form.PageNum))>
						<cfset form.Pagina = form.PageNum>
					</cfif>
					<!--- VARIABLES DE FILTROS PARA CUANDO VIENE DEL SQL --->
					<cfif isdefined("url.Filtro_Ndescripcion") and len(trim(url.Filtro_Ndescripcion))>
						<cfset form.Filtro_Ndescripcion = url.Filtro_Ndescripcion>
					</cfif>
					<cfif isdefined("url.Filtro_Nnotaminima") and len(trim(url.Filtro_Nnotaminima))>
						<cfset form.Filtro_Nnotaminima = url.Filtro_Nnotaminima>
					</cfif>
					<cfif isdefined("url.Filtro_Norden") and len(trim(url.Filtro_Norden))>
						<cfset form.Filtro_Norden = url.Filtro_Norden>
					</cfif>					
					<!--- VALORES POR DEFECTO DE LAS VARIBLES REQUERIDAS PORQUE SIEMPRE SE USAN EN EL FORM PARA ENVIARLAS AL SQL --->
					<cfparam name="form.Pagina" default="1">					
					<cfparam name="form.Filtro_Ndescripcion" default="">
					<cfparam name="form.Filtro_Nnotaminima" default="0.00">
					<cfparam name="form.Filtro_Norden" default="0">
					<cfparam name="form.MaxRows" default="15">
					<!--- LISTA DEL MANTENIMIENTO --->
					<cfinvoke 
					 component="edu.Componentes.pListas"
					 method="pListaEdu"
					 returnvariable="pListaRet">
					<cfinvokeargument name="tabla" value="Nivel"/>
						<cfinvokeargument name="columnas" value="Ncodigo, substring(Ndescripcion,1,50) as Ndescripcion, Nnotaminima, Norden " />
						<cfinvokeargument name="desplegar" value="Ndescripcion, Nnotaminima, Norden"/>
						<cfinvokeargument name="etiquetas" value="Descripci&oacute;n, Nota M&iacute;nima, &Oacute;rden"/>
						<cfinvokeargument name="formatos" value="S,M,I"/>
						<cfinvokeargument name="filtro" value="CEcodigo = #Session.Edu.CEcodigo# order by Norden"/>
						<cfinvokeargument name="align" value="left,right,left"/>
						<cfinvokeargument name="ajustar" value="N,N,N"/>
						<cfinvokeargument name="irA" value="Nivel.cfm"/> <!--- Nombre del Catlogo de Educaci n --->
						<cfinvokeargument name="conexion" value="#Session.Edu.Dsn#"/>
						<cfinvokeargument name="mostrar_filtro" value="true"/>
						<cfinvokeargument name="filtrar_automatico" value="true"/>
						<cfinvokeargument name="keys" value="Ncodigo"/>
						<cfinvokeargument name="MaxRows" value="#form.MaxRows#"/>
					</cfinvoke>
				</td>
				<td valign="top" width="60%">
					<!--- MANTENIMIENTO --->
					<cfinclude template="formNivel.cfm">
				</td>
			  </tr>
			</table>
		</cf_web_portlet>
	</cf_templatearea>
</cf_template>