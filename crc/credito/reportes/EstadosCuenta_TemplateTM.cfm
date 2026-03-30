<cfoutput>

	<cfdocumentitem type="header">
		<table #noBorder# width="100%">
			<tr valign="bottom">
				<td align="center">
					<img src="#imgLogoPath#" height="80px">
				</td>
				<td align="center">
					#q_Empresa.Enombre#<br/>
					SISTEMA DE CR&Eacute;DITO POR TARJETA
				</td>
			</tr>
		<table>
	</cfdocumentitem>

		<table #noBorder# width="100%">
			<tr valign="middle">
				<td>
					<br/>
						<font #font3#>#q_infoCuenta.SNnombre#</font><br/>
						<font #font2#>#q_infoCuenta.direccion1#</font><br/>
						<font #font2#>#q_infoCuenta.direccion2#</font><br/>
						<font #font2#>#q_infoCuenta.Colonia#</font><br/>
						<font #font2#>#q_infoCuenta.estado#</font><br/>
						<font #font2#>#q_infoCuenta.codPostal#</font><br/>
					<br/>
					<img src="#imgBarcodePath#"  align="center">
				</td>
				<td align="center"> 
					<table #noBorder# style="#resumenA#">
						<tr>
							<th style="#resumenA_th#">FECHA CORTE</th> 
							<th style="#resumenA_th#">N&Uacute;MERO DE CUENTA</th>
						</tr>
						<tr>
 							<td style="#resumenA_td#">#DateFormat(date_fin,'dd/mm/yyyy')#</td>
							<td style="#resumenA_td#">#q_infoCuenta.Numero#</td>
						</tr>
					</table>
					<br/>
					<table #noBorder# style="#resumenB#">
						<!--- <tr>
							<td style="#resumenB_tdL#"><b>Fecha l&iacute;mite de pago:</b></td> 
							<td style="#resumenB_tdR#"></td>
						</tr> --->
						<tr>
							<td style="#resumenB_tdL#">Pago y Condonaciones:</td> 
							<td nowrap style="#resumenB_tdR#"> $#LSCurrencyFormat(q_resumen.TodosLosPagos, "none")#</td>
						</tr>
						<tr>
							<td style="#resumenB_tdL#">Compras:</td> 
							<td nowrap style="#resumenB_tdR#"> $#LSCurrencyFormat(q_resumen.Compras, "none")#</td>
						</tr>
						<tr>
							<td style="#resumenB_tdL#">Intereses:</td> 
							<td nowrap style="#resumenB_tdR#"> $#LSCurrencyFormat(q_resumen.Intereses, "none")#</td>
						</tr>
						<tr>
							<td style="#resumenB_tdL#">Otros Cargos:</td> 
							<td nowrap style="#resumenB_tdR#"> $#LSCurrencyFormat(q_resumen.OtrosCargos, "none")#</td>
						</tr>
						<tr>
							<td style="#resumenB_tdL#">Saldo Actual:</td> 
							<td nowrap style="#resumenB_tdR#"> $#LSCurrencyFormat(q_resumen.SaldoActual, "none")#</td>
						</tr>
						<tr>
							<td style="#resumenB_tdL#">Saldo pendiente de aplicar:</td> 
							<td nowrap style="#resumenB_tdR#"> $#LSCurrencyFormat(q_resumen.SaldoPendiente, "none")#</td>
						</tr>
						<!--- <tr>
							<td style="#resumenB_tdL#">Pago M&iacute;nimo:</td> 
							<td style="#resumenB_tdR#">$ #NumberFormat(q_resumen.PagoMinimo,"00.00")#</td>
						</tr> --->
						<tr>
							<td style="#resumenB_tdL#"><b>Pago para no generar intereses:</b></td> 
							<td nowrap style="#resumenB_tdR#"> $#LSCurrencyFormat((q_resumen.Compras + q_resumen.Intereses + q_resumen.OtrosCargos) 
								- q_resumen.TodosLosPagos, "none")#</td>
						</tr>
						<tr>
							<td style="#resumenB_tdL#">Limite de Cr&eacute;dito total:</td> 
							<td nowrap style="#resumenB_tdR#"> $#LSCurrencyFormat(q_resumen.MontoAprobado, "none")#</td>
						</tr>
						<tr>
							<td style="#resumenB_tdL#">Cr&eacute;dito disponible:</td> 
							<td nowrap style="#resumenB_tdR#"> $#LSCurrencyFormat(q_resumen.CreditoDisponible, "none")#</td>
						</tr>
						<tr>
