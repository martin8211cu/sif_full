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
			<!--- MANTENIMIENTO DE TABLAS DE EVALUACION --->
			<!---  VARIABLE LlAVE PARA CUANDO VIENE DEL SQL --->
			<cfif isdefined("url.EVTcodigo") and len(trim(url.EVTcodigo))>
				<cfset form.EVTcodigo = url.EVTcodigo>
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
			<cfif isdefined("url.Filtro_EVTnombre") and len(trim(url.Filtro_EVTnombre))>
				<cfset form.Filtro_EVTnombre = url.Filtro_EVTnombre>
			</cfif>
			
			<!--- VARIABLE DE PAGINA PARA CUANDO VIENE DEL CLICK EN LA NAVEGACION--->
			<cfif isdefined("url.PageNum_Lista") and len(trim(url.PageNum_Lista))>
				<cfset form.Pagina = url.PageNum_Lista>
				<!--- RESETEA LA LLAVE CUANDO NAVEGA --->
				<cfset form.EVTcodigo = 0>
			</cfif>	
			
			<!--- VALORES POR DEFECTO DE LAS VARIBLES REQUERIDAS PORQUE SIEMPRE SE USAN EN EL FORM PARA ENVIARLAS AL SQL --->
			<cfparam name="form.Pagina" default="1">					
			<cfparam name="form.Filtro_EVTnombre" default="">

			<!--- VARIABLE DE PAGINA PARA CUANDO VIENE DEL SQL--->
			<cfif isdefined("url.Pagina2") and len(trim(url.Pagina2))>
				<cfset form.Pagina2 = url.Pagina2>
			</cfif>					
			<!--- VARIABLE DE PAGINA PARA CUANDO VIENE DEL CLICK EN LA NAVEGACION--->
			<cfif isdefined("url.PageNum_Lista2") and len(trim(url.PageNum_Lista2))>
				<cfset form.Pagina2 = url.PageNum_Lista2>
				<!--- RESETEA LA LLAVE CUANDO NAVEGA --->
				<cfset form.Valor = ''>
			</cfif>					
			<!--- VARIABLE DE PAGINA PARA CUANDO VIENE DEL CLICK EN LA LISTA--->
			<cfif isdefined("form.PageNum2") and len(trim(form.PageNum2))>
				<cfset form.Pagina2 = form.PageNum2>
			</cfif>
			<!--- PARAMETROS DEL DETALLE Y LA LISTA DE DETALLES --->
			<!---  VARIABLE LlAVE PARA CUANDO VIENE DEL SQL --->
			<cfif isdefined("url.Filtro_Valor") and  len(trim(url.Filtro_Valor))>
				<cfset form.Filtro_Valor = url.Filtro_Valor>
			</cfif>
			<cfif isdefined("url.Filtro_Descripcion") and  len(trim(url.Filtro_Descripcion))>
				<cfset form.Filtro_Descripcion = url.Filtro_Descripcion>
			</cfif>

			<cfif isdefined("url.Filtro_equivalencia") and len(trim(url.Filtro_equivalencia))>
				<cfset form.Filtro_equivalencia = url.Filtro_equivalencia>
			</cfif>
			<cfif isdefined("url.Filtro_minimo") and len(trim(url.Filtro_minimo))>
				<cfset form.Filtro_minimo = url.Filtro_minimo>
			</cfif>
			<cfif isdefined("url.Filtro_maximo") and len(trim(url.Filtro_maximo))>
				<cfset form.Filtro_maximo = url.Filtro_maximo>
			</cfif>


			<!--- VALORES POR DEFECTO DE LAS VARIBLES REQUERIDAS PORQUE SIEMPRE SE USAN EN EL FORM PARA ENVIARLAS AL SQL --->
			<cfparam name="form.Pagina2" default="1">					
			<cfparam name="form.Filtro_Valor" default="">
			<cfparam name="form.Filtro_Descripcion" default="">
			<cfparam name="form.Filtro_Equivalencia" default="0">
			<cfparam name="form.Filtro_Minimo" default="0">
			<cfparam name="form.Filtro_Maximo" default="0.00">
			<cfparam name="form.MaxRows2" default="15">

			<!--- Aqui se incluye el form --->

			<table width="100%" border="0" >
              <tr>
                <td>
					<cfinclude template="formTablaEvaluac.cfm"> 				
				</td>
              </tr>
            </table>
		</cf_web_portlet>
	</cf_templatearea>
</cf_template>