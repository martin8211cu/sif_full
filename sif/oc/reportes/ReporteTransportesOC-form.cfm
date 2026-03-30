<cfparam name="LvarReporteOD" default="false">
<cfparam name="LvarReporteSM" default="false">
<cfparam name="LvarReporteAC" default="false">
	
<form name="form1" action="ReporteTransportesOC-sql.cfm" method="post">
	<table border="0" align="center" cellpadding="0" cellspacing="0">
		<tr><td>&nbsp;</td></tr>
		<tr>
			<td><strong>Transporte:</strong></td>
			<td colspan="2">
				<select name="OCTtipo">
					<option value="">(Todos...)</option>
					<option value="B">Barco</option>
					<option value="A">Avion</option>
					<option value="T">Terrestre</option>
					<option value="F">Ferrocarril</option>
					<option value="O">Otro</option>
				</select>
				
				<input type="text" name="OCTtransporte" id="OCTtransporte"
					onkeydown="if (this.form.OCTtipo.value == '') return false;"
				/>
			</td>
		</tr>
		<tr>
			<td colspan="3">
				&nbsp;&nbsp;&nbsp;
				<input type="checkbox" value="1" name="chkSoloAbiertos">
				Incluir únicamente Transportes Abiertos
			</td>
		</tr>
		<tr>
			<td colspan="3">
				&nbsp;&nbsp;&nbsp;
				<input type="checkbox" value="1" name="chkSoloConInconsistencias">
				Incluir únicamente Transportes con Saldos Inconsistentes
			</td>
		</tr>
		<tr>
			<td colspan="3">
				&nbsp;&nbsp;&nbsp;
				<input type="checkbox" value="1" name="chkSoloConTransformaciones">
				Incluir únicamente Transportes con Transformaciones
			</td>
		</tr>
		<tr><td>&nbsp;</td></tr>
		<tr>
			<td><strong>Incluir Transportes con Origenes:</strong></td>
		</tr>
		<tr>
			<td>&nbsp;&nbsp;&nbsp;&nbsp;Mes:</td>
			<td>
				<cfoutput>
				<select name="OriMes" id="OriMes">
					<option value="">(Todos...)</option>
					<option value="1">Enero</option>
					<option value="2">Febrero</option>
					<option value="3">Marzo</option>
					<option value="4">Abril</option>
					<option value="5">Mayo</option>
					<option value="6">Junio</option>
					<option value="7">Julio</option>
					<option value="8">Agosto</option>
					<option value="9">Setiembre</option>
					<option value="10">Octubre</option>
					<option value="11">Noviembre</option>
					<option value="12">Diciembre</option>
				</select>
				<input type="text" 
					name="OriAno" id="OriAno" 
					value="#DateFormat(now(),"YYYY")#"
					size="4"
					onkeydown="if (this.form.OriMes.value == '') return false;"
				/>
				</cfoutput>
			</td>
		</tr>
		<tr>
			<td>&nbsp;&nbsp;&nbsp;&nbsp;Orden Comercial:&nbsp;</td>
			<td>
				<input type="text"
					name="OriOCcontrato" id="OriOCcontrato"
				 />
			</td>
		</tr>
		<tr>
			<td>&nbsp;&nbsp;&nbsp;&nbsp;Documento:</td>
			<td>
				<input type="text"
					name="OriDocumento" id="OriDocumento"
				 />
			</td>
		<tr>
		<tr><td>&nbsp;</td></tr>
		<tr>
			<td><strong>Incluir Transportes con Transformaciones:</strong></td>
		</tr>
		<tr>
			<td>&nbsp;&nbsp;&nbsp;&nbsp;Mes:</td>
			<td>
				<cfoutput>
				<select name="OCTTMes" id="OCTTMes">
					<option value="">(Todos...)</option>
					<option value="1">Enero</option>
					<option value="2">Febrero</option>
					<option value="3">Marzo</option>
					<option value="4">Abril</option>
					<option value="5">Mayo</option>
					<option value="6">Junio</option>
					<option value="7">Julio</option>
					<option value="8">Agosto</option>
					<option value="9">Setiembre</option>
					<option value="10">Octubre</option>
					<option value="11">Noviembre</option>
					<option value="12">Diciembre</option>
				</select>
				<input type="text" 
					name="OCTTAno" id="OCTTAno" 
					value="#DateFormat(now(),"YYYY")#"
					size="4"
					onkeydown="if (this.form.OCTTMes.value == '') return false;"
				/>
				</cfoutput>
			</td>
		</tr>
		<tr>
			<td>&nbsp;&nbsp;&nbsp;&nbsp;Documento:</td>
			<td>
				<input type="text"
					name="OCTTdocumento" id="OCTTdocumento"
				 />
			</td>
		<tr>
		<tr><td>&nbsp;</td></tr>
		<tr>
			<td><strong>Incluir Transportes con Destinos:</strong></td>
		</tr>
		<tr>
			<td>&nbsp;&nbsp;&nbsp;&nbsp;Mes:</td>
			<td>
				<cfoutput>
				<select name="DstMes" id="DstMes" onchange="this.form.chkSoloDstMes.disabled = this.value == ''">
					<option value="">(Todos...)</option>
					<option value="1">Enero</option>
					<option value="2">Febrero</option>
					<option value="3">Marzo</option>
					<option value="4">Abril</option>
					<option value="5">Mayo</option>
					<option value="6">Junio</option>
					<option value="7">Julio</option>
					<option value="8">Agosto</option>
					<option value="9">Setiembre</option>
					<option value="10">Octubre</option>
					<option value="11">Noviembre</option>
					<option value="12">Diciembre</option>
				</select>
				<input type="text" 
					name="DstAno" id="DstAno" 
					value="#DateFormat(now(),"YYYY")#"
					size="4"
					onkeydown="if (this.form.DstMes.value == '') return false;"
				/>
				</cfoutput>
			</td>
		</tr>
		<tr>
			<td>&nbsp;&nbsp;&nbsp;&nbsp;Orden Comercial:&nbsp;</td>
			<td>
				<input type="text"
					name="DstOCcontrato" id="DstOCcontrato"
				 />
			</td>
		</tr>
		<tr>
			<td>&nbsp;&nbsp;&nbsp;&nbsp;Documento:</td>
			<td>
				<input type="text"
					name="DstDocumento" id="DstDocumento"
				 />
			</td>
		<tr>
		<tr>
			<td colspan="3">
				&nbsp;&nbsp;&nbsp;
				<input type="checkbox" value="1" name="chkSoloDstMes" disabled>
				Incluir únicamente los Movimientos Destinos del Mes
			</td>
		</tr>
		<tr>
			<td colspan="3">
				&nbsp;&nbsp;&nbsp;
				<input type="checkbox" value="1" name="chkSoloConPendientes"
						 onclick="
						 	if (this.form.chkDI)
							{
								this.form.chkDI.disabled = this.checked;
								this.form.chkDO.disabled = this.checked;
								this.form.chkDT.disabled = this.checked;
								this.form.chkDX.disabled = this.checked;
							}
							"
				>
				Incluir únicamente los Movimientos de Ventas con Costo de Venta Pendientes
			</td>
		</tr>
	<cfif LvarReporteOD>
		<tr>
			<td>
				<input type="hidden"  value="1" name="chkIncluirOD">
			</td>
		</tr>
	<cfelseif LvarReporteAC>
		<tr>
			<td>
				<input type="hidden"  value="1" name="chkIncluirCostos">
			</td>
		</tr>
	<cfelse>
		<tr>
			<td>
				&nbsp;&nbsp;&nbsp;
				Incluir únicamente Movimientos tipo:
			</td>
			<td>
				<input type="checkbox" value="1" name="chkDC">
				Ventas de Tránsito
			</td>
			<td>
				&nbsp;&nbsp;
				<input type="checkbox" value="1" name="chkDV">
				Ventas de Almacén
			</td>
			<td>
				&nbsp;&nbsp;
				<input type="checkbox" value="1" name="chkDO">
				Otros Ingresos
			</td>
		</tr>
		<tr>
			<td>
				&nbsp;&nbsp;&nbsp;
			</td>
			<td>
				<input type="checkbox" value="1" name="chkDI">
				Entradas a Inventario
			</td>
			<td>
				&nbsp;&nbsp;
				<input type="checkbox" value="1" name="chkDT">
				Producto Transformado
			</td>
			<td>
				&nbsp;&nbsp;
				<input type="checkbox" value="1" name="chkDX">
				Cierre Transporte
			</td>
		</tr>

		<tr><td>&nbsp;</td></tr>
		<tr>
			<td colspan="3">
				<strong>Incluir en el Reporte:</strong>
			</td>
		</tr>
		<tr>
			<td>
				&nbsp;&nbsp;&nbsp;&nbsp;
				<input type="checkbox" value="1" name="chkIncluirTotales" checked>
				Totales por Línea de Negocio&nbsp;
			</td>
		</tr>
	<cfif LvarReporteSM>
		<tr>
			<td>
				&nbsp;&nbsp;&nbsp;&nbsp;
				<input type="checkbox" value="1" checked disabled>
				<input type="hidden" value="1" name="chkIncluirSaldos">
				Saldos por Producto
			</td>
		</tr>
	<cfelse>
		<tr>
			<td>
				&nbsp;&nbsp;&nbsp;&nbsp;
				<input type="checkbox" value="1" name="chkIncluirOD" checked>
				Orígenes y Destinos&nbsp;
			</td>
		</tr>
		<tr>
			<td>
				&nbsp;&nbsp;&nbsp;&nbsp;
				<input type="checkbox" value="1" name="chkIncluirSaldos" checked
					onclick=
							"	
								this.form.chkIncluirMovimientos.disabled = ! this.checked;
								this.form.chkIncluirDetalle.disabled = ! this.checked && this.form.chkIncluirMovimientos.checked;
							"
				>
				Saldos por Producto
			</td>
		</tr>
	</cfif>
		<tr>
			<td>
				&nbsp;&nbsp;&nbsp;&nbsp;
				&nbsp;&nbsp;&nbsp;&nbsp;
				<input type="checkbox" value="1" name="chkIncluirMovimientos" checked
					onclick=
							"	
								this.form.chkIncluirDetalle.disabled = ! this.checked;
							"
				>
				Movimientos por Producto
			</td>
		</tr>
	<cfif NOT LvarReporteSM>
		<tr>
			<td>
				&nbsp;&nbsp;&nbsp;&nbsp;
				<input type="checkbox" value="1" name="chkIncluirCostos" checked>
				Asignación de Costos
			</td>
		</tr>
	</cfif>
<!---
		<tr>
			<td>
				&nbsp;&nbsp;&nbsp;&nbsp;
				&nbsp;&nbsp;&nbsp;&nbsp;
				&nbsp;&nbsp;&nbsp;&nbsp;
				<input type="checkbox" value="1" name="chkIncluirDetalle" disabled>
				Detalle contable por Movimientos
			</td>
		</tr>
--->
	</cfif>

<input type="checkbox" value="1" name="chkIncluirDetalle" disabled style="display:none;">
		<tr><td>&nbsp;</td></tr>
		<tr>
			<td colspan="3" align="center"><input name="BtnGenerar" value="Generar Reporte" type="submit"></td>
		</tr>
	</table>
</form>
