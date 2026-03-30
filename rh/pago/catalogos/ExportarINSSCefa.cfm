
<cffunction name="fnGeneraTablasTemporales" output="no" access="private" hint="Genera Tablas Temporales para el proceso">
	<!---  ***************************************** --->
	<!---  TABLA TEMPORAL PARA LLEVAR LA INFORMACION DEL EMPLEADO EN EL MES --->
	<!---  ***************************************** --->
			<cf_dbtemp name="InfoEmpleado" returnvariable="InfoEmpleado" datasource="#session.DSN#">
				<cf_dbtempcol name="DEid"    					type="numeric" 		mandatory="no">
				<cf_dbtempcol name="Mes"   						type="Integer" 		mandatory="no">
				<cf_dbtempcol name="Periodo"   					type="Integer" 		mandatory="no">
				<cf_dbtempcol name="MesA"   					type="Integer" 		mandatory="no">
				<cf_dbtempcol name="PeriodoA"  					type="Integer" 		mandatory="no">
				<cf_dbtempcol name="DiasNoLab" 					type="Integer" 		mandatory="no">
				<cf_dbtempcol name="DiasMes" 					type="Integer" 		mandatory="no">
				<cf_dbtempcol name="FechaFinMes"   				type="datetime" 	mandatory="no">
				<cf_dbtempcol name="Ecodigo" 					type="Integer" 		mandatory="no">
				<cf_dbtempcol name="SalarioMesActual" 			type="numeric(18,2)" 		mandatory="no">
				<cf_dbtempcol name="IncidenciasMesActual" 		type="numeric(18,2)" 		mandatory="no">
				<cf_dbtempcol name="SalarioMesAnterior" 		type="numeric(18,2)" 		mandatory="no">
				<cf_dbtempcol name="IncidenciasMesAnterior" 	type="numeric(18,2)" 		mandatory="no">
				<cf_dbtempcol name="TipoContratacion" 			type="char(1)" 		mandatory="no">	<!---  P = Permanente y E = Eventual--->				
				<cf_dbtempcol name="Vigentes" 					type="Integer"		mandatory="no"> <!---  1 = Vigente Mes Actual	--->
				<cf_dbtempcol name="CantidadDias" 				type="numeric"		mandatory="no">
				<cf_dbtempindex cols="DEid">												 	    <!---  0 = No Vigente Mes Actual	--->
				<cf_dbtempindex cols="DEid,Mes, Periodo">
			</cf_dbtemp>
	
	<!---  ************************************************************************************************** --->
	<!---  TABLA TEMPORAL PARA LLEVAR LA INFORMACION DE LOS MOVIMIENTOS DE SEGURO SOCIAL NICARAGUENSE DEL MES --->
	<!---  ************************************************************************************************** --->
	
			<cf_dbtemp name="MovimientosMes" returnvariable="MovimientosMes" datasource="#session.DSN#">
				<cf_dbtempcol name="Id"    				type="numeric" 		mandatory="yes" identity="yes">
				<cf_dbtempcol name="DEid"    			type="numeric" 		mandatory="no">
				<cf_dbtempcol name="SalarioMensual" 	type="numeric(18,2)"		mandatory="no">	<!---  Salarios Recibidos Mes					--->
				<cf_dbtempcol name="SalarioDevengado" 	type="numeric(18,2)"		mandatory="no">	<!---  Igual a SalarioMensual excepto tipo Mov 3--->
				<cf_dbtempcol name="FechaFinMes"  		type="datetime" 	mandatory="no">	<!---  Fecha Fin del Mes						--->
				<cf_dbtempcol name="TipoMov"    		type="varchar(2)"		mandatory="no"> <!---  Ordenamiento    							--->
				<cf_dbtempcol name="Prioridad"    		type="numeric(1)"	mandatory="no">	<!---  01 - Alta, 			Prioridad 05 		--->
				<cf_dbtempcol name="Sabados"    		type="char(6)"		mandatory="no">	<!---  02 - Baja, 			Prioridad 02 		--->
				<cf_dbtempcol name="Cantidad"    		type="numeric"		mandatory="no">	<!---  03 - CambioSalario,  Prioridad 04 		--->
																							<!---  08 - Salida 			Prioridad 01 		--->
																							<!---  09 - Incapacidades 	Prioridad 03 )		--->
				<cf_dbtempindex cols="DEid">	
			</cf_dbtemp>
			
