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
			<cfif isdefined("url.Mconsecutivo") and len(trim(url.Mconsecutivo))>
				<cfset form.Mconsecutivo = url.Mconsecutivo>
			</cfif>
			<!--- VARIABLE DE PAGINA PARA CUANDO VIENE DEL SQL--->
			<cfif isdefined("url.Pagina") and len(trim(url.Pagina))>
				<cfset form.Pagina = url.Pagina>
			</cfif>
			<!--- VARIABLE DE PAGINA PARA CUANDO VIENE DEL CLICK EN LA LISTA--->
			<cfif isdefined("form.PageNum") and len(trim(form.PageNum))>
				<cfset form.Pagina = form.PageNum>
			</cfif>
			<!--- VARIABLES DE FiltroS PARA CUANDO VIENE DEL SQL --->
			<cfif isdefined("url.Filtro_Materia") and len(trim(url.Filtro_Materia))>
				<cfset form.Filtro_Materia = url.Filtro_Materia>
			</cfif>
			<cfif isdefined("url.Filtro_horas") and len(trim(url.Filtro_horas))>
				<cfset form.Filtro_horas = url.Filtro_horas>
			</cfif>
			<cfif isdefined("url.Filtro_Creditos") and len(trim(url.Filtro_Creditos))>
				<cfset form.Filtro_Creditos = url.Filtro_Creditos>
			</cfif>
			<cfif isdefined("url.hFiltro_Materia") and len(trim(url.hFiltro_Materia))>
				<cfset form.hFiltro_Materia = url.hFiltro_Materia>
			</cfif>
			<cfif isdefined("url.hFiltro_Horas") and len(trim(url.hFiltro_Horas))>
				<cfset form.hFiltro_Horas = url.hFiltro_Horas>
			</cfif>
			<cfif isdefined("url.hFiltro_Creditos") and len(trim(url.hFiltro_Creditos))>
				<cfset form.hFiltro_Creditos = url.hFiltro_Creditos>
			</cfif>			
			<!--- VALORES POR DEFECTO DE LAS VARIBLES REQUERIDAS PORQUE SIEMPRE SE USAN EN EL FORM PARA ENVIARLAS AL SQL --->
			<cfparam name="form.Pagina" default="1">
			<cfparam name="form.Filtro_Materia" default="">
			<cfparam name="form.Filtro_horas" default="0">
			<cfparam name="form.Filtro_Creditos" default="0">
			<cfparam name="form.hFiltro_Materia" default="">
			<cfparam name="form.hFiltro_Horas" default="0">
			<cfparam name="form.hFiltro_Creditos" default="0">
			<!--- TABLA PARA CONTENER EL MANTENIMIENTO ESTILO ENCABEZADO / LISTA DETALLES | DETATALLES--->
			<cfinclude template="formMateriasComplementarias.cfm">
		</cf_web_portlet>
	</cf_templatearea>
</cf_template>