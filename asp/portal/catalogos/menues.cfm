	<cf_templateheader title="Definici&oacute;n de Men&uacute;es">
			<cfset titulo = "Menues">
			<cfinclude template="/home/menu/pNavegacion.cfm">
			<table width="100%" border="0" cellspacing="1" cellpadding="1">
			  <tr>
					<td valign="top">
						<table border="0" cellpadding="2" cellspacing="0" width="100%">
							<tr>
								<td valign="top" colspan="2">
									<cfinclude template="menues-arbol.cfm">
								</td>
							</tr>
						</table>								
					</td>
					<td valign="top">
						<cfif (Form.nivel EQ 3)>
							<cfinclude template="menues-form.cfm">
						</cfif>
					</td>
			  </tr>
			</table>		
<cf_templatefooter>
