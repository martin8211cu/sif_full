
	<cf_templateheader title="Cuentas por Cobrar Empleados- Consulta de Saldos por Empleado">
	
	
		<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='Consulta Saldos por Empleado'>
			
			<cfoutput>
			<form name="form1" method="post" action="saldosEmpleado.cfm" style="margin: 0">
				<table width="100%" align="center" border="0" cellspacing="0" cellpadding="0">
					<tr>
						<td><cfinclude template="../../portlets/pNavegacion.cfm"></td>
					</tr>
					<tr>
						<td nowrap>
							<table width="100%" border="0" cellspacing="0" cellpadding="2" >
								<tr><td>&nbsp;</td></tr>
								<tr>
									<td width="37%" align="right" ><strong>Empleado Inicial:&nbsp;</strong></td>
									<td><cf_rhempleado tabindex="1" size = "50" index="1"></td>
								</tr>
								<tr>
									<td width="37%" align="right" ><strong>Empleado Final:&nbsp;</strong></td>
									<td><cf_rhempleado tabindex="1" size = "50" index="2"></td>
								</tr>
								<tr>
									<td align="right"  ><strong>Deducci&oacute;n Inicial:&nbsp;</strong></td>
									<td><cf_rhtipodeduccion size="50" validate="1" financiada="1" tabindex="1" id="TDidini" name="TDcodigoini" desc="TDdescripcionini" frame="frDeduccionini"></td>
								</tr>
								<tr>
									<td align="right"  ><strong>Deducci&oacute;n Final:&nbsp;</strong></td>
									<td><cf_rhtipodeduccion size="50" validate="1" financiada="1" tabindex="1" id="TDidfin" name="TDcodigofin" desc="TDdescripcionfin" frame="frDeduccionfin"></td>
								</tr>

								<tr>
									<td nowrap align="center" colspan="2">
										<input type="submit" name="btnFiltro"  value="Consultar">&nbsp;
										<input type="reset" name="btnLimpiar"  value="Limpiar">
									</td>
								</tr>
							</table>
						</td>
					</tr>
					<tr><td>&nbsp;</td></tr>
				</table>
			</form>
			</cfoutput>

		<cf_web_portlet_end>
	<cf_templatefooter>
