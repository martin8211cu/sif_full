<!---*******************************************
*******Sistema de Educación*********************
*******Administración de Centros de Estudio*****
*******Periodo de Evaluación********************
*******Fecha de Creación: Ene/2006**************
*******Desarrollado por: Dorian Abarca Gómez****
********************************************--->
<!---*******************************************
*******Registro de Cambios Realizados***********
*******Modificación No:*************************
*******Realizada por:***************************
*******Detalle de la Modificación:**************
********************************************--->
<!---*******************************************
*******Se crea Variable pNavegacion para********
*******obtener variables con datos del proceso**
*******como nombre para utilizarlo en titulos***
*******aquí se crea nav__SPdescripcion**********
********************************************--->
<cfset CurrentPage=GetFileFromPath(GetTemplatePath())>
<cfsavecontent variable="pNavegacion">
	<cfinclude template="/home/menu/pNavegacion.cfm">
</cfsavecontent>
<!---*******************************************
*******Template: Encabezado y Pie de Pag.*******
********************************************--->
<cf_template template="#session.sitio.template#">
	<!---*******************************************
	*******Templatearea title: Título de Pag.*******
	********************************************--->
	<cf_templatearea name="title">
		<!---*******************************************
		*******Pinta título con vairable generada en****
		*******en include de la navegacion de home******
		********************************************--->
		<cfoutput>#nav__SPdescripcion#</cfoutput>
	</cf_templatearea> 
	<cf_templatearea name="body">
		<!---*******************************************
		*******Portlet Principal************************
		********************************************--->
		<cf_web_portlet titulo="<cfoutput>#nav__SPdescripcion#</cfoutput>">
			<!---NAVEGACION--->
			<cfoutput>#pNavegacion#</cfoutput>
			<!--- TABLA PARA CONTENER EL MANTENIMIENTO ESTILO: LISTA | MANTENIMIENTO --->
			<table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>
				<td valign="top" width="40%">
					<!---  VARIABLE LlAVE PARA CUANDO VIENE DEL SQL --->
					<cfif isdefined("url.PEcodigo") and len(trim(url.PEcodigo))>
						<cfset form.PEcodigo = url.PEcodigo>
					</cfif>
					<!--- VARIABLE DE PAGINA PARA CUANDO VIENE DEL SQL--->
					<cfif isdefined("url.Pagina") and len(trim(url.Pagina))>
						<cfset form.Pagina = url.Pagina>
					</cfif>					
					<!--- VARIABLE DE PAGINA PARA CUANDO VIENE DEL CLICK EN LA NAVEGACION--->
					<cfif isdefined("url.PageNum_Lista") and len(trim(url.PageNum_Lista))>
						<cfset form.Pagina = url.PageNum_Lista>
						<!--- RESETEA LA LLAVE CUANDO NAVEGA --->
						<cfset form.PEcodigo = 0>
					</cfif>					
					<!--- VARIABLE DE PAGINA PARA CUANDO VIENE DEL CLICK EN LA LISTA--->
					<cfif isdefined("form.PageNum") and len(trim(form.PageNum))>
						<cfset form.Pagina = form.PageNum>
					</cfif>
					<!--- VARIABLES DE FILTROS PARA CUANDO VIENE DEL SQL --->
					<cfif isdefined("url.Filtro_PEdescripcion") and len(trim(url.Filtro_PEdescripcion))>
						<cfset form.Filtro_PEdescripcion = url.Filtro_PEdescripcion>
					</cfif>
					<cfif isdefined("url.Filtro_PEorden") and len(trim(url.Filtro_PEorden))>
						<cfset form.Filtro_PEorden = url.Filtro_PEorden>
					</cfif>				
					<!--- VALORES POR DEFECTO DE LAS VARIBLES REQUERIDAS PORQUE SIEMPRE SE USAN EN EL FORM PARA ENVIARLAS AL SQL --->
					<cfparam name="form.Pagina" default="1">					
					<cfparam name="form.Filtro_PEdescripcion" default="">
					<cfparam name="form.Filtro_PEorden" default="0">
					<!--- LISTA DEL MANTENIMIENTO --->
					<cfinvoke component="edu.Componentes.pListas" 
							  method="pListaEdu" 
							  returnvariable="pListaRet">
						<cfinvokeargument name="columnas" 	value="a.PEcodigo, substring(a.PEdescripcion,1,50) as PEdescripcion, a.PEorden, 
																	b.Norden, substring(b.Ndescripcion,1,50) as Ndescripcion, '' as esp"/>
						<cfinvokeargument name="tabla" 		value="PeriodoEvaluacion a 
																	INNER JOIN Nivel b 
																	ON b.Ncodigo = a.Ncodigo"/>
						<cfinvokeargument name="filtro" 	value="CEcodigo = #Session.Edu.CEcodigo#
																	ORDER BY b.Norden, a.PEorden"/>
						<cfinvokeargument name="desplegar" 	value="PEdescripcion, PEorden, esp"/>
						<cfinvokeargument name="etiquetas" 	value="Descripci&oacute;n, Orden, "/>
						<cfinvokeargument name="formatos" 	value="S, I, U"/>
						<cfinvokeargument name="align" 		value="left, right, left"/>
						<cfinvokeargument name="ajustar" 	value="N, N, N"/>
						<cfinvokeargument name="irA" 		value="PeriodoEvaluacion.cfm"/>
						<cfinvokeargument name="Cortes"     value="Ndescripcion"/>
						<cfinvokeargument name="conexion" 	value="#Session.Edu.Dsn#"/>
						<cfinvokeargument name="mostrar_filtro" value="true"/>
						<cfinvokeargument name="filtrar_automatico" value="true"/>
						<cfinvokeargument name="keys" 		value="PEcodigo"/>
						<cfinvokeargument name="MaxRows" 		value="15"/>
					</cfinvoke>
				</td>
				<td valign="top" width="60%">
					<!--- MANTENIMIENTO --->
					<cfinclude template="formPeriodoEvaluacion.cfm">
				</td>
			  </tr>
			</table>
		</cf_web_portlet>
	</cf_templatearea>
</cf_template>