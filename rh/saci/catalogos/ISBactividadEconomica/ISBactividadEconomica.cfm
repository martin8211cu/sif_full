<cfset CurrentPage = GetFileFromPath(GetTemplatePath())>

<cfsavecontent variable="pNavegacion">
	<cfinclude template="/home/menu/pNavegacion.cfm">
</cfsavecontent>

<cf_templateheader title="#nav__SPdescripcion#">
	<cfoutput>#pNavegacion#</cfoutput>
	<cfinclude template="ISBactividadEconomica-params.cfm">
	
	<cf_web_portlet_start titulo="#nav__SPdescripcion#">
		<cfinvoke component="sif.Componentes.pListas" method="pLista"
			tabla="ISBactividadEconomica"
			columnas="AEactividad,AEnombre,'#pagina#' as pagina"
			filtro="1=1 order by AEactividad,AEnombre"
			desplegar="AEactividad,AEnombre"
			etiquetas="Código actividad,Nombre actividad"
			formatos="S,S"
			align="left,left"
			ira="ISBactividadEconomica-edit.cfm"
			form_method="post"
			keys="AEactividad"
			mostrar_filtro="yes"
			filtrar_automatico="yes"
			botones="Nuevo"
			maxrows="15"
		/>
	<cf_web_portlet_end>
<cf_templatefooter>
