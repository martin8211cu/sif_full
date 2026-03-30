<cfparam name="LvarTrasladoExterno" default="false">
<cfif LvarTrasladoExterno>
	<cfset LvarTitulo = "Asignación de Traslados de Presupuesto a Documento de Autorización Externa">
<cfelse>
	<cfset LvarTitulo = "Registro de Traslados de Presupuesto">
</cfif>

<cf_templateheader title="#LvarTitulo#">
	<cf_web_portlet_start titulo="#LvarTitulo#">
		<cfinclude template="/sif/portlets/pNavegacion.cfm">
		<CF_onEnterKey enterActionDefault="none">
		<cfset session.CPformTipo = "registro">
		<cfinclude template="traslado-form.cfm">
	<cf_web_portlet_end>
<cf_templatefooter>