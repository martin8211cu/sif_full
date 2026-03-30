	
							<cfquery datasource="#cache#" name="Empleados">
								select a.DEid, '' as dias, '' as tipo, '' as cantidad
								from EVacacionesEmpleado a, DatosEmpleado b, LineaTiempo c
								where a.EVdia = <cfqueryparam cfsqltype="cf_sql_integer" value="#dia#">
								  and a.EVmes = <cfqueryparam cfsqltype="cf_sql_integer" value="#mes#">
								  and a.EVfantig <= <cfqueryparam cfsqltype="cf_sql_date" value="#FechaInicioCalculo#">
								  and a.EVfecha <= <cfqueryparam cfsqltype="cf_sql_date" value="#ultimafecha#">
								  and b.DEid = a.DEid
								  and c.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#empresa#">
								  and c.DEid = b.DEid
								  and <cfqueryparam cfsqltype="cf_sql_date" value="#FechaInicioCalculo#"> between c.LTdesde and c.LThasta
							</cfquery>
						
							<cfif Empleados.RecordCount GT 0 >
								<!--- Se convierte los DEids de Empleado en una lista para enviar a la funcion--->
								<cfset DEids_Empleado=ValueList(Empleados.DEid,',')>
	
								<cfinvoke component="rh.Componentes.RH_VacacionesProyeccion" method="calcularProyectado" returnvariable="ProyectadoMasivo">
									<cfinvokeargument name="datasource" 	value="#cache#">
									<cfinvokeargument name="Ecodigo" 		value="#empresa#">
									<cfinvokeargument name="IdsEmpleados" 	value="#DEids_Empleado#">
									<cfinvokeargument name="fechaLimitaSuperior" 	value="#FechaInicioCalculo#"><!--- se agrega este proceso para que tome la fecha superior de este proceso, y no del now--->
									<cfinvokeargument name="totalizado" 	value="true">
									<cfinvokeargument name="Debug" 			value="false">
								</cfinvoke>
								
								<cfquery dbtype="query"  name="data"> 
									select DEid, dias as Cantidad,'V' as tipo,'Vacaciones por años Laborados' as descripcion, Regimen
									from ProyectadoMasivo
									union
									select DEid, diasAdicionales as Cantidad,'A' as tipo,'Vacaciones Adicionales por años Laborados' as descripcion, Regimen
									from ProyectadoMasivo
									<cfif diasenfermedad eq 'S'>
									union
									select DEid, diasEnfermedad as Cantidad,'E' as tipo,'Dias de Enfermedad por años Laborados' as descripcion, Regimen
									from ProyectadoMasivo
									</cfif>
								</cfquery>
							<cfelse>
								<cfquery dbtype="query" name="data">
									select * from Empleados
								</cfquery>	
							</cfif>
		
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
								<cfquery datasource="#cache#" name="rsDVElinea" >
									insert into DVacacionesEmpleado (DEid, Ecodigo, RVid, DVEfecha, DVEdescripcion, DVEdisfrutados, DVEcompensados, DVEmonto, Usucodigo, Ulocalizacion, DVEfalta, DVEenfermedad, DVEperiodo)
									values(	
										<cfqueryparam cfsqltype="cf_sql_numeric" value="#data1.DEid#">, 
										<cfqueryparam cfsqltype="cf_sql_integer" value="#empresa#">, 
										<cfqueryparam cfsqltype="cf_sql_numeric" value="#data1.Regimen#">,
										<cfqueryparam cfsqltype="cf_sql_date" value="#FechaInicioCalculo#">, 
										<cfqueryparam cfsqltype="cf_sql_varchar" value="#data1.descripcion#" >,
										<cfif (data1.tipo eq 'V' or data1.tipo eq 'A') and len(trim(data1.cantidad))><cfqueryparam cfsqltype="cf_sql_float" value="#data1.Cantidad#" ><cfelse>0</cfif>, 
										0, 
										0, 
										1, 
										'00', 
										<cf_dbfunction name="today">, 
										<cfif trim(data1.tipo) eq 'E' and len(trim(data1.cantidad))><cfqueryparam cfsqltype="cf_sql_float" value="#data1.Cantidad#"><cfelse>0</cfif>,
										#lvarPeriodo#									
									)
									<cf_dbidentity1 datasource="#cache#">
								</cfquery>
									<cf_dbidentity2 name="rsDVElinea" datasource="#cache#">
									
								<cfset consecutivoDVElinea = rsDVElinea.identity>

								<cfinvoke component="rh.Componentes.RHParametros" method="get" datasource="#cache#" ecodigo="#empresa#" pvalor="2505" default="0" returnvariable="vCtrlVacXPeriodo"/>
	
								<cfif data1.tipo eq 'V' and vCtrlVacXPeriodo>
												<cfquery datasource="#cache#" name="rsVacPotenciales">
													select coalesce(sum(DVAdiasPotenciales),0) as VacPotenciales
													from DVacacionesAcum
													where DEid = #data1.DEid# 
													and Ecodigo = #empresa# 
													and DVAperiodo = #lvarPeriodo#
												</cfquery>
	
												<cfquery dbtype="query" name="ResumidoData1">
													select sum(Cantidad) as cantidad 
													from data
													where tipo = 'V' and DEid=#data1.DEid# 
													group by DEid
												</cfquery>
												<cfset lvarSaldoPotenciales = ResumidoData1.cantidad - rsVacPotenciales.VacPotenciales>
													
												<cfif lvarSaldoPotenciales neq 0>
													<cfquery datasource="#cache#">
														insert into DVacacionesAcum
															(DEid, DVAdiasPotenciales, DVAperiodo, DVAsaldodias, DVASalarioProm, DVASalarioPdiario, DVAfecha, Ecodigo)
														values
															(#data1.DEid#,<cfqueryparam cfsqltype="cf_sql_numeric" value="#lvarSaldoPotenciales#" scale="2">,#lvarPeriodo#,0,0,0,
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
													insert into DVacacionesAcum(DEid, Ecodigo,DVAperiodo,DVAsaldodias,DVASalarioProm,DVASalarioPdiario,DVAfecha, DVElinea)
													values(	
														#data1.DEid#, 
														#empresa#,
														#lvarPeriodo#,
														<cfqueryparam cfsqltype="cf_sql_numeric" value="#data1.cantidad#" scale="2">,
														#SalarioPromedio#,
														#SalarioPromedioDiario#,
														<cfqueryparam cfsqltype="cf_sql_date" value="#FechaInicioCalculo#"> ,
														#consecutivoDVElinea#
													)
												</cfquery>
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
							</cfloop>