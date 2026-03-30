<cf_templateheader title="Reporte">
	<cf_web_portlet_start titulo="Reporte de TAGs">
	<br>
		<table width="100%" cellpadding="2" cellspacing="0" border="0">
			<tr>
				<td valign="top" align="center">
		            Generaci&oacute;n del Reporte de TAGs En Traslado
				</td>
					<table width="100%" align="center">
						<tr>
							<td align="right"></td>
							 <form name="form1" action="QPassRTraslado_form.cfm" method="post">
						<tr>
							<td align="center">
								<input 	type="checkbox" name="corte" tabindex="1">
								<strong>Con Corte por Sucursal</strong>
							</td>
						</tr>
						<tr>
							<td align="center"><input type="submit" name="Generar" tabindex="1"value="Generar">
							</td>
						</tr>
							</form>
						</tr>
					</table>
            </tr>
             <tr> 
                <td valign="top"> </td>
             </tr>
            </table>
	<cf_web_portlet_end>
<cf_templatefooter>