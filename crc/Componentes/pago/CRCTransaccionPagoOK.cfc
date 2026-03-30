<cfcomponent output="false" displayname="CRCTransaccionPago"  extends="crc.Componentes.transacciones.CRCTransaccion">
	<cfset TIPO_TRANSACCION_PAGO = "PG">

	<cffunction name="pago" access="public" hint="funcion para realizar el  pago de compras y/o deudas">
		<cfargument name="CuentaID"        	required = "true" type="numeric">
		<cfargument name="Monto"         	required = "true" type="numeric">
		<cfargument name="FechaPago"        required = "true" type="date">
		<cfargument name="tipoTPago"     	required = "false" type="string" default = "#TIPO_TRANSACCION_PAGO#">
		<cfargument name="Observaciones" 	required = "false" type="string" default = "">
		<cfargument name="MontoDescuento"	required = "false" type="numeric" default = 0>
		<cfargument name="FCid" 			required = "false" type="numeric" default = 0>
		<cfargument name="ETnumero" 		required = "false" type="numeric" default = 0>
		<cfargument name="debug" 			required = "false" type="boolean" default = "false">

		<!--- OBTENCION DE ID PARA TIPO DE TRANSACCION --->
		<cfquery name="q_TipoTransaccion" datasource="#This.DSN#">
			select id, Codigo,TipoMov
			from   CRCTipoTransaccion
			where  Codigo = '#arguments.tipoTPago#'
				and afectaPagos = 1
				and	TipoMov = '#This.C_MOV_DEBITO#'
		</cfquery>	
		
		<cfset lavarFechaPago = formatStringToDate("#LSDateFormat(arguments.FechaPago,'dd/mm/yyyy')#")>

		<cfif q_TipoTransaccion.recordcount eq 0>
			<cfthrow errorcode="#This.C_ERROR_TIPO_TRANSACCION#" type="TransaccionException" message = "Tipo de Transaccion [#trim(arguments.tipoTPago)#] No reconocida">
		</cfif>	
		<cfset montoTotal = arguments.Monto>
		<cfset tranID = crearTransaccion(CuentaID=arguments.CuentaID,
								Tipo_TransaccionID = q_TipoTransaccion.id,
								Fecha_Transaccion= lavarFechaPago,
							    Monto = montoTotal,
							    Observaciones = arguments.Observaciones)>

 		<cfset cortes = aPagoMC(
			 		CuentaID = arguments.CuentaID,
					Monto = arguments.Monto,
					MontoDescuento = arguments.MontoDescuento,
					FechaPago = lavarFechaPago,
					FCid = arguments.FCid,
		            ETnumero = arguments.ETnumero,
					transaccionID = tranID,
					debug = arguments.debug
		 )> 

		<cfquery name="rsTran" datasource="#this.DSN#">
			select  Monto ,Descuento 
			from CRCTransaccion
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#this.Ecodigo#">
			and id = <cfqueryparam cfsqltype="cf_sql_numeric" value="#tranID#">
		</cfquery>
		<cfset lvarTotalPago = rsTran.Monto>

		<cfset caMccPorCorteCuenta(cortes= cortes ,CuentaID= arguments.CuentaID, acumularMontoPagado = true)>


		<cfset afectarCuenta(Monto= lvarTotalPago ,
									CuentaID= arguments.CuentaID ,
									CodigoTipoTransaccion= arguments.tipoTPago ,
									TipoMovimiento= q_TipoTransaccion.TipoMov )>



		<cfset ajsuteEstadoCuentaPorPago(CuentaID= arguments.CuentaID)>
			 
	</cffunction>

	<cffunction name="aPagoMC" access="public" hint="pago monto acutal de deuda" returntype="string">
		<cfargument name="CuentaID"   type="numeric" required="true">
		<cfargument name="Monto"      type="numeric" required="true">
		<cfargument name="FechaPago"        required = "true" type="date">
		<cfargument name="transaccionID"	required = "true" type="numeric">
		<cfargument name="MontoDescuento"	required = "false" type="numeric" default = 0>
		<cfargument name="FCid" 			required = "false" type="numeric" default = 0>
		<cfargument name="ETnumero" 		required = "false" type="numeric" default = 0>
		<cfargument name="debug"		required = "false" type="boolean" default = "false">
		<cfargument name="AplicaDescuento"		required = "false" type="boolean" default = "true">

		<!--- variables para controlar saldo del monto pagado y descuento --->
		<cfset lvarSaldoMonto = arguments.Monto>

		<cfset aplicades = 1>
		<cfif not arguments.AplicaDescuento>
			<cfset aplicades = 0>
		</cfif>

		<!--- Se identifica si es un pago que procesa porterior a la fecha del corte correspondiente a la fecha del Pago --->
		<cfset esPagoRetardado = false> 

 		<!-- obtener el componente de corte -->
 		<cfset cCorte = createobject("component", "crc.Componentes.cortes.CRCCortes")>	
		<cfset cCuenta = createobject("component", "crc.Componentes.CRCCuentas")>		

		<cfquery name="rsCuenta" datasource="#this.dsn#">
			select * from CRCCuentas where id = #arguments.CuentaID#
		</cfquery>

