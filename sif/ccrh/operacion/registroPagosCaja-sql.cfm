<cfset vs_mensaje = ''>
<cfset parametros = "?Did=#form.Did#&DEid=#form.DEid#&TDid=#form.TDid#&EPEdocumento=#form.EPEdocumento#">
<cf_dbfunction name="OP_concat"	returnvariable="_cat">
<cfif isdefined("form.PERid") and len(trim(form.PERid)) and isdefined("form.ID_Eliminar") and len(trim(form.ID_Eliminar))>
	<!----=====================================================================================--->
	<!----  ELIMINA DETALLE DE PAGO EXTRAORDINARIO (De tabla temporal)						   ---> 		
	<!----=====================================================================================--->	
	<cfquery name="rsRebajar" datasource="#session.DSN#">
		select montoAplicado
		from ccrhPagoRecibos
		where PERid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.PERid#">
	</cfquery>
	<cfset vn_mtorebajar = rsRebajar.montoAplicado>	
	<cfquery datasource="#session.DSN#">
		delete from ccrhPagoRecibos
		where PERid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.PERid#">
	</cfquery>
	<!---Actualizar monto del recibo--->
	<cfquery datasource="#session.DSN#">
		update PagoPorCaja
			set MontoUtilizado = abs(MontoUtilizado) - <cfqueryparam  cfsqltype="cf_sql_float" value="#vn_mtorebajar#">	
		where Id = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.ID_Eliminar#">
	</cfquery>	
	<cfset form.PERid = ''>	
