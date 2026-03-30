<cfcomponent>
	<cffunction name="CierreMes" access="public">
		<cfargument name="ActualPeriod" 	required="true" 	type="Numeric">
		<cfargument name="ActualMonth" 		required="true" 	type="Numeric">
		<cfargument name="DEid" 			required="false" 	type="Numeric" 	default="-1">
		<cfargument name="Reproc" 			required="false" 	type="Boolean" 	default="false">
		<cfargument name="liquidacion"		required="false" 	type="Boolean" 	default="false">
		<cfargument name="DClinea"			required="false" 	type="numeric">
	
		<!--- <cfdump var="#arguments#"> --->
		<cfset NextPeriod = ActualPeriod>
		<cfset NextMonth = ActualMonth + 1>
		<cfif NextMonth EQ 13>
			<cfset NextPeriod = ActualPeriod + 1>
			<cfset NextMonth = 1>
		</cfif>
	
		<!---************************************************************************--->
		<!---******************* INICIO DEL PROCESO CIERRE DE MES *******************--->
		<!--- calculo de intereses a para inicio de mes --->
		<!--- se agrega este if, pues si estoy liquidando no necesito recalcular montos por interes.--->
		<cfquery datasource="#session.dsn#">
			update RHCesantiaSaldos
			set RHCSmontoMesInt = coalesce((RHCSsaldoInicial+RHCSsaldoInicialInt) / 100 * (	select DCporcInteres
																							from DCargas
																							where DClinea = RHCesantiaSaldos.DClinea )
										   , 0.00)
			where RHCSperiodo = <cfqueryparam cfsqltype="cf_sql_integer" value="#ActualPeriod#">
			  and RHCSmes = <cfqueryparam cfsqltype="cf_sql_integer" value="#ActualMonth#">
				<cfif Not Reproc>
					and RHCScerrado = 0
				</cfif>
				<cfif isdefined("Arguments.DEid") and Arguments.DEid GT 0>
					and DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.DEid#">
				</cfif>
		</cfquery>
		
		<cfquery datasource="#session.dsn#">
			update RHCesantiaSaldos
			set RHCSsaldoInicial = coalesce((
				select RHCSsaldoInicial + RHCSmontoMes
				from RHCesantiaSaldos ref
				where ref.DEid = RHCesantiaSaldos.DEid
				  and ref.DClinea = RHCesantiaSaldos.DClinea
				  and ref.RHCSperiodo = <cfqueryparam cfsqltype="cf_sql_integer" value="#ActualPeriod#">
				  and ref.RHCSmes = <cfqueryparam cfsqltype="cf_sql_integer" value="#ActualMonth#">
			),0.00)
			, RHCSsaldoInicialInt = coalesce((
				select RHCSsaldoInicialInt + RHCSmontoMesInt
				from RHCesantiaSaldos ref
				where ref.DEid = RHCesantiaSaldos.DEid
				  and ref.DClinea = RHCesantiaSaldos.DClinea
				  and ref.RHCSperiodo = <cfqueryparam cfsqltype="cf_sql_integer" value="#ActualPeriod#">
				  and ref.RHCSmes = <cfqueryparam cfsqltype="cf_sql_integer" value="#ActualMonth#">
	
			),0.00)
			where RHCSperiodo = <cfqueryparam cfsqltype="cf_sql_integer" value="#NextPeriod#">
			  and RHCSmes = <cfqueryparam cfsqltype="cf_sql_integer" value="#NextMonth#">
			  <cfif Not Reproc>
				and RHCScerrado = 0
			  </cfif>
			  <cfif isdefined("Arguments.DEid") and Arguments.DEid GT 0>
				and DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.DEid#">
			  </cfif>
		</cfquery>
		
		<!--- SOLO CUANDO SE ESTA LIQUIDANDO --->
		<!--- Este proceso esta recalculando intereses al inicio, y para el proceso de liquidacion los datos pueden estar
			  incorectos, pues se elimina el ajuste para que el saldo inicial de este mes sea cero y se da que el interes 
			  inicial para este mes, empieze con el acumulado de intereses, lo cual es incorrecto. 
			  De igual manera si hay un movimiento fuera de tiempo (osea se cerro y se agrego un nuevo movimiento), eso 
			  quedaria reflejado en el interes de inicio del mes. Esto se va a agregar a la liquidacion para no arrastrar
			  movimientos.
		--->
		<cfif arguments.liquidacion >
			<!--- 1. monto de intereses calculado --->
			<cfquery name="rs_monto" datasource="#session.DSN#" >
				select a.RHCSsaldoInicialInt
				from RHCesantiaSaldos a
				where a.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.DEid#" >
				  and a.DClinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.DClinea#" >
				  and a.RHCSperiodo = <cfqueryparam cfsqltype="cf_sql_integer" value="#NextPeriod#" >
				  and a.RHCSmes = <cfqueryparam cfsqltype="cf_sql_numeric" value="#NextMonth#" >
			</cfquery>

			<!--- 2. monto de intereses calculado en la liquidacion --->
			<cfquery name="rs_monto_liq" datasource="#session.DSN#" >
				select a.RHCSmontoMesInt
				from RHCesantiaSaldos a
				where a.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.DEid#" >
				  and a.DClinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.DClinea#" >
				  and a.RHCSperiodo = <cfqueryparam cfsqltype="cf_sql_integer" value="#ActualPeriod#" >
				  and a.RHCSmes = <cfqueryparam cfsqltype="cf_sql_numeric" value="#ActualMonth#" >
			</cfquery>

			<cfif len(trim(rs_monto.RHCSsaldoInicialInt)) and len(trim(rs_monto_liq.RHCSmontoMesInt)) >
				<cfset saldo_inicial_int = rs_monto.RHCSsaldoInicialInt - rs_monto_liq.RHCSmontoMesInt >

				<!--- ajusta el saldo de mes de los intereses --->
				<cfquery datasource="#session.DSN#">
					update RHCesantiaSaldos
					set RHCSmontoMesInt = -<cfqueryparam cfsqltype="cf_sql_money" value="#saldo_inicial_int#">
					where DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.DEid#" >
					  and DClinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.DClinea#" >
					  and RHCSperiodo = <cfqueryparam cfsqltype="cf_sql_integer" value="#ActualPeriod#" >
					  and RHCSmes = <cfqueryparam cfsqltype="cf_sql_numeric" value="#ActualMonth#" >
				</cfquery>
				<cfquery datasource="#session.DSN#">
					update RHCesantiaSaldos
					set RHCSsaldoInicialInt = 0
					where DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.DEid#" >
					  and DClinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.DClinea#" >
					  and RHCSperiodo = <cfqueryparam cfsqltype="cf_sql_integer" value="#NextPeriod#" >
					  and RHCSmes = <cfqueryparam cfsqltype="cf_sql_numeric" value="#NextMonth#" >
				</cfquery>
			
				<!---
				<!--- Hubo un movimiento (positivo o negativo) antes de cerrar la liquidacion pero estando ya calculada la misma, 
				      por eso se ajusta de nuevo la liquidacion, para reflejar esto --->
				<!--- movimiento positivo --->
				<cfif saldo_inicial_int gt 0 >
									
				<!--- movimiento negativo --->
				<cfelseif saldo_inicial_int lt 0>
				</cfif>
				--->
				
			</cfif>
		</cfif>

		<cfif Not Reproc>
			<!--- inserta transaccion de intereses --->		
			<cfquery datasource="#session.DSN#">
				insert into RHCesantiaTransacciones( DEid, DClinea, RHCTperiodo, RHCTmes, RHCTtipo, RHCTmonto, RHCTfecha, BMUsucodigo)
				select DEid, DClinea, RHCSperiodo, RHCSmes, 1, RHCSmontoMesInt, <cfqueryparam cfsqltype="cf_sql_date" value="#now()#">, #session.Usucodigo#
				from RHCesantiaSaldos
				where RHCSperiodo = <cfqueryparam cfsqltype="cf_sql_integer" value="#ActualPeriod#">
				  and RHCSmes = <cfqueryparam cfsqltype="cf_sql_integer" value="#ActualMonth#">
				  and RHCScerrado = 0
			</cfquery>

			<cfquery datasource="#session.dsn#">
				insert into RHCesantiaSaldos 
					(DEid, DClinea, 
					RHCSperiodo, RHCSmes, 
					RHCSsaldoInicial, RHCSmontoMes, 
					RHCSsaldoInicialInt, RHCSmontoMesInt, 
					BMUsucodigo)
				select 
					DEid, DClinea, 
					<cfqueryparam cfsqltype="cf_sql_integer" value="#NextPeriod#">, 
					<cfqueryparam cfsqltype="cf_sql_integer" value="#NextMonth#">, 
					RHCSsaldoInicial + RHCSmontoMes, 0.00, 
					RHCSsaldoInicialInt + RHCSmontoMesInt, 0.00, 
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">
				from RHCesantiaSaldos 
				where RHCSperiodo = <cfqueryparam cfsqltype="cf_sql_integer" value="#ActualPeriod#">
				  and RHCSmes = <cfqueryparam cfsqltype="cf_sql_integer" value="#ActualMonth#">
				  and not exists(
					select 1
					from RHCesantiaSaldos ref
					where ref.DEid = RHCesantiaSaldos.DEid
					  and ref.DClinea = RHCesantiaSaldos.DClinea
					  and ref.RHCSperiodo = <cfqueryparam cfsqltype="cf_sql_integer" value="#NextPeriod#">
					  and ref.RHCSmes = <cfqueryparam cfsqltype="cf_sql_integer" value="#NextMonth#">
				  )
				  
	  				<!--- si esta definido el empleado hace solo el cierre para el pues se supone que esta haciendo una liquidacion de personal. --->
				  <cfif isdefined("Arguments.DEid") and Arguments.DEid GT 0>
					and DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.DEid#">
				  </cfif>
				  
			</cfquery>
			<!--- si esta definido el empleado hace solo el cierre para el pues se supone que esta haciendo una liquidacion de personal. --->
			<cfquery datasource="#session.dsn#">
				update RHCesantiaSaldos
				set RHCScerrado = 1
				where RHCSperiodo = <cfqueryparam cfsqltype="cf_sql_integer" value="#ActualPeriod#">
				  and RHCSmes = <cfqueryparam cfsqltype="cf_sql_integer" value="#ActualMonth#">
				  and RHCScerrado = 0
				  <cfif isdefined("Arguments.DEid") and Arguments.DEid GT 0>
					and DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.DEid#">
				  </cfif>
				  
			</cfquery>
		</cfif>
		<!---************************************************************************--->
		<!---******************* FINAL  DEL PROCESO CIERRE DE MES *******************--->
		<!--- <cf_dumptable name="RHCesantiaSaldos" abort="false"> --->
	</cffunction>

	<!---	METODO: LIQUIDACION
		  	RESULTADO:
		  	Calcula el monto que debe pagarse por concepto de liquidacion a un empleado por
		  	fin de relacion laboral (renuncia, despido).
		  
		  	Se asume que SIEMPRE va a existir al menos un periodo/mes abierto, la naturaleza del proceso garantiza
		  	esto, pues cada vez que se cierra un mes, de inmediato se abre el siguiente.
		  
		  	El proceso consiste en:
		  		1. 	Consultar la situacion actual del empleado. Basicamente es saber si hay meses que faltan por cerrar o
					si ya fue liquidado por antiguedad.
				2. 	Si hay meses pendientes de cierre, se procede al proceso de cierre de los mismos, para calcular los
					intereses correspondientes por periodo/mes.
				3.	Si se realizo un proceso de cierre implica la insercion de un nuevo registro para el periodo/mes ultimo 
					que se cerro, esto significa que los montos en ese registro(s) son los que deben pagarse al empleado
					
			El monto que se va a entregar a los empleados depende del tipo de salida de la empresa: renuncia o despido.
				Renuncia: se entrega al empleado unicamente un porcentaje de acuerdo a la cantidad de meses laborados en la
					  	  empresa. (segun tabla RHCesantiaMes)
				Despido: se entrega el monto total de cesantia acumulada al dia del despido.
					
	--->
	<cffunction name="liquidacion" access="public" returntype="query">
		<cfargument name="DEid" required="true" type="Numeric">		<!--- Empleado a quien se hacen los calculos --->
		<cfargument name="tipo" required="true" type="string">		<!--- Renuncia (R) o Despido (D) o (S) Despido sin Responsabilidad--->
		
		<!---	0.1 Consultar el mes y periodo mas reciente porque el que van los datos del empleado. --->
		<cfquery name="rs_periodo_actual" datasource="#session.DSN#">
			select max(RHCSperiodo) as periodo
			from RHCesantiaSaldos
			where DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.DEid#">
			and RHCScerrado = 0
		</cfquery>
		<cfset v_periodo = year(now())>
		<cfif len(trim(rs_periodo_actual.periodo))>
			<cfset v_periodo = rs_periodo_actual.periodo >
		</cfif>
		<cfquery name="rs_mes_actual" datasource="#session.DSN#">
			select max(RHCSmes) as mes
			from RHCesantiaSaldos
			where RHCSperiodo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#v_periodo#">
			and RHCScerrado = 0
		</cfquery>
		<cfset v_mes = month(now())>
		<cfif len(trim(rs_mes_actual.mes))>
			<cfset v_mes = rs_mes_actual.mes >
		</cfif>

		<!---	1. 	Consultar la situacion actual del empleado. Basicamente es saber si hay meses que faltan por cerrar o
					si ya fue liquidado por antiguedad. Se supone que siempre va a existir un mes abierto, por funcionalidad
					del sistema asi trabaja. --->
		<cfquery name="rs_datos" datasource="#session.DSN#">
			select DClinea as carga, RHCSperiodo as periodo, RHCSmes as mes
			from RHCesantiaSaldos
			where DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.DEid#">
			and RHCScerrado = 0
			and RHCSliquidado = 0
			order by RHCSperiodo asc, RHCSmes asc
		</cfquery>

		<!---	2.	Si hay meses pendientes de cierre, se procede al proceso de cierre de los mismos, para calcular los
					intereses correspondientes por periodo/mes. 
				 	Si se realizo un proceso de cierre implica la insercion de un nuevo registro para el periodo/mes ultimo 
					que se cerro, esto significa que los montos en ese registro(s) son los que deben pagarse al empleado --->
		<cfloop query="rs_datos">
			<cfset this.CierreMes(rs_datos.periodo, rs_datos.mes, arguments.DEid) >
		</cfloop>
		
		<!---	2.1 calcula la de cese del empleado, par atomar el periodo y mes dond etermino de laborar para la empresa --->
		<cfset v_fecha_cese = now() >
		<cfquery name="rs_fecha_cese" datasource="#session.DSN#">
			select max(DLfvigencia) as fecha
			from DLaboralesEmpleado le, RHTipoAccion ta
			where le.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.DEid#">
			and ta.RHTid = le.RHTid
			and RHTcomportam = 2
		</cfquery>
		<cfif len(trim(rs_fecha_cese.fecha))>
			<cfset v_fecha_cese = dateadd('d', -1, rs_fecha_cese.fecha) >
		</cfif>
