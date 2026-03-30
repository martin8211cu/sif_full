<form name="form1" action="ConsultaTRAN.cfm" method="post">
	<table align="center">
		<tr>
			<td align="right">
				<strong>Caja:</strong>
			</td>
			<td>
				<cf_conlisCajas>
			</td>
		</tr>
		<tr>
			<td nowrap align="right"><strong>Fecha:</strong></td>
				<td colspan="2">
					<table cellpadding="0" cellspacing="0" border="0">
						<tr>
							<td nowrap valign="middle">
									<cf_sifcalendario form="form1" value="" name="TESSPfechaPago_I" tabindex="1">
							</td>
							<td nowrap align="right" valign="middle">
								<strong>&nbsp;Hasta:</strong>
							</td>
							<td nowrap valign="middle">
									<cf_sifcalendario form="form1" value="" name="TESSPfechaPago_F" tabindex="1">
							</td>						
						</tr>

					</table>
				</td>
		</tr>
        <tr>
            <td align="right" valign="top" nowrap="nowrap"><strong>Estado del anticipo:</strong></td>
            <td align="left" valign="top" nowrap="nowrap">
                <select name="tipoMovimiento" id="tipoMovimiento">
                    <option value="1">Afectan Monto Asignado</option>
                    <option value="2">Entrega de Efectivo</option>
                    <option value="3">Reintegros</option>		
                    <option value="ALL">TODOS</option>
                </select>				
            </td>
        </tr>				

		<tr>
			<td align="center" colspan="2">
				<input type="submit" name="filtrar" value="Consultar">
			</td>
		</tr>
	</table>
</form>
