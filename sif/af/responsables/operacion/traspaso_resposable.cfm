<!--- Funcionalidad Especial El Usuario Funciona como Id del Documento por Falta de ID de Documento. --->
<cfset CurrentPage=GetFileFromPath(GetTemplatePath())>
<cfsavecontent variable="pNavegacion">
	<cfinclude template="/sif/portlets/pNavegacion.cfm">
</cfsavecontent>
<cf_templateheader title="#nav__SPdescripcion#">
	<cfoutput>#pNavegacion#</cfoutput>
	<cf_web_portlet_start titulo="<cfoutput>#nav__SPdescripcion#</cfoutput>">
		<cf_web_portlet_start titulo="Par&aacute;metros de la Transferencia">
		<cfinclude template="traspaso_responsable-form.cfm">
		<cf_web_portlet_end>
		<cf_web_portlet_start titulo="Lista de Documentos por Transferir">
		<cfinclude template="traspaso_responsable-lista-dets.cfm">
		<cf_web_portlet_end>
	<cf_web_portlet_end>
<cf_templatefooter>