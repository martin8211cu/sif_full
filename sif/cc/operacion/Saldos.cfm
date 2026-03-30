<cf_templateheader title="Inventarios">
		<cfinclude template="../../portlets/pNavegacionIV.cfm">
		<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo="Eliminación de Saldos de Documentos con Montos Despreciables">
		<cfset TipoNeteo = 2>
		<cfif isdefined("url.idDocumentoNeteo") and len(trim(url.idDocumentoNeteo))>
			<cfset form.idDocumentoNeteo = url.idDocumentoNeteo>
		</cfif>
		<cfif isdefined("form.idDocumentoNeteo") or isdefined("form.btnNuevo") or isdefined("form.Nuevoneteo")>
			<cfinclude template="Neteo-form.cfm">
		<cfelse>
			<cfinclude template="Neteo-lista.cfm">
		</cfif>
		<cf_web_portlet_end> 
	<cf_templatefooter>