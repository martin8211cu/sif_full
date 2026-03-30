<!--- 
	Modificado por: Ana Villavicencio
	Fecha: 07 de febrero del 2006
	Motivo: Actualizacin de fuentes de educación a nuevos estndares de Pantallas y Componente de Listas.
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
			<cfif isdefined("Url.Mconsecutivo") and not isdefined("Form.Mconsecutivo")>
				<cfparam name="Form.Mconsecutivo" default="#Url.Mconsecutivo#">
			</cfif>
			<cfif isdefined('Url.Detalle') and not isdefined('form.Detalle')>
				<cfparam name="Form.Detalle" default="#url.Detalle#">
			</cfif>
			<!--- VARIABLE DE PAGINA PARA CUANDO VIENE DEL SQL--->		
			<cfif isdefined("url.Pagina") and len(trim(url.Pagina))>
				<cfset form.Pagina = url.Pagina>
			</cfif>		
			<!--- VARIABLE DE PAGINA PARA CUANDO VIENE DEL CLICK EN LA NAVEGACION--->
			<cfif isdefined("url.PageNum_Lista") and len(trim(url.PageNum_Lista))>
				<cfset form.Pagina = url.PageNum_Lista>
			</cfif>					
			<!--- VARIABLE DE PAGINA PARA CUANDO VIENE DEL CLICK EN LA LISTA--->
			<cfif isdefined("form.PageNum") and len(trim(form.PageNum))>
				<cfset form.Pagina = form.PageNum>
			</cfif>
			<cfif isdefined('url.Filtro_Mcodigo') and LEN(TRIM(url.Filtro_Mcodigo))>
				<cfset form.Filtro_Mcodigo = url.Filtro_Mcodigo>
			</cfif>
			<cfif isdefined('url.Filtro_MTdescripcion') and LEN(TRIM(url.Filtro_MTdescripcion))>
				<cfset form.Filtro_MTdescripcion = url.Filtro_MTdescripcion>
			</cfif>
			<cfif isdefined('url.Filtro_Melectiva') and LEN(TRIM(url.Filtro_Melectiva))>
				<cfset form.Filtro_Melectiva = url.Filtro_Melectiva>
			</cfif>
			<cfif isdefined('url.Filtro_Mnombre') and LEN(TRIM(url.Filtro_Mnombre))>
				<cfset form.Filtro_Mnombre = url.Filtro_Mnombre>
			</cfif>
			<cfif isdefined('url.FNcodigoC') and LEN(TRIM(url.FNcodigoC))>
				<cfset form.FNcodigoC = url.FNcodigoC>
			</cfif>
			<cfif isdefined('url.FGcodigoC') and LEN(TRIM(url.FGcodigoC))>
				<cfset form.FGcodigoC = url.FGcodigoC>
			</cfif>
			<cfif isdefined('url.HFiltro_Mcodigo') and LEN(TRIM(url.HFiltro_Mcodigo))>
				<cfset form.HFiltro_Mcodigo = url.HFiltro_Mcodigo>
			</cfif>
			<cfif isdefined('url.HFiltro_MTdescripcion') and LEN(TRIM(url.HFiltro_MTdescripcion))>
				<cfset form.HFiltro_MTdescripcion = url.HFiltro_MTdescripcion>
			</cfif>
			<cfif isdefined('url.HFiltro_Melectiva') and LEN(TRIM(url.HFiltro_Melectiva))>
				<cfset form.HFiltro_Melectiva = url.HFiltro_Melectiva>
			</cfif>
			<cfif isdefined('url.HFiltro_Mnombre') and LEN(TRIM(url.HFiltro_Mnombre))>
				<cfset form.HFiltro_Mnombre = url.HFiltro_Mnombre>
			</cfif>
			<cfparam name="Pagina" default="1">
			<cfparam name="form.Filtro_Mcodigo" default="">
			<cfparam name="form.Filtro_MTdescripcion" default="-1">
			<cfparam name="form.Filtro_Melectiva" default="-1">
			<cfparam name="form.Filtro_Mnombre" default="">
			<cfparam name="form.FNcodigoC" default="-1">
			<cfparam name="form.FGcodigoC" default="-1">
			<cfparam name="form.HFiltro_Mcodigo" default="">
			<cfparam name="form.HFiltro_MTdescripcion" default="-1">
			<cfparam name="form.HFiltro_Melectiva" default="-1">
			<cfparam name="form.HFiltro_Mnombre" default="">
			<table width="100%"  border="0" cellspacing="0" cellpadding="0" style="margin:0">
				<tr>
					<td valign="top">	
						<cfif not isdefined('form.Detalle')>
							<cfinclude template="formMaterias.cfm">
						<cfelse>
							
							<cfinclude template="MateriaDetalle.cfm">
						</cfif>
					</td>
				</tr>
			</table>
		</cf_web_portlet>
	</cf_templatearea>
</cf_template>