<cfif arguments.debug><cfdump var='#rsCuenta#' abort='false' label="Datos de Cuenta"></cfif> 

		<cfset crcObjParametros = createobject("component","crc.Componentes.CRCParametros")>
		<cfset statusConvenio = crcObjParametros.GetParametro(codigo='30100501',conexion=this.dsn,ecodigo=this.ecodigo)>

		<cfquery name="rsOrdenEstatusAct" datasource="#this.dsn#">
			select id, Orden from CRCEstatusCuentas where id = #rsCuenta.CRCEstatusCuentasid#
		</cfquery>
		
		<cfquery name="rsOrdenEstatusParam" datasource="#this.dsn#">
			select id, Orden from CRCEstatusCuentas where id = #statusConvenio#
		</cfquery>

		<!-- buscar cortes con monto a pagar calculado-->
		<cfquery name="qCorteAPagar" datasource="#This.dsn#"> 
			select top 1 Codigo
			from CRCCortes 
			where  status = #This.C_STATUS_MP_CALC#
			and  Tipo = <cfqueryparam value ="#rsCuenta.Tipo#" cfsqltype="cf_sql_varchar"> 
	    </cfquery>

<!--- 		Si no se obtiene un corte en status uno, se busca el primer corte abierto --->
		<cfif qCorteAPagar.recordCount eq 0>
			<cfquery name="qCorteAPagar" datasource="#This.dsn#"> 
				select min(Codigo) Codigo
				from CRCCortes 
				where  status = 0
				and  Tipo = <cfqueryparam value ="#rsCuenta.Tipo#" cfsqltype="cf_sql_varchar"> 
			</cfquery>
		</cfif>

		<cfset This.cortesMP = qCorteAPagar.Codigo>
		
		<cfset lavarFechaPago = formatStringToDate("#LSDateFormat(arguments.FechaPago,'dd/mm/yyyy')#")>
		<cfset CRCCortes = createObject( "component","crc.Componentes.cortes.CRCCortes").init(TipoCorte = '#rsCuenta.Tipo#', conexion=THIS.dsn,ecodigo = this.Ecodigo)>
		<cfset cortePago = CRCCortes.GetCorte(fecha='#arguments.FechaPago#',TipoCorte='#rsCuenta.Tipo#', dsn=THIS.dsn,ecodigo = this.Ecodigo)>
		
		<cfif cortePago eq This.cortesMP >
			<cfset corteAnterior = CRCCortes.AnteriorCorte(corte="#cortePago#", dsn=THIS.dsn,ecodigo = this.Ecodigo)>
			<cfset corteAnteriorSV = CRCCortes.AnteriorCorte(corte="#corteAnterior#", dsn=THIS.dsn,ecodigo = this.Ecodigo)>
			<cfset esPagoRetardado = true> 
			<cfset This.cortesMP = corteAnterior>
		</cfif>
		
<!--- Pasos del pago --->
		<cfquery name="rsrsCtaCorte" datasource="#THIS.dsn#">
			select isnull(Seguro,0) Seguro from CRCMovimientoCuentaCorte
			where Corte = <cfqueryparam value ="#This.cortesMP#" cfsqltype="cf_sql_varchar"> 
				and CRCCuentasid = #arguments.CuentaID#
		</cfquery>

<cfset cortesPagados = "">
<cfset strPagos = structNew()>
<cfset strPagos.Seguro = 0>
<cfset strPagos.Intereses = 0>
<cfset strPagos.InteresesVencidos = 0>
<cfset strPagos.Descuento = 0>
<cfset strPagos.GastoCobranza = 0>
<cfset strPagos.Ventas = 0>
<cfset strPagos.Afavor = 0>

<!--- 1. Se paga seguro si existe --->
<!---	verificamos que el saldo del monto sea mayor igual que el monto de seguro a pagar --->
<!--- se obtienen los Movimientos de Cuentas correspondientes al Seguro que tengan saldo pendiente --->
		<cfif NumberFormat(lvarSaldoMonto,'9.99') gt 0 >
			<cfquery name="rsMovCtasSeguroPagar" datasource="#this.dsn#">
				select  c.id, round(c.MontoAPagar - c.Pagado - c.Descuento,2) MontoRequerido,
					c.MontoAPagar, c.Pagado,
					i.Intereses 
				from CRCMovimientoCuenta c 
				inner join CRCTransaccion t on t.id = c.CRCTransaccionid 
				inner join (
					select c.CRCTransaccionid, sum(Intereses) Intereses
					from CRCMovimientoCuenta c 
					where c.Corte <= <cfqueryparam value ="#This.cortesMP#" cfsqltype="cf_sql_varchar">
					group by c.CRCTransaccionid
				) i on t.id = i.CRCTransaccionid
				where c.Corte = <cfqueryparam value ="#This.cortesMP#" cfsqltype="cf_sql_varchar"> 
				and t.CRCCuentasid = #arguments.CuentaID#
				and t.afectaSeguro = 1
				and c.MontoAPagar > c.Pagado
				order by c.id
			</cfquery>
