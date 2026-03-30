<cfset CurrentPage=GetFileFromPath(GetTemplatePath())>
<cfsavecontent variable="pNavegacion">
	<cfinclude template="/sif/portlets/pNavegacion.cfm">
</cfsavecontent>

<cf_templateheader title="#nav__SPdescripcion#">
    <cfoutput>#pNavegacion#</cfoutput>
    <cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo="#nav__SPdescripcion#">
        <cfinclude template="listadoCompradores-form.cfm">
    <cf_web_portlet_end>	
<cf_templatefooter>