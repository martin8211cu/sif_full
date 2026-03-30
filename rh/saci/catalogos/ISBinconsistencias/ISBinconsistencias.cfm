<cfset CurrentPage = GetFileFromPath(GetTemplatePath())>

<cfsavecontent variable="pNavegacion">
	<cfinclude template="/home/menu/pNavegacion.cfm">
</cfsavecontent>

<cf_templateheader title="#nav__SPdescripcion#">
	<cfoutput>#pNavegacion#</cfoutput>
	<cfinclude template="ISBinconsistencias-params.cfm">
	
	<cf_web_portlet_start titulo="#nav__SPdescripcion#">
		<cfinvoke component="sif.Componentes.pListas" method="pLista"
			tabla="ISBinconsistencias"
			columnas="Iid,Inombre,Idescripcion,'#pagina#' as pagina"
			filtro="1=1 order by Inombre,Idescripcion"
			desplegar="Inombre,Idescripcion"
			etiquetas="Nombre,Descripción"
			formatos="S,S"
			align="left,left"
			ira="ISBinconsistencias-edit.cfm"
			form_method="post"
			keys="Iid"
			mostrar_filtro="yes"
			filtrar_automatico="yes"
			botones="Nuevo"
			maxrows="15"
		/>
	<cf_web_portlet_end>
<cf_templatefooter>


