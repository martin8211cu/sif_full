<cfset CurrentPage = GetFileFromPath(GetTemplatePath())>

<cfsavecontent variable="pNavegacion">
	<cfinclude template="/home/menu/pNavegacion.cfm">
</cfsavecontent>

<cf_templateheader title="#nav__SPdescripcion#">
	<cfoutput>#pNavegacion#</cfoutput>
	<cfinclude template="ISBclaseCuenta-params.cfm">
	
	<cf_web_portlet_start titulo="#nav__SPdescripcion#">
		<cfinvoke component="sif.Componentes.pListas" method="pLista"
			tabla="ISBclaseCuenta"
			columnas="CCclaseCuenta,CCnombre,'#pagina#' as pagina"
			filtro="1=1 order by CCclaseCuenta,CCnombre"
			desplegar="CCclaseCuenta,CCnombre"
			etiquetas="Código clase de cuenta,Nombre clase de cuenta"
			formatos="S,S"
			align="left,left"
			ira="ISBclaseCuenta-edit.cfm"
			form_method="post"
			keys="CCclaseCuenta"
			mostrar_filtro="yes"
			filtrar_automatico="yes"
			botones="Nuevo"
			maxrows="15"
		/>
	<cf_web_portlet_end>
<cf_templatefooter>
