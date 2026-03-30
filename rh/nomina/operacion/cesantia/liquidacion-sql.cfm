<cfif isdefined("form.Aplicar") and isdefined("form.btnEliminar") and form.btnEliminar eq 0 >
	<cflocation url="liquidacion-resumen.cfm">
</cfif>

<cfif isdefined("form.Aplicar") >
	<!--- 1. Query que devuelve los empleados que aplican para liquidacion de cesantia --->

	<!--- 1.1 Determinar fecha de corte --->
	<cfset fecha_corte = LSDateFormat(now(), 'dd/mm/yyyy') >
	<cfif isdefined("form.fecha_corte") and len(trim(form.fecha_corte)) >
		<cfset fecha_corte = form.fecha_corte >	
	</cfif>
	
	<!--- 1.2 Determinar meses de antiguedad para ser considerados --->
	<cfset meses = 96 >
	<cfif isdefined("form.meses") and len(trim(form.meses)) >
		<cfset meses = form.meses >	
	</cfif>
	
	<!--- funciones del select --->
	<cf_dbfunction name="to_date" args="'#fecha_corte#'" returnvariable="db_fecha_corte">
	<cfset cual_fecha = "( select case when ev2.EVfliquidacion > ev2.EVfantig then ev2.EVfliquidacion else ev2.EVfantig end from EVacacionesEmpleado ev2 where ev2.DEid=ve.DEid )" >
	<cf_dbfunction name="datediff" args="#cual_fecha#|#db_fecha_corte#|mm" delimiters="|" returnvariable="datediff_select">
	<!--- funciones del where --->
	<cf_dbfunction name="datediff" args="#cual_fecha#|#db_fecha_corte#|mm" delimiters="|" returnvariable="datediff_where">
	
	<cfquery name="data_calculo" datasource="#session.DSN#">
		select 	ve.DEid, 
				#cual_fecha# as fecha, 
				#preservesinglequotes(datediff_select)# as antiguedad
	
		from EVacacionesEmpleado ve
	
		inner join DatosEmpleado de
		on de.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		and de.DEid=ve.DEid
		
		<cfif isdefined("form.chk_centro") and isdefined("form.CFid") and len(trim(form.CFid))>
			<!--- empleado debe estar nombrado --->
			where exists( select 1
						  from LineaTiempo lt, RHPlazas p
						  where <cfqueryparam cfsqltype="cf_sql_date" value="#LSParsedateTime(fecha_corte)#"> between lt.LTdesde and lt.LThasta
							and lt.DEid=ve.DEid
							and p.RHPid=lt.RHPid
							and p.CFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CFid#"> )
		<cfelse>
			<!--- empleado debe estar nombrado --->
			where exists( select 1
						  from LineaTiempo lt
						  where <cfqueryparam cfsqltype="cf_sql_date" value="#LSParsedateTime(fecha_corte)#"> between lt.LTdesde and lt.LThasta
							and lt.DEid=ve.DEid	 )
		</cfif>

		<!--- empleado con mas de n años, siempre va esta condicion  --->
		and #preservesinglequotes(datediff_where)# >= <cfqueryparam cfsqltype="cf_sql_integer" value="#meses#">
		
		<cfif isdefined("form.chk_empleado") and isdefined("form.DEid") and len(trim(form.DEid))>
			and ve.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DEid#">
		</cfif>
	</cfquery>
	
	<!--- 2. Parametro 940: Concepto Incidente para llamado a la calculadora --->
	<cfquery name="data_parametro_940" datasource="#session.DSN#">
		select Pvalor as CIid
		from RHParametros
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
		and Pcodigo = 940
	</cfquery>
	<cfif not len(trim(data_parametro_940.CIid))>
		<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		Key="LB_Msg_1"
		Default="Error. No ha sido definido el Concepto Incidente para C&aacute;lculo de Cesant&iacute;a por renuncia."
		returnvariable="LB_Msg_1"/> 
		
		<cf_throw message="#LB_Msg_1#" errorCode="1160">
	</cfif>
	<cfquery name="data_concepto" datasource="#Session.DSN#">
		select c.CIid, 
			   c.CIcantidad, c.CIrango, c.CItipo, c.CIcalculo, c.CIdia, c.CImes
		from CIncidentesD c
		where c.CIid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#data_parametro_940.CIid#">
	</cfquery>

	<!--- 3. Parametro 950: Tipo de Accion para llamado a la calculadora --->
	<cfquery name="data_parametro_950" datasource="#session.DSN#">
		select Pvalor as RHTid
		from RHParametros
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
		and Pcodigo = 950
	</cfquery>
	<cfif not len(trim(data_parametro_950.RHTid))>
		<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		Key="LB_Msg_2"
		Default="Error. No ha sido definido el Tipo de Accion para el C&aacute;lculo de Cesant&iacute;a por renuncia."
		returnvariable="LB_Msg_2"/>
		<cf_throw message="#LB_Msg_2#"  errorCode="1165">
	</cfif>
	
	<!--- 4. Include calculadora --->
	<cfset RH_Calculadora = createobject("component","rh.Componentes.RH_Calculadora")>

	<!--- 5. borra e inserta en la tabla de trabajo --->
	<cfquery datasource="#session.DSN#">
		delete RHCesantiaLiquidacion 
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		and RHCLaprobada = 0
	</cfquery>

	<!--- 6. Ciclo para procesar empleados --->
	<cfloop query="data_calculo">
		<!--- 6.1 Calcula el porcentaje segun la antiguedad que se le va a pagar sobre la cesantia --->
		<cfquery name="data_porcentaje" datasource="#session.DSN#">
			select coalesce(max(RHCMporcentaje), 0) as porcentaje
			from RHCesantiaMes
			where RHCMmes <= <cfqueryparam cfsqltype="cf_sql_float" value="#data_calculo.antiguedad#">
		</cfquery>
		<cfset v_porcentaje = data_porcentaje.porcentaje >
		
		<!--- 6.2 Nomina del empleado, necesario para la calculadora  --->
		<cfquery name="data_nomina" datasource="#session.DSN#">
			select Tcodigo
			from LineaTiempo
			where DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#data_calculo.DEid#">
			and <cfqueryparam cfsqltype="cf_sql_date" value="#now()#"> between LTdesde and LThasta
		</cfquery>
		<cfset Tcodigo = data_nomina.Tcodigo >
	
		<!--- 6.3 Invocacion a la calculadora --->
		<cfset FVigencia = fecha_corte >
		<cfset FFin = fecha_corte >

			<cfset current_formulas = data_concepto.CIcalculo>
			<cfset presets_text = RH_Calculadora.get_presets(CreateDate(ListGetAt(FVigencia,3,'/'), ListGetAt(FVigencia,2,'/'), ListGetAt(FVigencia,1,'/')),
										   CreateDate(ListGetAt(FFin,3,'/'), ListGetAt(FFin,2,'/'), ListGetAt(FFin,1,'/')),
										   data_concepto.CIcantidad,
										   data_concepto.CIrango,
										   data_concepto.CItipo,
										   data_calculo.DEid,
										   1,
										   session.Ecodigo,
										   data_parametro_950.RHTid,
										   0,
										   data_concepto.CIdia,
										   data_concepto.CImes,
										   Tcodigo, <!---Tcodigo solo se requiere si no va RHAlinea--->
										   FindNoCase('SalarioPromedio', current_formulas), <!---optimizacion - SalarioPromedio es el calculo más pesado--->
										   'false',
										   '',
										   'false'   )>
			<cfset values = RH_Calculadora.calculate( presets_text & ";" & current_formulas )>
			<cfset calc_error = RH_Calculadora.getCalc_error()>
			<cfif Not IsDefined("values")>
				<cfif isdefined("presets_text")>
					<cf_throw detail="#presets_text# & '----' & #current_formulas# & '-----' & #calc_error#"  errorCode="1000">
				<cfelse>
					<cf_throw detail="#calc_error#"  errorCode="1000">
				</cfif>
			</cfif>

			<!--- 6.4 Calcula los saldos iniciales del mes abierto, siempre hay un mes abierto para los empleados UNO SOLO A LA VEZ para un DClinea (se supone qu esolo va a haber un dclinea para provisionar), el proceso lo garantiza--->
			<cfquery name="data_saldos" datasource="#session.DSN#">
				select RHCSsaldoInicial as saldo_inicial, 
					   RHCSsaldoInicialInt as saldo_interes_inicial, 
					   RHCSperiodo as periodo_abierto,
					   RHCSmes as mes_abierto,
					   DClinea

				from RHCesantiaSaldos cs
				where DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#data_calculo.DEid#">
				
				and RHCScerrado=0
				and RHCSliquidado=0
			</cfquery>
			
			<!--- 6.5 Validacion de variables --->
			<cfset v_saldo_inicial     = 0 >
			<cfset v_saldo_inicial_int = 0 >
			<cfset v_mes		       = 0 >
			<cfset v_periodo		   = 0 >
			<cfset v_mes_abierto       = 0 >
			<cfset v_periodo_abierto   = 0 >
			<cfset v_dclinea           = 0 >
			<cfif data_saldos.recordcount gt 0>
				<cfif len(trim(data_saldos.saldo_inicial ))>
					<cfset v_saldo_inicial = data_saldos.saldo_inicial >
				</cfif>
				<cfif len(trim(data_saldos.saldo_interes_inicial ))>
					<cfset v_saldo_inicial_int = data_saldos.saldo_interes_inicial >
				</cfif>
				<cfif len(trim(data_saldos.mes_abierto ))>
					<cfset v_mes_abierto = data_saldos.mes_abierto >
				</cfif>
				<cfif len(trim(data_saldos.periodo_abierto ))>
					<cfset v_periodo_abierto = data_saldos.periodo_abierto >
				</cfif>
				<cfif len(trim(data_saldos.dclinea ))>
					<cfset v_dclinea = data_saldos.dclinea >
				</cfif>
			</cfif>
			
			<cfif v_mes_abierto eq 1>
				<cfset v_mes = 12 >
				<cfset v_periodo = v_periodo_abierto - 1 >
			<cfelseif v_mes_abierto gt 1 >
				<cfset v_mes = v_mes_abierto - 1 >
				<cfset v_periodo = v_periodo_abierto >
			</cfif>
			
			<cfset v_referencia = (((v_periodo*100)+v_mes)*100)+1 >
			<cfif v_referencia eq 1 >
				<cfset v_referencia = 0 >
			</cfif>
			
			<cfset v_cesantia		  = iif( len(trim(values.get('resultado').toString())), values.get('resultado').toString(), '0') >
			<cfset v_cantidad_dias 	  = iif( len(trim(values.get('cantidad').toString())), values.get('cantidad').toString(), '0') >
			<cfset v_salario_promedio = iif( len(trim(values.get('importe').toString())), values.get('importe').toString(), '0') >

			<!--- 6.6 Insertar en tabla de trabajo --->
			<cfquery datasource="#session.DSN#">
				insert into RHCesantiaLiquidacion( 	Ecodigo, 
													DEid, 
													DClinea, 
													RHCLperiodo, 
													RHCLmes, 
													RHCLmontoCesantia, 
													RHCLmontoInteres, 
													RHCLreferencia, 
													RHCLfechaliq,
													RHCLfechaliqAnterior,
													BMUsucodigo,
													RHCLperiodoAbierto,
													RHCLmesAbierto,
													RHCLsaldoInicial,
													RHCLsaldoInicialInt,	
													RHCLantiguedad,
													RHCLporcentaje,
													RHCLcantidadDias,
													RHCLsalarioPromedio )
				values( <cfqueryparam cfsqltype="cf_sql_integer" 	value="#session.Ecodigo#">,
						<cfqueryparam cfsqltype="cf_sql_numeric" 	value="#data_calculo.DEid#">,
						<cfqueryparam cfsqltype="cf_sql_numeric" 	value="#v_dclinea#">,
						<cfqueryparam cfsqltype="cf_sql_integer"   		value="#v_periodo#">,
						<cfqueryparam cfsqltype="cf_sql_integer"   		value="#v_mes#">,
						<cfqueryparam cfsqltype="cf_sql_money" 		value="#v_cesantia#">,
						<cfqueryparam cfsqltype="cf_sql_money" 		value="#(v_saldo_inicial_int*v_porcentaje)/100#">,
						<cfqueryparam cfsqltype="cf_sql_integer" 	value="#v_referencia#">, 
						<cfqueryparam cfsqltype="cf_sql_date" 		value="#LSParsedateTime(fecha_corte)#">,
						<cfqueryparam cfsqltype="cf_sql_date" 		value="#data_calculo.fecha#">,
						<cfqueryparam cfsqltype="cf_sql_numeric"	value="#session.Usucodigo#">,
						<cfqueryparam cfsqltype="cf_sql_integer"   		value="#v_periodo_abierto#">,
						<cfqueryparam cfsqltype="cf_sql_integer"   		value="#v_mes_abierto#">,
						<cfqueryparam cfsqltype="cf_sql_money" 		value="#v_saldo_inicial#">,
						<cfqueryparam cfsqltype="cf_sql_money" 		value="#v_saldo_inicial_int#">,
						<cfqueryparam cfsqltype="cf_sql_float" 		value="#data_calculo.antiguedad#">,
						<cfqueryparam cfsqltype="cf_sql_float" 		value="#v_porcentaje#">,
						<cfqueryparam cfsqltype="cf_sql_money" 		value="#v_cantidad_dias#">,
						<cfqueryparam cfsqltype="cf_sql_money" 		value="#v_salario_promedio#"> )
			</cfquery>
	</cfloop>
	
	<!--- 7. Borra los empleados cuyos montos son cero --->
	<cfquery datasource="#session.DSN#">
		delete RHCesantiaLiquidacion
		where RHCLmontoCesantia+RHCLmontoInteres = 0 
		  and RHCLaprobada = 0
	</cfquery>
	
	<cflocation url="liquidacion-resumen.cfm">
</cfif>

<cfif isdefined("form.Aprobar") or isdefined("form.AprobarTodos")>
	<cfif isdefined("form.Aprobar") and isdefined("form.chk")>
		<cfset lista_deid = form.chk >
	</cfif>
	
	<!--- 1. recupera el parametro 820: incidencia para liquidacion de cesantia --->
	<cfquery name="rs_parametro820" datasource="#session.DSN#">
		select Pvalor
		from RHParametros
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		  and Pcodigo = 820
	</cfquery>
	<cfif not len(trim(rs_parametro820.Pvalor))>
		<cfinvoke component="sif.Componentes.Translate"
			method="Translate"
			Key="MSG_Error._Debe_definir_la_incidencia_para_Liquidacion_de_Cesantia"
			xmlfile="/rh/nomina/operacion/cesantia/liquidacion.xml"	
			Default="Error. Debe definir la incidencia para Liquidaci&oacute;n de Cesant&iacute;a."	
			returnvariable="vError"/>	
		<cf_throw detail="#vError#"  errorCode="1170">
	</cfif>
	
	<!--- MODIFICA registros para poner aprobadas las liquidaciones --->
	<cftransaction>
		<!--- MARCAR LOS REGISTROS COMO LIQUIDADOS --->
		<!--- los registros que fueron procesados deben quedar como liquidados  modificar aqui la tabla de saldos --->
		<cfquery datasource="#session.DSN#"	>
			update RHCesantiaSaldos 
			set RHCSliquidado = 1
			where exists (	select 1 
							from RHCesantiaLiquidacion lm
							where lm.RHCLaprobada = 0
							  and lm.DEid=RHCesantiaSaldos.DEid
							  and lm.RHCLreferencia  >= (((RHCesantiaSaldos.RHCSperiodo*100)+RHCesantiaSaldos.RHCSmes)*100)+01
						)
						
			<!--- liquida solo los que se marcaron de la lista --->
			<cfif isdefined("form.Aprobar")>
				<cfif isdefined("lista_deid") and len(trim(lista_deid))>
					and DEid in (#lista_deid#)
				<cfelse>
					and DEid = 0
				</cfif>
			</cfif>
						
		</cfquery>

		<!--- PROBLEMA: Si en un mismo dia hacen varias liquidaciones el reporte final de la liquidacion muestra los empleados de
						todas las liquidaciones, esto no es correcto, deberia mostrar solo lo que acabo de liquidar
			  SOLUCION: Poner un campo de lote para detrminar en que orden del dia fueron hechas las liquidaciones e indicarle al reporte
						cual lote desplegar
		--->
		<cfset v_lote = 1 >
		<cfquery name="rs_lote" datasource="#session.DSN#" >
			select coalesce(max(RHCLBlote), 1) as lote
			from RHCesantiaLiqBitacora
		</cfquery>
		<cfif len(trim(rs_lote.lote))>
			<cfset v_lote = rs_lote.lote + 1 >
		</cfif>

		<cfquery datasource="#session.DSN#">
			insert RHCesantiaLiqBitacora( DEid, 
										  DClinea, 
										  RHCLBfecha, 
										  RHCLBtipo, 
										  RHCLBmontocesantia, 
										  RHCLBmontointeres, 
										  BMUsucodigo,
										  RHCLBlote,
										  RHCLBperiodo,
										  RHCLBmes )
										  
			select 	cl.DEid, 
					cl.DClinea, 
					<cfqueryparam cfsqltype="cf_sql_date" value="#now()#">,
					2,
					sum(cl.RHCLmontoCesantia),
					 sum(cl.RHCLmontoInteres),
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">,
					<cfqueryparam cfsqltype="cf_sql_integer" value="#v_lote#">,
					cl.RHCLperiodo, cl.RHCLmes
	
			from RHCesantiaLiquidacion cl
	
			where cl.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			  and cl.RHCLaprobada = 0
			<cfif isdefined("form.Aprobar")>
				<cfif isdefined("lista_deid") and len(trim(lista_deid))>
					and cl.DEid in (#lista_deid#)
				<cfelse>
					and cl.DEid = 0
				</cfif>
			</cfif>
			
			group by cl.DEid, cl.DClinea, cl.RHCLperiodo, cl.RHCLmes
		</cfquery>
	
		<!--- REPROCESO SALDOS Y TRANSACCIONES --->
		<!--- AQUI SE DEBE PONER EL REGISTRO DE SALDOS EN CERO --->
		<!--- SIEMPRE VA A EXISTIR UN MES ABIERTO EN EL PUNTO DONDE SE HAGA LA LIQUIDACION --->
		<!--- 1. INSERTAR TRANSACCIONES NEGATIVAS PARA SALDAR MONTOS --->
		<!---    DEBEN SER POR EL MONTO DE LA LIQUIDACION PARA NO AFECTAR MOVIMIENTOS DEL MES YA REGISTRADOS --->
		<!--- 	 Y DEBEN SER POR EL MES	ACTUAL PARA LLEGAR A LOS SALDOS EN CERO --->
	
		<!--- poner transaccion negativa inserta aportes --->
		<cfquery datasource="#session.DSN#" >
			insert into RHCesantiaTransacciones(DEid, DClinea, RHCTperiodo, RHCTmes, RHCTtipo, RHCTmonto, RHCTfecha, BMUsucodigo)
			select 	DEid, 
					DClinea, 
					RHCLperiodo, 
					RHCLmes, 
					0, 
					sum(RHCLsaldoInicial)*-1, 
					<cfqueryparam cfsqltype="cf_sql_date" value="#now()#">, 
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">
			from RHCesantiaLiquidacion
			where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			  and RHCLaprobada = 0
			  and DClinea > 0
			<cfif isdefined("form.Aprobar")>
				<cfif isdefined("lista_deid") and len(trim(lista_deid))>
					and DEid in (#lista_deid#)
				<cfelse>
					and DEid = 0
				</cfif>
			</cfif>
			
			group by DEid, DClinea, RHCLperiodo, RHCLmes
		</cfquery>

		<!--- inserta intereses --->
		<cfquery datasource="#session.DSN#">
			insert into RHCesantiaTransacciones(DEid, DClinea, RHCTperiodo, RHCTmes, RHCTtipo, RHCTmonto, RHCTfecha, BMUsucodigo)
			select 	DEid, 
					DClinea, 
					RHCLperiodo, 
					RHCLmes, 
					1, 
					sum(RHCLsaldoInicialInt)*-1, 
					<cfqueryparam cfsqltype="cf_sql_date" value="#now()#">, 
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">
			from RHCesantiaLiquidacion
			where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			  and RHCLaprobada = 0
			  and DClinea > 0
			<cfif isdefined("form.Aprobar")>
				<cfif isdefined("lista_deid") and len(trim(lista_deid))>
					and DEid in (#lista_deid#)
				<cfelse>
					and DEid = 0
				</cfif>
			</cfif>
			
			group by DEid, DClinea, RHCLperiodo, RHCLmes
		</cfquery>

		<!--- modifica saldos --->
		<cfquery datasource="#session.DSN#">
			update RHCesantiaSaldos 
			set RHCSmontoMes= RHCSmontoMes - (	select sum(cl.RHCLsaldoInicial)
												from RHCesantiaLiquidacion cl
												where cl.RHCLaprobada = 0
												and cl.DEid=RHCesantiaSaldos.DEid
												and cl.DClinea=RHCesantiaSaldos.DClinea
												and cl.RHCLperiodo=RHCesantiaSaldos.RHCSperiodo
												and cl.RHCLmes=RHCesantiaSaldos.RHCSmes), 
				 RHCSmontoMesInt = RHCSmontoMesInt - (	select sum(cl.RHCLsaldoInicialInt)
														from RHCesantiaLiquidacion cl
														where cl.RHCLaprobada = 0
														and cl.DEid=RHCesantiaSaldos.DEid
														and cl.DClinea=RHCesantiaSaldos.DClinea
														and cl.RHCLperiodo=RHCesantiaSaldos.RHCSperiodo
														and cl.RHCLmes=RHCesantiaSaldos.RHCSmes)
			where exists ( 	  select 1
							  from RHCesantiaLiquidacion cl
							  where cl.RHCLaprobada = 0
							  and cl.DEid=RHCesantiaSaldos.DEid
							  and cl.DClinea=RHCesantiaSaldos.DClinea
							  and cl.RHCLperiodo=RHCesantiaSaldos.RHCSperiodo
							  and cl.RHCLmes=RHCesantiaSaldos.RHCSmes	 )
			and RHCScerrado = 1
			<cfif isdefined("form.Aprobar")>
				<cfif isdefined("lista_deid") and len(trim(lista_deid))>
					and DEid in (#lista_deid#)
				<cfelse>
					and DEid = 0
				</cfif>
			</cfif>
		</cfquery>
		
		

		<!--- REGENERAR PARA EL MES QUE SE ESTA CERRANDO --->
		<cfquery name="rsMonthsToReproc" datasource="#session.dsn#">
			select distinct DEid, DClinea, RHCLperiodo as periodo, RHCLmes as mes
			from RHCesantiaLiquidacion
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			  and RHCLaprobada = 0
			<cfif isdefined("form.Aprobar")>
				<cfif isdefined("lista_deid") and len(trim(lista_deid))>
					and DEid in (#lista_deid#)
				<cfelse>
					and DEid = 0
				</cfif>
			</cfif>
			
		</cfquery>
		<cfloop query="rsMonthsToReproc">
			<cfinvoke component="rh.Componentes.RH_Cesantia" method="CierreMes">
				<cfinvokeargument name="ActualPeriod" 	value="#rsMonthsToReproc.periodo#" >
				<cfinvokeargument name="ActualMonth" 	value="#rsMonthsToReproc.mes#" >
				<cfinvokeargument name="DEid" 			value="#rsMonthsToReproc.DEid#" >
				<cfinvokeargument name="Reproc" 		value="true" >
				<cfinvokeargument name="liquidacion" 	value="true" >
				<cfinvokeargument name="DClinea" 		value="#rsMonthsToReproc.DClinea#" >
			</cfinvoke> 
		</cfloop>

		<cfquery datasource="#session.DSN#"	>
			update EVacacionesEmpleado
			set EVfliquidacion = (	select min(RHCLfechaliq)
									from RHCesantiaLiquidacion cl
									where cl.RHCLaprobada = 0
								  	   and cl.DEid=EVacacionesEmpleado.DEid)
			<cfif isdefined("form.Aprobar")>
				<cfif isdefined("lista_deid") and len(trim(lista_deid))>
					where DEid in (#lista_deid#)
				<cfelse>
					where DEid = 0
				</cfif>
			<cfelse>
				where exists ( 	select 1
								from RHCesantiaLiquidacion cl
								where cl.RHCLaprobada = 0
								  and cl.DEid=EVacacionesEmpleado.DEid )
			</cfif>
	
		</cfquery>
		
		<cfquery datasource="#session.DSN#" >
			update RHCesantiaLiquidacion
			set RHCLaprobada = 1
			where RHCLaprobada = 0
			  and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			<cfif isdefined("form.Aprobar")>
				<cfif isdefined("lista_deid") and len(trim(lista_deid))>
					and DEid in (#lista_deid#)
				<cfelse>
					and DEid = 0
				</cfif>
			</cfif>
		</cfquery>
		
	</cftransaction>
	<cflocation url="liquidacion-fin.cfm?lote=#v_lote#">
</cfif>