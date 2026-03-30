<cfparam name="modo" default="ALTA">
<cfparam name="url.tab" default="1">
<cfset CurrentPage=GetFileFromPath(GetTemplatePath())>
<cfsavecontent variable="pNavegacion">
	<cfinclude template="../../../sif/portlets/pNavegacion.cfm">
</cfsavecontent>
<!---<cfdump var="#form#">--->
<cf_templateheader title="#nav__SPdescripcion#">
<cfoutput>#pNavegacion#</cfoutput>
<cf_web_portlet_start border="true" titulo="Aprobración Garantías en Liberación" skin="#Session.Preferences.Skin#">
	<cfinclude template="aprobarGarantia_form.cfm">
<cf_web_portlet_end>
<cf_templatefooter>