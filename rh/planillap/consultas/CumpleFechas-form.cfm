<SCRIPT SRC="/cfmx/rh/js/utilesMonto.js"></SCRIPT>
<style type="text/css">
<!--
.style1 {
	font-size: 14px;
	font-weight: bold;
}
-->
</style>
<cfoutput>
	<form method="post" name="form1" action="CumpleFechas-SQL.cfm">
		<table width="95%" border="0" cellspacing="0" cellpadding="0" align="center">
			<tr valign="top">
				<td width="50%">
					<table width="100%">
						<tr>
							<td height="173" valign="top">	
								<cf_web_portlet_start border="true" titulo="Cumplimiento de Fechas" skin="info1">
									<div align="justify">
									  <p>En &eacute;ste reporte 
									  muestra una lista de empleados según los criterios de activo, inactivo y por fecha de cumplimiento de anualidades. Los filtros de fecha desde y hasta, se utilizan para hacer calzar los meses y los días sin tomar en cuenta los años. Se ordena por: Tipo de Cumplimiento, Centro Funcional y mes.</p>
								</div>
							  <cf_web_portlet_end></td>
						</tr>
					</table>  
				</td>
				<td width="50%" valign="top">
					<table width="100%" cellpadding="0" cellspacing="0" align="center">
						
						
					  <tr>
						<td><strong>Centro Funcional:</strong></td>
						<td>&nbsp;</td>
						<td>&nbsp;</td>
					  </tr>
					   <tr> 
							<td nowrap>
								
							</td>
							<td nowrap></td>
							<td nowrap>
								
							</td>
							
					  </tr>
						<tr>
							<td align="left" nowrap>
							  	<cf_rhcfuncional tabindex="1">
							</td>
							<td align="center">&nbsp;</td>
							<td align="center">
								
							</td>
						</tr>
						<tr>
						  <td><strong>Mostrar Empleados:</strong></td>
						  <td>&nbsp;</td>
						  <td>&nbsp;</td>
					  </tr>
						
						<tr>
						  <td align="left">
							  	<select name="Estado" tabindex="2">
                                	<option value="A">Activos</option>
                                	<option value="I">Inactivos</option>
                              	</select>
                        </td>
							<td>&nbsp;</td>
							<td>&nbsp;</td>
						</tr>	
						<tr>
						  <td><strong>Tipo de Cumplimiento:</strong></td>
							<td >&nbsp;</td>
							<td >&nbsp;</td>
							
						</tr>
							
						<tr>
						  <td align="left">
						  	<select name="Cumplimiento" tabindex="3">
								<option value="C">Cumplea&ntilde;os</option>
								<option value="A">Anuales</option>
								<option value="V">Vacaciones</option>
								<option value="I">Ingreso</option>
							</select>
                          </td>
							<td >&nbsp;</td>
							<td >&nbsp;</td>
							
						</tr>			
						<tr>
						  <td><strong>Fecha Desde:</strong></td>
						  <td >&nbsp;</td>
							<td >&nbsp;</td>
							
						</tr>	
						<tr>
							<td>
								<cf_sifcalendario tabindex="4" name="CumpleDesde" value="">
							</td>
							<td >&nbsp;</td>
							<td >&nbsp;</td>
						</tr>
						<tr>
						  <td><strong>Fecha Hasta:</strong></td>
						  <td >&nbsp;</td>
							<td >&nbsp;</td>
							
						</tr>	
						<tr>
							<td>
								<cf_sifcalendario tabindex="5" name="CumpleHasta" value="">
							</td>
							<td >&nbsp;</td>
							<td >&nbsp;</td>
						</tr>
						<tr>
						  <td><strong>Formato:</strong></td>
						  <td >&nbsp;</td>
							<td >&nbsp;</td>
							
						</tr>	
						<tr>
							<td>
								<select name="formato" tabindex="6">
                                	<option value="FlashPaper">FlashPaper</option>
                                	<option value="pdf">Adobe PDF</option>
                                	<option value="Excel">Microsoft Excel</option>
                              	</select>
							</td>
							<td></td>
							<td></td>
						</tr>
						<tr>
							<td colspan="3" align="center">&nbsp;</td>
						</tr>																						
						<tr>
							<td align="center" colspan="3"><input type="submit" value="Generar" name="Reporte" tabindex="7">
							<input type="reset" name="Limpiar" value="Limpiar" tabindex="8"></td>
							</tr>
					</table>
				</td>
			</tr>
		</table>
	</form>
	</cfoutput>
