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
			<!--- VARIABLE DE PAGINA PARA CUANDO VIENE DE LA PANTALLA DE MANTENIMIENTO O DEL BORRADO DEL SQL DE LA PANTALLA DE MANTENIMIENTO--->
			<cfif isdefined("url.Pagina") and len(trim(url.Pagina))>
				<cfset form.Pagina = url.Pagina>
			</cfif>
			<!--- VARIABLE DE PAGINA PARA CUANDO VIENE DEL CLICK EN LA NAVEGACION--->
			<cfif isdefined("url.PageNum_Lista") and len(trim(url.PageNum_Lista))>
				<cfset form.Pagina = url.PageNum_Lista>
			</cfif>
			<!--- VARIABLES DE FILTROS PARA CUANDO VIENE DE LA PANTALLA O DE LA NAVEGACIÓN --->
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
			<cfif len(trim(form.Pagina)) eq 0>
				<!--- CUANDO LE DAN CLICK AL FILTRAR EXISTE EL CAMPO PAGINA EN EL FORM PERO ESTÁ VACÍO PORQQUE EL CAMPO SE LLENA CUAND LE DAN CLICK A LA LISTA Y NO LE DIERON CLIK --->
				<cfset form.Pagina = 1>
			</cfif>
			<!--- LISTA DE PLANES DE EVALUACIÓN --->
			<!--- SE DEFINE EL FILTRO A PAR PORQUE EL FILTRO DE UN CAMPO QUE AGRUPA DATOS DEBE IR CON UN HAVING, Y ESTA FUNCIONALIDAD NO LA MANEJA EL COMPONENTE DE LISTAS Y NO DEBE PORQUE NO ES TÍPICA, ES UNA FUNCIONALIDAD POCO COMÚN. --->
			<cfset filtro = "1=1">
			<cfset nav = "">
			<cfset filtro = filtro & " AND a.CEcodigo = #session.edu.cecodigo#">
			<cfif isdefined("form.Filtro_EPnombre") and len(trim(form.Filtro_EPnombre))>
				<cfset filtro = filtro & " AND upper(rtrim(ltrim(a.EPnombre))) like '%#Ucase(Trim(form.Filtro_EPnombre))#%'">
				<cfset nav = nav & "&Filtro_EPnombre="&form.Filtro_EPnombre>
			</cfif>
			<cfset filtro = filtro & " GROUP BY a.EPcodigo, a.EPnombre">
			<cfif isdefined("form.Filtro_EPCporcentaje") and len(trim(form.Filtro_EPCporcentaje))>
				<cfset filtro = filtro & " HAVING coalesce(sum(b.EPCporcentaje), 0.00) >= " & Replace(form.Filtro_EPCporcentaje,",","","all")>
				<cfset nav = nav & "&Filtro_EPCporcentaje="&Replace(form.Filtro_EPCporcentaje,",","","all")>
			</cfif>
			<cfset filtro = filtro & " ORDER BY a.EPnombre">
			<cfinvoke 
			 component="edu.Componentes.pListas"
			 method="pListaEdu"
			 returnvariable="pListaEduRet">
			 	<cfinvokeargument name="debug" value="N">
				<cfinvokeargument name="tabla" value="EvaluacionPlan a
														LEFT OUTER JOIN EvaluacionPlanConcepto b 
														ON a.EPcodigo = b.EPcodigo"/>
				<cfinvokeargument name="columnas" value="a.EPcodigo, a.EPnombre, coalesce(sum(b.EPCporcentaje), 0.00) as EPCporcentaje, '' as esp, #form.Pagina# as Pagina"/><!--- ES NECESARIO ENVIAR LA PAGINA PORQUE EL COMPONENTE DE LISTAS NO EVÍA PAGENUM CUANDO LA SEGUNDA PANTALLA NO ES LA MISMA QUE LA PRIMERA --->
				<cfinvokeargument name="desplegar" value="EPnombre, EPCporcentaje, esp"/>
				<cfinvokeargument name="etiquetas" value="Descripci&oacute;n, Porcentaje Asignado, "/>
				<cfinvokeargument name="formatos" value="S, P, U"/>
				<cfinvokeargument name="filtro" value="#filtro#"/>
				<cfinvokeargument name="filtrar_por" value="a.EPnombre,'',''"/>
				<cfinvokeargument name="align" value="left, right, right"/>
				<cfinvokeargument name="ajustar" value="N"/>
				<cfinvokeargument name="irA" value="PlanEvaluacion.cfm"/>
				<cfinvokeargument name="botones" value="Nuevo"/>
				<cfinvokeargument name="conexion" 	value="#Session.Edu.Dsn#"/>
				<cfinvokeargument name="mostrar_filtro" value="true"/>
				<cfinvokeargument name="filtrar_automatico" value="false"/>
				<cfinvokeargument name="navegacion" value="#nav#"/>
				<cfinvokeargument name="keys" value="EPcodigo"/>
				<cfinvokeargument name="maxrows" value="15"/>
			</cfinvoke>
		</cf_web_portlet>
	</cf_templatearea>
</cf_template>