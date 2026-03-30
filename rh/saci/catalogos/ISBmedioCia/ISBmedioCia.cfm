<cfset CurrentPage = GetFileFromPath(GetTemplatePath())>

<cfsavecontent variable="pNavegacion">
	<cfinclude template="/home/menu/pNavegacion.cfm">
</cfsavecontent>

<cf_templateheader title="#nav__SPdescripcion#">
	<cfoutput>#pNavegacion#</cfoutput>
	<cfinclude template="ISBmedioCia-params.cfm">
	
	<cf_web_portlet_start titulo="#nav__SPdescripcion#">
		<cfinvoke component="sif.Componentes.pListas" method="pLista"
			tabla="ISBmedioCia"
			columnas="EMid,EMnombre,'#pagina#' as pagina"
			filtro="Ecodigo=#session.Ecodigo# order by EMnombre"
			desplegar="EMnombre"
			etiquetas="Nombre Empresa"
			formatos="S"
			align="left"
			ira="ISBmedioCia-edit.cfm"
			form_method="post"
			keys="EMid"
			mostrar_filtro="yes"
			filtrar_automatico="yes"
			botones="Nuevo"
			maxrows="15"
		/>
	<cf_web_portlet_end>
<cf_templatefooter>

