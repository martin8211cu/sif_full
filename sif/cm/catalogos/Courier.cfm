<cf_templateheader title="Compras - Couriers">
		<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='Cat&aacute;logo de Couriers'>
			<cfinclude template="../../portlets/pNavegacionCM.cfm">
			<table width="100%" border="0" cellspacing="0" cellpadding="0">
				<tr> 
					<td width="60%" valign="top"> 
						<!--- Lista --->
						<cfinclude template="Courier-lista.cfm">
					</td>
					<td valign="top">
						<cfinclude template="Courier-form.cfm">
					</td>
				</tr>
			</table>
		<cf_web_portlet_end>
	<cf_templatefooter>
