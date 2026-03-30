<cfset CurrentPage = GetFileFromPath(GetTemplatePath())>

<cfsavecontent variable="pNavegacion">
	<cfinclude template="/home/menu/pNavegacion.cfm">
</cfsavecontent>

<cf_templateheader title="#nav__SPdescripcion#">
	<cfoutput>#pNavegacion#</cfoutput>
	<cfinclude template="ISBrangoValoracion-params.cfm">
	
	<cf_web_portlet_start titulo="#nav__SPdescripcion#">
		<cfinvoke component="sif.Componentes.pListas" method="pLista"
			tabla="ISBrangoValoracion"
			columnas="rangoid,rangodes,rangotope,'#pagina#' as pagina"
			filtro="1=1 order by rangotope"
			desplegar="rangodes,rangotope"
			etiquetas="Descripción,Porcentaje Mínimo"
			formatos="S,S"
			align="left,left"
			ira="ISBrangoValoracion-edit.cfm"
			form_method="post"
			keys="rangoid"
			mostrar_filtro="yes"
			filtrar_automatico="yes"
			botones="Nuevo"
			maxrows="15"
		/>
	<cf_web_portlet_end>
<cf_templatefooter>