<cfif arguments.debug><cfdump var="#lvarSaldoMonto#"><cfdump var='#rsMovCtasSeguroPagar#' abort='false' label="Pago Seguro"></cfif> 

		<!--- por cada movimiento cuenta al Corte --->
			<cfloop query="rsMovCtasSeguroPagar">
				<cfset varMontoRequerido = NumberFormat(rsMovCtasSeguroPagar.MontoRequerido,'9.99')>
				<cfset varMontoInteres = NumberFormat(rsMovCtasSeguroPagar.Intereses,'9.99')>
			<!---	verificamos que el saldo del monto sea mayor igual que el monto de requerido a pagar --->
				<cfif NumberFormat(lvarSaldoMonto,'9.99') gte varMontoRequerido>
					<cfset lvarPagado = varMontoRequerido>
				<cfelse>
					<cfset lvarPagado = NumberFormat(lvarSaldoMonto,'9.99')>
				</cfif>
				
				<cfset lvarSaldoMonto   = lvarSaldoMonto-lvarPagado>

				<cfquery datasource="#this.dsn#">
					update c
						set c.Pagado += #NumberFormat(lvarPagado,'9.99')#
					from CRCMovimientoCuenta c 						
					where c.id = #rsMovCtasSeguroPagar.id#
				</cfquery>
				<!--- <cfset varInteres = (varMontoInteres*varMontoRequerido)/lvarPagado> --->
				<cfset strPagos.Seguro += lvarPagado <!--- - varInteres--->>
				<!--- <cfset strPagos.Intereses += varInteres> --->
				<cfif NumberFormat(lvarSaldoMonto,'9.99') lte 0 >
					<cfbreak>
				</cfif>

			</cfloop>
		</cfif>		

		<cfset cortesPagados = listAppend(cortesPagados,This.cortesMP)>

		<cfif NumberFormat(lvarSaldoMonto,'9.99') gt 0 >
<!--- 2. Se pagan los gastos de cobranza --->
		<!--- se obtienen los Movimientos de Cuentas correspondientes al corte a Pagar que tengan saldo pendiente --->
			<cfquery name="rsMovCtasMontoPagar" datasource="#this.dsn#">
				select  c.id, round(c.MontoAPagar - c.Pagado,2) MontoRequerido ,
					c.MontoAPagar, c.Pagado,
					i.Intereses 
				from CRCMovimientoCuenta c 
				inner join CRCTransaccion t on t.id = c.CRCTransaccionid 
				inner join (
					select c.CRCTransaccionid, sum(Intereses) Intereses
					from CRCMovimientoCuenta c 
					where c.Corte <= <cfqueryparam value ="#This.cortesMP#" cfsqltype="cf_sql_varchar">
					group by c.CRCTransaccionid
				) i on t.id = i.CRCTransaccionid
				where c.Corte = <cfqueryparam value ="#This.cortesMP#" cfsqltype="cf_sql_varchar"> 
				and t.CRCCuentasid = #arguments.CuentaID#
				and t.afectaGastoCobranza = 1
				and c.MontoAPagar > c.Pagado
				order by c.id
			</cfquery>

<cfif arguments.debug><cfdump var="#lvarSaldoMonto#"><cfdump var='#strPagos#'><cfdump var='#rsMovCtasMontoPagar#' abort='false' label="Gasto Cobranza">	</cfif> 
		<!--- por cada movimiento cuenta al Corte --->
			<cfloop query="rsMovCtasMontoPagar">
				<cfset varMontoRequerido = NumberFormat(rsMovCtasMontoPagar.MontoRequerido,'9.99')>
				<cfset varMontoInteres = NumberFormat(rsMovCtasMontoPagar.Intereses,'9.99')>
			<!---	verificamos que el saldo del monto sea mayor igual que el monto de requerido a pagar --->
				<cfif NumberFormat(lvarSaldoMonto,'9.99') gte varMontoRequerido>
					<cfset lvarPagado = varMontoRequerido>
				<cfelse>
					<cfset lvarPagado = NumberFormat(lvarSaldoMonto,'9.99')>
				</cfif>
				<cfset lvarSaldoMonto = NumberFormat(lvarSaldoMonto,'9.99') - NumberFormat(lvarPagado,'9.99')>

				<cfquery datasource="#this.dsn#">
					update c
						set c.Pagado += #NumberFormat(lvarPagado,'9.99')#
					from CRCMovimientoCuenta c 						
					where c.id = #rsMovCtasMontoPagar.id#
				</cfquery>
				<!--- <cfset varInteres = (lvarPagado/(varMontoInteres+varMontoRequerido))*varMontoInteres> --->
				<cfset strPagos.GastoCobranza += lvarPagado <!--- - varInteres ----> >
				<!--- <cfset strPagos.Intereses += varInteres> --->
				<cfif NumberFormat(lvarSaldoMonto,'9.99') lte 0 >
					<cfbreak>
				</cfif>

			</cfloop>
		</cfif>

	<cfif NumberFormat(lvarSaldoMonto,'9.99') gt 0 >
