<cfset CurrentPage = GetFileFromPath(GetTemplatePath())>

<cfsavecontent variable="pNavegacion">
	<cfinclude template="/home/menu/pNavegacion.cfm">
</cfsavecontent>

<cf_templateheader title="#nav__SPdescripcion#">
	<cfoutput>#pNavegacion#</cfoutput>
	<cfinclude template="ISBgrupoCobro-params.cfm">

	<cf_web_portlet_start titulo="#nav__SPdescripcion#">
		<cfinvoke component="sif.Componentes.pListas" method="pLista"
			tabla="ISBgrupoCobro"
			columnas="GCcodigo,GCnombre,'#pagina#' as pagina"
			filtro="1=1 order by GCcodigo,GCnombre"
			desplegar="GCcodigo,GCnombre"
			etiquetas="Código Grupo de cobro,Nombre Grupo de cobro"
			formatos="I,S"
			align="left,left"
			ira="ISBgrupoCobro-edit.cfm"
			form_method="post"
			keys="GCcodigo"
			mostrar_filtro="yes"
			filtrar_automatico="yes"
			botones="Nuevo"
			maxrows="15"
		/>
	<cf_web_portlet_end>
<cf_templatefooter>
