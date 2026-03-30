<cfcomponent>
	<!--- 
		Este componente requiere que se invoque dentro de un <cftransaction>
		(DEid, Ecodigo, Ocodigo, Dcodigo, RHPid, RHPcodigo, Tcodigo, Ttipopago, CFid, Eid, EEid, ETid, Mcodigo, EPid, EPcodigo, Perceptil, Salario, Incidencias, SalReferencia, SalPeriodo, SalMensual)
	--->

	<!--- Tabla ocupada por el reporte de Análisis de Proyección Salarial --->
	<cffunction name="CrearTablaEmpleadosRep1" access="package" output="false" returntype="string">
		<cfargument name="Conexion" type="string" required="no" default="#Session.DSN#">

		<cf_dbtemp name="ASalarial1" returnvariable="TablaEmpleados" datasource="#Arguments.Conexion#">
			<cf_dbtempcol name="DEid"			type="numeric"		mandatory="yes">
			<cf_dbtempcol name="Ecodigo"		type="numeric"		mandatory="yes">
			<cf_dbtempcol name="Ocodigo"		type="int"			mandatory="yes">
			<cf_dbtempcol name="Dcodigo"		type="int"			mandatory="yes">
			<cf_dbtempcol name="RHPid"			type="numeric"		mandatory="yes">
			<cf_dbtempcol name="RHPcodigo"		type="char(10)"		mandatory="yes">
			<cf_dbtempcol name="Tcodigo"		type="char(5)"		mandatory="yes">
			<cf_dbtempcol name="Ttipopago"		type="int"			mandatory="yes">
			<cf_dbtempcol name="CFid"			type="numeric"		mandatory="no">
			<cf_dbtempcol name="Eid"			type="numeric"		mandatory="no">
			<cf_dbtempcol name="EEid"			type="numeric"		mandatory="no">
			<cf_dbtempcol name="ETid"			type="numeric"		mandatory="no">
			<cf_dbtempcol name="Mcodigo"		type="numeric"		mandatory="no">
			<cf_dbtempcol name="EPid"			type="numeric"		mandatory="no">
			<cf_dbtempcol name="EPcodigo"		type="char(10)"		mandatory="no">
			<cf_dbtempcol name="Perceptil"		type="int"			mandatory="no">
			<cf_dbtempcol name="Salario"		type="money"		mandatory="no">
			<cf_dbtempcol name="Incidencias"	type="money"		mandatory="no">
			<cf_dbtempcol name="SalReferencia"	type="money"		mandatory="no">
			<cf_dbtempcol name="SalPeriodo"		type="money"		mandatory="no">
			<cf_dbtempcol name="SalMensual"		type="money"		mandatory="no">
		</cf_dbtemp>
		<cfset Request.Empleados = TablaEmpleados>
		<cfreturn TablaEmpleados>
	</cffunction>

	<!--- Tabla ocupada por el reporte de Análisis de Proyección Salarial --->
	<cffunction name="CrearTablaCalendario" access="package" output="false" returntype="string">
		<cfargument name="Conexion" type="string" required="no" default="#Session.DSN#">

		<cf_dbtemp name="ASalarial2" returnvariable="TablaCalendario" datasource="#Arguments.Conexion#">
			<cf_dbtempcol name="Tcodigo"	type="char(5)"		mandatory="no">
			<cf_dbtempcol name="CPid"		type="numeric"		mandatory="yes">
		</cf_dbtemp>
		<cfset Request.Calendarios = TablaCalendario>
		<cfreturn TablaCalendario>
	</cffunction>

	<!--- Tabla ocupada por el reporte de Análisis de Dispersión Salarial --->
	<cffunction name="CrearTablaEmpleadosRep2" access="package" output="false" returntype="string">
		<cfargument name="Conexion" type="string" required="no" default="#Session.DSN#">

		<cf_dbtemp name="ASalarial3" returnvariable="TablaEmpleados" datasource="#Arguments.Conexion#">
			<cf_dbtempcol name="DEid"			type="numeric"			mandatory="yes">
			<cf_dbtempcol name="Ecodigo"		type="numeric"			mandatory="yes">
			<cf_dbtempcol name="RHPcodigo"		type="char(10)"			mandatory="yes">
			<cf_dbtempcol name="LTsalario"		type="money"			mandatory="yes">
			<cf_dbtempcol name="ptsTotal"		type="int"				mandatory="yes">
			<cf_dbtempcol name="Nivel"			type="char(3)"			mandatory="no">
			<cf_dbtempcol name="minimo"			type="int"				mandatory="no">
			<cf_dbtempcol name="maximo"			type="int"				mandatory="no">
			<cf_dbtempcol name="xmenosX"		type="numeric(22,4)"	mandatory="no">
			<cf_dbtempcol name="xmenosXal2"		type="numeric(22,4)"	mandatory="no">
			<cf_dbtempcol name="ymenosY"		type="numeric(22,4)"	mandatory="no">
			<cf_dbtempcol name="valor"			type="numeric(22,4)"	mandatory="no">
			<cf_dbtempcol name="EPid"			type="numeric"			mandatory="no">
			<cf_dbtempcol name="EPcodigo"		type="char(10)"			mandatory="no">
			<cf_dbtempcol name="Perceptil"		type="int"				mandatory="no">
			<cf_dbtempcol name="SalReferencia"	type="money"			mandatory="no">
			<cf_dbtempcol name="Ttipopago"		type="int"				mandatory="yes">
		</cf_dbtemp>
		<cfset Request.Empleados = TablaEmpleados>
		<cfreturn TablaEmpleados>
	</cffunction>

	<!--- Tabla ocupada por el reporte de Análisis de Dispersión Salarial --->
	<cffunction name="CrearTablaNiveles" access="package" output="false" returntype="string">
		<cfargument name="Conexion" type="string" required="no" default="#Session.DSN#">

		<cf_dbtemp name="ASalarial4" returnvariable="TablaNiveles" datasource="#Arguments.Conexion#">
			<cf_dbtempcol name="id"					type="numeric"			identity="yes">
			<cf_dbtempcol name="Nivel"				type="char(3)"			mandatory="yes">
			<cf_dbtempcol name="PunMedios"			type="int"				mandatory="no">
			<cf_dbtempcol name="minimo"				type="int"				mandatory="no">
			<cf_dbtempcol name="maximo"				type="int"				mandatory="no">
			<cf_dbtempcol name="MedioMenosPorcen"	type="numeric(22,4)"	mandatory="no">
			<cf_dbtempcol name="Medio"				type="numeric(22,4)"	mandatory="no">
			<cf_dbtempcol name="MedioMasPorcen"		type="numeric(22,4)"	mandatory="no">
			<cf_dbtempcol name="Traslape"			type="numeric(10,4)"	mandatory="no">
			<cf_dbtempcol name="Amplitud"			type="numeric(10,4)"	mandatory="no">
			<cf_dbtempcol name="m"					type="numeric(22,4)"	mandatory="no">
			<cf_dbtempcol name="b"					type="numeric(22,4)"	mandatory="no">
			<cf_dbtempkey cols="id">
		</cf_dbtemp>
		<cfset Request.Niveles = TablaNiveles>
		<cfreturn TablaNiveles>
	</cffunction>

	<!--- Generación del Reporte de Análisis de Proyección Salarial --->
	<cffunction name="GenerarAnalisisSalarial" access="public" output="true" returntype="query">
		<cfargument name="RHASid" type="numeric" required="yes">
		<cfargument name="debug" type="boolean" required="no" default="false">
		<cfargument name="Conexion" type="string" required="no" default="#Session.DSN#">
		
		<!--- Crear Tablas Temporales --->
		<cfset LvarTabla1 = this.CrearTablaEmpleadosRep1()>
		<cfset LvarTabla2 = this.CrearTablaCalendario()>
		
		<!--- Obtener los parámetros del Análisis Salarial --->
		<cfquery name="rsAnalisis" datasource="#Arguments.Conexion#">
			select 	a.Ecodigo, 
					a.RHASdescripcion, 
					a.EEid, 
					a.ETid, 
					a.Eid, 
					a.Mcodigo, 
					a.NoSalario, 
					a.RHASref, 
					a.RHASaplicar, 
					a.RHASnumper, 
					a.BMUsucodigo
			from RHASalarial a
			where a.RHASid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RHASid#">
			and a.RHAStipo = 0
		</cfquery>
		<cfif rsAnalisis.recordCount EQ 0>
			<cfthrow message="Codigo de Analisis Salarial Invalido">
		</cfif>
		
		<!--- Parametros para el Generar el Reporte de Análisis de Proyección Salarial --->
		<cfset LvarEmpresa = rsAnalisis.Ecodigo>
		<cfset LvarFechaRef = rsAnalisis.RHASref>
		<cfset LvarTipo = rsAnalisis.RHASaplicar>
		<cfset LvarNumPeriodos = rsAnalisis.RHASnumper>
		<cfset LvarEncuesta = rsAnalisis.Eid>
		<cfset LvarEncuestadora = rsAnalisis.EEid>
		<cfset LvarTipoEncuesta = rsAnalisis.ETid>
		<cfset LvarMoneda = rsAnalisis.Mcodigo>
		<cfset LvarNoAplicaSalario = rsAnalisis.NoSalario>
		
		<!--- 
			Averiguar el tipo por defecto de las unidades de negocio
			Por Defecto el Tipo de Unidad de Negocio es por Centro Funcional
		--->
		<cfquery name="rsTipoCF" datasource="#Arguments.Conexion#">
			select count(1) as cantidad
			from RHASalarialUbicaciones
			where RHASid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RHASid#">
			and CFid is not null
		</cfquery>
		<cfset ExisteUbicXCF = rsTipoCF.cantidad>		<!--- Variable para indicar si ya existen unidades de negocio por Centro Funcional guardadas --->
		
		<cfquery name="rsTipoOD" datasource="#Arguments.Conexion#">
			select count(1) as cantidad
			from RHASalarialUbicaciones
			where RHASid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RHASid#">
			and Ocodigo is not null
			and Dcodigo is not null
		</cfquery>
		<cfset ExisteUbicXOD = rsTipoOD.cantidad>		<!--- Variable para indicar si ya existen unidades de negocio por Oficina/Depto guardadas --->

		<!--- Incluir todos los empleados que cumplan con los parámetros de Puesto 
			y unidades de negocio en las que estan ubicados --->
		<cfquery name="insEmpleados" datasource="#Arguments.Conexion#">
			insert into #Request.Empleados# (DEid, Ecodigo, Ocodigo, Dcodigo, RHPid, RHPcodigo, Tcodigo, Ttipopago, CFid, Eid, EEid, ETid, Mcodigo, EPid, EPcodigo, Perceptil, Salario, Incidencias, SalReferencia, SalPeriodo, SalMensual)
			select 	c.DEid, c.Ecodigo, c.Ocodigo, c.Dcodigo, c.RHPid, c.RHPcodigo, c.Tcodigo, t.Ttipopago, e.CFid, 
					a.Eid, a.EEid, a.ETid, a.Mcodigo, k.EPid, k.EPcodigo, d.RHASPperceptil, null, null, null, null, null
			from RHASalarial a
				inner join DatosEmpleado b
					on b.Ecodigo = a.Ecodigo
				inner join LineaTiempo c
					on c.DEid = b.DEid
					and <cfqueryparam cfsqltype="cf_sql_date" value="#Now()#"> between c.LTdesde and c.LThasta
				inner join TiposNomina t
					on t.Ecodigo = c.Ecodigo
					and t.Tcodigo = c.Tcodigo
				inner join RHASalarialPuestos d
					on d.RHASid = a.RHASid
					and d.Ecodigo = c.Ecodigo
					and d.RHPcodigo = c.RHPcodigo
					and d.EEid = a.EEid
				inner join RHEncuestaPuesto j
					on j.Ecodigo = d.Ecodigo
					and j.RHPcodigo = d.RHPcodigo
					and j.EEid = d.EEid
				inner join EncuestaPuesto k
					on k.EPid = j.EPid
					and k.EEid = j.EEid
				inner join RHPlazas e
					on e.RHPid = c.RHPid
			<cfif ExisteUbicXCF>
				inner join RHASalarialUbicaciones f
					on f.RHASid = a.RHASid
					and f.CFid = e.CFid
			<cfelseif ExisteUbicXOD>
				inner join RHASalarialUbicaciones f
					on f.RHASid = a.RHASid
					and f.Ecodigo = c.Ecodigo
					and f.Ocodigo = c.Ocodigo
					and f.Dcodigo = c.Dcodigo
			</cfif>
			where a.RHASid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RHASid#">
		</cfquery>
		
		
		
		<!--- Actualización de los Salarios de las Encuestas --->
		<cfquery name="updEmpleados1" datasource="#Arguments.Conexion#">
			update #Request.Empleados#
				set SalReferencia = coalesce((select case 
												when #Request.Empleados#.Perceptil = 1 then a.ESp25 
												when #Request.Empleados#.Perceptil = 2 then a.ESp50 
												when #Request.Empleados#.Perceptil = 3 then a.ESp75 
												when #Request.Empleados#.Perceptil = 4 then a.ESpromedio
												when #Request.Empleados#.Perceptil = 5 then a.ESvariacion
												else a.ESvariacion
											  end
											  from EncuestaSalarios a
											  where a.Eid = #Request.Empleados#.Eid
												and a.EEid = #Request.Empleados#.EEid
												and a.ETid = #Request.Empleados#.ETid
												and a.EPid = #Request.Empleados#.EPid
												and a.Moneda = #Request.Empleados#.Mcodigo
											),0.00)
		</cfquery>
		
		<!--- Obtención de los ultimos Calendarios de Pago para cada Tipo de Nomina --->
		<cfquery name="insCalendario" datasource="#Arguments.Conexion#">
			insert into #Request.Calendarios# (Tcodigo,CPid)
			select a.Tcodigo,max(RCNid) as CPid
			from HRCalculoNomina a 
				inner join CalendarioPagos b
					on b.CPid = a.RCNid
					and b.Tcodigo = a.Tcodigo
					and CPtipo = 0
			where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#LvarEmpresa#">
			  and a.RCdesde < <cfqueryparam cfsqltype="cf_sql_date" value="#LvarFechaRef#">
			group by a.Tcodigo
		</cfquery>
		
		
		<!--- Busca los salarios Base --->
		<!--- Si el tipo es mensual (0), se tomara el  salario del ultimo periodo y se llevara a mensual --->
		<cfif LvarTipo EQ 0>
			<cfif LvarNoAplicaSalario EQ 0>
				<!--- Se busca el salario --->
				<cfquery name="updEmpleados2" datasource="#Arguments.Conexion#">
					update #Request.Empleados#
						set Salario = coalesce((select sum(a.PEmontores)
												from HPagosEmpleado a, #Request.Calendarios# b
												where a.DEid = #Request.Empleados#.DEid
												and a.RCNid = b.CPid
												and a.Tcodigo = b.Tcodigo
												and PEtiporeg = 0
											  ), 0.00)
				</cfquery>
			</cfif>
			
			<!--- Se buscan las incidencias que se solicitarion que aplicaran --->
			<cfquery name="updEmpleados3" datasource="#Arguments.Conexion#">
				update #Request.Empleados#
					set Incidencias = coalesce((select sum(a.ICmontores)
												from HIncidenciasCalculo a, #Request.Calendarios# b
												where a.DEid = #Request.Empleados#.DEid
												and a.RCNid = b.CPid
												and #Request.Empleados#.Tcodigo = b.Tcodigo
												group by a.DEid)
												, 0.00)
			</cfquery>
			
			<!--- Se actualiza el salario del periodo --->
			<cfquery name="updEmpleados4" datasource="#Arguments.Conexion#">
				update #Request.Empleados#
					set SalPeriodo = Salario + Incidencias
			</cfquery>
		
		
		<!--- 
			Significa que el tipo es 1 o sea por periodo, por lo tanto se deben de tomar todos los periodos 
			que se indicaron y calcular el promedio por periodo y luego llevarlo a Mensual 
		--->
		<cfelse>
			<!--- se buscan la cantidad de periodos que se estan solicitando para cada tipo de nomina --->
			<cfset Lvarcuenta = 1>
			<cfloop condition="Lvarcuenta LT LvarNumPeriodos">
				<cfquery name="insCalendarios2" datasource="#Arguments.Conexion#">
 					insert into #Request.Calendarios# (CPid)
					select  max(RCNid) as CPid
					from HRCalculoNomina a 
						inner join CalendarioPagos b
							on b.CPid = a.RCNid
							and b.Tcodigo = a.Tcodigo
							and CPtipo = 0
					where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#LvarEmpresa#">
					  and a.RCdesde < <cfqueryparam cfsqltype="cf_sql_date" value="#LvarFechaRef#">
					  and RCNid not in (select CPid from #Request.Calendarios#)
					
				</cfquery>
				<cfset Lvarcuenta = Lvarcuenta + 1>
			</cfloop>
			
			
			<!--- se buscan los salarios recibidos durante estos periodos --->
			<cfif LvarNoAplicaSalario EQ 0>
				<cfquery name="updEmpleados5" datasource="#Arguments.Conexion#">
					update #Request.Empleados# 
						set Salario = coalesce((select sum(a.PEmontores)
												from HPagosEmpleado a, #Request.Calendarios# b
												where a.DEid = #Request.Empleados#.DEid
												and a.RCNid = b.CPid
												group by a.DEid			
												), 0.00)
				</cfquery>
			</cfif>
			
			<!--- se buscan las incidencias durante estos periodos, incluir solo las solicitadas --->
			<cfquery name="updEmpleados6" datasource="#Arguments.Conexion#">
				update #Request.Empleados#
					set Incidencias = coalesce((select sum(a.ICmontores)
												from HIncidenciasCalculo a, #Request.Calendarios# b
												where a.DEid = #Request.Empleados#.DEid
												and a.RCNid = b.CPid
												group by a.DEid), 0.00)
			</cfquery>
		
			<!--- se actualiza el salario del periodo --->
			<cfquery name="updEmpleados7" datasource="#Arguments.Conexion#">
				update #Request.Empleados# 
					set SalPeriodo = (Salario + Incidencias)/#LvarNumPeriodos#
			</cfquery>
		</cfif>

		<!--- Se genera el salario Mensual --->
		<cfquery name="updEmpleados8" datasource="#Arguments.Conexion#">
			update #Request.Empleados# 
				set SalMensual = case
									when Ttipopago = 0 then (SalPeriodo * 52)/12
									when Ttipopago = 1 then (SalPeriodo * 26)/12
									when Ttipopago = 2 then (SalPeriodo * 24)/12
									when Ttipopago = 3 then SalPeriodo
									else SalPeriodo
								end
		</cfquery>
		
		<!--- Salida --->
		<cfquery name="rsResultset" datasource="#Arguments.Conexion#">
			select	e.DEid, a.DEidentificacion, a.DEapellido1 || ' ' || a.DEapellido2 || ' ' || a.DEnombre as Nombre,
					b.CFcodigo, b.CFdescripcion, c.Ddescripcion,
					d.RHPdescpuesto, e.SalPeriodo, e.SalMensual, e.EPcodigo, 
					case when e.Ttipopago = 0 then 'Semanal'
						 when e.Ttipopago = 1 then 'Bisemanal'
						 when e.Ttipopago = 2 then 'Quincenal'
						 when e.Ttipopago = 3 then 'Mensual'
						 else ''
					end as TipoPago, 
					rtrim(b.CFcodigo) || ' ' || b.CFdescripcion || ' ' || 
					(
					case when e.Ttipopago = 0 then 'Semanal'
						 when e.Ttipopago = 1 then 'Bisemanal'
						 when e.Ttipopago = 2 then 'Quincenal'
						 when e.Ttipopago = 3 then 'Mensual'
						 else ''
					end
					) as Agrupador,
					case 
						when e.Perceptil = 1 then '25'
						when e.Perceptil = 2 then '50'
						when e.Perceptil = 3 then '75'
						when e.Perceptil = 4 then 'PROM'
						when e.Perceptil = 5 then 'VAR'
						else ''
					end as Perceptil, 
					e.SalReferencia,
					e.Salario,
					e.Incidencias
			from #Request.Empleados# e
				inner join DatosEmpleado a
					on a.Ecodigo = e.Ecodigo 
					and a.DEid = e.DEid 
				left outer join CFuncional b
					on b.Ecodigo = e.Ecodigo
					and b.CFid = e.CFid 
				left outer join Departamentos c
					on c.Ecodigo = e.Ecodigo 
					and c.Dcodigo = e.Dcodigo
				inner join RHPuestos d
					on d.Ecodigo = e.Ecodigo 
					and ltrim(rtrim(d.RHPcodigo)) = ltrim(rtrim(e.RHPcodigo))
			order by b.CFcodigo, e.Ttipopago, a.DEidentificacion
		</cfquery>
		
		<cfif Arguments.debug>
			<cfquery name="rs1" datasource="#Arguments.Conexion#">
				select *
				from #Request.Empleados#
			</cfquery>
			<cfdump var="#rs1#" label="Empleados">

			<cfquery name="rs2" datasource="#Arguments.Conexion#">
				select *
				from #Request.Calendarios#
			</cfquery>
			<cfdump var="#rs2#" label="Calendarios">
		
			<cftransaction action="rollback">
		</cfif>
		
		<cfreturn rsResultset>
	</cffunction>

	<cffunction name="GenerarTablasDispersion" access="public" output="false" returntype="numeric">
		<!--- Crear Tablas Temporales --->
		<cfset LvarTabla1 = this.CrearTablaEmpleadosRep2()>
		<cfset LvarTabla2 = this.CrearTablaNiveles()>
		<cfset LvarTabla3 = this.CrearTablaCalendario()>
		<cfreturn 0>
	</cffunction>

	<!--- Generación del Reporte de Análisis de Dispersión Salarial --->
	<cffunction name="GenerarDispersionSalarial" access="public" output="true" returntype="numeric">
		<cfargument name="RHASid" type="numeric" required="yes">
		<cfargument name="debug" type="boolean" required="no" default="false">
		<cfargument name="Conexion" type="string" required="no" default="#Session.DSN#">
		
		<!--- Obtener los parámetros del Análisis Salarial --->
		<cfquery name="rsAnalisis" datasource="#Arguments.Conexion#">
			select 	a.Ecodigo, 
					a.RHASdescripcion, 
					a.EEid, 
					a.ETid, 
					a.Eid, 
					a.Mcodigo, 
					a.NoSalario, 
					a.RHASref, 
					a.ESid,
					a.RHASporcentaje,
					a.BMUsucodigo
			from RHASalarial a
			where a.RHASid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RHASid#">
			and a.RHAStipo = 1
		</cfquery>
		<cfif rsAnalisis.recordCount EQ 0>
			<cfthrow message="Codigo de Analisis Salarial Invalido">
		</cfif>
		
		<!--- Parametros para el Generar el Reporte de Análisis de Dispersión Salarial --->
		<cfset LvarEmpresa = rsAnalisis.Ecodigo>
		<cfset LvarFechaRef = rsAnalisis.RHASref>
		<cfset LvarEncuesta = rsAnalisis.Eid>
		<cfset LvarEncuestadora = rsAnalisis.EEid>
		<cfset LvarTipoEncuesta = rsAnalisis.ETid>
		<cfset LvarMoneda = rsAnalisis.Mcodigo>
		<cfset LvarNoAplicaSalario = rsAnalisis.NoSalario>
		<cfset LvarEscalaHAY = rsAnalisis.ESid>
		<!--- <cfset LvarPorcentaje = rsAnalisis.RHASporcentaje / 100.0> --->
		
		<!--- Incluir todos los empleados que cumplan con los parámetros de Puesto a los cuales pertenecen --->
		<cfquery name="insEmpleados" datasource="#Arguments.Conexion#">
			insert into #Request.Empleados# (DEid, Ecodigo, RHPcodigo, LTsalario, ptsTotal, Ttipopago,
				Nivel, minimo, maximo, xmenosX, xmenosXal2, ymenosY, valor, EPid, EPcodigo, Perceptil, SalReferencia)
			select 	c.DEid, c.Ecodigo, c.RHPcodigo, c.LTsalario, e.ptsTotal, Ttipopago,
				null, null, null, null, null, null, null, k.EPid, k.EPcodigo, d.RHASPperceptil, null
			from RHASalarial a
				inner join DatosEmpleado b
					on b.Ecodigo = a.Ecodigo
				inner join LineaTiempo c
					on c.DEid = b.DEid
					and <cfqueryparam cfsqltype="cf_sql_date" value="#Now()#"> between c.LTdesde and c.LThasta
				inner join TiposNomina t
					on t.Ecodigo = c.Ecodigo
					and t.Tcodigo = c.Tcodigo
				inner join RHASalarialPuestos d
					on d.RHASid = a.RHASid
					and d.Ecodigo = c.Ecodigo
					and d.RHPcodigo = c.RHPcodigo
					and d.EEid = a.EEid
				inner join RHPuestos e
					on e.Ecodigo = d.Ecodigo
					and e.RHPcodigo = d.RHPcodigo
				inner join RHEncuestaPuesto j
					on j.Ecodigo = d.Ecodigo
					and j.RHPcodigo = d.RHPcodigo
					and j.EEid = d.EEid
				inner join EncuestaPuesto k
					on k.EPid = j.EPid
					and k.EEid = j.EEid
			where a.RHASid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RHASid#">
		</cfquery>
		<!--- Busca la ultima nomina aplicada para saber el salario y lo pasa a Mensual. --->

		<!--- Obtención de los ultimos Calendarios de Pago para cada Tipo de Nomina --->
		<cfquery name="insCalendario" datasource="#Arguments.Conexion#">
			insert into #Request.Calendarios# (CPid)
			select max(RCNid) as CPid
			from HRCalculoNomina a 
				inner join CalendarioPagos b
					on b.CPid = a.RCNid
					and b.Tcodigo = a.Tcodigo
					and CPtipo = 0
			where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#LvarEmpresa#">
			  and a.RCdesde < <cfqueryparam cfsqltype="cf_sql_date" value="#LvarFechaRef#">
		</cfquery>

		<!--- Se busca el salario --->
		<cfquery name="updEmpleados2" datasource="#Arguments.Conexion#">
			update #Request.Empleados#
				set LTsalario = coalesce((select sum(a.PEmontores)
										from HPagosEmpleado a, #Request.Calendarios# b
										where a.DEid = #Request.Empleados#.DEid
										and a.RCNid = b.CPid
										and PEtiporeg = 0
									  ), 0.00)
		</cfquery>
		<!--- Se genera el salario Mensual --->
		<cfquery name="updEmpleados8" datasource="#Arguments.Conexion#">
			update #Request.Empleados# 
				set LTsalario = case
									when Ttipopago = 0 then (LTsalario * 52)/12
									when Ttipopago = 1 then (LTsalario * 26)/12
									when Ttipopago = 2 then (LTsalario * 24)/12
									when Ttipopago = 3 then LTsalario
									else LTsalario
								end
		</cfquery>
		<!--- Actualiza los salarios de las encuestas --->
		<cfquery name="updSalarios" datasource="#Arguments.Conexion#">
			update #Request.Empleados#
				set SalReferencia = coalesce((select case 
												when #Request.Empleados#.Perceptil = 1 then a.ESp25 
												when #Request.Empleados#.Perceptil = 2 then a.ESp50 
												when #Request.Empleados#.Perceptil = 3 then a.ESp75 
												when #Request.Empleados#.Perceptil = 4 then a.ESpromedio
												when #Request.Empleados#.Perceptil = 5 then a.ESvariacion
												else a.ESvariacion
											  end
											  from EncuestaSalarios a
											  where a.Eid = #LvarEncuesta#
												and a.EEid = #LvarEncuestadora#
												and a.ETid = #LvarTipoEncuesta#
												and a.EPid = #Request.Empleados#.EPid
												and a.Moneda = #LvarMoneda#
											),0.00)
		</cfquery>
		
		<!--- Actualiza los niveles de la escala HAY a aplicar --->
		<cfquery name="updEmpleados1" datasource="#Arguments.Conexion#">
			update #Request.Empleados# set
				Nivel = ( select a.DESnivel from RHDEscalaSalHAY a
						  where a.ESid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarEscalaHAY#">
						  and #Request.Empleados#.ptsTotal between a.DESptodesde and a.DESptohasta
						),
				minimo = ( select a.DESptodesde from RHDEscalaSalHAY a
						  where a.ESid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarEscalaHAY#">
						  and #Request.Empleados#.ptsTotal between a.DESptodesde and a.DESptohasta
						),
				maximo = ( select a.DESptohasta from RHDEscalaSalHAY a
						  where a.ESid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarEscalaHAY#">
						  and #Request.Empleados#.ptsTotal between a.DESptodesde and a.DESptohasta
						)

		</cfquery>
		
		<!--- Inserta en la tabla resumen por nivel --->
		<cfquery name="insNiveles" datasource="#Arguments.Conexion#">
			insert into #Request.Niveles# (Nivel, PunMedios, minimo, maximo)
			select distinct Nivel, (minimo + maximo) / 2, minimo, maximo from #Request.Empleados#
			where maximo <> 0
			order by minimo
		</cfquery>
		
		<!--- Calcula Campos de la Formula --->
		<cfquery name="Calculo1" datasource="#Arguments.Conexion#">
			select coalesce(avg(convert(money, ptsTotal)), 0.0000) as promediox
			from #Request.Empleados#
		</cfquery>
		<cfset LvarPromedioX = Calculo1.promediox>
		<cfquery name="Calculo2" datasource="#Arguments.Conexion#">
			select coalesce(avg(LTsalario), 0.0000) as promedioy
			from #Request.Empleados#
		</cfquery>
		<cfset LvarPromedioY = Calculo2.promedioy>
		
		<cfquery name="updEmpleadosX" datasource="#Arguments.Conexion#">
			update #Request.Empleados# set
				xmenosX = round(ptsTotal - #LvarPromedioX#, 4),
				ymenosY = round(LTsalario - #LvarPromedioY#, 4)
		</cfquery>
		<cfquery name="updEmpleadosY" datasource="#Arguments.Conexion#">
			update #Request.Empleados# set
				xmenosXal2 = round(xmenosX * xmenosX, 4),
				valor = round(xmenosX * ymenosY, 4)
		</cfquery>
		
		<cfquery name="Calculo3" datasource="#Arguments.Conexion#">
			select coalesce(avg(xmenosXal2), 0.0000) as xmenosXal2
			from #Request.Empleados#
		</cfquery>
		<cfset LvarPromxmenosXal2 = Calculo3.xmenosXal2>
		<cfquery name="Calculo4" datasource="#Arguments.Conexion#">
			select coalesce(avg(ymenosY), 0.0000) as ymenosY
			from #Request.Empleados#
		</cfquery>
		<cfset LvarPromymenosY = Calculo4.ymenosY>
		<cfquery name="Calculo5" datasource="#Arguments.Conexion#">
			select coalesce(avg(valor), 0.0000) as valor
			from #Request.Empleados#
		</cfquery>
		<cfset LvarPromPxPy = Calculo5.valor>
		
		<!--- Calcula M y B --->
		<cfif LvarPromxmenosXal2 GT 0>
			<cfset LvarM = LvarPromPxPy / LvarPromxmenosXal2>
		<cfelse>
			<cfset LvarM = LvarPromPxPy>
		</cfif>
		<cfset LvarB = ((LvarM * -1.0) * LvarPromedioX) + LvarPromedioY>
		
		<!--- <!--- Actualiza los salarios del nivel --->
		<cfquery name="updSalarios" datasource="#Arguments.Conexion#">
			update #Request.Niveles# set
				Medio = round((#LvarM# * PunMedios) + #LvarB#, 4)
		</cfquery>
		
		<!--- Actualiza los demás campos en la tabla de Niveles --->
		<cfquery name="updNiveles" datasource="#Arguments.Conexion#">
			update #Request.Niveles# set
				MedioMenosPorcen = round(Medio - (Medio * #LvarPorcentaje#), 4),
				MedioMasPorcen = round(Medio + (Medio * #LvarPorcentaje#), 4),
				m = round(#LvarM#, 4),
				b = round(#LvarB#, 4)
		</cfquery> --->
		<cfquery name="updNiveles" datasource="#Arguments.Conexion#">
			update #Request.Niveles# set
			MedioMenosPorcen = ( select a.DESsalmin from RHDEscalaSalHAY a
								  where a.ESid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarEscalaHAY#">
								  and #Request.Niveles#.minimo between a.DESptodesde and a.DESptohasta
								),
			Medio = ( select a.DESsalprom from RHDEscalaSalHAY a
								  where a.ESid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarEscalaHAY#">
								  and #Request.Niveles#.PunMedios between a.DESptodesde and a.DESptohasta
								),
			MedioMasPorcen = ( select a.DESsalmax from RHDEscalaSalHAY a
								  where a.ESid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarEscalaHAY#">
								  and #Request.Niveles#.maximo between a.DESptodesde and a.DESptohasta
								),
			m = round(#LvarM#, 4),
			b = round(#LvarB#, 4)
		</cfquery>
		
		<!--- Actualiza la columna de Amplitud --->
		<cfquery name="updNiveles" datasource="#Arguments.Conexion#">
			update #Request.Niveles# set
				Amplitud = round(((MedioMasPorcen - MedioMenosPorcen) / MedioMenosPorcen) * 100, 4)
		</cfquery>
		
		<!--- Actualización de la columna de Traslape --->
		<cfquery name="rsNiveles" datasource="#Arguments.Conexion#">
			select *
			from #Request.Niveles#
			order by minimo desc
		</cfquery>
		<cfloop query="rsNiveles">
			<cfif rsNiveles.currentRow NEQ 1>
				<cfquery name="updNiveles" datasource="#Arguments.Conexion#">
					update #Request.Niveles# set
						Traslape = round(((MedioMasPorcen - #MedioMenosPorcen_Ant#) / #MedioMenosPorcen_Ant#) * 100, 4)
					where id = #rsNiveles.id#
				</cfquery>
			</cfif>
			<cfset MedioMenosPorcen_Ant = rsNiveles.MedioMenosPorcen>
		</cfloop>
		
		<cfif Arguments.debug>
			<cfquery name="rs1" datasource="#Arguments.Conexion#">
				select *
				from #Request.Empleados#
			</cfquery>
			<cfdump var="#rs1#" label="Empleados">

			<cfquery name="rs2" datasource="#Arguments.Conexion#">
				select *
				from #Request.Niveles#
			</cfquery>
			<cfdump var="#rs2#" label="Niveles">
		
			<cftransaction action="rollback">
		</cfif>
		
		<cfreturn 0>
	</cffunction>

	<cffunction name="obtenerDatosNiveles" access="public" output="true" returntype="query">
		<cfargument name="order" type="numeric" required="yes">		<!--- 1: ascendente; 2: descendente --->
		<cfargument name="Conexion" type="string" required="no" default="#Session.DSN#">
		
		<cfquery name="rsResultset" datasource="#Arguments.Conexion#">
			select Nivel, minimo, PunMedios, maximo, 
				   MedioMenosPorcen, Medio, MedioMasPorcen, 
				   Traslape, Amplitud,
				   m, b
			from #Request.Niveles#
			order by minimo <cfif Arguments.order EQ 1>asc<cfelseif Arguments.order EQ 2>desc</cfif>
		</cfquery>
		
		<cfreturn rsResultset>
	</cffunction>
	
	<cffunction name="obtenerDatosEmpresa" access="public" output="true" returntype="query">
		<cfargument name="order" type="numeric" required="yes">		<!--- 1: ascendente; 2: descendente --->
		<cfargument name="Conexion" type="string" required="no" default="#Session.DSN#">
		
		<cfquery name="rsResultset" datasource="#Arguments.Conexion#">
			select LTsalario,ptsTotal as PunMedios, DEid
			from #Request.Empleados#
			order by minimo <cfif Arguments.order EQ 1>asc<cfelseif Arguments.order EQ 2>desc</cfif>
		</cfquery>
		
		<cfreturn rsResultset>
	</cffunction>
	
	<cffunction name="obtenerDatosEncuesta" access="public" output="true" returntype="query">
		<cfargument name="order" type="numeric" required="yes">		<!--- 1: ascendente; 2: descendente --->
		<cfargument name="Conexion" type="string" required="no" default="#Session.DSN#">
		
		<cfquery name="rsResultset" datasource="#Arguments.Conexion#">
			select SalReferencia,ptsTotal as PunMedios, DEid
			from #Request.Empleados#
			order by minimo <cfif Arguments.order EQ 1>asc<cfelseif Arguments.order EQ 2>desc</cfif>
		</cfquery>
		
		<cfreturn rsResultset>
	</cffunction>
	
	
	<!--- Generación del Reporte de Análisis de Dispersión Salarial --->
	<cffunction name="ObtenerDetalleDispersion" access="public" output="true" returntype="query">
		<cfargument name="PunMedios" type="numeric" required="yes">
		<cfargument name="porcentaje" type="numeric" required="no">
		<cfargument name="debug" type="boolean" required="no" default="false">
		<cfargument name="Conexion" type="string" required="no" default="#Session.DSN#">
		
		<cfquery name="rsNivel" datasource="#Arguments.Conexion#">
			select Nivel
			from #Request.Niveles#
			where PunMedios = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.PunMedios#">
		</cfquery>
		<cfset LvarNivel = rsNivel.Nivel>
		
		<cfquery name="resultSet" datasource="#Arguments.Conexion#">
			select  b.DEidentificacion,
					rtrim(b.DEapellido1 || ' ' || b.DEapellido2) || ', ' || b.DEnombre as Nombre,
					c.RHPcodigo,
					c.RHPdescpuesto,
					DESsalmin,
					DESsalprom,
					DESsalmax,
					a.LTsalario as Salario,
					a.ptsTotal,
					a.Nivel,
					a.minimo,
					(a.minimo + a.maximo) / 2 as PunMedios,
					a.maximo,
					case 
						when a.Perceptil = 1 then '25'
						when a.Perceptil = 2 then '50'
						when a.Perceptil = 3 then '75'
						when a.Perceptil = 4 then 'PROM'
						when a.Perceptil = 5 then 'VAR'
						else ''
					end as Perceptil,
					a.SalReferencia
			from #Request.Empleados# a
				inner join DatosEmpleado b
					on b.DEid = a.DEid
				inner join RHPuestos c
					on c.Ecodigo = a.Ecodigo
					and c.RHPcodigo = a.RHPcodigo
				inner join RHDEscalaSalHAY d
					on a.ptsTotal between d.DESptodesde and d.DESptohasta
					
			<!--- where a.Nivel = <cfqueryparam cfsqltype="cf_sql_char" value="#LvarNivel#"> --->
			order by a.Nivel,b.DEidentificacion
		</cfquery>
		<cfreturn resultSet>
	</cffunction>

</cfcomponent>