<!--- 3. Se paga Intereses si existe --->
<!-- buscar cortes con monto saldo vencido e intereses -->
			<cfquery name="qCorteASaldoVencido" datasource="#This.dsn#"> 
				select top 1 Codigo
				from CRCCortes 
				where  status = #This.C_STATUS_SV_CALC#
				and  Tipo = <cfqueryparam value ="#rsCuenta.Tipo#" cfsqltype="cf_sql_varchar"> 
			</cfquery>
			<!---	se obtienen los Movimientos de Cuentas correspondientes al corte a Pagar que tengan Intereses generados --->
				<cfquery name="rsIntereses" datasource="#this.dsn#">			
					select 
						t.id, t.CRCCuentasid,
						sum(c.MontoAPagar) MontoAPagar, 
						sum(c.Pagado) +sum(c.Descuento)  Pagado,
						sum(p.Intereses) - sum(p.Condonaciones) Intereses,
						sum(p.Intereses) - sum(p.Condonaciones) - sum(c.Pagado) +sum(c.Descuento) MontoRequerido
					FROM (
							select * from CRCMovimientoCuenta
							<cfif rsCuenta.Tipo eq 'TM'>
								where Corte in (
										select Codigo from CRCCortes
										where Tipo = 'TM'
										and Codigo like '%-#rsCuenta.SNegociosSNid#'
											and getdate() between FechaInicioSV and dateadd(day, 1, FechaFinSV)
									)
								</cfif>
						) c
					INNER JOIN CRCTransaccion t ON t.id = c.CRCTransaccionid
					inner join (
						select 
							t.id, t.CRCCuentasid,
							<cfif esPagoRetardado>
								0
							<cfelse>
								sum(c.Intereses)  
							</cfif> Intereses,
							sum(c.Condonaciones) Condonaciones, 
							sum(c.Pagado) Pagado, 
							sum(c.Descuento) Descuento
						FROM CRCMovimientoCuenta c
						INNER JOIN CRCTransaccion t ON t.id = c.CRCTransaccionid
						<cfif rsCuenta.Tipo eq 'TM'>
							where c.Corte in (
									select Codigo from CRCCortes
									where Tipo = 'TM'
									and Codigo like '%-#rsCuenta.SNegociosSNid#'
										and getdate() between FechaInicioSV and dateadd(day, 1, FechaFinSV)
								)
						<cfelse>
							WHERE c.Corte = <cfqueryparam value ="#qCorteASaldoVencido.Codigo#" cfsqltype="cf_sql_varchar">
						</cfif>
						group by t.id, t.CRCCuentasid
					) p on t.id = p.id and t.CRCCuentasid = p.CRCCuentasid
					<cfif rsCuenta.Tipo eq 'TM'>
						where 1 = 1
					<cfelse>
						WHERE c.Corte = <cfqueryparam value ="#This.cortesMP#" cfsqltype="cf_sql_varchar">
					</cfif>
						AND t.CRCCuentasid = #arguments.CuentaID#
					group by t.id, t.CRCCuentasid
					having sum(c.Pagado) +sum(c.Descuento)  < sum(p.Intereses) - sum(p.Condonaciones) 
				</cfquery>
<cfif arguments.debug><cfdump var="#lvarSaldoMonto#"><cfdump var='#strPagos#'><cfdump var='#rsIntereses#' abort='false' label="Pago Intereses">	 </cfif>
			<!--- 	por cada movimiento cuenta con intereses generados --->
				<cfloop query="rsIntereses">
				<!---	verificamos que el saldo del monto sea mayor igual que el monto de Intereses a pagar --->
					<cfif NumberFormat(lvarSaldoMonto,'9.99') gte rsIntereses.MontoRequerido >
						<cfset lvarInteres = rsIntereses.MontoRequerido>
					<cfelse>
						<cfset lvarInteres = NumberFormat(lvarSaldoMonto,'9.99')>
					</cfif>

					<cfquery datasource="#this.dsn#" name="rsPago">
						update c 
							set c.Pagado += #NumberFormat(lvarInteres,'9.99')#
						from CRCMovimientoCuenta c 						
						where c.CRCTransaccionid = #rsIntereses.id#
						<cfif rsCuenta.Tipo eq 'TM'>
							and c.id = (
								select max(id) id from CRCMovimientoCuenta
								where CRCTransaccionid = #rsIntereses.id#
							)
						<cfelse>
							and c.Corte = <cfqueryparam value ="#this.cortesMP#" cfsqltype="cf_sql_varchar">
						</cfif>
					</cfquery>

					<cfset strPagos.Intereses = strPagos.Intereses + lvarInteres>
					<cfset lvarSaldoMonto = lvarSaldoMonto - lvarInteres>

					<cfif NumberFormat(lvarSaldoMonto,'9.99') lte 0 >
						<cfbreak>
					</cfif>
					
				</cfloop>
		
		</cfif>

	<cfif NumberFormat(lvarSaldoMonto,'9.99') gt 0 >
