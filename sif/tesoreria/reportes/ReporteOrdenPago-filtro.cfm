
	<form name="formFiltro" method="get" action="ReporteOrdenPago.cfm" style="margin: '0' ">
		<table width="100%"  border="0" cellpadding="0" cellspacing="0">
			<tr><td>&nbsp;</td></tr>
			<tr>
			    <td nowrap align="right"><strong><cf_translate key=LB_TrabajarTesoreria> Trabajar con Tesorería</cf_translate>:</strong>&nbsp;</td>
				<td><cf_cboTESid onchange="this.form.submit();" tabindex="1"></td>
				<td align="right"><strong><cf_translate key=LB_EmpresaPago>Empresa&nbsp;Pago</cf_translate>:</strong></td>
				<td><cf_cboTESEcodigo name="EcodigoPago_F" tabindex="1"></td>
			 </tr>
			 <tr>
				<td nowrap align="right"><strong><cf_translate key=LB_Beneficiario>Beneficiario</cf_translate>:</strong></td>
				<td><input type="text" name="Beneficiario_F" size="60" tabindex="1"></td>
				<td align="right" nowrap><strong><cf_translate key=LB_CuentaPago>Cuenta Pago</cf_translate>:</strong></td>					
				<td><cf_cboTESCBid name="CBidPago_F" Ccompuesto="no" all="yes" tabindex="1" value="CBid"></td>										
			  </tr>
			  <tr>
				<td align="right" nowrap><strong><cf_translate key=LB_Estado>Estado</cf_translate>:</strong></td>
				<td nowrap valign="middle">
					<select name="TESOPestado_F" id="TESOPestado_F" tabindex="1">
						<option value="-1">-- <cf_translate key=LB_Todos>Todos</cf_translate> --</option>
						<option value="10"><cf_translate key=LB_EnPreparacion>En Preparación</cf_translate></option>
						<option value="11"><cf_translate key=LB_EnEmision>En Emisión</cf_translate></option>
						<option value="12"><cf_translate key=LB_Emitidas>Emitidas</cf_translate></option>
						<option value="13"><cf_translate key=LB_Anuladas>Anuladas</cf_translate></option>
					</select>
				</td>
				<td align="right" nowrap><strong><cf_translate key=LB_MonedaPago>Moneda Pago</cf_translate>:</strong></td>
				<td nowrap valign="middle">
				<cfquery name="rsMonedas" datasource="#session.DSN#">
					select distinct Miso4217, (select min(Mnombre) from Monedas m2 where m.Miso4217=m2.Miso4217) as Mnombre
					  from Monedas m 
						inner join TESempresas e
						  on e.TESid = #session.Tesoreria.TESid#
						 and e.Ecodigo = m.Ecodigo
				</cfquery>
					<select name="Miso4217Pago_F" tabindex="1">
						<option value="">(<cf_translate key=LB_Todos>Todas las monedas</cf_translate>)</option>
						<cfoutput query="rsMonedas">
							<option value="#Miso4217#">#Mnombre#</option>
						</cfoutput>
					</select>
				</td>
			  </tr>
			  <tr>
				<td align="right" nowrap><strong><cf_translate key=LB_NumOrden>Num.Orden:</cf_translate></strong></td>
				<td><input name="TESOPnumero_F" type="text" tabindex="1" size="22"></td>
				<td align="right" nowrap><strong>&nbsp;<cf_translate key=LB_DocumentoPago>Documento Pago</cf_translate>:</strong></td>
				<td><input name="DocPago_F" type="text" tabindex="1" size="20"></td>
			  </tr>
			  <tr>
			  <tr> <td class="fileLabel" align="right"><strong><cf_translate key=LB_Formato>Formato</cf_translate>:</strong></td>
				  <td>
					<select name="formato" tabindex="1">
						<option value="flashpaper">Flashpaper</option>
						<option value="pdf">Pdf</option>
						<option value="excel"><cf_translate key=LB_ExportarArchivoE>Exportar a Archivo Excel</cf_translate></option>
						<option value="txt"><cf_translate key=LB_ExportarArchivoT>Exportar a Archivo TXT</cf_translate></option>
					</select>
				  </td>
			      
			      <td align="right"><strong><cf_translate key=LB_FechaIni>Fecha desde</cf_translate>:&nbsp;</strong></td>
			      <td><cf_sifcalendario form="formFiltro" value="" name="TESOPfechaPago_I" tabindex="1"></td>   
			 </tr>
			 <tr>
				 <td colspan="2">&nbsp;</td>
			      <td align="right"><strong><cf_translate key=LB_FechaFin>Fecha Hasta</cf_translate>:&nbsp;</strong></td>
			      <td><cf_sifcalendario form="formFiltro" value="" name="TESOPfechaPago_F" tabindex="1"></td>   
			  </tr>
			  <td align="center" colspan="4"><cf_botones values="Consultar,Limpiar" tabindex="1"></td>
			  </tr>
			</table>
		</form>

