<cfset CurrentPage=GetFileFromPath(GetTemplatePath())>
<cfsavecontent variable="pNavegacion">
	<cfinclude template="/sif/portlets/pNavegacion.cfm">
</cfsavecontent>
<cf_templateheader title="#nav__SPdescripcion#">
	<cfoutput>#pNavegacion#</cfoutput>
		<cf_web_portlet_start titulo="<cfoutput>#nav__SPdescripcion#</cfoutput>">
			<table>
				<tr>
					<td valign="top">
						<cf_menu SScodigo="SIF" SMcodigo="CRAF">
					</td>
					<td valign="top">
						<cfinclude template="MenuCRAF-principal.cfm">
					</td>
				</tr>
			</table>			
		<cf_web_portlet_end>
<cf_templatefooter>