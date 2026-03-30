<cfset CurrentPage=GetFileFromPath(GetTemplatePath())>
<cfsavecontent variable="pNavegacion">
	<cfinclude template="../../../sif/portlets/pNavegacion.cfm">
</cfsavecontent>
<!---<cfdump var="#form#">--->
<cf_templateheader title="#nav__SPdescripcion#">
<cfoutput>#pNavegacion#</cfoutput>
<cf_web_portlet_start border="true" titulo="Liberación Garantías" skin="#Session.Preferences.Skin#">
	<cfinclude template="libe_ejec_Garantia_form.cfm">
<cf_web_portlet_end>
<cf_templatefooter>