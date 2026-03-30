<cfoutput>
	<cfset vDebug = false>

	<cfsetting requesttimeout="66000">

	<cfsetting enablecfoutputonly="yes">
		<cfapplication name="TAREAS" 
		sessionmanagement="Yes"
		clientmanagement="Yes"
		setclientcookies="Yes"
		sessiontimeout=#CreateTimeSpan(0,10,0,0)#>	
	
    <cfinvoke component="home.Componentes.DbUtils" method="generate_dsinfo">
		<cfinvokeargument name="refresh" value="no">
	</cfinvoke>
	<cfset listadatasourse = "'x'">
    <cfloop collection="#Application.dsInfo#" item="xx">
		<cfset listadatasourse = UCase(listadatasourse) & ",'#xx#'">
    </cfloop>
	<cfset registros = 0 >

	<cfquery name="bds" datasource="asp">
		select distinct c.Ccache
		from Empresa e
		inner join ModulosCuentaE m
			on e.CEcodigo = m.CEcodigo
		inner join Caches c
			on c.Cid = e.Cid
		Where m.SScodigo = 'RH'
			and upper(c.Ccache) in(#PreserveSingleQuotes(listadatasourse)#)
			and Ereferencia is not null
	</cfquery>

	<cfflush interval="1">
		<cfloop query="bds">
			<cfif vDebug >
			**********************************<br>
			<b>CACHE:</b> <cfdump var="#bds.Ccache#"><br>
			**********************************<br>
		</cfif>
		<cfset cache = trim(bds.Ccache) > 
		<cf_dbtemp name="PagosEmpTAR" returnvariable="tbl_PagosEmpleado" datasource="#cache#">
			<cf_dbtempcol name="RCNid" type="numeric">
			<cf_dbtempcol name="DEid" type="numeric"> 
			<cf_dbtempcol name="FechaDesde" type="datetime">
			<cf_dbtempcol name="FechaHasta" type="datetime">
			<cf_dbtempcol name="Cantidad" type="int">
			<cf_dbtempkey cols="RCNid,DEid">
		</cf_dbtemp>
		
		<cf_dbtemp name="PAgosPEriodosTAR" returnvariable="PAgosPEriodos" datasource="#cache#">
			<cf_dbtempcol name="RCNid"       type="numeric">
			<cf_dbtempcol name="RCNDes"      type="varchar(256)">
			<cf_dbtempcol name="FechaDesde"  type="date">
			<cf_dbtempcol name="FechaHasta"  type="date">
			<cf_dbtempcol name="salario"     type="float">
			<cf_dbtempcol name="incidencias" type="float">
			<cf_dbtempcol name="dias" type="int">
		</cf_dbtemp>

		<cfset continuar = true >
		
		<!--- validacion de existencia de las tablas --->
		<cfif vDebug ><b>Iniciando validacion de tablas</b><br></cfif>	
		<cftry>
			<cfif vDebug ><b>Validando empresas</b><br></cfif>	
			<cfquery datasource="#cache#">
				select 1
				from Empresas
			</cfquery>
			
			<cfif vDebug ><b>Validando parametros</b><br></cfif>	
			<cfquery datasource="#cache#">
				select 1 
				from RHParametros
			</cfquery>
		
			<cfif vDebug ><b>Validando regimen</b><br></cfif>	
			<cfquery datasource="#cache#" maxrows="1" >
				select 1 
				from DRegimenVacaciones
			</cfquery>
		
			<cfif vDebug ><b>Validando EVacacionesEmpleado</b><br></cfif>	
			<cfquery datasource="#cache#" maxrows="1" >
				select 1 
				from EVacacionesEmpleado
			</cfquery>
		
			<cfif vDebug ><b>Validando DVacacionesEmpleado</b><br></cfif>	
			<cfquery datasource="#cache#" maxrows="1" >
				select 1 
				from DVacacionesEmpleado
			</cfquery>
		<cfcatch type="any">
			<cfset continuar = false >
		</cfcatch>
		</cftry>

		<cfif vDebug ><br><b>Validacion de tablas concluida resultado:</b> <cfdump var="#continuar#"><br><br></cfif>	
	
		<cfif continuar >
			<cfquery name="empresas" datasource="#cache#">
				select Ecodigo
				from Empresas
			</cfquery>
			<cftransaction> 
				<cfloop query="empresas">
					<cfset empresa = empresas.Ecodigo >
					<cfif vDebug ><b>Empresa:</b><cfdump var="#empresa#"><br><br></cfif>
					<!--- Recupera el parametros de dias antes para asignar vacaciones --->
					<cfinvoke component="rh.Componentes.RHParametros" method="get" datasource="#cache#" 
					ecodigo="#empresa#" pvalor="260" default="0" returnvariable="parametrodias"/>				 
					<cfif vDebug ><b>Dias antes para asignar vacaciones:</b> <cfdump var="#parametrodias#"><br><br></cfif>
				
					<!--- Recupera el parametro de dias de enfermedad --->	
					<cfinvoke component="rh.Componentes.RHParametros" method="get" datasource="#cache#" 
					ecodigo="#empresa#" pvalor="270" default="N" returnvariable="diasenfermedad"/>				 
					<cfif vDebug ><b>Procesa Dias de enfermedad:</b> <cfdump var="#diasenfermedad#"><br><br></cfif>
				
					<!--- Recupera el parametro de ultima fecha de corrida --->	
					<cfinvoke component="rh.Componentes.RHParametros" method="get" datasource="#cache#" 
					ecodigo="#empresa#" pvalor="280" default="" returnvariable="ultimafecha"/>				 
					<cfif len(trim(ultimafecha))>
						<cfset tmp = ListToArray(ultimafecha,'/') >
						<cfif arraylen(tmp) eq 3 >
							<cfset ultimafecha = CreateDate(tmp[3], tmp[2], tmp[1]) >
						<cfelse>
							<cfset ultimafecha = Now() >
						</cfif>
					<cfelse>
						<cfset ultimafecha = Now() >
					</cfif>
					<cfif vDebug ><b>Ultima fecha de corrida:</b><cfdump var="#ultimafecha#"><br><br></cfif>
				
					<!--- Se toma la cantidad de días pendientes de "ejecutar" y se analiza la asignacion por día--->	
					<cfset cantidad_dias = datediff('d',ultimafecha, Now())>
					<cfset FechaEjecucion = ultimafecha >	<br /><br />			
					<cfloop from="1" index="i" to="#cantidad_dias#">
						<cfset FechaEjecucion 	  = dateadd('d',1,FechaEjecucion) >
						<cfset FechaInicioCalculo = dateadd('d',parametrodias,FechaEjecucion) >
						<cfset dia = datepart('d', FechaInicioCalculo)>
						<cfset mes = datepart('m', FechaInicioCalculo)>
						<cfif vDebug ><b>Procesando fecha: </b> 
							<cfdump var="#lsdateFormat(FechaInicioCalculo,'dd/mm/yyyy')#"><br>
						</cfif>
						<cfquery datasource="#cache#" name="data">
								select 	'V' as tipo, 
										'Vacaciones por años Laborados' as descripcion, 
										a.DEid,
										   ( select rv.DRVdias
											 from DRegimenVacaciones rv 
											 where rv.RVid = c.RVid 
											   and rv.DRVcant = ( select max(DRVcant) 
																  from DRegimenVacaciones rv2 
																	where rv2.RVid = c.RVid 
																	and rv2.DRVcant <= 
																	<cf_dbfunction name="datediff" args="a.EVfantig, #FechaInicioCalculo# ,yy">)
										   ) as Cantidad
									from EVacacionesEmpleado a, DatosEmpleado b, LineaTiempo c
									where a.EVdia = <cfqueryparam cfsqltype="cf_sql_integer" value="#dia#">
									  and a.EVmes = <cfqueryparam cfsqltype="cf_sql_integer" value="#mes#">
									  and a.EVfantig <= <cfqueryparam cfsqltype="cf_sql_date" value="#FechaInicioCalculo#">
									  and a.EVfecha <= <cfqueryparam cfsqltype="cf_sql_date" value="#ultimafecha#">
									  and b.DEid = a.DEid
									  and c.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#empresa#">
									  and c.DEid = b.DEid
									  and <cfqueryparam cfsqltype="cf_sql_date" value="#FechaInicioCalculo#"> between c.LTdesde and c.LThasta
								union
									select 	'A' as tipo, 
											'Vacaciones Adicionales por años Laborados' as descripcion, 
											a.DEid, 
											   ( select rv.DRVdiasadic
												 from DRegimenVacaciones rv 
												 where rv.RVid = c.RVid 
												   and rv.DRVcant = ( select max(DRVcant) 
																	  from DRegimenVacaciones rv2 
																		where rv2.RVid = c.RVid 
																		and rv2.DRVcant <= 
																		<cf_dbfunction name="datediff" args="a.EVfantig, #FechaInicioCalculo# ,yy">)
											   ) as Cantidad
									from EVacacionesEmpleado a, DatosEmpleado b, LineaTiempo c
									where a.EVdia = <cfqueryparam cfsqltype="cf_sql_integer" value="#dia#">
									  and a.EVmes = <cfqueryparam cfsqltype="cf_sql_integer" value="#mes#">
									  and a.EVfantig < <cfqueryparam cfsqltype="cf_sql_date" value="#FechaInicioCalculo#">
									  and a.EVfecha <= <cfqueryparam cfsqltype="cf_sql_date" value="#ultimafecha#">
									  and b.DEid = a.DEid
									  and c.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#empresa#">
									  and c.DEid = b.DEid
									  and <cfqueryparam cfsqltype="cf_sql_date" value="#FechaInicioCalculo#"> between c.LTdesde and c.LThasta
								<cfif diasenfermedad eq 'S'>
									union
									select 	'E' as tipo, 
											'Dias de Enfermedad por aÃ±os Laborados' as descripcion, 
											a.DEid, 
										   ( select rv.DRVdiasenf
											 from DRegimenVacaciones rv 
											 where rv.RVid = c.RVid 
											   and rv.DRVcant = ( select max(DRVcant) 
																  from DRegimenVacaciones rv2 
																	where rv2.RVid = c.RVid 
																	and rv2.DRVcant <= 
																	<cf_dbfunction name="datediff" args="a.EVfantig, #FechaInicioCalculo# ,yy">)
										   ) as Cantidad
									from EVacacionesEmpleado a, DatosEmpleado b, LineaTiempo c
									where a.EVdia = <cfqueryparam cfsqltype="cf_sql_integer" value="#dia#">
									  and a.EVmes = <cfqueryparam cfsqltype="cf_sql_integer" value="#mes#">
									  and a.EVfantig < <cfqueryparam cfsqltype="cf_sql_date" value="#FechaInicioCalculo#">
									  and a.EVfecha <= <cfqueryparam cfsqltype="cf_sql_date" value="#FechaInicioCalculo#">
									  and b.DEid = a.DEid
									  and c.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#empresa#">
									  and c.DEid = b.DEid
									  and <cfqueryparam cfsqltype="cf_sql_date" value="#FechaInicioCalculo#"> between c.LTdesde and c.LThasta
									  <cfif vDebug >
										and  a.DEid = #vDEid#
									</cfif>
								</cfif>
						</cfquery>
						<cfif vDebug >
							<cfif isdefined("data") and data.RecordCount GT 1>
								<cfdump var="[data] Viene Con Datos">
							<cfelse>
								<cfdump var="[data] Viene Vacio">
							</cfif>
						</cfif>
						<cfquery dbtype="query" name="data1">
							select * from data
						</cfquery>						
						<cfloop query="data1">
							<cfset lvarPeriodo = Datepart('yyyy',FechaInicioCalculo)-1>
							<cfquery datasource="#cache#" >
								insert into DVacacionesEmpleado (DEid, Ecodigo, DVEfecha, DVEdescripcion, DVEdisfrutados, DVEcompensados, DVEmonto, Usucodigo, Ulocalizacion, DVEfalta, DVEenfermedad, DVEperiodo)
								values(	
									<cfqueryparam cfsqltype="cf_sql_numeric" value="#data1.DEid#">, 
									<cfqueryparam cfsqltype="cf_sql_integer" value="#empresa#">, 
									<cfqueryparam cfsqltype="cf_sql_date" value="#FechaInicioCalculo#">, 
									<cfqueryparam cfsqltype="cf_sql_varchar" value="#data1.descripcion#" >,
									<cfif (data1.tipo eq 'V' or data1.tipo eq 'A') and len(trim(data1.cantidad))><cfqueryparam cfsqltype="cf_sql_float" value="#data1.Cantidad#" ><cfelse>0</cfif>, 
									0, 
									0, 
									1, 
									'00', 
									getdate(), 
									<cfif trim(data1.tipo) eq 'E' and len(trim(data1.cantidad))><cfqueryparam cfsqltype="cf_sql_float" value="#data1.Cantidad#"><cfelse>0</cfif>,
									#lvarPeriodo#									
								)
							</cfquery>
							<cfinvoke component="rh.Componentes.RHParametros" method="get" datasource="#cache#" ecodigo="#empresa#" pvalor="2505" default="0" returnvariable="vCtrlVacXPeriodo"/>
							<cfif data1.tipo eq 'V' and vCtrlVacXPeriodo>
								<cfquery datasource="#cache#" name="rsVacPotenciales">
									select coalesce(sum(DVAdiasPotenciales),0) as VacPotenciales
									from DVacacionesAcum
									where DEid = #data1.DEid# 
									and Ecodigo = #empresa# 
									and DVAperiodo = #lvarPeriodo#
								</cfquery>
								<cfset lvarSaldoPotenciales = data1.cantidad - rsVacPotenciales.VacPotenciales>
								<cfif lvarSaldoPotenciales neq 0>
									<cfquery datasource="#cache#">
										insert into DVacacionesAcum
											(DEid, DVAdiasPotenciales, DVAperiodo, DVAsaldodias, DVASalarioProm, DVASalarioPdiario, DVAfecha, Ecodigo)
										values
											(#data1.DEid#,#lvarSaldoPotenciales#,#lvarPeriodo#,0,0,0,
											<cfqueryparam cfsqltype="cf_sql_timestamp" value="#FechaInicioCalculo#">,#empresa#)
									</cfquery>
								</cfif>
								<!--- Código para el Cálculo Salario Promedio del Periodo --->
								<cfinclude template="calculaSalario.cfm">								
								<cfif vDebug > <!--- ljimenez --->
									<cfdump var="Datos que se van a insertar en	DVacacionesAcum"> </br>						
									DEid:<cfdump var="#data1.DEid#"> </br>
									empresa:<cfdump var="#empresa#"></br>
									FechaInicioCalculo:<cfdump var="#Datepart('yyyy',FechaInicioCalculo)-1#"></br>
									Cantidad VAC:<cfdump var="#data1.cantidad#"></br>
									SalarioUltimosPeriodos:<cfdump var="#SalarioUltimosPeriodos#"></br>
									SalarioPromedioDiario:<cfdump var="#SalarioPromedioDiario#"></br>
									SalarioPromedio:<cfdump var="#SalarioPromedio#"></br>
									FechaInicioCalculo:<cfdump var="#FechaInicioCalculo#"></br>
								</cfif>
								<cfquery datasource="#cache#">
									insert into DVacacionesAcum(DEid, Ecodigo,DVAperiodo,DVAsaldodias,DVASalarioProm,DVASalarioPdiario,DVAfecha)
									values(	
										#data1.DEid#, 
										#empresa#,
										#lvarPeriodo#,
										#data1.cantidad#,
										#SalarioPromedio#,
										#SalarioPromedioDiario#,
										<cfqueryparam cfsqltype="cf_sql_date" value="#FechaInicioCalculo#">
									)
								</cfquery>
								<cfif vDebug >
									<cfquery name="rsantes" datasource="#cache#">
										select 	* from DVacacionesAcum
										where  DEid =  #data1.DEid# 	
									</cfquery>
									<cfdump var="#rsantes#">
								</cfif>	
							</cfif>

							<!--- Actualiza la ultima fecha de calculo --->
							<cfquery datasource="#cache#">
								update EVacacionesEmpleado 
								set EVfecha = <cfqueryparam cfsqltype="cf_sql_date" value="#FechaInicioCalculo#">
								where DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#data1.DEid#">
							</cfquery>
							
							<!---ljimenez INICIO - llamado al proceso que calcula e inserta la incidencia de pago de vacaciones MEXICO--->
							<cfinvoke component="rh.Componentes.RHParametros" method="get" datasource="#cache#" ecodigo="#empresa#" pvalor="2031" default="0" returnvariable="vCIidVac"/>
							<cfif data1.tipo eq 'V' and vCIidVac GT 0>
								<cfinclude template="GeneraIncidenciaVacaciones.cfm">
							</cfif>
						
							<!---ljimenez FIN - llamado al proceso que calcula e inserta la incidencia de pago de vacaciones MEXICO--->
						</cfloop> <!--- ciclo de Vacaciones a Asignar por empleado y empresa --->						
					</cfloop> <!--- Ciclo Control de Días a Procesar por Empresa --->
				<cfquery name="update_parametros" datasource="#cache#">
					update RHParametros
					set Pvalor = <cfqueryparam cfsqltype="cf_sql_varchar" value="#LSDateFormat(Now(),'dd/mm/yyyy')#">
					where Ecodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#empresa#">
					and Pcodigo=280
				</cfquery>
				</cfloop><!--- Ciclo de Manejo de Empresas--->
				<!--- 
					Proceso para activar el bit EVinicializar de la tabla  EVinicializar  
					para todos los empleados que se encuentran inactivos (con la fecha de hoy) en la linea del tiempo,
					que tengan el bit EVinicializar = 0 y que la cantidad de dias del ultimo cese sea mayor a la cantidad
					de dias definido en la pantalla de parametro generales de RH 
					(Cantidad de dias para anular antiguedad de empleados inactivos)
				--->

				<!--- 
					Proceso para activar el bit EVinicializar de la tabla  EVinicializar  
					para todos los empleados que se encuentran inactivos (con la fecha de hoy) en la linea del tiempo,
					que tengan el bit EVinicializar = 0 y que la cantidad de dias del ultimo cese sea mayor a la cantidad
					de dias definido en la pantalla de parametro generales de RH 
					(Cantidad de dias para anular antiguedad de empleados inactivos)
				--->
				<cfinvoke component="rh.Componentes.RHParametros" method="get" datasource="#cache#" 
				ecodigo="#empresa#" pvalor="670" default="15" returnvariable="DiasMaxAnular"/>				 
				<cfif vDebug ><b>Dias Maximo Anulacion de Vacaciones:</b> <cfdump var="#DiasMaxAnular#"><br><br></cfif>
				
				<cfquery name="rs_empleadosnoactivos" datasource="#cache#">
					select de.DEid 
					from 	DatosEmpleado de
					inner join EVacacionesEmpleado ev
						on de.DEid = ev.DEid
						and ev.EVinicializar = 0	
					where de.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#empresa#">
					and de.DEid not in 
						(select lt.DEid 
						from LineaTiempo lt
						where lt.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#empresa#">
						and <cfqueryparam value="#now()#" cfsqltype="cf_sql_date"> between lt.LTdesde and lt.LThasta )						
				</cfquery>
				<cfif rs_empleadosnoactivos.recordCount GT 0>
					<cfloop query="rs_empleadosnoactivos">
						<!--- busca la fecha maxima de  LThasta en la linea del tiempo.--->
						<cfquery name="rs_validaactivacion" datasource="#cache#">
							select max(LThasta) as LThasta from LineaTiempo 
							where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#empresa#">
							and DEid = #rs_empleadosnoactivos.DEid#
						</cfquery>
						
						<cfif len(trim(rs_validaactivacion.LThasta)) eq 0>
							<cfset rs_validaactivacion.LThasta =  CreateDate('1900','01','01')>
						</cfif>
						
						<cfif vDebug>
							<br>**************************************************************************************************************<br>
							<b>Cantidad de d&iacute;as para anular antig&uuml;edad de empleados inactivos: </b> <cfdump var="#DiasMaxAnular#"><br>
							<b>Fecha LThasta de empleado  <cfdump var="#rs_empleadosnoactivos.DEid#"> :</b>   <cfdump var="#rs_validaactivacion.LThasta#"><br>	
							<b>diferencia :</b>  <cfdump var="#datediff('d',rs_validaactivacion.LThasta, Now())# "> <br>
							
							<cfquery name="rsantes" datasource="#cache#">
								select 	DEid,EVinicializar from EVacacionesEmpleado
								where  DEid =  #rs_empleadosnoactivos.DEid# 	
							</cfquery>
							<b>antes :</b><br>
							<cfdump var="#rsantes#">
						</cfif>	
						<cfif datediff('d',rs_validaactivacion.LThasta, Now()) gt #DiasMaxAnular#>
							<cfquery name="rs_actualizabit" datasource="#cache#">
								update EVacacionesEmpleado 
								set EVinicializar = 1
								where  DEid =  #rs_empleadosnoactivos.DEid#
							</cfquery>
						</cfif>
						
						<cfif vDebug>
							<cfquery name="rsdespues" datasource="#cache#">
								select 	DEid,EVinicializar from EVacacionesEmpleado
								where  DEid =  #rs_empleadosnoactivos.DEid# 	
							</cfquery>
							<b>despues :</b><br>
							<cfdump var="#rsdespues#">
							**************************************************************************************************************<br>
						</cfif>
					</cfloop>	
				</cfif>
				<cfif vDebug>
					<cftransaction action="rollback" />
				</cfif>		
			</cftransaction>
		</cfif>
		</cfloop>
		<b><Finalizacion del Proceso....></b>
</cfoutput>
