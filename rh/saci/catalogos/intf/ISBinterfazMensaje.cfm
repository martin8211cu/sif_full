<cfset CurrentPage = GetFileFromPath(GetTemplatePath())>

<cfsavecontent variable="pNavegacion">
	<cfinclude template="/home/menu/pNavegacion.cfm">
</cfsavecontent>

<cf_templateheader title="#nav__SPdescripcion#">
	<cfoutput>#pNavegacion#</cfoutput>
	<cfinclude template="ISBinterfazMensaje-params.cfm">
	
	<cf_web_portlet_start titulo="#nav__SPdescripcion#">
		<cfinvoke component="sif.Componentes.pListas" method="pLista"
			tabla="ISBinterfazMensaje"
			columnas="codMensaje, mensaje,'#pagina#' as pagina"
			filtro="1=1 order by codMensaje"
			desplegar="codMensaje,mensaje"
			etiquetas="Código,Mensaje"
			formatos="S,S"
			align="left,left"
			ira="ISBinterfazMensaje-edit.cfm"
			form_method="post"
			keys="codMensaje"
			mostrar_filtro="yes"
			filtrar_automatico="yes"
			botones="Nuevo"
			maxrows="15"
		/>
	<cf_web_portlet_end/>
<cf_templatefooter>

