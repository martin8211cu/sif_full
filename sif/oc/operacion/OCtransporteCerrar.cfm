<cfset LvarTitulo = "Ajustes por Sobrantes y Faltantes al Cierre de Transportes">
<cf_templateheader title="#LvarTitulo#">
	<cf_web_portlet_start titulo="#LvarTitulo#">
		<cf_navegacion name="OCTid" default="" navegacion="">
		<table width="100%" align="center">
			<tr>
				<td align="center">
					<cfset LvarCerrar = true>
					<cfinclude template="OCtransporte_list.cfm">
				</td>
			</tr>
		</table>
	<cf_web_portlet_end>
<cf_templatefooter>
