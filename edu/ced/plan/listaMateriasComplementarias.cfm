<!---*******************************************
*******Sistema de Educación*********************
*******Administración de Centros de Estudio*****
*******Plan de Evaluación***********************
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
			<cfif isdefined("url.PageNum_Lista") and len(trim(url.PageNum_Lista))>
				<cfparam name="form.Pagina" default="#url.PageNum_Lista#">
			</cfif>
			<cfif isdefined("url.Pagina") and len(trim(url.Pagina))>
				<cfparam name="form.Pagina" default="#url.Pagina#">
			</cfif>
			<cfparam name="form.Pagina" default="1">
			<cfinvoke 
			 component="edu.Componentes.pListas"
			 method="pListaEdu"
			 returnvariable="pListaEduRet">
			 	<cfinvokeargument name="tabla" value="Materia a
																				INNER JOIN Nivel b
																					on b.Ncodigo = a.Ncodigo
																					and b.CEcodigo = #Session.Edu.CEcodigo#
																				INNER JOIN Grado c
																					on c.Ncodigo = a.Ncodigo
																					and c.Gcodigo = a.Gcodigo"/>
				<cfinvokeargument name="columnas" value="a.Mconsecutivo, 
																				a.Mhoras as Horas, 
																				a.Mcreditos as Creditos, 
																				substring(a.Mnombre,1,50) as Materia, 
																				b.Ncodigo, 
																				substring(b.Ndescripcion,1,50) as Nivel,
																				c.Gcodigo, 
																				substring(c.Gdescripcion,1,50) as Grado, 
																				'#form.Pagina#' as Pagina, '' as e"/>
				<cfinvokeargument name="cortes" value="Nivel, Grado"/>
				<cfinvokeargument name="desplegar" value="Materia, Horas, Creditos, e"/>
				<cfinvokeargument name="filtrar_por" value="a.Mnombre, a.Mhoras, a.Mcreditos, '' "/>
				<cfinvokeargument name="etiquetas" value="Descripci&oacute;n, Horas, Cr&eacute;ditos, "/>
				<cfinvokeargument name="formatos" value="S,I,I,U"/>
				<cfinvokeargument name="Filtro" value="a.Melectiva = 'C' 
																				and a.Mactiva = 1 
																				order by b.Norden, c.Gorden, a.Morden"/>
				<cfinvokeargument name="align" value="left, right, right, right"/>
				<cfinvokeargument name="ajustar" value="N"/>
				<cfinvokeargument name="irA" value="MateriasComplementarias.cfm"/>
				<cfinvokeargument name="conexion" value="#Session.Edu.Dsn#"/>
				<cfinvokeargument name="mostrar_Filtro" value="true"/>
				<cfinvokeargument name="filtrar_automatico" value="true"/>
				<cfinvokeargument name="keys" value="Mconsecutivo"/>
				<cfinvokeargument name="maxrows" value="15"/>
			</cfinvoke>
		</cf_web_portlet>
	</cf_templatearea>
</cf_template>