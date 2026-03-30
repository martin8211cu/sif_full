<!---
  --- CRCCuentas
  --- ----------
  ---
  --- author: martin
  --- date:   25/10/17
  --->
<cfcomponent accessors="true" output="false">

	<cffunction name="CreaCuenta" access="public" returntype="string">
		<cfargument name="snid" type="integer" required="true" hint="id del socio de negocio">
		<cfargument name="tipo" type="string" required="true" hint="Tipo de cuenta (D,TC,TM)">
		<cfargument name="monto" type="numeric" required="true" hint="Monto autorizado">
		<cfargument name="categoriaid" type="integer" required="false" default="-1" hint="id de la categoria en caso que el tipo sea D">

		<cfset loc.numero ="">

		<!---
		<cfif ucase(arguments.tipo) eq "D">
			<cfset loc.numero ="01">
		<cfelseif ucase(arguments.tipo) eq "TC">
			<cfset loc.numero ="02">
		<cfelseif ucase(arguments.tipo) eq "TM">
			<cfset loc.numero ="03">
		</cfif>
		--->
		<cfset loc.numero ="#loc.numero##DateFormat(now(),'YYMM')#">

		<cfquery name="rsMaxConsecutivo" datasource="#session.dsn#">
			select right('000' + cast(cast(right( COALESCE(max(Numero),0),3) as integer)+1 as varchar),3) as consecutivo
			from CRCCuentas where Numero like '#loc.numero#%' and Ecodigo = #Session.Ecodigo#
		</cfquery>
		<cfset loc.numero ="#loc.numero##rsMaxConsecutivo.consecutivo#">

		<cfquery name="rsEstatusid" datasource="#session.dsn#">
			select top 1 id from CRCEstatusCuentas where Ecodigo = #session.Ecodigo# order by Orden
		</cfquery>

		<cfquery datasource="#session.dsn#" name="ins">
			INSERT INTO CRCCuentas
			(SNegociosSNid,Numero,Tipo,CRCEstatusCuentasid,CRCCategoriaDistid,
					MontoAprobado,Ecodigo,Usucrea,createdat)
			VALUES
		           (#arguments.snid#
		           ,'#loc.numero#'
		           ,'#trim(arguments.tipo)#'
		           ,#rsEstatusid.id#
		           ,<cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.categoriaid#" null="#arguments.categoriaid eq -1#">
		           ,#arguments.monto#
		           ,#Session.Ecodigo#
		           ,#session.Usucodigo#
		           ,getDate())
			<cf_dbidentity1 datasource="asp">
		</cfquery>
		<cf_dbidentity2 datasource="asp" name="ins">

		<cfreturn ins.identity>
	</cffunction>

	<cffunction name="DisponibleCuenta" access="public" return="numeric">
		<cfargument name="CuentaID" 	required="yes" 		type="numeric">
		<cfargument name="DSN" 			default="#Session.DSN#" type="string">
		<cfargument name="Ecodigo" 		default="#Session.Ecodigo#" type="string">

		<cfset Disponible = 0>
		<cfquery name="q_CRCCuentas" datasource="#arguments.DSN#">
			select
				SNegociosSNid,
				ISNULL(MontoAprobado,0) MontoAprobado,
				(ISNULL(MontoAprobado,0)
					- ( ISNULL(Interes,0) + ISNULL(GastoCobranza,0) + ISNULL(SaldoVencido,0) + ISNULL(Compras,0))
					+ (ISNULL(Pagos,0) + ISNULL(Condonaciones,0))) Disponible,
				Tipo
			from CRCCuentas where id = '#arguments.CuentaID#' and Ecodigo = '#arguments.Ecodigo#' ;
		</cfquery>
		<cfif q_CRCCuentas.recordcount eq 0>
			<cfthrow type="TransaccionException" message = "No se encontro la cuenta [#arguments.CuentaID#]">
		</cfif>

		<cfset q_CRCCuentas = QueryGetRow(q_CRCCuentas, 1)>
		<cfset Disponible = q_CRCCuentas.Disponible>

		<cfif Trim(q_CRCCuentas.Tipo) eq 'D'>
			<cfquery name="q_CRCTCParams" datasource="#arguments.DSN#">
				select
					DCreditoAbierto
				from CRCTCParametros 
				where 
					SNegociosSNid = '#q_CRCCuentas.SNegociosSNid#' 
					and CRCuentasid = #arguments.CuentaID#;
			</cfquery>
			<!--- <cf_dump var="#q_CRCTCParams#"> --->

			<cfif q_CRCTCParams.recordcount ge 1>
				<cfset q_CRCTCParams = QueryGetRow(q_CRCTCParams, 1)>
			<cfif q_CRCTCParams.DCreditoAbierto eq 1>
					<cfquery name="q_Promos" datasource="#arguments.DSN#">
					select
						FechaDesde,
						FechaHasta,
						Monto,
						Porciento
					from CRCPromocionCredito
					where
							Ecodigo = '#arguments.Ecodigo#'
						and '#DateFormat(Now(), "yyyy/mm/dd")#'  between FechaDesde and dateadd(day, 1, FechaHasta) 
						;
				</cfquery>
				<cfloop query="#q_Promos#">
					<cfif q_Promos.Porciento eq 1>
						<cfset Disponible = Disponible + (q_CRCCuentas.MontoAprobado * (q_Promos.Monto / 100))>
					<cfelse>
						<cfset Disponible = Disponible + q_Promos.Monto>
					</cfif>
				</cfloop>
			</cfif>
			<cfelse>
				<cfthrow type="TransaccionException" message = "SNegociosSNid [#q_CRCCuentas.SNegociosSNid#] no encontrado en CRCTCParametros">
		</cfif>
		</cfif>

		<cfreturn Disponible>

	</cffunction>


	<cffunction name="afectarCuenta" access="public" return="numeric">

		<cfargument name="CuentaID" 				required="yes" 		type="numeric">
		<cfargument name="Monto" 					required="yes" 		type="numeric">
		<cfargument name="CodigoTipoTransaccion" 	required="yes" 		type="string">
		<cfargument name="DSN" 						default="#Session.DSN#" type="string">
		<cfargument name="Ecodigo" 					default="#Session.Ecodigo#" type="string">

		<cfquery name="q_TipoTransaccion" datasource="#arguments.DSN#">
			select
				afectaSaldo,
				afectaInteres,
				afectaCompras,
				afectaPagos,
				afectaCondonaciones,
				afectaGastoCobranza
			from CRCTipoTransaccion
			where
				Ecodigo = '#arguments.Ecodigo#'
				and Codigo = '#arguments.CodigoTipoTransaccion#'
				;
		</cfquery>

		<cfif q_TipoTransaccion.recordcount ge 1>
			<cfset q_TipoTransaccion = QueryGetRow(q_TipoTransaccion, 1)>
		<cfelse>
			<cfthrow type="TransaccionException" message = "No se encontro codigo de tipo de transaccion [#arguments.CodigoTipoTransaccion#]">
		</cfif>

		<cfif q_TipoTransaccion.afectaSaldo eq 1>
			<cfset afectaA = 'SaldoActual'>
		<cfelseif q_TipoTransaccion.afectaInteres eq 1>
			<cfset afectaA = 'Interes'>
		<cfelseif q_TipoTransaccion.afectaCompras eq 1>
			<cfset afectaA = 'Compras'>
		<cfelseif q_TipoTransaccion.afectaPagos eq 1>
			<cfset afectaA = 'Pagos'>
		<cfelseif q_TipoTransaccion.afectaCondonaciones eq 1>
			<cfset afectaA = 'Condonaciones'>
		<cfelseif q_TipoTransaccion.afectaGastoCobranza eq 1>
			<cfset afectaA = 'GastoCobranza'>
		</cfif>

		<cfquery name="q_Afectacion" datasource="#arguments.DSN#">
			update CRCCuentas set #afectaA# = (ISNull(#afectaA#,0 )+#arguments.Monto#) where id = #arguments.CuentaID#;
		</cfquery>

		<cfreturn 1>


	</cffunction>

	<cffunction name="getPagoMinino" returntype="numeric" access="public">
		<cfargument name="monto" default="0" type="float">
		<cfargument name="ecodigo" required="false" default="#Session.Ecodigo#" type="numeric">
		<cfargument name="dsn" required="false" default="#Session.dsn#" type="string">
		<!---
		<cfset montoR = monto/1000>

		<cfif monto eq 0>
			<cfset result=0>
		<cfelseif monto gt 5000>
			<cfset result=monto>
		<cfelse>
			<cfset result = iif( montoR eq 0,1,iif(monto%1000 eq 0,int(montoR),int(montoR)+1))*1000>
		</cfif>
		<cfreturn (result*10)/100>
		--->
		<cfquery name="q_pagoMin" datasource="#arguments.dsn#">
			select * from CRCPagoMinimo where SaldoMin <= #arguments.monto# and SaldoMax >= #arguments.monto# and Ecodigo = #arguments.ecodigo#
		</cfquery>
		

		<cfif q_pagoMin.recordCount gt 0>
			<cfif q_pagoMin.Porciento eq 1>
				<cfset result = arguments.monto * (q_pagoMin.MontoPagoMin/100)>
			<cfelse>
				<cfset result = q_pagoMin.MontoPagoMin>
			</cfif>
		<cfelse>
			<cfset PORCINTO_DEFECTO_PAGO_MIN = '30200501'>
			<cfset objParams = createObject("component", "crc.Componentes.CRCParametros")>
			<cfset val = objParams.getParametro(#PORCINTO_DEFECTO_PAGO_MIN#)>
			<cfset result = arguments.monto * (val/100)>
		</cfif>

		<cfreturn NumberFormat(result,"0.00")>

	</cffunction>

	<cffunction name="getPagos" returnformat="plain" access="remote">
		<cfargument name="idcuenta" required="true" >
		<cfargument name="dsn" required="false" default="#Session.dsn#">
		<cfargument name="Ecodigo" required="false" default="#Session.Ecodigo#">


		<cfset _pagoreq = 1>

		<cfset pagosHtml = "">
		<cfif arguments.idcuenta neq "">
			<cfquery name="rsUltimoCorteCerrado" datasource="#arguments.dsn#">
				select c.id Cuentaid, max(mcc.Corte) Corte, c.Tipo, isnull(c.SaldoActual,0) SaldoActual, 
					isnull(c.SaldoVencido,0) SaldoVencido, isnull(c.MontoAprobado,0) MontoAprobado,
					isnull(c.DatosEmpleadoDEid,c.DatosEmpleadoDEid2) CRCDEid,
					isnull(c.FechaAbogado,c.FechaGestor) FechaAsignacion, c.CRCCategoriaDistid,
					isnull(c.Condonaciones,0) Condonaciones, isnull(c.Interes,0) Intereses, c.CRCEstatusCuentasid,
					isnull(d.PorcentajeCobranzaAntes,0) PorcentajeCobranzaAntes, isnull(d.PorcentajeCobranzaDespues,0) PorcentajeCobranzaDespues,
					sum(mcc.MontoRequerido -isnull(mcc.GastoCobranza,0)-isnull(mcc.Seguro,0)) Compras,
					sum(mcc.MontoPagado), 
					isnull(sum(mcc.Seguro),0) Seguro, 
					isnull(sum(mcc.MontoAPagar),0)  MontoAPagar, 
					isnull(sum(mcc.GastoCobranza),0) GastoCobranza,
					isnull(sum(mcc.MontoPagado),0) Pagos, 
					isnull(sum(mcc.Descuentos),0) Descuentos
				from CRCMovimientoCuentaCorte mcc
				inner join CRCCuentas c
					on c.id = mcc.CRCCuentasid
				inner join CRCCortes ct
					on ct.Codigo = mcc.Corte
				left join DatosEmpleado d
					on isnull(c.DatosEmpleadoDEid,c.DatosEmpleadoDEid2) = d.DEid and c.Ecodigo = d.Ecodigo
				where ct.cerrado = 1
					and ct.status = 1
					and mcc.CRCCuentasid = #arguments.idcuenta#
				group by  c.id, c.Tipo, isnull(c.SaldoActual,0), 
					isnull(c.SaldoVencido,0), isnull(c.MontoAprobado,0),
					isnull(c.DatosEmpleadoDEid,c.DatosEmpleadoDEid2),
					isnull(c.FechaAbogado,c.FechaGestor), c.CRCCategoriaDistid,
					isnull(c.Condonaciones,0), isnull(c.Interes,0), c.CRCEstatusCuentasid,
					isnull(d.PorcentajeCobranzaAntes,0), isnull(d.PorcentajeCobranzaDespues,0) 
				order by Corte desc
			</cfquery>
			
			<cfif rsUltimoCorteCerrado.recordCount eq 0>
				<cfset _pagoreq = 0>
				<cfquery name="rsUltimoCorteCerrado" datasource="#arguments.dsn#">
					select top 1 c.id Cuentaid, mcc.Corte, c.Tipo, isnull(c.SaldoActual,0) SaldoActual, 
						isnull(c.SaldoVencido,0) SaldoVencido, isnull(c.MontoAprobado,0) MontoAprobado,
						isnull(c.DatosEmpleadoDEid,c.DatosEmpleadoDEid2) CRCDEid,
						isnull(c.FechaAbogado,c.FechaGestor) FechaAsignacion,
						(mcc.MontoRequerido -isnull(mcc.GastoCobranza,0)-isnull(mcc.Seguro,0)) Compras,mcc.MontoPagado, isnull(c.Condonaciones,0) Condonaciones, c.CRCCategoriaDistid,
						isnull(mcc.MontoAPagar,0)  MontoAPagar, isnull(c.Interes,0) Intereses, isnull(mcc.MontoPagado,0) Pagos, isnull(mcc.Descuentos,0) Descuentos,
						isnull(d.PorcentajeCobranzaAntes,0) PorcentajeCobranzaAntes, isnull(d.PorcentajeCobranzaDespues,0) PorcentajeCobranzaDespues,
						isnull(mcc.Seguro,0) Seguro, isnull(mcc.GastoCobranza,0) GastoCobranza,
						c.CRCEstatusCuentasid
					from CRCMovimientoCuentaCorte mcc
					inner join CRCCuentas c
						on c.id = mcc.CRCCuentasid
					inner join CRCCortes ct
						on ct.Codigo = mcc.Corte
					left join DatosEmpleado d
						on isnull(c.DatosEmpleadoDEid,c.DatosEmpleadoDEid2) = d.DEid and c.Ecodigo = d.Ecodigo
					where mcc.CRCCuentasid = #arguments.idcuenta#
						and ct.status = 0
					order by Corte
				</cfquery>

			</cfif>
			<cfif rsUltimoCorteCerrado.recordCount gt 0>
				<cfquery name="rsCorteActual" datasource="#arguments.dsn#">
					select top 1 *
					from CRCCortes ct
					where getdate() between FechaInicio and dateadd(day, 1, FechaFin)
						and Tipo = '#rsUltimoCorteCerrado.Tipo#'
				</cfquery>
				<cfquery name="rsHayPagos" datasource="#arguments.dsn#">
					select count(1) cantPagos
					from CRCTransaccion t 
					inner join CRCCortes c on t.Fecha between c.FechaInicio and dateadd(day, 1, c.FechaFin)
					inner join CRCCuentas ct on t.CRCCuentasid = ct.id and ct.Tipo = c.Tipo
					where t.CRCCuentasid = #arguments.idcuenta# 
						and t.TipoTransaccion in ('PG', 'NR')
						and c.Codigo = '#trim(rsCorteActual.Codigo)#'
				</cfquery>
							
				<cfset descLine = 0>
				<cfset porcComision = 0>
				<cfset porDesc = 0>
				<cfset lvarDescuentoFuturo= 0>

				<cfif rsUltimoCorteCerrado.FechaAsignacion neq "">
					<cfset objParams = createObject("component", "crc.Componentes.CRCParametros")>
					<cfset val = objParams.getParametroInfo('30200503')>
					<cfif val.valor eq ''><cfset  val.valor = 30></cfif>
					<cfset porcComision = rsUltimoCorteCerrado.PorcentajeCobranzaAntes>
					<cfif datediff("d",rsUltimoCorteCerrado.FechaAsignacion,now()) gte val.valor>
						<cfset porcComision = rsUltimoCorteCerrado.PorcentajeCobranzaDespues>
					</cfif>
				</cfif>
				
				<cfset lvarSaldoActual = rsUltimoCorteCerrado.SaldoActual>
				<cfset lvarSaldoActualNeto = rsUltimoCorteCerrado.SaldoActual>
				
				<cfset crcObjParametros = createobject("component","crc.Componentes.CRCParametros")>
				<cfset statusConvenio = crcObjParametros.GetParametro(codigo='30100501',conexion=arguments.dsn,ecodigo=arguments.ecodigo)>

				<cfquery name="rsOrdenEstatusAct" datasource="#arguments.dsn#">
					select id, Orden from CRCEstatusCuentas where id = #rsUltimoCorteCerrado.CRCEstatusCuentasid#
				</cfquery>
				
				<cfquery name="rsOrdenEstatusParam" datasource="#arguments.dsn#">
					select id, Orden from CRCEstatusCuentas where id = #statusConvenio#
				</cfquery>

				<cfif trim(rsUltimoCorteCerrado.Tipo) eq "D" and rsOrdenEstatusAct.Orden lt rsOrdenEstatusParam.Orden>
					<cfquery name="rsCategoria" datasource="#arguments.DSN#">
						select DescuentoInicial , PenalizacionDia
						from CRCCategoriaDist where Ecodigo = #arguments.Ecodigo# and id = #rsUltimoCorteCerrado.CRCCategoriaDistid#
					</cfquery>
					
					<cfset porcDescIni = rsCategoria.DescuentoInicial>
					<cfset lvarDescuentoFuturo = porcDescIni/100 * (rsUltimoCorteCerrado.SaldoActual - rsUltimoCorteCerrado.Seguro - rsUltimoCorteCerrado.SaldoVencido - rsUltimoCorteCerrado.Intereses -rsUltimoCorteCerrado.Compras)>
					<cfset lvarSaldoFuturo = rsUltimoCorteCerrado.SaldoActual - rsUltimoCorteCerrado.Seguro - rsUltimoCorteCerrado.SaldoVencido - rsUltimoCorteCerrado.Intereses - rsUltimoCorteCerrado.Compras - lvarDescuentoFuturo>
					
					<cfset porDesc = getPorcientoDescuento(now(),rsUltimoCorteCerrado.CRCCategoriaDistid,rsCorteActual.Codigo)>
					<cfset descLine = ((rsUltimoCorteCerrado.Compras)*porDesc)/100>

					<cfset lvarSaldoActual = rsUltimoCorteCerrado.SaldoVencido + rsUltimoCorteCerrado.Intereses + rsUltimoCorteCerrado.Seguro + (rsUltimoCorteCerrado.Compras - descLine) + (lvarSaldoFuturo)>		

				</cfif>
			<cfelse>
				<!--- mensaje por defecto --->
				<cfset pagosHtml = "No se requiere ningun Pago">
			</cfif>
			
		</cfif>

		<cfif arguments.idcuenta neq "" and rsUltimoCorteCerrado.recordcount gt 0>
			<cfsavecontent variable="pagosHtml">
				<cfoutput>
				<table border="0" cellpadding="1" cellspacing="0">
					<tr>
						<td width="50%" valign="top">
							<table border="0" cellpadding="1" cellspacing="2">
								<!--- Precio Unitario --->
								<tr>
									<td align="left">
										<input name="dtPago" type="radio" value="A" 
											onchange="$('##DTotraCant').val('#LSNumberFormat(lvarSaldoActual,',9.00')#'); $('##DTotraCant').prop('readonly', true);" >
										<label id="PrecioULabel" class="etiqueta">Saldo Actual:</label>
									</td>
			      						<td align="right"> 
			      							#LSCurrencyFormat(lvarSaldoActual)#
			      						</td>
								</tr>
								<!--- <tr>
									<td align="left" nowrap>
										<input name="dtPago" type="radio" value="V" <cfif rsUltimoCorteCerrado.SaldoVencido lte 0> disabled</cfif>
											onchange="$('##DTotraCant').val('#LSNumberFormat(rsUltimoCorteCerrado.SaldoVencido,',9.00')#')">
											<label id="cantLabel" class="etiqueta">Saldo Vencido + Intereses:</label>
									</td>
			      						<td align="right">
			      							#LSCurrencyFormat(rsUltimoCorteCerrado.SaldoVencido+rsUltimoCorteCerrado.Intereses)#
			                              </td>
								</tr> --->
								<!--- Cantidad --->
								<tr>
									<td align="left" nowrap>
										<cfset lvarMontoApagar = rsUltimoCorteCerrado.MontoAPagar - descLine>
										<cfif rsUltimoCorteCerrado.Tipo eq 'TM'>
											<cfset lvarMontoApagar = lvarSaldoActual>
										</cfif>
										<input name="dtPago" type="radio" value="C" 
											onchange="$('##DTotraCant').val('#LSNumberFormat(lvarMontoApagar,',9.00')#'); $('##DTotraCant').prop('readonly', true);">
										<label id="cantLabel" class="etiqueta">Saldo al corte:</label>
									</td>
										  <td align="right">
											<cfset lvarMontoApagar = (lvarMontoApagar gt 0) ? lvarMontoApagar : 0 >
										  	#LSCurrencyFormat(lvarMontoApagar)#
											<input name="DTSaldoActual" type="hidden" value="#lvarSaldoActual#">
			      							<input name="DTSaldoVencido" type="hidden" value="#rsUltimoCorteCerrado.SaldoVencido + rsUltimoCorteCerrado.Intereses#">
			      							<input name="DTdeslinea" type="hidden" value="0">
			      							<input name="DTCRCDEid" type="hidden" value="#rsUltimoCorteCerrado.CRCDEid#">
			      							<input name="DTCRCPorcCom" type="hidden" value="#porcComision#">
			      							<input name="DTCRCSaldoCorte" type="hidden" value="#rsUltimoCorteCerrado.Compras#">
											<input name="DTCRCMontoAPagar" type="hidden" value="#rsUltimoCorteCerrado.MontoAPagar - descLine#">
			      							<input name="DTCRCPorcDes" type="hidden" value="#porDesc#">
											<input name="DTCRCDesTotal" type="hidden" value="#descLine + lvarDescuentoFuturo#">
											<input name="DTCRCSeguro" type="hidden" value="#rsUltimoCorteCerrado.Seguro#">
											<input name="DTCRCPago" type="hidden" value="#rsUltimoCorteCerrado.Pagos#">
											<input name="DTCRCTotalPago" type="hidden" value="#rsUltimoCorteCerrado.Pagos + rsUltimoCorteCerrado.Descuentos#">
											<input name="DTCRCGastoCobranza" type="hidden" value="#rsUltimoCorteCerrado.GastoCobranza#">
											<input name="DTCRCCantPagos" type="hidden" value="#rsHayPagos.cantPagos#">
			                            </td>
								</tr>
								<cfif trim(rsUltimoCorteCerrado.tipo) eq "TC">
								<tr>
									<td align="left">
										<input name="dtPago" type="radio" value="M" 
										onchange="$('##DTotraCant').val('#LSNumberFormat(getPagoMinino(rsUltimoCorteCerrado.MontoAPagar + rsUltimoCorteCerrado.Seguro),',9.00')#'); $('##DTotraCant').prop('readonly', true);">
										<label id="cantLabel" class="etiqueta">Pago Minimo:</label>
									</td>
			      						<td align="right">
			      							#LSCurrencyFormat(getPagoMinino(rsUltimoCorteCerrado.MontoAPagar + rsUltimoCorteCerrado.Seguro))#
			                              </td>
								</tr>
								</cfif>
								<tr>
									<td align="left">
										<input name="dtPago" type="radio" value="O" checked onchange="$('##DTotraCant').val('#LSNumberFormat(0,',9.00')#'); $('##DTotraCant').prop('readonly', false);">
										<label id="recargoLabel" class="etiqueta">Otra cantidad:</label>
									</td>
			      						<td align="right">
			      							<input id="DTotraCant" name="DTotraCant" type="text" style="text-align:right; margin-top: 7px;"
			      								   <!--- onBlur="javascript: suma();" onFocus="javascript: this.select();"
			      								   onchange="javascript:fm(this,2); suma();" ---> tabindex="-1"
											onKeyUp="if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}"
											onFocus="javascript:this.select();"
											onChange="javascript: fm(this,2);"
			      							size="18" maxlength="18" value="0.00" >
										<input type="hidden" name="rec" value="" />
			      						</td>
								</tr>
							</table>
						</td>
						<td>
							<table width="95%" border="1" cellspacing="0" cellpadding="0" align="center" style="font-weight:bold">
								<tr>
									<td align="center" colspan="2" class="listaPar">
										<b>Estado Actual</b>
									</td>
								</tr>
								<!--- <tr>
									<td width="50%" align="right" nowrap>
										<strong>Monto Aprobado:&nbsp;</strong>
									</td>
									<td align="right" nowrap>
										#LSCurrencyFormat(rsUltimoCorteCerrado.MontoAprobado)#
									</td>
								</tr> --->
								<tr>
									<td align="right" nowrap>
										<strong>Saldo Actual:&nbsp;</strong>
									</td>
									<td align="right" nowrap>
										#LSCurrencyFormat(lvarSaldoActualNeto)#
									</td>
								</tr>
								<tr>
									<td align="right" nowrap>
										<strong>Saldo Vencido:&nbsp;</strong>
									</td>
									<td align="right" nowrap>
										#LSCurrencyFormat(rsUltimoCorteCerrado.SaldoVencido)#
									</td>
								</tr>
								<tr>
									<td align="right" nowrap>
										<strong>Intereses:&nbsp;</strong>
									</td>
									<td align="right" nowrap>
										#LSCurrencyFormat(rsUltimoCorteCerrado.Intereses)#
									</td>
								</tr>
								<tr>
									<td align="right" nowrap>
										<strong>Seguro:&nbsp;</strong>
									</td>
									<td align="right" nowrap>
										#LSCurrencyFormat(rsUltimoCorteCerrado.Seguro)#
									</td>
								</tr>
								<tr>
									<td align="right" nowrap>
										<strong>Gasto Cobranza:&nbsp;</strong>
									</td>
									<td align="right" nowrap>
										#LSCurrencyFormat(rsUltimoCorteCerrado.GastoCobranza)#
									</td>
								</tr>
								<tr>
									<td align="right" nowrap>
										<strong>Saldo por vencer:&nbsp;</strong>
									</td>
									<td align="right" nowrap>
										#LSCurrencyFormat(rsUltimoCorteCerrado.Compras)#
									</td>
								</tr>
								<cfif trim(rsUltimoCorteCerrado.Tipo) eq "D">
									<tr>
										<td align="right" nowrap>
											<strong>Descuento:&nbsp;</strong>
										</td>
										<td align="right" nowrap>
											#LSNumberFormat(porDesc)#%
										</td>
									</tr>
									<tr>
										<td align="right" nowrap>
											<strong>Monto Descuento:&nbsp;</strong>
										</td>
										<td align="right" nowrap>
											#LSCurrencyFormat(rsUltimoCorteCerrado.Compras*(porDesc/100))#
										</td>
									</tr>
								</cfif>
								<tr>
									<td align="right" nowrap>
										<strong>Abonos:&nbsp;</strong>
									</td>
									<td align="right" nowrap>
										#LSCurrencyFormat(rsUltimoCorteCerrado.Pagos)#
									</td>
								</tr>
								<tr>
									<td align="right" nowrap>
										<strong>Descuentos:&nbsp;</strong>
									</td>
									<td align="right" nowrap>
										#LSCurrencyFormat(rsUltimoCorteCerrado.Descuentos)#
									</td>
								</tr>
								<tr>
									<td align="right" nowrap>
										<strong>Condonaciones:&nbsp;</strong>
									</td>
									<td align="right" nowrap>
										#LSCurrencyFormat(rsUltimoCorteCerrado.Condonaciones)#
									</td>
								</tr>
								<tr style="background: blue">
									<td style="color:white" align="right" nowrap>
										<strong>POR PAGAR:&nbsp;</strong>
									</td>
									<td style="color:white" align="right" nowrap>
									<cfset lvarPorPagar = ((
											rsUltimoCorteCerrado.SaldoVencido + rsUltimoCorteCerrado.Intereses 
											+ rsUltimoCorteCerrado.Seguro + rsUltimoCorteCerrado.GastoCobranza 
											+ rsUltimoCorteCerrado.Compras
										) 
										- ( rsUltimoCorteCerrado.Pagos + rsUltimoCorteCerrado.Descuentos + rsUltimoCorteCerrado.Condonaciones)) * _pagoreq>
									<cfif lvarPorPagar gt 0>
										<cfset lvarMontoDescuento = lvarPorPagar>
										<cfif lvarPorPagar gte rsUltimoCorteCerrado.Compras>
											<cfset lvarMontoDescuento = rsUltimoCorteCerrado.Compras>
										</cfif>
										<cfset lvarPorPagar = lvarPorPagar - (lvarMontoDescuento *(porDesc/100))>
									</cfif>
									#LSCurrencyFormat(lvarPorPagar)#									
									</td>
								</tr>
							</table>
						</td>
					</tr>
				</table>
				</cfoutput>
			</cfsavecontent>
		</cfif>
		<cfreturn pagosHtml>
	</cffunction>

	<cffunction name="getPorcientoDescuento" returntype="numeric">
		<cfargument name="fechaPago" type="date" required="true">
		<cfargument name="categoriaid" type="integer" required="true">
		<cfargument name="codigoCorte" type="string" required="true">
		<cfargument name="conexion" required="false" default="#session.dsn#">
		<cfargument name="ecodigo"  required="false" default="#session.Ecodigo#">

		<cfquery name="rsCategoria" datasource="#arguments.conexion#">
			select DescuentoInicial , PenalizacionDia
			from CRCCategoriaDist where Ecodigo = #arguments.Ecodigo# and id = #Arguments.categoriaid#
		</cfquery>

		<cfquery name="rsCorte" datasource="#arguments.conexion#">
			select Codigo, FechaInicio, FechaFin
			from CRCCortes where Ecodigo = #arguments.Ecodigo# and codigo = '#arguments.codigoCorte#'
		</cfquery>

		<cfif rsCategoria.recordcount eq 0 or rsCorte.recordcount eq 0>
			<cfreturn 0>
		</cfif>

		<cfset crcParametros = createobject("component","crc.Componentes.CRCParametros")>
		<cfset diasPenDesc = crcParametros.GetParametro(codigo='30006101',conexion=arguments.conexion,ecodigo=arguments.ecodigo)>
		<cfset descIni = rscategoria.DescuentoInicial>
		<cfset penDia = rscategoria.PenalizacionDia>
		<cfset fechaFinCorte = dateFormat(rsCorte.FechaFin,"yyyy-mm-dd")>
		
		<cfset fechaPago = dateFormat(arguments.fechaPago,"yyyy-mm-dd")>

		<cfset difFecha = datediff("d",fechaPago,fechaFinCorte)+1>
		<cfif difFecha + 1 gte diasPenDesc>
			<cfreturn descIni>
		<cfelseif difFecha + 1 eq (diasPenDesc - 1)>
			<cfreturn descIni - (((diasPenDesc - 1)  - difFecha)*penDia)>
		<cfelse>
			<cfreturn 0>
		</cfif>

	</cffunction>

</cfcomponent>