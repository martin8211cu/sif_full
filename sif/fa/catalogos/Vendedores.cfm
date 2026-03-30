<cf_templateheader title="Vendedores">
	<cfinclude template="../../portlets/pNavegacionFA.cfm">
		<cf_web_portlet_start titulo="Cat&aacute;logo de Vendedores">
			<table width="100%" border="0" cellspacing="0" cellpadding="0">
				<tr>
			  		<td valign="top" width="30%">
						<cfinclude template="arbolVendedores.cfm">
					</td>
					<td valign="top">
						<cfinclude template="formVendedores.cfm">
					</td>
				</tr>
			</table>
 		<cf_web_portlet_end>
<cf_templatefooter>  