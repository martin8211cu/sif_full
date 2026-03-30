<!--- 
	Menú Principal de Tarjetas de Credito Empresarial
--->
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
						<cf_menu SScodigo="SIF" SMcodigo="TCE" Size="250" excluirColumna="123">
					</td>
					<td valign="top"></td>
				</tr>
			</table>
		<cf_web_portlet_end>
<cf_templatefooter>