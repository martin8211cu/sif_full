<cfparam name="modo" default="ALTA">
<cfset CurrentPage=GetFileFromPath(GetTemplatePath())>
<cfsavecontent variable="pNavegacion">
	<cfinclude template="../../../sif/portlets/pNavegacion.cfm">
</cfsavecontent>
<cf_templateheader title="#nav__SPdescripcion#">
<cfoutput>#pNavegacion#</cfoutput>
<cf_web_portlet_start border="true" titulo="Aprobación de Movimientos" skin="#Session.Preferences.Skin#">
<cf_dbfunction name="OP_CONCAT"returnvariable="_Cat">
	<cfinclude template="aprobacionDepositos_form.cfm">
<cf_web_portlet_end>
<cf_templatefooter>