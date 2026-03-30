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
			<!--- MANTENIMIENTO DE PLANES DE EVALUACION --->
			<!---  VARIABLE LlAVE PARA CUANDO VIENE DEL SQL --->
			<cfif isdefined("url.EPcodigo") and len(trim(url.EPcodigo))>
				<cfset form.EPcodigo = url.EPcodigo>
			</cfif>
			<!--- VARIABLE DE PAGINA PARA CUANDO VIENE DEL SQL--->
			<cfif isdefined("url.Pagina") and len(trim(url.Pagina))>
				<cfset form.Pagina = url.Pagina>
			</cfif>
			<!--- VARIABLE DE PAGINA PARA CUANDO VIENE DEL CLICK EN LA LISTA--->
			<cfif isdefined("form.PageNum") and len(trim(form.PageNum))>
				<cfset form.Pagina = form.PageNum>
			</cfif>
			<!--- VARIABLES DE FILTROS PARA CUANDO VIENE DEL SQL --->
			<cfif isdefined("url.Filtro_EPnombre") and len(trim(url.Filtro_EPnombre))>
				<cfset form.Filtro_EPnombre = url.Filtro_EPnombre>
			</cfif>
			<cfif isdefined("url.Filtro_EPCporcentaje") and len(trim(url.Filtro_EPCporcentaje))>
				<cfset form.Filtro_EPCporcentaje = url.Filtro_EPCporcentaje>
			</cfif>				
			<!--- VALORES POR DEFECTO DE LAS VARIBLES REQUERIDAS PORQUE SIEMPRE SE USAN EN EL FORM PARA ENVIARLAS AL SQL --->
			<cfparam name="form.Pagina" default="1">					
			<cfparam name="form.Filtro_EPnombre" default="">
			<cfparam name="form.Filtro_EPCporcentaje" default="0.00">
			<!--- PARAMETROS DEL DETALLE Y LA LISTA DE DETALLES --->
			<!---  VARIABLE LlAVE PARA CUANDO VIENE DEL SQL --->
			<cfif isdefined("url.EPCcodigo") and len(trim(url.EPCcodigo))>
				<cfset form.EPCcodigo = url.EPCcodigo>
			</cfif>
			<!--- VARIABLE DE PAGINA PARA CUANDO VIENE DEL SQL--->
			<cfif isdefined("url.Pagina2") and len(trim(url.Pagina2))>
				<cfset form.Pagina2 = url.Pagina2>
			</cfif>					
			<!--- VARIABLE DE PAGINA PARA CUANDO VIENE DEL CLICK EN LA NAVEGACION--->
			<cfif isdefined("url.PageNum_Lista2") and len(trim(url.PageNum_Lista2))>
				<cfset form.Pagina2 = url.PageNum_Lista2>
				<!--- RESETEA LA LLAVE CUANDO NAVEGA --->
				<cfset form.EPCcodigo = 0>
			</cfif>					
			<!--- VARIABLE DE PAGINA PARA CUANDO VIENE DEL CLICK EN LA LISTA--->
			<cfif isdefined("form.PageNum2") and len(trim(form.PageNum2))>
				<cfset form.Pagina2 = form.PageNum2>
			</cfif>
			<!--- VARIABLES DE FILTROS PARA CUANDO VIENE DEL SQL --->
			<cfif isdefined("url.Filtro_ECnombre") and len(trim(url.Filtro_ECnombre))>
				<cfset form.Filtro_ECnombre = url.Filtro_ECnombre>
			</cfif>
			<cfif isdefined("url.Filtro_EVTnombre") and len(trim(url.Filtro_EVTnombre))>
				<cfset form.Filtro_EVTnombre = url.Filtro_EVTnombre>
			</cfif>
			<cfif isdefined("url.Filtro_EPCnombre") and len(trim(url.Filtro_EPCnombre))>
				<cfset form.Filtro_EPCnombre = url.Filtro_EPCnombre>
			</cfif>
			<cfif isdefined("url.Filtro_Porcentaje") and len(trim(url.Filtro_Porcentaje))>
				<cfset form.Filtro_Porcentaje = url.Filtro_Porcentaje>
			</cfif>
			<!--- VALORES POR DEFECTO DE LAS VARIBLES REQUERIDAS PORQUE SIEMPRE SE USAN EN EL FORM PARA ENVIARLAS AL SQL --->
			<cfparam name="form.Pagina2" default="1">					
			<cfparam name="form.Filtro_ECnombre" default="">
			<cfparam name="form.Filtro_EVTnombre" default="">
			<cfparam name="form.Filtro_EPCnombre" default="">
			<cfparam name="form.Filtro_Porcentaje" default="0.00">
			<cfparam name="form.MaxRows2" default="10">
			<!--- TABLA PARA CONTENER EL MANTENIMIENTO ESTILO ENCABEZADO / LISTA DETALLES | DETATALLES--->
			<table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>
				<td><cfinclude template="formPlanEvaluacion.cfm"></td>
			  </tr>
			  <cfparam name="modo" default="ALTA">
			  <cfif (modo neq "ALTA")>
			  <tr>
				<td>
					<!--- LISTA DEL MANTENIMIENTO --->
					<cfinvoke component="edu.Componentes.pListas" 
							  method="pListaEdu" 
							  returnvariable="pListaRet">
						<cfinvokeargument name="columnas" value="a.EPcodigo, a.EPCcodigo, a.EPCnombre, a.EPCporcentaje as Porcentaje, b.ECnombre, 
																	isnull(c.EVTnombre, '-- Digitar Nota --') as EVTnombre, '' as esp,
																	#form.Pagina# as Pagina, '#form.Filtro_EPnombre#' as Filtro_EPnombre, #form.Filtro_EPCporcentaje# as Filtro_EPCporcentaje"/>
						<cfinvokeargument name="tabla" value="EvaluacionPlanConcepto a
																INNER JOIN EvaluacionConcepto b
																	ON a.ECcodigo=b.ECcodigo																
																LEFT OUTER JOIN EvaluacionValoresTabla c
																	ON a.EVTcodigo = c.EVTcodigo"/>
						<cfinvokeargument name="filtro" value="EPcodigo = #form.EPcodigo# order by b.ECorden" />
						<cfinvokeargument name="desplegar" value="ECnombre, EVTnombre, EPCnombre, Porcentaje, esp"/>						
						<cfinvokeargument name="etiquetas" value="Concepto, Tipo de Evaluaci&oacute;n, Prefijo Componente de Evaluaci&oacute;n, Porcentaje, "/>
						<cfinvokeargument name="formatos" value="S, S, S, P, U"/>
						<cfinvokeargument name="align" value="left, left, left, right, right"/>
						<cfinvokeargument name="totales" value="Porcentaje"/>
						<cfinvokeargument name="ajustar" value="S"/>
						<cfinvokeargument name="irA" value="PlanEvaluacion.cfm"/>
						<cfinvokeargument name="conexion" 	value="#Session.Edu.Dsn#"/>
						<cfinvokeargument name="mostrar_filtro" value="true"/>
						<cfinvokeargument name="filtrar_automatico" value="true"/>
						<cfinvokeargument name="filtrar_por" value="b.ECnombre, c.EVTnombre, a.EPCnombre, a.EPCporcentaje, esp"/>
						<cfinvokeargument name="keys" value="EPCcodigo"/>
						<cfinvokeargument name="PageIndex" value="2"/>
						<cfinvokeargument name="formname" value="lista2"/>
						<cfinvokeargument name="navegacion" value="&EPcodigo=#EPcodigo#&Pagina=#Form.Pagina#&Filtro_EPnombre=#Form.Filtro_EPnombre#&Filtro_EPCporcentaje=#Form.Filtro_EPCporcentaje#"/>
						<cfinvokeargument name="MaxRows" value="#form.MaxRows2#"/>
					</cfinvoke>
					<script language="javascript" type="text/javascript">
						function funcFiltrar2(){
							document.lista2.action = "PlanEvaluacion.cfm<cfoutput>?EPcodigo=#EPcodigo#&Pagina=#Form.Pagina#&Filtro_EPnombre=#Form.Filtro_EPnombre#&Filtro_EPCporcentaje=#Form.Filtro_EPCporcentaje#</cfoutput>";
							return true;
						}
					</script>
				</td>
			  </tr>
			  </cfif>
			</table>
		</cf_web_portlet>
	</cf_templatearea>
</cf_template>