</cffunction>


		
<!---  ********************************************************************* --->
<!---  FUNCION QUE DETERMINA PARA UN MES EN PARTICULAR CUANTOS SABADOS TIENE --->
<!---  ********************************************************************* --->
<cffunction name="fnDOWs" returntype="numeric" output="no">
            <cfargument name="fecha" type="date"> <!--- Cualquier dia del mes que se quiere --->
            <cfargument name="dow" type="numeric">          <!--- 1=D, 2=L, 3=K, 4=M, 5=J, 6=V, 7=S --->
            <cfset LvarFechaDia1 = createDate(year(Arguments.Fecha),month(Arguments.Fecha),1)>
            <cfset LvarDia1 = DayOfWeek(LvarFechaDia1)>
            <cfset LvarDiasXmes = DaysInMonth(LvarFechaDia1)>			
            <cfset LvarDias = int((LvarDia1 + LvarDiasXmes + 6 - Arguments.dow)/7)>
            <cfif dow LT LvarDia1>
                   <cfset LvarDias = LvarDias - 1>
            </cfif>
			
            <cfreturn LvarDias>
</cffunction>		
		

<cfset fnGeneraTablasTemporales()>

<!---  ***************************************** --->
<!---  VARIABLES CONSTANTES EN EL REPORTE		 --->
<!---  ***************************************** --->
<cfset TipoNomina = 1> <!---  Dato Constante del Reporte según Propuesta Desarrollo --->
<cfset AportesVoluntarios = 0> <!---  Dato Constante del Reporte según Propuesta Desarrollo --->
<cfset FechaInicio = CreateDate(#url.CPperiodo# , #url.CPmes#,1)> 
<cfset Infinito = CreateDate(6100, 1,1)> 
<cfset FechaFin = CreateDate(#url.CPperiodo# , #url.CPmes#,DaysInMonth(FechaInicio))>
<cfset Fecha = CreateDate(#url.CPperiodo# , #url.CPmes#,1)> 
<cfset Mes=#url.CPmes#>
<cfset Periodo=#url.CPperiodo#>
<cfset LvarSabados = fnDOWs(FechaInicio, 7)>
<cfset LvarDiasMes =  DaysInMonth(FechaInicio)>	

<!---Variables necesarias para el calculo de los sabados trabajados--->
<cfset LvarFechaDia1 = createDate(year(FechaInicio),month(FechaInicio),1)>
<cfset LvarDia1 = DayOfWeek(LvarFechaDia1)>
<cfset LvarDiasXmes = DaysInMonth(LvarFechaDia1)>		
<!---*************************************************************--->

<!---  ***************************************** --->
<!---  Se establece quien es el Periodo Anterior --->
<!---  ***************************************** --->
		<cfif #Mes# eq 1>
			<cfset MesA=12>
			<cfset PeriodoA=#Mes#-1>
		<cfelse>
			<cfset MesA=#Mes#-1>
			<cfset PeriodoA=#Periodo#>
		</cfif>
<cfset FechaIniMA = CreateDate(#PeriodoA# , #MesA#,1)>
<cfset FechaFinMA = CreateDate(#PeriodoA# , #MesA#,DaysInMonth(FechaIniMA))>

<!---  ****************************************************** --->
<!---  Carga la Lista de Empleados que laboraron el Mes Actual--->
<!---  ****************************************************** --->
		<cfquery  datasource="#Session.DSN#" name="LZ">
				insert into  #InfoEmpleado# (DEid, Ecodigo, Mes, Periodo, MesA, PeriodoA,
											SalarioMesActual, IncidenciasMesActual, 
											SalarioMesAnterior, IncidenciasMesAnterior, Vigentes,DiasNoLab,DiasMes)
				select 	distinct DEid,
						#session.Ecodigo# as Ecodigo,
						#url.CPperiodo# , #url.CPmes#, #MesA#,#PeriodoA#,
						0,0,
						0,0,
						1,0,#LvarDiasMes#
				from CalendarioPagos cp
					inner join  HSalarioEmpleado pe
					on pe.RCNid  	= cp.CPid
				where cp.Ecodigo = #session.Ecodigo#
				  and cp.CPperiodo	= #url.CPperiodo#
				  and cp.CPmes = #url.CPmes#
		</cfquery>

<!---  *********************************************************--->
<!---  Carga la Lista de Empleados que laboraron el Mes ANTERIOR--->
<!---  ******************************************************** --->
		<cfquery  datasource="#Session.DSN#" name="LZ">
				insert into  #InfoEmpleado# (DEid, Ecodigo, Mes, Periodo, MesA, PeriodoA,
											SalarioMesActual, IncidenciasMesActual, 
											SalarioMesAnterior, IncidenciasMesAnterior, Vigentes,DiasNoLab)
				select 	distinct DEid,
						#session.Ecodigo# as Ecodigo,
						#url.CPperiodo# , #url.CPmes#, #MesA#,#PeriodoA#,
						0,0,
						0,0,
						0,0				  
			From DLaboralesEmpleado la
			 inner join RHTipoAccion ta
				 on    la.Ecodigo = ta.Ecodigo
				 and   ta.RHTid = la.RHTid
			 where la.Ecodigo = #session.Ecodigo#
			 and   la.DLfvigencia between #FechaIniMA# and #FechaFinMA#
			 and ta.RHTcomportam = 2 <!---  Es Cese --->
		</cfquery>
		
		
<!---  ***************************************** --->
<!--- Actualizo Salarios Mes Actual 			 --->
<!---  ***************************************** --->
		<cfquery  datasource="#Session.DSN#" name="LZ">
				update #InfoEmpleado#
				set SalarioMesActual= (Select coalesce(Sum(SEsalariobruto),0)
									   from HSalarioEmpleado hse, HRCalculoNomina hrc, CalendarioPagos cp
									   Where hse.DEid=#InfoEmpleado#.DEid
									   and hrc.RCNid=hse.RCNid
									   and hrc.RCNid=cp.CPid
									   and cp.CPperiodo	= #url.CPperiodo#
				  					   and cp.CPmes = #url.CPmes#)
		</cfquery>
<!---  ***************************************** --->
<!--- Actualizo Incidencias Mes Actual 			 --->
<!---  ***************************************** --->
<cfquery  datasource="#Session.DSN#" name="LZ">
		update #InfoEmpleado#
		set IncidenciasMesActual= (Select coalesce(Sum(ICmontores),0)
							   from HIncidenciasCalculo hic, HRCalculoNomina hrc, CalendarioPagos cp, CIncidentes ci
							   Where hic.DEid=#InfoEmpleado#.DEid
							   and hrc.RCNid=hic.RCNid
							   and hrc.RCNid=cp.CPid
							   and ci.CIid=hic.CIid
							   and ci.CInocargasley=0
							   and cp.CPperiodo	= #url.CPperiodo#
		  					   and cp.CPmes = #url.CPmes#)
</cfquery>		
		
<!---  ***************************************** --->
<!--- Actualizo Salarios Mes Anterior            --->
<!---  ***************************************** --->
		<cfquery  datasource="#Session.DSN#" name="LZ">
				update #InfoEmpleado#
				set SalarioMesAnterior= (Select coalesce(Sum(SEsalariobruto),0)
									   from HSalarioEmpleado hse, HRCalculoNomina hrc, CalendarioPagos cp
									   Where hse.DEid=#InfoEmpleado#.DEid
									   and hrc.RCNid=hse.RCNid
									   and hrc.RCNid=cp.CPid
									   and cp.CPperiodo	= #PeriodoA#
				  					   and cp.CPmes = #MesA#)
		</cfquery>
		

<!---  ***************************************** --->
<!--- Actualizo Incidencias Mes Anterior         --->
<!---  ***************************************** --->

		<cfquery  datasource="#Session.DSN#" name="LZ">
				update #InfoEmpleado#
				set IncidenciasMesAnterior= (Select coalesce(Sum(ICmontores),0)
									   from HIncidenciasCalculo hic, HRCalculoNomina hrc, CalendarioPagos cp, CIncidentes ci
									   Where hic.DEid=#InfoEmpleado#.DEid
									   and hrc.RCNid=hic.RCNid
									   and hrc.RCNid=cp.CPid
									   and ci.CIid=hic.CIid
									   and ci.CInocargasley=0
									   and cp.CPperiodo	= #PeriodoA#
				  					   and cp.CPmes = #MesA#)
		</cfquery>

<!---  ***************************************** --->
<!---- Resta los días que estuvo Ausente TANTO   --->
<!---  ***************************************** --->		

		<!---  ***************************************** --->
		<!---- PRODUCTO DE ACCIONES RETROACTIVAS         --->
		<!---  ***************************************** --->
				<cfquery datasource="#session.DSN#">
					update #InfoEmpleado#
						set DiasNoLab = DiasNoLab +  coalesce( 
													(	select  sum(PEcantdias)
														from HPagosEmpleado a, 
														 	 DatosEmpleado b, 
														 	 RHTipoAccion c,
														 	 CalendarioPagos d
														where 	a.DEid = #InfoEmpleado#.DEid
																and a.DEid = b.DEid
																and a.RCNid = d.CPid													
																and a.RHTid = c.RHTid
																and d.CPmes=<cfqueryparam cfsqltype="cf_sql_integer" value="#url.CPmes#">
																and d.CPperiodo=<cfqueryparam cfsqltype="cf_sql_integer" value="#url.CPPeriodo#">
																and RHTcomportam = 5
																and a.PEtiporeg=0  <!--- LZ 27-02-2009 Solo debe contemplar los Ordinarios no los Retroactivos --->
													) 
												,0)
				</cfquery>
				

		<!---  ***************************************** --->
		<!---- PRODUCTO DE ACCIONES NO RETROACTIVAS      --->
		<!---  ***************************************** --->
		
				<cfset x1 = "'#LSDateFormat(FechaInicio,'dd-mm-yyyy')#'" >
				<cfset y1 = "'#LSDateFormat(FechaFin,'dd-mm-yyyy')#'" >
				
				<cf_dbfunction name="datediff" args="#preservesinglequotes(x1)#, DLfvigencia"	returnvariable="difd3">
				<cf_dbfunction name="datediff" args="#preservesinglequotes(y1)#, DLffin" 		returnvariable="difd4">
		
				<cfquery datasource="#session.DSN#">
					update #InfoEmpleado#
						set DiasNoLab = DiasNoLab +  coalesce( 
													(select  sum(<cf_dbfunction name="datediff" args="DLfvigencia, DLffin">	+1
																	- case when <cfqueryparam cfsqltype="cf_sql_date" value="#FechaInicio#"> > DLfvigencia then 
																				abs(#preservesinglequotes(difd3)#) else 0 end
																	- case when <cfqueryparam cfsqltype="cf_sql_date" value="#FechaFin#"> < DLffin then 
																			    abs(#preservesinglequotes(difd4)#) else 0 end 
																)
													from DLaboralesEmpleado a, 
														 DatosEmpleado b, 
														 RHTipoAccion c
														 <!---RHSaldoPagosExceso d--->
													where 	a.DEid = #InfoEmpleado#.DEid
															and a.DEid = b.DEid
															and a.RHTid = c.RHTid
															<!---and d.DLlinea= a.DLlinea
															and d.RHSPEanulado=0   <!--- Acciones no Anuladas--->--->
															and  (	a.DLfvigencia 	between <cfqueryparam cfsqltype="cf_sql_date" value="#FechaInicio#"> 
																					and <cfqueryparam cfsqltype="cf_sql_date" value="#FechaFin#">
																	or a.DLffin 	between <cfqueryparam cfsqltype="cf_sql_date" value="#FechaInicio#"> 
																					and <cfqueryparam cfsqltype="cf_sql_date" value="#FechaFin#">
																	or <cfqueryparam cfsqltype="cf_sql_date" value="#FechaInicio#"> between a.DLfvigencia and a.DLffin
																	or <cfqueryparam cfsqltype="cf_sql_date" value="#FechaFin#">	between a.DLfvigencia and a.DLffin
																)
													and RHTcomportam = 5  
													) 
												,0)
				</cfquery>

	
		<!---  ****************************************************************** --->
		<!---- SE ACTUALIZA LA CANTIDAD DE DIAS LABORADOS CUANDO EXISTA UN CESE   --->
		<!---  ****************************************************************** --->

		<cfquery datasource="#session.DSN#">
			update #InfoEmpleado#
					set DiasNoLab = coalesce(DiasNoLab,0) + 
									(Select <cf_dbfunction name="datediff" args="DLfvigencia,#FechaFin#">+1
									from DLaboralesEmpleado a,
	 									 RHTipoAccion c
									where a.DEid = #InfoEmpleado#.DEid
									and a.RHTid = c.RHTid
									and c.RHTcomportam = 2
									and a.DLfvigencia >= <cfqueryparam cfsqltype="cf_sql_date" value="#FechaInicio#">
									and a.Ecodigo= #session.Ecodigo#)
			Where exists ( Select 1 
							from DLaboralesEmpleado a,
								RHTipoAccion c
							where a.DEid = #InfoEmpleado#.DEid
							and a.RHTid = c.RHTid
							and c.RHTcomportam = 2
							and a.DLfvigencia >= <cfqueryparam cfsqltype="cf_sql_date" value="#FechaInicio#">
							and a.Ecodigo= #session.Ecodigo#)

		</cfquery>
		
		<!---  ******************************************************************** --->
		<!---- SE ACTUALIZA LA CANTIDAD DE DIAS LABORADOS CUANDO SEA MENOR A CERO   --->
		<!---  ******************************************************************** --->
		<cfquery datasource="#session.DSN#">
				update #InfoEmpleado#
				set DiasNoLab = 0
				Where DiasNoLab < 0
		</cfquery>	
	
	
<!---		  ******************************************************************** 
		- SE ACTUALIZA LA CANTIDAD DE DIAS LABORADOS CUANDO SEA MENOR A CERO   
		  ******************************************************************** 
		<cfquery datasource="#session.DSN#">
				update #InfoEmpleado#
				set DiasNoLab = DiasNoLab+2
				Where DiasNoLab > 0
				and month(FechaFinMes)=2
		</cfquery>	--->
		<!---  *********************************************************************** --->
		<!---- DETERMINA LOS EMPLEADOS QUE TIENEN NOMBRAMIENTO PERMANENENTE y ACTIVOS  --->
		<!---  *********************************************************************** --->
		<cfquery datasource="#session.DSN#">
			update #InfoEmpleado# set 
			TipoContratacion='P'
			Where DEid in (
					Select a.DEid
					from    DatosEmpleado a inner join  					<!--- Informacion del Empleado --->
					            DLaboralesEmpleado b on   					<!--- Encabezado de las Acciones de Personal Confeccionadas (Analizar los Nombramientos) --->
					            a.DEid = b.DEid    							<!--- Relacion Tabla DatosEmpleado vrs DLaboralesEmpleado --->
					            inner join RHTipoAccion c      				<!--- Catálogo de Acciones de Personal relacionado a DLaboralesb (b2) --->
					                on b.RHTid = c.RHTid 					<!--- Relacion Tabla DLaboralesEmpleado vrs RHTipoAccion --->
					                and   c.RHTcomportam = 1				<!--- Comportamiento de1 Tipo de Acción de Personal Nombramiento --->
					                and c.RHTpfijo = 0 						<!--- El Comportamiento de la Accion no es Plazo Fijo, por lo tanto es Permanente --->
					                and a.DEid in (Select lt.DEid 
					                			   from LineaTiempo lt 
					                			   Where #FechaInicio# <=  lt.LThasta
					                			   		 and #FechaFin# >= lt.LTdesde )) <!--- Funcionarios Activos --->
			</cfquery>
			
		<!---  ********************************************************************************** --->
		<!---- DETERMINA LOS EMPLEADOS QUE TIENEN NOMBRAMIENTO PERMANENENTE PERO ESTAN INACTIVOS  --->
		<!---  ********************************************************************************** --->
		<cfquery datasource="#session.DSN#">
			update #InfoEmpleado# set 
			TipoContratacion='P'
			Where DEid in (
					Select a.DEid
					from    DatosEmpleado a inner join  								<!--- Informacion del Empleado --->
					            DLaboralesEmpleado b on   								<!--- Encabezado de las Acciones de Personal Confeccionadas (Analizar los Nombramientos) --->
					            a.DEid = b.DEid    										<!--- Relacion Tabla DatosEmpleado vrs DLaboralesEmpleado --->
								and #FechaInicio# between b.DLfvigencia and b.DLffin 		<!--- nombramiento mas RECIENTE--->					            
					            inner join RHTipoAccion c      							<!--- Catálogo de Acciones de Personal relacionado a DLaboralesb (b2) --->
					                on b.RHTid = c.RHTid 								<!--- Relacion Tabla DLaboralesEmpleado vrs RHTipoAccion --->
					                and   c.RHTcomportam = 1				<!--- Comportamiento de1 Tipo de Acción de Personal Nombramiento --->
					                and c.RHTpfijo = 0 						<!--- El Comportamiento de la Accion no es Plazo Fijo, por lo tanto es Permanente --->
					                and a.DEid not in (Select lt.DEid 
					                			   from LineaTiempo lt 
					                			   Where #FechaInicio# <=  lt.LThasta
					                			   		 and #FechaFin# >= lt.LTdesde )) <!--- Funcionarios Activos --->
			and TipoContratacion is null											<!--- De los que no se les ha asignado en Estatus de Permanentente  --->
			</cfquery>			

		<!---  ************************************************************** --->
		<!---- DETERMINA LOS EMPLEADOS QUE TIENEN NOMBRAMIENTO PERMANENENTE   --->
		<!---  ************************************************************** --->
			<cfquery datasource="#session.DSN#">
					update #InfoEmpleado# 
					set   TipoContratacion='E'
					Where rtrim(TipoContratacion) is null
			</cfquery>
			
			<cfquery datasource="#session.DSN#">
					update #InfoEmpleado# 
					set   TipoContratacion= '0'
					Where rtrim(TipoContratacion) in ('P', 'E')
			</cfquery>
<!---  ***************************************** --->
<!---- ANALISIS DE LOS MOVIMIENTOS DEL MES.   	 --->
<!---  ***************************************** --->

<!---  ***************************************** --->
<!---- INGRESOS DEL MES  					 	 --->
<!---  ***************************************** --->
<cfquery datasource="#session.DSN#">
		Insert into #MovimientosMes#(DEid, SalarioMensual, SalarioDevengado,FechaFinMes, TipoMov, Prioridad,Sabados,Cantidad)
		Select a.DEid,
			   0,
			   SalarioMesActual+IncidenciasMesActual,
			   la.DLfvigencia, <!---#FechaFin#,--->
			   '01',
			   5,
			    '00000',
				0
		From #InfoEmpleado#  a
			 inner join DLaboralesEmpleado la
				on 	  a.DEid = la.DEid
				and   la.DLfvigencia between #FechaInicio# and #FechaFin#
				inner join RHTipoAccion ta
					on    ta.RHTcomportam = 1 -- Es Nombramiento
					and   la.Ecodigo = ta.Ecodigo
					and   ta.RHTid = la.RHTid
</cfquery>

<!---  ***************************************** --->
<!---- BAJAS DEL MES  						 	 --->
<!---  ***************************************** --->
<cfquery datasource="#session.DSN#">
		Insert into #MovimientosMes#(DEid, SalarioMensual, SalarioDevengado,FechaFinMes, TipoMov, Prioridad,Sabados,Cantidad)
		Select a.DEid,
			   0,
			   SalarioMesActual+IncidenciasMesActual,
			   la.DLfvigencia, <!---#FechaFin#,--->
			   '02',
			   1,
			   '00000',0
		From #InfoEmpleado#  a
			 inner join DLaboralesEmpleado la
				 on    a.DEid = la.DEid
				 and   la.Ecodigo = #session.Ecodigo#
				 and   la.DLfvigencia between #FechaInicio# and #FechaFin#
			 inner join RHTipoAccion ta
				 on    ta.RHTcomportam = 2 <!---  Es Cese --->
				 and   la.Ecodigo = ta.Ecodigo
				 and   ta.RHTid = la.RHTid
</cfquery>

<!---  ********************************************************************************************************* --->
<!---- SALIDAS DE LA EMPRESA, CUANDO EL EMPLEADO FUE CESADO EL MES ANTERIOR Y FUE REPORTADO CON MOV = 02	 	 --->
<!---  ********************************************************************************************************* --->
<cfquery datasource="#session.DSN#">
		Insert into #MovimientosMes#(DEid, SalarioMensual, SalarioDevengado,FechaFinMes, TipoMov, Prioridad,Sabados,Cantidad)
		Select a.DEid,
			   0,
			   0,<!---SalarioMesActual+IncidenciasMesActual,--->
			   #FechaFinMA#,
			   '08',
			   2,
			   '00000',0
		From #InfoEmpleado#  a
		where Vigentes = 0	 
				 
</cfquery>

<!---  ***************************************** --->
<!---- INCAPACIDADES DEL MES RETROACTIVAS	 	 --->
<!---  ***************************************** --->
<cfquery datasource="#session.DSN#">
		Insert into #MovimientosMes#(DEid, SalarioMensual, SalarioDevengado,FechaFinMes, TipoMov, Prioridad,Sabados,Cantidad)
		Select a.DEid,
			   0,
			   SalarioMesActual+IncidenciasMesActual,
			   #FechaFin#,
			   '09',
			   3,
			   '00000',0
		From #InfoEmpleado#  a
				inner join HPagosEmpleado b
				on a.DEid=b.DEid
				and PEtiporeg=0
					inner join HRCalculoNomina c
					on b.RCNid=c.RCNid
						inner join CalendarioPagos d
						on d.CPid=c.RCNid
						and d.CPmes=#Mes#
						and d.CPperiodo=#Periodo#
						and d.Ecodigo=#session.Ecodigo#
							inner join RHTipoAccion e
							on b.RHTid=e.RHTid
							and e.RHTcomportam=5
</cfquery>

<!---  ***************************************** --->
<!---- INCAPACIDADES DEL MES NO RETROACTIVAS 	 --->
<!---  ***************************************** --->
<cfquery datasource="#session.DSN#">
		Insert into #MovimientosMes#(DEid, SalarioMensual, SalarioDevengado,FechaFinMes, TipoMov, Prioridad,Sabados,Cantidad)
		Select  a.DEid,
			   0,
			   SalarioMesActual+IncidenciasMesActual,
			   b.DLfvigencia, <!---#FechaFin#,--->
			   '09',
			   1,
			   '00000',0
		From #InfoEmpleado#  a
				inner join DLaboralesEmpleado b
				on a.DEid = b.DEid
				and b.Ecodigo=#session.Ecodigo# 
				and  (b.DLfvigencia 	between <cfqueryparam cfsqltype="cf_sql_date" value="#FechaInicio#"> and <cfqueryparam cfsqltype="cf_sql_date" value="#FechaFin#">
										<!---or b.DLffin 	between <cfqueryparam cfsqltype="cf_sql_date" value="#FechaInicio#"> and <cfqueryparam cfsqltype="cf_sql_date" value="#FechaFin#">
										or <cfqueryparam cfsqltype="cf_sql_date" value="#FechaInicio#"> between b.DLfvigencia and b.DLffin
										or <cfqueryparam cfsqltype="cf_sql_date" value="#FechaFin#">	between b.DLfvigencia and b.DLffin
				--->	)
					inner join RHTipoAccion c
					on b.RHTid = c.RHTid
					and c.RHTcomportam = 5												
		<!---where---> 		
			    
														<!---DLaboralesEmpleado b
				on a.DEid = b.DEid
				and b.Ecodigo=#session.Ecodigo#
				and b.DLfvigencia >= #FechaInicio#
				and b.DLffin <= #FechaFin#
					inner join RHTipoAccion c
					on b.RHTid = c.RHTid
					and c.RHTcomportam = 5
					and c.RHTcodigo = 'NP1'
				inner join RHSaldoPagosExceso sp
				on a.DEid=sp.DEid
				and sp.Ecodigo=#session.Ecodigo#
				and sp.RHSPEfdesde >= #FechaFin#
				and sp.RHSPEfhasta <= #FechaInicio#
		Where not exists (Select 1 
								From #MovimientosMes# c
								Where a.DEid=c.DEid
								and  c.TipoMov = '02')--->
</cfquery>


<!---  ***************************************** --->
<!---- CAMBIOS DE SALARIO					  	 --->
<!---  ***************************************** --->
<cfquery datasource="#session.DSN#">
		Insert into #MovimientosMes#(DEid, SalarioMensual, SalarioDevengado,FechaFinMes, TipoMov, Prioridad,Sabados,Cantidad)
		Select a.DEid,
			   SalarioMesActual,
			   SalarioMesActual+IncidenciasMesActual,
			   #FechaFin#,
			   '03',
			   4,
			   '00000',0
		From #InfoEmpleado#  a
		Where not exists (Select 1 
								From #MovimientosMes# c
								Where a.DEid=c.DEid
								and  c.TipoMov = '01')
		
</cfquery>
<cfquery name="rsUpCantidad" datasource="#session.dsn#">
	update #MovimientosMes# 
	set Cantidad =(#LvarDia1#+(
					select DiasMes-DiasNoLab
					from #InfoEmpleado# where
					DEid=#MovimientosMes#.DEid)
					+6-7)
</cfquery>
<cfquery name="rsUpCantidad2" datasource="#session.dsn#">
	update #InfoEmpleado#  
	set CantidadDias =Ceiling((select min(Cantidad) from #MovimientosMes# where #MovimientosMes#.DEid=#InfoEmpleado#.DEid)/7)
	 
</cfquery>
<cfquery name="x" datasource="#session.dsn#">
	select b.DiasNoLab,DiasMes,(DiasMes-DiasNoLab) as DiasLab,Cantidad
	from #MovimientosMes# a, #InfoEmpleado# b
	where 
	a.DEid=b.DEid
	and a.DEid=3636
</cfquery>

<!---- ACTUALIZA LA CANTIDAD DE SABADOS LABORADOS  	 --->
<cfquery datasource="#session.DSN#">
			update #MovimientosMes# 
			set Sabados=(Select case 
								when CantidadDias = 0 and  #LvarSabados# =4 then '00000'
								when CantidadDias = 1 and  #LvarSabados# =4 then '10000'
								when CantidadDias = 2 and  #LvarSabados# =4 then '11000'
								when CantidadDias = 3 and #LvarSabados# =4 then '11100'
								when CantidadDias = 4 and #LvarSabados# =4 then '11110'
								when CantidadDias > 4 and #LvarSabados# =4 then '11110'
								
								when CantidadDias = 0 and #LvarSabados# =5 then '00000'
								when CantidadDias = 1 and #LvarSabados# =5 then '10000'
								when CantidadDias = 2 and #LvarSabados# =5 then '11000'
								when CantidadDias = 3 and #LvarSabados# =5 then '11100'
								when CantidadDias = 4 and #LvarSabados# =5 then '11110'
								when CantidadDias > 4 and #LvarSabados# =5 then '11111'
								else '11111'
								end
						  From #InfoEmpleado# 
						  Where DEid = #MovimientosMes#.DEid) 
</cfquery>

<!---  ***************************************** --->

<!---<cfquery datasource="#session.DSN#">

update 
	delete from #MovimientosMes# where DEid in (select DEid from #MovimientosMes#
												where TipoMov = '01')
</cfquery>--->


<!---  ********************************************* --->
<!---- ACTUALIZA LA CANTIDAD DE SABADOS LABORADOS  	 --->
<!---  ********************************************* --->

<!--- <cfset LvarDia1 = DayOfWeek(LvarFechaDia1)>--->
	<!---	<cfquery datasource="#session.DSN#">
			update #MovimientosMes# 
			set Sabados= (Select case when (DiasNoLab = 0) and #LvarSabados# =4 then
										 	 '11110'
									  when (DiasNoLab = 0) and #LvarSabados# =5 then
										 	 '11111'
									  when (DiasNoLab between 1 and 10) then
										 	 '11100'
								  	  when (DiasNoLab between 11 and 17) then
										 	 '11000'
								  	  when (DiasNoLab between 18 and 24) then
										 	 '11110'
								  	  when (DiasNoLab >=25) and #LvarSabados# =5 then
										 	 '00000'
								  	  when (DiasNoLab >=25) and #LvarSabados# =4 then
										 	 '10000'
 							 	      else
								 	 		 '11111'
						 		      end
						  From #InfoEmpleado# 
						  Where DEid = #MovimientosMes#.DEid)--->
<!---		update #MovimientosMes# 
			set Sabados= (Select case when (DiasNoLab = 0) and #LvarSabados# =4 then
										 	 '11110'
									  when (DiasNoLab = 0) and #LvarSabados# =5 then
										 	 '11111'
									  when (DiasNoLab between 1 and 10) and #LvarSabados# =4 then
										 	 '11100'
									  when (DiasNoLab between 1 and 10) and #LvarSabados# =5 then
										 	 '11110'
								  	  when (DiasNoLab between 11 and 17) and #LvarSabados# =4 then
										 	 '11100'
									   when (DiasNoLab between 11 and 17) and #LvarSabados# =5 then
										 	 '11100'
									when (DiasNoLab between 18 and 24) and #LvarSabados# =4 then
										 	 '10000'		 
								  	  when (DiasNoLab between 18 and 24) and #LvarSabados# =5  then
										 	 '11000'
								  	  when (DiasNoLab >=25) and #LvarSabados# =5 then
										 	 '00000'
								  	  when (DiasNoLab >=25) and #LvarSabados# =4 then
										 	 '10000'
 							 	      else
								 	 		 '11111'
						 		      end
						  From #InfoEmpleado# 
						  Where DEid = #MovimientosMes#.DEid)
</cfquery>--->

<!---<cfquery datasource="#session.DSN#">
	delete from #MovimientosMes# where DEid in (select DEid from #MovimientosMes#
												where TipoMov = '01')
</cfquery>--->
<!---<cfquery datasource="#session.DSN#" name = "katy">
select *
from #MovimientosMes#
where DEid = 13061 
</cfquery>
<cfdump var = "#katy#">--->
<cfquery datasource="#session.DSN#">
	update #MovimientosMes# set Sabados = '00000'
	where TipoMov ='08'
</cfquery>

<cfquery datasource="#session.DSN#">
	update #MovimientosMes# set Sabados = '00000'
	where TipoMov in ('02', '09')
	and SalarioDevengado = 0
	and SalarioMensual = 0
</cfquery>

<cf_dbfunction name="OP_concat" returnvariable="LvarCCat">
<cf_dbfunction name="date_format" args="a.FechaFinMes,yyyy-mm-dd" returnvariable="LvarFecha">
<cf_dbfunction name="concat" args="'''';#LvarFecha#" returnvariable="fecha" delimiters=";">
<!---<cf_dumptable var="#MovimientosMes#">--->

<cfquery name="ERR" datasource="#session.DSN#">
		
	select 					
									c.DESeguroSocial as SeguroSocial, 
									<!--- c.DEnombre as Nombre,--->
									coalesce(SUBSTRING(c.DEnombre,1,CHARINDEX(' ',c.DEnombre)),c.DEnombre)as Nombre, <!---sólo toma en cuenta el primer nombre del empleado "Katy"--->
									c.DEapellido1 as Apellido1,
									#TipoNomina# as TipoNomina,
									a.TipoMov as TipoMov,
									#preservesinglequotes(fecha)# as Fecha,
										round(a.SalarioDevengado,2) as SalarioDevengado,
										round(a.SalarioMensual,2) as SalarioMensual,
									'#LSCurrencyFormat(AportesVoluntarios,'none')#' as AportesVol,
									a.Sabados as Sabados,
									b.TipoContratacion as TipoContratacion
	from #MovimientosMes# a, #InfoEmpleado# b, DatosEmpleado c
	Where a.DEid=b.DEid
	and a.DEid=c.DEid
	and b.DEid = c.DEid

	and a.Prioridad = (Select Min(Prioridad) 
				from #MovimientosMes# d
				Where d.DEid=a.DEid)


	
</cfquery>