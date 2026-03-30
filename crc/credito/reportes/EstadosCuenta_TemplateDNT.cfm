
<cfoutput>
		<cfdocumentitem type="header">
			<table #noBorder# width="100%">
				<tr valign="bottom">
					<td align="center">
						<!---<cfimage  source="#imgLogoPath#" action="writeToBrowser">--->
						<img src="#imgLogoPath#">
					</td>
					<td align="center">
						#q_Empresa.Enombre# <br/>
						SISTEMA DE CR&Eacute;DITO POR VALES
					</td>
				</tr>
			<table>
		</cfdocumentitem>
		<cfquery name="q_CortePago" datasource="#session.dsn#">
			select fechainicio, fechafin, Dateadd(day,2,fechafin)as fechaEntregaRelacion, codigo from CRCCortes 
				where Dateadd(day,1,'#q_Corte.fechafin#') between fechainicio and fechafin 
				and ecodigo = #session.ecodigo#
				and tipo = '#q_corte.tipo#'
		</cfquery>
		
		<cfquery name="q_CortePagoPrev" datasource="#session.dsn#">
			select fechainicio, fechafin, codigo from CRCCortes 
				where Dateadd(day,-2,'#q_Corte.fechainicio#') between fechainicio and fechafin 
				and ecodigo = #session.ecodigo#
				and tipo = '#q_corte.tipo#'
		</cfquery>
		<cfset NewCycleStartDate = ListToArray(dateFormat(q_CortePago.fechainicio,'yyyy-mm-dd'),'-',false,false)>
		<cfset NewCycleStartDate = CreateDate(NewCycleStartDate[1],NewCycleStartDate[2],NewCycleStartDate[3])>

		<cfset descuento = 100>
		<cfset Max_Descuento = 0>
		<cfquery name="q_movCuentaCorteA" datasource="#session.DSN#">
			select Sum(mc.MontoAPagar - (mc.Pagado + mc.Condonaciones + mc.Descuento)) as MontoAPagar
				from CRCMovimientoCuenta mc
					inner join CRCTransaccion t
						on t.id = mc.CRCTransaccionid
				where 
					rtrim(ltrim(t.TipoTransaccion)) = 'VC'
					and mc.corte='#CodCorte#' and t.CRCCuentasid = #CuentaID# and mc.Ecodigo = #session.ecodigo#;
		</cfquery>
		<cfquery name="q_movCuentaCorteB" datasource="#session.DSN#">
			select MontoAPagar - (MontoPagado + Condonaciones +Descuentos) MontoAPagar 
				from CRCMovimientoCuentaCorte 
				where corte='#CodCorte#' and CRCCuentasid = #CuentaID# and Ecodigo = #session.ecodigo#;
		</cfquery>	

		<cfquery name="q_Contacto" datasource="#session.DSN#">
			select top 1 * from SNContactos c
			inner join SNegocios s on c.SNcodigo = s.SNcodigo 
			where c.SNcodigo = #q_infoCuenta.SNcodigo#
			and c.Ecodigo = #session.ecodigo#
		</cfquery>	

		<table #noBorder# width="100%">
			<tr>
				<td colspan="2" align="center">Fecha Inicio de Pago: #DateFormat(DateAdd("d", 1, q_Corte.fechafin) ,'yyyy/mm/dd')# Vence: #DateFormat(q_CortePago.fechafin,'yyyy/mm/dd')#</td> 
			</tr>
			<tr>
				<td colspan="2">
					<br/>
					<table #noBorder#>
						<tr>
							<td width="10%">Distribuidor</td>
							<td width="60%">#q_infoCuenta.Numero# - #q_infoCuenta.SNnombre#</td>
						</tr>
						<tr width="10%">
							<td>Direccion</td>
							<td>
								<cfset ultimosChar = right(#q_infoCuenta.direccion1#, 11)>

								<cfif ultimosChar eq '- Principal'>
									<cfset longitud = len(#q_infoCuenta.direccion1#)>
									<cfset nueva_direccion = Mid(#q_infoCuenta.direccion1#, 1, longitud - 11)>
									#nueva_direccion#
								<cfelse>
									#q_infoCuenta.direccion1#
								</cfif>
							</td>
						</tr>
						<tr>
							<td width="10%">Contactos</td>
							<td>#q_Contacto.SNCnombre# #q_Contacto.SNCtelefono#, #q_Contacto.SNCfax#</td>
						</tr>
						<tr>
							<td width="10%">Telefono</td>
							<td>#q_infoCuenta.SNtelefono#</td>
						</tr>
					</table>
				<td>
			</tr>
			<tr>
				<td colspan="2">
					<br>
					···························································································································································································
				</td>
			</tr>
			<tr>
				<td width="75%" align="center">
					<p style="#letter9#"> <b>PROGRAMACION DE DESCUENTOS PARA PAGO EN</b></p>
					<table #noBorder# style="#resumenE#" width="100%">
						<tr>
							<td style="#resumenE_td# text-align: center;"> Fecha Pago </td>
							<td style="#resumenE_td# text-align: left;"> % Descuento </td>
							<td style="#resumenE_td# text-align: center;"> Abono Prog </td>
							<td style="#resumenE_td# text-align: center;"> Descuento </td>
							<td style="#resumenE_td# text-align: center;"> Pago Total </td>
						</tr>
						<cfset lastDay4Pay = "">
						<cfset val = objParams.GetParametroInfo('30006101') >
						
						<cfloop from="1" to="30" index="i">
							<cfset dateDiffVar = Datediff('d',NewCycleStartDate,q_CortePago.FechaFin)>
							
							<cfif dateDiffVar lt val.valor + 3 and dateDiffVar gte 1 >

								<cfset newDescuento = objCuenta.getPorcientoDescuento(fechaPago=NewCycleStartDate,categoriaid=q_infoCuenta.CRCCategoriaDistid,codigoCorte='#q_CortePago.codigo#')>
								<cfif newDescuento gt Max_Descuento> 
									<cfset Max_Descuento = newDescuento> 
								</cfif>
								<cfset descuento = newDescuento>
								<cfset lastDay4Pay = NewCycleStartDate> 
								<tr>
									<td style="#resumenE_td# text-align: right;"> #DateFormat(NewCycleStartDate,"yyyy/mm/dd")#</td>
									<td style="#resumenE_td# text-align: right;"> #NumberFormat(descuento,"0")# %</td>
									<td style="#resumenE_td# text-align: right;"> $#LSCurrencyFormat(q_movCuentaCorteB.MontoAPagar, "none")#</td>
									<td style="#resumenE_td# text-align: right;"> $#LSCurrencyFormat(NumberFormat(q_movCuentaCorteA.MontoAPagar,"00.00") * (descuento/100), "none")#</td>
									<td style="#resumenE_td# text-align: right;"> $#LSCurrencyFormat(NumberFormat(q_movCuentaCorteB.MontoAPagar,"00.00") - (NumberFormat(q_movCuentaCorteA.MontoAPagar,"00.00") * (descuento/100)),"none")#</td>
								</tr>
							</cfif>
							<cfset NewCycleStartDate=DateAdd("d",1,NewCycleStartDate)> 
						</cfloop>
						<cfset result = objBarcode.CreateBarcodeOxxoD(
							  NumCuenta="#q_infoCuenta.Numero#"
							, FechaLimite=lastDay4Pay
						)>
					</table>
				</td>
				<td>
					<table #noBorder# style="#resumenE#" width="100%">
						<tr>
							<td>
								<div style=" padding-left: 1cm;">
									<span><img src="/crc/images/logo_oxxo.png" height="40px" width="auto"></span>
								</div>
								<div style=" padding-left: 1cm;">
									<span>&nbsp;</span>
								</div>
								<div style=" padding-left: 1cm;">
									<img src="#imgBarcodePath#" height="80px" width="auto" align="center">
								</div>
							</td>
							<td>
								<cfset numCorte = right(CodCorte,1)>
								<cfif numCorte eq 1>
									<cfset EmisorDeposito = q_infoCuenta.EmisorQ1>
								<cfelse>
									<cfset EmisorDeposito = q_infoCuenta.EmisorQ2>
								</cfif>
								<cfset _banco.PintaReferenciaPago(EmisorDeposito=EmisorDeposito,
														SNnombre = q_infoCuenta.SNnombre,
														fechafin = q_CortePago.fechafin -1,
														CodCorte = CodCorte,
														Numero = q_infoCuenta.Numero,
														Convenio = _convenio,
														MontoAPagar = q_movCuentaCorteB.MontoAPagar)>
							</td>
							<cfquery name="rsClasificacion" datasource="#session.DSN#">
								select cld.SNCDdescripcion 
								from SNClasificacionSN cl  
								left join SNClasificacionD cld  
									on cl.SNCDid = cld.SNCDid
								left join SNClasificacionE cle
									on cld.SNCEid = cle.SNCEid
								where SNid = <cfqueryparam value="#q_infoCuenta.SNid#" cfsqltype="cf_sql_integer">
								and cle.SNCredyC = 1
							</cfquery> 
							<td align="center" valign="middle">
								<span style="#letter15#"> <b>Usted es Categoria:</b></span><br/>
								<span style="#letter20#"> <b>#uCase(q_infoCuenta.titulo)#</b></span><br/>
								<span style="#letter15#">
								Aproveche descuento m&aacute;ximo<br/>
								del <b>#NumberFormat(Max_Descuento,"0")# %</b> pagando a tiempo
								</span><br/><br/><br/>
								<span style="#letter15#"> <b>#rsClasificacion.SNCDdescripcion#</b></span><br/>
							</td>
						</tr>
						

					</table>
				</td>
			</tr>
			<tr>
				<td colspan="2">
					<br>
					···························································································································································································
				</td>
			</tr>
			
			<tr>
				<td colspan="2">
					<br/>
					<table #noBorder# style="#resumenE#" width="100%">
						<tr>
							<td style="#resumenF_tdL# #resumenF_btm#">Fecha Compra</td>
							<td style="#resumenF_tdL# #resumenF_btm#">Nota de Venta</td>
							<td style="#resumenF_tdL# #resumenF_btm#">Negocio y Vale</td>
							<td style="#resumenF_tdL# #resumenF_btm#" width="20%">Cliente</td>
							<td style="#resumenF_tdR# #resumenF_btm#">Compra Inicial</td>
							<td style="#resumenF_tdR# #resumenF_btm#">Saldo Vencido</td>
							<td style="#resumenF_tdR# #resumenF_btm#">Interes Moratorio</td>
							<td style="#resumenF_tdR# #resumenF_btm#">No. Pago</td>
							<td style="#resumenF_tdR# #resumenF_btm#">Abono Corte</td>
							<td style="#resumenF_tdR# #resumenF_btm#">Descuento x Aplicar</td>
							<td style="#resumenF_tdR# #resumenF_btm#">Saldo Post al Pago</td>
						</tr>
						<cfquery name="q_MovCuenta"  datasource="#session.DSN#">
							select 
								  B.Fecha
								, B.Ticket
								, B.Folio
								, B.TiendaExt
								, B.Tienda
								, case B.TipoTransaccion
									when 'VC' then B.Cliente
									else TT.Descripcion end as Cliente
								, B.CURP
								, B.Monto
								, A.SaldoVencido
								, A.Intereses
								, A.MontoAPagar - (A.Pagado + A.Descuento) MontoAPagar
								, A.MontoRequerido - (A.Pagado + A.Descuento) MontoRequerido
								<!--- , isNull(C.Pagos,0) as Pagos --->
								, A.Descripcion
								, B.TipoTransaccion
								, case when (A.MontoAPagar - A.MontoRequerido) - (A.Pagado + A.Descuento) >= 0
										then (A.MontoAPagar - A.MontoRequerido) - (A.Pagado + A.Descuento)
										else 0
									end AS SV
								, B.monto - isnull(C.Pagos,0) - (A.MontoAPagar - (A.Pagado + A.Descuento)) AS SaldoPost
							from CRCMovimientoCuenta as A 
								inner join CRCTransaccion B 
									on A.CRCTransaccionid = B.id 
								left join (
									select CRCTransaccionid, Sum(A.Pagado)+ sum(A.Descuento) - sum(A.Intereses) + sum(A.Condonaciones) as Pagos
									from CRCMovimientoCuenta A 
									inner join CRCCortes B  on B.Codigo = A.Corte
									where  B.FechaFin <= '#DateFormat(q_Corte.fechafin,'yyyy-mm-dd')#'
									group by A.CRCTransaccionid
								) as C
									on C.CRCTransaccionid = B.id
								inner join CRCTipoTransaccion TT
									on TT.Codigo = B.TipoTransaccion
									and TT.Ecodigo = B.Ecodigo 
							where 
								A.Corte = '#CodCorte#' 
								and A.MontoAPagar - (A.Pagado + A.Descuento) > 0
								and B.CRCCuentasid = #CuentaID# and A.Ecodigo = #session.ecodigo#
								and rtrim(ltrim(B.TipoTransaccion)) not in ('SG','RP')
								and A.CRCConveniosid is null
								order by B.Fecha asc; 
						</cfquery>
				
						<cfquery name="q_MovCuentaSG"  datasource="#session.DSN#">
							select 
								  B.Fecha
								, B.Ticket
								, B.Folio
								, B.TiendaExt
								, B.Tienda
								, case B.TipoTransaccion
									when 'VC' then B.Cliente
									else TT.Descripcion end as Cliente
								, B.CURP
								, B.Monto
								, A.SaldoVencido
								, A.Intereses
								, A.MontoAPagar - (A.Pagado + A.Descuento) MontoAPagar
								, A.MontoRequerido - (A.Pagado + A.Descuento) MontoRequerido
								, A.Descripcion
								, B.TipoTransaccion
								, A.MontoAPagar - A.MontoRequerido as SV
								, B.monto - isnull(C.Pagos,0) - A.MontoRequerido AS SaldoPost
							from CRCMovimientoCuenta as A 
								inner join CRCTransaccion B 
									on A.CRCTransaccionid = B.id 
								left join (select CRCTransaccionid, Sum(A.Pagado)+ sum(A.Descuento) - sum(A.Intereses) + sum(A.Condonaciones) as Pagos
									from CRCMovimientoCuenta A inner join CRCCortes B  on B.Codigo = A.Corte
									where  B.FechaFin < '#DateFormat(q_Corte.fechafin,'yyyy-mm-dd')#' 
									group by A.CRCTransaccionid
								) as C
									on C.CRCTransaccionid = B.id
								inner join CRCTipoTransaccion TT
									on TT.Codigo = B.TipoTransaccion
									and TT.Ecodigo = B.Ecodigo 
							where 
								A.Corte = '#CodCorte#' 
								and B.CRCCuentasid = #CuentaID# and A.Ecodigo = #session.ecodigo#
								and rtrim(ltrim(B.TipoTransaccion)) = 'SG'
								and A.MontoRequerido > 0
								and A.CRCConveniosid is null
								order by B.Fecha asc; 
						</cfquery>

						<cfset val = objParams.GetParametroInfo('30000701')>
						<cfif val.codigo eq ''><cfthrow message="El parametro [30000701 - Porcentaje de interes por retraso] no existe"></cfif>
						<cfif val.valor eq ''><cfthrow message="El parametro [30000701 - Porcentaje de interes por retraso] no esta definido"></cfif>
						<cfset PorcientoInteres = val.valor/100>

						<cfset Total_Compras = 0>
						<cfset Total_AbonoCorte = 0>
						<cfset Total_Descuento = 0>
						<cfset Total_SaldoPost = 0>
						<cfset Total_SaldoVencido = 0>
						<cfset Total_Intereses = 0>

						<cfloop query="#q_MovCuenta#">
							<cfset Parcialidad = REMatch("\(\d+?\/\d+?\)",q_MovCuenta.Descripcion)[1]>
							<cfset Descuento = 0>
							<cfif trim(q_MovCuenta.TipoTransaccion) eq 'VC'>
								<cfset Descuento = q_MovCuenta.MontoAPagar * (Max_Descuento / 100)>
								<!--- <cfset q_MovCuenta.SaldoPost = q_MovCuenta.SaldoPost - Descuento> --->
							</cfif>
							<cfset SaldoVencidoD = 0>
							<cfset InteresesD = 0>
							<cfif trim(q_MovCuenta.TipoTransaccion) neq ''>
								<cfset SaldoVencidoD = q_MovCuenta.SV>
								<cfset InteresesD = SaldoVencidoD - (SaldoVencidoD / (1 + PorcientoInteres))>
								<cfset SaldoVencidoD = SaldoVencidoD> <!---  - InteresesD --->
							</cfif>
							
							<tr>
								<td style="#resumenF_tdL#">#dateFormat(q_MovCuenta.Fecha,'yyyy-mm-dd')#</td>
								<td style="#resumenF_tdL#">#q_MovCuenta.Tienda#-#q_MovCuenta.Ticket#</td>
								<td nowrap style="#resumenF_tdL#">
									<cfif q_MovCuenta.TiendaExt neq ''>#q_MovCuenta.TiendaExt# </cfif>#q_MovCuenta.Folio#
								</td>
								<td style="#resumenF_tdL#" nowrap>#q_MovCuenta.Cliente#</td>
								<td style="#resumenF_tdR#">$#LSCurrencyFormat(q_MovCuenta.Monto, "none")#</td>
								<td style="#resumenF_tdR#">$#LSCurrencyFormat(SaldoVencidoD, "none")#</td>
								<td style="#resumenF_tdR#">$#LSCurrencyFormat(InteresesD, "none")#</td>
								<td style="#resumenF_tdR#">#Parcialidad#</td>
								<td style="#resumenF_tdR#">$#LSCurrencyFormat(q_MovCuenta.MontoAPagar, "none")#</td>
								<td style="#resumenF_tdR#">$#LSCurrencyFormat(Descuento, "none")#</td>
								<td style="#resumenF_tdR#">$#LSCurrencyFormat(q_MovCuenta.SaldoPost, "none")#</td>
								<td style="#resumenF_tdR#">
									<cfset primerosChart = left(TRIM(#Parcialidad#), 3)>

									<cfif primerosChart eq '(1/'>
										* 
									<cfelse>
									</cfif>
								</td>
							</tr>
							
							<cfset Total_Compras += q_MovCuenta.Monto>
							<cfset Total_AbonoCorte += q_MovCuenta.MontoAPagar>
							<cfset Total_Descuento += Descuento>
							<cfset Total_SaldoPost += q_MovCuenta.SaldoPost>
							<cfset Total_SaldoVencido += SaldoVencidoD>
							<cfset Total_Intereses += InteresesD>
						</cfloop>
						
						<cfquery name="q_MCCPrev" datasource="#session.DSN#">
							select *
								from CRCMovimientoCuentaCorte 
								where corte='#q_CortePagoPrev.codigo#' and CRCCuentasid = #CuentaID# and Ecodigo = #session.ecodigo#;
						</cfquery>
						<cfquery name="q_MCC" datasource="#session.DSN#">
							select *
								from CRCMovimientoCuentaCorte 
								where corte='#CodCorte#' and CRCCuentasid = #CuentaID# and Ecodigo = #session.ecodigo#;
						</cfquery>
						<cfif q_MovCuentaSG.recordCount gt 0>
						<tr style="font-weight: normal;">
							<td>#dateFormat(q_MovCuentaSG.Fecha,'yyyy-mm-dd')#</td>
							<td>#q_MovCuentaSG.Tienda#-#q_MovCuentaSG.Ticket#</td>
							<td>
								<cfif q_MovCuentaSG.TiendaExt neq ''>#q_MovCuentaSG.TiendaExt# </cfif>#q_MovCuentaSG.Folio#
							</td>
							<td>#q_MovCuentaSG.Cliente#</td>
							<td>$#LSCurrencyFormat(q_MovCuentaSG.Monto,"none")#</td>
							<td>$#LSCurrencyFormat(NumberFormat(q_MCCPrev.SaldoVencido,'0.00')-Total_SaldoVencido , "none")#</td>
							<td>$#LSCurrencyFormat(NumberFormat(q_MCCPrev.Intereses,'0.00')-Total_Intereses, "none")#</td>
							<td>(1)</td>
							<td>$#LSCurrencyFormat(q_MovCuentaSG.MontoAPagar,"none")#</td>
							<td>$#LSCurrencyFormat(0,"none")#</td>
							<td>$#LSCurrencyFormat(q_MovCuentaSG.SaldoPost,"none")#</td>
						</tr>
						</cfif>
						<tr>
							<td style="#resumenF_tdL# #resumenF_tp#" colspan="2">NETO A PAGAR</td>
							<td style="#resumenF_tdR# #resumenF_tp#">$#LSCurrencyFormat(NumberFormat(Total_AbonoCorte,"00.00") - NumberFormat(Total_Descuento,"00.00"), "none")#</td>
							<td style="#resumenF_tdR# #resumenF_tp#">TOTALES:</td>
							<td style="#resumenF_tdR# #resumenF_tp#">$#LSCurrencyFormat(Total_Compras, "none")#</td>
							<td style="#resumenF_tdR# #resumenF_tp#">$#LSCurrencyFormat(Total_SaldoVencido, "none")#</td>
							<td style="#resumenF_tdR# #resumenF_tp#">$#LSCurrencyFormat(Total_Intereses, "none")#</td>
							<td style="#resumenF_tdR# #resumenF_tp#"></td>
							<td style="#resumenF_tdR# #resumenF_tp#">$#LSCurrencyFormat(Total_AbonoCorte, "none")#</td>
							<td style="#resumenF_tdR# #resumenF_tp#">$#LSCurrencyFormat(Total_Descuento, "none")#</td>
							<td style="#resumenF_tdR# #resumenF_tp#">$#LSCurrencyFormat(Total_SaldoPost, "none")#</td>
						</tr>
						<tr>
							<td style="#resumenF_tdL#" colspan="11">Distribuidor #q_infoCuenta.Numero# #q_infoCuenta.SNnombre#</td>
						</tr>
						<tr style="font-weight:bold">
						<cfquery name="c_resumen" datasource="#session.DSN#">
							select 
								MontoAprobado, 
								isnull(SaldoActual,0) - (Pagos + Condonaciones) + (isnull(Interes,0) + GastoCobranza) SaldoActual, 
								MontoAprobado - (isnull(SaldoActual,0) - (Pagos + Condonaciones) + (isnull(Interes,0) + isnull(GastoCobranza,0))) CreditoDisponible 
							from CRCCuentas C where C.id = #CuentaID#
						</cfquery>
						
							<td style="#resumenF_tdL#" colspan="3"><b>SALDO TOTAL ACTUAL (Incluyendo compras diferidas)</b></td>
							<td style="#resumenF_tdL#" colspan="1"><b>$#LSCurrencyFormat(c_resumen.SaldoActual<!--- Total_SaldoPost + Total_AbonoCorte ---> , "none")#</b></td>
<!--- 							<td style="#resumenF_tdL#" colspan="1">#toCurrencyFormat(c_resumen.SaldoActual)#</td> --->
							<td style="#resumenF_tdL#" colspan="2"><b>LIMITE DE CREDITO ACTUAL</b></td>
							<td style="#resumenF_tdL#" colspan="2"><b>$#LSCurrencyFormat(c_resumen.MontoAprobado, "none")#</b></td>
							<td style="#resumenF_tdL#" colspan="2"><b>SALDO DISPONIBLE ACTUAL</b></td>
							<td style="#resumenF_tdL#" colspan="1"><b>$#LSCurrencyFormat(c_resumen.MontoAprobado - (c_resumen.SaldoActual), "none")#</b></td>
<!--- 							<td style="#resumenF_tdL#" colspan="1">#toCurrencyFormat(c_resumen.CreditoDisponible)#</td> --->
						</tr>
						<tr>
							<!--- NAVA INICIO --->
							<cfquery name="q_TotalComprasDiferidas" datasource="#session.DSN#">
								select sum(Monto) as TotalComprasDiferidas
								from CRCTransaccion
								where CRCCuentasid = #CuentaID#
								and TipoTransaccion = 'VC'
								and FechaInicioPago > DATEADD(DAY, 1, (select FechaFin from CRCCortes where Codigo = '#CodCorte#') ) 
							</cfquery>
							<!--- NAVA FIN --->
							<td style="#resumenF_tdL#" colspan="3"><b>COMPRAS DIFERIDAS (Pendientes de aplicar)</b></td>
							<td style="#resumenF_tdL#" colspan="1"><b>$#LSCurrencyFormat(q_TotalComprasDiferidas.TotalComprasDiferidas , "none")#</b></td>
<!--- 							<td style="#resumenF_tdL#" colspan="1">#toCurrencyFormat(c_resumen.SaldoActual)#</td> --->
							<td style="#resumenF_tdL#" colspan="2">&nbsp;</td>
							<td style="#resumenF_tdL#" colspan="2">&nbsp;</td>
							<td style="#resumenF_tdL#" colspan="2">&nbsp;</td>
							<td style="#resumenF_tdL#" colspan="1">&nbsp;</td>
<!--- 							<td style="#resumenF_tdL#" colspan="1">#toCurrencyFormat(c_resumen.CreditoDisponible)#</td> --->
						</tr>
					</table>
				</td>
			</tr>
			
			<cfif Total_SaldoVencido + Total_Intereses gt 0>
				<tr>
					<td colspan="2" align="left">
						<cfset VC_Msg = "SALDO VENCIDO (incluye INTERESES MORATORIOS Y GASTOS DE COBRANZA): $#LSCurrencyFormat(Total_SaldoVencido + Total_Intereses, "none")# * Cuide su crédito, liquide este atraso cuanto antes*">
						<p style="#letter11#"><b> #VC_Msg# </b></p>
					</td>
				</tr>
			</cfif>
			<!--- NAVA INICIO --->
			<cfif q_TotalComprasDiferidas.TotalComprasDiferidas gt 0>
				<tr>
					<td colspan="2" align="center">
						<br/>
						<p style="#letter11#"><b>DESGLOSE COMPRAS DIFERIDAS</b></p>
					</td>
				</tr>
				<tr>
					<cfquery name="q_ComprasDiferidas" datasource="#session.DSN#">
						select Fecha, Monto, Cliente, Parciales, FechaInicioPago, Tienda, TiendaExt, Ticket, Folio
						from CRCTransaccion
						where CRCCuentasid = #CuentaID#
						and TipoTransaccion = 'VC' 
						and FechaInicioPago > DATEADD(DAY, 1, (select FechaFin from CRCCortes where Codigo = '#CodCorte#') ) 
						order by Fecha asc
					</cfquery>
					<td colspan="2" align="left">
						<table #noBorder# style="#resumenE#" width="100%">
							<tr>
								<th style="#resumenF_tdL# #resumenF_btm#">Fecha</th>
								<th style="#resumenF_tdL# #resumenF_btm#">Nota de Venta</th>
								<th style="#resumenF_tdL# #resumenF_btm#">Negocio y Vale</th>
								<th style="#resumenF_tdL# #resumenF_btm#">Cliente</th>
								<th style="#resumenF_tdR# #resumenF_btm#">Monto</th>
								<th style="#resumenF_tdR# #resumenF_btm#">Parciales</th>
								<th style="#resumenF_tdR# #resumenF_btm#">Fecha Inicio Pago</th>
							</tr>
							<cfloop query="q_ComprasDiferidas">
								<tr>
									<td style="#resumenF_tdL#">#dateFormat(q_ComprasDiferidas.Fecha,'yyyy-mm-dd')#</td>
									<td style="#resumenF_tdL#">#q_ComprasDiferidas.Tienda#-#q_ComprasDiferidas.Ticket#</td>
									<td style="#resumenF_tdL#">
										<cfif q_ComprasDiferidas.TiendaExt neq ''>#q_ComprasDiferidas.TiendaExt#</cfif>
										#q_ComprasDiferidas.Folio#
									</td>
									<td style="#resumenF_tdL#">#q_ComprasDiferidas.Cliente#</td>
									<td style="#resumenF_tdR#">$#LSCurrencyFormat(q_ComprasDiferidas.Monto, "none")#</td>
									<td style="#resumenF_tdR#">#q_ComprasDiferidas.Parciales#</td>
									<td style="#resumenF_tdR#">#dateFormat(q_ComprasDiferidas.FechaInicioPago,'yyyy-mm-dd')#</td>
								</tr>
							</cfloop>
						</table>
					</td>
				</tr>
			</cfif>
			<!--- NAVA FIN --->
			<tr>
				<td colspan="2" align="center">
					<br/>
					<cfset monthName = ["enero","febrero","marzo","abril","mayo","junio","julio","agosto","septiembre","octubre","noviembre","diciembre"]>
					<cfset dayName = {"SUN":"domingo","MON":"lunes","TUE":"martes","WED":"miercoles","THU":"jueves","FRI":"viernes","SAT":"sabado"}>
					<cfset mN=monthName[DateFormat(q_CortePago.fechaEntregaRelacion,"m")]>
					<cfset dN=dayName[DateFormat(q_CortePago.fechaEntregaRelacion,"ddd")]>
					<cfset fechaSiguienteCorte = "#uCase(dN)# #DateFormat(q_CortePago.fechaEntregaRelacion,'dd')# DE #Ucase(mN)# DEL #DateFormat(q_CortePago.fechaEntregaRelacion,'yyyy')#">
					<cfset VC_Msg = "ATENCION DISTRIBUIDORES DE GOMEZ<br/><br/>LA PROXIMA ENTREGA DE RELACIONES SERA EL #fechaSiguienteCorte# DE 9:45 AM A 6:30 PM EN LA SUCURSAL DE TIENDAS FULL VICTORIA. TELS 7294129/30">
					<p style="#letter11#"><b> #VC_Msg# </b></p>
				</td>
			</tr>
			<tr>
				<td colspan="2" align="center">
					<br/>
					<p style="#letter11#"><b> #objParams.GetParametroInfo('30010001').valor# </b></p>
				</td>
			</tr>
			<tr>
				<td colspan="2">
					<br>
					
				</td>
			</tr>
		</table>
 </cfoutput>
 <cffunction  name="toCurrencyFormat">
	<cfargument  name="value">

	<cfreturn "$#NumberFormat(arguments.value,"00.00")#">
 </cffunction>