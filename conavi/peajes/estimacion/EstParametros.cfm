<cfparam name="modo" default="ALTA"></cfparam>
<cfset CurrentPage=GetFileFromPath(GetTemplatePath())>
<cfsavecontent variable="pNavegacion">
	<cfinclude template="../../../sif/portlets/pNavegacion.cfm">
</cfsavecontent>
<cf_templateheader title="CONAVI - Parámetros">
<cfoutput>#pNavegacion#</cfoutput>
	<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo="Parámetros de Estimación">
<table width="700" border="0" align="center">
  <tr>
    <td>
	    <cfinclude template="EstParametrosLista.cfm">
	</td>
  </tr>
</table>
<cf_web_portlet_end>
<cf_templatefooter>