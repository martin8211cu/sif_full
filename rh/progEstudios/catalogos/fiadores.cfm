<cfparam name="modo" default="ALTA">

<cfset CurrentPage=GetFileFromPath(GetTemplatePath())>
<cfsavecontent variable="pNavegacion">
	<cfinclude template="../../../sif/portlets/pNavegacion.cfm">
</cfsavecontent>

<cfset titulo = "Tipos de Becas">
<cfif isdefined('form.ConceptosB')>
	<cfset titulo = "Conceptos por Tipos de Becas">
</cfif>
<cfif isdefined('form.FormatosB')>
	<cfset titulo = "Formatos">
</cfif>
<cf_templateheader title="#nav__SPdescripcion#">
	<cfoutput>#pNavegacion#</cfoutput>
    <cf_web_portlet_start border="true" titulo="#titulo#" skin="#Session.Preferences.Skin#">
    	<table width="100%" border="0" cellpadding="0" cellspacing="0">
        	<tr>
                <td>
                  <cfinclude template="fiadores-form.cfm">
                </td>
        	</tr>
		</table>
    <cf_web_portlet_end>
<cf_templatefooter>