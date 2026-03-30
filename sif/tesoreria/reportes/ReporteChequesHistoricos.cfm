
<cf_templateheader title="Reporte de Cheques Hist&oacute;ricos">
	<cfset titulo = 'Reporte de Cheques Historicos'>
	<cf_web_portlet_start border="true" titulo="#titulo#" skin="#Session.Preferences.Skin#">

		<table width="100%" border="0" cellspacing="6">
		  <tr>
			<td width="50%" valign="top">
				<form name="form1" method="get" action="ReporteChequesHistoricos-result.cfm" style="margin: '0' ">
					<table width="100%"  border="0" cellpadding="1" cellspacing="0">
						<tr><td>&nbsp;</td></tr>
						<tr>
							<td nowrap align="right" width="45%"><strong>&nbsp;Trabajar con Tesorería:</strong>&nbsp;</td>
							<td nowrap align="left"><cf_cboTESid tabindex="1" ></td>
						</tr>
						<tr>
							<td align="right"><strong>Reporte:</strong>&nbsp;</td>
							<td>
								<input type="radio" name="TipoReporte" value="Resumido" tabindex="1"> Resumido &nbsp;
								<input type="radio" name="TipoReporte" value="Detallado" tabindex="1">Detallado
							</td>
						</tr>
						<tr>
							<td align="right"><strong>Fecha Inicial:</strong>&nbsp;</td>
							<td ><cf_sifcalendario name="inicio"  tabindex="1"></td>
						</tr>
						<tr>
							<td align="right"><strong>Fecha Final:</strong>&nbsp;</td>
							<td><cf_sifcalendario name="ffinal"  tabindex="1"></td>
						</tr>
	
						<tr>
							<td align="right"><strong>Socio desde:</strong>&nbsp;</td>
							<td>
								<cf_sifsociosnegocios2 SNcodigo="idsocio1" SNnombre="nsocio1" 
									SNnumero="socioDesde" SNtiposocio="P" frame="frame1" tabindex="1">
							</td>
						</tr>
						<tr>
							<td align="right"><strong>Socio hasta:</strong>&nbsp;</td>
							<td>
								<cf_sifsociosnegocios2 SNcodigo="idsocio2" SNnombre="nsocio2" 
									SNnumero="socioHasta" SNtiposocio="P" frame="frame2" tabindex="1">
							</td>
						</tr>
	
						<tr>
							<td align="right"><strong>Banco Inicial:</strong>&nbsp;</td>
							<td>
								<cf_conlis title="Lista de Bancos"
										campos = "Bid_inicio, Bdescripcion_inicio" 
										desplegables = "N,S" 
										modificables = "N,N" 
										size = "0,40"
										tabla="Bancos b"
										columnas="b.Bid as Bid_inicio, b.Bdescripcion as Bdescripcion_inicio"
										filtro="b.Ecodigo = #Session.Ecodigo# order by b.Bdescripcion"
										desplegar="Bdescripcion_inicio"
										etiquetas="Descripci&oacute;n"
										formatos="S"
										align="left"
										asignar="Bid_inicio, Bdescripcion_inicio"
										asignarformatos="S,S"
										showEmptyListMsg="true"
										debug="false"
										tabindex="1"
										filtrar_por="b.Bdescripcion">
							</td>
						</tr>
						
						<tr>
							<td align="right"><strong>Banco Final:</strong>&nbsp;</td>
							<td>
								<cf_conlis title="Lista de Bancos"
										campos = "Bid_final, Bdescripcion_final" 
										desplegables = "N,S" 
										modificables = "N,N" 
										size = "0,40"
										tabla="Bancos b"
										columnas="b.Bid as Bid_final, b.Bdescripcion as Bdescripcion_final"
										filtro="b.Ecodigo = #Session.Ecodigo# order by b.Bdescripcion"
										desplegar="Bdescripcion_final"
										etiquetas="Descripci&oacute;n"
										formatos="S"
										align="left"
										asignar="Bid_final, Bdescripcion_final"
										asignarformatos="S,S"
										showEmptyListMsg="true"
										debug="false"
										tabindex="1"
										filtrar_por="b.Bdescripcion">
							</td>
						</tr>
						
						<tr>
							<td align="right"><strong>Cuenta:</strong>&nbsp;</td>
							<td>
								<cf_cboTESCBid all="true">
							</td>
						</tr>
						
						
						<tr>
							<td align="right"><strong>Formato:</strong>&nbsp;</td>
							<td>
								<select name="formato" tabindex="1">
									<option value="flashpaper">flashpaper</option>
									<option value="pdf">pdf</option>
								</select>
							</td>
						</tr>
						
						
						<tr><td>&nbsp;</td></tr>
						<tr>
							<td nowrap align="left" colspan="2">
								<cf_botones tabindex="1" include="Filtrar" exclude="Alta,Limpiar">
							</td>
						</tr>
						<tr><td>&nbsp;</td></tr>
					</table>
					<br>
				</form>
			 </td>
		  </tr>
		</table>
	
		<cf_qforms>
		<script language="javascript1.2" type="text/javascript">
			objForm.TESid.required = true;
			objForm.TESid.description = 'Tesorería';
			objForm.inicio.description = 'Fecha Inicial';
			objForm.inicio.required = true;
			objForm.ffinal.description = 'Fecha Final';
			objForm.ffinal.required = true;
			objForm.Bdescripcion_inicio.required = true;
			objForm.Bdescripcion_inicio.description = 'Banco Inicial';		
			objForm.Bdescripcion_final.required = true;
			objForm.Bdescripcion_final.description = 'Banco Final';		
			document.form1.TESid.focus();
		</script>
	<cf_web_portlet_end>
<cf_templatefooter>	

