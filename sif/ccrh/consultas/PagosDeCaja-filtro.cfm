<cf_templateheader title="Cuentas por Cobrar Empleados- Consulta de Documentos Provenientes de Cajas">
	<cfinclude template="../../portlets/pNavegacion.cfm">
		<cf_web_portlet_start titulo="Documentos Provenientes de Cajas">
			<cfoutput>
			<form name="form1" method="post" action="PagosDeCajas.cfm" style="margin: 0">
				<table width="100%" align="center" border="0" cellspacing="0" cellpadding="0">
					<tr>
						<td></td>
					</tr>
					<tr>
						<td nowrap>
							<table width="100%" border="0" cellspacing="0" cellpadding="2" >
								<tr><td colspan="2">&nbsp;</td></tr>
								<tr>
									  <td align="right" width="23%"> <strong>Empleado:&nbsp;</strong></td>
								  <td width="77%"><cf_rhempleado tabindex="1" size = "50" index="1"></td>	
							  </tr>
								 <tr>
									  <td align="right" width="23%"> <strong>Fecha Inicial:&nbsp;</strong></td>
									  <td align="left">
									  	<table width="98%" align="center">
											<tr>											  
											  <td width="1%"><cf_sifcalendario form="form1" name="FechaInicial"></td>
											  <td width="19%" align="right"><strong>Fecha Final:&nbsp;</strong></td>
											  <td width="22%"><cf_sifcalendario form="form1" name="FechaFinal"> </td>								  
											  <td width="14%" align="right"><strong>No.Recibo:&nbsp;</strong></td>
											  <td width="44%">
											  	<input type="text" name="NoDocumento" size="15" maxlength="25"/>
											  </td>
											</tr>
										</table>
									  </td>
							     </tr>
								 <tr><td>&nbsp;</td></tr>
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