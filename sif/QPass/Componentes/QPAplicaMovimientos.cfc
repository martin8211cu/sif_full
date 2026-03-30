<cfcomponent output="no">
	<!--- 
	********************************************************************************************
	APLICACION DE PAGOS A LOS MOVIMIENTOS DE CONSUMOS:
		PAGOS O INTENTOS DE COBRO = movimientos positivos = Bloqueos o Recargas
		MOVIMIENTOS DE CONSUMOS   = movimientos negativos
	Los movimientos de ajuste positivos se consideran pagos (aunque sean ajustes de consumo)
	Los movimientos de ajuste negativos se consideran consumos (aunque sean bloqueos o recargas)
	********************************************************************************************
		- La tarea se invoca desde un ciclo a partir del último IdTag procesado en la iteración anterior. 
		- Sólo se procesan los movimientos que no hayan sido aplicados por completo (con saldo de aplicación diferente de CERO), o sea, 
		  que todavía puedan pagar (positivos con saldo > 0) o consumos que no han sido saldados (negativos con saldo < 0)
		- Los movimientos se procesan en orden cronológico por fecha de afectación de saldos, con el objetivo de seguir el mismo orden 
		  cronológico con que se procesaron los movimientos en la afectación de saldos 
		- No se van a procesar movimientos que no tengan movimientos de signo contrario.  Es decir, pagos sin un solo consumo, o bien, 
		  consumos sin un solo pago.  Estos casos sólo son correctos en la Venta de Tags, mientras se registra el pago.
		1) Proceso de POST PAGO: 
			- Aplicar movimientos positivos únicamente a movimientos negativos de la misma causa de un mismo tag y de una misma cuenta de saldos. 
			  No se mezclan unas causas con otras. 
			- La fecha contable de aplicación es la fecha del movimiento positivo (QPMCFInclusion), o sea, la fecha de bloqueo enviada por el banco 
		2) Proceso de PRE PAGO: 
			- Aplicar cualquier movimiento positivo a cualquier movimiento negativo de un mismo tag y de una misma cuenta de saldos sin importar su causa. 
			  Se mezclan las causas. 
			- Los movimientos negativos pendientes que no tengan movimiento positivo con saldo deben generar incobrable.  Por convención, el incobrable 
			  se asigna al último movimiento positivo con saldo=0. 
			- La fecha contable de aplicación es la mayor fecha de afectación de saldos (QPMCFAfectacion) entre el movimiento positivo y negativo: 
			  a) Si la fecha de afectación del movimiento negativo es mayor es porque se está cobrando un Movimiento de Uso con una Recarga anterior.  
				 En este caso, si el saldo del movimiento positivo no alcanza para aplicar todo el saldo del movimiento negativo, se genera incobrable 
				 únicamente si el "siguiente movimiento positivo" es posterior (si el siguiente movimiento positivo es anterior, sigue siendo prepago 
				 y por tanto el actual no debe generar incobrable), es decir, sólo se va a generar incobrable en el "último movimiento positivo anterior" 
				 que no alcance para pagar el movimiento negativo. Por tanto, se usa la fecha del Movimiento de Uso o Consumo. 
			  b) Si la fecha de afectación del movimiento positivo es mayor es porque el Movimiento de Uso ya tuvo un incobrable y ahora se está reintentando 
				 pagar el saldo con una Recarga Posterior. En este caso, si el saldo del movimiento positivo no alcanza siempre se registra incobrable. 
				 Por tanto, se usa la fecha de la Recarga o Pago. 
		
		Por cada Tag:
			Por cada Movimiento Positivo se aplica su saldo (SaldoDisponible = MovPos.SaldoMov) a cada Movimiento Negativo que tenga saldo (MontoAplicar = MovNeg.SaldoMov)
			Si SaldoDisponible > MontoAplicar entonces
				MontoBloqueado  = MontoAplicar
				MontoIncobrable = 0
			sino
				MontoBloqueado = SaldoDisponible
				Si esPostPago AND (MovimientoPositivo PostPagoAl MovimientoNegativo)
					-- Si esPostPago hay incobrable solo si el pago es posterior
					MontoIncobrable = MontoAplicar - MontoBloqueado
				Si esPrePago  AND NOT (SiguienteMovimientoPositivo PrePagoAl MovimientoNegativo) 
					-- Si esPrePago hay incobrable solo si el pago es el ultimo anterior.  
					-- Si el siguiente pago tambien es anterior este pago no es el último anterior y por tanto no le toca generar incobrable
					MontoIncobrable = MontoAplicar - MontoBloqueado
				sino
					MontoIncobrable = 0
			Si MontoBloqueado <> 0 OR MontoIncobrable <> 0
				Se registra la Aplicacion y se actualizan los saldos positivo y negativo con MontoBloqueado
	--->
	<cffunction name="AplicaMovimientos" access="public" returntype="numeric" output="yes">
		<cfargument name="Conexion" type="string" required="yes">
		<cfargument name="QPTidTag" type="string" default="1">

		<cfsetting requesttimeout="36000" enableCFoutputOnly="yes">
        <cfapplication name="SIF_ASP" 
            sessionmanagement="Yes"
            clientmanagement="No"
            setclientcookies="Yes"
            sessiontimeout=#CreateTimeSpan(0,10,0,0)#>

		<cfset LvarFechaMaxima  = dateadd("s",840,now())>
		

		<cflock scope="application" timeout="5" type="exclusive">
			<cfif isdefined("Application.QPAplicaMovimiento") and Application.QPAplicaMovimiento EQ 1>
				<cfset LvarFechaControla = Application.QPFechaAplicaMovimiento>
				<cfset LvarFechaControla = dateadd("s",910,LvarFechaControla)>
        		<cfif LvarFechaControla GT now()>
					<cfreturn false>
				</cfif>
			</cfif>
			<cfset Application.QPFechaAplicaMovimiento = now()>
			<cfset Application.QPAplicaMovimiento = 1>
		</cflock>

		<cfquery name="rsSQL" datasource="#Arguments.Conexion#">
			select count(1) as cantidad from QPMovCuentaAplicacion
		</cfquery>
		<cfset LvarPrimeraVez = rsSQL.cantidad EQ 0>


		<!--- 
			Movimientos positivos son cuando:
				Movimiento no procesado:	
					QPMCSaldoMovLoc IS NULL		saldo no se ha llenado
					QPMCMontoLoc	>= 0		saldo inicial es MontoLoc e incluye los que son 0
				Movimiento ya procesado:
					QPMCSaldoMovLoc	> 0			saldo no ha llegado a 0
				EN RESUMEN:
					coalesce(QPMCSaldoMovLoc, QPMCMontoLoc + 0.001) > 0
					unicamente los procesados = QPMCMontoLoc is not null
					cuando QPMCMontoLoc = 0 entonces QPMCMontoLoc + 0.001 > 0
		--->
		<cfflush interval="512">
		<cfset javaRT = createobject("java","java.lang.Runtime").getRuntime()>
		<cfset javaRT.gc()>
		<cfset LvarTagN = 400>

		<!--- 	
				PostPago:	Movimientos Positivos con saldo que tengan movimientos negativos anteriores con saldo
				PrePago:	Movimientos Negativos con saldo aunque no tengan movimientos positivos con que pagar
		--->
		<cfquery name="rsTags" datasource="#Arguments.Conexion#" maxrows="#LvarTagN#">
			select 	DISTINCT TOP #LvarTagN#
				pos.QPTidTag, pos.QPctaSaldosid, s.QPctaSaldosTipo as tipo
			  from QPMovCuenta pos
				inner join QPcuentaSaldos s
					on s.QPctaSaldosid = pos.QPctaSaldosid
			 where QPTidTag > #Arguments.QPTidTag#
			   and coalesce(QPMCSaldoMovLoc, QPMCMontoLoc + 0.001) > 0
			   and QPMCMontoLoc is not null
			   and s.QPctaSaldosTipo = 1
			   and 
			   	(
					select count(1)
					  from QPMovCuenta neg
					 where QPTidTag	= pos.QPTidTag AND QPctaSaldosid = pos.QPctaSaldosid
					   and QPCid	= pos.QPCid 
					   and QPMCFInclusion < pos.QPMCFInclusion
					   and coalesce(QPMCSaldoMovLoc, QPMCMontoLoc) < 0
					   and QPMCMontoLoc is not null
				) > 0
			UNION
			select 	DISTINCT TOP #LvarTagN#
				neg.QPTidTag, neg.QPctaSaldosid, s.QPctaSaldosTipo as tipo
			  from QPMovCuenta neg
				inner join QPcuentaSaldos s
					on s.QPctaSaldosid = neg.QPctaSaldosid
			 where QPTidTag > #Arguments.QPTidTag#
			   and coalesce(neg.QPMCSaldoMovLoc, neg.QPMCMontoLoc) < 0
			   and neg.QPMCMontoLoc is not null
			   and s.QPctaSaldosTipo <> 1
			   and 	(
						select count(1)
						  from QPMovCuenta pos
						 where QPTidTag = neg.QPTidTag AND QPctaSaldosid = neg.QPctaSaldosid
						   and coalesce(QPMCSaldoMovLoc, QPMCMontoLoc) >= 0		<!--- Saldo = 0 puede ser pos o neg --->
						   and QPMCMontoLoc is not null and QPMCMontoLoc >= 0	<!--- Monto >= 0 es positivo --->
					) > 0
			order by 1,2
		</cfquery>
		<cfif rsTags.recordCount GT 0>
			<cfquery name="rsSQL" dbtype="query">
				select 	min(QPTidTag) as primero, max(QPTidTag) as ultimo from rsTags
			</cfquery>
			<cfif #Arguments.QPTidTag# EQ 0>
				<cfoutput>INICIO PROCESAMIENTO = #now()#<BR></cfoutput>
			</cfif>
			<cfoutput>Procesando #rsTags.recordCount# Tags (del #rsSQL.primero# al #rsSQL.ultimo#)<BR></cfoutput>
			<cfoutput>Tags: </cfoutput>
		<cfelse>
			<cfoutput>FIN PROCESAMIENTO DE TODOS LOS TAGs = #now()#<BR></cfoutput>
		</cfif>
		<cfset LvarQPTidTag		 = 0>
		<cfset LvarQPctaSaldosid = 0>
		<cfloop query="rsTags">
			<cfoutput>#rsTags.QPTidTag#,</cfoutput>
			<cfset LvarQPTidTag		 = rsTags.QPTidTag>
			<cfset LvarQPctaSaldosid = rsTags.QPctaSaldosid>
			<cfset LvarTagTipo		 = rsTags.tipo>

			<!--- Obtiene tipo PostPago / PrePago --->
			<cfset LvarPostPago		= (LvarTagTipo EQ 1)>
			<cfset LvarPrePago		= NOT LvarPostPago>

			<!--- Si es PostPago solo aplico Movimientos de las mismas Causas, se puede sacar diferencial cambiario --->
			<!--- Si es PrePago aplico Movimientos de cualquier Causa solo en colones --->

			<cfif LvarPostPago>
				<!--- Obtiene las diferentes Causas por Tag, porque se aplican Movimientos Positivos únicamente a Movimientos Negativos de la misma Causa --->
				<cfquery name="rsCausasTag" datasource="#Arguments.Conexion#">
					select distinct QPCid
					  from QPMovCuenta pos
					 where QPTidTag = #LvarQPTidTag# AND QPctaSaldosid = #LvarQPctaSaldosid#
					   and coalesce(QPMCSaldoMovLoc, QPMCMontoLoc + 0.001) > 0
					   and QPMCMontoLoc is not null
					   and
						(
							select count(1)
							  from QPMovCuenta neg
							 where QPTidTag = pos.QPTidTag AND QPctaSaldosid = pos.QPctaSaldosid
							   and QPCid	= pos.QPCid
							   and QPMCFInclusion < pos.QPMCFInclusion  
							   and coalesce(QPMCSaldoMovLoc, QPMCMontoLoc) < 0
							   and QPMCMontoLoc is not null
						) > 0
					order by 1
				</cfquery>
			<cfelse>
				<!--- Crea una única Causa para el Tag, porque se aplican Movimientos Positivos a cualquier Causa de Movimientos Negativos --->
				<cfset rsCausasTag = queryNew("QPCid")>
				<cfset queryAddRow(rsCausasTag,1)>
			</cfif>

			<cfloop query="rsCausasTag">
				<cfoutput> </cfoutput>
				<!--- Obtiene Movimientos por Tag, agrupados por Causa QPCid --->
				<cfquery name="rsMovimientosPos" datasource="#Arguments.Conexion#">
					select QPMCid, coalesce(QPMCSaldoMovLoc, QPMCMontoLoc) as QPMCSaldoMovLoc, QPMCFInclusion, QPMCFAfectacion
					  from QPMovCuenta pos
					 where QPTidTag = #LvarQPTidTag# AND QPctaSaldosid = #LvarQPctaSaldosid#
					<cfif LvarPostPago>
					   and QPCid	= #rsCausasTag.QPCid#
					</cfif>
					   and coalesce(QPMCSaldoMovLoc, QPMCMontoLoc + 0.001) > 0
					   and QPMCMontoLoc is not null
					 order by QPMCFAfectacion, QPMCFInclusion, QPMCid
				</cfquery>
				<cfset LvarPrePagoSinMovPos = false>
				<cfif LvarPrePago AND rsMovimientosPos.recordCount EQ 0>
					<!--- Si no hay positivos con saldo, escoge el ultimo movPos con Saldo=0 --->
					<cfset LvarPrePagoSinMovPos = true>
					<cfquery name="rsMovimientosPos" datasource="#Arguments.Conexion#">
						select QPMCid, QPMCSaldoMovLoc, QPMCFInclusion, QPMCFAfectacion
						  from QPMovCuenta pos
						 where QPTidTag = #LvarQPTidTag# AND QPctaSaldosid = #LvarQPctaSaldosid#
						   and QPMCid = (
											select max(QPMCid) 
											  from QPMovCuenta pos_cero
											 where QPTidTag = pos.QPTidTag AND QPctaSaldosid = pos.QPctaSaldosid
											   and QPMCSaldoMovLoc = 0								<!--- Saldo = 0 puede ser pos o neg --->
											   and QPMCMontoLoc is not null and QPMCMontoLoc >= 0	<!--- Monto >= 0 es positivo --->
										)
					</cfquery>
				</cfif>
				<cfquery name="rsMovimientosNeg" datasource="#Arguments.Conexion#">
					select QPMCid, coalesce(QPMCSaldoMovLoc, QPMCMontoLoc) as QPMCSaldoMovLoc, QPMCFInclusion, QPMCFAfectacion
					  from QPMovCuenta neg
					 where QPTidTag = #LvarQPTidTag# AND QPctaSaldosid = #LvarQPctaSaldosid#
					<cfif LvarPostPago>
					   and QPCid	= #rsCausasTag.QPCid#
					</cfif>
					   and coalesce(QPMCSaldoMovLoc, QPMCMontoLoc) < 0
					   and QPMCMontoLoc is not null
				   <cfif LvarPrePagoSinMovPos>
					   and (
					   		select count(1)
							  from QPMovCuentaAplicacion
							 where QPMCidPos = #rsMovimientosPos.QPMCid#
							   and QPMCidNeg = neg.QPMCid
							) = 0
				   </cfif>
					 order by QPMCFAfectacion, QPMCFInclusion, QPMCid
				</cfquery>

				<cfif rsMovimientosPos.recordCount GT 0 AND rsMovimientosNeg.recordCount GT 0>
					<cfif LvarPrePago>
						<cfset LvarQPMCidPoss = listToArray(valueList(rsMovimientosPos.QPMCid))>
					</cfif>

					<cfloop query="rsMovimientosPos">
						<cfset LvarIDpos	= rsMovimientosPos.QPMCid>
						<cfset LvarSaldoPos	= rsMovimientosPos.QPMCSaldoMovLoc>

						<cfif LvarPostPago>
							<!--- POSTPAGO --->
							<!--- Fecha Movimiento: Se usa la fecha enviada por el Banco --->
							<!--- Fecha Aplicacion: SIEMPRE es la fecha de Bloqueo o Incobrable --->
							<cfset LvarFechaMovPos = rsMovimientosPos.QPMCFInclusion>
						<cfelse>
							<!--- PREPAGO --->
							<!--- Fecha Movimiento: Se usa la fecha de afectación en Quickpass --->
							<!--- Fecha Aplicacion: Sólo cuando es un reintento de cobro es fecha de Bloqueo o Incobrable --->
							<cfset LvarFechaMovPos = rsMovimientosPos.QPMCFAfectacion>

							<!--- Fecha Siguiente MovimientoPositivo --->
							<cfif rsMovimientosPos.currentRow LT rsMovimientosPos.recordCount>
								<cfif LvarIDpos  NEQ LvarQPMCidPoss[rsMovimientosPos.currentRow]>
									<cfthrow message="No sirvio LvarQPMCidPoss">
								</cfif>
								<cfset LvarIDposSig = LvarQPMCidPoss[rsMovimientosPos.currentRow+1]>
								<cfquery name="rsSQL" dbtype="query">
									select QPMCFAfectacion
									  from rsMovimientosPos
									 where QPMCid = #LvarIDposSig#
								</cfquery>
								<cfset LvarFechaSigPos = rsSQL.QPMCFAfectacion>
							<cfelse>
								<cfset LvarIDposSig = "999999999999999999">
								<cfset LvarFechaSigPos = createDate(6000,1,1)>
							</cfif>
						</cfif>
						
						<cfset LvarCountNeg = 0>
						<cfloop query="rsMovimientosNeg">
							<cfoutput> </cfoutput>
							<cfif rsMovimientosNeg.QPMCSaldoMovLoc LT 0>
								<cfset LvarCountNeg ++>
								<cfset LvarIDneg 		= rsMovimientosNeg.QPMCid>
								<cfif LvarPostPago>
									<!--- Se usa la fecha enviada por Autopistas del Sol --->
									<!--- NUNCA SE TOMA EN CUENTA como fecha de Bloqueo o Incobrable --->
									<cfset LvarFechaMovNeg 	= rsMovimientosNeg.QPMCFInclusion>
								<cfelse>
									<!--- Se usa la fecha de afectación en Quickpass --->
									<!--- Generalmente es la fecha de Bloqueo o Incobrable cuando es un Consumo posterior al Prepago --->
									<cfset LvarFechaMovNeg 	= rsMovimientosNeg.QPMCFAfectacion>
								</cfif>
								<cfset LvarSaldoNeg		= rsMovimientosNeg.QPMCSaldoMovLoc>
								<cfset LvarAplicar		= abs(LvarSaldoNeg)>
								<cfset LvarSalir		= false>
								<cfif LvarAplicar LTE LvarSaldoPos>
									<!--- Si el saldo del Mov Pos alcanza: Bloquear SaldoNeg sin Incobrable --->
									<cfset LvarBloqueado	= LvarAplicar>
									<cfset LvarIncobrable	= 0>
								<cfelse>
									<!--- Si el saldo del Mov Pos no alcanza: Bloquear el SaldoPos --->
									<cfset LvarBloqueado	= LvarSaldoPos>
			
									<!--- 
										Manejo de Incobrables cuando el SaldoPos no alcanza:
			
										PostPago (incluye movs en cero):
											si el 'movNeg' esAnterior al 'movPos' (PostPago: movPos POSTERIOR a movNeg)
												hay incobrable 
												sigue con el siguiente movNeg
											si no 
												no hay incobrable
												si hay bloqueo lo registra
												termina los movNeg
												sigue con el siguiente movPos
										PrePago:	
											si el 'movNeg' esAnterior al 'SIGUENTEmovPos' (PrePago: SIGUIENTEmovPos es ANTERIOR a movNeg sigue siendo PrePago, el incobrable se da en el ultimo movPos que no alcance)
												hay incobrable 
												sigue con el siguiente movNeg
											si no 
												no hay incobrable
												si hay bloqueo lo registra
												termina los movNeg
												sigue con el siguiente movPos

									--->
									<cfset LvarGeneraIncobrable = true>
									<cfif LvarPostPago>
										<!--- POSTPAGO: Solo hay incobrable si el mov es Postpago --->
										<cfset LvarGeneraIncobrable = (LvarFechaMovPos GT LvarFechaMovNeg)>
									<cfelseif LvarPrePago>
										<!--- PREPAGO: No hay incobrable si el siguiente movimiento tambien es Prepago (solo el último Prepago genera incobrable) --->
										<cfset LvarGeneraIncobrable = NOT (LvarFechaSigPos LT LvarFechaMovNeg)>
 									</cfif>
		
									<cfif LvarGeneraIncobrable>
										<cfset LvarIncobrable	= LvarAplicar-LvarBloqueado>
									<cfelse>
										<cfset LvarIncobrable	= 0>
										<cfset LvarSalir	= true>
										<!--- 
											Si no alcanzó pero no hay incobrable se puede salir, 
												. Si tampoco hubo bloqueo se puede salir inmediatamente
												. Si hubo bloqueo primero debe registrar la aplicación y luego salirse
										--->
										<cfif LvarBloqueado EQ 0>
											<cfbreak>
										</cfif> 
									</cfif>
								</cfif>
		
								<cftransaction>
									<!--- Insertar registro en QPMovCuentaAplicacion: --->
									<!--- EXEC sp_rename 'QPMovCuentaAplicacion.QPMCAFMovPos', 'QPMCAFAplicacion', 'COLUMN' --->
									
									<cfquery datasource="#Arguments.Conexion#">
										insert into QPMovCuentaAplicacion (QPMCidPos, QPMCidNeg, QPMCAMonDisponible, QPMCAMonAplicar, QPMCAMonBloqueado, QPMCAMonIncobrable, QPMCAFAplicacion, QPctaSaldosTipo)
										values(#LvarIDpos#, #LvarIDneg#, #LvarSaldoPos#, #LvarAplicar#, #LvarBloqueado#, #LvarIncobrable#
										<cfif LvarPostPago>
											<!--- En PostPago es la fecha de aplicacion en el banco, o sea, fecha movimiento de Cobro: rsMovimientosPos.QPMCFInclusion --->
											, <cfqueryparam cfsqltype="cf_sql_date" value="#LvarFechaMovPos#">
										<cfelse>
											<!--- En PrePago es la fecha de afectación del Saldo en QuickPass: mayor QPMCFAfectacion de movPos y movNeg --->
											<!--- Si no hay MovPos hay que usar LvarFechaMovNeg --->
											<!--- Se usa la fecha contable mayor entre LvarFechaMovPos y LvarFechaMovNeg --->
												<!--- Si  LvarFechaMovPos < LvarFechaMovNeg es la primera vez que se va a cobrar el movNeg y por tanto debe usarse esa fecha movNeg --->
												<!--- Si  LvarFechaMovPos > LvarFechaMovNeg es un reintento de cobro del movNeg y por tanto debe usarse la fecha del movPos --->
											<cfif LvarFechaMovPos NEQ "" AND LvarFechaMovNeg NEQ "">
												<cfif LvarPrePagoSinMovPos OR LvarFechaMovNeg GTE LvarFechaMovPos>
													, <cfqueryparam cfsqltype="cf_sql_date" value="#LvarFechaMovNeg#">
												<cfelse>
													, <cfqueryparam cfsqltype="cf_sql_date" value="#LvarFechaMovPos#">
												</cfif>
											<cfelse>
												, <cfqueryparam cfsqltype="cf_sql_date" value="#now()#">
											</cfif>
										</cfif>
											, #LvarTagTipo#
										)
									</cfquery>
									
									<cfset LvarSaldoPos 	-= LvarBloqueado>
									<cfset LvarSaldoNeg 	+= LvarBloqueado>
				
									<!--- Actualizar QPmovCuenta Pos: LvarSaldoPos --->
									<cfquery datasource="#Arguments.Conexion#">
										update QPMovCuenta
										   set QPMCSaldoMovLoc = #LvarSaldoPos#
										 where QPMCid = #LvarIDpos#
									</cfquery>
														
									<!--- Actualizar QPmovCuenta Neg: LvarSaldoNeg --->
									<cfquery datasource="#Arguments.Conexion#">
										update QPMovCuenta
										   set QPMCSaldoMovLoc = #LvarSaldoNeg#
										 where QPMCid = #LvarIDneg#
									</cfquery>
								</cftransaction>

								<!--- Actualizar rsMovimientosNeg: LvarSaldoNeg --->
								<cfset querysetcell(rsMovimientosNeg,"QPMCSaldoMovLoc",LvarSaldoNeg,rsMovimientosNeg.currentRow)>
			
								<cfif LvarSalir>
									<cfbreak>
								</cfif>
							</cfif>
						</cfloop>	<!--- rsMovimientosNegs --->
		
						<cfif LvarCountNeg EQ 0>
							<!--- Si no hay más movimientos negativos, ya no hay más que aplicar, brinca a la siguiente Causa (PostPago) o al siguiente TAG (PrePago) --->
							<cfbreak>
						</cfif>
					</cfloop>	<!--- rsMovimientosPos --->
				</cfif>		<!--- rsMovimientosPos.recordCount GT 0 AND rsMovimientosNeg.recordCount GT 0 --->
			</cfloop>	<!--- rsCausasTag --->
			<cfset rsMovimientosPos = javacast("null","")>
			<cfset rsMovimientosNeg = javacast("null","")>
			<cfset javaRT.gc()>
		</cfloop>	<!--- rsTags --->
		<cfif rsTags.recordCount GT 0>
			<cfoutput>TOTAL=#rsTags.recordCount#<BR><BR></cfoutput>
		</cfif>
		<cfset Application.QPAplicaMovimiento = 0>
        <cfreturn LvarQPTidTag>
	</cffunction>
</cfcomponent>