<!---CESE:<cfdump var="#v_fecha_cese#"><br>--->

		<!---	3.	Por defecto el porcentaje a pagar es del 100%, en paso 5 puede cambiar si liquidacion es por renuncia --->
		<cfset porcentaje_pagar = 100 >
		<!--- 	3.5	Caso Nuevo, si es Tipo Despido Sin Responsabilidad	LZ 2011-06-01 --->
		<cfif ucase(arguments.tipo) eq 'S'>
				<cfset porcentaje_pagar = 0 > 
		</cfif>
	<!--- 	4.	Esto solo lo hace si es renuncia 	--->
				<!--- 	4.	Esto solo lo hace si es renuncia 	--->
		<cfif ucase(arguments.tipo) eq 'R'>
			<!---	4.1	Calcula la cantidad de meses que ha trabajado el empleado desde su ultima liquidacion por antiguedad, y si no hay dato, entonces desde su ingreso (solo si es renuncia) --->
			<cfquery name="rs_ingreso" datasource="#session.DSN#">
				<!---select coalesce( ve.EVfliquidacion, ve.EVfantig ) as fecha--->
				select ( select case when ev2.EVfliquidacion > ev2.EVfantig then ev2.EVfliquidacion 
									 else ev2.EVfantig end 
						 from EVacacionesEmpleado ev2 
						 where ev2.DEid = ve.DEid )  as fecha
				
				from EVacacionesEmpleado ve
				where ve.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.DEid#">
			</cfquery>
			<cfset fecha_ingreso = rs_ingreso.fecha >
			<cfif len(trim(fecha_ingreso)) eq 0>
				<cfset fecha_ingreso = now() >
			</cfif>
			<!---<cfset meses_laborados = abs((datediff('d', fecha_ingreso, now() )/30.00)) >--->
			<cfset meses_laborados = abs((datediff('m', fecha_ingreso, v_fecha_cese ))) >
			<cfif len(trim(meses_laborados)) eq 0 >
				<cfset meses_laborados = 0 >
			</cfif>