<cfelseif isdefined("btnAgregar")>
	<!----=====================================================================================--->
	<!----  INSERTA ENCABEZADO Y DETALLE DE PAGO EXTRAORDINARIO EN TABLA FISICA TEMPORAL	   ---> 		
	<!----=====================================================================================--->
	<cftransaction>
		<cfif isdefined('form.DPEtc')>
			<cfset LvarTC = #form.DPEtc#>
		<cfelse>
			<cfset LvarTC =1>
		</cfif>
		<cfset vMontoDoc = Replace(form.DPEmonto,',','','all') * Replace(#LvarTC#,',','','all')>  <!--- Monto en moneda local --->
		<cfset request.Error.Backs = 1 >
		<!---Verificar que el monto por aplicar digitado sea menor al disponible del recibo seleccionado --->		
		<cfquery name="rsDisponible" datasource="#session.DSN#">
			select coalesce(MontoTotalPagado - coalesce(MontoUtilizado,0),0) as Disponible
			from PagoPorCaja
			where Id = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Id_referencia#">
		</cfquery>
		
		<cfif isdefined("rsDisponible") and rsDisponible.RecordCount>
			<cfif Replace(form.DPEmonto,',','','all') GT rsDisponible.Disponible>
				<cf_errorCode	code = "50202" msg = "El monto a aplicar digitado es mayor al disponible del documento(recibo) seleccionado. Por favor seleccione otro.">
			</cfif>
		</cfif>		 
		
		<!---Inserta en tabla temporal--->  <!--- TMPpagoErecibos por ccrhPagoRecibos campo identity PERid--->
		<cfquery name="insert" datasource="#session.DSN#">
			insert into ccrhPagoRecibos (
            	Did, 
				DEid, 
				documento, 
				moneda, 
				fecha, 
				tipocambio, 
				idRecibo, 
				montoAplicado, 
				BMUsucodigo)
			values(	<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Did#">,
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DEid#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.EPEdocumento#">,
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Mcodigo#">,
					<cfqueryparam cfsqltype="cf_sql_date" 	value="#LSParseDateTime(form.EPEfechadoc)#">,
					<cfqueryparam  cfsqltype="cf_sql_float" value="#LvarTC#">,
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Id_referencia#">,
					<cfqueryparam  cfsqltype="cf_sql_money" value="#vMontoDoc#">,
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
					)
			<cf_dbidentity1 datasource="#session.DSN#">								
		</cfquery>
		<cf_dbidentity2 datasource="#session.DSN#" name="insert">
		<cfset parametros = parametros & "&modo=CAMBIO">
		<!---Actualiza monto disponible del recibo--->
		<cfquery datasource="#session.DSN#">
			Update PagoPorCaja
				set MontoUtilizado = MontoUtilizado + <cfqueryparam cfsqltype="cf_sql_money" value="#vMontoDoc#">
			where Id = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Id_referencia#">			
		</cfquery>
	</cftransaction>
	
<cfelseif isdefined("btnRecalcular") and isdefined("form.tipopago") and len(trim(form.tipopago)) and form.tipopago EQ 'PC'>	
	<!----=====================================================================================--->
	<!----  PROCESAR PAGO DE CUOTA															   ---> 		
	<!----=====================================================================================--->
	<cfset request.Error.Backs = 1 >
	<!---Verificar que el disponible del recibo seleccionado "alcance" para pagar la cuota--->
	<cfquery name="rsDisponible" datasource="#session.DSN#">
		select coalesce(MontoTotalPagado - coalesce(MontoUtilizado,0),0) as DisponibleRecibo
		from PagoPorCaja
		where Id = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Id#">
	</cfquery>
	<cfquery name="rsCuota" datasource="#session.DSN#"><!---Datos de la cuota--->
		select case when pp.PPfecha_pago is null then 
					pp.PPprincipal+pp.PPinteres  
				else 
					pp.PPpagointeres+pp.PPpagomora+pp.PPpagoprincipal 
				end as total
		from DeduccionesEmpleadoPlan pp
		where pp.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			and pp.Did = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Did#">		
			and pp.PPnumero = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.PPnumero#">	
	</cfquery>

	<cfif rsDisponible.RecordCount NEQ 0 and rsCuota.RecordCount NEQ 0>
		<cfif rsDisponible.DisponibleRecibo LT rsCuota.total>
			<cf_errorCode	code = "50203" msg = "El monto disponible del recibo seleccionado no cubre la cuota. Por favor seleccione otro.">
		</cfif> 
	</cfif>
	<!---Actualizar el saldo de DeduccionesEmpleado--->
	<cfquery datasource="#session.DSN#">
		update DeduccionesEmpleado		
			set Dsaldo = Dsaldo - <cfqueryparam cfsqltype="cf_sql_money" value="#rsCuota.total#">
		where DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DEid#">			
			and Did = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Did#">
	</cfquery>
	<!----Poner la cuota como pagada--->	
	<cfquery name="updateCuota" datasource="#session.DSN#">
		Update DeduccionesEmpleadoPlan
			set PPfecha_pago = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
				,PPpagado = 1 	<!---PPpagado : 0--> NO, 1--> NOMINA, 2 -->EXTRAORDINARIO --->
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			and Did = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Did#">		
			and PPnumero = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.PPnumero#">			
	</cfquery>	
	<!---Actualizar el monto del recibo utilizado--->
	<cfquery datasource="#session.DSN#">
		update PagoPorCaja
			set MontoUtilizado = MontoUtilizado + <cfqueryparam cfsqltype="cf_sql_money" value="#rsCuota.total#">
		where Id = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Id#">
	</cfquery>
	<!---Eliminar detalle de pago extraordinarios, si los hay (Pueden quedar datos al estarse cambiando el combo de tipo de pago)--->
	<cfquery datasource="#session.DSN#">
		delete from ccrhPagoRecibos
		where Did  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Did#">
			and DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DEid#">
			and BMUsucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
	</cfquery>
	<cfset vs_mensaje = 'Se ha realizado el pago de la cuota satisfactoriamente'>
	
<cfelseif isdefined("btnRecalcular") and isdefined("form.tipopago") and len(trim(form.tipopago)) and form.tipopago EQ 'PE'>
	<cfset request.Error.Backs = 1 >
	<!----=====================================================================================--->
	<!----  PROCESAR PAGO EXTRAORDINARIO													   ---> 		
	<!----=====================================================================================--->
	<!--- Fecha del Pago --->
	<!--- TIENE que corresponder a la ultima fecha de plan de pagos pagado --->
	<!--- Si no existe toma la primer fecha del plan de pagos --->
	<cfquery name="dataFecha" datasource="#session.DSN#">
		select max(PPfecha_vence) as PPfecha_vence
		from DeduccionesEmpleadoPlan
		where Did = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Did#">
		and PPpagado=1
	</cfquery>
	<cfif (dataFecha.recordCount eq 0) or ( isdefined("dataFecha.PPfecha_vence") and len(trim(dataFecha.PPfecha_vence)) eq 0 ) >
		<cfquery name="dataFecha" datasource="#session.DSN#">
			select min(PPfecha_vence) as PPfecha_vence
			from DeduccionesEmpleadoPlan
			where Did = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Did#">
		</cfquery>
	</cfif>
	
	<!--- Numero de pago --->
	<cfset vPPnumero = 1 >
	<cfquery name="dataNumero" datasource="#session.DSN#">
		select max(PPnumero) as PPnumero
		from DeduccionesEmpleadoPlan
		where Did = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Did#">
		  and PPpagado in (1, 2)
	</cfquery>
	<cfif isdefined("dataNumero.PPnumero") and len(trim(dataNumero.PPnumero))>
		<cfset vPPnumero = dataNumero.PPnumero + 1 >
	</cfif>
	
	<!--- Moneda de la empresa, las deducciones funcionan SOLO con monedas de la empresa --->
	<cfquery name="dataMoneda" datasource="#session.DSN#">
		select Mcodigo 
		from Empresas 
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	</cfquery>
	
	<!--- Deduccion --->
	<cfquery datasource="#session.DSN#"  name="dataDeduccion" maxrows="1">
		select 	Ddescripcion, Dreferencia, 
				b.DEidentificacion#_Cat#' - '#_Cat#b.DEnombre#_Cat#' '#_Cat#DEapellido1#_Cat#' '#_Cat#b.DEapellido2 as Empleado				
		from DeduccionesEmpleado a, DatosEmpleado b	
		where a.Did = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Did#">
		  and a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		  and a.DEid = b.DEid
	</cfquery>
	
	<cfif not isdefined("form.EPEdocumento") or len(trim(form.EPEdocumento)) eq 0>
		<cfset form.EPEdocumento = dataDeduccion.Ddescripcion >
	</cfif>
	
	<!---<cfset monto_efectivo = Replace(form.Dmontopago,',','','all')  >--->
	<cfset monto_documentos = Replace(form.Dmontodoc,',','','all')  >
	<!---<cfset vPrincipal = monto_efectivo + monto_documentos >--->
	<cfset vPrincipal = monto_documentos >
	 
	<cftransaction>
		<!--- Recupera el IDcontable generado para el plan de pagos, para no perderlo y volover a insertarlo --->
		<cfquery name="rsIDcontable" datasource="#session.DSN#" maxrows="1">
			select IDcontable
			from DeduccionesEmpleadoPlan
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			  and Did = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Did#">
			  and PPpagado = 0
		</cfquery>

		<cfquery datasource="#session.DSN#">
			delete from DeduccionesEmpleadoPlan
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			  and Did = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Did#">
			  and PPpagado = 0
		</cfquery>
		
		<!--- inserta el pago en DeduccionesEmpleadoPlan --->
		<cfquery datasource="#session.DSN#">
			insert into DeduccionesEmpleadoPlan( Did, 
											PPnumero, 
											Ecodigo, 
											PPfecha_doc,
											PPfecha_vence, 
											PPsaldoant, 
											PPprincipal, 
											PPinteres, 
											PPpagoprincipal, 
											PPpagointeres, 
											PPpagomora, 
											PPfecha_pago, 
											Mcodigo, 
											PPtasa, 
											PPtasamora, 
											PPpagado, 
											DEPextraordinario,
											PPdocumento, 
											BMUsucodigo)
			values( <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Did#">,
					<cfqueryparam cfsqltype="cf_sql_integer" value="#vPPnumero#">,
					<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">,
					<cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(Form.EPEfechadoc)#">,  <!--- Fecha del Documento --->
					<cfqueryparam cfsqltype="cf_sql_timestamp" value="#dataFecha.PPfecha_vence#">,  <!--- *** PPfecha_vence --->
					<cfqueryparam cfsqltype="cf_sql_money" value="#Replace(form.Dmonto,',','','all')#">,
					<cfqueryparam cfsqltype="cf_sql_money" value="#Replace(vPrincipal,',','','all')#">, <!--- PPprincipal --->
					0, <!--- PPinteres --->
					<cfqueryparam cfsqltype="cf_sql_money" value="#Replace(vPrincipal,',','','all')#">, <!--- PPpagoprincipal --->
					0, <!--- PPpagointeres --->
					0, <!--- PPpagomora --->
					<cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#dataMoneda.Mcodigo#">,
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#Replace(form.Dtasa,',','','all')#">,
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#Replace(form.Dtasamora,',','','all')#">,
					2,
					1,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#dataDeduccion.Dreferencia#">,
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#"> 
			)
		</cfquery>
		
		<!---  Creacion de la tabla INTARC ----->
		<cfset obj  = CreateObject("component", "sif.Componentes.CG_GeneraAsiento") >
		<cfset plan = CreateObject("component", "sif.Componentes.CCRH_PlanPagos") >
		<cfset intarc = obj.CreaIntarc() >
		
		<cfset totalMontoDoc = 0 >
		
		<!---Obtener los datos de los recibos utilizados en el detalle--->
		<cfquery name="rsDatos" datasource="#session.DSN#">
			select * 
			from ccrhPagoRecibos a
				inner join PagoPorCaja b
					on a.idRecibo = b.Id
			where a.Did  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Did#">
				and a.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DEid#">
				and a.BMUsucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
		</cfquery>
			
		<cfif rsDatos.RecordCount NEQ 0>	
			<!--- INSERTA DATOS DEL PAGO EXTRAORDINARIO EN DOCUMENTOS --->
			<cfquery name="insert" datasource="#session.DSN#">
				insert into EPagosExtraordinarios( Did,
												  PPnumero, 
												  Ecodigo, 
												  EPEdocumento, 
												  EPEfechadoc,
												  BMUsucodigo, 
												  fechaalta)
				values( <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Did#">,
						<cfqueryparam cfsqltype="cf_sql_integer" value="#vPPnumero#">,
						<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsDatos.documento#">,
						<!---<cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(rsDatos.fecha)#">,--->
						<cfqueryparam cfsqltype="cf_sql_timestamp" value="#rsDatos.fecha#">,
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">, 
						<cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#"> )		
				<cf_dbidentity1 datasource="#session.DSN#">
			</cfquery>	
			<cf_dbidentity2 datasource="#session.DSN#" name="insert">
			
			<!----INSERTAR EL DETALLE DEL PAGO EXTRAORDINARIO--->
			<cfset descripcion = '' >
			<cfset referencia = '' >
			
			<cfloop query="rsDatos"><!---Cada linea del detalle (recibos utilizados) ---->
				<cfquery datasource="#session.DSN#">
					insert into DPagosExtraordinarios( 	EPEid, 
														Ecodigo, 
														DPEreferencia, 
														DPEdescripcion, 
														DPEmonto, 
														CFcuenta, 
														Ccuenta, 
														Mcodigo, 
														DPEtc, 
														BMUsucodigo, 
														fechaalta )
					values ( <cfqueryparam cfsqltype="cf_sql_numeric" value="#insert.identity#">, 
							 <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">, 
							 <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsDatos.NoDocumento#">, 
							 <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsDatos.NoDocumento#">, 
							 <cfqueryparam cfsqltype="cf_sql_money" value="#rsDatos.montoAplicado#">, 
							 <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsDatos.CFcuenta#">, 
							 <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsDatos.Ccuenta#">, 
							 <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsDatos.Mcodigo#">, 
							 <cfqueryparam cfsqltype="cf_sql_money" value="#rsDatos.TipoCambio#">, 
							 <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">, 
							 <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">)
				</cfquery>	
				
				<cfset totalMontoDoc = totalMontoDoc + rsDatos.montoAplicado>
	
				<cfset plan.insertarINTARC( session.Ecodigo,
											form.DEid,
											intarc,
											'CCRH',
											rsDatos.NoDocumento,
											rsDatos.NoDocumento,
											rsDatos.montoAplicado,
											'D',
											rsDatos.NoDocumento,
											rsDatos.Ccuenta,
											1 ) >
			</cfloop>
			
			<cfif not isdefined("referencia")>
				<cfset referencia = ltrim(rtrim(form.EPEdocumento))><!----dataDeduccion.Dreferencia --->
				<!---<cfset referencia = rsDatos.NoDocumento>--->
				
			</cfif>
			<cfif not isdefined("descripcion")>
				<cfset descripcion = dataDeduccion.Empleado><!---dataDeduccion.Ddescripcion--->
			</cfif>
				
			<!---<!--- Inserta debitos a cuenta de tipo de deduccion --->
			====== NO hay monto en efectivo ========
			<cfset plan.insertarINTARC( session.Ecodigo,
										form.DEid,
										intarc,
										'CCRH',
										referencia,
										descripcion,
										Replace(form.Dmontopago,',','','all'),
										'D',
										descripcion,
										plan.obtenerCuentaTipo(session.Ecodigo, form.TDid),
										1 ) >--->
		
			<!--- Inserta creditos a cuenta de socio --->
			<!----<cfset totalGlobal = Replace(form.Dmontopago,',','','all') + totalMontoDoc >---->
			<cfset plan.insertarINTARC( session.Ecodigo,
										form.DEid,
										intarc,
										'CCRH',
										referencia,
										descripcion,										
										totalMontoDoc,	<!---totalGlobal,--->
										'C',
										descripcion,
										plan.obtenerCuentaSocio(session.Ecodigo, form.SNcodigo),
										1 ) >
		
			<cfinvoke component="sif.Componentes.CG_GeneraAsiento" method="GeneraAsiento" returnvariable="IDcontable">
				<cfinvokeargument name="Ecodigo" value="#session.Ecodigo#"/>
				<cfinvokeargument name="Oorigen" value="CCRH"/>
				<cfinvokeargument name="Eperiodo" value="#plan.obtenerPeriodo(session.Ecodigo)#"/>
				<cfinvokeargument name="Emes" value="#plan.obtenerMes(session.Ecodigo)#"/>
				<cfinvokeargument name="Efecha" value="#LSParseDateTime(Form.EPEfechadoc)#"/>
				<cfinvokeargument name="Edescripcion" value="CCRH: #form.EPEdocumento#"/>
				<cfinvokeargument name="Edocbase" value="#referencia#"/>
				<cfinvokeargument name="Ereferencia" value="#referencia#"/>
				<cfinvokeargument name="NAP" value="0"/>
			</cfinvoke>
			
			<cfif isdefined("IDcontable") and len(trim(IDcontable))> <!---Si genero el asiento--->
				<cfquery datasource="#session.DSN#">
					update DeduccionesEmpleadoPlan			
					set IDcontable = <cfqueryparam cfsqltype="cf_sql_numeric" value="#IDcontable#">
					where Did = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Did#">
					  and PPnumero = <cfqueryparam cfsqltype="cf_sql_numeric" value="#vPPnumero#">
					  and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
				</cfquery>
			</cfif>

			<!---=============== RECALCULO DE CUOTAS ===============--->
			<cfset form.Dmonto = form.Dmonto - (monto_documentos)>
			<!--- 2. Realiza calculo de cuotas y montos --->
			<cfinclude template="plan-financiamiento.cfm">			
			<!--- 2.1 Monto de la cuota --->
			<cfset vCuota = 0 >
			<cfquery dbtype="query" name="dataCuota" maxrows="1">
				select total
				from calculo
				where pagado = 0
			</cfquery>
			<cfif isdefined("dataCuota.total") and len(trim(dataCuota.total))>
				<cfset vCuota = dataCuota.total >
			</cfif>
		
			<!--- 3. Inserta solo los registros que no han sido pagados y solo si queda saldo --->
			<cfif form.Dmonto gt 0 >
				<cfquery name="calculoNoPagado" dbtype="query">
					select *
					from calculo
					where pagado = 0
				</cfquery>
			
				<cfloop query="calculoNoPagado">
					<cfquery datasource="#session.DSN#">
						insert into DeduccionesEmpleadoPlan( Did, 
														PPnumero, 
														Ecodigo, 
														PPfecha_vence, 
														PPsaldoant, 
														PPprincipal, 
														PPinteres, 
														PPpagoprincipal, 
														PPpagointeres, 
														PPpagomora, 
														PPfecha_pago, 
														Mcodigo, 
														PPtasa, 
														PPtasamora, 
														PPpagado, 
														PPdocumento,
														IDcontable, 
														BMUsucodigo)
						values( <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Did#">,
								<cfqueryparam cfsqltype="cf_sql_integer" value="#calculoNoPagado.PPnumero#">,
								<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">,
								<cfqueryparam cfsqltype="cf_sql_timestamp" value="#calculoNoPagado.fecha#">,  <!--- *** PPfecha_vence --->
								<cfqueryparam cfsqltype="cf_sql_money" value="#Replace(calculoNoPagado.saldoant,',','','all')#">,
								<cfqueryparam cfsqltype="cf_sql_money" value="#Replace(calculoNoPagado.principal,',','','all')#">, <!--- PPprincipal --->
								<cfqueryparam cfsqltype="cf_sql_money" value="#Replace(calculoNoPagado.intereses,',','','all')#">, <!--- PPinteres --->
								0, <!--- PPpagoprincipal --->
								0, <!--- PPpagointeres --->
								0, <!--- PPpagomora --->
								null,
								<cfqueryparam cfsqltype="cf_sql_numeric" value="#dataMoneda.Mcodigo#">,
								<cfqueryparam cfsqltype="cf_sql_numeric" value="#Replace(form.Dtasa,',','','all')#">,
								<cfqueryparam cfsqltype="cf_sql_numeric" value="#Replace(form.Dtasamora,',','','all')#">,
								0, 
								<cfqueryparam cfsqltype="cf_sql_varchar" value="#dataDeduccion.Dreferencia#">,
								<cfif len(trim(rsIDcontable.IDcontable))><cfqueryparam cfsqltype="cf_sql_numeric" value="#rsIDcontable.IDcontable#"><cfelse>null</cfif>,
								<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#"> )
					</cfquery>
				</cfloop>
		
				<cfquery datasource="#session.DSN#">
					update DeduccionesEmpleado
					set Dvalor = <cfqueryparam cfsqltype="cf_sql_money" value="#Replace(vCuota,',','','all')#">,
						Dsaldo = Dsaldo - <cfqueryparam cfsqltype="cf_sql_money" value="#vPrincipal#">
					where Did = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Did#">
					  and DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DEid#">
					  and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
				</cfquery>
			<!--- 4. No hay saldo, inactiva la Deduccion y pone saldo en cero  --->
			<cfelse>
				<cfquery datasource="#session.DSN#">
					update DeduccionesEmpleado
					set Dvalor = 0,
						Dsaldo = 0,
						Dactivo = 0,
						Destado = 0
					where Did = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Did#">
					  and DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DEid#">
					  and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
				</cfquery>
			</cfif>	
			<!---==================== LIMPIAR TABLA ccrhPagoRecibos, para ese usuario y deduccion ====================---->	
			<cfquery datasource="#session.DSN#">
				delete from ccrhPagoRecibos
				where Did  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Did#">
					and DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DEid#">
					and BMUsucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
			</cfquery>
			<cfset form.tipopago = 'PE'><!---Poner el tipo de pago por default--->
			<cfset vs_mensaje = 'Se ha realizado el pago extraordinario satisfactoriamente'>
		<cfelse>
			<cf_errorCode	code = "50204" msg = "No hay detalle del pago extraordinario. Por favor verifique.">
		</cfif>	<!---Fin de si hay detalles--->		
	</cftransaction>	
</cfif>
<cfoutput>
	<cfif len(trim(vs_mensaje))>
		<cfset parametros = parametros & '&vs_mensaje=#vs_mensaje#'>
	</cfif>
	<cflocation url="registroPagosCaja.cfm#parametros#">
</cfoutput>	

