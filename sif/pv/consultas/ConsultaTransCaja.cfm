<cf_templateheader title="Punto de Venta - Consulta de Transacciones por Caja">

	
		<cf_templatecss>
			<cf_web_portlet_start border="true" skin="#session.preferences.skin#" titulo="Consulta de Transacciones por Caja">
				<cfinclude template="../../portlets/pNavegacion.cfm">
				<cfoutput>
					<form method="get" name="form1" action="ConsultaTransCaja-sql.cfm" onsubmit="javascript: return validar(this);">
						<table width="94%" border="0" cellspacing="0" cellpadding="0" align="center">
							<tr>
								<td colspan="2">&nbsp;</td>
							</tr>
							<tr>
							  	<td width="50%" valign="top">
									<cf_web_portlet_start border="true" titulo="Transacciones por Caja" skin="info1">
										<div align="justify">En &eacute;ste reporte 
										  se detalla la informaci&oacute;n de todas 
										  las Transacciones por Caja.
										  Encontraremos varios clasificaciones del
										  reporte, dependiendo por medio de qu&eacute; 
										  aspectos se desea detallar.
										  Este reporte se puede generar en varios
										  formatos, aumentando as&iacute; su utilidad 
										  y eficiencia en el traslado de datos.
										</div>
									<cf_web_portlet_end>
							  	</td>
								<td width="50%" valign="top">
									<table width="100%"  border="0" cellspacing="0" cellpadding="2">
									  <tr>
										<td class="fileLabel" align="right">Rango de Fechas:</td>
										<td width="1%">
											<cf_sifcalendario form="form1" name="Fdesde">
										</td>
									    <td align="center">a</td>
									    <td>
											<cf_sifcalendario form="form1" name="Fhasta">
										</td>
									  </tr>
									  <tr>
										<td class="fileLabel" align="right">Caja Desde:</td>
										<td colspan="3">
											 <cf_sifcajasPV form="form1" FAM01CODD="FAM01CODD1" FAM01DES="FAM01DES1" Ocodigo="Ocodigo1" FAM01COD="FAM01COD1">
										</td>
									  </tr>
									  <tr>
										<td class="fileLabel" align="right">Caja Hasta:</td>
										<td colspan="3">
											 <cf_sifcajasPV form="form1" FAM01CODD="FAM01CODD2" FAM01DES="FAM01DES2" Ocodigo="Ocodigo2" FAM01COD="FAM01COD2">
										</td>
									  </tr>
									  <tr>
										<td class="fileLabel" align="right">Oficina:</td>
										<td colspan="3">
											<cf_sifoficinas form="form1">
										</td>
									  </tr>
									  <tr>
										<td class="fileLabel" align="right">Tipo de Transacci&oacute;n:</td>
										<td colspan="3">
											<select name="TipoTrans">
												<option value="">-Seleccionar-</option>
												<option value="1">Facturas de Contado</option>
												<option value="3">Recibos de Adelantos</option>
												<option value="4">Recibo de CxC</option>
												<option value="5">Devoluciones de Facturas</option>
												<option value="6">Adelantos Aplicados</option>
												<option value="7">Facturas de Crédito</option>
												<option value="8">Notas de Crédito</option>
												<option value="9">Otros Recibos</option>
												<option value="10">Devoluciones de Recibos</option>
											</select>
										</td>
									  </tr>
									  <tr>
										<td class="fileLabel" align="right">Formato:</td>
										<td colspan="3">
											<select name="formato">
											  <option value="flashpaper">Flash Paper</option>
											  <option value="pdf">Adobe PDF</option>
											</select>
										</td>
									  </tr>
									  <tr>
										<td colspan="4" align="center">&nbsp;</td>
									  </tr>
									  <tr>
										<td colspan="4" align="center">
											<input type="submit" value="Generar" name="Reporte">										</td>
									  </tr>
									</table>
							  </td>
							</tr>
						<tr>
							<td colspan="2">&nbsp;</td>
						</tr>
					</table>
				</form>
			</cfoutput>
			
			<script language="javascript" type="text/javascript">
				function validar(f) {
					if (document.form1.Fdesde.value == '') {
						alert('El campo de Rango de Fechas es requerido');
						return false;
					}
					if (document.form1.Fhasta.value == '') {
						alert('El campo de Rango de Fechas es requerido');
						return false;
					}
					return true;
				}
			</script>
			
		<cf_web_portlet_end>
<cf_templatefooter>	  