<!--- 
	Interfaces desde BNValores hacia SOIN.
	Interfaz 151: Transmision de Mensaje: Conformacion, Cancelacion o Anulacion de orden de pago desde sistema externo
	Entradas :
		ID : ID del Proceso a crear.
		MODO : Accion a realizar.
	Salidas :
		1 Registro en la Tabla IE150 : Datos del Encabezado de la Recepcin (EDRid).
--->

<!--- Crea Instancia de Componente de Interfaces para reportar actividad de la intarfaz --->
<cfobject name="LobjInterfaz" component="interfacesSoin.Componentes.interfaces">

<!--- Reporta actividad de la intarfaz --->
<cfset LobjInterfaz.sbReportarActividad(GvarNI, GvarID)>

<!--- Lectura de Orden de Pago. --->
<!---<cftransaction isolation="read_uncommitted">--->
	<!--- Lee encabezado y detalles por procesar. --->
	<cfquery name="readInterfaz151" datasource="sifinterfaces">
		select 	ID, 
				tesoreria, 
				OrdenPago, 
				Operacion, 
				Moneda_ISO as moneda, 
				TipoCambio, 
				Monto, 
				Banco, 
				CuentaBancaria, 
				TipoMedioPago, 
				NumeroDocumento,
				FechaPago,
				FechaOperacion,
				UsuarioOperacion

		from IE151

		where ID = <cfqueryparam cfsqltype="cf_sql_numeric" value="#GvarID#"><!--- La variable GvarID fué por el Componente de Interfaces previamente a invocar este Componente --->
	</cfquery>

	<!--- Valida que vengan datos --->
	<cfif readInterfaz151.recordcount eq 0>
		<cfthrow message="Error en Interfaz 151. No existen datos de Entrada para el ID='#GvarID#' o no tiene detalles definidos. Proceso Cancelado!.">
	</cfif>

<!---</cftransaction>--->