<!--- 4. Se paga Saldo Vencido si existe --->
<!--- por cada movimiento cuenta con Saldo Vencido generados --->
			<cfquery name="rsMovCtasSaldoVencido" datasource="#this.dsn#">
				SELECT t.id, t.FechaInicioPago,
					t.CRCCuentasid,
					sum(c.Pagado) + sum(c.Descuento) Pagado,
					sum(p.MontoAPagar) MontoAPagar,
					sum(p.Condonaciones) Condonaciones,
					case when sum(p.SaldoVencido) -  ((sum(c.Pagado) + sum(c.Descuento) +sum(p.Condonaciones)) - sum(p.Intereses)) < 0 then 0
						else sum(p.SaldoVencido) -  ((sum(c.Pagado) + sum(c.Descuento) +sum(p.Condonaciones)) - sum(p.Intereses))
					end MontoRequerido
				FROM (
						select mc.* from CRCMovimientoCuenta mc inner join  CRCTransaccion t ON t.id = mc.CRCTransaccionid 
						where t.CRCCuentasid = #arguments.CuentaID# 
						<cfif esPagoRetardado and  rsCuenta.Tipo neq 'TM'>
							and mc.Corte = '#corteAnteriorSV#'
						</cfif>
						<cfif rsCuenta.Tipo eq 'TM'>
							and Corte in (
									select Codigo from CRCCortes
									where Tipo = 'TM'
									and Codigo like '%-#rsCuenta.SNegociosSNid#'
										and getdate() between FechaInicioSV and dateadd(day, 1, FechaFinSV)
								)
						</cfif>
						) c
				INNER JOIN CRCTransaccion t ON t.id = c.CRCTransaccionid
				INNER JOIN
				(SELECT t.id,
						t.CRCCuentasid,
						sum(c.MontoAPagar) MontoAPagar,
						sum(c.Condonaciones) Condonaciones,
						<cfif esPagoRetardado>
							0
						<cfelse>
							sum(c.SaldoVencido)  
						</cfif>SaldoVencido,
						<cfif esPagoRetardado>
							0
						<cfelse>
							sum(c.Intereses)  
						</cfif>Intereses
				FROM CRCMovimientoCuenta c
				INNER JOIN CRCTransaccion t ON t.id = c.CRCTransaccionid
				<cfif rsCuenta.Tipo eq 'TM'>
					where c.Corte in (
							select Codigo from CRCCortes
							where Tipo = 'TM'
							and Codigo like '%-#rsCuenta.SNegociosSNid#'
								and getdate() between FechaInicioSV and dateadd(day, 1, FechaFinSV)
						)
				<cfelse>
					<cfif esPagoRetardado >
						where c.Corte = '#corteAnteriorSV#'
					<cfelse>
						WHERE c.Corte = <cfqueryparam value ="#qCorteASaldoVencido.Codigo#" cfsqltype="cf_sql_varchar">
					</cfif>
				</cfif>
				GROUP BY t.id,
				t.CRCCuentasid
				) p ON t.id = p.id
				AND t.CRCCuentasid = p.CRCCuentasid
				<cfif rsCuenta.Tipo eq 'TM'>
					where 1 = 1
				<cfelse>
					WHERE c.Corte = <cfqueryparam value ="#This.cortesMP#" cfsqltype="cf_sql_varchar">
				</cfif>
				AND t.CRCCuentasid = #arguments.CuentaID#
				GROUP BY t.id, t.FechaInicioPago,
						t.CRCCuentasid
				HAVING sum(p.SaldoVencido) -  ((sum(c.Pagado) + sum(c.Descuento) +sum(p.Condonaciones)) - sum(p.Intereses)) > 0
					<!--- sum(c.Pagado) +sum(c.Descuento) < sum(p.MontoAPagar) --->
				order by t.FechaInicioPago
			</cfquery>

<cfif arguments.debug><cfdump var="#lvarSaldoMonto#"><cfdump var='#strPagos#'><cfdump var='#rsMovCtasSaldoVencido#' abort='false' label="Pago Saldo Vencido"> </cfif> 
			<cfloop query="rsMovCtasSaldoVencido">
			<!---	verificamos que el saldo del monto sea mayor igual que el monto de vencido a pagar --->

				<cfif rsCuenta.Tipo eq 'TM'>
					<cfif NumberFormat(lvarSaldoMonto,'9.99') gte rsMovCtasSaldoVencido.MontoAPagar>
						<cfset lvarSaldoVencido = rsMovCtasSaldoVencido.MontoAPagar>
					<cfelse>
						<cfset lvarSaldoVencido = NumberFormat(lvarSaldoMonto,'9.99')>
					</cfif>
				<cfelse>
					<cfif NumberFormat(lvarSaldoMonto,'9.99') gte rsMovCtasSaldoVencido.MontoRequerido>
						<cfset lvarSaldoVencido = rsMovCtasSaldoVencido.MontoRequerido>
					<cfelse>
						<cfset lvarSaldoVencido = NumberFormat(lvarSaldoMonto,'9.99')>
					</cfif>
				</cfif>
				
				
				<cfset lvarSaldoMonto = NumberFormat(lvarSaldoMonto - lvarSaldoVencido,'9.99')>
				<cfquery datasource="#this.dsn#" name="rsPago">
					update c 
						set c.Pagado += #NumberFormat(lvarSaldoVencido,'9.99')# 
					from CRCMovimientoCuenta c 						
					where c.CRCTransaccionid = #rsMovCtasSaldoVencido.id#
					<cfif rsCuenta.Tipo eq 'TM'>
						and c.id = (
								select max(id) id from CRCMovimientoCuenta
								where CRCTransaccionid = #rsMovCtasSaldoVencido.id#
							)
					<cfelse>
						and c.Corte = <cfqueryparam value ="#this.cortesMP#" cfsqltype="cf_sql_varchar">
					</cfif>
				</cfquery>
				
				<cfset strPagos.Ventas += lvarSaldoVencido>

				<cfif NumberFormat(lvarSaldoMonto,'9.99') lte 0 >
					<cfbreak>
				</cfif>
			</cfloop>

