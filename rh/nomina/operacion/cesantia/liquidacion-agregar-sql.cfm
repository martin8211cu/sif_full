<cfset lista_deid = '' >

<cfif isdefined("form.chk") and len(trim(form.chk))>
	<cfset lista_deid = form.chk >
	<!--- 1. tabla que tiene los empleados que tienen 5 annos o mas para el calculo de intereses--->
	<cf_dbtemp name="RHLiquidacionCesantia" returnvariable="RHLiquidacionCesantia">
		<cf_dbtempcol name="DEid" 			type="numeric" 	mandatory="yes">
		<cf_dbtempcol name="fecha" 			type="date" 	mandatory="yes">
		<cf_dbtempcol name="antiguedad" 	type="int" 		mandatory="yes">
		<cf_dbtempcol name="porcentaje" 	type="float" 	mandatory="no">
		<cf_dbtempcol name="Tcodigo" 		type="char(5)" 	mandatory="no">
		<cf_dbtempcol name="fecha_nomina"	type="datetime"	mandatory="no">
	</cf_dbtemp>
	
	<!--- 2. fecha con datos de la liquidacion para los empleados de RHLiquidacionCesantia --->
	<cf_dbtemp name="RHLiqMontos" returnvariable="RHLiqMontos">
		<cf_dbtempcol name="DEid" 				type="numeric" 	mandatory="yes">
		<cf_dbtempcol name="DClinea" 			type="numeric" 	mandatory="yes">
		<cf_dbtempcol name="SaldoInicial" 		type="money"	mandatory="no">
		<cf_dbtempcol name="SaldoInicialInt"	type="money" 	mandatory="no">
		<cf_dbtempcol name="fecha_referencia"	type="int" 		mandatory="no">
		<cf_dbtempcol name="periodo"			type="int" 		mandatory="yes">
		<cf_dbtempcol name="mes"				type="int" 		mandatory="yes">
	</cf_dbtemp>
	
	<!--- 3. query que devuelve los empleados con 8 o mas años sin tener liquidacion de cesantia --->
	<cfset fecha_hoy = LSDateFormat(now(), 'dd/mm/yyyy') >
	<!--- funciones del select --->
	<cf_dbfunction name="to_date" args="'#fecha_hoy#'" returnvariable="db_fecha_hoy">
	<cf_dbfunction name="datediff" args="coalesce((select max(RHCLBfecha) from RHCesantiaLiqBitacora where DEid=ve.DEid ), EVfantig)|#db_fecha_hoy#|mm" delimiters="|" returnvariable="datediff_select">
	<!--- funciones del where --->
	<cf_dbfunction name="datediff" args="coalesce((select max(RHCLBfecha) from RHCesantiaLiqBitacora where DEid=ve.DEid ), EVfantig)|#db_fecha_hoy#|mm" delimiters="|" returnvariable="datediff_where">
	
	<cfquery datasource="#session.DSN#">
		insert into #RHLiquidacionCesantia#( DEid, fecha, antiguedad ) 
		select 	ve.DEid, 
				coalesce(  (select max(RHCLBfecha) from RHCesantiaLiqBitacora where DEid=ve.DEid ), ve.EVfantig), 
				#preservesinglequotes(datediff_select)#
	
		from EVacacionesEmpleado ve
	
		inner join DatosEmpleado de
		on de.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		and de.DEid=ve.DEid
		
		<!--- empleado debe estar nombrado --->
		where exists( select 1
					 from LineaTiempo lt
					 where <cfqueryparam cfsqltype="cf_sql_date" value="#now()#"> between lt.LTdesde and lt.LThasta
					 and lt.DEid=ve.DEid	 )

		and ve.DEid in (#lista_deid#)
	</cfquery>
	
	<!--- 4. Calcula el porcentaje segun la antiguedad que se le va a pagar sobre la cesantia --->
	<cfquery datasource="#session.DSN#">
		update #RHLiquidacionCesantia#
		set porcentaje = (	select coalesce(max(RHCMporcentaje), 0)
							from RHCesantiaMes
							where RHCMmes <= #RHLiquidacionCesantia#.antiguedad )
	</cfquery>
	
	<!--- 5. Calcula el tipo de nomina del empleado --->
	<cfquery datasource="#session.DSN#">
		update #RHLiquidacionCesantia#
		set Tcodigo = (	select lt.Tcodigo
						from LineaTiempo lt
						where lt.DEid = #RHLiquidacionCesantia#.DEid
							and <cfqueryparam cfsqltype="cf_sql_date" value="#now()#"> between lt.LTdesde and lt.LThasta  )
	</cfquery>
	
	<!--- 6. fecha de la proxima nomina de este empleado--->
	<cfquery datasource="#session.DSN#">
		update #RHLiquidacionCesantia#
		set fecha_nomina = ( select min(CPdesde) 
							 from CalendarioPagos 
							 where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
							   and Tcodigo=#RHLiquidacionCesantia#.Tcodigo
							   and CPfcalculo is null )
	</cfquery>
	
	<!--- ***** AGREGAR ESTO A LA TABLA DE SALDOS --->
	<!---alter table RHCesantiaSaldos add RHCSliquidado int default 0 not null  ver esto y poner un check para 0 y 1 --->
	
	<!---- 7. tengo varios registros de cierre de mes, tengo que sacar el ultimo pues es el que tiene el acumulado TOTAL --->
	<cfquery datasource="#session.DSN#">
		insert into #RHLiqMontos#( DEid, DClinea, SaldoInicial, SaldoInicialInt, fecha_referencia, periodo, mes  )
		select cs.DEid, cs.DClinea, cs.RHCSsaldoInicial+cs.RHCSmontoMes, cs.RHCSsaldoInicialInt+cs.RHCSmontoMesInt, (((cs.RHCSperiodo*100)+cs.RHCSmes)*100)+01, cs.RHCSperiodo, cs.RHCSmes
		from RHCesantiaSaldos cs
		
		inner join #RHLiquidacionCesantia# lc
		on lc.DEid=cs.DEid
		
		where cs.RHCSliquidado=0								<!--- tienen que estar en estado por liquidar --->
		and cs.RHCScerrado = 1 									<!--- toma solo los meses cerrados --->
		<!--- toma el mes mas reciente al que se le hizo un cierre --->
		and (((cs.RHCSperiodo*100)+cs.RHCSmes)*100)+1 = (  select   max(((((cs2.RHCSperiodo*100)+cs2.RHCSmes)*100)+1))
															from RHCesantiaSaldos cs2
															where cs2.RHCSperiodo=cs.RHCSperiodo
															  and cs2.DEid=cs.DEid
															  and cs2.DClinea=cs.DClinea
															  and cs2.RHCSliquidado=0  
															  and cs2.RHCScerrado = 1  )		<!--- trabajar solo con registros por liquidar y cerrados--->
	</cfquery>
	
	<cfquery datasource="#session.DSN#" name="x">
		select #session.Ecodigo#, a.DEid, a.DClinea, a.periodo, a.mes, sum(SaldoInicial) as monto, sum(SaldoInicialInt) as intereses, fecha_referencia, #session.usucodigo#
		from #RHLiqMontos# a, #RHLiquidacionCesantia# b
		where b.DEid=a.DEid
		and b.fecha_nomina is not null
		group by a.DEid, DClinea
	</cfquery>
	
	<cfquery datasource="#session.DSN#">
		insert into RHCesantiaLiquidacion(Ecodigo, DEid, DClinea, RHCLperiodo, RHCLmes, RHCLmontoCesantia, RHCLmontoInteres, RHCLreferencia, BMUsucodigo)
		select #session.Ecodigo#, a.DEid, a.DClinea, a.periodo, a.mes, sum(SaldoInicial) as monto, sum(SaldoInicialInt) as intereses, fecha_referencia, #session.usucodigo#
		from #RHLiqMontos# a, #RHLiquidacionCesantia# b
		where b.DEid=a.DEid
		and b.fecha_nomina is not null
		group by a.DEid, DClinea
	</cfquery>
</cfif>

<script type="text/javascript" language="javascript1.2">
	window.opener.location.href = '/cfmx/rh/nomina/operacion/cesantia/liquidacion-resumen.cfm';
	window.close();
</script>