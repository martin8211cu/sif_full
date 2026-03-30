	<!---
	Última Modificación: 7 de Febrero 2006

	En la construcción de los asientos en el reporte de asientos se asume lo siguiente
	- El asiento no tiene agrupamiento
	- El origen para los asientos va a ser RHPN

--->

<cfcomponent>

	<cffunction name="GenerarDatosReporte" access="public" returntype="query">
		<cfargument name="RCNid" 		type="numeric"	required="yes">
		<cfargument name="Ecodigo" 		type="numeric"	required="no"	default="#Session.Ecodigo#">
		<cfargument name="conexion" 	type="string"	required="no"	default="#Session.DSN#">

		<!---================== TRADUCCION ====================---->
		<cfinvoke component="sif.Componentes.Translate"
			method="Translate"
			Key="MSG_ERROR_La_relacion_debe_volverse_a_calcular_Proceso_Cancelado"
			Default="ERROR: La relación debe volverse a calcular. Proceso Cancelado!"
			returnvariable="MSG_RecalcularRelacion"/>

		<cfinvoke component="sif.Componentes.Translate"
			method="Translate"
			Key="MSG_ERROR_La_cuenta_contable_para_Pagos_no_Realizados_no_es_valida"
			Default="ERROR: La cuenta contable para Pagos no Realizados no es una cuenta válida. Revise los Parámetros del Sistema. Proceso Cancelado."
			returnvariable="MSG_CuentaContablePagosInvalida"/>

		<cfinvoke component="sif.Componentes.Translate"
			method="Translate"
			Key="LB_Nomina"
			Default="Nómina"
			returnvariable="LB_Nomina"/>

		<cfinvoke component="sif.Componentes.Translate"
			method="Translate"
			Key="MSG_ERROR_No_se_ha_definido_el_Tipo_de_Nomina_para_la_Relacion_de_Calculo_que_desea_Aplicar"
			Default="ERROR: No se ha  definido el Tipo de Nómina para la Relación de Cálculo que desea Aplicar"
			returnvariable="MSG_TipoNominaIndefinido"/>

		<cfinvoke component="sif.Componentes.Translate"
			method="Translate"
			Key="MSG_ERROR_La_moneda_del_Tipo_de_Nomina_solo_puede_ser_la_Moneda_Local_de_la_Empresa"
			Default="ERROR: La moneda del Tipo de Nómina sólo puede ser la Moneda Local de la Empresa"
			returnvariable="MSG_TipoMonedaEmpresa"/>

		<cfinvoke component="sif.Componentes.Translate"
			method="Translate"
			Key="MSG_Se_esta_intentando_aplicar_una_nomina_con_fecha_mayor_a_la_fecha_hasta"
			Default="Se esta intentando aplicar una nómina con fecha mayor a la fecha hasta"
			returnvariable="MSG_FechaMayorHasta"/>


		<cfquery name="rsSQL" datasource="#Arguments.conexion#">
			select count(1) as cantidad
			  from RCuentasTipo
			 where RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RCNid#">
		</cfquery>
		<cfif rsSQL.cantidad EQ 0>
			<cfthrow message =  "#MSG_RecalcularRelacion#">
		</cfif>

		<!---
			Cuenta Contable de Pagos no realizados
		--->
		<cfquery name="rsSQL" datasource="#Arguments.conexion#">
			select coalesce(Pvalor,'-1') as Ccuenta
			from RHParametros
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#">
			  and Pcodigo = 150
		</cfquery>
		<cfset LvarCcuentaPagosNoRealizados = rsSQL.Ccuenta>

		<cfquery name="rsSQL" datasource="#Arguments.conexion#">
			select 	cc.Cformato,
					(
						select min(cf.CFcuenta)
						  from CFinanciera cf
						 where cf.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#">
						   and cf.Ccuenta = cc.Ccuenta
						   and cf.CFmovimiento = 'S'
					) as CFcuenta
			  from CContables cc
			 where cc.Ccuenta = #LvarCcuentaPagosNoRealizados#
			   and cc.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#">
		</cfquery>
		<cfset LvarCformatoPagosNoRealizados = rsSQL.Cformato>
		<cfset LvarCFcuentaPagosNoRealizados = rsSQL.CFcuenta>

		<cfif trim(LvarCformatoPagosNoRealizados) EQ "">
			<cfthrow message="#MSG_CuentaContablePagosInvalida#">
		</cfif>

		<!--- Averiguar si los asientos son unificados --->
		<cfquery name="rsSQL" datasource="#Arguments.conexion#">
			select Pvalor
			from RHParametros
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#">
			and Pcodigo = 25
		</cfquery>
		<!--- Default unificado --->
		<cfset LvarUnificarGastosCargas = (rsSQL.Pvalor NEQ "0")>
		<cf_dbfunction name="OP_concat"	returnvariable="concat">
		<cfquery name="rsSQL" datasource="#Arguments.conexion#">
			select c.Tcodigo,
					'#LB_Nomina#'#concat#' '#concat#rtrim(b.CPcodigo) #concat#' ('#concat# <cf_dbfunction name="date_format" args="b.CPdesde,DD/MM/YY"> #concat#' - '#concat# <cf_dbfunction name="date_format" args="b.CPhasta,DD/MM/YY">#concat#')'  as Descripcion,
					b.CPcodigo,
					b.CPhasta,
					{fn concat(rtrim(c.Tcodigo),{fn concat(' - ',c.Tdescripcion)})} as NominaDesc,
					{fn concat(rtrim(b.CPdescripcion),{fn concat(' (',{fn concat(rtrim(b.CPcodigo),{fn concat(', ',{fn concat(<cf_dbfunction name="date_format" args="b.CPdesde,DD/MM/YY">,{fn concat(' - ',{fn concat(<cf_dbfunction name="date_format" args="b.CPhasta,DD/MM/YY">,')')})})})})})})} as CalendarioDesc
			from RCuentasTipo a
				inner join CalendarioPagos b
				   on b.CPid = a.RCNid
				inner join TiposNomina c
				   on c.Ecodigo = b.Ecodigo
				   and c.Tcodigo = b.Tcodigo
			where a.RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RCNid#">
			  and a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#">
		</cfquery>
		<cfset LvarTcodigo = rsSQL.Tcodigo>
		<cfif LvarTcodigo EQ "">
			<cfthrow message="#MSG_TipoNominaIndefinido#">
		</cfif>
		<cfset LvarDescripcion 		= rsSQL.Descripcion>
		<cfset LvarNominaDesc 		= rsSQL.NominaDesc>
		<cfset LvarCalendarioDesc 	= rsSQL.CalendarioDesc>
		<cfset LvarCPcodigo 		= rsSQL.CPcodigo>

		<cfset LvarReferencia 	= Arguments.RCNid>
		<cfset LvarFechaHasta	= rsSQL.CPhasta>

		<!--- Verifica la Moneda --->
		<cfset LvarTC = 1.00>
		<cfquery name="rsSQL" datasource="#Arguments.conexion#">
			select Mcodigo
			  from TiposNomina
			 where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#">
			   and Tcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#LvarTcodigo#">
		</cfquery>
		<cfset LvarMcodigo = rsSQL.Mcodigo>

		<cfquery name="rsSQL" datasource="#Arguments.conexion#">
			select Mcodigo
			  from Empresas
			 where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#">
		</cfquery>
		<cfset LvarMcodigoLocal = rsSQL.Mcodigo>

		<cfif LvarMcodigo NEQ LvarMcodigoLocal>
			<cfthrow message="#MSG_TipoMonedaEmpresa#">
		</cfif>

		<!--- Obtener proximo RHEnumero --->
		<cfquery name="rsRHEnumero" datasource="#Arguments.conexion#">
			select coalesce(max(RHEnumero),0) as RHEnumero
			from RHEjecucion
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#">
			and RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RCNid#">
		</cfquery>
		<cfset LvarRHEnumero = rsRHEnumero.RHEnumero>

		<!--- Averiguar la cantidad de asientos que se generan por mes --->
		<cfquery name="rsDocumentos" datasource="#Arguments.conexion#">
			select distinct RCNid, Periodo, Mes
			from RCuentasTipo
			where RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RCNid#">
		</cfquery>

		<!--- Creacion de Tabla Temporal de Trabajo --->
		<cfset INTARC = CreaIntarc()>
		<cfset ECONTABLES = CreaEContables()>
		<cfset DCONTABLES = CreaDContables()>

		<cfloop query="rsDocumentos">
			<cfset LvarPeriodo 	= rsDocumentos.Periodo>
			<cfset LvarMes 		= rsDocumentos.Mes>

			<cfif LvarPeriodo*100+LvarMes EQ dateFormat(LvarFechaHasta,"YYYYMM")>
				<cfset LvarFecha = LvarFechaHasta>
			<cfelseif LvarPeriodo*100+LvarMes LT dateFormat(LvarFechaHasta,"YYYYMM")>
				<cfset LvarFecha = createDate(LvarPeriodo,LvarMes,1)>
				<cfset LvarFecha = createDate(LvarPeriodo,LvarMes,DaysInMonth(LvarFecha))>
			<cfelse>
				<cfthrow message="#MSG_FechaMayorHasta#">
			</cfif>

			<!--- Genera Asiento Contable: (Gastos sin unificar) o (Gastos y Cargas Unificadas) --->
			<cfif LvarUnificarGastosCargas>
				<!--- Asiento Unificado: Gastos y Cargas) --->
				<cfset sbAsientoContable (Arguments.RCNid, LvarRHEnumero, "U")>
			<cfelse>
				<!--- Asiento No Unificado: Gastos --->
				<cfset sbAsientoContable (Arguments.RCNid, LvarRHEnumero, "G")>
				<!--- Asiento No Unificado: Cargas --->
				<cfset sbAsientoContable (Arguments.RCNid, LvarRHEnumero, "C")>
			</cfif>
		</cfloop>

		<!--- Consulta de los Asientos Generados --->
		<cfset QueryReporte = ReporteAsientos(Arguments.RCNid, Arguments.Ecodigo, Arguments.conexion)>

		<cfreturn QueryReporte>

	</cffunction>


	<cffunction name="CreaIntarc" access="private" output="false" returntype="string">
		<cfargument name="conexion" type="string" required="no" default="#Session.DSN#">

		<cf_dbtemp name="CG_INTARC_V5" returnvariable="CG_GeneraAsiento_INTARC_NAME" datasource="#Arguments.Conexion#">
			<cf_dbtempcol name="INTLIN"   type="numeric"      identity="yes">
			<cf_dbtempcol name="INTORI"   type="char(4)"      mandatory="yes">
			<cf_dbtempcol name="INTREL"   type="int"          mandatory="yes">
			<cf_dbtempcol name="INTDOC"   type="char(20)"     mandatory="yes">
			<cf_dbtempcol name="INTREF"   type="varchar(25)"  mandatory="yes">
			<cf_dbtempcol name="INTMON"   type="money"        mandatory="yes">
			<cf_dbtempcol name="INTTIP"   type="char(1)"      mandatory="yes">
			<cf_dbtempcol name="INTDES"   type="varchar(80)"  mandatory="yes">
			<cf_dbtempcol name="INTCAM"   type="float"        mandatory="yes">
			<cf_dbtempcol name="Periodo"  type="int"          mandatory="yes">
			<cf_dbtempcol name="Mes"      type="int"          mandatory="yes">
			<cf_dbtempcol name="Ccuenta"  type="numeric"      mandatory="yes">
			<cf_dbtempcol name="Mcodigo"  type="numeric"      mandatory="yes">
			<cf_dbtempcol name="Ocodigo"  type="int"          mandatory="yes">
			<cf_dbtempcol name="INTMOE"   type="money"        mandatory="yes">
			<cf_dbtempcol name="Cgasto"   type="varchar(100)" mandatory="no">
			<cf_dbtempcol name="Cformato" type="varchar(100)" mandatory="no">
			<cf_dbtempcol name="CFcuenta" type="numeric"      mandatory="no">
			<cf_dbtempcol name="INTMON2"  type="money"        mandatory="no">

			<cf_dbtempkey cols="INTLIN">
		</cf_dbtemp>

		<cfset Request.intarc = CG_GeneraAsiento_INTARC_NAME>
		<cfreturn CG_GeneraAsiento_INTARC_NAME>
	</cffunction>


	<cffunction name="CreaEContables" access="private" output="false" returntype="string">
		<cfargument name="conexion" type="string" required="no" default="#Session.DSN#">

		<cf_dbtemp name="CG_ECONTABLES_V5" returnvariable="CG_GeneraAsiento_ECONTABLES_NAME" datasource="#Arguments.Conexion#">
			<cf_dbtempcol name="IDcontable"		type="numeric"		identity="yes">
			<cf_dbtempcol name="Ecodigo"		type="int"			mandatory="yes">
			<cf_dbtempcol name="Eperiodo"   	type="int"     		mandatory="yes">
			<cf_dbtempcol name="Emes"   		type="int"			mandatory="yes">
			<cf_dbtempcol name="CPcodigo"   	type="varchar(20)"  mandatory="yes">
			<cf_dbtempcol name="Edescripcion"	type="varchar(100)" mandatory="yes">
			<cf_dbtempcol name="NominaDesc"		type="varchar(100)" mandatory="yes">
			<cf_dbtempcol name="CalendarioDesc"	type="varchar(100)" mandatory="yes">
			<cf_dbtempcol name="Ereferencia"	type="varchar(25)"  mandatory="yes">

			<cf_dbtempkey cols="IDcontable">
		</cf_dbtemp>

		<cfset Request.Econtables = CG_GeneraAsiento_ECONTABLES_NAME>
		<cfreturn CG_GeneraAsiento_ECONTABLES_NAME>
	</cffunction>

	<cffunction name="CreaDContables" access="private" output="false" returntype="string">
		<cfargument name="conexion" type="string" required="no" default="#Session.DSN#">

		<cf_dbtemp name="CG_DCONTABLES_V5" returnvariable="CG_GeneraAsiento_DCONTABLES_NAME" datasource="#Arguments.Conexion#">
			<cf_dbtempcol name="Dlinea"			type="numeric"			identity="yes">
			<cf_dbtempcol name="IDcontable"		type="numeric"			mandatory="yes">
			<cf_dbtempcol name="Ecodigo"		type="int"				mandatory="yes">
			<cf_dbtempcol name="Eperiodo"   	type="int"     			mandatory="yes">
			<cf_dbtempcol name="Emes"   		type="int"				mandatory="yes">
			<cf_dbtempcol name="Ddocumento"		type="varchar(20)"  	mandatory="yes">
			<cf_dbtempcol name="Ocodigo"		type="int"  			mandatory="yes">
			<cf_dbtempcol name="Ddescripcion"	type="varchar(100)"		mandatory="yes">
			<cf_dbtempcol name="Dmovimiento"	type="varchar(1)"		mandatory="yes">
			<cf_dbtempcol name="Ccuenta"		type="numeric"			mandatory="yes">
			<cf_dbtempcol name="CFcuenta"		type="numeric"			mandatory="yes">
			<cf_dbtempcol name="Doriginal"		type="money"			mandatory="yes">
			<cf_dbtempcol name="Dlocal"			type="money"			mandatory="yes">
			<cf_dbtempcol name="Mcodigo"		type="numeric"			mandatory="yes">
			<cf_dbtempcol name="Dtipocambio"	type="float"			mandatory="yes">
			<cf_dbtempcol name="Dreferencia"	type="varchar(25)"		mandatory="yes">

			<cf_dbtempkey cols="Dlinea">
		</cf_dbtemp>

		<cfset Request.Dcontables = CG_GeneraAsiento_DCONTABLES_NAME>
		<cfreturn CG_GeneraAsiento_DCONTABLES_NAME>
	</cffunction>

	<cffunction name="sbAsientoContable" access="private" output="false" returntype="void">
		<cfargument name="RCNid" 		type="numeric" 	required="true">
		<cfargument name="RHEnumero"	type="numeric" 	required="true">
		<cfargument name="Tipo" 		type="string" 	required="true">
		<cfargument name="Ecodigo" 		type="numeric" 	required="no" default="#Session.Ecodigo#">
		<cfargument name="conexion" 	type="string" 	required="no" default="#Session.DSN#">

		<cfquery datasource="#Arguments.conexion#">
			delete from #Request.intarc#
		</cfquery>
		<cfquery datasource="#Arguments.conexion#">
			insert into #Request.intarc#
				(
					INTORI, INTREL, INTDOC, INTREF, INTMON, INTTIP,
					INTDES, INTCAM, Periodo, Mes,
					Mcodigo, Ocodigo, INTMOE,
					Ccuenta, CFcuenta
				)
			select 'RHPN', 1, '#LvarCPcodigo#', '#LvarReferencia#', round(sum(a.montores*#LvarTC#),2), a.tipo,
					case a.tiporeg
						when 10 then 'SALARIOS'
						when 11 then 'SALARIOS MES ANTERIOR (CxP)'
						when 20 then 'INCIDENCIAS'
						when 21 then 'INCIDENCIAS MES ANTERIOR'
						when 25 then 'PAGOS NO REALIZADOS'
						when 50 then 'CARGAS EMPLEADO'
						when 51 then 'Cargas EMPLEADO por distribucion'
						when 52 then 'Cargas EMPLEADO Mes Anterior'
						when 60 then 'DEDUCCIONES'
						when 61 then 'INTERESES DEDUCCIONES'
						when 70 then 'RENTA'

						when 30 then 'CARGAS EMPRESA (GASTO)'
						when 31 then 'CARGAS EMPRESA MES ANTERIOR (GASTO)'
						when 40 then 'CARGAS EMPRESA (CxC)'
						when 55 then 'CARGAS EMPRESA (CxP)'
						when 56 then 'CargasPatronales por distribucion'
						when 57 then 'CargasPatronales Mes Anterior'
						when 80 then 'SALARIO LIQUIDO'
						when 85 then 'SALARIO LIQUIDO'

					end,
					#LvarTC#, #LvarPeriodo#, #LvarMes#,
					#LvarMcodigo#, a.Ocodigo, round(sum(a.montores), 2),
					a.Ccuenta, a.CFcuenta
			  from RCuentasTipo a
				left join CIncidentes ci
					on ci.CIid = a.referencia
					and a.tipo = 'D'
				and (ci.CItimbrar is null or ci.CItimbrar = 0)
			 where a.RCNid 		= #Arguments.RCNid#
			   and a.Periodo	= #LvarPeriodo#
			   and a.Mes 		= #LvarMes#
			   and (ci.CItimbrar is null or ci.CItimbrar = 0)
			   and a.tiporeg in
				<cfif Arguments.Tipo EQ "U">			<!--- Unificando Gastos y Cargas --->
				 (10,11,20,21,25,50,51,52,60,61,70, 30,31,40,55,56,57,80,85)
				<cfelseif Arguments.Tipo EQ "G">		<!--- Gastos: sin unificar Cargas --->
				 (10,11,20,21,25,50,51,52,60,61,70,80,85)
				<cfelseif Arguments.Tipo EQ "C">		<!--- Cargas: sin unificar Gastos--->
				 (30,31,40,55,56,57)
				</cfif>
			group by a.tipo, a.tiporeg, a.Ocodigo, a.Ccuenta, a.CFcuenta
			order by a.tipo desc, a.tiporeg, a.Ocodigo
		</cfquery>


		<!--- OPARRALES 2018-11-07
			- Modificacion para operacion de tipo U,
			- los valores de RCuentasTipo ya se contemplan en el insert de arriba
		--->
		<cfif Arguments.Tipo NEQ "C" and Arguments.Tipo neq 'U'>
			<!--- Gastos o Unificado --->
			<!--- Asiento Contable: (Pagos) --->
			<cfquery datasource="#Arguments.conexion#">
				insert 	into #Request.intarc#
					(
						INTORI, INTREL, INTDOC, INTREF, INTMON, INTTIP,
						INTDES, INTCAM, Periodo, Mes,
						Mcodigo, Ocodigo, INTMOE,
						Ccuenta, CFcuenta
					)
				select 	'RHPN', 1, '#LvarCPcodigo#', '#LvarReferencia#', sum(round(a.montores*#LvarTC#,2)), a.tipo,
						case
							when d.DRNestado = 2 then 'PAGOS NO REALIZADOS'
							when d.DRNestado = 1 AND a.tiporeg = 80 then 'BANCO'
							when d.DRNestado = 1 AND a.tiporeg = 85 then 'SALARIOS POR PAGAR'
						end,
						#LvarTC#, #LvarPeriodo#, #LvarMes#,
						#LvarMcodigo#, a.Ocodigo, sum(round(a.montores, 2)),

						case when d.DRNestado = 1 then a.Ccuenta  else #LvarCcuentaPagosNoRealizados# end,
						case when d.DRNestado = 1 then a.CFcuenta else #LvarCFcuentaPagosNoRealizados# end

				  from RCuentasTipo a
				  inner join ERNomina e
					on e.RCNid = a.RCNid
				  inner join DRNomina d
				   on e.ERNid = d.ERNid
				   and a.DEid  = d.DEid
				  left join CIncidentes ci
					on ci.CIid = a.referencia
					and tipo = 'D'
				 where a.RCNid 		= #Arguments.RCNid#
				   and a.Periodo 	= #LvarPeriodo#
				   and a.Mes 		= #LvarMes#
				   and a.tiporeg in (80,85)
				   and (ci.CItimbrar is null or ci.CItimbrar = 0)
				 group by a.tipo, d.DRNestado, a.tiporeg, a.Ccuenta, a.Ocodigo, a.CFcuenta
			</cfquery>
		</cfif>

		<cfquery name="rsSQL" datasource="#Arguments.conexion#">
			select
				sum(case when INTTIP='D' then INTMON end) as Debitos,
				sum(case when INTTIP='C' then INTMON end) as Creditos
			from #Request.intarc#
		</cfquery>

		<cfset LvarDebitos 	= rsSQL.Debitos>
		<cfset LvarCreditos = rsSQL.Creditos>

		<!---================== TRADUCCION ====================---->
		<cfinvoke component="sif.Componentes.Translate"
			method="Translate"
			Key="MSG_ERROR_El_asiento_Contable_de_la_Nomina_no_esta_Balanceado"
			Default="ERROR: El asiento Contable de la Nómina no está Balanceado:"
			returnvariable="MSG_AsientoNoBalanceado"/>

		<cfinvoke component="sif.Componentes.Translate"
			method="Translate"
			Key="MSG_ERROR_El_asiento_Contable_de_Otros_Costos_de_la_Nomina_no_esta_Balanceado"
			Default="ERROR: El asiento Contable de Otros Costos de la Nómina (no unificado) no está Balanceado:"
			returnvariable="MSG_AsientoOtrosCostosNoBalanceado"/>

		<cfinvoke component="sif.Componentes.Translate"
			method="Translate"
			Key="MSG_Debitos"
			Default="Débitos= "
			returnvariable="MSG_Debitos"/>

		<cfinvoke component="sif.Componentes.Translate"
			method="Translate"
			Key="MSG_Creditos"
			Default="Créditos= "
			returnvariable="MSG_Creditos"/>

		<cfinvoke component="sif.Componentes.Translate"
			method="Translate"
			Key="MSG_Otros_Costos"
			Default="Otros Costos "
			returnvariable="MSG_Otros_Costos"/>


		<cfif LvarDebitos NEQ LvarCreditos>
			<cfif Arguments.Tipo NEQ "C">		<!--- Gastos o Unificado --->
				<cfthrow message="#MSG_AsientoNoBalanceado# #MSG_Debitos# #NumberFormat(LvarDebitos,',9.99')#, #MSG_Creditos# #NumberFormat(LvarCreditos,',9.99')# #LvarPeriodo#/#LvarMes#">
			<cfelse>
				<cfthrow message="#MSG_AsientoOtrosCostosNoBalanceado# #MSG_Debitos# #NumberFormat(LvarDebitos,',9.99')#, #MSG_Creditos# #NumberFormat(LvarCreditos,',9.99')# #LvarPeriodo#/#LvarMes#">
			</cfif>
		</cfif>

		<cfif Arguments.Tipo EQ "C">		<!--- No es de tipo Gastos o Unificado --->
			<cfset LvarDescripcion = "#MSG_Otros_Costos#  #LvarDescripcion#">
		</cfif>
		<!--- Genera el Asiento Contable --->
		<cfset LvarIDcontable = GeneraAsiento(LvarPeriodo, LvarMes, LvarCPcodigo, LvarDescripcion, LvarNominaDesc, LvarCalendarioDesc, LvarReferencia, Arguments.Ecodigo, Arguments.conexion)>

	</cffunction>


	<cffunction name="GeneraAsiento" access="private" output="false" returntype="numeric">
		<cfargument name="Eperiodo" type="numeric" required="true">
		<cfargument name="Emes" type="numeric" required="true">
		<cfargument name="CPcodigo" type="string" required="true">
		<cfargument name="Edescripcion" type="string" required="true">
		<cfargument name="NominaDesc" type="string" required="true">
		<cfargument name="CalendarioDesc" type="string" required="true">
		<cfargument name="Ereferencia" type="string" required="true" default="">
		<cfargument name="Ecodigo"	type="numeric"	required="no"	default="#Session.Ecodigo#">
		<cfargument name="conexion"	type="string"	required="no"	default="#Session.DSN#">

		<!--- 1 Obtener el numero del asiento - Edocumento --->
		<!---
		<cfset Edocumento = Nuevo_Asiento(Arguments.Eperiodo, Arguments.Emes, Arguments.Ecodigo, Arguments.conexion)>
		--->

		<!----===================== TRADUCCION =======================---->
		<cfinvoke component="sif.Componentes.Translate"
			method="Translate"
			Key="MSG_ERROR_No_se_ha_definido_correctamente_la_cuenta_Contable_para_saldos"
			Default="Error, no se ha definido correctamente la Cuenta Contable para saldos por redondeo de monedas en los Parámetros del Sistema. Proceso Cancelado! (Tabla: Parametros)"
			returnvariable="MSG_CtaContableSaldos"/>

		<cfinvoke component="sif.Componentes.Translate"
			method="Translate"
			Key="MSG_ERROR_no_se_ha_definido_correctamente_la_Cuenta_Contable_para_movimiento_entre_sucursales"
			Default="Error, no se ha definido correctamente la Cuenta Contable para movimiento entre sucursales en los Parámetros del Sistema. Proceso Cancelado! (Tabla: Parametros)"
			returnvariable="MSG_CtaContableMovimientosIncorrecta"/>

		<cfquery datasource="#Arguments.Conexion#">
			update #Request.intarc#
			set INTCAM = INTMON / INTMOE
			where INTMOE != 0
			  and round(INTMOE * INTCAM, 2) != round(INTMON, 2)
		</cfquery>

		<!--- Redondea los montos a dos decimales --->
		<cfquery datasource="#Arguments.Conexion#">
			update #Request.intarc#
			set INTMON = round(INTMON, 2), INTMOE = round(INTMOE, 2)
		</cfquery>

		<!--- Modificar los datos según signo --->
		<cfquery datasource="#Arguments.Conexion#">
			update #Request.intarc#
			set INTTIP = 'D', INTMON = abs(INTMON), INTMOE = abs(INTMOE)
			where INTTIP = 'C'
			  and INTMON < 0
		</cfquery>

		<cfquery datasource="#Arguments.Conexion#">
			update #Request.intarc#
			set INTTIP = 'C', INTMON = abs(INTMON), INTMOE = abs(INTMOE)
			where INTTIP = 'D'
			  and INTMON < 0
		</cfquery>

		<!---
		3.  Insertar el Documento Contable
		    Validar balance por moneda origen en #INTARC
		--->
		<cfquery datasource="#Arguments.Conexion#" name="Parametro100">
			select a.Pvalor, a.Ecodigo
			from Parametros a
			where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#">
			  and a.Pcodigo = 100
		</cfquery>
		<cfif Len(Trim(Parametro100.Pvalor)) EQ 0>
		   	<cfthrow message="#MSG_CtaContableSaldos#">
		</cfif>
		<cfquery datasource="#Arguments.Conexion#" name="CuentaRedondeos">
			select b.Ccuenta
			from CContables b
			where b.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#">
			  and b.Ccuenta = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Trim(Parametro100.Pvalor)#">
		</cfquery>
		<cfif Len(Trim(CuentaRedondeos.Ccuenta)) EQ 0>
			<cfthrow message="Error, no existe la Cuenta Contable definida para saldos por redondeo de monedas en los Parámetros del Sistema. Proceso Cancelado!. (Tabla: CContables, ID: #Parametro100.Pvalor#)">
		</cfif>

		<cfquery datasource="#Arguments.Conexion#" name="cursorMonedas">
			select i.Mcodigo, m.Mnombre,
				sum(i.INTMOE * (case i.INTTIP when 'C' then -1 else 1 end)) as diferencia_original,
				sum(i.INTMON * (case i.INTTIP when 'C' then -1 else 1 end)) as diferencia_local
			from #Request.intarc# i join Monedas m
			  on i.Mcodigo = m.Mcodigo
			group by i.Mcodigo, m.Mnombre
		</cfquery>

		<cfset MonedasDesbalanceadas = "">
		<cfloop query="cursorMonedas">
			<cfif cursorMonedas.diferencia_original neq 0>
				<cfset MonedasDesbalanceadas = ListAppend(MonedasDesbalanceadas, cursorMonedas.Mnombre)>
			<cfelseif cursorMonedas.diferencia_local neq 0>
				<cfquery datasource="#Arguments.Conexion#">
					insert into #Request.intarc# (INTORI, INTREL, INTDOC, INTREF, INTMON, INTTIP, INTDES, INTCAM, Periodo, Mes, Ccuenta, Mcodigo, Ocodigo, INTMOE)
					select a.INTORI, a.INTREL, 'AJ', 'AJ',
						<!---
							hay que usar cf_sql_money, con cf_sql_numeric no lo hace bien
							cambido el 10/12/2004 para resolver un problema de CRT, invocado desde CP_MBPosteoMovimientosB.cfc
						 --->
						<cfqueryparam cfsqltype="cf_sql_money" value="#Abs(cursorMonedas.diferencia_local)#">,
						<cfif cursorMonedas.diferencia_local gt 0>'C'<cfelse>'D'</cfif>,
						'Balance de Saldos por Redondeo de Monedas', 0.00, a.Periodo, a.Mes,
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#CuentaRedondeos.Ccuenta#">,
						a.Mcodigo, a.Ocodigo, 0.00
					from #Request.intarc# a
					where INTLIN = (select min(INTLIN) from #Request.intarc#
						where Mcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#cursorMonedas.Mcodigo#">)
				</cfquery>
			</cfif>
		</cfloop><!--- cursorMonedas --->

		<cfif Len(Trim(MonedasDesbalanceadas))>
			<cfthrow message="La póliza no esta Balanceada en las siguientes Monedas: #MonedasDesbalanceadas#. Proceso Cancelado!">
		</cfif>

		<!---
		3.1. Balance por Sucursal
		--->
		<cfquery datasource="#Arguments.Conexion#" name="Parametro90">
			select a.Pvalor
			from Parametros a
			where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#">
			  and a.Pcodigo = 90
		</cfquery>
		<cfif Len(Trim(Parametro90.Pvalor)) EQ 0>
		    <cfthrow message="#MSG_CtaContableMovimientosIncorrecta#">
		</cfif>
		<cfquery datasource="#Arguments.Conexion#" name="CuentaSaldosOficina">
			select b.Ccuenta
			from CContables b
			where b.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#">
			  and b.Ccuenta = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Parametro90.Pvalor#">
		</cfquery>
		<cfif Len(Trim(CuentaSaldosOficina.Ccuenta)) EQ 0>
		    <cfthrow message="Error, no existe la Cuenta Contable definida para movimiento entre
				sucursales en los Parámetros del Sistema. Proceso Cancelado! (Tabla: CContables, ID: #Parametro90.Pvalor#)">
		</cfif>

		<cfquery datasource="#Arguments.Conexion#" name="distinctOcodigo">
			select count(distinct Ocodigo) cnt from #Request.intarc#
		</cfquery>
		<cfif distinctOcodigo.cnt gt 1>
			<!--- Insertar los créditos --->
			<cfquery datasource="#Arguments.Conexion#">
			insert into #Request.intarc# (INTORI, INTREL, INTDOC, INTREF, INTMON, INTTIP, INTDES, INTCAM, Periodo, Mes, Ccuenta, Mcodigo, Ocodigo, INTMOE)
			select a.INTORI, a.INTREL, 'AJ', 'AJ', abs(sum(a.INTMON * (case a.INTTIP when 'C' then -1 else 1 end))),
				case when sum(a.INTMON * (case a.INTTIP when 'C' then -1 else 1 end)) > 0 then 'C' else 'D' end,
				'Balance de Saldos por Oficina', 0.00, a.Periodo, a.Mes,
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#CuentaSaldosOficina.Ccuenta#">,
				a.Mcodigo, a.Ocodigo, abs(sum(a.INTMOE * (case a.INTTIP when 'C' then -1 else 1 end)))
			from #Request.intarc# a
			group by a.INTORI, a.INTREL, a.Periodo, a.Mes, a.Mcodigo, a.Ocodigo
			having abs(sum(a.INTMOE * (case a.INTTIP when 'C' then -1 else 1 end))) != 0
			</cfquery>
		</cfif>

		<cfquery datasource="#Arguments.Conexion#" name="balanceado">
			select abs(round(sum(case when INTTIP = 'C' then - INTMON else INTMON end),2)) balance
			from #Request.intarc#
		</cfquery>
		<!--- Validar que el asiento esté balanceado --->
		<cfif balanceado.balance neq 0>
			<cfthrow message="La póliza no esta Balanceada en Moneda Local. Hay una diferencia de #balanceado.balance#. Proceso Cancelado!">
		</cfif>

		<cfquery datasource="#Arguments.Conexion#">
			delete from #Request.intarc#
			where INTMON = 0.00 and INTMOE = 0.00
		</cfquery>

		<!--- Validar que las cuentas existan antes de que se inserten los datos
			Aunque esto lo hace la integridad referencial, aquí podemos avisar cuál es la cuenta que da error
		--->
		<cfquery datasource="#Arguments.Conexion#" name="cuenta_no_existe">
			select distinct Ccuenta, INTDES from #Request.intarc# x
			where CFcuenta is NULL AND not exists (select 1 from CContables y where x.Ccuenta = y.Ccuenta)
		</cfquery>
		<cfif cuenta_no_existe.RecordCount neq 0>
			<cfthrow message="Cuentas contables no existen: #ValueList(cuenta_no_existe.Ccuenta)# para #ValueList(cuenta_no_existe.INTDES)#">
			<cfdump var="#cuenta_no_existe#" label="Ccuenta que no existen">
			<cfabort>
		</cfif>
		<cfquery datasource="#Arguments.Conexion#" name="cuenta_no_existe">
			select distinct CFcuenta, INTDES from #Request.intarc# x
			where CFcuenta is NOT NULL AND not exists (select 1 from CFinanciera y where x.CFcuenta = y.CFcuenta)
		</cfquery>
		<cfif cuenta_no_existe.RecordCount neq 0>
			<cfthrow message="Cuentas Financieras no existen: #ValueList(cuenta_no_existe.CFcuenta)# para #ValueList(cuenta_no_existe.INTDES)#">
			<cfdump var="#cuenta_no_existe#" label="CFcuenta que no existen">
			<cfabort>
		</cfif>

		<cfquery datasource="#Arguments.Conexion#" name="insert_Econtables">
			insert into #Request.Econtables# (
				Ecodigo, Eperiodo, Emes, Edescripcion,
				NominaDesc, CalendarioDesc, CPcodigo, Ereferencia)
			values (
				<cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#">,
				<cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Eperiodo#">,
				<cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Emes#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.Edescripcion#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.NominaDesc#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.CalendarioDesc#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.CPcodigo#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.Ereferencia#">
				)

			<cf_dbidentity1 verificar_transaccion="no" datasource="#Arguments.Conexion#">
		</cfquery>
		<cf_dbidentity2 name="insert_Econtables" verificar_transaccion="no" datasource="#Arguments.Conexion#">
		<cfset Lvaridentity = insert_Econtables.identity>

		<!---
		4. Incluir la referencia del numero en la tabla #asiento para actualizar el sistema auxiliar
		   // se cambia, ahora va a ser la variable de retorno //
		   // que pasaba antes si no habia registros en #asiento al regresar de aqui ? //
		   // el valor en el documento del auxiliar seguramente quedaba en null //
		--->

		<cfquery datasource="#Arguments.Conexion#">
			insert into #Request.Dcontables# (
				 IDcontable, Ecodigo,
				 Eperiodo, Emes, Ddocumento,
				 Ocodigo, Ddescripcion, Dmovimiento,
				 Ccuenta, CFcuenta,
				 Doriginal, Dlocal, Mcodigo, Dtipocambio, Dreferencia)
			select
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#Lvaridentity#">,
				<cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#">,
				<cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Eperiodo#">,
				<cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Emes#">,
				INTDOC,
				Ocodigo, INTDES, INTTIP,
				CASE
					WHEN CFcuenta IS NOT NULL AND Ccuenta = 0
					THEN
						(select min(Ccuenta)
						   from CFinanciera
						  where CFinanciera.CFcuenta = #Request.intarc#.CFcuenta
						)
					ELSE
						Ccuenta
				END,
				CASE
					WHEN CFcuenta IS NOT NULL
						THEN CFcuenta
					ELSE
						(select min(CFcuenta)
						   from CFinanciera
						  where CFinanciera.Ccuenta = #Request.intarc#.Ccuenta
						)
				END,
				round(INTMOE, 2), round(INTMON, 2), Mcodigo, INTCAM, INTREF
			from #Request.intarc#
			order by INTLIN
		</cfquery>

		<cfreturn Lvaridentity>

	</cffunction>

	<cffunction name="ReporteAsientos" access="private" returntype="query" output="false" hint="Retorna con query para reporte de Asientos">
		<cfargument name="RCNid"	type="numeric"	required="yes">
		<cfargument name="Ecodigo"	type="numeric"	required="no"	default="#Session.Ecodigo#">
		<cfargument name="conexion"	type="string"	required="no"	default="#Session.DSN#">

		<cfquery name="rsReporte" datasource="#Arguments.conexion#">
			select rtrim(a.NominaDesc) as NominaDesc, rtrim(a.CalendarioDesc) as CalendarioDesc,
			       <cf_dbfunction name="to_char" args="a.Eperiodo"> as Periodo,
				   <cf_dbfunction name="to_char" args="a.Emes"> as Mes,
				   rtrim(a.Edescripcion) as Asiento,
				   b.Ddescripcion as Detalle,
				   {fn concat(c.CFformato,{fn concat(' ',c.CFdescripcion)})} as CuentaContable,
				   d.Odescripcion as Oficina,
				   case when b.Dmovimiento = 'D' then b.Dlocal else 0 end as Debito,
				   case when b.Dmovimiento = 'C' then b.Dlocal else 0 end as Credito,
				   {fn concat(<cf_dbfunction name="to_char" args="a.Eperiodo">,{fn concat(<cf_dbfunction name="to_char" args="a.Emes">,rtrim(a.Edescripcion))})} as CorteAsiento
			from #Request.Econtables# a
				inner join #Request.Dcontables# b
				   on b.IDcontable = a.IDcontable
				inner join CFinanciera c
				   on c.CFcuenta = b.CFcuenta
				inner join Oficinas d
				   on d.Ecodigo = a.Ecodigo
				   and d.Ocodigo = b.Ocodigo
			order by a.NominaDesc, a.CalendarioDesc, a.Eperiodo, a.Emes, a.IDcontable, b.Dlinea
		</cfquery>
		<cfreturn rsReporte>
	</cffunction>

</cfcomponent>
