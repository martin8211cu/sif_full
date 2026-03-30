<!---
** Mantenimiento Materias Sustitutivas
** Hecho por: 		Rodolfo Jiménez Jara
** Fecha: 			23-Diciembre-2002
** Comentarios: 
** Aquí se relacionan las materias Electivas , con las materia ya asociados a los grados en grados sustitutivas.
--->

<!---
** Mantenimiento Materias Sustitutivas
** Modificado por: 	Karol Rodríguez
** Fecha: 			23-Enero-2006
** Comentarios: 	Hice los cambios en el uso del componente de listas y otros, basicamente la pantalla funciona igual 
** 					que como funcionaba antes, los cambios realizados son para adaptar la pantalla al framework de minisif
--->

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
			<table width="100%" border="0"  cellpadding="0" cellspacing="0">
              <tr>
                <td>
					
					<!------------------------Variables que vienen del url y de form---------------------------------------->
					
					<!--- VARIABLE DE PAGINA DE LA LISTA PRINCIPAL---->
					<cfif isdefined("url.Pagina") and len(trim(url.Pagina))>
						<cfset form.Pagina = url.Pagina>
					</cfif>					
					<!---  FILTROS DE LA LISTA PRINCIPAL--->
					<cfif isdefined("url.Filtro_Mnombre") and len(trim(url.Filtro_Mnombre))>
						<cfset form.Filtro_Mnombre = url.Filtro_Mnombre>
					</cfif>
					<cfif isdefined("url.Filtro_Mhoras") and len(trim(url.Filtro_Mhoras))>
						<cfset form.Filtro_Mhoras = url.Filtro_Mhoras>
					</cfif>
					<cfif isdefined("url.Filtro_Mcreditos") and len(trim(url.Filtro_Mcreditos))>
						<cfset form.Filtro_Mcreditos = url.Filtro_Mcreditos>
					</cfif>
					<!---- ID DE LA LISTA PRINCIPAL--->
					<cfif isdefined("Url.Mconsecutivo") and not isdefined("Form.Mconsecutivo")>
						<cfparam name="Form.Mconsecutivo" default="#Url.Mconsecutivo#">		
					</cfif>
					<!--- VALORES POR DEFECTO DE LAS VARIBLES REQUERIDAS PORQUE SIEMPRE SE USAN EN EL FORM PARA ENVIARLAS AL SQL --->
					<cfparam name="form.Pagina" default="1">					
					<cfparam name="form.Filtro_Mnombre" default="">
					<cfparam name="form.Filtro_Mhoras" default="0.00">
					<cfparam name="form.Filtro_Mcreditos" default="0.00">
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
					<cfif isdefined("url.Filtro_Mnombre2") and len(trim(url.Filtro_Mnombre2))>
						<cfset form.Filtro_Mnombre2 = url.Filtro_Mnombre2>
					</cfif>
					<cfif isdefined("url.Filtro_Mhoras2") and len(trim(url.Filtro_Mhoras2))>
						<cfset form.Filtro_Mhoras2 = url.Filtro_Mhoras2>
					</cfif>
					<cfif isdefined("url.Filtro_Mcreditos2") and len(trim(url.Filtro_Mcreditos2))>
						<cfset form.Filtro_Mcreditos2 = url.Filtro_Mcreditos2>
					</cfif>
					<!--- VALORES POR DEFECTO DE LAS VARIBLES REQUERIDAS PORQUE SIEMPRE SE USAN EN EL FORM PARA ENVIARLAS AL SQL --->
					<cfparam name="form.Pagina2" default="1">					
					<cfparam name="form.Filtro_Mnombre2" default="">
					<cfparam name="form.Filtro_Mhoras2" default="0.00">
					<cfparam name="form.Filtro_Mcreditos2" default="0.00">
					<cfparam name="form.MaxRows2" default="10">
					<cfif len(trim(form.Pagina2)) eq 0>
						<!--- CUANDO LE DAN CLICK AL FILTRAR EXISTE EL CAMPO PAGINA EN EL FORM PERO ESTÁ VACÍO PORQQUE EL CAMPO SE LLENA CUAND LE DAN CLICK A LA LISTA Y NO LE DIERON CLIK --->
						<cfset form.Pagina2 = 1>
					</cfif>	
					
					<!--- OTRAS VARIABLES DEFINIDAS ANTERIORMENTE--->
					<cfif isdefined("Url.Mnombre") and not isdefined("Form.Mnombre")>
						<cfparam name="Form.Mnombre" default="#Url.Mnombre#">
					</cfif>
					
					<cfinclude template="formMateriasElectivas.cfm">
					
				</td>
			  </tr>
			</table>
					
		</cf_web_portlet>
	</cf_templatearea>
</cf_template>