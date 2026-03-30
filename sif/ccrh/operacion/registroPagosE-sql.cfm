<!--- ================================================================================ --->
<!--- PENDIENTES --->
<!--- ================================================================================ --->

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

<!--- Moneda --->
<cfquery name="dataMoneda" datasource="#session.DSN#">
	select Mcodigo 
	from Empresas 
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
</cfquery>

<!--- Deduccion --->
<cfquery datasource="#session.DSN#"  name="dataDeduccion" maxrows="1">
	select Ddescripcion, Dreferencia
	from DeduccionesEmpleado
	where Did = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Did#">
	  and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
</cfquery>

<cfif not isdefined("form.EPEdocumento") or len(trim(form.EPEdocumento)) eq 0>
	<cfset form.EPEdocumento = dataDeduccion.Ddescripcion >
</cfif>

<cfset monto_efectivo = Replace(form.Dmontopago,',','','all')  >
<cfset monto_documentos = Replace(form.Dmontodoc,',','','all')  >
<cfset vPrincipal = monto_efectivo + monto_documentos >
 
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
	
	<!---  Creacin de la tabla INTARC ----->
	<cfset obj  = CreateObject("component", "sif.Componentes.CG_GeneraAsiento") >
	<cfset plan = CreateObject("component", "sif.Componentes.CCRH_PlanPagos") >
	<cfset intarc = obj.CreaIntarc() >
	
	<cfset totalGlobal   = 0 > <!--- monto efectivo + monto documentos --->
	<cfset totalMontoDoc = 0 >

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
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.EPEdocumento#">,
				<cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(Form.EPEfechadoc)#">,
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">, 
				<cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#"> )

		<cf_dbidentity1 datasource="#session.DSN#">
	</cfquery>	
	<cf_dbidentity2 datasource="#session.DSN#" name="insert">

	<!--- Solo si el monto en documentos es mayor que cero --->
	<cfif replace(form.Dmontodoc,',','','all') gt 0 >
		<!--- Si no se digitaron cuentas advierte el error --->
		<cfset Request.Error.Backs = 1>
		<cfif form.Dcantidad lte 0 >
			<cf_errorCode	code = "50205" msg = "No se ha registrado el detalle de cuentas y montos, para el pago en documentos.">
		</cfif> 
	
		<cfset descripcion = '' >
		<cfset referencia = '' >

		<cfloop from="1" to="#form.Dcantidad#" index="i">
			<!--- Deberia validar la existencia de los campos:  DPEdescripcion_, DPEreferencia_, DPEmonto_, CCuenta_, CFcuenta_ --->

			<cfset descripcion = form['DPEdescripcion_#i#'] >
			<cfset referencia = form['DPEreferencia_#i#'] >

			<cfset vMontoDoc = Replace(form['DPEmonto_#i#'],',','','all') * Replace(form['DPEtc'],',','','all') >  <!--- monto en moneda local --->
			<cfset totalMontoDoc = totalMontoDoc + vMontoDoc >
		
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
						 <cfqueryparam cfsqltype="cf_sql_varchar" value="#form['DPEreferencia_#i#']#">, 
						 <cfqueryparam cfsqltype="cf_sql_varchar" value="#form['DPEdescripcion_#i#']#">, 
						 <cfqueryparam cfsqltype="cf_sql_money" value="#vMontoDoc#">, 
						 <cfqueryparam cfsqltype="cf_sql_numeric" value="#form['CFcuenta_#i#']#">, 
						 <cfqueryparam cfsqltype="cf_sql_numeric" value="#form['Ccuenta_#i#']#">, 
						 <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Mcodigo#">, 
						 <cfqueryparam cfsqltype="cf_sql_money" value="#Replace(form.DPEtc,',','','all')#">, 
						 <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">, 
						 <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#"> )
			</cfquery>		 

			<cfset plan.insertarINTARC( session.Ecodigo,
										form.DEid,
										intarc,
										'CCRH',
										form['DPEreferencia_#i#'],
										form['DPEreferencia_#i#'],
										vMontoDoc,
										'D',
										form['DPEdescripcion_#i#'],
										form['Ccuenta_#i#'],
										1 ) >
		</cfloop>
		<!--- Valida que el monto de pago en documentos, coincida con la sumatoria de montos dados en el detalle --->
		<cfif monto_documentos neq totalMontoDoc >
			<cf_errorCode	code = "50206" msg = "El monto total en documentos es diferente a la sumatoria de los montos registrados por cada cuenta.">
		</cfif>
	</cfif>		<!--- *** if si monto docs es mayor a cero (por aquello ver linea 257 )--->
	
	<cfif not isdefined("referencia")>
		<cfset referencia = dataDeduccion.Dreferencia >
	</cfif>
	<cfif not isdefined("descripcion")>
		<cfset descripcion = dataDeduccion.Ddescripcion >
	</cfif>
		
	<!--- Inserta debitos a cuenta de tipo de deduccion --->
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
								1 ) >

	<!--- Inserta creditos a cuenta de socio --->
	<cfset totalGlobal = Replace(form.Dmontopago,',','','all') + totalMontoDoc >
	<cfset plan.insertarINTARC( session.Ecodigo,
								form.DEid,
								intarc,
								'CCRH',
								referencia,
								descripcion,
								totalGlobal,
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
	</cfinvoke>
	<cfif isdefined("IDcontable") and len(trim(IDcontable)) >
		<cfquery datasource="#session.DSN#">
			update DeduccionesEmpleadoPlan			
			set IDcontable = <cfqueryparam cfsqltype="cf_sql_numeric" value="#IDcontable#">
			where Did = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Did#">
			  and PPnumero = <cfqueryparam cfsqltype="cf_sql_numeric" value="#vPPnumero#">
			  and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		</cfquery>
	</cfif>

<!--- *********** aqui cerraba el if qu epreguntaba si monto docs era mayor que cero --->	
	

	<!--- RECALCULAR PLAN DE PAGOS --->
	<!--- 1. Recalcula monto (saldo), para tomar en cuenta el pago registrado --->
	<cfset form.Dmonto = form.Dmonto - (monto_efectivo+monto_documentos) >
	
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
</cftransaction>

<cfoutput>
<cfset parametros = "?Did=#form.Did#&DEid=#form.DEid#&TDid=#form.TDid#">
<cflocation url="registroPagosE.cfm#parametros#">
</cfoutput>

