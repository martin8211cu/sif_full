<cf_template>
	<cf_templatearea name="title">Cuestionarios</cf_templatearea>
	<cf_templatearea name="body">
		<cf_web_portlet_start border="true" titulo="Cuestionarios" >
			<table width="100%" cellpadding="0" cellspacing="0" style="vertical-align:bottom; ">
				<tr><td colspan="2"><cfinclude template="/rh/portlets/pNavegacion.cfm"></td></tr>
				<tr>
					<td valign="top" width="150"><cfinclude template="../menu.cfm"></td>
					<td valign="top">
						<table width="100%" border="0" cellpadding="0" cellspacing="0">
							<tr>
								<td align="center" valign="top" >
									<cfinclude template="../../evaluaciondes/operacion/registro_evaluacion.cfm">
								</td>
							</tr>
							<tr><td>&nbsp;</td></tr>
						</table>
					</td>
				</tr>
			</table>
		<cf_web_portlet_end>		
	</cf_templatearea>
</cf_template>