<!--- 			Se restan los intereses vencidos --->
			<cfset strPagos.Ventas -= strPagos.InteresesVencidos>
		</cfif>
		<cfif NumberFormat(lvarSaldoMonto,'9.99') gt 0 >
<!--- 5. Se pagan Montos requeridos del corte --->
			<cfset porDesc = 0>
			<cfif trim(rsCuenta.Tipo) eq "#this.C_TP_DISTRIBUIDOR#" and rsOrdenEstatusAct.Orden lt rsOrdenEstatusParam.Orden>
				<cfquery name="q_codCortePago" datasource="#this.dsn#">
					select top 1 *
					from CRCCortes ct
					where #arguments.FechaPago# between FechaInicio and dateadd(day, 1, FechaFin)
						and Tipo = 'D'
				</cfquery>
				<cfset porDesc = cCuenta.getPorcientoDescuento(arguments.FechaPago,rsCuenta.CRCCategoriaDistid,"#q_codCortePago.codigo#")>
			</cfif>
		<!--- se obtienen los Movimientos de Cuentas correspondientes al corte a Pagar que tengan saldo pendiente --->
			<cfquery name="rsMovCtasMontoPagar" datasource="#this.dsn#">
				select  c.id, round(case when c.MontoAPagar > c.MontoRequerido then c.MontoAPagar else c.MontoRequerido end - c.Pagado - c.Descuento,2) MontoRequerido from CRCMovimientoCuenta c 
				inner join CRCTransaccion t on t.id = c.CRCTransaccionid 
				where c.Corte = <cfqueryparam value ="#This.cortesMP#" cfsqltype="cf_sql_varchar"> 
				and t.CRCCuentasid = #arguments.CuentaID#
				and case when c.MontoAPagar > c.MontoRequerido then c.MontoAPagar else c.MontoRequerido end > c.Pagado + c.Descuento
				order by t.FechaInicioPago, c.id
			</cfquery>

<cfif arguments.debug><cfdump var="#lvarSaldoMonto#"><cfdump var='#strPagos#'><cfdump var='#rsMovCtasMontoPagar#' abort='false' label="Monto requerido"></cfif>
		<!--- por cada movimiento cuenta al Corte --->
			<cfloop query="rsMovCtasMontoPagar">
				<cfset varMontoRequerido = NumberFormat(rsMovCtasMontoPagar.MontoRequerido,'9.99')>
			<!---	verificamos que el saldo del monto sea mayor igual que el monto de requerido a pagar --->
				<cfset lvarDescuento = calculaDescuentoSaldo(monto=varMontoRequerido, porciento=porDesc)  * aplicades>
				<cfif NumberFormat(lvarSaldoMonto,'9.99') + NumberFormat(lvarDescuento,'9.99') gte varMontoRequerido>
					<cfset lvarPagado = varMontoRequerido - lvarDescuento>
				<cfelse>
					<cfset lvarDescuento = calculaDescuento(monto=NumberFormat(lvarSaldoMonto,'9.99'), porciento=porDesc) * aplicades>
					<cfset lvarPagado = NumberFormat(lvarSaldoMonto,'9.99')>
				</cfif>
		
				<cfset lvarSaldoMonto = lvarSaldoMonto - lvarPagado>

				<cfquery datasource="#this.dsn#">
					update c
						set c.Pagado += #NumberFormat(lvarPagado,'9.99')#,
							c.Descuento += #NumberFormat(lvarDescuento,'9.99')#,
							c.Intereses = 0 <!--- Se cancelan los intereses--->
					from CRCMovimientoCuenta c 						
					where c.id = #rsMovCtasMontoPagar.id#
				</cfquery>

				<cfset strPagos.Ventas += lvarPagado>
				<cfset strPagos.Descuento += lvarDescuento>
				
				<cfif NumberFormat(lvarSaldoMonto,'9.99') + NumberFormat(lvarDescuento,'9.99') lte 0 >
					<cfbreak>
				</cfif>

			</cfloop>
		</cfif>

		<cfif NumberFormat(lvarSaldoMonto,'9.999') gt 0.009 >
<!--- 6. Si queda disponible, se pagan montos a futuro--->
			<cfset porcDesFuturo = 0>
			<cfif trim(rsCuenta.Tipo) eq "#this.C_TP_DISTRIBUIDOR#" and rsOrdenEstatusAct.Orden lt rsOrdenEstatusParam.Orden>
				<cfquery name="rsCategoria" datasource="#this.DSN#">
					select DescuentoInicial , PenalizacionDia
					from CRCCategoriaDist where Ecodigo = #this.Ecodigo# and id = #rsCuenta.CRCCategoriaDistid#
				</cfquery>
				<cfset porcDesFuturo = rsCategoria.DescuentoInicial>
			</cfif>
		
		<!---	se obtienen los Movimientos de Cuentas correspondientes de cortes a futuro que tengan saldo pendiente --->
			<cfquery name="rsMovCtasMontoPagarFuturo" datasource="#this.dsn#">
				select  c.id, round(c.MontoRequerido - c.Pagado - c.Descuento,2) MontoRequerido 
				from CRCMovimientoCuenta c 
				inner join CRCTransaccion t on t.id = c.CRCTransaccionid 
				where c.Corte > <cfqueryparam value ="#This.cortesMP#" cfsqltype="cf_sql_varchar"> 
				and t.CRCCuentasid = #arguments.CuentaID#
				and c.MontoRequerido > 0
				and c.MontoRequerido > c.Pagado + c.Descuento
				order by t.FechaInicioPago, c.id
			</cfquery>