<!--- 							<td colspan="2" style="#resumenB_tdL#">Periodo del #Replace(ListToArray(q_Corte.fechainicio,' ',false,false)[1],'-','/','all')# al #Replace(ListToArray(q_Corte.fechafin,' ',false,false)[1],'-','/','all')#</td>  --->
						</tr>
					</table>
				</td>
			</tr>
			<tr>
				<td colspan="2" align="center">
				<br/>
					<font #font2# ><b>DETALLE DE MOVIMIENTOS DEL PERIODO</b></font>
					<table #noBorder# style="#resumenC# width:95%;">
						<tr>
							<th style="#resumenC_th# width:10%; text-align: left;">Fecha</th>
							<th style="#resumenC_th# width:10%; text-align: left;">Tienda</th>
							<th style="#resumenC_th# width:30%; text-align: left;">Tipo</th>
							<th style="#resumenC_th# width:10%; text-align: left;">Folio</th>
							<th style="#resumenC_th# width:25%; text-align: left;">Descripci&oacute;n</th>
							<th style="#resumenC_th# width:15%; text-align: left;">Importe</th>
						</tr>
						<cfloop query="#q_transacciones#">
							<tr>
								<td style="#resumenC_td# text-align: left;">#Replace(ListToArray(Fecha,' ',false,false)[1],'-','/','all')#</td>
								<td style="#resumenC_td# text-align: left;">#Tienda#</td>
								<td style="#resumenC_td# text-align: left;">#Tipo#</td>
								<td style="#resumenC_td# text-align: left;">#Folio#</td>
								<td style="#resumenC_td# text-align: left;">#Observaciones#</td>
								<td style="#resumenC_td# text-align: right;"> $#LSCurrencyFormat(Monto, "none")#</td>
							</tr>
						</cfloop>
					</table>
				</td>
			</tr>
			<tr>
				<td colspan="2" align="center">
					<font #font2# style="display:block; page-break-before:always;" ><b>DESGLOSE DE OPERACIONES DE CREDITO DOCUMENTADO</b></font>
					<br/>
					<table #noBorder#>
						<tr>
							<td valign="top">
								<img src="#imgPromoPath#" width="250px">
							</td>
							<td width="70%">
								<cfset TotalSaldoVencido = 0>
								<cfset TotalRecargos = 0>
								<cfset TotalAPagar = 0>
								<cfloop query="#q_tarjetas#">
									<cfset TarjetaSaldoVencido = 0>
									<cfset TarjetaRecargos = 0>
									<cfset TarjetaAPagar = 0>
									<br/>
									
									<table #noBorder# style="#resumenD#">
										<tr>
											<th style="#resumenD_th#" colspan="6">Tipo de tarjeta: <cfif q_tarjetas.CRCTarjetaAdicionalid eq ''>Titular<cfelse>Adicional (#q_tarjetas.SNnombre#)</cfif> - #q_tarjetas.Numero#</th>
										</tr>
										<tr>
											<th style="#resumenD_th#" >Folio</th>
											<th style="#resumenD_th#" >Compra Inicial</th>
											<th style="#resumenD_th#" >Saldo Vencido</th>
											<th style="#resumenD_th#" >Recargos</th>
											<th style="#resumenD_th#" >Parcialidad</th>
											<th style="#resumenD_th#" >Vence este mes</th>
										</tr>
										<cfquery name="q_MovCuenta"  datasource="#session.DSN#">
											select 
												  B.Ticket
												, B.Monto
												, A.MontoRequerido
												, A.SaldoVencido
												, A.Intereses
												, A.Descripcion
												, A.MontoAPagar
											from CRCMovimientoCuenta as A
												inner join CRCTransaccion B
													on A.CRCTransaccionid = B.id
												left join CRCTarjeta C
													on B.CRCTarjetaid = C.id
											where 
													A.Corte = '#CodCorte#'
												and B.CRCCuentasid = #CuentaID#
												and A.Ecodigo = #session.ecodigo#
												and C.id = #q_tarjetas.id#
											order by B.Fecha asc;
										</cfquery>
										<cfloop query="#q_MovCuenta#">
											<cfset Parcialidad = REMatch("\(\d+?\/\d+?\)",q_MovCuenta.Descripcion)[1]>
											<tr>
												<td style="#resumenD_td#">#q_MovCuenta.Ticket#</td>
												<td style="#resumenD_td#"> $#LSCurrencyFormat(q_MovCuenta.Monto, "none")#</td>
												<td style="#resumenD_td#"> $#LSCurrencyFormat(q_MovCuenta.SaldoVencido, "none")#</td>
												<td style="#resumenD_td#"> $#LSCurrencyFormat(q_MovCuenta.Intereses, "none")#</td>
												<td style="#resumenD_td#">#Parcialidad#</td>
												<td style="#resumenD_td#"> $#LSCurrencyFormat(q_MovCuenta.MontoAPagar, "none")#</td>
											</tr>
											<cfset TarjetaSaldoVencido = TarjetaSaldoVencido + q_MovCuenta.SaldoVencido>
											<cfset TarjetaRecargos = TarjetaRecargos + q_MovCuenta.Intereses>
											<cfset TarjetaAPagar = TarjetaAPagar + q_MovCuenta.MontoAPagar>
										</cfloop>
										<tr>
											<th colspan="2" style="#resumenD_th#">TOTALES:</th>
											<th style="#resumenD_th#"> $#LSCurrencyFormat(TarjetaSaldoVencido, "none")#</th>
											<th style="#resumenD_th#"> $#LSCurrencyFormat(TarjetaRecargos, "none")#</th>
											<th style="#resumenD_th#"> </th>
											<th style="#resumenD_th#"> $#LSCurrencyFormat(TarjetaAPagar, "none")#</th>
										</tr>
										<cfset TotalSaldoVencido = TotalSaldoVencido + TarjetaSaldoVencido>
										<cfset TotalRecargos = TotalRecargos + TarjetaRecargos>
										<cfset TotalAPagar = TotalAPagar + TarjetaAPagar>
									</table>
								</cfloop>
							</td>
						</tr>
					</table>
				</td>
			</tr>
			<tr>
				<td colspan="2" align="center">
					<br/><br/>
					<p>
						<font #font2#>
							ESTIMADO TARJETAHABIENTE
							<br/>
							CONSULTE SU ESTADO DE CUENTA EN www.tiendasfull.com
							<br/>
							TELS; 7-29-41-29/30
						</font>
					</p>
				</td>
			</tr>
		</table>
 </cfoutput>