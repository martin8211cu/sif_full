<!--- Este fuente requiere saber que vista debe mostrar --->
<cfif isdefined("url.id_vista") and len(url.id_vista)><cfset form.id_vista = url.id_vista></cfif>
<cfif isdefined("url.id_tipo") and len(url.id_tipo)><cfset form.id_tipo = url.id_tipo></cfif>
<cfif isdefined("form.id_vista") and isdefined("form.id_tipo")
		and len(trim(form.id_vista)) and len(trim(form.id_tipo))>
	<cfset rsVista ="rsVista_#form.id_vista#_#form.id_tipo#">
	<cfset CurrentPage=GetFileFromPath(GetTemplatePath())>
	<!--- 	LECTURA DE LA VISTA  --->
	<cfinvoke component="home.tramites.componentes.vistas" method="getVista" id_vista="#form.id_vista#" id_tipo="#form.id_tipo#" returnvariable="rsVista">
	<cfset rsVista_titulo_vista = rsVista.titulo_vista>
<cfelse>
	<cfset rsVista_titulo_vista = "Lista de Documentos">
</cfif>
<cf_template>
<cf_templatearea name="title">
  <cfoutput>#rsVista_titulo_vista#</cfoutput>
</cf_templatearea>
<cf_templatearea name="body">
<cf_web_portlet_start titulo='#rsVista_titulo_vista#'>
	<cfinclude template="/home/menu/pNavegacion.cfm">
	<cfif isdefined("form.id_vista") and isdefined("form.id_tipo")
		and len(trim(form.id_vista)) and len(trim(form.id_tipo))>
		<cfinclude template="vistas-form.cfm">
	<cfelse>
		<cfinclude template="vistas-lista.cfm">
	</cfif>
<cf_web_portlet_end>
</cf_templatearea>
</cf_template>