<cfif arguments.debug><cfdump var="#lvarSaldoMonto#"><cfdump var='#strPagos#'><cfdump var='#rsMovCtasMontoPagarFuturo#' abort='false' label="Pago Futuro">	 </cfif>
			<cfquery name="rsCortesPagarFuturo" datasource="#this.dsn#">
				select  distinct c.Corte , c.Pagado
				from CRCMovimientoCuenta c 
				inner join CRCTransaccion t on t.id = c.CRCTransaccionid 
				where c.Corte > <cfqueryparam value ="#This.cortesMP#" cfsqltype="cf_sql_varchar"> 
				and t.CRCCuentasid = #arguments.CuentaID#
				and c.MontoRequerido > 0
				and c.MontoRequerido > c.Pagado + c.Descuento
			</cfquery>

			<cfset cortesPagados = listAppend(cortesPagados,ValueList(rsCortesPagarFuturo.Corte))>
		<!--- 		por cada movimiento cuenta con pendiente de pago a futuro --->
			<cfloop query="rsMovCtasMontoPagarFuturo">
			<!---	verificamos que el saldo del monto sea mayor igual que el monto requerido a pagar --->
				<cfset varMontoRequerido = NumberFormat(rsMovCtasMontoPagarFuturo.MontoRequerido,'9.99')>
				<cfset lvarDescuento = calculaDescuentoSaldo(monto=varMontoRequerido, porciento=porcDesFuturo) * aplicades>
				<cfif NumberFormat(lvarSaldoMonto,'9.99') + lvarDescuento gte varMontoRequerido>
					<cfset lvarPagado = varMontoRequerido - lvarDescuento>
				<cfelse>
					<cfset lvarDescuento = calculaDescuento(monto=NumberFormat(lvarSaldoMonto,'9.99'), porciento=porcDesFuturo) * aplicades>
					<cfset lvarPagado = NumberFormat(lvarSaldoMonto,'9.99')>
				</cfif>
				<cfset lvarSaldoMonto = NumberFormat(lvarSaldoMonto - lvarPagado,'9.99')>

				<cfquery datasource="#this.dsn#">
					update c
						set c.Pagado += #NumberFormat(lvarPagado,'9.99')#,
							c.Descuento += #NumberFormat(lvarDescuento,'9.99')#
					from CRCMovimientoCuenta c 						
					where c.id = #rsMovCtasMontoPagarFuturo.id#
				</cfquery>

				<cfset strPagos.Ventas += lvarPagado>
				<cfset strPagos.Descuento += lvarDescuento>

				<cfif NumberFormat(lvarSaldoMonto,'9.99') lte 0 >
					<cfbreak>
				</cfif>
			</cfloop>
			
		</cfif>

<cfif arguments.debug><cfdump var='#NumberFormat(lvarSaldoMonto,'9.99')#' abort='false' label="Saldo">	 </cfif>
		<cfif NumberFormat(lvarSaldoMonto,'9.999') gt 0.009 >
<!--- 7. si queda saldo en el monto pagago, se debe poner como saldo a favor...  --->
		<!---	se obtienen los Movimientos de Cuentas correspondientes de cortes a futuro que tengan saldo pendiente --->
			<cfquery datasource="#this.dsn#">
				update CRCcuentas set saldoAFavor = isnull(saldoAFavor,0) + #NumberFormat(lvarSaldoMonto,'9.99')#
				where id = #arguments.CuentaID#
			</cfquery>
			<cfset strPagos.Afavor = lvarSaldoMonto>
		</cfif>
		
