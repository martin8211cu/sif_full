<cfcomponent>

	<!--- 
    Comportamiento de Acciones de personal
    1	Nombramiento
    2	Cese
    3	Vacaciones
    4	Permiso
    5	Incapacidad
    6	Cambio
    7	Anulación
	8   Aumento
	9   Cambio de Empresa
	--->

	<cfset Exceso = 0>
	
	<cffunction name="VacacionesEmpleado" access="public" output="true" returntype="boolean">
		<cfargument name="Ecodigo" type="numeric" required="yes">
		<cfargument name="RHAlinea" type="numeric" required="yes">		<!--- Accion en Proceso --->
		<cfargument name="DLlinea" type="numeric" required="yes">
		<cfargument name="DEid" type="numeric" required="yes">			<!--- Empleado --->
		<cfargument name="Usucodigo" type="string" required="no" default="#Session.Usucodigo#">
		<cfargument name="conexion" type="string" required="no" default="#Session.DSN#">
		<cfargument name="debug" type="boolean" required="no" default="false">

		<cfquery name="dataTipoAccion" datasource="#Arguments.conexion#">
			select  a.RHTcomportam,
					b.DLfvigencia as fechadesde,
					b.DLffin as fechahasta,
					b.RVid
			from RHTipoAccion a, RHAcciones b 
			where a.RHTid = b.RHTid
			and b.RHAlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RHAlinea#">
		</cfquery>
		
		<!--- Quitar las horas de las fechas --->
		<cfset LvarTemp = LSDateFormat(dataTipoAccion.fechadesde, 'dd/mm/yyyy')>
		<cfset Fdesde = CreateDate(ListGetAt(LvarTemp, 3, '/'), ListGetAt(LvarTemp, 2, '/'), ListGetAt(LvarTemp, 1, '/'))>
		<cfif Len(Trim(dataTipoAccion.fechahasta))>
			<cfset LvarTemp = LSDateFormat(dataTipoAccion.fechahasta, 'dd/mm/yyyy')>
			<cfset Fhasta = CreateDate(ListGetAt(LvarTemp, 3, '/'), ListGetAt(LvarTemp, 2, '/'), ListGetAt(LvarTemp, 1, '/'))>
		<cfelse>
			<cfset Fhasta = CreateDate(6100, 01, 01)>
		</cfif>
		
		<cfquery name="rsEVacaciones" datasource="#Arguments.conexion#">
			select 1 
			from EVacacionesEmpleado 
			where DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.DEid#">
		</cfquery>
		
		<!--- Inserta el registro nuevo en la tabla de Vacaciones si no hay registros --->
		<cfif rsEVacaciones.recordCount EQ 0>
			<cfquery name="insVacaciones" datasource="#Arguments.conexion#">
				insert into EVacacionesEmpleado (DEid, EVfantig, EVfecha, EVmes, EVdia, EVinicializar,EVfvacas)
				values (
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.DEid#">, 
					<cfqueryparam cfsqltype="cf_sql_timestamp" value="#Fdesde#">, 
					<cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">, 
					<cfqueryparam cfsqltype="cf_sql_integer" value="#DatePart('m', Fdesde)#">, 
					<cfqueryparam cfsqltype="cf_sql_integer" value="#DatePart('d', Fdesde)#">, 
					0,
					<cfqueryparam cfsqltype="cf_sql_timestamp" value="#Fdesde#">
				)
			</cfquery>
		</cfif>
		
		<!--- ACCION DE COMPORTAMIENTO NOMBRAMIENTO --->
		<cfif dataTipoAccion.RHTcomportam EQ 1>
			<cfquery name="rsEVacaciones" datasource="#Arguments.conexion#">
				select 1 
				from EVacacionesEmpleado 
				where DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.DEid#">
				and EVinicializar = 1			
			</cfquery>
			
			<cfif rsEVacaciones.recordCount>
				<cfquery name="updEVacaciones" datasource="#Arguments.conexion#">
					update EVacacionesEmpleado set 
						EVfantig = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Fdesde#">,
						EVfvacas = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Fdesde#">,
						EVmes    = <cfqueryparam cfsqltype="cf_sql_integer" value="#DatePart('m', Fdesde)#">, 
						EVdia    = <cfqueryparam cfsqltype="cf_sql_integer" value="#DatePart('d', Fdesde)#">, 
						EVinicializar = 0
					where DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.DEid#">
				</cfquery>
			</cfif>

			<!--- Si el nombramiento es retroactivo --->
			<cfset LvarTemp = LSDateFormat(Now(), 'dd/mm/yyyy')>
			<cfset Hoy = CreateDate(ListGetAt(LvarTemp, 3, '/'), ListGetAt(LvarTemp, 2, '/'), ListGetAt(LvarTemp, 1, '/'))>
			<cfset agnos = 0>

			<cfif DateCompare(Fdesde, Hoy) LT 0>
				<cfset agnos = Int(DateDiff('d', Fdesde, Hoy) / 365.0)>
			</cfif>

			<cfif agnos GT 0>
					<!--- determina la cantidad de días totales de vacaciones que tiene según años laborados desde la fecha de nombramiento a la fecha de hoy --->
					<cfquery name="rsRegimen" datasource="#Arguments.conexion#">
						select 
							coalesce((DRVdias * (
													case when (
																select coalesce(min(DRVcant-1), <cfqueryparam cfsqltype="cf_sql_integer" value="#agnos#">+1) 
																from DRegimenVacaciones t2 
																where t2.RVid = t1.RVid 
																and t1.DRVcant < t2.DRVcant
															   ) > <cfqueryparam cfsqltype="cf_sql_integer" value="#agnos#">
														 then <cfqueryparam cfsqltype="cf_sql_integer" value="#agnos#">
														 else (select coalesce(min (DRVcant-1), <cfqueryparam cfsqltype="cf_sql_integer" value="#agnos#">+1) 
															   from DRegimenVacaciones t2 
															   where t2.RVid = t1.RVid 
															   and t1.DRVcant < t2.DRVcant
															   ) 
													end
													- 
													case when DRVcant = 0 
														 then 1 
														 else DRVcant 
													end 
													+ 1 
													)
										), 
							0) as totaldiasvac,
							coalesce((DRVdiasadic * (
													case when (
																select coalesce(min(DRVcant-1), <cfqueryparam cfsqltype="cf_sql_integer" value="#agnos#">+1) 
																from DRegimenVacaciones t2 
																where t2.RVid = t1.RVid 
																and t1.DRVcant < t2.DRVcant
															   ) > <cfqueryparam cfsqltype="cf_sql_integer" value="#agnos#">
														 then <cfqueryparam cfsqltype="cf_sql_integer" value="#agnos#">
														 else (select coalesce(min (DRVcant-1), <cfqueryparam cfsqltype="cf_sql_integer" value="#agnos#">+1) 
															   from DRegimenVacaciones t2 
															   where t2.RVid = t1.RVid 
															   and t1.DRVcant < t2.DRVcant
															   ) 
													end
													- 
													case when DRVcant = 0 
														 then 1 
														 else DRVcant 
													end 
													+ 1 
													)
										), 
							0) as totaldiasvacadic,
							coalesce((DRVdiasenf * (
													case when (
																select coalesce(min (DRVcant-1), <cfqueryparam cfsqltype="cf_sql_integer" value="#agnos#">+1) 
																from DRegimenVacaciones t2 
																where t2.RVid = t1.RVid 
																and t1.DRVcant < t2.DRVcant
															   ) > <cfqueryparam cfsqltype="cf_sql_integer" value="#agnos#">
														 then <cfqueryparam cfsqltype="cf_sql_integer" value="#agnos#">
														 else (select coalesce(min (DRVcant-1), <cfqueryparam cfsqltype="cf_sql_integer" value="#agnos#">+1) 
															   from DRegimenVacaciones t2 
															   where t2.RVid = t1.RVid 
															   and t1.DRVcant < t2.DRVcant
															   ) 
													end
													- 
													case when DRVcant = 0 
														 then 1 
														 else DRVcant 
													end 
													+ 1 
													)
										), 
							0) as totaldiasvacenf
						from DRegimenVacaciones t1
						where t1.RVid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#dataTipoAccion.RVid#">
						and DRVcant <= <cfqueryparam cfsqltype="cf_sql_integer" value="#agnos#">
					</cfquery>
					<cfif rsRegimen.recordCount>
						<cfquery name="rssumRegimen" dbtype="query">
							select 
								sum(totaldiasvac) as totaldiasvac,
								sum(totaldiasvacenf) as totaldiasvacenf,
								sum(totaldiasvacadic) as totaldiasvacadic
							from rsRegimen
						</cfquery>
						<cfset TotalDiasVac = rssumRegimen.totaldiasvac>
						<cfset TotalDiasVacEnf = rssumRegimen.totaldiasvacenf>
						<cfset TotalDiasVacAdic = rssumRegimen.totaldiasvacadic>
					<cfelse>
						<cfset TotalDiasVac = 0>
						<cfset TotalDiasVacEnf = 0>
						<cfset TotalDiasVacAdic = 0>
					</cfif>
	
					<!--- Inserta el Detalle de Vacaciones por el Total acumulado que tiene el empleado --->
					<!--- Dias de Vacaciones --->
					<cfquery name="insDVacaciones" datasource="#Arguments.conexion#">
						insert into DVacacionesEmpleado(DEid, Ecodigo, DVEfecha, DVEreferencia, DVEdescripcion, DVEdisfrutados, DVEcompensados, DVEmonto, Usucodigo, Ulocalizacion, DVEfalta, DVEenfermedad)
						select <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.DEid#">, 
							   <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#">, 
							   <!--- <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Fdesde#">, --->
							   <cfqueryparam cfsqltype="cf_sql_date" value="#Now()#">, 
							   <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.DLlinea#">, 
							   coalesce(substring(DLobs, 1, 60), 'Vacaciones por Nombramiento Retroactivo #LSDateFormat(Fdesde, 'dd/mm/yyyy')#'), 
							   <cfqueryparam cfsqltype="cf_sql_float" value="#TotalDiasVac#">, 
							   0, 
							   0.00, 
							   <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Usucodigo#">, 
							   '00', 
							   <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">, 
							   0
						from RHAcciones 
						where RHAlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RHAlinea#">
					</cfquery>
					<!--- Dias de Vacaciones Adicionales --->
					<cfquery name="insDVacaciones" datasource="#Arguments.conexion#">
						insert into DVacacionesEmpleado(DEid, Ecodigo, DVEfecha, DVEreferencia, DVEdescripcion, DVEdisfrutados, DVEcompensados, DVEmonto, Usucodigo, Ulocalizacion, DVEfalta, DVEenfermedad)
						select <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.DEid#">, 
							   <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#">, 
							   <!--- <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Fdesde#">, --->
							   <cfqueryparam cfsqltype="cf_sql_date" value="#Now()#">, 
							   <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.DLlinea#">, 
							   coalesce(substring(DLobs, 1, 60), 'Vacaciones Adic. por Nombramiento Retroact. #LSDateFormat(Fdesde, 'dd/mm/yyyy')#'), 
							   <cfqueryparam cfsqltype="cf_sql_float" value="#TotalDiasVacAdic#">,
							   0, 
							   0.00, 
							   <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Usucodigo#">, 
							   '00', 
							   <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">, 
							   0
						from RHAcciones 
						where RHAlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RHAlinea#">
					</cfquery>
	
					<!--- Dias de Enfermedad --->
					<cfquery name="insDVacaciones" datasource="#Arguments.conexion#">
						insert into DVacacionesEmpleado(DEid, Ecodigo, DVEfecha, DVEreferencia, DVEdescripcion, DVEdisfrutados, DVEcompensados, DVEmonto, Usucodigo, Ulocalizacion, DVEfalta, DVEenfermedad)
						select <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.DEid#">, 
							   <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#">, 
							   <!--- <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Fdesde#">, --->
							   <cfqueryparam cfsqltype="cf_sql_date" value="#Now()#">, 
							   <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.DLlinea#">, 
							   coalesce(substring(DLobs, 1, 60), 'Dias de Enfermedad Nombramiento Retroact. #LSDateFormat(Fdesde, 'dd/mm/yyyy')#'), 
							   0, 
							   0, 
							   0.00, 
							   <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Usucodigo#">, 
							   '00', 
							   <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">, 
							   <cfqueryparam cfsqltype="cf_sql_float" value="#TotalDiasVacEnf#">
						from RHAcciones 
						where RHAlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RHAlinea#">
					</cfquery>
					
					<!--- Actualiza la Fecha de Corte en el Encabezado --->
					<cfquery name="updEncabezadoVacaciones" datasource="#Arguments.conexion#">
						update EVacacionesEmpleado
						set EVfecha = <cfqueryparam cfsqltype="cf_sql_date" value="#DateAdd('yyyy', agnos, Fdesde)#">
						where DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.DEid#">
					</cfquery>
				<cfquery name="rsVacPotenciales" datasource="#Arguments.conexion#">
					select coalesce(min(rv.DRVdias), 0) as VacPotenciales
					from DRegimenVacaciones rv 
					where rv.RVid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#dataTipoAccion.RVid#">
						and rv.DRVcant <= <cfqueryparam cfsqltype="cf_sql_numeric" value="#agnos#">
				</cfquery>
				
			<cfelse>
				<!--- No ha transcurrido un año desde la fecha de nombramiento del empleado, por lo que se debe inicializar la columna EVfecha con la fecha de ingreso --->
				<cfquery name="updEncabezadoVacaciones" datasource="#Arguments.conexion#">
					update EVacacionesEmpleado
					set EVfecha = <cfqueryparam cfsqltype="cf_sql_date" value="#Fdesde#">
					where DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.DEid#">
				</cfquery>
				<cfquery name="rsVacPotenciales" datasource="#Arguments.conexion#">
					select coalesce(min(rv.DRVdias), 0) as VacPotenciales
					from DRegimenVacaciones rv 
					where rv.RVid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#dataTipoAccion.RVid#">
				</cfquery>
			</cfif>
			<cfinvoke component="RHParametros" method="get" datasource="#session.dsn#" ecodigo="#session.Ecodigo#" pvalor="2505" default="0" returnvariable="vCtrlVacXPeriodo"/>
			<cfif vCtrlVacXPeriodo>
				<cfquery datasource="#Arguments.conexion#">
					insert into DVacacionesAcum
						(DEid, DVAdiasPotenciales, DVAperiodo, DVAsaldodias, DVASalarioProm, DVASalarioPdiario, DVAfecha, Ecodigo)
					values
						(#Arguments.DEid#,#rsVacPotenciales.VacPotenciales#,#Year(dataTipoAccion.fechadesde)#,0,0,0,
						<cfqueryparam cfsqltype="cf_sql_timestamp" value="#Fdesde#">,#session.Ecodigo#)
				</cfquery>
			</cfif>
		</cfif>
		<!--- ACCION DE COMPORTAMIENTO CESE --->
		<cfif dataTipoAccion.RHTcomportam EQ 2>

			<!--- Calculo de Vacaciones --->
			<!--- Buscar fecha de antiguedad y fecha de corte del ultimo calculo de vacaciones del empleado --->
			<cfquery name="rsFechaAntiguedad" datasource="#Arguments.conexion#">
				select EVfantig, EVfecha
				from EVacacionesEmpleado
				where DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.DEid#">
			</cfquery>

			<cfset vFecha = ListToArray(LSDateFormat(rsFechaAntiguedad.EVfantig,'dd/mm/yyyy'),'/')>
			<cfset fecha_ingreso = Createdate(vFecha[3],vFecha[2],vfecha[1]) >
			<cfset vFecha = ListToArray(LSDateFormat(rsFechaAntiguedad.EVfecha,'dd/mm/yyyy'),'/')>
			<cfset fecha_corte = Createdate(vFecha[3],vFecha[2],vfecha[1]) >
			<!--- calcula la cantidad de años laborados, a partir de la fecha ingreso --->
			<cfset annoslaborados = DateDiff('yyyy', fecha_ingreso, fecha_corte)>

			<!--- calcula la cantidad de años, a partir de la fecha de corte --->
			<cfset anno = DateDiff('yyyy', fecha_corte, Now())>
			
			<!--- Realizar inserción del corte de años laborales si al menos ha pasado un año --->
			<!--- --------------------------------------------------------------------------------------------------- --->
			<cfif anno GT 0>
				<!--- Se asume que la diferencia de años es a los mas de 1 (uno) --->
				<cfset fecha_corte = DateAdd('yyyy', 1, fecha_corte)>
				<!--- calcula la cantidad de años laborados, a partir de la fecha ingreso --->
				<cfset annoslaborados = DateDiff('yyyy', fecha_ingreso, fecha_corte)>
				<!--- calcula la cantidad de años, a partir de la fecha de corte --->
				<cfset anno = DateDiff('yyyy', fecha_corte, Now())>

				<!--- dias asignados según regimen --->
				<cfquery name="rsDias" datasource="#Arguments.conexion#">
					select coalesce(rv.DRVdias, 0) as DRVdias, coalesce(rv.DRVdiasadic, 0) as DRVdiasadic, coalesce(rv.DRVdiasenf, 0) as DRVdiasenf
					from DRegimenVacaciones rv 
					where rv.RVid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#dataTipoAccion.RVid#">
					  and rv.DRVcant = ( select coalesce(max(DRVcant),1) 
										 from DRegimenVacaciones rv2 
										 where rv2.RVid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#dataTipoAccion.RVid#">
										   and rv2.DRVcant <= <cfqueryparam cfsqltype="cf_sql_float" value="#annoslaborados#"> 
										)
				</cfquery>

				<!--- Inserción de Vacaciones Ordinarias --->
				<cfinvoke component="sif.Componentes.Translate"
					method="Translate"
					Key="LB_Vacaciones_por_años_Laborados"
					Default="Vacaciones por años Laborados"	
					returnvariable="LB_Vacaciones_por_años_Laborados"/>
					
				<cfquery name="insVacaciones" datasource="#Arguments.conexion#">
					insert into DVacacionesEmpleado (DEid, Ecodigo, DVEfecha, DVEreferencia, DVEdescripcion, DVEdisfrutados, DVEcompensados, DVEmonto, Usucodigo, Ulocalizacion, DVEfalta, DVEenfermedad)
					values(	
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.DEid#">, 
						<cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#">, 
						<cfqueryparam cfsqltype="cf_sql_date" value="#fecha_corte#">, 
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.DLlinea#">, 
						'#LB_Vacaciones_por_años_Laborados#',
						<cfqueryparam cfsqltype="cf_sql_float" value="#rsDias.DRVdias#">,
						0, 
						0, 
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">, 
						'00', 
						<cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">, 
						0
					)
				</cfquery>

				<!--- Inserción de Vacaciones Adicionales --->
				<cfinvoke component="sif.Componentes.Translate"
					method="Translate"
					Key="LB_Vacaciones_Adicionales_por_años_Laborados"
					Default="Vacaciones Adicionales por años Laborados"	
					returnvariable="LB_Vacaciones_Adicionales_por_años_Laborados"/>
					
				<cfquery name="insVacaciones" datasource="#Arguments.conexion#">
					insert into DVacacionesEmpleado (DEid, Ecodigo, DVEfecha, DVEreferencia, DVEdescripcion, DVEdisfrutados, DVEcompensados, DVEmonto, Usucodigo, Ulocalizacion, DVEfalta, DVEenfermedad)
					values(	
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.DEid#">, 
						<cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#">, 
						<cfqueryparam cfsqltype="cf_sql_date" value="#fecha_corte#">, 
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.DLlinea#">, 
						'#LB_Vacaciones_Adicionales_por_años_Laborados#',
						<cfqueryparam cfsqltype="cf_sql_float" value="#rsDias.DRVdiasadic#">,
						0, 
						0, 
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">, 
						'00', 
						<cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">, 
						0
					)
				</cfquery>

				<!--- Recupera el parametro de dias de enfermedad --->	
				<cfquery name="data_enfermedad" datasource="#Arguments.conexion#">
					select coalesce(Pvalor,'N') as Pvalor
					from RHParametros 
					where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#">
					and Pcodigo = 270
				</cfquery>

				<!--- Si hay que insertar las vacaciones por enfermedad --->
				<cfif data_enfermedad.RecordCount gt 0 and data_enfermedad.Pvalor eq 'S'>
					<cfinvoke component="sif.Componentes.Translate"
						method="Translate"
						Key="LB_Dias_de_Enfermedad_por_años_Laborados"
						Default="Dias de Enfermedad por años Laborados"	
						returnvariable="LB_Dias_de_Enfermedad_por_años_Laborados"/>
						
					<cfquery name="insVacaciones" datasource="#Arguments.conexion#">
						insert into DVacacionesEmpleado (DEid, Ecodigo, DVEfecha, DVEreferencia, DVEdescripcion, DVEdisfrutados, DVEcompensados, DVEmonto, Usucodigo, Ulocalizacion, DVEfalta, DVEenfermedad)
						values(	
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.DEid#">, 
							<cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#">, 
							<cfqueryparam cfsqltype="cf_sql_date" value="#fecha_corte#">, 
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.DLlinea#">, 
							'#LB_Dias_de_Enfermedad_por_años_Laborados#',
							0,
							0, 
							0, 
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">, 
							'00', 
							<cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">, 
							<cfqueryparam cfsqltype="cf_sql_float" value="#rsDias.DRVdiasenf#">
						)
					</cfquery>
				</cfif>

				<!--- Actualiza la ultima fecha de calculo --->
				<cfquery datasource="#Arguments.conexion#">
					update EVacacionesEmpleado 
					set EVfecha = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#fecha_corte#">
					where DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.DEid#">
				</cfquery>

			</cfif>
			<!--- ----------------------------- FIN INSERCION CORTE DE VACACIONES ORDINARIAS ---------------------------------- --->
			
			<!--- CALCULO DE LOS DIAS DE VACACIONES ORDINARIOS HASTA EL DIA DE LIQUIDACION --->
			<!--- calcula la cantidad de dias laborados, a partir de la fecha de corte --->
			<cfset dias = DateDiff('d', fecha_corte, Now())>
			<!--- Insertar la diferencia de dias entre la fecha del ultimo corte y hoy --->
			<cfif dias GT 0>
				<!--- calcula la cantidad de meses desde la fecha_corte(dia, mes de ingreso, año en curso) hasta la fecha de hoy --->
				<cfset meses = DateDiff('m', fecha_corte, Now())>
				<cfset meses = meses + (DateDiff('d', DateAdd('m', meses, fecha_corte), Now()) / 30.0)>
				<!--- dias asignados según regimen --->
				<cfquery name="rsDias" datasource="#Arguments.conexion#">
					select coalesce(rv.DRVdias, 0) as DRVdias
					from DRegimenVacaciones rv 
					where rv.RVid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#dataTipoAccion.RVid#">
					  and rv.DRVcant = ( select coalesce(max(DRVcant),1) 
										 from DRegimenVacaciones rv2 
										 where rv2.RVid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#dataTipoAccion.RVid#">
										   and rv2.DRVcant <= <cfqueryparam cfsqltype="cf_sql_float" value="#annoslaborados+1#"> 
										)
				</cfquery>
				<cfset saldo_corriente = ((rsDias.DRVdias*meses)/12)*-1>
				
				<cfquery name="insVacaciones" datasource="#Arguments.conexion#">
					insert into DVacacionesEmpleado (DEid, Ecodigo, DVEfecha, DVEreferencia, DVEdescripcion, DVEdisfrutados, DVEcompensados, DVEmonto, Usucodigo, Ulocalizacion, DVEfalta, DVEenfermedad)
					values(	
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.DEid#">, 
						<cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#">, 
						<cfqueryparam cfsqltype="cf_sql_date" value="#Fdesde#">, 
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.DLlinea#">, 
						'Vacaciones Pagadas por Cese #LSDateFormat(Fdesde, 'dd/mm/yyyy')#',
						<cfqueryparam cfsqltype="cf_sql_float" value="#saldo_corriente#">, 
						0, 
						0, 
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">,
						'00', 
						<cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">, 
						0
					)
				</cfquery>
			</cfif>
			
			<cfquery name="upDVacacionesAcum" datasource="#Arguments.conexion#">
				update DVacacionesAcum
				set DVAsaldodias = 0
				where DEid  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.DEid#">
				and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#">
				and DVAsaldodias > 0
			</cfquery>
			
			
			<!--- Actualizacion del parametro para la inicializacion de la antiguedad del empleado en caso de que se le vuelva a nombrar --->
			<cfquery name="updEVacaciones" datasource="#Arguments.conexion#">
				update EVacacionesEmpleado
				set EVinicializar = 1
				where DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.DEid#">
			</cfquery>
			
		</cfif>

		<!--- ACCION DE COMPORTAMIENTO VACACIONES --->
		<cfif dataTipoAccion.RHTcomportam EQ 3>
			<cfquery name="rsEVfantig" datasource="#Arguments.conexion#">
				select EVfantig  from EVacacionesEmpleado where DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.DEid#">
			</cfquery>
			
			<cfset dia = datepart('d', rsEVfantig.EVfantig)>
			<cfset mes = datepart('m', rsEVfantig.EVfantig)>
			<cfset ano = datepart('yyyy', now())>
			<cfset anterior = ano-1 >
			<cfset Nueva_EVfantig = CreateDate( ano, mes, dia)>
			
			<cfquery name="rsVacSolicitadas" datasource="#Arguments.conexion#">
				select 	coalesce(RHAvdisf,0) as RHAvdisf
				from RHAcciones  
				where RHAlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RHAlinea#">
			</cfquery>
			
			<cfinvoke component="RHParametros" method="get" datasource="#session.dsn#" ecodigo="#session.Ecodigo#" pvalor="2505" default="" returnvariable="vCtrlVacXPeriodo"/>
			<cfif len(trim(vCtrlVacXPeriodo)) and vCtrlVacXPeriodo>
				<cfset lvarVacSolicitadas  = rsVacSolicitadas.RHAvdisf> 
				<cfset lvarVacRebajar = 0>
				<cfset lvarPeriodo = 0>
				<cfloop condition="lvarVacSolicitadas gt 0">
                	
					<cfquery name="rsVacAcum" datasource="#Arguments.conexion#">
						select DVAperiodo
                             ,abs(coalesce(sum(case when dva.DVAsaldodias < 0 then dva.DVAsaldodias else 0 end ),0))
                            -
                            (select coalesce(sum(va.DVAsaldodias),0)
                            from DVacacionesAcum va 
                            where va.DEid = dva.DEid and va.DVAperiodo = dva.DVAperiodo and not va.DVElinea is null
                            ) - coalesce(sum(case when dva.DVAsaldodias > 0 and dva.DVAmanual = 1 then dva.DVAsaldodias else 0 end ),0) as vacDisf
                             ,case when sum(dva.DVAsaldodias ) < 0 then 0 else  sum(dva.DVAsaldodias) end as vacDisp
                             ,sum(DVAdiasPotenciales) as vacPot
						from DVacacionesAcum dva
						where DEid  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.DEid#">
						  and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#">
						  and (dva.DVElinea in (select dve.DVElinea
                                          from DVacacionesEmpleado dve
                                          where dve.DEid = dva.DEid
                                           and dve.Ecodigo = dva.Ecodigo
                                           and dve.DVErefLinea is null
                                         ) 
                    	  or dva.DVElinea is null)
                		group by dva.DEid, dva.DVAperiodo
                        having sum(dva.DVAdiasPotenciales) - (abs(coalesce(sum(case when dva.DVAsaldodias < 0 then dva.DVAsaldodias else 0 end ),0))
                        -
                        (select coalesce(sum(va.DVAsaldodias),0)
                        from DVacacionesAcum va 
                        where va.DEid = dva.DEid and va.DVAperiodo = dva.DVAperiodo and not va.DVElinea is null
                        ) - coalesce(sum(case when dva.DVAsaldodias > 0 and dva.DVAmanual = 1 then dva.DVAsaldodias else 0 end ),0)) > 0
                		order by dva.DEid, dva.DVAperiodo
					</cfquery>
                    <cfif rsVacAcum.recordcount gt 1>
                        <cfquery name="rsVacAcumMin" dbtype="query">
                            select min(DVAperiodo) as DVAperiodo
                            from rsVacAcum
                        </cfquery>
                        <cfquery name="rsVacAcum" dbtype="query">
                            select DVAperiodo, vacDisf, vacDisp, vacPot
                            from rsVacAcum
                            where DVAperiodo = #rsVacAcumMin.DVAperiodo#
                        </cfquery>
                    </cfif>
					<cfif rsVacAcum.recordcount eq 0>
						<cfset lvarVacPot = fnGetVacacionesPontenciales(Arguments.DEid, Fdesde)>
						<cfquery name="rsMaxPeriodo" datasource="#Arguments.conexion#">
							select coalesce(max(DVAperiodo), #Year(Fdesde) - 1#) + 1 as Periodo
							from DVacacionesAcum  
							where DEid  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.DEid#">
							  and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#">
						</cfquery>
						<cfquery datasource="#Arguments.conexion#">
							insert into DVacacionesAcum
								(DEid, DVAdiasPotenciales, DVAperiodo, DVAsaldodias, DVASalarioProm, DVASalarioPdiario, DVAfecha, Ecodigo)
							values
								(#Arguments.DEid#,#lvarVacPot#,#rsMaxPeriodo.Periodo#,0,0,0,
								<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,#session.Ecodigo#)
						</cfquery>
						<cfset lvarVacRebajar = iif(lvarVacSolicitadas lte lvarVacPot, lvarVacSolicitadas, lvarVacPot)>
						<cfset lvarPeriodo = rsMaxPeriodo.Periodo>
					<cfelseif rsVacAcum.vacDisf lt rsVacAcum.vacPot>
						<cfset lvarVacRebajar = iif(lvarVacSolicitadas lte (rsVacAcum.vacPot - rsVacAcum.vacDisf), lvarVacSolicitadas, rsVacAcum.vacPot - rsVacAcum.vacDisf)>
						<cfset lvarPeriodo = rsVacAcum.DVAperiodo>
					</cfif>
					<cfif lvarVacRebajar gt 0>
						<cfset lvarVacSolicitadas = lvarVacSolicitadas - lvarVacRebajar>
						<cfquery datasource="#Arguments.conexion#">
							insert into DVacacionesAcum
								(DEid, DVAdiasPotenciales, DVAperiodo, DVAsaldodias, DVASalarioProm, DVASalarioPdiario, DVAfecha, Ecodigo)
							values
								(#Arguments.DEid#,0,#lvarPeriodo#,-#lvarVacRebajar#,0,0,
								<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,#session.Ecodigo#)
						</cfquery>
						<cfquery datasource="#Arguments.conexion#">
							insert into DVacacionesEmpleado (DEid, Ecodigo, DVEfecha, DVEreferencia, DVEdescripcion, DVEdisfrutados, DVEcompensados, DVEmonto, Usucodigo, Ulocalizacion, DVEfalta,DVEperiodo)
							select <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.DEid#">, 
								   <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#">, 
								   <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Fdesde#">, 
								   <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.DLlinea#">, 
								   coalesce(substring(DLobs, 1, 60), 'Vacaciones #LSDateFormat(Fdesde, 'dd/mm/yyyy')#'), 
								   -(#lvarVacRebajar#), 
								   0, 
								   0.00, 
								   <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Usucodigo#">, 
								   '00', 
								   <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
								   #lvarPeriodo#
							from RHAcciones 
							where RHAlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RHAlinea#">
						</cfquery>
					</cfif>
				</cfloop>
			<cfelse>
				<cfquery datasource="#Arguments.conexion#">
					insert into DVacacionesEmpleado (DEid, Ecodigo, DVEfecha, DVEreferencia, DVEdescripcion, DVEdisfrutados, DVEcompensados, DVEmonto, Usucodigo, Ulocalizacion, DVEfalta,DVEperiodo)
					select <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.DEid#">, 
						   <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#">, 
						   <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Fdesde#">, 
						   <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.DLlinea#">, 
						   coalesce(substring(DLobs, 1, 60), 'Vacaciones #LSDateFormat(Fdesde, 'dd/mm/yyyy')#'), 
						   -(#rsVacSolicitadas.RHAvdisf#), 
						   0, 
						   0.00, 
						   <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Usucodigo#">, 
						   '00', 
						   <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
						   #ano#
					from RHAcciones 
					where RHAlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RHAlinea#">
				</cfquery>
			</cfif>
		</cfif>
		<!--- Insertar Conceptos marcados que afectan vacaciones (DVEcompensados = cantidad que se genero de la formula, monto = resultado) --->
		<cfquery name="insDVacaciones" datasource="#Arguments.conexion#">
			insert into DVacacionesEmpleado (DEid, Ecodigo, DVEfecha, DVEreferencia, DVEdescripcion, DVEdisfrutados, DVEcompensados, DVEmonto, Usucodigo, Ulocalizacion, DVEfalta)
			select <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.DEid#">, 
				   <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#">, 
				   <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Fdesde#">, 
				   <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.DLlinea#">,
				   {fn concat ({fn concat(b.CIcodigo, ' - ') }, b.CIdescripcion)}, <!--- b.CIcodigo || ' - ' || b.CIdescripcion, --->
				   0, 
				   -(a.RHCAcant), 
				   a.RHCAres, 
				   <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Usucodigo#">, 
				   '00', 
				   <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">
			from RHConceptosAccion a, CIncidentes b
			where a.RHAlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RHAlinea#">
			and a.CIid = b.CIid
			and b.CItipo = 3          <!--- Calculo --->
			and b.CIvacaciones = 1    <!--- Afecta vacaciones --->
		</cfquery>
		<cfreturn true>
	</cffunction>
	
	<cffunction name="fnGetVacacionesPontenciales" access="private" returntype="numeric">
		<cfargument name="DEid" 		type="numeric" 	required="yes">
		<cfargument name="FechaCorte" 	type="date" 	required="no" default="#now()#">
		<cfargument name="Conexion" 	type="string" 	required="no">
		
		<cfif not isdefined('Arguments.Conexion')>
			<cfset Arguments.Conexion = session.dsn>
		</cfif>
		
		<cfquery name="rsFechaAntiguedad" datasource="#Arguments.Conexion#">
			select EVfantig
			from EVacacionesEmpleado
			where DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.DEid#">
		</cfquery>

		<cfset lvarFecha = ListToArray(LSDateFormat(rsFechaAntiguedad.EVfantig,'dd/mm/yyyy'),'/')>
		<cfset lvarFechaIngreso = Createdate(lvarFecha[3],lvarFecha[2],lvarFecha[1])>
		<cfset lvarAgnosLaborado = DateDiff('yyyy', lvarFechaIngreso, Arguments.FechaCorte)>
		
		<cfif lvarAgnosLaborado eq 0>
			<cfset lvarAgnosLaborado = 1>
		</cfif>

		<cfquery name="rsVacPotenciales" datasource="#Arguments.conexion#">
			select coalesce(min(rv.DRVdias), 0) as VacPotenciales
			from DRegimenVacaciones rv 
			where rv.RVid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#dataTipoAccion.RVid#">
				and rv.DRVcant <= <cfqueryparam cfsqltype="cf_sql_numeric" value="#lvarAgnosLaborado#">
		</cfquery>
		<!---<cfquery name="rsVacPotenciales" datasource="#Arguments.conexion#">
			select coalesce(rv.DRVdias) as VacPotenciales
			 from DRegimenVacaciones rv 
			 where rv.RVid = c.RVid 
			   and rv.DRVcant = ( select max(DRVcant) 
								  from DRegimenVacaciones rv2 
									where rv2.RVid = c.RVid 
									and rv2.DRVcant <= 
									<cf_dbfunction name="datediff" args="#lvarFechaIngreso#, #FechaCorte#, yy">)
		</cfquery>--->
		<cfreturn rsVacPotenciales.VacPotenciales>
	</cffunction>
	
    <!---=====Funcion para obtener las vacaciones de un Empleado=====--->
    <cffunction name="GetVacaciones" access="remote" returntype="struct">
        <cfargument name="DEid" 	type="numeric" 	required="no">
        <cfargument name="Conexion" type="string" 	required="no">
        
        <cfif NOT isdefined('Arguments.Conexion') and isdefined('session.dsn')>
            <cfset Arguments.Conexion = session.dsn>
        </cfif>
    
    	<!--- Obtiene las vacaciones asignadas al empleado, tarea programada --->
       	<cfquery name="rsVacAsig" datasource="#arguments.Conexion#">
            select coalesce(sum(DVEdisfrutados),0) as asignadas
                from DVacacionesEmpleado
            where DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.DEid#">
              and DVEreferencia is null
              and DVEdisfrutados > 0
              and DVEmanual = 0
            group by DEid
        </cfquery>
        <cfset lvarAsig = rsVacAsig.asignadas>
        <cfif len(trim(lvarAsig)) eq 0>
        	<cfset lvarAsig = 0>
        </cfif>

        <!--- Obtiene las vacaciones disfrutadas por el empleado, las cuales son asignadas mediante una accion de personal --->
       	<cfquery name="rsVacDisf" datasource="#arguments.Conexion#">
            select 		dve1.DVEdisfrutados as disfrutadas,
					dve1.DVEcompensados as Compensados
                from DVacacionesEmpleado dve1
            where dve1.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.DEid#">
              and not dve1.DVEreferencia is null
              and dve1.DVEdisfrutados < 0
              and dve1.DVEmanual = 0
            group by dve1.DEid
        </cfquery>
        <cfquery name="rsVacCanc" datasource="#arguments.Conexion#">
            select sum(coalesce(dve2.DVEdisfrutados,0)) as Canceladas
            from DVacacionesEmpleado dve1
                left outer join DVacacionesEmpleado dve2 
                     on dve2.DVErefLinea = dve1.DVElinea
            where dve1.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.DEid#">
              and not dve1.DVEreferencia is null
              and dve1.DVEdisfrutados < 0
              and dve1.DVEmanual = 0
            group by dve1.DEid 
        </cfquery>
        <cfset lvarDisf = 0>
        <cfif rsVacDisf.recordcount gt 0>
        	<cfset lvarDisf = rsVacDisf.disfrutadas>
        </cfif>
        <cfif rsVacCanc.recordcount gt 0>
        	<cfset lvarDisf = lvarDisf - rsVacCanc.Canceladas>
        </cfif>
        
        <!--- Obtiene los ajustes manuales  --->
       	<cfquery name="rsVacMan" datasource="#arguments.Conexion#">
            select coalesce(sum(DVEdisfrutados),0) as manuales
                from DVacacionesEmpleado
            where DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.DEid#">
              and DVEreferencia is null
              and DVEmanual = 1
            group by DEid
        </cfquery>
        <cfset lvarMan = rsVacMan.manuales>
        <cfif len(trim(lvarMan)) eq 0>
        	<cfset lvarMan = 0>
        </cfif>

		<!--- Obtiene el saldo real asigado al empleado--->
        <cfquery name="rsSaldoVac" dbtype="query">
            select sum(disfrutadas+Compensados) as Saldo
            from rsVacDisf
        </cfquery>
        <cfif rsSaldoVac.recordcount>
        	<cfset lvarSaldoRealAsignado = rsSaldoVac.Saldo>
        <cfelse>
        	<cfset lvarSaldoRealAsignado = 0>
        </cfif>
        
        <!--- Obtiene la fecha de antiguedad y la antiguedad laboral --->
        <cfquery name="rsVacaE" datasource="#arguments.Conexion#">
           select EVfantig
			from EVacacionesEmpleado
         	where DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.DEid#">      
        </cfquery>
        <cfset lvarAgnos 	  = DateDiff("yyyy", rsVacaE.EVfantig, now())>
        <cfset lvarMeses 	  = DateDiff("m", DateAdd("yyyy",lvarAgnos,rsVacaE.EVfantig), now())>
        <cfset lvarDias 	  = DateDiff("d", DateAdd("m",lvarMeses,DateAdd("yyyy",lvarAgnos,rsVacaE.EVfantig)), now())>
        <cfset lvarDiasTotal  = DateDiff("d", rsVacaE.EVfantig, now())>
        
        <cfquery name="rsDias" datasource="#session.DSN#">
                select coalesce(rv.DRVdias, 0) as DRVdias
                from DRegimenVacaciones rv 
                    inner join LineaTiempo a
                        on a.RVid = rv.RVid
                where a.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.DEid#">  
                  and <cf_dbfunction name="now"> between a.LTdesde and a.LThasta
                  and rv.DRVcant = ( select coalesce(max(DRVcant),1) 
                                     from DRegimenVacaciones rv2 
                                     where rv2.RVid = rv.RVid
                                       and rv2.DRVcant <= <cfqueryparam cfsqltype="cf_sql_float" value="#lvarAgnos+1#"> )
        </cfquery>
        
        <cfset lvarSaldoCorriente = 0>
        <cfif rsDias.recordCount GT 0 and Len(Trim(rsDias.DRVdias))>
            <cfset lvarSaldoCorriente = (rsDias.DRVdias * (lvarDiasTotal / 30)) / 12.0>
        </cfif>
   
        <cfset lvarProyectado = lvarSaldoRealAsignado + lvarSaldoCorriente >
        
        <!--- Fecha de Ingreso --->
        <cfquery name="rsFIngreso" datasource="#session.DSN#">
            select max(de.DLfvigencia) as Ingreso
            from DLaboralesEmpleado de
            	inner join RHTipoAccion ta 
               		on de.RHTid = ta.RHTid and de.Ecodigo =  ta.Ecodigo and ta.RHTcomportam in (1,9)
            where de.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.DEid#">
        </cfquery>
        
        <cfif lvarAgnos EQ 1>
            <cfinvoke component="sif.Componentes.Translate" method="Translate" Key="Agno"   Default="Agno"    returnvariable="LabelAgnos"/>
         <cfelse>
            <cfinvoke component="sif.Componentes.Translate" method="Translate" Key="Agno"  Default="Agno"   returnvariable="LabelAgnos"/>
        </cfif>
        <cfif lvarMeses EQ 1>
            <cfinvoke component="sif.Componentes.Translate" method="Translate" Key="Mes" 	Default="Mes" 	returnvariable="LabelMeses"/>
         <cfelse>
            <cfinvoke component="sif.Componentes.Translate" method="Translate" Key="Meses"  Default="Meses" returnvariable="LabelMeses"/>
        </cfif>
         <cfif lvarDias EQ 1>
            <cfinvoke component="sif.Componentes.Translate" method="Translate" Key="día"   	Default="día"  	returnvariable="LabelDias"/>
         <cfelse>
            <cfinvoke component="sif.Componentes.Translate" method="Translate" Key="días"  	Default="días"  returnvariable="LabelDias"/>
        </cfif>
        
       <cfset vacaciones = StructNew()>
       <cfset StructInsert(vacaciones, "Asignadas", lvarAsig)>
       <cfset StructInsert(vacaciones, "Disfrutadas", lvarDisf)>
       <cfset StructInsert(vacaciones, "Manuales", lvarMan)>
       <cfset StructInsert(vacaciones, "SaldoReal", lvarSaldoRealAsignado)>
       <cfset StructInsert(vacaciones, "Proyectado", lvarProyectado)>
       <cfset StructInsert(vacaciones, "FechaAntiguedad", DateFormat(rsVacaE.EVfantig,'dd/mm/yyyy'))>
       <cfset StructInsert(vacaciones, "AntiguedadLaboral", '#lvarAgnos# #LabelAgnos#, #lvarMeses# #LabelMeses#, #lvarDias# #LabelDias#')>
       <cfset StructInsert(vacaciones, "FechaIngreso", DateFormat(rsFIngreso.Ingreso,'dd/mm/yyyy'))>
       
        <cfreturn vacaciones>
    </cffunction>
    
    <!---=====Funcion para el registro de vacaciones de un Empleado=====--->
    <cffunction name="GetRegVacaciones" access="public" returntype="query">
    	<cfargument name="DEid" 	type="numeric" 	required="yes">
    	<cfargument name="DVElinea" type="numeric" 	required="no">
        <cfargument name="Conexion" type="string" 	required="no">
            
            <cfif NOT isdefined('Arguments.Conexion') and isdefined('session.dsn')>
                <cfset Arguments.Conexion = session.dsn>
            </cfif>
        
            <!--- Obtiene las vacaciones asignadas al empleado, tarea programada --->
            <cfquery name="rsVac" datasource="#session.dsn#">
                select dve.DVEfecha, dve.DVEperiodo, dve.DVEreferencia, dve.DVEdescripcion, dve.DVEdisfrutados, dve.DVErefLinea,
                       spe.RHSPEfdesde, spe.RHSPEfhasta, spe.RHSPEdiasreb,
                       abs(dve.DVEdisfrutados) - (select coalesce(sum(dve2.DVEdisfrutados),0) from DVacacionesEmpleado dve2 where dve2.DVErefLinea = dve.DVElinea) as DiasReales
                from DVacacionesEmpleado dve
                    inner join DLaboralesEmpleado dle
                        on dle.DLlinea = dve.DVEreferencia and dle.Ecodigo = dve.Ecodigo
                    inner join RHSaldoPagosExceso spe
                        on spe.DLlinea = dle.DLlinea  and spe.Ecodigo = dle.Ecodigo
                where dve.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.DEid#">
                  and spe.RHSPEanulado = 0
                <cfif isdefined('Arguments.DVElinea') and len(trim(Arguments.DVElinea))>
                    and dve.DVElinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.DVElinea#">
                </cfif>
            </cfquery>
       	<cfreturn rsVac>
    </cffunction>
    
    <cffunction name="fnAnularVacaciones" access="public">
    	<cfargument name="RHSPEid" 		type="numeric" required="yes">
        <cfargument name="DEid" 		type="numeric" required="yes">
        <cfargument name="RHTid" 		type="numeric" required="yes">
        <cfargument name="Fecha" 		type="date"    required="no">
        <cfargument name="esAnular" 	type="boolean" required="yes" default="true">
        
        <cfargument name="Conexion" type="string" required="no">
        
    	<cfif NOT isdefined('Arguments.Conexion') and isdefined('session.dsn')>
            <cfset Arguments.Conexion = session.dsn>
        </cfif>
        
        <cfquery name="rsID" datasource="#Arguments.Conexion#">
            select DLlinea, RHSPEfdesde, RHSPEfhasta, RHSPEdiasreb
            from RHSaldoPagosExceso
                where RHSPEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RHSPEid#">
                and DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.DEid#">
        </cfquery>
        <cfif Arguments.esAnular>
        	<cfset lvarFecha = rsID.RHSPEfdesde>
            <cfset msj = "ANULACIÓN DE: ">
            <cfset lvarDias = 0>
      	<cfelse>
        	<cfset lvarFecha = Arguments.Fecha>
            <cfset lvarDias = DateDiff('d',rsID.RHSPEfdesde,lvarFecha) + 1><!--- Dias disfrutados--->
            <cfset msj = "SUSPENSION DE: ">
        </cfif>
        
        
    	<cfquery name="rsDLE" datasource="#Arguments.Conexion#">
            select DLconsecutivo, DEid, Ecodigo, RHPid, RHPcodigo, Tcodigo, RVid, Dcodigo, Ocodigo, RHJid, DLfvigencia, DLsalario, 
            	{fn concat('#msj#', DLobs)} as Descripcion, Dcodigoant, Ocodigoant, RHPidant, RHPcodigoant, Tcodigoant, DLsalarioant, 
                   DLporcplaza, RVidant, DLporcplazaant, DLestado, DLporcsal, DLporcsalant, RHJidant, DLidtramite, DLvdisf, DLvcomp, IEid, TEid, DLffin
            from DLaboralesEmpleado
            where DLlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsID.DLlinea#">
        </cfquery>
        <cfquery name="rsDLaboralesEmpleado" datasource="#Arguments.Conexion#">
            insert into DLaboralesEmpleado
                (DLconsecutivo, DEid, RHTid, Ecodigo, RHPid, 
                 RHPcodigo, Tcodigo, RVid, Dcodigo, Ocodigo, RHJid, 
                 DLfvigencia, DLffin, DLsalario, DLobs, DLfechaaplic, Dcodigoant, 
                 Ocodigoant, RHPidant, RHPcodigoant, Tcodigoant, DLsalarioant,
                 Usucodigo, Ulocalizacion, DLporcplaza, RVidant, DLporcplazaant, 
                 DLestado, DLporcsal, DLporcsalant, RHJidant, DLidtramite, DLvdisf, 
                 DLvcomp, IEid, TEid, DLreferencia)
            values(
                 <cfqueryparam cfsqltype="cf_sql_integer" 		value="#rsDLE.DLconsecutivo#">, 
                 <cfqueryparam cfsqltype="cf_sql_numeric" 		value="#rsDLE.DEid#">, 
                 <cfqueryparam cfsqltype="cf_sql_numeric" 		value="#Arguments.RHTid#">, 
                 <cfqueryparam cfsqltype="cf_sql_integer" 		value="#rsDLE.Ecodigo#">, 
                 <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#rsDLE.RHPid#" 				voidNull>, 
                 <cfqueryparam cfsqltype="cf_sql_char" 			value="#rsDLE.RHPcodigo#">, 
                 <cf_jdbcquery_param cfsqltype="cf_sql_char" 	value="#rsDLE.Tcodigo#" 			voidNull>, 
                 <cfqueryparam cfsqltype="cf_sql_numeric" 		value="#rsDLE.RVid#">, 
                 <cf_jdbcquery_param cfsqltype="cf_sql_integer" value="#rsDLE.Dcodigo#" 			voidNull>, 
                 <cf_jdbcquery_param cfsqltype="cf_sql_integer" value="#rsDLE.Ocodigo#" 			voidNull>, 
                 <cfqueryparam cfsqltype="cf_sql_numeric" 		value="#rsDLE.RHJid#">,
                 <cfif not esAnular>
                	<cfqueryparam cfsqltype="cf_sql_timestamp" value="#DateAdd('d',1,lvarFecha)#">,
					<cfqueryparam cfsqltype="cf_sql_timestamp" value="#rsDLE.DLffin#">,
               	 <cfelse>
                 	<cfqueryparam cfsqltype="cf_sql_timestamp"	value="#rsDLE.DLfvigencia#">,
                 	<cfqueryparam cfsqltype="cf_sql_timestamp" 	value="#lvarFecha#">,
                 </cfif>
                 <cfqueryparam cfsqltype="cf_sql_money" 		value="#rsDLE.DLsalario#">, 
                 <cf_jdbcquery_param cfsqltype="cf_sql_varchar" value="#rsDLE.Descripcion#" 		voidNull>,
                 <cfqueryparam cfsqltype="cf_sql_timestamp" 	value="#Now()#">, 
                 <cf_jdbcquery_param cfsqltype="cf_sql_integer" value="#rsDLE.Dcodigoant#" 			voidNull>, 
                 <cf_jdbcquery_param cfsqltype="cf_sql_integer" value="#rsDLE.Ocodigoant#" 			voidNull>, 
                 <cf_jdbcquery_param cfsqltype="cf_sql_integer" value="#rsDLE.RHPidant#" 			voidNull>, 
                 <cf_jdbcquery_param cfsqltype="cf_sql_char" 	value="#rsDLE.RHPcodigoant#" 		voidNull>, 
                 <cf_jdbcquery_param cfsqltype="cf_sql_char" 	value="#rsDLE.Tcodigoant#" 			voidNull>, 
                 <cf_jdbcquery_param cfsqltype="cf_sql_money" 	value="#rsDLE.DLsalarioant#" 		voidNull>, 
                 <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#" 		voidNull>,
                 <cf_jdbcquery_param cfsqltype="cf_sql_char" 	value="#Session.Ulocalizacion#" 	voidNull>,
                 <cf_jdbcquery_param cfsqltype="cf_sql_float" 	value="#rsDLE.DLporcplaza#" 		voidNull>, 
                 <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#rsDLE.RVidant#" 			voidNull>, 
                 <cf_jdbcquery_param cfsqltype="cf_sql_float" 	value="#rsDLE.DLporcplazaant#" 		voidNull>, 
                 <cfqueryparam cfsqltype="cf_sql_integer" 		value="#rsDLE.DLestado#">, 
                 <cfqueryparam cfsqltype="cf_sql_float" 		value="#rsDLE.DLporcsal#">, 
                 <cf_jdbcquery_param cfsqltype="cf_sql_float" 	value="#rsDLE.DLporcsalant#" 		voidNull>, 
                 <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#rsDLE.RHJidant#" 			voidNull>, 
                 <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#rsDLE.DLidtramite#" 		voidNull>, 
                 <cfqueryparam cfsqltype="cf_sql_float" 		value="#rsDLE.DLvdisf- lvarDias#">, 
                 <cfqueryparam cfsqltype="cf_sql_float" 		value="#rsDLE.DLvcomp#">, 
                 <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#rsDLE.IEid#" 				voidNull>, 
                 <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#rsDLE.TEid#" 				voidNull>, 
                 <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#rsID.DLlinea#" 				voidNull>
                )
            <cf_dbidentity1>
        </cfquery>
        <cf_dbidentity2 name="rsDLaboralesEmpleado">
        <cfset lvarDLlinea = rsDLaboralesEmpleado.identity>
        <cfif not esAnular>
        	<cfset lvarDiasSusp = rsID.RHSPEdiasreb - lvarDias>
            <cfquery name="rsVacSusp" datasource="#Arguments.Conexion#">
                select {fn concat('#msj#', DVEdescripcion)} as Descripcion, DVEperiodo, DVElinea, 
                (DVEdisfrutados + coalesce((select sum(DVEdisfrutados) from DVacacionesEmpleado va where va.DVErefLinea = dva.DVElinea),0)) as DVEdisfrutados, DVErefLinea, DVEreferencia
                from DVacacionesEmpleado dva
                where DVEreferencia = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsID.DLlinea#">
                  and DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.DEid#">
                  and (DVEdisfrutados + coalesce((select sum(DVEdisfrutados) from DVacacionesEmpleado va where va.DVErefLinea = dva.DVElinea),0)) < 0
                order by DVEperiodo desc
            </cfquery>
            <cfloop query="rsVacSusp">
                <cfif lvarDiasSusp lt 1>
                    <cfbreak>
                </cfif>
                <cfif lvarDiasSusp lte Abs(rsVacSusp.DVEdisfrutados)>
                    <cfset lvarDiasCant = lvarDiasSusp>
                <cfelse>
                    <cfset lvarDiasCant = Abs(rsVacSusp.DVEdisfrutados)>
                </cfif>
                <cfquery datasource="#Arguments.Conexion#">
                    insert into DVacacionesEmpleado(
                        DEid, 			Ecodigo, 
                        DVEfecha, 		DVEreferencia, 
                        DVEdescripcion, DVEdisfrutados, 
                        DVEcompensados, DVEmonto, 
                        Usucodigo, 		Ulocalizacion, 
                        DVEfalta, 		DVEenfermedad,
                        DVEperiodo, 	DVErefLinea,
                        BMUsucodigo)
                    values(#Arguments.DEid#, #session.Ecodigo#, 
                           <cfqueryparam cfsqltype="cf_sql_timestamp" value="#lvarFecha#">,
                           #rsID.DLlinea#,
                           '#rsVacSusp.Descripcion#', #lvarDiasCant#, 
                           0, 0, 
                           #Session.Usucodigo#, '#Session.Ulocalizacion#', 
                           <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">, 0,
                           #rsVacSusp.DVEperiodo#, #rsVacSusp.DVElinea#,#session.usucodigo#)
                </cfquery>
                <cfset lvarDiasSusp = lvarDiasSusp - lvarDiasCant>
            </cfloop>
            <cfinvoke component="rh.Componentes.RHParametros" method="get" datasource="#Arguments.Conexion#" ecodigo="#session.Ecodigo#" pvalor="2505" default="0" returnvariable="vCtrlVacXPeriodo"/>
            <cfif vCtrlVacXPeriodo>
                <cfset lvarDiasSusp = rsID.RHSPEdiasreb - lvarDias>
                <cfloop query="rsVacSusp">
                    <cfif lvarDiasSusp lt 1>
                        <cfbreak>
                    </cfif>
                    <cfif lvarDiasSusp lte Abs(rsVacSusp.DVEdisfrutados)>
                        <cfset lvarDiasCant = lvarDiasSusp>
                    <cfelse>
                        <cfset lvarDiasCant = Abs(rsVacSusp.DVEdisfrutados)>
                    </cfif>
                    <cfquery datasource="#Arguments.Conexion#">
                        insert into DVacacionesAcum
                            (DEid, DVAdiasPotenciales, DVAperiodo, DVAsaldodias, DVASalarioProm, DVASalarioPdiario, DVAfecha, Ecodigo, DVElinea, BMUsucodigo)
                        values(#Arguments.DEid#, 0, #rsVacSusp.DVEperiodo#, #lvarDiasCant#, 0, 0
                               ,<cfqueryparam cfsqltype="cf_sql_timestamp" value="#lvarFecha#">, #Session.Ecodigo#, #rsVacSusp.DVElinea#,#session.usucodigo#)
                    </cfquery>
                    <cfset lvarDiasSusp = lvarDiasSusp - lvarDiasCant>
                </cfloop>
            </cfif>
            <cfquery datasource="#Arguments.Conexion#">
                insert into RHSaldoPagosExceso(Ecodigo, DEid, DLlinea, RHTid, RHSPEfdesde, RHSPEfhasta, RHSPEfecha, RHSPEfdesdesig, RHSPEmontoreb,
                                               RHSPEsaldo, RHSPEmontosub, RHSPEsaldiario, RHSPEsubdiario, RHSPEsaldosub, RHSPEdiasreb, RHSPEdiassub,
                                               RHSPEanulado, BMUsucodigo)
                select 
                    Ecodigo, DEid, DLlinea, RHTid, RHSPEfdesde, <cfqueryparam cfsqltype="cf_sql_timestamp" value="#lvarFecha#">,
                    <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">, RHSPEfdesdesig, RHSPEsaldiario * #lvarDias#,
                    case when RHSPEsaldiario * #lvarDias# <= RHSPEsaldosub then RHSPEsaldiario * #lvarDias# else 0 end,
                    RHSPEsubdiario * #lvarDias#, RHSPEsaldiario, RHSPEsubdiario,
                    case when RHSPEsubdiario * #lvarDias# <= RHSPEsaldosub then RHSPEsubdiario * #lvarDias# else 0 end,
                    <cfqueryparam cfsqltype="cf_sql_numeric" value="#lvarDias#">,
                    <cfqueryparam cfsqltype="cf_sql_numeric" value="#lvarDias#">, 0, #session.Usucodigo#
                from RHSaldoPagosExceso
                where RHSPEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RHSPEid#">
                  and DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.DEid#">
            </cfquery>
            <cfquery datasource="#Arguments.Conexion#">
                update RHSaldoPagosExceso 
                set RHSPEanulado = 1, BMUsucodigo = #session.usucodigo#
                where RHSPEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RHSPEid#">
                  and DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.DEid#">
            </cfquery>
        <cfelse>
            <cfquery datasource="#Arguments.Conexion#">
                insert into DVacacionesEmpleado(
                    DEid, 			Ecodigo, 
                    DVEfecha, 		DVEreferencia, 
                    DVEdescripcion, DVEdisfrutados, 
                    DVEcompensados, DVEmonto, 
                    Usucodigo, 		Ulocalizacion, 
                    DVEfalta, 		DVEenfermedad,
                    DVEperiodo, 	DVErefLinea)
                select DEid, Ecodigo,
                       <cfqueryparam cfsqltype="cf_sql_timestamp" value="#lvarFecha#">,
                       <cfqueryparam cfsqltype="cf_sql_numeric" value="#lvarDLlinea#">,
                       {fn concat('#msj#: ', DVEdescripcion)}, abs((DVEdisfrutados + coalesce((select sum(DVEdisfrutados) from DVacacionesEmpleado va where va.DVErefLinea = dva.DVElinea),0))), 
                       0, 0, 
                       #Session.Usucodigo#, '#Session.Ulocalizacion#', 
                       <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">, 0,
                       DVEperiodo, DVElinea
                from DVacacionesEmpleado dva
                where DVEreferencia = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsID.DLlinea#">
                  and DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.DEid#">
                  and (DVEdisfrutados + coalesce((select sum(DVEdisfrutados) from DVacacionesEmpleado va where va.DVErefLinea = dva.DVElinea),0)) < 0
                order by DVEperiodo desc
            </cfquery>
            <cfinvoke component="rh.Componentes.RHParametros" method="get" datasource="#Arguments.Conexion#" ecodigo="#session.Ecodigo#" pvalor="2505" default="0" returnvariable="vCtrlVacXPeriodo"/>
            <cfif vCtrlVacXPeriodo>
                <cfquery name="rsVacReb" datasource="#Arguments.Conexion#">
                    select RHSPEdiasreb as Dias
                    from RHSaldoPagosExceso 
                    where RHSPEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RHSPEid#">
                    and DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.DEid#">
                </cfquery>
                <cfquery name="rsVacDis" datasource="#Arguments.Conexion#">
                    select abs(sum(DVEdisfrutados)) as Dias
                    from DVacacionesEmpleado
                    where DVEreferencia = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsID.DLlinea#">
                     and DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.DEid#">
                </cfquery>
                <cfif rsVacReb.Dias neq rsVacDis.Dias>
                    <cfthrow message="Las vacaciones anuladas no corresponde con las vacaciones asignadas para el empleado.">
                </cfif>
                <cfset lvarPeriodo = Year(LSParseDateTime(fecha))>
                <cfquery datasource="#Arguments.Conexion#">
                    insert into DVacacionesAcum
                        (DEid, DVAdiasPotenciales, DVAperiodo, DVAsaldodias, DVASalarioProm, DVASalarioPdiario, DVAfecha, Ecodigo, DVElinea)
                    select #Arguments.DEid#, 0, DVEperiodo, abs(DVEdisfrutados), 0, 0
                       ,<cfqueryparam cfsqltype="cf_sql_timestamp" value="#lvarFecha#">, #Session.Ecodigo#, DVElinea
                    from DVacacionesEmpleado
                    where DVEreferencia = <cfqueryparam cfsqltype="cf_sql_numeric" value="#lvarDLlinea#">
                </cfquery>
            </cfif>
            <cfquery name="ABC_Anulacion2" datasource="#Arguments.Conexion#">
                update RHSaldoPagosExceso 
                set 
                    RHSPEdiasreb = 0,
                    RHSPEdiassub = 0,
                    RHSPEfhasta = RHSPEfdesde,
                    RHSPEanulado = 1
                where RHSPEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RHSPEid#">
                and DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.DEid#">
            </cfquery>
     	</cfif>
        <!--- Actualizar Montos --->
        <cfquery name="ABC_Anulacion" datasource="#Arguments.Conexion#">
            update RHSaldoPagosExceso 
            set 
                RHSPEsaldo = RHSPEsaldo - (RHSPEmontoreb - (RHSPEsaldiario * RHSPEdiasreb)),
                RHSPEsaldosub = RHSPEsaldosub - (RHSPEmontosub - (RHSPEsubdiario * RHSPEdiassub)),
                RHSPEmontoreb = RHSPEsaldiario * RHSPEdiasreb,
                RHSPEmontosub = RHSPEsubdiario * RHSPEdiassub
            where RHSPEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RHSPEid#">
            and DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.DEid#">
        </cfquery>
        
        <cfquery name="rsSalarioEmpleado" datasource="#Arguments.Conexion#">
            select se.RCNid, se.DEid
            from SalarioEmpleado se, RCalculoNomina a, CalendarioPagos b
            where se.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.DEid#">
            and se.SEcalculado = 1
            and a.RCNid = se.RCNid
            and a.RChasta >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#lvarFecha#">
            and a.RCestado = 0
            and b.CPid = a.RCNid
            and b.CPfcalculo is not null
            and b.CPfenvio is null
        </cfquery>
        <cfloop query="rsSalarioEmpleado">
            <cfquery datasource="#Arguments.Conexion#">
                update SalarioEmpleado
                set SEcalculado = 0
                where DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsSalarioEmpleado.DEid#">
                and RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsSalarioEmpleado.RCNid#">
            </cfquery>
        </cfloop>
    </cffunction>
    
    <cffunction name="fnAgregarVacacinesManuales" access="public">
    	<cfargument name="DEid" 			type="numeric" 	required="yes">
        <cfargument name="DVEfecha" 		type="string"  	required="yes">
        <cfargument name="DVEdescripcion" 	type="string"  	required="yes">
        <cfargument name="DVEdisfrutados"	type="numeric" 	required="yes">
        <cfargument name="DVEmanual" 		type="numeric" 	required="yes" default="0">
        <cfargument name="DVEperiodo" 		type="numeric" 	required="no">
        
        
        <cfargument name="Conexion" 		type="string" 	required="no">
        <cfargument name="Ecodigo" 			type="numeric" 	required="no">
		
        <cfif NOT isdefined('Arguments.Conexion') and isdefined('session.dsn')>
            <cfset Arguments.Conexion = session.dsn>
        </cfif>
        <cfif NOT isdefined('Arguments.Ecodigo') and isdefined('session.Ecodigo')>
            <cfset Arguments.Ecodigo = session.Ecodigo>
        </cfif>
        <cfif not isdefined('Arguments.DVEperiodo')>
        	<cfset Arguments.DVEperiodo = Year(LSParseDateTime(Arguments.DVEfecha))>
        </cfif>

    	<cfquery datasource="#Arguments.Conexion#">
				insert into DVacacionesEmpleado(DEid, Ecodigo, DVEfecha,DVEdescripcion, DVEdisfrutados, DVEcompensados, DVEenfermedad, DVEmonto, Usucodigo, Ulocalizacion,DVEperiodo,DVEmanual)
				values (
					<cfqueryparam cfsqltype="cf_sql_numeric" 	value="#Arguments.DEid#">,
					<cfqueryparam cfsqltype="cf_sql_numeric" 	value="#Arguments.Ecodigo#">, 
					<cfqueryparam cfsqltype="cf_sql_date" 		value="#LSParseDateTime(Arguments.DVEfecha)#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" 	value="#Arguments.DVEdescripcion#">,
					<cfqueryparam cfsqltype="cf_sql_float" 		value="#Arguments.DVEdisfrutados#">,
					<cfqueryparam cfsqltype="cf_sql_float" 		value="0">,
					<cfqueryparam cfsqltype="cf_sql_float" 		value="0">,
					<cfqueryparam cfsqltype="cf_sql_money" 		value="0">,
					<cfqueryparam cfsqltype="cf_sql_numeric" 	value="#Session.Usucodigo#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" 	value="#Session.Ulocalizacion#">,
					<cfqueryparam cfsqltype="cf_sql_integer" 	value="#Arguments.DVEperiodo#">,
                    <cfqueryparam cfsqltype="cf_sql_integer" 	value="#Arguments.DVEmanual#"> 
				 )	
			</cfquery>
    </cffunction>
    
</cfcomponent>
