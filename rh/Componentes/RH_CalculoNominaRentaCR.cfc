<cfcomponent>
	<cffunction name="CalculoNominaRenta" access="public" output="true" >
		<cfargument name="conexion" 			type="string" 	required="no" default="#Session.DSN#">
		<cfargument name="RCNid"   				type="numeric" 	required="yes">
		<cfargument name="Ecodigo" 				type="numeric" 	required="yes">
		<cfargument name="Tcodigo" 				type="string" 	required="yes">
		<cfargument name="cantdias" 			type="numeric"	required="yes">
		<cfargument name="CantDiasMensual" 		type="numeric"	required="yes">
		<cfargument name="CantPagosRealizados" 	type="numeric"	required="yes">		
		<cfargument name="Factor" 				type="numeric"	required="yes">				
		<cfargument name="per" 					type="numeric"	required="yes">				
		<cfargument name="mes" 					type="numeric"	required="yes">				
		<cfargument name="IRcodigo" 			type="string" 	required="yes">
		<cfargument name="RCdesde" 				type="date" 	required="yes">
		<cfargument name="RChasta" 				type="date" 	required="yes">
		
		<!--- SE VERIFICA PARAMETRO PARA CALCULO DE RENTA MANUAL SI NO ES MANUEL SIGUE EL CALCULO NORMAL --->			
		<cfinvoke component="RHParametros" method="get" datasource="#Arguments.conexion#" ecodigo="#Arguments.Ecodigo#" pvalor="1090" default="" returnvariable="RentaManual"/>
		<!--- <cfif Not Len(RentaManual) or RentaManual EQ 0> --->
		<!--- Calculo de Renta Costa Rica --->
		<!--- Se deducen del devengado total a proyectar las cargas del empleado ---> 
		<!--- que esten marcadas como:  Disminuyen el monto imponible de Renta ---> 
		<!--- Se suman a esto las cargas deducibles de renta de otras nominas del mes ---> 
		<!--- Ejemplo. Planes de Pension Voluntaria ---> 
		

		<cfquery name="rsDatosRenta" datasource="#arguments.conexion#">
			select coalesce(IRfactormeses,1) as IRfactormeses, coalesce(IRCreditoAntes, 0) as IRCreditoAntes
		 	from ImpuestoRenta 
		 	where IRcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.IRcodigo#">
		</cfquery>	

		<!---ljimenez lee parametro calculo renta retroactivo--->
		<cfinvoke component="RHParametros" method="get" datasource="#arguments.conexion#" ecodigo="#arguments.Ecodigo#" pvalor="31" default="0" returnvariable="vUsaRetro"/>
		
		<!---ljimenez crea tabla temporar para control de retroactivos--->

		<cf_dbtemp name="ExcepcionesRenta" returnvariable="ExcepcionesRenta" datasource="#session.DSN#">
			<cf_dbtempcol name="RCNid" type="numeric" mandatory="no">	
			<cf_dbtempcol name="DEid" type="numeric" mandatory="no">
			<cf_dbtempcol name="SalarioExo" type="money" mandatory="no">
			<cf_dbtempcol name="Proyectado" type="money" mandatory="no">
		</cf_dbtemp>
			<!--- Fecha de inicio de tabla de renta anual vigente--->				
			<cfquery datasource="#session.DSN#" name="Tabla">
				select EIRdesde
				from EImpuestoRenta a, RCalculoNomina b
				where IRcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.IRcodigo#">
				and EIRestado = 1
				and (RCdesde between EIRdesde and EIRhasta 
				   or RChasta between EIRdesde and EIRhasta )
				and RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.RCNid#">
			</cfquery>
			<cfset FechaTabla = Tabla.EIRdesde>
			<cfquery datasource="#session.DSN#" name="Calendario">
				-- Establezco El mes/periodo Primer Calendario de Pagos Vigente en la Nómina para esa tabla de Renta
				select CPperiodo, CPmes
				from CalendarioPagos
				Where CPid in (Select min(CPid)
							   from CalendarioPagos
							   Where CPdesde >= <cfqueryparam cfsqltype="cf_sql_date" value="#LSDateformat(Tabla.EIRdesde,'dd/mm/yyyy')#">
							   and Tcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.Tcodigo#">
							   and Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.Ecodigo#">)
			</cfquery>
		
			<cfset FechaPrimeraNomina = CreateDate(Calendario.CPperiodo,Calendario.CPmes,01)>
			<!--- LZ Si el Periodo/Mes del primer Calendario es diferente de la Tabla --->								
			<cfif FechaPrimeraNomina NEQ FechaTabla>
				<cfset FechaTabla = FechaPrimeraNomina>
			</cfif>
		
		<!--- **************** INICIO MODIFICACION RENTA ANUAL JC  ********************** --->	
		<cfif rsDatosRenta.IRfactormeses eq 12>		
			<!--- INICIO MODIFICACION RENTA ANUAL JC --->		
			<cf_dbtemp name="EmpleadosRenta1" returnvariable="EmpleadosRenta" datasource="#session.DSN#">
				<cf_dbtempcol name="DEid" type="numeric" mandatory="no">
				<cf_dbtempcol name="ingreso" type="datetime" mandatory="no">
				<cf_dbtempcol name="meses_periodo" type="int" mandatory="no">
				<cf_dbtempcol name="SEproyectado" type="money" mandatory="no">
				<cf_dbtempcol name="SEdevengado" type="money" mandatory="no">
				<cf_dbtempcol name="PEcantdias" type="int" mandatory="no">			
				<cf_dbtempcol name="SErenta" type="money" mandatory="no">
				<cf_dbtempcol name="SERentaT" type="money" mandatory="no">
				<cf_dbtempcol name="SERentaD" type="money" mandatory="no">
				<cf_dbtempcol name="Renta_proyectada" type="money" mandatory="no">
				<cf_dbtempcol name="Renta" type="money" mandatory="no">
				<cf_dbtempcol name="Periodos" type="money" mandatory="no">
				<cf_dbtempcol name="Periodos_Transcurridos" type="money" mandatory="no">
			</cf_dbtemp>

			<cfquery datasource="#session.DSN#">
				insert into #EmpleadosRenta# (DEid, ingreso, meses_periodo)
					select DEid, (select min(LTdesde) from LineaTiempo b where a.DEid = b.DEid), 0
						from SalarioEmpleado a
						where RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.RCNid#">
			</cfquery>
		
			<!--- LZ Verifica que a partir de la Vigencia de la Tabla de Renta, 
					existan la Cantidad Mínima de Calendarios de Pago esperados para el año,
					de modo que el Sistema calcule adecuadamente los montos proyectados 
					Mensual --> 12 Calendarios. 
					Bisemanal--> 26 Calendarios 
					Quincenal--> 24 Calendarios
					Semanal--> 52 Calendarios --->								
				
			<cfquery datasource="#session.DSN#" name="VerificaCalendarios">
				select count(CPid) as CantCalendarios, case b.Ttipopago  when  0 then 52
																	  when  1 then 26
																	  when  2 then 15
																	  when  3 then 30
													end as CantEsperados
				from CalendarioPagos a, TiposNomina b
				Where a.Tcodigo=b.Tcodigo
				and a.Ecodigo=b.Ecodigo
				and a.Tcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.Tcodigo#">
				and a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.Ecodigo#">
				and a.CPhasta >= <cfqueryparam cfsqltype="cf_sql_date" value="#LSDateformat(FechaTabla,'dd/mm/yyyy')#">
				group by a.Tcodigo, case b.Ttipopago when 0 then 52 
													 when 1 then 26 
													 when 2 then 15 
													 when 3 then 30 
									end
			</cfquery>
			<cfif VerificaCalendarios.CantCalendarios LT VerificaCalendarios.CantEsperados>
				<cfthrow detail="Error utilizando Renta Anual. Deben definirse la totalidad de Calendarios de Pago del Año, 
								 para una correcta distribuci&oacute;n de la retenci&oacute;n por n&oacute;mina a calcular">
			</cfif>	
					
			<!--- TODO ESTO SE SUPRIME POR OTRO CODIGO PARA MANEJAR EN FORMA CORRECTA LAS NOMINAS BISEMANALES
					Fecha de inicio de actual tabla de renta anual
					<cfquery datasource="#session.DSN#" name="Tabla">
						select EIRdesde
						from EImpuestoRenta a, RCalculoNomina b
						where IRcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.IRcodigo#">
						and EIRestado = 1
						and (RCdesde between EIRdesde and EIRhasta 
						   or RChasta between EIRdesde and EIRhasta )
						and RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.RCNid#">
					</cfquery>
					
					<cfset FechaTabla = Tabla.EIRdesde> 
					FIN TODO ESTO SE SUPRIME POR OTRO CODIGO PARA MANEJAR EN FORMA CORRECTA LAS NOMINAS BISEMANALES--->	
			<cf_dbfunction name="dateaddx" args="yy|1|'#LSDateFormat(FechaTabla,'dd/mm/yyyy')#'" returnvariable="Lvar_DAdd" delimiters="|">

			<!--- datediff(mm,RCdesde,dateadd(yy,1,<cfqueryparam cfsqltype="cf_sql_timestamp" value="#FechaTabla#">)) --->
			<!--- Cantidad de meses que faltan para cotizar todo el año --->				
			<cfquery datasource="#session.DSN#" name="Faltantes">
				select abs(<cf_dbfunction name="datediff" args="RCdesde|#preservesinglequotes(Lvar_DAdd)#|mm" delimiters="|">) as Meses
				from RCalculoNomina
				where RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.RCNid#">
			</cfquery>
			<cfset MesesFaltantes = Faltantes.Meses>		
			<!--- Cantidad de Periodos Faltantes --->		
			<cfquery datasource="#session.DSN#" name="Faltan">
				select count(1) as periodos
				from CalendarioPagos a, RCalculoNomina b
									where CPtipo = 0
									and a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.Ecodigo#">
									and a.Tcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#arguments.Tcodigo#">
									and CPhasta between RCdesde and #preservesinglequotes(Lvar_DAdd)#
									and RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.RCNid#">
			</cfquery>		
			
			<cfset Periodos_Faltantes = Faltan.periodos>

			<cfif Periodos_Faltantes LT 1>
				<cfthrow detail="Error al Calcular Renta. Defina todos los calendarios pago de n&oacute;mina del año, 
								 antes de calcular la renta anual. Recuerde definir la Fecha de Rige de la Tabla de Renta en el periodo actual">
			</cfif>
			<cf_dbfunction name="datediff" args="'#LSDateFormat(FechaTabla,'dd/mm/yyyy')#', ingreso,mm" returnvariable="Lvar_Ddiff">
			<!--- datediff(mm,<cfqueryparam cfsqltype="cf_sql_timestamp" value="#FechaTabla#">, ingreso) --->
			<!--- Cantidad de meses que el empleado va a cotizar en el año --->							
			<cfquery datasource="#session.DSN#">
					update #EmpleadosRenta# 
					set meses_periodo = case when ingreso > <cfqueryparam cfsqltype="cf_sql_timestamp" value="#FechaTabla#"> 
										then abs(12-#preservesinglequotes(Lvar_Ddiff)#)
										else 12 end
			</cfquery>
		

			<!--- LZ En Panamá si un empleado entro despues de la primera nomina de renta en adelante, 
				   se le rebaja periodicamente contabilizando los meses transcurridos pero tomando en cuenta la cantidad de periodos totales anuales
				   Esto no ocurre en Nicaragua, Honduras, Salvador (CEFA), por lo que se condiciona al país mientras se da una solucion
			  --->
			
			<cfquery datasource="#session.DSN#">
						update #EmpleadosRenta# 
						set Periodos = (select count(1) from CalendarioPagos 
										where CPtipo = 0
										and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.Ecodigo#">
										and Tcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#arguments.Tcodigo#">
										and CPhasta between <cfqueryparam cfsqltype="cf_sql_timestamp" value="#FechaTabla#">
										and #preservesinglequotes(Lvar_DAdd)#
										)
			</cfquery>											

			<!--- Cantidad de periodos que el empleado va a cotizar en el año --->		
			<cfquery datasource="#session.DSN#">
				update #EmpleadosRenta# 
				set Periodos = case when ingreso > <cfqueryparam cfsqltype="cf_sql_timestamp" value="#FechaTabla#"> 
									then 
									(select count(1) from CalendarioPagos 
									where CPtipo = 0
									and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.Ecodigo#">
									and Tcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#arguments.Tcodigo#">
									and CPhasta between #EmpleadosRenta#.ingreso
									and #preservesinglequotes(Lvar_DAdd)#
									)
									else 
									(select count(1) from CalendarioPagos 
									where CPtipo = 0
									and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.Ecodigo#">
									and Tcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#arguments.Tcodigo#">
									and CPhasta between <cfqueryparam cfsqltype="cf_sql_timestamp" value="#FechaTabla#">
									and #preservesinglequotes(Lvar_DAdd)#
									)
									 end
			</cfquery>
		
			<!--- Cantidad de periodos que el empleado ya lleva cotizados --->		
			<cfquery datasource="#session.DSN#" name="transcurridos">
				update #EmpleadosRenta# 
				set Periodos_Transcurridos = case when ingreso > <cfqueryparam cfsqltype="cf_sql_timestamp" value="#FechaTabla#"> 
						then 
						(select count(1) from CalendarioPagos a, RCalculoNomina b
						where CPtipo = 0
						and a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.Ecodigo#">
						and a.Tcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#arguments.Tcodigo#">
						and (CPhasta >= #EmpleadosRenta#.ingreso
								and CPdesde <= RChasta)
						and RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.RCNid#">
						)
						else
						(select count(1) from CalendarioPagos a, RCalculoNomina b
						where CPtipo = 0
						and a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.Ecodigo#">
						and a.Tcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#arguments.Tcodigo#">
						and (CPhasta >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#FechaTabla#"> 
							  and CPdesde <= RChasta)
						and RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.RCNid#">
						)
						 end
			</cfquery>					


			<!--- Salario Devengado en Nominas históricas --->		
			<cfquery datasource="#session.DSN#">
				update #EmpleadosRenta# 
				set SEdevengado = (select coalesce(sum(SEsalariobruto),0)
											from HRCalculoNomina a, 
												 HSalarioEmpleado b, 
												 CalendarioPagos c
											where a.RCNid=c.CPid
											and c.CPhasta >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#FechaTabla#">
											and a.RCNid = b.RCNid
											and c.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.Ecodigo#">
											and b.DEid = #EmpleadosRenta#.DEid)
				
			</cfquery>
	    
			<!--- Salario Incidencias en Nominas históricas --->		
			<cfquery datasource="#session.DSN#">
				update #EmpleadosRenta# 
				set SEdevengado = SEdevengado+(Select coalesce(sum(ICmontores),0)
															 from HRCalculoNomina a,
																  CalendarioPagos b,
																  HIncidenciasCalculo c, 
																  CIncidentes d
															 where a.RCNid=b.CPid
															 and b.CPhasta >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#FechaTabla#">
															 and b.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.Ecodigo#">
															 and c.RCNid = a.RCNid
															 and c.DEid = #EmpleadosRenta#.DEid
															 and c.CIid = d.CIid
															 and d.CInorenta = 0 )
			</cfquery>
	    
			<!--- Se rebajan las Cargas Sociales que rebajan el Monto Imponible de Renta --->		
			<cfquery datasource="#session.DSN#">
				update #EmpleadosRenta# 
				set SEdevengado =SEdevengado-(Select coalesce(sum(CCvaloremp),0)
															 from HRCalculoNomina a,
																  CalendarioPagos b,
																  HCargasCalculo c, 
																  DCargas d
															 where a.RCNid=b.CPid
															 and b.CPfpago >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#FechaTabla#">
															 and b.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.Ecodigo#">
															 and c.RCNid = a.RCNid
															 and c.DEid = #EmpleadosRenta#.DEid
															 and c.DClinea = d.DClinea
															 and d.DCnorenta = 1 )
	   		</cfquery>
		
			<cfquery datasource="#session.DSN#">
				update #EmpleadosRenta# set
				PEcantdias =  (select coalesce(sum(PEcantdias),0) 
								from HRCalculoNomina a, HPagosEmpleado c,CalendarioPagos d
									where a.RCNid=d.CPid
									and d.CPhasta >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#FechaTabla#">
									and d.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.Ecodigo#">
									and c.DEid = #EmpleadosRenta#.DEid
									and a.RCNid=c.RCNid
									)
									
			</cfquery>
			
			<cfquery datasource="#session.DSN#">																
				update #EmpleadosRenta# set
				SERentaT	= coalesce((Select sum(SERentaT)
									from HRCalculoNomina a, HSalarioEmpleado b, CalendarioPagos c
									where a.RCNid=c.CPid
									and c.CPhasta >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#FechaTabla#">
									and a.RCNid = b.RCNid
									and c.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.Ecodigo#">
									and b.DEid = #EmpleadosRenta#.DEid
									)
									,0)
			</cfquery>
			<!--- Salario Devengado en Nómina Actual --->
			<cfquery datasource="#session.DSN#">
				update #EmpleadosRenta# 
				set SEdevengado = SEdevengado + (select SEsalariobruto 
												+ coalesce(( Select sum(ICmontores) 
															from IncidenciasCalculo c, CIncidentes d
															where b.DEid = c.DEid
															and c.RCNid = a.RCNid
															and c.CIid = d.CIid
															and d.CInorenta = 0),0)
												- coalesce(( Select sum(CCvaloremp) 
															from CargasCalculo c, DCargas d
															where b.DEid = c.DEid
															and c.RCNid = a.RCNid
															and c.DClinea = d.DClinea
															and d.DCnorenta = 1),0)		   
									from RCalculoNomina a, SalarioEmpleado b
									where a.RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.RCNid#">
									and a.RCNid = b.RCNid
									and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.Ecodigo#">
									and b.DEid = #EmpleadosRenta#.DEid
									)  , 
				PEcantdias =  PEcantdias + coalesce((select sum(PEcantdias)
													from RCalculoNomina a, PagosEmpleado c
													where a.RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.RCNid#">
													and a.RCNid = c.RCNid
													and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.Ecodigo#">
													and c.DEid = #EmpleadosRenta#.DEid
													and c.PEtiporeg  < 2
													),0)  
			</cfquery>
		
			<!--- Proyección del SEProyectado  (Devengado entre dias ) --->
			<cfquery datasource="#session.DSN#">
				update #EmpleadosRenta# 
				----- set SEproyectado = ( SEdevengado / PEcantdias ) * 30 * meses_periodo
				set SEproyectado =  SEdevengado *  (Periodos / Periodos_Transcurridos)
			</cfquery>
		
			<!--- Calculo del Impuesto sobre la Renta al salario. --->
			<cfquery name="proyectar" datasource="#arguments.conexion#">
				update #EmpleadosRenta# 
					set Renta_proyectada = coalesce((	select round(((#EmpleadosRenta#.SEproyectado - a.DIRinf ) * (a.DIRporcentaje / 100)) + a.DIRmontofijo,2)  
												from EImpuestoRenta b, DImpuestoRenta a
												where b.IRcodigo = '#arguments.IRcodigo#'
													and b.EIRestado > 0
													and a.EIRid = b.EIRid
													and <cfqueryparam cfsqltype="cf_sql_date" value="#arguments.RChasta#"> between EIRdesde and EIRhasta
													and round(#EmpleadosRenta#.SEproyectado,2) >= round(a.DIRinf,2)
													and round(#EmpleadosRenta#.SEproyectado,2) <= round(a.DIRsup,2)), 0.00)
			</cfquery>
		


			<!---  Se resta lo ya cobrado y se divide entre los meses faltantes --->
			<cfquery name="calculorenta" datasource="#arguments.conexion#">
				update #EmpleadosRenta# 
					set Renta = ((Renta_proyectada - SERentaT) / #Periodos_Faltantes# ) -----/ #Factor#
			</cfquery>
		</cfif>			
		
		<!--- **************** FIN MODIFICACION RENTA ANUAL JC  ********************** --->				
		
		<cfquery datasource="#session.DSN#">
			update SalarioEmpleado 
			set SEinorenta =  coalesce((select sum(cc.CCvaloremp)
										from CargasCalculo cc, DCargas dc
										where cc.RCNid = SalarioEmpleado.RCNid
											and cc.DEid = SalarioEmpleado.DEid
										  	and dc.DClinea = cc.DClinea
										  	and dc.DCnorenta > 0), 0.00) 
			where SalarioEmpleado.RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.RCNid#">
				and SalarioEmpleado.SEcalculado = 0
		</cfquery>

		<!--- Cargas que se rebajan de la renta calculadas en este mes --->
		<cfquery datasource="#arguments.conexion#">
			update SalarioEmpleado 
			set SEinorenta = SEinorenta + coalesce ((	select sum(cc.CCvaloremp)
														from HCargasCalculo cc, CalendarioPagos cp, DCargas dc
														where cc.DEid = SalarioEmpleado.DEid
															and cp.CPid = cc.RCNid
															and cp.CPperiodo = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.per#">
															and cp.CPmes = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.mes#">
															and cp.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.Ecodigo#">
															and cp.CPnorenta = 0
															and dc.DClinea = cc.DClinea
															and dc.DCnorenta > 0 ), 0.00)
			where SalarioEmpleado.RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.RCNid#">
				and SalarioEmpleado.SEcalculado = 0
		</cfquery>

		<!--- Pagos Externos Realizados por el empleado y que disminuyen el monto imponible de la renta. --->
		<cfquery datasource="#arguments.conexion#">
			update SalarioEmpleado 
				set SEinorenta = SEinorenta 
								 + coalesce ((	select sum(pext.PEXmonto)
												from RHPagosExternosCalculo pext
													inner join  RHPagosExternosTipo tipo
														on tipo.PEXTid = pext.PEXTid
														and tipo.PEXTsirenta = 1
												where pext.DEid = SalarioEmpleado.DEid
												  and pext.RCNid = SalarioEmpleado.RCNid ), 0.00)
								 + coalesce ((	select sum(pext.PEXmonto)
												from CalendarioPagos cp,HRHPagosExternosCalculo pext,RHPagosExternosTipo tipo
												where cp.CPperiodo = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.per#">
												  	and cp.CPmes = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.mes#">
												  	and cp.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.Ecodigo#">
												  	and tipo.PEXTid = pext.PEXTid
												  	and tipo.PEXTsirenta = 1
												  	and pext.DEid = SalarioEmpleado.DEid
												  	and pext.RCNid = cp.CPid ), 0.00)
			where SalarioEmpleado.RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.RCNid#">
				and SalarioEmpleado.SEcalculado = 0
		</cfquery>

		<!--- Renta:  Calcular Salario Acumulado para Renta --->
		<!--- 1. Calcular el monto de pago de salario (por fechas trabajadas) que se toman en cuenta para la renta --->
		<!---ljimenez si usa calculo de renta retroactivo al acumulado de salarios solo sumamos lo correcpondiente al periodo
		actual ya que los ingresos por retroactivos los manejamos aparte--->
		<cfif #vUsaRetro# EQ 1>
			<cfquery datasource="#arguments.conexion#">
				update SalarioEmpleado
				set SEacumulado = coalesce((select sum(p.PEmontores) 
												from PagosEmpleado p, RHTipoAccion t
												where p.RCNid = SalarioEmpleado.RCNid 
													and p.DEid = SalarioEmpleado.DEid 
													and t.RHTid = p.RHTid
													and t.RHTnorenta = 0 
                                                    and p.CPperiodo = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.per#">
													and p.CPmes = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.mes#">), 0.00)
				where RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.RCNid#">
				  and SEcalculado = 0
			</cfquery>
			
			<cfquery datasource="#arguments.conexion#">
				update SalarioEmpleado
				set SEacumulado = SEacumulado + coalesce((	select sum(p.PEmontores)  
															from HPagosEmpleado p, CalendarioPagos cp, RHTipoAccion t
															where p.DEid = SalarioEmpleado.DEid
																and cp.CPid = p.RCNid
																and cp.CPperiodo = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.per#">
																and cp.CPmes = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.mes#">
																and cp.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.Ecodigo#">
																and t.RHTid = p.RHTid
																and t.RHTnorenta = 0
																and p.PEtiporeg = 0
														 ), 0.00)
				where RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.RCNid#">
					and SEcalculado = 0
			</cfquery>
		<cfelse>

			<cfquery datasource="#arguments.conexion#">
				update SalarioEmpleado
				set SEacumulado = coalesce((select sum(p.PEmontores) 
												from PagosEmpleado p, RHTipoAccion t
												where p.RCNid = SalarioEmpleado.RCNid 
													and p.DEid = SalarioEmpleado.DEid 
													and t.RHTid = p.RHTid
													and t.RHTnorenta = 0 ), 0.00)
				where RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.RCNid#">
				  and SEcalculado = 0
			</cfquery>	
	
			<cfquery datasource="#arguments.conexion#">
				update SalarioEmpleado
				set SEacumulado = SEacumulado + coalesce((	select sum(p.PEmontores)  
															from HPagosEmpleado p, CalendarioPagos cp, RHTipoAccion t
															where p.DEid = SalarioEmpleado.DEid
																and cp.CPid = p.RCNid
																and cp.CPperiodo = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.per#">
																and cp.CPmes = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.mes#">
																and cp.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.Ecodigo#">
																and t.RHTid = p.RHTid
																and t.RHTnorenta = 0
														 ), 0.00)
				where RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.RCNid#">
					and SEcalculado = 0
			</cfquery>
		</cfif>
		

		<!--- 2. Aplicar el factor por los dias trabajados de acuerdo ---> 
		<!---	 con el factor de dias de calculo de salario mensual ---> 
		<!---	 salario = (acumulado de pagos * Cantidad de dias mensual / (cantidad de dias en Periodo * Numero de Periodos)) --->
		
		<cfquery datasource="#arguments.conexion#">
			update SalarioEmpleado
			set SEproyectado = SEacumulado * <cfqueryparam cfsqltype="cf_sql_float" value="#arguments.CantDiasMensual#"> / (<cfqueryparam cfsqltype="cf_sql_float" value="#arguments.cantdias#"> * <cfqueryparam cfsqltype="cf_sql_float" value="#arguments.CantPagosRealizados#">)
			where RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.RCNid#">
				and SEcalculado = 0
		</cfquery>
	
		<!--- 3. Sumar al Salario Acumulado las Incidencias que apliquen para renta que se hayan aplicado en el mes --->
		<!---	 Sumar al Salario Acumulado las Incidencias que apliquen para renta que se esten calculando en esta nomina --->
		<!---	 A esta suma de incidencias debe de aplicarsele el factor de proyeccion de pagos en el mes --->
		<cfif #vUsaRetro# EQ 1>
			<!---ljimenez suma las incidencias que aplican al mes periodo--->
			<cfquery datasource="#arguments.conexion#">
				update SalarioEmpleado
				set SEacumulado = SEacumulado 
								  + coalesce((	select sum(b.ICmontores)
												from IncidenciasCalculo b, CIncidentes d
												where b.DEid = SalarioEmpleado.DEid 
													and b.RCNid = SalarioEmpleado.RCNid
													and d.CIid = b.CIid
													and d.CInorenta = 0 
													and b.CPperiodo = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.per#">
													and b.CPmes 	= <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.mes#">
											), 0.00)
								  +	coalesce((	select sum(h.ICmontores)
												from CalendarioPagos cp, HIncidenciasCalculo h, CIncidentes d
												where cp.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.Ecodigo#">
													and cp.CPperiodo = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.per#">
													and cp.CPmes = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.mes#">
													and h.CPperiodo = cp.CPperiodo
													and h.CPmes 	= cp.CPmes
													and h.DEid = SalarioEmpleado.DEid
													and h.RCNid = cp.CPid
													and d.CIid = h.CIid
													and d.CInorenta = 0 
											), 0.00),
	
					SEproyectado = SEproyectado 
								   + ((coalesce(( 	select sum(b.ICmontores)
													from IncidenciasCalculo b, CIncidentes d
													where b.DEid = SalarioEmpleado.DEid 
														and b.RCNid = SalarioEmpleado.RCNid
														and d.CIid = b.CIid
														and d.CInorenta = 0
														and b.CPperiodo = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.per#">
														and b.CPmes 	= <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.mes#">
														<cfif arguments.Factor neq 1>
															and d.CInopryrenta = 0
														</cfif>
												 ), 0.00)
								   + coalesce((	select sum(h.ICmontores)
												from CalendarioPagos cp, HIncidenciasCalculo h, CIncidentes d
												where cp.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.Ecodigo#">
													and cp.CPperiodo = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.per#">
													and cp.CPmes = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.mes#">
													and h.CPperiodo = cp.CPperiodo
													and h.CPmes 	= cp.CPmes
													and h.DEid = SalarioEmpleado.DEid
													and h.RCNid = cp.CPid
													and d.CIid = h.CIid
													and d.CInorenta = 0
													<cfif arguments.Factor neq 1>
														and d.CInopryrenta = 0
													</cfif>
												), 0.00))
												* <cfqueryparam cfsqltype="cf_sql_decimal" scale="4" value="#arguments.Factor#">)
												<cfif arguments.Factor neq 1>
													+ (coalesce((	select sum(b.ICmontores)
																	from IncidenciasCalculo b, CIncidentes d
																	where b.DEid = SalarioEmpleado.DEid 
																		and b.RCNid = SalarioEmpleado.RCNid
																		and d.CIid = b.CIid
																		and d.CInorenta = 0
																		and d.CInopryrenta = 1
																		and b.CPperiodo = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.per#">
																		and b.CPmes 	= <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.mes#">
																), 0.00)
													+ coalesce((	select sum(h.ICmontores)
																	from CalendarioPagos cp, HIncidenciasCalculo h, CIncidentes d
																	where cp.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.Ecodigo#">
																		and cp.CPperiodo = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.per#">
																		and cp.CPmes = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.mes#">
																		and h.CPperiodo = cp.CPperiodo
																		and h.CPmes 	= cp.CPmes
																		and h.DEid = SalarioEmpleado.DEid
																		and h.RCNid = cp.CPid
																		and d.CIid = h.CIid
																		and d.CInorenta = 0
																		and d.CInopryrenta = 1), 0.00))
												</cfif>
				where SalarioEmpleado.RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.RCNid#">
					and SalarioEmpleado.SEcalculado = 0
			</cfquery>	
		<cfelse> 
	
		
			<cfquery datasource="#arguments.conexion#">
				update SalarioEmpleado
				set SEacumulado = SEacumulado 
								  + coalesce((	select sum(b.ICmontores)
												from IncidenciasCalculo b, CIncidentes d
												where b.DEid = SalarioEmpleado.DEid 
													and b.RCNid = SalarioEmpleado.RCNid
													and d.CIid = b.CIid
													and d.CInorenta = 0 ), 0.00)
								  +	coalesce((	select sum(h.ICmontores)
												from CalendarioPagos cp, HIncidenciasCalculo h, CIncidentes d
												where cp.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.Ecodigo#">
													and cp.CPperiodo = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.per#">
													and cp.CPmes = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.mes#">
													and h.DEid = SalarioEmpleado.DEid
													and h.RCNid = cp.CPid
													and d.CIid = h.CIid
													and d.CInorenta = 0 ), 0.00),
	
					SEproyectado = SEproyectado 
								   + ((coalesce(( 	select sum(b.ICmontores)
													from IncidenciasCalculo b, CIncidentes d
													where b.DEid = SalarioEmpleado.DEid 
														and b.RCNid = SalarioEmpleado.RCNid
														and d.CIid = b.CIid
														and d.CInorenta = 0
														<cfif arguments.Factor neq 1>
															and d.CInopryrenta = 0
														</cfif>
												 ), 0.00)
								   + coalesce((	select sum(h.ICmontores)
												from CalendarioPagos cp, HIncidenciasCalculo h, CIncidentes d
												where cp.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.Ecodigo#">
													and cp.CPperiodo = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.per#">
													and cp.CPmes = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.mes#">
													and h.DEid = SalarioEmpleado.DEid
													and h.RCNid = cp.CPid
													and d.CIid = h.CIid
													and d.CInorenta = 0
													<cfif arguments.Factor neq 1>
														and d.CInopryrenta = 0
													</cfif>
												), 0.00))
												* <cfqueryparam cfsqltype="cf_sql_decimal" scale="4" value="#arguments.Factor#">)
												<cfif arguments.Factor neq 1>
													+ (coalesce((	select sum(b.ICmontores)
																	from IncidenciasCalculo b, CIncidentes d
																	where b.DEid = SalarioEmpleado.DEid 
																		and b.RCNid = SalarioEmpleado.RCNid
																		and d.CIid = b.CIid
																		and d.CInorenta = 0
																		and d.CInopryrenta = 1), 0.00)
													+ coalesce((	select sum(h.ICmontores)
																	from CalendarioPagos cp, HIncidenciasCalculo h, CIncidentes d
																	where cp.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.Ecodigo#">
																		and cp.CPperiodo = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.per#">
																		and cp.CPmes = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.mes#">
																		and h.DEid = SalarioEmpleado.DEid
																		and h.RCNid = cp.CPid
																		and d.CIid = h.CIid
																		and d.CInorenta = 0
																		and d.CInopryrenta = 1), 0.00))
												</cfif>
				where SalarioEmpleado.RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.RCNid#">
					and SalarioEmpleado.SEcalculado = 0
			</cfquery>
		</cfif>
		

		
		<!--- 4. Al acumulado, restar el monto de las cargas deducibles de renta por el factor --->
		<cfquery datasource="#arguments.conexion#">
			update SalarioEmpleado
			set SEproyectado = SEproyectado - (SEinorenta * <cfqueryparam cfsqltype="cf_sql_float" value="#arguments.Factor#">),
				SEacumulado = SEacumulado - SEinorenta
			where SalarioEmpleado.RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.RCNid#">
				and SalarioEmpleado.SEcalculado = 0
		</cfquery>
			
		<!--- 4.1 Obtener el factor de meses (Cantidad de meses) a tomar en cuenta para la tabla de renta, para poder aplicar ese factor al monto. --->
		<!---	  La tabla de Impuesto de Renta tiene una columna con el factor de meses (default 1, para una renta mensual) --->
		<!---	  (para poder incorporar Renta Anual) --->
		<!---	  modificado por: marcelm --->
		<!---	  fecha: 08/Nov/2006 --->

		<cfset LvarCreditoFiscalAntes = 0>
		<cfquery name="rsDatosRenta" datasource="#arguments.conexion#">
			select coalesce(IRfactormeses,1) as IRfactormeses, coalesce(IRCreditoAntes, 0) as IRCreditoAntes
		 	from ImpuestoRenta 
		 	where IRcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.IRcodigo#">
		</cfquery>

		<cfif rsDatosRenta.recordcount GT 0>
			<cfset LvarCreditoFiscalAntes = rsDatosRenta.IRCreditoAntes>
		</cfif>
		
		<!--- JC --->
		<!---INICIO RENTA ANUAL--->	
		<cfif rsDatosRenta.IRfactormeses eq 12>
			<cfquery datasource="#arguments.conexion#">
				update SalarioEmpleado
				set SEproyectado = (select b.SEproyectado
									from SalarioEmpleado a, #EmpleadosRenta# b
									where a.RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.RCNid#">
										and a.SEcalculado = 0
										and a.DEid = b.DEid
										and a.RCNid = SalarioEmpleado.RCNid
										and a.DEid = SalarioEmpleado.DEid)
				where exists(select 1
							from SalarioEmpleado a, #EmpleadosRenta# b
							where a.RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.RCNid#">
								and a.SEcalculado = 0
								and a.DEid = b.DEid
								and a.RCNid = SalarioEmpleado.RCNid
								and a.DEid = SalarioEmpleado.DEid)
			</cfquery>
		<!---FIN RENTA ANUAL--->	
		<cfelse><!---INICIO RENTA MENSUAL--->
			<cfquery datasource="#arguments.conexion#">
				update SalarioEmpleado
				set SEproyectado = SEproyectado * <cfqueryparam cfsqltype="cf_sql_float" value="#rsDatosRenta.IRfactormeses#">
				where exists(select 1
							from SalarioEmpleado a
							where a.RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.RCNid#">
								and a.SEcalculado = 0
								and a.RCNid = SalarioEmpleado.RCNid
								and a.DEid = SalarioEmpleado.DEid)
			</cfquery>
		</cfif> <!---FIN RENTA MENSUAL--->
		
		<cfif LvarCreditoFiscalAntes EQ 1>
			<!--- LZ SE HACE UN ANALISIS DE LAS NOMINAS QUE PASAN POR UN CALENDARIO DE PAGO CON EXONERACIONES ANTES DE PROYECTAR --->
			<cfquery datasource="#arguments.conexion#">
				Insert into #ExcepcionesRenta# (RCNid, DEid, Proyectado)
				Select RCNid, DEid, SEproyectado from SalarioEmpleado Where RCNid= #arguments.RCNid#
			</cfquery>
	
			<cfquery datasource="#arguments.conexion#">
				Update #ExcepcionesRenta# set
						SalarioExo = coalesce((Select Sum(SEsalariobruto+SEincidencias)
										from HSalarioEmpleado hse, 
											 CalendarioPagos cp, 
											 RHExcluirCFiscal ecf
										Where #ExcepcionesRenta#.DEid=hse.DEid
										and cp.CPhasta >= <cfqueryparam cfsqltype="cf_sql_date" value="#FechaTabla#">
										and hse.RCNid = cp.CPid
										and ecf.CPid = cp.CPid),0)
			</cfquery>
			
			<cfquery datasource="#arguments.conexion#">
				Update #ExcepcionesRenta# set
						SalarioExo = SalarioExo + coalesce(
											(Select Sum(SEsalariobruto+SEincidencias)
											from SalarioEmpleado hse, CalendarioPagos cp
											Where #ExcepcionesRenta#.DEid=hse.DEid
											and  hse.RCNid= #arguments.RCNid#
											and cp.CPhasta >= <cfqueryparam cfsqltype="cf_sql_date" value="#FechaTabla#">
											and hse.RCNid = cp.CPid
											and exists (Select 1 
													from  RHExcluirCFiscal ecf
													Where ecf.CPid = cp.CPid)),0)
			</cfquery>
			<cfquery datasource="#arguments.conexion#">
				Update SalarioEmpleado set
						SEproyectado = SEproyectado- coalesce((Select SalarioExo
													  from #ExcepcionesRenta# exo
													  Where SalarioEmpleado.DEid = exo.DEid
													  and SalarioEmpleado.RCNid = exo.RCNid),0)
			</cfquery>
			<!--- FIN LZ --->

			<!--- Rebajar del Proyectado los montos de CREDITO FISCAL PARA FAMILIARES que se aplican antes de pasar por la tabla --->

			<cfquery datasource="#arguments.conexion#">
				update SalarioEmpleado 
				set SEproyectado = SEproyectado 
								   - coalesce(( select sum(case when d.esporcentaje = 0 then d.DCDvalor else (se.SEproyectado * d.DCDvalor / 100) end)
												from FEmpleado a, ConceptoDeduc f, EImpuestoRenta e, DConceptoDeduc d, SalarioEmpleado se
												where a.DEid = SalarioEmpleado.DEid
									  				and se.RCNid = SalarioEmpleado.RCNid
								      				and se.DEid = SalarioEmpleado.DEid
									  				and a.FEdeducrenta > 0
									  				and a.FEdeducdesde <= <cfqueryparam cfsqltype="cf_sql_date" value="#arguments.RChasta#">
									  				and a.FEdeduchasta >= <cfqueryparam cfsqltype="cf_sql_date" value="#arguments.RCdesde#">
									  				and a.FEidconcepto = f.CDid
									  				and e.IRcodigo = f.IRcodigo
									  				and e.EIRestado > 0
									  				and <cfqueryparam cfsqltype="cf_sql_date" value="#arguments.RCdesde#"> between e.EIRdesde and e.EIRhasta
									  				and <cfqueryparam cfsqltype="cf_sql_date" value="#arguments.RChasta#"> between e.EIRdesde and e.EIRhasta
									  				and d.CDid = f.CDid
									  				and d.EIRid = e.EIRid
			<!--- LZ Se Agrega Dfamiliar para identificar que Deducciones son de tipo Familiar--->									  				
									  				and d.Dfamiliar=1), 0.00 )
				where SalarioEmpleado.RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.RCNid#">
					and SalarioEmpleado.SEcalculado < 1
			</cfquery>			  
			
			<!--- Rebajar del Proyectado los montos de CREDITO FISCAL DE LA TABLA que se aplican antes de pasar por la tabla --->
			<cfquery datasource="#arguments.conexion#">
				update SalarioEmpleado 
				set SEproyectado = SEproyectado 
								   - coalesce(( select sum(case when d.esporcentaje = 0 then 
								   								d.DCDvalor else 
								   							(se.SEproyectado * d.DCDvalor / 100) end)
												from ConceptoDeduc f, EImpuestoRenta e, DConceptoDeduc d, SalarioEmpleado se
												where se.RCNid = SalarioEmpleado.RCNid
								          			and se.DEid = SalarioEmpleado.DEid
									  				and e.IRcodigo = f.IRcodigo
									  				and <cfqueryparam cfsqltype="cf_sql_date" value="#arguments.RCdesde#"> between e.EIRdesde and e.EIRhasta
									  				and <cfqueryparam cfsqltype="cf_sql_date" value="#arguments.RChasta#"> between e.EIRdesde and e.EIRhasta
									  				and e.IRcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.IRcodigo #">
									  				and e.EIRestado > 0
									  				and d.CDid = f.CDid
									  				and d.EIRid = e.EIRid
			<!--- LZ Se Agrega Dfamiliar para identificar que Deducciones No son de tipo Familiar--->									  													  				
									  				and d.Dfamiliar=0), 0.00)
				where SalarioEmpleado.RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.RCNid#">
					and SalarioEmpleado.SEcalculado < 1
			</cfquery>

			<!--- LZ Vuelve a incrementar la parte Exonerada posterior a la ejecucion de los Creditos Fiscales --->
			<cfquery datasource="#arguments.conexion#">
				Update SalarioEmpleado set
						SEproyectado = SEproyectado + coalesce((Select SalarioExo
													  from #ExcepcionesRenta# exo
													  Where SalarioEmpleado.DEid = exo.DEid
													  and SalarioEmpleado.RCNid = exo.RCNid),0)
			</cfquery>
			<!--- FIN LZ  --->
		</cfif>
		
		<!--- 4.2 SALARIOS OTROS PATRONOS---> 
		<!---	 Cuando el empleado tiene varios patronos, la base mensual del patrono origen se le suma al patrono actual---> 
		<!---	 Por ejemplo FUNDATEC debe conocer la base salarial de sus empleados en el TEC --->
		<cfquery datasource="#arguments.conexion#">
			update SalarioEmpleado
			set SEproyectado = SEproyectado + SEotrossalarios
			where RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.RCNid#">
				and SEcalculado = 0
		</cfquery>		
		
		<!--- 4.2.1 CALCULAR RENTA AL SALARIO DE OTROS PATRONOS PARA RESTARSELA A LA RENTA REAL --->
		<cfquery name="rsdag" datasource="#arguments.conexion#">
			update SalarioEmpleado 
				set SErentaotrossalarios  = coalesce((select round(((SalarioEmpleado.SEotrossalarios - a.DIRinf ) * (a.DIRporcentaje / 100)) + a.DIRmontofijo,2)  
											from EImpuestoRenta b, DImpuestoRenta a
											where b.IRcodigo = '#arguments.IRcodigo#'
												and b.EIRestado > 0
												and a.EIRid = b.EIRid
												and <cfqueryparam cfsqltype="cf_sql_date" value="#arguments.RChasta#"> between EIRdesde and EIRhasta
												and round(SalarioEmpleado.SEotrossalarios,2) >= round(a.DIRinf,2)
												and round(SalarioEmpleado.SEotrossalarios,2) <= round(a.DIRsup,2)), 0.00)
				where SalarioEmpleado.RCNid = #arguments.RCNid#
					and SalarioEmpleado.SEcalculado = 0
		</cfquery>
		
		<!--- 5.1 Calculo del Impuesto sobre la Renta al salario. --->
		<!--- Se utiliza la tabla de renta definida en la empresa, de acuerdo con el rango de fechas --->
		<cfquery name="rsdag" datasource="#arguments.conexion#">
			update SalarioEmpleado 
				set SErenta = coalesce((select round(((SalarioEmpleado.SEproyectado - a.DIRinf ) * (a.DIRporcentaje / 100)) + a.DIRmontofijo,2)  
											from EImpuestoRenta b, DImpuestoRenta a
											where b.IRcodigo = '#arguments.IRcodigo#'
												and b.EIRestado > 0
												and a.EIRid = b.EIRid
												and <cfqueryparam cfsqltype="cf_sql_date" value="#arguments.RChasta#"> between EIRdesde and EIRhasta
												and round(SalarioEmpleado.SEproyectado,2) >= round(a.DIRinf,2)
												and round(SalarioEmpleado.SEproyectado,2) <= round(a.DIRsup,2)), 0.00)
				where SalarioEmpleado.RCNid = #arguments.RCNid#
					and SalarioEmpleado.SEcalculado = 0
		</cfquery>
		
		<!--- se Resta a la renta bruta (sin rebajo de créditos fiscales) el monto de renta potencialmente retenido en otras empresas--->
		<cfquery datasource="#arguments.conexion#"> 
		Update SalarioEmpleado
		set SErenta=SErenta - SErentaotrossalarios
		where SalarioEmpleado.RCNid = #arguments.RCNid#
					and SalarioEmpleado.SEcalculado = 0
		</cfquery>
		
		
		<!---ljimenez Calculo de Renta Parte Retroactiva--->
        
        <cfset vDebugRetro = 'false'>
        
		<cfif #vUsaRetro# EQ 1>

			<!---ljimenez crea tabla temporar para control de retroactivos--->
			<cf_dbtemp name="CRetroactivos" returnvariable="CRetroactivos" datasource="#arguments.conexion#">
				<cf_dbtempcol name="RCNid" 			type="numeric" 	mandatory="yes">  
				<cf_dbtempcol name="DEid" 			type="numeric" 	mandatory="yes">
				<cf_dbtempcol name="CPmes" 			type="int" 		mandatory="no">
				<cf_dbtempcol name="CPperiodo" 		type="int" 		mandatory="no">
                <cf_dbtempcol name="SalarioRetro"	type="money" 	mandatory="no">
                <cf_dbtempcol name="IncidenciasRetro" type="money" 	mandatory="no">
				<cf_dbtempcol name="SalarioAjustar"	type="money" 	mandatory="no">
				<cf_dbtempcol name="SalarioActual"	type="money" 	mandatory="no">
				<cf_dbtempcol name="Incidencias"	type="money" 	mandatory="no">
				<cf_dbtempcol name="SalarioTotal"	type="money" 	mandatory="no">
				<cf_dbtempcol name="OtrosSalarios"	type="money" 	mandatory="no"> <!--- Base Otros Salarios --->				
				<cf_dbtempcol name="SalarioTotalR"	type="money" 	mandatory="no"> <!--- Base Otros Salarios para Retroactivos--->
				<cf_dbtempcol name="OtrosSalariosR"	type="money" 	mandatory="no">								
				<cf_dbtempcol name="AjusteRetro"	type="money" 	mandatory="no">
				<cf_dbtempcol name="Renta"			type="money" 	mandatory="no">
				<cf_dbtempcol name="RentaRetro"		type="money" 	mandatory="no">  
				<cf_dbtempcol name="RentaAjuste"	type="money" 	mandatory="no"> 
				<cf_dbtempcol name="RentaOtrosSalarios"	type="money" 	mandatory="no">	<!--- Renta Calculada  Otros Salarios Base Actual--->				
				<cf_dbtempcol name="RentaOtrosSalariosRetro"	type="money" 	mandatory="no">	 <!--- Renta Calculada  Otros Salarios Base Retroactiva--->				
                <cf_dbtempcol name="Creditos"		type="money" 	mandatory="no">
                <cf_dbtempcol name="Cargas"			type="money" 	mandatory="no">
				<cf_dbtempcol name="cortedesde" 	type="datetime" mandatory="no">
                <cf_dbtempcol name="cortehasta" 	type="datetime" mandatory="no">
			</cf_dbtemp>
            	
			<!---inserta en la temporal lo correspondiente a los pagos por retroactivos registrados para la nomina en proceso--->
			<cfquery name="rsDatosRetro" datasource="#arguments.conexion#">
				insert into #CRetroactivos# (RCNid,DEid,CPmes,CPperiodo,SalarioActual)
					select RCNid,DEid,CPmes,CPperiodo,abs(sum(PEmontores))
					from PagosEmpleado a
					where RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.RCNid#">
						and PEtiporeg = 2
                        and CPperiodo+CPmes  <> <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.PER#">+<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.MES#">
                        <cfif isdefined('arguments.DEid')>
                        	and a.DEid = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.DEid#">
                        </cfif>
					group by RCNid,DEid,CPmes,CPperiodo
			</cfquery>
        
            
			<!---se lee la infomacion correspondiente a la fecha maxima del periodo mes del retroactivo para utilizar en la tabla de renta--->
			<cfquery name="rsDatosRetro" datasource="#arguments.conexion#">
				update #CRetroactivos# set cortehasta = 
					(select max(CPhasta)
					from CalendarioPagos
					where CPmes = #CRetroactivos#.CPmes
						and CPperiodo = #CRetroactivos#.CPperiodo
						and CPfcalculo <> ''
						and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.Ecodigo#"> )
			</cfquery>
			<cfquery name="rsDatosRetro" datasource="#arguments.conexion#">
				update #CRetroactivos# 
                set cortedesde = 
					(select min(PEdesde)
					from PagosEmpleado 
					where RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.RCNid#">
				      and PEtiporeg = 2
                      and CPmes = #CRetroactivos#.CPmes
                      and CPperiodo = #CRetroactivos#.CPperiodo
                      and DEid = #CRetroactivos#.DEid
					group by RCNid,DEid,CPmes,CPperiodo)
			</cfquery>
            <cfquery name="rsDatosRetro" datasource="#arguments.conexion#">
				update #CRetroactivos# 
                set SalarioRetro = coalesce((select sum(PEmontores) 
                							  from PagosEmpleado 
                                              where RCNid = #CRetroactivos#.RCNid 
                                              and DEid = #CRetroactivos#.DEid
                                              and PEtiporeg = 1
                                              and CPmes = #CRetroactivos#.CPmes
                                              and CPperiodo = #CRetroactivos#.CPperiodo
                                              group by CPmes,CPperiodo),0)
            </cfquery>
			<cfquery name="rsDatosRetro" datasource="#arguments.conexion#">
				update #CRetroactivos# set Incidencias =
						coalesce((	select abs(sum(b.ICmontores))
								from IncidenciasCalculo b, CIncidentes d
								where b.DEid = #CRetroactivos#.DEid 
									and b.RCNid = #CRetroactivos#.RCNid
									and d.CIid = b.CIid
									and d.CInorenta = 0 
									and b.CPperiodo = #CRetroactivos#.CPperiodo
									and b.CPmes 	= #CRetroactivos#.CPmes
                                    and b.ICvalor < 0 <!--- OJO revisar   ljimenez   --->
							), 0.00)
					-	coalesce(				
							(select sum(hs.SEinorenta)
								from HSalarioEmpleado hs
								where hs.RCNid  in (
													select CPid
													from CalendarioPagos
													where CPmes = #CRetroactivos#.CPmes
														and CPperiodo = #CRetroactivos#.CPperiodo
														and CPfcalculo <> ''
														and hs.DEid = #CRetroactivos#.DEid
														and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.Ecodigo#">)
							group by DEid),0)
							
				where #CRetroactivos#.DEid = DEid
			</cfquery>
			<cfquery name="rsDatosRetro" datasource="#arguments.conexion#">
				update #CRetroactivos# set IncidenciasRetro  =
						coalesce((	select abs(sum(b.ICmontores))
								from IncidenciasCalculo b, CIncidentes d
								where b.DEid = #CRetroactivos#.DEid 
									and b.RCNid = #CRetroactivos#.RCNid
									and d.CIid = b.CIid
									and d.CInorenta = 0 
									and b.CPperiodo = #CRetroactivos#.CPperiodo
									and b.CPmes 	= #CRetroactivos#.CPmes
                                    and b.ICvalor > 0 <!--- OJO, revisar ljimenez--->
                                    and b.ICfecha < <cfqueryparam cfsqltype="cf_sql_date" value="#arguments.RCdesde#">
							), 0.00)
					-	coalesce(				
							(select sum(hs.SEinorenta)
								from HSalarioEmpleado hs
								where hs.RCNid  in (
													select CPid
													from CalendarioPagos
													where CPmes = #CRetroactivos#.CPmes
														and CPperiodo = #CRetroactivos#.CPperiodo
														and CPfcalculo <> ''
														and hs.DEid = #CRetroactivos#.DEid
														and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.Ecodigo#">)
							group by DEid),0)
							
				where #CRetroactivos#.DEid = DEid
			</cfquery>
            <cfquery datasource="#session.DSN#">
            	update #CRetroactivos# 
                set SalarioTotal = SalarioActual + Incidencias,
                	 SalarioTotalR = SalarioRetro + IncidenciasRetro,
					 OtrosSalarios = (Select SEotrossalarios
																 from SalarioEmpleado se
																 Where se.DEid=#CRetroactivos#.DEid
																 and se.RCNid=#CRetroactivos#.RCNid),
					 OtrosSalariosR = (Select SEotrossalarios
																 from SalarioEmpleado se
																 Where se.DEid=#CRetroactivos#.DEid
																 and se.RCNid=#CRetroactivos#.RCNid)
            </cfquery>

			<cfquery name="rsDatosRetro" datasource="#arguments.conexion#">
				update #CRetroactivos# 
                set Cargas = coalesce((select sum(cc.CCvaloremp)
														from HCargasCalculo cc, CalendarioPagos cp, DCargas dc
														where cc.DEid = #CRetroactivos# .DEid
															and cp.CPid = cc.RCNid
															and cp.CPperiodo = #CRetroactivos#.CPperiodo
															and cp.CPmes = #CRetroactivos#.CPmes
															and cp.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.Ecodigo#">
															and cp.CPnorenta = 0
															and dc.DClinea = cc.DClinea
															and dc.DCnorenta > 0
                                                            and #CRetroactivos#.cortedesde >= cp.CPdesde),0)
            </cfquery>
			
			
            <cfquery name="rsdag" datasource="#arguments.conexion#">
				update #CRetroactivos#  
					set SalarioTotal = SalarioTotal - Cargas,
                    	SalarioTotalR = SalarioTotalR - Cargas
            </cfquery>      
			
			<!--- 4.2 SALARIOS OTROS PATRONOS---> 
			<!---	 Cuando el empleado tiene varios patronos, la base mensual del patrono origen se le suma al patrono actual---> 
			<!---	 Por ejemplo FUNDATEC debe conocer la base salarial de sus empleados en el TEC --->
			<cfquery datasource="#arguments.conexion#">
				update #CRetroactivos#
				set SalarioTotal = SalarioTotal + OtrosSalarios,
					SalarioTotalR = SalarioTotalR +  OtrosSalariosR
			</cfquery>			

		<!--- CALCULAR RENTA AL SALARIO DE OTROS PATRONOS PARA RESTARSELA A LA RENTA REAL tanto para el ordinario como para los retroactivos--->
			<cfquery name="rsdag" datasource="#arguments.conexion#">
				update #CRetroactivos#
					set RentaOtrosSalarios  = coalesce((select round(((#CRetroactivos#.OtrosSalarios - a.DIRinf ) * (a.DIRporcentaje / 100)) + a.DIRmontofijo,2)  
												from EImpuestoRenta b, DImpuestoRenta a
												where b.IRcodigo = '#arguments.IRcodigo#'
													and b.EIRestado > 0
													and a.EIRid = b.EIRid
													and <cfqueryparam cfsqltype="cf_sql_date" value="#arguments.RChasta#"> between EIRdesde and EIRhasta
													and round(#CRetroactivos#.OtrosSalarios,2) >= round(a.DIRinf,2)
													and round(#CRetroactivos#.OtrosSalarios,2) <= round(a.DIRsup,2)), 0.00),
					RentaOtrosSalariosRetro  = coalesce((select round(((#CRetroactivos#.OtrosSalariosR - a.DIRinf ) * (a.DIRporcentaje / 100)) + a.DIRmontofijo,2)  
												from EImpuestoRenta b, DImpuestoRenta a
												where b.IRcodigo = '#arguments.IRcodigo#'
													and b.EIRestado > 0
													and a.EIRid = b.EIRid
													and <cfqueryparam cfsqltype="cf_sql_date" value="#arguments.RChasta#"> between EIRdesde and EIRhasta
													and round(#CRetroactivos#.OtrosSalariosR,2) >= round(a.DIRinf,2)
													and round(#CRetroactivos#.OtrosSalariosR,2) <= round(a.DIRsup,2)), 0.00)
			</cfquery>
				<cfif LvarCreditoFiscalAntes  EQ 1>
					<!--- Se eliminan los créditos fiscales --->
					<cfquery name="rsdag" datasource="#arguments.conexion#">
						update #CRetroactivos#  
							set SalarioTotal = #CRetroactivos#.SalarioTotal 
												 - coalesce(( select sum(d.DCDvalor)
																from FEmpleado a
																inner join ConceptoDeduc f
																	on f.CDid = a.FEidconcepto
																inner join  DConceptoDeduc d
																	on d.CDid = f.CDid  
																inner join EImpuestoRenta e
																	on e.EIRid = d.EIRid
																	and e.IRcodigo = f.IRcodigo
																where DEid = #CRetroactivos#.DEid   
																  and a.FEdeducrenta > 0
																  and d.Dfamiliar = 1
																  and e.EIRestado > 0
																  and #CRetroactivos#.cortehasta between EIRdesde and EIRhasta
																  and #CRetroactivos#.cortehasta between a.FEdeducdesde and a.FEdeduchasta), 0.00 )
																  
							 , SalarioTotalR = #CRetroactivos#.SalarioTotalR
												 - coalesce(( select sum(d.DCDvalor)
																from FEmpleado a
																inner join ConceptoDeduc f
																	on f.CDid = a.FEidconcepto
																inner join  DConceptoDeduc d
																	on d.CDid = f.CDid  
																inner join EImpuestoRenta e
																	on e.EIRid = d.EIRid
																	and e.IRcodigo = f.IRcodigo
																where DEid = #CRetroactivos#.DEid   
																  and a.FEdeducrenta > 0
																  and d.Dfamiliar = 1
																  and e.EIRestado > 0
																  and #CRetroactivos#.cortehasta between EIRdesde and EIRhasta
																  and #CRetroactivos#.cortehasta between a.FEdeducdesde and a.FEdeduchasta), 0.00 )                                                              
						where #CRetroactivos#.RCNid = #arguments.RCNid#
					</cfquery>
				 </cfif>          
			<!---calculo de la renta parte retroactiva --->
			<cfquery name="rsdag" datasource="#arguments.conexion#">
				update #CRetroactivos#  
					set Renta = coalesce((select round(((#CRetroactivos#.SalarioTotal - a.DIRinf ) * (a.DIRporcentaje / 100)) + a.DIRmontofijo,2)  
												from EImpuestoRenta b, DImpuestoRenta a
												where b.IRcodigo = '#arguments.IRcodigo#'
													and b.EIRestado > 0
													and a.EIRid = b.EIRid
													and #CRetroactivos#.cortehasta between EIRdesde and EIRhasta
													and round((#CRetroactivos#.SalarioTotal),2) >= round(a.DIRinf,2)
													and round((#CRetroactivos#.SalarioTotal),2) <= round(a.DIRsup,2)), 0.00), 
					RentaRetro = coalesce((select round(((#CRetroactivos#.SalarioTotalR - a.DIRinf ) * (a.DIRporcentaje / 100)) + a.DIRmontofijo,2)  
												from EImpuestoRenta b, DImpuestoRenta a
												where b.IRcodigo = '#arguments.IRcodigo#'
													and b.EIRestado > 0
													and a.EIRid = b.EIRid
													and #CRetroactivos#.cortehasta between EIRdesde and EIRhasta
													and round((#CRetroactivos#.SalarioTotalR),2) >= round(a.DIRinf,2)
													and round((#CRetroactivos#.SalarioTotalR),2) <= round(a.DIRsup,2)), 0.00) 
				where #CRetroactivos#.RCNid = #arguments.RCNid#
			</cfquery>
             <cfif LvarCreditoFiscalAntes EQ 0>
                <cfquery name="rsdag" datasource="#arguments.conexion#">
                    update #CRetroactivos#  
                        set SalarioTotal = #CRetroactivos#.SalarioTotal 
                                             - coalesce(( select sum(d.DCDvalor)
                                                            from FEmpleado a
                                                            inner join ConceptoDeduc f
                                                                on f.CDid = a.FEidconcepto
                                                            inner join  DConceptoDeduc d
                                                                on d.CDid = f.CDid  
                                                            inner join EImpuestoRenta e
                                                                on e.EIRid = d.EIRid
                                                                and e.IRcodigo = f.IRcodigo
                                                            where DEid = #CRetroactivos#.DEid   
                                                              and a.FEdeducrenta > 0
                                                              and d.Dfamiliar = 1
                                                              and e.EIRestado > 0
                                                              and #CRetroactivos#.cortehasta between EIRdesde and EIRhasta
                                                              and #CRetroactivos#.cortehasta between a.FEdeducdesde and a.FEdeduchasta), 0.00 )
                                                              
                                                              
                                            - coalesce(( select sum(d.DCDvalor)
                                                            from FEmpleado a
                                                            inner join ConceptoDeduc f
                                                                on f.CDid = a.FEidconcepto
                                                            inner join  DConceptoDeduc d
                                                                on d.CDid = f.CDid  
                                                            inner join EImpuestoRenta e
                                                                on e.EIRid = d.EIRid
                                                                and e.IRcodigo = f.IRcodigo
                                                            where DEid = #CRetroactivos#.DEid   
                                                              and a.FEestudia > 0
                                                              and a.FEdeduchasta <= a.FEfiniestudio
                                                              and d.Dfamiliar = 1
                                                              and e.EIRestado > 0
                                                              and #CRetroactivos#.cortehasta between EIRdesde and EIRhasta
                                                              and #CRetroactivos#.cortehasta between a.FEfiniestudio and a.FEffinestudio), 0.00 )
                                                                            
						 , SalarioTotalR = #CRetroactivos#.SalarioTotalR
                                             - coalesce(( select sum(d.DCDvalor)
                                                            from FEmpleado a
                                                            inner join ConceptoDeduc f
                                                                on f.CDid = a.FEidconcepto
                                                            inner join  DConceptoDeduc d
                                                                on d.CDid = f.CDid  
                                                            inner join EImpuestoRenta e
                                                                on e.EIRid = d.EIRid
                                                                and e.IRcodigo = f.IRcodigo
                                                            where DEid = #CRetroactivos#.DEid   
                                                              and a.FEdeducrenta > 0
                                                              and d.Dfamiliar = 1
                                                              and e.EIRestado > 0
                                                              and #CRetroactivos#.cortehasta between EIRdesde and EIRhasta
                                                              and #CRetroactivos#.cortehasta between a.FEdeducdesde and a.FEdeduchasta), 0.00 )
                                            
                                            - coalesce(( select sum(d.DCDvalor)
                                                            from FEmpleado a
                                                            inner join ConceptoDeduc f
                                                                on f.CDid = a.FEidconcepto
                                                            inner join  DConceptoDeduc d
                                                                on d.CDid = f.CDid  
                                                            inner join EImpuestoRenta e
                                                                on e.EIRid = d.EIRid
                                                                and e.IRcodigo = f.IRcodigo
                                                            where DEid = #CRetroactivos#.DEid   
                                                              and a.FEestudia > 0
                                                              and a.FEdeduchasta <= a.FEfiniestudio
                                                              and d.Dfamiliar = 1
                                                              and e.EIRestado > 0
                                                              and #CRetroactivos#.cortehasta between EIRdesde and EIRhasta
                                                              and #CRetroactivos#.cortehasta between a.FEfiniestudio and a.FEffinestudio), 0.00 )                  
                    where #CRetroactivos#.RCNid = #arguments.RCNid#
                </cfquery>
			</cfif>

			<!---  eliminar la Renta OTROS PATRONES a la renta actual y renta Retroactiva antes de calcular el Ajuste--->
	           <cfquery name="rsdag" datasource="#arguments.conexion#">
				update #CRetroactivos#  
					set RentaAjuste = (RentaRetro-RentaOtrosSalariosRetro) - (Renta- RentaOtrosSalarios)
            </cfquery>
        
            <cfif vDebugRetro>
                <strong>CRetroactivos</strong>
                <cfquery name="rsCRetroactivos" datasource="#arguments.conexion#"> 
                	select * from #CRetroactivos#
                </cfquery>
                <cf_dump var="#rsCRetroactivos#">
                
            </cfif>
		</cfif>
		<!---ljimenez Fin de calculo de Renta Retroactivo--->


		<!--- 5.1.a El credito fiscal posterior al monto de renta se rebaja del total calculado, cuando el credito se aplica al monto de la renta --->
        
		<cfif LvarCreditoFiscalAntes LT 1>
			<!--- Monto a Deducir del Impuesto de la Renta si hay conceptos de Deduccion asociados (conyuge o dependientes) CREDITO FISCAL --->
			<cfquery datasource="#arguments.conexion#">
				update SalarioEmpleado 
				set SErenta = SErenta - coalesce((	select sum(case when d.esporcentaje = 0 then d.DCDvalor else (se.SEproyectado * d.DCDvalor / 100) end)
													from FEmpleado a, ConceptoDeduc f, EImpuestoRenta e, DConceptoDeduc d, SalarioEmpleado se
													where a.DEid = SalarioEmpleado.DEid
								 					  and se.RCNid = SalarioEmpleado.RCNid
												      and se.DEid = SalarioEmpleado.DEid
													  and a.FEdeducrenta > 0
													  and a.FEdeducdesde <= <cfqueryparam cfsqltype="cf_sql_date" value="#arguments.RChasta#">
													  and a.FEdeduchasta >= <cfqueryparam cfsqltype="cf_sql_date" value="#arguments.RCdesde#">
													  and a.FEidconcepto = f.CDid
													  and e.IRcodigo = f.IRcodigo
													  and e.EIRestado > 0
													  and <cfqueryparam cfsqltype="cf_sql_date" value="#arguments.RCdesde#"> between e.EIRdesde and e.EIRhasta
													  and <cfqueryparam cfsqltype="cf_sql_date" value="#arguments.RChasta#"> between e.EIRdesde and e.EIRhasta
													  and d.CDid = f.CDid
													  and d.EIRid = e.EIRid), 0.00 )
				where SalarioEmpleado.RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.RCNid#">
					and SalarioEmpleado.SEcalculado < 1
			</cfquery>
           
		
            <!--- Monto a Deducir del Impuesto de la Renta si hay conceptos de Deduccion asociados (conyuge o dependientes ESTUDIA) CREDITO FISCAL --->
            
            <cfquery datasource="#arguments.conexion#">
				update SalarioEmpleado 
				set SErenta = SErenta - coalesce((	select sum(case when d.esporcentaje = 0 then d.DCDvalor else (se.SEproyectado * d.DCDvalor / 100) end)
													from FEmpleado a, ConceptoDeduc f, EImpuestoRenta e, DConceptoDeduc d, SalarioEmpleado se
													where a.DEid = SalarioEmpleado.DEid
								 					  and se.RCNid = SalarioEmpleado.RCNid
												      and se.DEid = SalarioEmpleado.DEid
													  and a.FEestudia > 0
													  and a.FEfiniestudio <= <cfqueryparam cfsqltype="cf_sql_date" value="#arguments.RChasta#">
													  and a.FEffinestudio >= <cfqueryparam cfsqltype="cf_sql_date" value="#arguments.RCdesde#">
                                                      and a.FEdeduchasta  <= a.FEfiniestudio 
													  and a.FEidconcepto = f.CDid
													  and e.IRcodigo = f.IRcodigo
													  and e.EIRestado > 0
													  and <cfqueryparam cfsqltype="cf_sql_date" value="#arguments.RCdesde#"> between e.EIRdesde and e.EIRhasta
													  and <cfqueryparam cfsqltype="cf_sql_date" value="#arguments.RChasta#"> between e.EIRdesde and e.EIRhasta
													  and d.CDid = f.CDid
													  and d.EIRid = e.EIRid), 0.00 )
				where SalarioEmpleado.RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.RCNid#">
					and SalarioEmpleado.SEcalculado < 1
			</cfquery>
            
        
		</cfif>
		<!--- SI EXISTE UNA DEDUCCIÓN DE RENTA ASIGANDA AL EMPLEADO SE INGRESA--->
		<cfquery datasource="#arguments.conexion#">
			update SalarioEmpleado 
			set SERentaD = (Select Dvalor
							from DeduccionesEmpleado de
								inner join TDeduccion td
								on td.TDid = de.TDid
								and td.TDrenta = 1
							where de.DEid = SalarioEmpleado.DEid
								and de.Dactivo = 1
								and td.TDrenta = 1		
								and <cfqueryparam cfsqltype="cf_sql_date" value="#arguments.RChasta#"> 
								between Dfechaini and Dfechafin)
			  where SalarioEmpleado.RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.RCNid#">
			  and SalarioEmpleado.SEcalculado = 0
			  and exists ( Select 1
							from DeduccionesEmpleado de
								inner join TDeduccion td
								on td.TDid = de.TDid
								and td.TDrenta = 1
							where de.DEid = SalarioEmpleado.DEid
								and de.Dactivo = 1
								and td.TDrenta = 1		
								and <cfqueryparam cfsqltype="cf_sql_date" value="#arguments.RChasta#"> 
								between Dfechaini and Dfechafin)
		</cfquery>
		<!--- JC --->
		<cfif rsDatosRenta.IRfactormeses eq 12>
			<!--- Se resta lo ya cobrado y se divide entre los meses faltantes --->		
			<cfquery name="calculorenta" datasource="#arguments.conexion#">
				update SalarioEmpleado
					set SErenta = coalesce((select ((a.SErenta - b.SERentaT) / #Periodos_Faltantes# ) ------/ #Factor#
									from SalarioEmpleado a, #EmpleadosRenta# b
									where a.RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.RCNid#">
										and a.SEcalculado = 0
										and a.DEid = b.DEid
										and a.RCNid = SalarioEmpleado.RCNid
										and a.DEid = SalarioEmpleado.DEid),0.0)
				where exists(select 1
							from SalarioEmpleado a, #EmpleadosRenta# b
							where a.RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.RCNid#">
								and a.SEcalculado = 0
								and a.DEid = b.DEid
								and a.RCNid = SalarioEmpleado.RCNid
								and a.DEid = SalarioEmpleado.DEid)
			</cfquery>
		<cfelse> <!---calculo de renta mensual--->
				<!--- 5.1.b Ahora se calcula la proporción de renta para atenuar y distribuir el monto de renta en esta nómina si hay conceptos de pago que no se proyecten --->
				<cfif arguments.Factor neq 1>
					<cfquery datasource="#arguments.conexion#">
						update SalarioEmpleado 
						set SErenta = (	SErenta / <cfqueryparam cfsqltype="cf_sql_decimal" scale="4" value="#arguments.Factor#"> * (SEproyectado) 
										 / 		case when coalesce(SEproyectado,0) = 0 
										 		then 1 
												else SEproyectado end )
						where SalarioEmpleado.RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.RCNid#">
							and SalarioEmpleado.SEcalculado = 0
					</cfquery>

				</cfif>
				<cfif #vUsaRetro# EQ 1>
					<!---ljimenez Actualiza el valor de renta a cobrar periodo actual mas la parte correspondiente a lo retroactivo--->
							 <cfquery name="rsdag" datasource="#arguments.conexion#">
								update SalarioEmpleado 
									set SErenta =  SErenta  + coalesce((select sum(RentaAjuste)
															from #CRetroactivos# 
															where SalarioEmpleado.DEid = #CRetroactivos#.DEid
															  and #CRetroactivos#.RentaAjuste > 0
															group by #CRetroactivos#.DEid),0)
								where SalarioEmpleado.RCNid = #arguments.RCNid#
									and SalarioEmpleado.SEcalculado = 0
							</cfquery>
                    		 <!---ljimenez Actualiza el valor de renta a cobrar periodo actual mas la parte correspondiente a lo retroactivo--->
					 <!---<cfquery name="rsdag" datasource="#arguments.conexion#">
						update SalarioEmpleado 
							set SErenta =  SErenta  + coalesce((select sum(RentaRPagar)
													from #IncRetroactiva# 
													where SalarioEmpleado.DEid = #IncRetroactiva#.DEid
                                                      and #IncRetroactiva#.RentaRPagar > 0
													group by #IncRetroactiva#.DEid),0)
						where SalarioEmpleado.RCNid = #arguments.RCNid#
							and SalarioEmpleado.SEcalculado = 0
					</cfquery>--->
                </cfif>
				<!--- 5.2 Se Suma al Calculo del Impuesto sobre la Renta al salario la deducción de tipo renta del empleado (si la tiene). 	--->
				<cfquery name="rsVerificaDed" datasource="#session.DsN#">
						select d.DEidentificacion,count(a.DEid)
						from SalarioEmpleado a
						inner join DeduccionesEmpleado de
							  on de.DEid = a.DEid	
						inner join TDeduccion td
						on td.TDid = de.TDid
						inner join DatosEmpleado d
						on d.DEid = a.DEid
						where RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.RCNid#">
						  and td.TDrenta = 1							
						  and de.Dactivo = 1							
						  and <cfqueryparam cfsqltype="cf_sql_date" value="#arguments.RChasta#">
							  between Dfechaini and Dfechafin
						group by d.DEidentificacion
						having count(a.DEid) > 1
				</cfquery>

				<cfif isdefined('rsVerificaDed') and rsVerificaDed.RecordCount GT 0>
					<cfset Lvar_Lista = ValueList(rsVerificaDed.DEidentificacion)>
					<cfthrow message="Error en Cálculo de Nómina. Los siguientes empleados tienen más de una deducción de Retención de Renta(#Lvar_Lista#). Favor verificar.">
				</cfif>
				<cfquery datasource="#arguments.conexion#">
					update SalarioEmpleado 
					set SERentaD = 
						( 
						coalesce((	select 
										case when 
												coalesce(de.Dvalor,0.00) >
												 (SalarioEmpleado.SEsalariobruto +
												   SalarioEmpleado.SEincidencias -
												   SalarioEmpleado.SEdeducciones -
												   SalarioEmpleado.SEcargasempleado - 
												   SalarioEmpleado.SErenta)   <!--- La Renta por Deduccion es Cobrable? --->
										then (case when (	SalarioEmpleado.SEsalariobruto +
																   SalarioEmpleado.SEincidencias -
																   SalarioEmpleado.SEdeducciones -
																   SalarioEmpleado.SEcargasempleado - 
																   SalarioEmpleado.SErenta) < 0 then 0 
												   else (		   SalarioEmpleado.SEsalariobruto +
																   SalarioEmpleado.SEincidencias -
																   SalarioEmpleado.SEdeducciones -
																   SalarioEmpleado.SEcargasempleado - 
																   SalarioEmpleado.SErenta) 
									               end)
										else coalesce(de.Dvalor,0.00)
										end
									from DeduccionesEmpleado de
										inner join TDeduccion td
										on td.TDid = de.TDid
										
									where de.DEid = SalarioEmpleado.DEid
										and de.Dactivo = 1
										and td.TDrenta = 1		
										and <cfqueryparam cfsqltype="cf_sql_date" value="#arguments.RChasta#"> 
										between Dfechaini and Dfechafin),0.00))
					where SalarioEmpleado.RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.RCNid#">
					  and SalarioEmpleado.SEcalculado = 0
				</cfquery>
				<!---  Si la renta proyectada es negativa, el monto a retener es cero  --->
				<cfquery datasource="#arguments.conexion#">
					update SalarioEmpleado 
					set SErenta = 0.00 
					where SalarioEmpleado.RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.RCNid#">
						and SalarioEmpleado.SEcalculado = 0
						and coalesce(SErenta, 0.00) < 0.00
				</cfquery>		
			</cfif>  
			<!--- JC --->		
				<!--- SI EXISTE UNA DEDUCCIÓN DE RENTA ASIGANDA AL EMPLEADO SE INGRESA --->
			
			<!--- Obtener la renta proyectada entre el factor de proyeccion de renta para calcular la renta a aplicar en esta nomina --->
			<!--- La fórmula de renta ya considera el factor --->
			<cfquery datasource="#arguments.conexion#">
				update SalarioEmpleado 
				set SErenta = round((SErenta),2) 
				where SalarioEmpleado.RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.RCNid#">
					and SalarioEmpleado.SEcalculado = 0
			</cfquery>

			<cfquery datasource="#arguments.conexion#">
				update SalarioEmpleado
				set SERentaT = SErenta
				where RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.RCNid#">
				  and SEcalculado = 0
			</cfquery>

			<!--- JC --->				
			<cfif rsDatosRenta.IRfactormeses NEQ 12>		
				<!--- Restar de la renta proyectada el monto ya retenido al empleado. Puede ser mayor el monto retenido al proyectado  --->
				<cfquery datasource="#arguments.conexion#">
					update SalarioEmpleado 
					set SERentaT = coalesce(SERentaT, 0.00) - coalesce((	select round(sum(a.SERentaT),2)
																		from HSalarioEmpleado a, CalendarioPagos cp
																		where a.DEid = SalarioEmpleado.DEid
																			and cp.CPid = a.RCNid
																			and cp.CPperiodo = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.per#">
																			and cp.CPmes = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.mes#">
																			and cp.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.Ecodigo#">
																	 ),0.00)
					where SalarioEmpleado.RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.RCNid#">
						and SalarioEmpleado.SEcalculado = 0
				</cfquery>
			</cfif>

			<cfif rsDatosRenta.IRfactormeses EQ 12>
				<cfquery datasource="#arguments.conexion#">				
					update SalarioEmpleado 
					set SErenta = 0 
					where (SEsalariobruto + SEincidencias) < SErenta
					and RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.RCNid#">
					and SEcalculado = 0
				</cfquery>
			</cfif>
		
			<!--- SUMA EL MONTO DE RENTA POR DEDUCCIÓN AL TOTAL DE RENTA SErenta --->
			<cfquery datasource="#arguments.conexion#">
				update SalarioEmpleado
				set SErenta = SERentaT + SERentaD
				where RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.RCNid#">
				  and SEcalculado = 0
			</cfquery>

		
		<cfreturn>	
	</cffunction>
</cfcomponent>
