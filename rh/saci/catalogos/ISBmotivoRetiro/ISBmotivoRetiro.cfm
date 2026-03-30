<cfset CurrentPage = GetFileFromPath(GetTemplatePath())>

<cfsavecontent variable="pNavegacion">
	<cfinclude template="/home/menu/pNavegacion.cfm">
</cfsavecontent>

<cf_templateheader title="#nav__SPdescripcion#">
	<cfoutput>#pNavegacion#</cfoutput>
	<cfinclude template="ISBmotivoRetiro-params.cfm">
	
	<cf_web_portlet_start titulo="#nav__SPdescripcion#">
		<cfinvoke component="sif.Componentes.pListas" method="pLista"
			tabla="ISBmotivoRetiro"
			columnas="MRid,MRcodigo,MRnombre,'#pagina#' as pagina"
			filtro="1=1 order by MRcodigo"
			desplegar="MRcodigo,MRnombre"
			etiquetas="Código Motivo,Nombre Motivo"
			formatos="S,S"
			align="left,left"
			ira="ISBmotivoRetiro-edit.cfm"
			form_method="post"
			keys="MRid"
			mostrar_filtro="yes"
			filtrar_automatico="yes"
			botones="Nuevo"
			maxrows="15"
		/>
<cf_web_portlet_end>
<cf_templatefooter>


