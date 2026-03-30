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
			<link href="../../css/estilos.css" rel="stylesheet" type="text/css">
			<script language="JavaScript" src="../../js/utilesMonto.js"></script>
			<!--- VARIABLE DE PAGINA PARA CUANDO VIENE DEL SQL--->
			<cfif isdefined("url.Pagina") and len(trim(url.Pagina))>
				<cfset form.Pagina = url.Pagina>
			</cfif>
			<!--- VARIABLE DE PAGINA PARA CUANDO VIENE DEL CLICK EN LA LISTA--->
			<cfif isdefined("form.PageNum") and len(trim(form.PageNum))>
				<cfset form.Pagina = form.PageNum>
			</cfif>
			<!--- VARIABLES DE FILTROS PARA CUANDO VIENE DEL SQL --->
			<cfif isdefined("url.Filtro_Rdescripcion") and len(trim(url.Filtro_Rdescripcion))>
				<cfset form.Filtro_Rdescripcion = url.Filtro_Rdescripcion>
			</cfif>
			<cfif isdefined("url.Filtro_Rcodigo") and len(trim(url.Filtro_Rcodigo))>
				<cfset form.Filtro_Rcodigo = url.Filtro_Rcodigo>
			</cfif>
			<cfif isdefined("url.Filtro_Rcapacidad") and len(trim(url.Filtro_Rcapacidad))>
				<cfset form.Filtro_Rcapacidad = url.Filtro_Rcapacidad>
			</cfif>
			
			<!--- VARIABLE DE PAGINA PARA CUANDO VIENE DEL CLICK EN LA NAVEGACION--->
			<cfif isdefined("url.PageNum_Lista") and len(trim(url.PageNum_Lista))>
				<cfset form.Pagina = url.PageNum_Lista>
				<!--- RESETEA LA LLAVE CUANDO NAVEGA --->
				<cfset form.Rconsecutivo = 0>
			</cfif>	
			
			<!--- VALORES POR DEFECTO DE LAS VARIBLES REQUERIDAS PORQUE SIEMPRE SE USAN EN EL FORM PARA ENVIARLAS AL SQL --->
			<cfparam name="form.Pagina" default="1">					
			<cfparam name="form.Filtro_Rdescripcion" default="">
			<cfparam name="form.Filtro_Rcodigo" default="">
			<cfparam name="form.Filtro_Rcapacidad" default="0">
			<cfparam name="form.MaxRows" default="15">
			
			
			<table width="100%" border="0">
              <tr>
                <td>
					<cfinclude template="formInfraestructura.cfm">
				</td>
              </tr>
            </table>
		</cf_web_portlet>
	</cf_templatearea>
</cf_template>