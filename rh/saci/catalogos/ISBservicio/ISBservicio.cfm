<cfset CurrentPage = GetFileFromPath(GetTemplatePath())>

<cfsavecontent variable="pNavegacion">
	<cfinclude template="/home/menu/pNavegacion.cfm">
</cfsavecontent>

<cf_templateheader title="#nav__SPdescripcion#">
	<cfoutput>#pNavegacion#</cfoutput>

	<cf_web_portlet_start titulo="<cfoutput>#nav__SPdescripcion#</cfoutput>">
	
			<table width="100%" border="0"  cellpadding="0" cellspacing="0">
              <tr>
                <td>
					
					<!------------------------Variables que vienen del url y de form---------------------------------------->
					
					<!--- VARIABLE DE PAGINA DE LA LISTA PRINCIPAL---->
					<cfif isdefined("url.Pagina") and len(trim(url.Pagina))>
						<cfset form.Pagina = url.Pagina>
					</cfif>					
					<!---  FILTROS DE LA LISTA PRINCIPAL--->
					<cfif isdefined("url.Filtro_PQnombre") and len(trim(url.Filtro_PQnombre))>
						<cfset form.Filtro_PQnombre = url.Filtro_PQnombre>
					</cfif>
					<cfif isdefined("url.Filtro_PQdescripcion") and len(trim(url.Filtro_PQdescripcion))>
						<cfset form.Filtro_PQdescripcion = url.Filtro_PQdescripcion>
					</cfif>
					
					<!---- ID DE LA LISTA PRINCIPAL--->
					<cfif isdefined("Url.Mconsecutivo") and not isdefined("Form.Mconsecutivo")>
						<cfparam name="Form.Mconsecutivo" default="#Url.Mconsecutivo#">		
					</cfif>
					<!--- VALORES POR DEFECTO DE LAS VARIBLES REQUERIDAS PORQUE SIEMPRE SE USAN EN EL FORM PARA ENVIARLAS AL SQL --->
					<cfparam name="form.Pagina" default="1">					
					<cfparam name="form.Filtro_PQnombre" default="">
					<cfparam name="form.Filtro_PQdescripcion" default="">
					<cfif len(trim(form.Pagina)) eq 0>
						<!--- CUANDO LE DAN CLICK AL FILTRAR EXISTE EL CAMPO PAGINA EN EL FORM PERO ESTÁ VACÍO PORQQUE EL CAMPO SE LLENA CUAND LE DAN CLICK A LA LISTA Y NO LE DIERON CLIK --->
						<cfset form.Pagina = 1>
					</cfif>	
					<!--- VARIABLE DE PAGINA DE LA LISTA DE DETALLES ---->
					<!--- Variable de Pagina para cuando viene la variable del mantenimiento--->
					<cfif isdefined("url.Pagina2") and len(trim(url.Pagina2))>
						<cfset form.Pagina2 = url.Pagina2>
					</cfif>					
					<!--- variable de pagina para cuando viene del clic en la navegacion--->			
					<cfif isdefined("url.PageNum_Lista2") and len(trim(url.PageNum_Lista2))>
						<cfset form.Pagina2 = url.PageNum_Lista2>
					</cfif>			
					<cfif isdefined("form.PageNum2") and len(trim(form.PageNum2))>
						<cfset form.Pagina2 = form.PageNum2>
					</cfif>
					<!---  FILTROS DE LA LISTA DE DETALLES--->
					<cfif isdefined("url.Filtro_TSnombre") and len(trim(url.Filtro_TSnombre))>
						<cfset form.Filtro_TSnombre = url.Filtro_TSnombre>
					</cfif>
					<cfif isdefined("url.Filtro_TSdescripcion") and len(trim(url.Filtro_TSdescripcion))>
						<cfset form.Filtro_TSdescripcion = url.Filtro_TSdescripcion>
					</cfif>
					
					<!--- VALORES POR DEFECTO DE LAS VARIBLES REQUERIDAS PORQUE SIEMPRE SE USAN EN EL FORM PARA ENVIARLAS AL SQL --->
					<cfparam name="form.Pagina2" default="1">					
					<cfparam name="form.Filtro_TSnombre" default="">
					<cfparam name="form.Filtro_TSdescripcion" default="">
					<cfparam name="form.MaxRows2" default="10">
					<cfif len(trim(form.Pagina2)) eq 0>
						<!--- CUANDO LE DAN CLICK AL FILTRAR EXISTE EL CAMPO PAGINA EN EL FORM PERO ESTÁ VACÍO PORQQUE EL CAMPO SE LLENA CUAND LE DAN CLICK A LA LISTA Y NO LE DIERON CLIK --->
						<cfset form.Pagina2 = 1>
					</cfif>	
					
					<!--- OTRAS VARIABLES DEFINIDAS ANTERIORMENTE--->
					<cfif isdefined("Url.PQnombre") and not isdefined("Form.PQnombre")>
						<cfparam name="Form.PQnombre" default="#Url.PQnombre#">
					</cfif>
					
					<cfinclude template="ISBservicio-form.cfm">
					
				</td>
			  </tr>
			</table>
					
		<cf_web_portlet_end>
<cf_templatefooter>