<!---MESES: <cfdump var="#meses_laborados#">			<br>--->
			<!---	4.2	Calcula el porcentaje que hay que pagarle al empleado sobre lo acumulado --->
			<cfquery name="rs_porcentaje" datasource="#session.DSN#">
				select coalesce(max(RHCMporcentaje), 0) as porcentaje
				from RHCesantiaMes
				where RHCMmes <= <cfqueryparam cfsqltype="cf_sql_float" value="#meses_laborados#">
			</cfquery>
			<cfset porcentaje_pagar = rs_porcentaje.porcentaje > 
			<cfif len(trim(porcentaje_pagar)) eq 0>
				<cfset porcentaje_pagar = 0 > 
			</cfif>
<!---Porcentaje: <cfdump var="#porcentaje_pagar#">--->
		</cfif>
		
		<!---	5.	Recupera los registros recien insertados para hacer el calculo de los montos segun el tipo de fin de 
					relacion. Estos registros ya tienen los montos que hay que pagar al empleado. Hace los calculos de los 
					montos a pagar al empleado, segun porcentaje de pago.
					Realiza dos queries, uno sumarizado por empleado y otro sumarizado por empleado/carga (este ultimo por bitacoras) --->
		<cfif isdefined("v_fecha_cese") and len(trim(v_fecha_cese))>
			<cfset v_periodo = datepart('yyyy', v_fecha_cese) >
			<cfset v_mes = datepart('m', v_fecha_cese) >
			<cfquery name="rs_datos" datasource="#session.DSN#">
				select 	DEid, 
						(sum(RHCSsaldoInicial+RHCSmontoMes)*(#porcentaje_pagar#/100)) as monto, 
						(sum(RHCSsaldoInicialInt+RHCSmontoMesInt)*(#porcentaje_pagar#/100)) as intereses, 
						(sum(RHCSsaldoInicial+RHCSmontoMes)*(#porcentaje_pagar#/100)) + (sum(RHCSsaldoInicialInt+RHCSmontoMesInt)*(#porcentaje_pagar#/100)) as monto_total
				from RHCesantiaSaldos
				where DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.DEid#">
				  and RHCSperiodo = <cfqueryparam cfsqltype="cf_sql_integer" value="#v_periodo#">
				  and RHCSmes = <cfqueryparam cfsqltype="cf_sql_integer" value="#v_mes#">
				
				group by DEid
			</cfquery>

			<cfquery name="rs_datos_carga" datasource="#session.DSN#">
				select 	DEid, 
						DClinea, 
						(sum(RHCSsaldoInicial+RHCSmontoMes)*(#porcentaje_pagar#/100)) as monto, 
						(sum(RHCSsaldoInicialInt+RHCSmontoMesInt)*(#porcentaje_pagar#/100)) as intereses
				from RHCesantiaSaldos

				where DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.DEid#">
				  and RHCSperiodo = <cfqueryparam cfsqltype="cf_sql_integer" value="#v_periodo#">
				  and RHCSmes = <cfqueryparam cfsqltype="cf_sql_integer" value="#v_mes#">

				group by DEid, DClinea
			</cfquery>

		<cfelse>
			<cfquery name="rs_datos" datasource="#session.DSN#">
				select 	DEid, 
						(sum(RHCSsaldoInicial)*(#porcentaje_pagar#/100)) as monto, 
						(sum(RHCSsaldoInicialInt)*(#porcentaje_pagar#/100)) as intereses, 
						(sum(RHCSsaldoInicial)*(#porcentaje_pagar#/100)) + (sum(RHCSsaldoInicialInt)*(#porcentaje_pagar#/100)) as monto_total
				from RHCesantiaSaldos
				where DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.DEid#">
				and RHCScerrado = 0
				and RHCSliquidado = 0
				
				group by DEid
			</cfquery>
	
			<cfquery name="rs_datos_carga" datasource="#session.DSN#">
				select 	DEid, 
						DClinea, 
						(sum(RHCSsaldoInicial)*(#porcentaje_pagar#/100)) as monto, 
						(sum(RHCSsaldoInicialInt)*(#porcentaje_pagar#/100)) as intereses
				from RHCesantiaSaldos
				where DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.DEid#">
				and RHCScerrado = 0
				and RHCSliquidado = 0
				group by DEid, DClinea
			</cfquery>
		</cfif>

		<!---	6.	Marca como liquidado el empleado --->
		<cfquery datasource="#session.DSN#">
			update RHCesantiaSaldos
			set RHCSliquidado = 1,
				RHCScerrado = 1
			where DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DEid#">
		</cfquery>

		<!---	7.	Inserta informacion de bitacoras relacionada a la liquidacion, para cada combinacion empleado/carga --->
		<cfloop query="rs_datos_carga">
			<!---	7.1	Inserta un registro de bitacora de la liquidacion --->	
			<cfquery name="rs_insert_bitacora" datasource="#session.DSN#">
				insert into RHCesantiaLiqBitacora( 	DEid, 
													DClinea, 
													RHCLBfecha, 
													RHCLBtipo, 
													RHCLBmontocesantia, 
													RHCLBmontointeres, 
													BMUsucodigo,
													RHCLBperiodo,
													RHCLBmes )
				values ( <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.DEid#">, 
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#rs_datos_carga.DClinea#">,
						<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
						3,
						<cfqueryparam cfsqltype="cf_sql_money" value="#rs_datos_carga.monto#">,
						<cfqueryparam cfsqltype="cf_sql_money" value="#rs_datos_carga.intereses#">,
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">,
						<cfqueryparam cfsqltype="cf_sql_integer" value="#v_periodo#">,
						<cfqueryparam cfsqltype="cf_sql_integer" value="#v_mes#"> )
				<cf_dbidentity1 datasource="#Session.DSN#" verificar_transaccion="false">
			</cfquery>
			<cf_dbidentity2 datasource="#Session.DSN#" name="rs_insert_bitacora" verificar_transaccion="false">
	
			<!---	7.2	Mueve toda la historia del empleado a la tabla de historicos y la asocia a la bitacora creada --->		
			<cfquery datasource="#session.DSN#">
                insert into RHCesantiaSaldosHist(DEid, DClinea, RHCSperiodo, RHCSmes, RHCLBid, RHCSsaldoInicial, RHCSmontoMes, RHCSsaldoInicialInt, RHCSmontoMesInt, RHCSliquidado, RHCScerrado, BMUsucodigo)
                select DEid, DClinea, RHCSperiodo, RHCSmes, #rs_insert_bitacora.identity#, RHCSsaldoInicial, RHCSmontoMes, RHCSsaldoInicialInt, RHCSmontoMesInt, RHCSliquidado, RHCScerrado, BMUsucodigo
                from RHCesantiaSaldos
                where DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.DEid#">
                  and DClinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rs_datos_carga.DClinea#">
                  and not exists (Select 1 from RHCesantiaSaldosHist b
                                    where RHCesantiaSaldos.DEid= b.DEid
                                    and RHCesantiaSaldos.RHCSmes=b.RHCSmes
                                    and RHCesantiaSaldos.RHCSperiodo=b.RHCSperiodo)
                  and RHCSmontoMes=0
            </cfquery>
						
		</cfloop>

		<!--- 	8. 	Elimina toda la informacion de saldos de la tabla con saldos vigentes.
					Porque asi?
					Porque esta tabla lleva saldo sdelos empleados nombrados, si dejamso los empleados cesados cad avez que se cierre el mes
					se va a generar un registro para estos empleados lo cual no deberia ser, puesto que estan cesados. El proveso  de cierre 
					esta medio sensible a las modificaciones entonces lo mejor es mover estos datos. --->
		<cfquery datasource="#session.DSN#">
			delete from RHCesantiaSaldos
			where DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.DEid#">
		</cfquery>
		
		<!--- 	9. 	LEJ 2009-12-16 Elimina de la tabla de Cesantías Saldos Históricas, aquellos meses que son posteriores al último mes cerrado (y que uso para calcular
			el monto de Cesantía). La razón, que si existen recontrataciones y posteriores Ceses con pagos de Liquidación de Cesantía, el aplicativo
			intentará registrar nuevamente dichos registros generando ERROR de DUPLICACION DE DATOS. Se usará la información de la bitácora de Liquidación
			para establecer que ultimo mes con que se calculo --->
		<cfquery datasource="#session.DSN#">
			delete from RHCesantiaSaldosHist
			where DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.DEid#">
			and ((RHCSperiodo*100) + RHCSmes) > (Select ((RHCLBperiodo*100)+RHCLBmes)
												 from RHCesantiaLiqBitacora
												 Where DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.DEid#">
												 and RHCLBid in (Select Max(RHCLBid)
												 				 from RHCesantiaLiqBitacora
																 Where DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.DEid#">
																 )
												)
		</cfquery>
		<cfreturn rs_datos >			
	
	</cffunction>

</cfcomponent>
