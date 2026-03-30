<cfset CurrentPage=GetFileFromPath(GetTemplatePath())>
<cfsavecontent variable="pNavegacion">
	<cfinclude template="/sif/portlets/pNavegacion.cfm">
</cfsavecontent>
<cf_templateheader title="#nav__SPdescripcion#">
	<cfoutput>#pNavegacion#</cfoutput>
		<cf_web_portlet_start titulo="<cfoutput>#nav__SPdescripcion#</cfoutput>">
			<table width="99%" align="center" border="0" cellpadding="0" cellspacing="0">
				<tr> 
					<td valign="top" width="35%">
						<cfinclude template="arbolClasificacion.cfm">
					</td>
					<td valign="top" width="65%">
						<cfinclude template="formClasificacion.cfm">
					</td>
				</tr>
			</table>
		<cf_web_portlet_end>
	<cf_templatefooter>