<!--- Reporta actividad de la interfaz --->
<cfset LobjInterfaz.sbReportarActividad(GvarNI, GvarID)>
<!--- Validaciones. --->
	
	<!--- 1. Valida existencia d ela orden de pago y Tesoreria --->
	<cfquery name="rsTesoreriaOrden" datasource="#session.DSN#">
		select 1 
		from IE151
		where IE151.ID = <cfqueryparam cfsqltype="cf_sql_numeric" value="#GvarID#">
		 and not exists ( 	select 1
							from TESOrdenPago a, Tesoreria b
							where a.TESOPnumero = IE151.OrdenPago
							  and b.TEScodigo = IE151.tesoreria
							  and b.TESid=a.TESid	
							  and b.CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.CEcodigo#"> )
	</cfquery>

	<cfif rsTesoreriaOrden.RecordCount gt 0>			
		<cfthrow message="La Tesorería y Orden de Pago asociada no existen.">
	</cfif>

	<!--- moneda --->
	<cfset lista_monedas = quotedvaluelist(readInterfaz151.moneda) >
	<cfquery name="rsValidaMoneda" datasource="#session.DSN#">
		select Miso4217
		from Monedas
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		<cfif len(trim(lista_monedas)) >
		    and Miso4217 in (#preservesinglequotes(lista_monedas)#) 
		<cfelse>
		    and Miso4217 = '0'
		</cfif>
	</cfquery>
	<cfset lista_monedas2 = quotedvaluelist(rsValidaMoneda.Miso4217) >	
	<cfif listlen(lista_monedas) neq listlen(lista_monedas2)  >
		<cfthrow message="Existen monedas de este grupo (#lista_monedas#) que no han sido definidas.">
	</cfif>

	<!--- banco --->
	<cfset lista_bancos = quotedvaluelist(readInterfaz151.banco) >
	<cfquery name="query" datasource="#Session.DSN#">
		select Bcodigocli 
		from Bancos
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		<cfif len(trim(lista_monedas)) >
			and Bcodigocli in (#preservesinglequotes(lista_bancos)#)
		<cfelse>
			and Bcodigocli = '*'
		</cfif>	
	</cfquery>
	<cfset lista_bancos2 = quotedvaluelist(query.Bcodigocli) >
	<cfif listlen(lista_bancos) neq listlen(lista_bancos2)  >
		<cfthrow message="Existen bancos de este grupo (#lista_bancos#) que no han sido definidos.">
	</cfif>

	<!--- cuentas bancarias --->	
	<cfset lista_errores = '' >
	<cfset lista_operaciones = '' >
	<cfloop query="readInterfaz151">
		<cfquery name="rsExisteCuenta" datasource="#session.DSN#">
			select a.CBcodigo
			from CuentasBancos a, Bancos b
			where b.Bid = a.Bid
			  and b.Bcodigocli = <cfqueryparam cfsqltype="cf_sql_varchar" value="#readInterfaz151.banco#">
			  and a.CBcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#readInterfaz151.CuentaBancaria#">
              and a.CBesTCE = <cfqueryparam value="0" cfsqltype="cf_sql_bit">
		</cfquery>
		<cfif rsExisteCuenta.recordcount eq 0 >
			<cfset lista_errores = listappend(lista_errores, readInterfaz151.CuentaBancaria) >
		</cfif> 
		
		<cfif listfind('1,2,3,4', readInterfaz151.operacion) eq 0 >
			<cfset lista_operaciones = listappend(lista_operaciones, readInterfaz151.operacion ) >
		</cfif>

	</cfloop>
	<cfif listlen(lista_errores) gt 0 >
		<cfthrow message="Las siguientes cuentas bancarias no existen: #lista_errores#.">
	</cfif>
	<cfif listlen(lista_operaciones) gt 0 >
		<cfthrow message="Las siguientes tipos de operacion no estan permitidos: #lista_operaciones#. [1:emitida, 2:cancelada, 3:Documento Anulado, 4:Pago Anulado]">
	</cfif>


	<!--- procesa la interfaz --->
	<cfloop query="readInterfaz151">
		
		<!--- el banco y cuenta bancaria pudieron cambiar, se hace update para ajustarlos --->
		<!--- nuevo banco --->
		<cfquery name="rsNuevobanco" datasource="#session.DSN#">
			select Bid
			from Bancos
			where Bcodigocli = <cfqueryparam cfsqltype="cf_sql_varchar" value="#readInterfaz151.banco#">
			  <!--- no estoy seguro de poner esto, pues se supone que lo que trae tesoreria puede ser de una empresa diferente a session --->	
			  and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		</cfquery>
		<!--- nueva cuenta --->
		<cfquery name="rsNuevaCuenta" datasource="#session.DSN#">
			select CBid
			from CuentasBancos
			where CBcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#readInterfaz151.CuentaBancaria#">
			  <!--- no estoy seguro de poner esto, pues se supone que lo que trae tesoreria puede ser de una empresa diferente a session --->	
			  and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
              and CBesTCE = <cfqueryparam value="0" cfsqltype="cf_sql_bit">
		</cfquery>
		
		<!---
		<cfquery datasource="#session.DSN#">
			update TESOrdenPago
			set CBidpago = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsNuevaCuenta.CBid#">
			where TESOPnumero = <cfqueryparam cfsqltype="cf_sql_integer" value="#readInterfaz151.OrdenPago#">
			  and exists ( 	select 1
			  				from Tesoreria a
							where a.TESid = TESOrdenPago.TESid
							  and a.TEScodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#readInterfaz151.tesoreria#"> 
			  				  and a.CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.CEcodigo#">
						 ) 
		</cfquery>
		--->

		<!--- datos de la orden de pago --->
		<cfquery name="rsdatos" datasource="#session.DSN#">
			select 	b.TESid, 
					a.TESOPid, 
					a.CBidpago, 
					a.TESid, 
					a.TESMPcodigo, 
					a.TESOPnumero, 
					a.TESOPfechaPago, 
					'#session.usulogin#' as UsuarioOperacion,
					a.TESOPfechaPago, 
					a.TESCFDnumFormulario, 
					a.TESTDid,
					( select mp.TESTMPtipo 
					  from TESmedioPago mp
					  where mp.TESid = a.TESid
						and mp.CBid	= a.CBidPago
						and mp.TESMPcodigo	= a.TESMPcodigo ) as TESTMPtipo,
					a.TESMPcodigo,
					a.TESOPestado

			from TESordenPago a, Tesoreria b

			where a.TESOPnumero = <cfqueryparam cfsqltype="cf_sql_integer" value="#readInterfaz151.OrdenPago#">
			  and b.TEScodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#readInterfaz151.tesoreria#">
			  and b.CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.CEcodigo#">
			  and b.TESid = a.TESid
		</cfquery>
		<cfset session.Tesoreria.TESid = rsdatos.TESid >

		<!--- emitida --->	
		<cfif readInterfaz151.Operacion eq 1 >
		<!--- ************************************************************* --->
		<!--- ************************************************************* --->
				<cftransaction>
					<cfquery name="rsTipoMedioPago" datasource="#session.DSN#">
						select substr(b.TESTMPdescripcion, 1, 3) as tipo  
						from TESMedioPago a, TESTipoMedioPago b
						where b.TESTMPtipo = a.TESTMPtipo
						  and a.CBid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsdatos.CBidpago#">
						  and a.TESid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsdatos.TESid#">
						  and a.TESMPcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsdatos.TESMPcodigo#">
					</cfquery>
					
					<cfset vBanco = 0 >
					<cfquery name="rsBanco151" datasource="#session.DSN#">
						select Bid
						from Bancos
						where Bcodigocli = <cfqueryparam cfsqltype="cf_sql_varchar" value="#readInterfaz151.banco#">
					</cfquery>
					<cfif len(trim(rsBanco151.Bid))>
						<cfset vBanco = rsBanco151.Bid >
					<cfelse>
						<cfthrow message="ERROR. El banco #readInterfaz151.bid# no existe.">
					</cfif>

					<cfquery name="rsCuentaID" datasource="#session.DSN#">
						select CBid
						from CuentasBancos
						where CBcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#readInterfaz151.CuentaBancaria#">
						  and Bid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#vBanco#">
                          and CBesTCE = <cfqueryparam value="0" cfsqltype="cf_sql_bit">
					</cfquery>
					<cfif len(trim(rsCuentaID.CBid))>
						<cfset vCuenta = rsCuentaID.CBid >
					<cfelse>
						<cfthrow message="ERROR. La Cuenta Bancaria #readInterfaz151.CuentaBancaria# para el banco #readInterfaz151.banco# no existe.">
					</cfif>
					
					

					<cfif rsTipoMedioPago.tipo EQ 'CHK' >
						<!--- GENERA FORMULARIO REGISTRADO --->
						<!--- ** OJO **. No se si esta bien, pero nadie me dice como hacerlo y necesito tener un TESCFDnumFormulario 
						entonces lo hago asi, leyendo el mayor de la bd y asignado el siguiente  --->	
						<cfquery name="rsnumfor" datasource="#session.DSN#">
							select max(TESCFDnumFormulario) as numFormulario
							from TEScontrolFormulariosD
							where TESid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsdatos.TESid#">
							  and CBid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsdatos.CBidpago#">
							  and TESMPcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsdatos.TESMPcodigo#">
						</cfquery>
						<cfset numFormulario = rsnumfor.numFormulario >
						<cfif len(trim(numFormulario)) >
							<cfset numFormulario = numFormulario + 1 >
						<cfelse>
							<cfset numFormulario = 1 >
						</cfif>

						<cfquery datasource="#session.dsn#">
							insert into TEScontrolFormulariosD(	TESid,
																CBid,
																TESMPcodigo,
																TESCFDnumFormulario,
																TESOPid,
																TESCFLid,
																TESCFDestado,
																UsucodigoEmision,
																TESCFDfechaEmision,
																TESCFDfechaGeneracion,
																BMUsucodigo )
								values(	<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsdatos.TESid#">
										,<cfqueryparam cfsqltype="cf_sql_numeric" value="#vCuenta#">
										,<cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(rsdatos.TESMPcodigo)#">
										,<cfqueryparam cfsqltype="cf_sql_integer" value="#readInterfaz151.NumeroDocumento#"> <!--- numero calculado arriba, no hay seguridad que sea asi. --->
										,<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsdatos.TESOPid#">
										,null
										,1	<!--- Impresos --->
										,#session.Usucodigo#
										,<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#"> 	<!--- TESCFDfechaEmision --->
										,<cfqueryparam cfsqltype="cf_sql_date" 		value="#rsdatos.TESOPfechaPago#">
										,#session.Usucodigo# )
						</cfquery>
						
<!---
<CFQUERY name="X" datasource="#SESSION.dsn#">
	SELECT TESid, CBid, TESMPcodigo, TESCFDnumFormulario
	FROM TEScontrolFormulariosD
	where TESid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsdatos.TESid#">
	  and CBid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#vCuenta#">
      and TESMPcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(rsdatos.TESMPcodigo)#">
      and TESCFDnumFormulario = <cfqueryparam cfsqltype="cf_sql_integer" value="#readInterfaz151.NumeroDocumento#">

</CFQUERY>
<cfthrow message="ERROR. TESid: #x.TESid#  CBid: #x.CBid# TESMPcodigo: #x.TESMPcodigo# Numformulario: #x.TESCFDnumFormulario#">

--->
						
						<cfquery datasource="#session.dsn#" >
							insert into TEScontrolFormulariosB(	TESid, 
																CBid, 
																TESMPcodigo, 
																TESCFDnumFormulario, 
																TESCFBultimo, 
																UsucodigoCustodio,
																TESCFBfecha, 
																TESCFEid, 
																TESCFLUid, 
																TESCFBfechaGenera, 
																UsucodigoGenera, 
																BMUsucodigo )
							select 	 TESid,
									 CBid,
									 TESMPcodigo,
									<cfqueryparam cfsqltype="cf_sql_numeric" value="#readInterfaz151.NumeroDocumento#">,
									1,
									<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">,
									<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
									(select min(TESCFEid) from TESCFestados where TESid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsdatos.TESid#"> and TESCFEimpreso = 1),
									NULL,
									<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
									<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">,
									<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
									
							  from TEScontrolFormulariosD
							 where TESid				= <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsdatos.TESid#">
							   and CBid					= <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsdatos.CBidpago#">
							   and TESMPcodigo			= <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsdatos.TESMPcodigo#">
							   and TESCFDnumFormulario	= <cfqueryparam cfsqltype="cf_sql_integer" value="#readInterfaz151.NumeroDocumento#">
							   and TESCFDestado			= 1
						</cfquery>
					<cfelse>
						<!--- TIPO MEDIO PAGO "TRANSFERENCIA" --->
						<cfquery name="insert" datasource="#session.dsn#">
							insert into TEStransferenciasD(	TESid,
															CBid,
															TESMPcodigo,
															TESOPid,
															TESTLid,
															TESTDreferencia,
															TESTDestado,
															UsucodigoEmision,
															TESTDfechaEmision,
															TESTDfechaGeneracion,
															BMUsucodigo )
								values(	<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsdatos.TESid#">,
										<cfqueryparam cfsqltype="cf_sql_numeric" value="#vCuenta#">,
										<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsdatos.TESMPcodigo#">,
										<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsdatos.TESOPid#">,
										NULL,
										<!---<cfqueryparam cfsqltype="cf_sql_varchar" value="#mid(rsdatos.TESOPnumero, 1, 20)#">,--->
										<cfqueryparam cfsqltype="cf_sql_varchar" value="#mid(readInterfaz151.NumeroDocumento, 1, 20)#">,
										1,
										#session.Usucodigo#,
										<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">, 	<!--- TESTDfechaEmision --->
										<cfqueryparam cfsqltype="cf_sql_date" 		value="#rsdatos.TESOPfechaPago#">,
										#session.Usucodigo# )
							<cf_dbidentity1 datasource="#session.DSN#">
						</cfquery>
						<cf_dbidentity2 datasource="#session.DSN#" name="insert" returnvariable="LvarTESTDid">
					</cfif>
				
					<!--- valida existencia de banco/cuenta/medio de pago en la tabla TESMedioPago--->
					<cfquery name="rsMedioPago" datasource="#session.DSN#">
						select 1
						from TESMedioPago
						where TESid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Tesoreria.TESid#">
						  and CBid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#vCuenta#">
						  and TESMPcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsdatos.TESMPcodigo#">
					</cfquery>
					<cfif rsMedioPago.recordcount eq 0 >
						<cfthrow message="ERROR. La relaci&oacute;n entre la tesorer&iacute;a #readInterfaz151.tesoreria#, el medio de pago #trim(rsdatos.TESMPcodigo)# y la cuenta bancaria #trim(readInterfaz151.CuentaBancaria)# no se encuentra registrada.">
					</cfif>
<!---<cfthrow message="ERROR. TESid: #rsDatos.TESid#  CBid: #vCuenta# TESMPcodigo: #rsdatos.TESMPcodigo# Numformulario: #readInterfaz151.NumeroDocumento#">--->

					<cfquery datasource="#session.dsn#">
						update TESordenPago 
							set TESOPestado  = 12,
								TESOPfechaEmision = <cfqueryparam cfsqltype="cf_sql_date" value="#rsdatos.TESOPfechaPago#">,
								UsucodigoEmision = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">,
								TESOPfechaPago = <cfqueryparam cfsqltype="cf_sql_date" value="#rsdatos.TESOPfechaPago#">,
								TESOPtipocambiopago = <cfqueryparam cfsqltype="cf_sql_float" value="#readInterfaz151.TipoCambio#">,
								CBidpago = <cfqueryparam cfsqltype="cf_sql_numeric" value="#vCuenta#">,
								CBid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#vCuenta#">

							<!--- No se nada de la parte de formularios, no se que va aqui. --->
							<cfif rsTipoMedioPago.tipo EQ 'CHK' >
								,TESOPobservaciones = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsdatos.TESOPnumero#" >
								,TESCFDnumFormulario = <cfqueryparam cfsqltype="cf_sql_integer" value="#readInterfaz151.NumeroDocumento#">
							<cfelse>
								,TESTDid = #LvarTESTDid#
							</cfif>
							
						 where TESid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsDatos.TESid#">
						   and TESOPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsDatos.TESOPid#">
						   and TESOPestado in (10,11)
					</cfquery>

					<cfquery datasource="#session.dsn#">
						update TESsolicitudPago 
							set TESSPestado  = 12
						 where TESid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsDatos.TESid#">
						   and TESOPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsDatos.TESOPid#">
						   and TESSPestado in (10,11)
					</cfquery>
					<cfquery datasource="#session.dsn#">
						update TESdetallePago 
							set TESDPestado  = 12
						 where TESid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsDatos.TESid#">
						   and TESOPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsDatos.TESOPid#">
						   and TESDPestado in (10,11)
					</cfquery>
				
					<cfinvoke component="sif.tesoreria.Componentes.TESaplicacion" method="sbAplicarOrdenPago"> 
						<cfinvokeargument name="TESOPid" value="#rsDatos.TESOPid#"/>
					</cfinvoke>
				</cftransaction>
				

		<!--- ************************************************************* --->
		<!--- ************************************************************* --->
		
		<!--- cancelada --->
		<cfelseif readInterfaz151.Operacion eq 2 >
			<cfquery datasource="#session.dsn#">
				update TESsolicitudPago
				   set TESSPestado 		= 2
	
					 , TESOPid	 		= null
					 , CBid	 			= null
					 , TESMPcodigo	 	= null
					 , SNid	 			= null
					 , EcodigoSP	 	= null
					 , TESOPfechaPago	= null
	
				 where TESid = #session.Tesoreria.TESid#
				   and TESOPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsdatos.TESOPid#">
				   and TESSPestado in (10,11)
			</cfquery>	
			<cfquery datasource="#session.dsn#">
				update TESdetallePago 
				   set  TESDPestado  			= 2
					  , TESOPid 				= null
					  , TESDPfechaPago 			= null
					  , EcodigoPago				= null
					  , TESDPmontoAprobadoLocal = null
					  , TESDPtipoCambioOri		= null
					  , TESDPfactorConversion	= null
					  , TESDPmontoPago			= null
					  , TESDPmontoPagoLocal 	= null
				 where TESid 	= #session.Tesoreria.TESid#
				   and TESOPid 	= <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsdatos.TESOPid#">
				   and TESDPestado in (10,11)
			</cfquery>
			<cfquery datasource="#session.dsn#">
				update TESordenPago
				   set  TESOPestado 			= 13	/* TESOPestado = 13:  Anulado */
					  , TESOPmsgRechazo			= 'ORDEN DE PAGO ELIMINADA'
					  , TESOPfechaCancelacion	= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
					  , UsucodigoCancelacion	= <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
				 where TESid 	= #session.Tesoreria.TESid#
				   and TESOPid 	= <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsdatos.TESOPid#">
				   and TESOPestado in (10,11)
			</cfquery>	
		
	
		<!--- Documento Anulado--->
		<cfelseif readInterfaz151.Operacion eq 3 >
	
		<!--- Pago Anulado --->
		<cfelseif readInterfaz151.Operacion eq 4 >
			<!--- ******************************************************** --->
			<!--- ******************************************************** --->
			
				<!--- estado de la orden debe ser 12 --->
				<cfif rsDatos.TESOPestado neq 12>
					<cfthrow message="ERROR. La Orden de Pago debe estar emitida para poder ejecutar el proceso de anulacion.">
				</cfif>

				<cfset vBanco = 0 >
				<cfquery name="rsBanco151" datasource="#session.DSN#">
					select Bid
					from Bancos
					where Bcodigocli = <cfqueryparam cfsqltype="cf_sql_varchar" value="#readInterfaz151.banco#">
				</cfquery>
				<cfif len(trim(rsBanco151.Bid))>
					<cfset vBanco = rsBanco151.Bid >
				<cfelse>
					<cfthrow message="ERROR. El banco #readInterfaz151.bid# no existe.">
				</cfif>

				<cfquery name="rsCuentaID" datasource="#session.DSN#">
					select CBid
					from CuentasBancos
					where CBcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#readInterfaz151.CuentaBancaria#">
					  and Bid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#vBanco#">
                      and CBesTCE = <cfqueryparam value="0" cfsqltype="cf_sql_bit">
				</cfquery>
				<cfif len(trim(rsCuentaID.CBid))>
					<cfset vCuenta = rsCuentaID.CBid >
				<cfelse>
					<cfthrow message="ERROR. La Cuenta Bancaria #readInterfaz151.CuentaBancaria# para el banco #readInterfaz151.banco# no existe.">
				</cfif>

				<!--- valida existencia de banco/cuenta/medio de pago en la tabla TESMedioPago--->
				<cfquery name="rsMedioPago" datasource="#session.DSN#">
					select 1
					from TESMedioPago
					where TESid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Tesoreria.TESid#">
					  and CBid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#vCuenta#">
					  and TESMPcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsdatos.TESMPcodigo#">
				</cfquery>
				<cfif rsMedioPago.recordcount eq 0 >
					<cfthrow message="ERROR. (uno)La relaci&oacute;n entre la tesorer&iacute;a #readInterfaz151.tesoreria#, el medio de pago #trim(rsdatos.TESMPcodigo)# y la cuenta bancaria #trim(readInterfaz151.CuentaBancaria)# no se encuentra registrada.">
				</cfif>

				<cfquery datasource="#session.dsn#">
					update TESordenPago 
						set CBidpago = <cfqueryparam cfsqltype="cf_sql_numeric" value="#vCuenta#">
					 where TESid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsDatos.TESid#">
					   and TESOPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsDatos.TESOPid#">
				</cfquery>


			<cftransaction>
				<cfif rsDatos.TESTMPtipo EQ "1">
					<cfif len(trim(readInterfaz151.NumeroDocumento)) eq 0>
						<cfthrow message="ERROR. No se ha espec&iacute;ficado el n&uacute;mero de documento para la orden de pago #readInterfaz151.OrdenPago#">
					</cfif>

					<!--- Anular cheque --->
					<cfquery datasource="#session.DSN#">
						update TEScontrolFormulariosD
						   set TESCFDestado 		= 3, <!--- ANULADO --->
							   TESCFDmsgAnulacion 	= 'ANULADO POR INTERFAZ 151 ID de proceso: #readInterfaz151.ID#',
							   UsucodigoAnulacion	= <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">,
							   TESCFDfechaAnulacion	= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
						 where TESid				= <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.tesoreria.TESid#">
						   and CBid					= <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsDatos.CBidPago#">
						   and TESMPcodigo			= <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsDatos.TESMPcodigo#">
						   and TESCFDnumFormulario	= <cfqueryparam cfsqltype="cf_sql_integer" value="#readInterfaz151.NumeroDocumento#">
						   and TESOPid 				= <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsDatos.TESOPid#">
					</cfquery>
					<!--- ACTUALIZA LOS REGISTROS DEL FORMULARIO EN LA BITACORA DE FORMULARIOS --->
					<cfquery datasource="#session.DSN#">
						update TEScontrolFormulariosB
						   set TESCFBultimo = 0
						where TESid				   = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsDatos.TESid#">
						   and CBid				   = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsDatos.CBidPago#">
						   and TESMPcodigo		   = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsDatos.TESMPcodigo#">
						   and TESCFDnumFormulario = <cfqueryparam cfsqltype="cf_sql_numeric" value="#readInterfaz151.NumeroDocumento#">
					</cfquery>
					<!--- INSERTA UN REGISTRO CON LE MOVIMIENTO REALIZADO EN LA BITACORA DE FORMULARIOS --->	
					<cfquery datasource="#session.dsn#">
						insert into TEScontrolFormulariosB
							(
								TESid, CBid, TESMPcodigo,TESCFDnumFormulario, 
								TESCFBfecha, TESCFEid, TESCFLUid, TESCFBultimo, UsucodigoCustodio, TESCFBfechaGenera, UsucodigoGenera, BMUsucodigo
							)
						select 	 TESid, CBid, TESMPcodigo,TESCFDnumFormulario
								,<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
								,(select min(TESCFEid) from TESCFestados where TESid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsDatos.TESid#"> and TESCFEanulado = 1)
								,NULL
								,1
								,<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
								,<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
								,<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
								,<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
						  from TEScontrolFormulariosD
						 where TESid			   = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsDatos.TESid#">
						   and CBid				   = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsDatos.CBidPago#">
						   and TESMPcodigo		   = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsDatos.TESMPcodigo#">
						   and TESCFDnumFormulario = <cfqueryparam cfsqltype="cf_sql_numeric" value="#readInterfaz151.NumeroDocumento#">
						   and TESOPid 			   = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsDatos.TESOPid#">
					</cfquery>
				<cfelseif rsDatos.TESTMPtipo EQ "2" OR rsDatos.TESTMPtipo EQ "3" OR rsDatos.TESTMPtipo EQ "4">
					<!--- Anular transferencia --->
					<cfquery datasource="#session.DSN#">
						update TEStransferenciasD
						   set TESTDestado = 3, <!--- ANULADA --->
							   TESTDmsgAnulacion 	= 'ANULADO POR INTERFAZ 151 ID de proceso: #readInterfaz151.ID#',
							   UsucodigoAnulacion 	= <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">,
							   TESTDfechaAnulacion	= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
						 where TESid				= <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsDatos.TESid#">
						   and CBid					= <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsDatos.CBidPago#">
						   and TESMPcodigo			= <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsDatos.TESMPcodigo#">
						   and TESTDid				= <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsDatos.TESTDid#">		  
						   and TESOPid 			   	= <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsDatos.TESOPid#">
					</cfquery>
				<cfelse>
					<cfthrow message="Tipo Medio de Pago incorrecto">
				</cfif>
		
				<!--- MODIFICAR ESTADO DE LA ORDEN DE PAGO Y LA SOLICITUD DE PAGO --->
				<cfset mensajeRechazo = 'Anulado por interfaz 151. Id de proceso #readInterfaz151.id#. Usuario: #readInterfaz151.UsuarioOperacion#' >
				<cfset mensajeRechazo = mid(mensajeRechazo, 1, 255) >
				<cfquery datasource="#session.dsn#">
					update TESsolicitudPago
					   set  TESSPestado 		= 13	/* TESSPestado = 13: OP ANULADA */
						  , TESSPmsgRechazo 	= <cfqueryparam cfsqltype="cf_sql_varchar" value="#mensajeRechazo#">
						  , TESSPfechaRechazo	= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
						  , UsucodigoRechazo	= <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
					 where TESid 		= <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsDatos.TESid#">
					   and TESOPid 		= <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsDatos.TESOPid#">
					   and TESSPestado 	= 12
				</cfquery>	
				<cfquery datasource="#session.dsn#">
					update TESdetallePago 
					   set TESDPestado	= 13 <!--- Orden de Pago Cancelada --->
					 where TESid 		= <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsDatos.TESid#">
					   and TESOPid 		= <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsDatos.TESOPid#">
					   and TESDPestado 	= 12
				</cfquery>
				<cfquery datasource="#session.dsn#">
					update TESordenPago
					   set TESOPestado	= 13, <!--- Orden de Pago Cancelada --->
						   TESOPmsgRechazo 		  = 'ANULADO POR INTERFAZ 151 ID de proceso: #readInterfaz151.ID#',
						   UsucodigoCancelacion	  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">,
						   TESOPfechaCancelacion  = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">			   
					 where TESid 		= <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsDatos.TESid#">
					   and TESOPid 		= <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsDatos.TESOPid#">
					   and TESOPestado 	= 12
				</cfquery>	
		
				<cfset session.Tesoreria.TESid = rsDatos.TESid>
				<cfinvoke 	component="sif.tesoreria.Componentes.TESaplicacion" 
							method="sbReversarOrdenPago">
					<cfinvokeargument name="TESOPid" value="#rsdatos.TESOPid#"/>
					<cfinvokeargument name="AnularOP" value="yes"/>
					<cfinvokeargument name="AnularSP" value="yes"/>
				</cfinvoke>
			</cftransaction>


			<!--- ******************************************************** --->
			<!--- ******************************************************** --->
			

		</cfif>
	</cfloop>

<!--- Reporta actividad de la interfaz --->
<cfset LobjInterfaz.sbReportarActividad(GvarNI, GvarID)>