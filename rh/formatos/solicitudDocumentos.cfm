<cfset CurrentPage=GetFileFromPath(GetTemplatePath())>
<cfsavecontent variable="pNavegacion">
	<cfinclude template="/rh/portlets/pNavegacion.cfm">
</cfsavecontent>
<cf_template template="#session.sitio.template#">
	<cf_templatearea name="title">
		<cfoutput>#nav__SPdescripcion#</cfoutput>
	</cf_templatearea>
	<cf_templatearea name="body">
		<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		Key="LB_SolicitudDeDocumentos"
		Default="Solicitud de Documentos"
		returnvariable="LB_SolicitudDeDocumentos"/> 
		
		<cf_web_portlet_start titulo="<cfoutput>#LB_SolicitudDeDocumentos#</cfoutput>">
			<cfoutput>#pNavegacion#</cfoutput>
			<cfinclude template="solicitudDocumentos-form.cfm">
		<cf_web_portlet_end>
	</cf_templatearea>
</cf_template>