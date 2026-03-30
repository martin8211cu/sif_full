<cfset CurrentPage = GetFileFromPath(GetTemplatePath())>

<cfsavecontent variable="pNavegacion">
	<cfinclude template="/home/menu/pNavegacion.cfm">
</cfsavecontent>

<cf_templateheader title="#nav__SPdescripcion#">
	<cfoutput>#pNavegacion#</cfoutput>
	<cfinclude template="ISBinterfaz-params.cfm">
	
	<cf_web_portlet_start titulo="#nav__SPdescripcion#">
		<cfinvoke component="sif.Componentes.pListas" method="pLista"
			tabla="ISBinterfaz"
			columnas="interfaz,S02ACC,nombreInterfaz,componente,metodo,'#pagina#' as pagina"
			filtro="1=1 order by interfaz"
			desplegar="interfaz,S02ACC,nombreInterfaz,componente,metodo"
			etiquetas="Código,Letra,Nombre,Componente,Método"
			formatos="S,S,S,S,S"
			align="left,left,left,left,left"
			ira="ISBinterfaz-edit.cfm"
			form_method="post"
			keys="interfaz"
			mostrar_filtro="yes"
			filtrar_automatico="yes"
			botones="Nuevo,Exportar"
			maxrows="40"
		/>
	<cf_web_portlet_end/>
	<script type="text/javascript">
		function funcExportar(){
			location.href=('ISBinterfaz-apply.cfm?exportar=si');
			return false;
		}
	</script>
<cf_templatefooter>
