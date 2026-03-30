<!--- 
	Modificado por: Ana Villavicencio
	Fecha: 25 de febrero del 2006
	Motivo: Actualización de fuentes de educación a nuevos estándares de Pantallas y Componente de Listas.
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
				<cfset form.Pagina2 = form.PageNum>
			</cfif>
			<cfif isdefined('url.Filtro_Hnombre')>
				<cfset form.Filtro_Hnombre = url.Filtro_Hnombre>
			</cfif>
			<cfif isdefined('url.HFiltro_Hnombre')>
				<cfset form.HFiltro_Hnombre = url.HFiltro_Hnombre>
			</cfif>
			<!--- VARIABLE DE PAGINA PARA CUANDO VIENE DEL SQL--->		
			<cfif isdefined("url.Pagina2") and len(trim(url.Pagina2))>
				<cfset form.Pagina2 = url.Pagina2>
			</cfif>		
			<!--- VARIABLE DE PAGINA PARA CUANDO VIENE DEL CLICK EN LA NAVEGACION--->
			<cfif isdefined("url.PageNum_Lista2") and len(trim(url.PageNum_Lista2))>
				<cfset form.Pagina2 = url.PageNum_Lista2>
			</cfif>					
			<!--- VARIABLE DE PAGINA PARA CUANDO VIENE DEL CLICK EN LA LISTA--->
			<cfif isdefined("form.PageNum2") and len(trim(form.PageNum2))>
				<cfset form.Pagina2 = form.PageNum2>
			</cfif>
			<cfif isdefined("url.Hcodigo") and len(trim(url.Hcodigo))>
				<cfset form.Hcodigo = url.Hcodigo>
			</cfif>		
			<cfif isdefined("url.Hbloque") and len(trim(url.Hbloque))>
				<cfset form.Hbloque = url.Hbloque>
			</cfif>	
			<cfparam name="form.Pagina2" default="1">
			<cfoutput>#pNavegacion#</cfoutput>
			<script language="JavaScript1.4" type="text/javascript" src="../../js/utilesMonto.js" >//</script>
			<table width="100%" border="0">
				<tr><td><cfinclude template="formHorarioTipo.cfm"></td></tr>
			</table>
		</cf_web_portlet>
	</cf_templatearea>
</cf_template>