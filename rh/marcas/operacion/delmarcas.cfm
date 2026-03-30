<cfset CurrentPage=GetFileFromPath(GetTemplatePath())>
<cfsavecontent variable="pNavegacion">
	<cfinclude template="/home/menu/pNavegacion.cfm">
</cfsavecontent>
<cf_templateheader>
	<cfoutput>
		<cfinvoke component="sif.Componentes.TranslateDB"
			method="Translate"
			VSvalor="#session.monitoreo.SScodigo#.#session.monitoreo.SMcodigo#.#session.monitoreo.SPcodigo#"
			Default="Tipos de Deducciones a Excluir"
			VSgrupo="103"
			returnvariable="LB_titulo"/>
		<cf_web_portlet_start titulo="#LB_titulo#">
			#pNavegacion#
			<cfinclude template="delmarcas-form.cfm">
		<cf_web_portlet_end>
	</cfoutput>
<cf_templatefooter>