<cfset CurrentPage = GetFileFromPath(GetTemplatePath())>

<cfsavecontent variable="pNavegacion">
	<cfinclude template="/home/menu/pNavegacion.cfm">
</cfsavecontent>

<cf_templateheader title="#nav__SPdescripcion#">
	<cfoutput>#pNavegacion#</cfoutput>
	<cfinclude template="ISBmedioRango-params.cfm">
	
	<cf_web_portlet_start titulo="#nav__SPdescripcion#">
		<cfinvoke component="sif.Componentes.pListas" method="pLista"
			tabla="ISBmedioRango"
			columnas="MRid,access_server,MRdesde,MRhasta,'#pagina#' as pagina"
			filtro="1=1 order by access_server,MRdesde"
			desplegar="access_server,MRdesde,MRhasta"
			etiquetas="Servidor de acceso,Desde,Hasta"
			formatos="S,S,S"
			align="left,left,left"
			ira="ISBmedioRango-edit.cfm"
			form_method="post"
			keys="MRid"
			mostrar_filtro="yes"
			filtrar_automatico="yes"
			filtrar_por="access_server,MRdesde,MRhasta"
			botones="Nuevo"
			maxrows="15"
		/>
	<cf_web_portlet_end>
<cf_templatefooter>

