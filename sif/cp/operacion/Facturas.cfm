<cfif isdefined ('url.tipoF')>
	<cfset tipoF=#url.tipoF#>
</cfif>

<cfif isdefined ('url.LvarTipo')>
	<cfset form.LvarTipo=#url.LvarTipo#>
</cfif>
<cfif isdefined ('root')>
	<cfset form.root=#root#>
</cfif>

<cfif isdefined ('tipoF')>
	<cfset form.tipoF=#tipoF#>
</cfif>

	<cfset LvarTitulo = "">
		<cfif isdefined("tipoF") and #tipoF# eq 'A'>
			<cfset LvarTitulo = "Aplicar Facturas">
		<cfelseif isdefined("tipoF") and #tipoF# eq 'C'>
			 <cfset LvarTitulo = "Registro de Facturas por Usuario">
		<cfelseif isdefined("tipoF") and #tipoF# eq 'D'>
			 <cfset LvarTitulo = "Lista Notas de Crédito">
		<cfelseif isdefined("tipoF") and #tipoF# eq 'F'>
			 <cfset LvarTitulo = "Lista de Facturas">
		</cfif>

		<cf_templateheader title="#LvarTitulo#">
		<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='#LvarTitulo#'>
			<cfinclude template="../../portlets/pNavegacion.cfm">
			
			<cfif (isdefined('form.IDdocumento') and len(trim(form.IDdocumento))) OR (isdefined('form.btnNuevo')) OR (isdefined('url.Nuevo'))or (isdefined('form.Nuevo')or isdefined('url.IDdocumento'))>
				<cfinclude template="formRegistroFacturasCP.cfm">			
			<cfelse>

				<cfset tipoF = #tipoF#>
				<cfinclude template="listaFacturasCP.cfm">
			</cfif>
  <cf_web_portlet_end>
<cf_templatefooter>
