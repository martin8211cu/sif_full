 <cf_templateheader title="Cuentas por Cobrar Empleados- Consulta de Saldos por Empleado">
	
		<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='Consulta Saldos por Empleado'>
			
			<cfoutput>
			<form name="form1" method="post" action="Deducciones-form.cfm" style="margin: 0">
				<table width="100%" align="center" border="0" cellspacing="0" cellpadding="0">
					<tr>
						<td><cfinclude template="../../portlets/pNavegacion.cfm"></td>
					</tr>
					<tr>
						<td nowrap>
							<table width="100%" border="0" cellspacing="0" cellpadding="2" >
								<tr><td>&nbsp;</td></tr>
								<tr>
									<td align="right" width="40%"  ><strong>Deducci&oacute;n Inicial:&nbsp;</strong></td>
									<td><cf_rhtipodeduccion size="50" validate="1" financiada="1" tabindex="1" id="TDidini" name="TDcodigoini" desc="TDdescripcionini" frame="frDeduccionini"></td>
								</tr>
								<tr>
								  <td align="right"  ><strong>Deducci&oacute;n Final:</strong></td>
								  <td><cf_rhtipodeduccion size="50" validate="1" financiada="1" tabindex="1" id="TDidfin" name="TDcodigofin" desc="TDdescripcionfin" frame="frDeduccionfin"></td>
							  </tr>
								<tr>
								  <td align="right"  > <strong>Fecha Desde:&nbsp;</strong></td>
								  <td><cf_sifcalendario form="form1" value="#LSDateFormat(Now(),'dd/mm/yyyy')#" name="FechaDesde"></td>
							  </tr>
								<tr>
									<td align="right"  ><strong>Fecha Hasta:&nbsp;</strong></td>
									<td><cf_sifcalendario form="form1" value="#LSDateFormat(Now(),'dd/mm/yyyy')#" name="FechaHasta"> </td>
								</tr>
										<!---OPCION SALDOS TOTALIZADOS--->
                                <tr>
									<td align="right"></td>
									<td><table width="100%" cellpadding="0" cellspacing="0"><tr><td width="1%"><input type="checkbox" name="totaliza" onclick="javascript: desabilitaFiltroFechaIni(); "></td><td>Mostrar saldos totalizados</td></tr></table></td>
								</tr>

										<!---OPCION SALDOS CON CERO--->
								<tr>
									<td align="center"></td>
									<td><table width="100%" cellpadding="0" cellspacing="0"><tr><td width="1%"><input type="checkbox" name="saldosCero"></td><td>No mostrar saldos en cero</td></tr></table></td>
								</tr>
										<!---Filtrar por fecha de inicio--->
								<tr>
									<td align="center"></td>
										<td>
									<!---	<FIELDSET>--->
											<table width="100%" cellpadding="0" cellspacing="0" border="0">
												<tr>
													<td width="1%"><input type="checkbox" name="FiltroFechaInicio" onclick="javascript: mostrarFiltroFechaIni();"></td>
													<td>Filtrar por Fecha de Inicio</td>
												</tr>
											</table>
											<div id="FiltroDateI" style="display:none">
												<FIELDSET>
													<table width="100%" cellpadding="0" cellspacing="0" border="0">
														<tr>
															<LEGEND></LEGEND>
															<td width="5%"></td>
															<LABEL><td width="16%"><em>Fecha Desde:</em></td></LABEL>
															<td><cf_sifcalendario form="form1" value="#LSDateFormat(Now(),'dd/mm/yyyy')#" name="FechaDesdeFiltro"></td>
															<tr>
																<td width="5%"></td>
																<td><em>Fecha Hasta</em>:</td>
																<td><cf_sifcalendario form="form1" value="#LSDateFormat(Now(),'dd/mm/yyyy')#" name="FechaHastaFiltro"></td>
															</tr>
														</tr>
													</table>
												</FIELDSET>
											</div>
										</td>
								</tr>
								<tr>
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


<!-- MANEJA LOS ERRORES--->
<cf_qforms>
<script language="javascript">
	<!--//
	
    objForm.FechaDesde.description = "Desde";
	objForm.FechaHasta.description = "Hasta";
		
	function habilitarValidacion(){
	    objForm.FechaDesde.required = true;
		objForm.FechaHasta.required = true;
	}
	
	function deshabilitarValidacion(){
		objForm.FechaDesde.required = false;
		objForm.FechaHasta.required = false;
	}
	
	habilitarValidacion();
 
	function mostrarFiltroFechaIni() {
		if(document.form1.FiltroFechaInicio.checked)
		{
			div = document.getElementById('FiltroDateI');
			div.style.display = '';
			document.form1.totaliza.disabled = true;
		}
		else{
			ocultarFiltroFecha();
			document.form1.totaliza.disabled = false;
			}
	}
	
	function ocultarFiltroFecha() {
		div = document.getElementById('FiltroDateI');
		div.style.display='none';
	}	
	
	function desabilitaFiltroFechaIni() {
	if(document.form1.totaliza.checked){
		document.form1.FiltroFechaInicio.disabled =true;
	}else{
		document.form1.FiltroFechaInicio.disabled =false;
		}
	}		
//-->
</script>



