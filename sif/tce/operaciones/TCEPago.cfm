
<cfif isdefined("Form.Cambio")>
	<cfset modo="CAMBIO">
<cfelse>
	<cfif not isdefined("Form.modo")>
		<cfset modo="ALTA">
	<cfelseif Form.modo EQ "CAMBIO">
		<cfset modo="CAMBIO">
	<cfelse>
		<cfset modo="ALTA">
	</cfif>
</cfif>

<cfif not isdefined("Form.modoDelete")>
	<cfset modoDet = "ALTA">
</cfif>

<cfif isDefined("Form.NuevoPago")>
	<cfset modo = "ALTA">
	<cfset modoDet = "ALTA">
</cfif>

<cfif isDefined("Form.datos") and Form.datos NEQ "">
	<cfset modo = "CAMBIO">
	<cfset modoDet = "ALTA">
</cfif>

<cfif isdefined("Form.btnNuevo")>
	<cfset modo = "ALTA">
</cfif>	

<cfif isdefined('url.ECid') and not isdefined('form.ECid')>
	<cfset form.ECid = url.ECid>
	<cfset modo = "CAMBIO">
	<cfset modoDet = "ALTA">
</cfif>

<cf_templateheader title="Generar Pago Tarjetas de Cr&eacute;dito">
	<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='Generar Pago Tarjetas de Cr&eacute;dito'>
		<cfinclude template="TCEPago-form.cfm">
	<cf_web_portlet_end>
<cf_templatefooter>