<cfif arguments.debug><cfdump var='#strPagos#' abort='false'></cfif>

		<cfquery datasource="#this.dsn#">
			insert into #request.crcdesglose#
				(CUENTAID,DESCUENTO,GASTOCOBRANZA,INTERESES,SEGURO,VENTAS,AFAVOR)
			values(
				#arguments.CuentaID#,
				round(cast(#NumberFormat(strPagos.Descuento,'9.0000')# as money),2),
				round(cast(#NumberFormat(strPagos.GastoCobranza,'9.0000')# as money),2),
				round(cast(#NumberFormat(strPagos.Intereses + strPagos.InteresesVencidos,'9.0000')# as money),2),
				round(cast(#NumberFormat(strPagos.Seguro,'9.0000')# as money),2),
				round(cast(#NumberFormat(strPagos.Ventas,'9.0000')# as money),2),
				round(cast(#NumberFormat(strPagos.Afavor,'9.0000')# as money),2)
			)
		</cfquery>
		
<cfif arguments.debug><cf_dumptable var='#request.crcdesglose#' abort='true'></cfif>
	
		<cfquery name="rsActualizaDescuento" datasource="#this.DSN#">
			update DTransacciones set DTdeslinea = #NumberFormat(strPagos.Descuento,'9.99')#
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#this.Ecodigo#">
			and FCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.FCid#">
			and ETnumero = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.ETnumero#">
			and DTborrado = 0
		</cfquery>

		<cfquery datasource="#this.DSN#">
			update CRCTransaccion 
			set Monto = #NumberFormat(arguments.Monto,'9.99')# + #NumberFormat(strPagos.Descuento,'9.99')#,
				Descuento = #NumberFormat(strPagos.Descuento,'9.99')#,
				ETnumero = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.ETnumero#">
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#this.Ecodigo#">
			and id = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.transaccionID#">
		</cfquery>

		<cfif rsCuenta.Tipo eq 'TM'>
			<cfquery name="rsCortesTM" datasource="#this.dsn#">
				select  c.Codigo 
				from CRCMovimientoCuentaCorte mcc 
				inner join CRCCortes c
					on mcc.Corte = c.Codigo
				where mcc.CRCCuentasid = #arguments.CuentaID#
					and datediff(day,getdate(),c.FechaFin) > 0 
			</cfquery>
			<cfset cortesPagados = listAppend(cortesPagados,ValueList(rsCortesTM.Codigo))>
		</cfif>
		
		<cfif esPagoRetardado>
			<cfinvoke component="crc.Componentes.cortes.CRCReProcesoCorte"  method="reProcesarCorte" cuentaID="#arguments.CuentaID#">
		</cfif>
		
		<cfreturn cortesPagados>	

	</cffunction>

	<cffunction name="calculaDescuento" returntype="numeric">
		<cfargument name="monto" type="numeric" required="true" >
		<cfargument name="porciento" type="numeric" required="true" >
		<cfset rDescuento = arguments.monto * 100/(100- arguments.porciento)-arguments.monto>
		
		<cfreturn rDescuento>
	</cffunction>

	<cffunction name="calculaDescuentoSaldo" returntype="numeric">
		<cfargument name="monto" type="numeric" required="true" >
		<cfargument name="porciento" type="numeric" required="true" >
		<cfset rDescuento = arguments.monto * arguments.porciento /100>
		
		<cfreturn rDescuento>
	</cffunction>


	<cffunction name="ajsuteEstadoCuentaPorPago" returntype="void" access="public" hint="Si el pago cubre el monto del saldo vencido más los intereses, se regresa el estado de la cuenta a activa siempre y cuando el estado actual sea menor o igual al límite de movimiento automático.">
		<cfargument name="CuentaID" type="numeric" required="true" >

		<cfquery name="qMenorOrden" datasource="#This.dsn#">
			select TOP 1 ID from CRCEstatusCuentas order by Orden asc 
		</cfquery>

		<cfset loc.estadoActivoID =  #qMenorOrden.id#>

		<cfquery name="QRESULADO" datasource="#This.DSN#">
		    update c
		    set c.CRCEstatusCuentasid = #loc.estadoActivoID#,
				c.DatosEmpleadoDEid = null,
				c.DatosEmpleadoDEid2 = null,
				c.FechaGestor = null,
				c.FechaAbogado = null
		    from CRCCuentas c
			INNER JOIN CRCEstatusCuentas ec
			ON c.CRCEstatusCuentasid = ec.id
			inner join ( select mcc.CRCCuentasid, isnull(sum(mcc.MontoRequerido),0) MontoRequerido, 
				                isnull(sum(mcc.MontoAPagar),0) MontoAPagar,
								isnull(sum(mcc.MontoPagado),0) MontoPagado
						 from CRCMovimientoCuentaCorte mcc
						 where mcc.Corte in (select top 1 Codigo
											from CRCCortes 
											where  status = #This.C_STATUS_MP_CALC#
											and  Tipo = <cfqueryparam value ="#rsCuenta.Tipo#" cfsqltype="cf_sql_varchar"> )
						 and mcc.CRCCuentasid = #arguments.CuentaID#
						 group by mcc.CRCCuentasid
						) mcc1
		   on c.id = mcc1.CRCCuentasid
		   where c.id = #arguments.CuentaID#
		   and   ec.Orden <= #This.pLimiteCambioEstadoCuenta#
		   and mcc1.MontoRequerido >= (mcc1.MontoAPagar - mcc1.MontoPagado)

		</cfquery>
 

	</cffunction>

	<cffunction  name="Create_CRCDESGLOSE">
		<cf_dbtemp name="CRC_DESGLOSE" returnvariable="CRC_DESGLOSE" datasource="#this.dsn#">
			<cf_dbtempcol name="CUENTAID"       type="numeric"      mandatory="yes">
			<cf_dbtempcol name="DESCUENTO"      type="money"        mandatory="yes">
			<cf_dbtempcol name="GASTOCOBRANZA"  type="money"        mandatory="yes">
			<cf_dbtempcol name="INTERESES"     type="money"        mandatory="yes">
			<cf_dbtempcol name="SEGURO"         type="money"        mandatory="yes">
			<cf_dbtempcol name="VENTAS"         type="money"        mandatory="yes">
			<cf_dbtempcol name="AFAVOR"         type="money"        mandatory="yes">
			<cf_dbtempkey cols="CUENTAID">
		</cf_dbtemp>

		<cfset request.crcdesglose = CRC_DESGLOSE>
	</cffunction>


</cfcomponent>