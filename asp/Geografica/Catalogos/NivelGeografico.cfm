<cfparam name="modo"  default="ALTA"></cfparam>
<cfparam name="modoL" default="ALTA"></cfparam>
<cfparam name="modoA" default="ALTA"></cfparam>
<cfif isdefined('form.btnNuevo')>
	<cfset modoL = "ALTA">
</cfif>
<cfif isdefined('form.Ppais')>
	<cfset modoL = "CAMBIO">
</cfif>
<cfif isdefined('form.NGid')>
	<cfset modoA = "CAMBIO">
</cfif>
<cfset CurrentPage=GetFileFromPath(GetTemplatePath())>
<cfsavecontent variable="pNavegacion">
	<cfinclude template="../../../sif/portlets/pNavegacion.cfm">
</cfsavecontent>
<cf_templateheader title="#nav__SPdescripcion#">
<cfoutput>#pNavegacion#</cfoutput>
	<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo="#nav__SPdescripcion#">
	<cfif modoL eq 'CAMBIO' or modoA eq 'CAMBIO'>
		<cfinclude template="NivelGeografico-Form.cfm">
	<cfelse>
		<cfset irA = "NivelGeografico.cfm">
		<cfset BtnsMostrar = "Nuevo">
		<cfinclude template="NivelGeografico-Lista.cfm">
	</cfif>
	<cf_web_portlet_end>
<cf_templatefooter>