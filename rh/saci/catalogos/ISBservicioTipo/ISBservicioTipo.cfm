<cfset CurrentPage = GetFileFromPath(GetTemplatePath())>

<cfsavecontent variable="pNavegacion">
	<cfinclude template="/home/menu/pNavegacion.cfm">
</cfsavecontent>

<cf_templateheader title="#nav__SPdescripcion#">
	<cfoutput>#pNavegacion#</cfoutput>
	<cfinclude template="ISBservicioTipo-params.cfm">

	<cf_web_portlet_start titulo="#nav__SPdescripcion#">
		<cfinvoke component="sif.Componentes.pListas" method="pLista"
			tabla="ISBservicioTipo"
			columnas="TScodigo,TSnombre,TSobservacion,'#pagina#' as pagina"
			filtro="Ecodigo = #session.Ecodigo# order by TScodigo,TSnombre,TSobservacion"
			desplegar="TScodigo,TSnombre,TSobservacion"
			etiquetas="Tipo de servicio,Nombre,Observación"
			formatos="S,S,S"
			align="left,left,left"
			ira="ISBservicioTipo-edit.cfm"
			form_method="post"
			keys="TScodigo"
			mostrar_filtro="yes"
			filtrar_automatico="yes"
			botones="Nuevo"
			maxrows="20"
		/>
	<cf_web_portlet_end>
<cf_templatefooter>
