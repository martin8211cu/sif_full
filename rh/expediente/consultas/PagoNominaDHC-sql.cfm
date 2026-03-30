<cfsetting requesttimeout="8600">
<!--- Modified with Notepad --->
<cfset Session.DebugInfo = true>
<!--- Pago de Planilla (S.A.) --->
<cfsilent>
	<!--- Invoca el portlet de traduccin y genera algunas 
	variables utilizadas en este componente. --->
	<cfsavecontent variable="pNavegacion">
		<cfinclude template="/home/menu/pNavegacion.cfm">
	</cfsavecontent>
	<!--- Genera variables de traduccin --->
	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		Key="LB_Reporte_de_Planilla_DHC"
		Default="#nav__SPdescripcion#"
		returnvariable="LB_Reporte_de_Planilla_DHC"/>
	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		Key="LB_Periodo"
		Default="Periodo"
		returnvariable="LB_Periodo"/>
	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		Key="LB_A"
		Default="a"
		returnvariable="LB_A"/>
	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		Key="LB_Fecha_de_pago"
		Default="Fecha de pago"
		returnvariable="LB_Fecha_de_pago"/>
	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		Key="LB_Nombre"
		Default="Nombre"
		returnvariable="LB_Nombre"/>
	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		Key="LB_Tarifa_por_horas"
		Default="Tarifa por horas"
		returnvariable="LB_Tarifa_por_Hora"/>
	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		Key="LB_Fecha_de_Ingreso"
		Default="Fecha de Ingreso"
		returnvariable="LB_Fecha_de_Ingreso"/>
	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		Key="LB_Identificacion"
		Default="Identificaci&oacute;n"
		xmlfile="/rh/generales.xml"
		returnvariable="LB_Identificacion"/>
	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		Key="LB_TotalHorasRegulares"
		Default="Total Horas Regulares"
		returnvariable="LB_TotalHorasRegulares"/>		
	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		Key="LB_PagoTotal"
		Default="Pago Total"
		returnvariable="LB_PagoTotal"/>	
	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		Key="LB_TiempoExtra"
		Default="Tiempo Extra"
		returnvariable="LB_TiempoExtra"/>	
	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		Key="LB_TotalTiempoExtra"
		Default="Total Tiempo Extra"
		returnvariable="LB_TotalTiempoExtra"/>	
	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		Key="LB_HorasDomingo"
		Default="Horas Domingo"
		returnvariable="LB_HorasDomingo"/>	
	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		Key="LB_TotalHorasDomingo"
		Default="Total Horas Domingo"
		returnvariable="LB_TotalHorasDomingo"/>	
	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		Key="LB_DiaNacional"
		Default="Dia Nacional"
		returnvariable="LB_DiaNacional"/>	
	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		Key="LB_TotalDiaNacional"
		Default="Total D&iacute;a Nacional"
		returnvariable="LB_TotalDiaNacional"/>	
	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		Key="LB_Ajustes_(+)"
		Default="Ajustes (+)"
		returnvariable="LB_Ajustes"/>	
	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		Key="LB_Comision"
		Default="Comisi&oacute;n"
		returnvariable="LB_Comision"/>	
	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		Key="LB_Vacaciones"
		Default="Vacaciones"
		returnvariable="LB_Vacaciones"/>	
	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		Key="LB_XIII"
		Default="XIII"
		returnvariable="LB_XIII"/>
	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		Key="LB_SalarioTotal"
		Default="Salario Total"
		returnvariable="LB_SalarioTotal"/>
	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		Key="LB_ImpuestoRenta"
		Default="Impuesto Renta"
		returnvariable="LB_ImpuestoRenta"/>		
	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		Key="LB_SeguroSocialEmpleado"
		Default="Seguro Social Empleado"
		returnvariable="LB_SeguroSocialEmpleado"/>
	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		Key="LB_EducacionEmpleado"
		Default="Educacion Empleado"
		returnvariable="LB_EducacionEmpleado"/>
	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		Key="LB_CargasSociales"
		Default="Cargas Sociales"
		returnvariable="LB_CargasSociales"/>
	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		Key="LB_SalarioNeto"
		Default="Salario Neto"
		returnvariable="LB_SalarioNeto"/>
	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		Key="LB_DeduccionesEmpleado"
		Default="Deducciones Empleado"
		returnvariable="LB_DeduccionesEmpleado"/>
	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		Key="LB_PagoTotal"
		Default="Pago Total"
		returnvariable="LB_PagoTotal"/>		
		
	<!--- Tabla temporal de calendario de pagos --->
	<cf_dbtemp name="calendario" returnvariable="calendario">
		<cf_dbtempcol name="RCNid"   	type="int"      mandatory="yes">
		<cf_dbtempcol name="RCdesde" 	type="datetime" mandatory="no">
		<cf_dbtempcol name="RChasta" 	type="datetime" mandatory="no">
		<cf_dbtempcol name="Tcodigo" 	type="char(5)"  mandatory="no">
		<cf_dbtempcol name="FechaPago" 	type="datetime"	mandatory="no">
		<cf_dbtempkey cols="RCNid">
	</cf_dbtemp>
	<!--- Tabla temporal de resultados --->
	<cf_dbtemp name="salida" returnvariable="salida">
		<cf_dbtempcol name="DEid"     				type="numeric"      mandatory="yes">
		<cf_dbtempcol name="DEidentificacion"     	type="varchar(60)"	mandatory="no">
		<cf_dbtempcol name="RCNid"    				type="numeric"      mandatory="no">		<!---  nomina mas reciente de las nominas seleccionadas para el reporte --->
		<cf_dbtempcol name="LTid"     				type="numeric"      mandatory="no">		<!---  corte mas reciente de la linea del tiempo del empleado par atrabajar sobre el --->
		<cf_dbtempcol name="LThasta"  				type="datetime"     mandatory="no">		<!---  fecha del corte mas reciente de la linea del tiempo del empleado, necesario para trabajar sobre el --->		
		<cf_dbtempcol name="Nombre"   				type="char(40)"     mandatory="no">
		<cf_dbtempcol name="PagoPorHora"  			type="int"          mandatory="no">		<!--- indicador de salario fijo o salario por horas --->
		<cf_dbtempcol name="SalarioPorHora"			type="money"        mandatory="no">		<!--- Hourly Salary rate --->
		<cf_dbtempcol name="TotalHorasRegulares"	type="float"        mandatory="no">		<!--- Total Regular Hours --->
		<cf_dbtempcol name="CantDiasMensual"		type="integer"      mandatory="no">		<!--- utilizado para calculo de salario por hora --->
		<cf_dbtempcol name="PagoTotal"				type="money"      	mandatory="no">		<!--- Pago Total (Total Pay) --->	
		<cf_dbtempcol name="TiempoExtra"			type="money"      	mandatory="no">		<!--- tiempo Extra (overtime) --->	
		<cf_dbtempcol name="TotalTiempoExtra"		type="money"      	mandatory="no">		<!--- Cantidad total tiempoextra (Total Amount Overtime) --->			
		<cf_dbtempcol name="HorasDomingo"			type="money"      	mandatory="no">		<!--- Horas Domingo (Hours Sunday) --->	
		<cf_dbtempcol name="TotalHorasDomingo"		type="money"      	mandatory="no">		<!--- total Horas Domingo --->			
		<cf_dbtempcol name="DiaNacional"			type="money"      	mandatory="no">		<!--- Dia nacional (National Day) --->
		<cf_dbtempcol name="TotalDiaNacional"		type="money"      	mandatory="no">		<!--- Total Dia nacional (National Day) --->
		<cf_dbtempcol name="Ajustes"				type="money"      	mandatory="no">		<!--- Ajustes (Adjustments) --->
		<cf_dbtempcol name="Comision"				type="money"      	mandatory="no">		<!--- Comision --->		
		<cf_dbtempcol name="Vacaciones" 			type="money"       	mandatory="no">		<!--- Vacaciones (Vacactions)--->
		<cf_dbtempcol name="XIII" 					type="money"       	mandatory="no">		<!--- XIII --->
		<cf_dbtempcol name="SalarioTotal"			type="money"       	mandatory="no">		<!--- Salario Total (Total salary) --->
		<cf_dbtempcol name="ImpuestoRenta"			type="money"       	mandatory="no">		<!--- Impuesto renta --->
		<cf_dbtempcol name="SeguroSocialEmpleado"	type="money"       	mandatory="no">		<!--- Seguro Social Empleado (Employed Social security) --->
		<cf_dbtempcol name="EducacionEmpleado"		type="money"       	mandatory="no">		<!--- Educacion Empleado (Employed Educational) --->
		<cf_dbtempcol name="CargasSociales"			type="money"       	mandatory="no">		<!--- Cargas Sociales --->
		<cf_dbtempcol name="SalarioNeto"			type="money"       	mandatory="no">		<!--- Salario Neto (Net Pay) --->
		<cf_dbtempcol name="DeduccionesEmpleado"	type="money"       	mandatory="no">		<!--- DeduccionesEmpleado (Employed Advance) --->
		<cf_dbtempcol name="TotalPagado"			type="money"       	mandatory="no">		<!--- Pago Total (Total Pay) columna 23--->
		
		<cf_dbtempcol name="EsNuevo"  				type="int"    		mandatory="no">
		<cf_dbtempcol name="CFcodigo" 				type="varchar(10)"  mandatory="no">
		<cf_dbtempcol name="CFdescripcion"			type="varchar(60)"  mandatory="no">
		<cf_dbtempcol name="FIngreso" 				type="datetime"     mandatory="no">
		<cf_dbtempcol name="Fechas" 				type="char(50)"     mandatory="no">
		<cf_dbtempcol name="Fechap" 				type="char(30)"		mandatory="no">
		<cf_dbtempkey cols="DEid">
	</cf_dbtemp>
	
	<!--- Tabla temporal de calendario de pagos --->	
	<cf_dbtemp name="salario" returnvariable="salario">
		<cf_dbtempcol name="DEid"   	type="numeric" mandatory="yes">
		<cf_dbtempcol name="salario" 	type="money" 	mandatory="no">
		<!----===================================================================================---->	
		<cf_dbtempcol name="componentes" 		type="float" 		mandatory="no">
		<cf_dbtempcol name="LTid"   			type="numeric" 		mandatory="no">
		<cf_dbtempcol name="RCNid"   			type="numeric" 		mandatory="no">
		<cf_dbtempcol name="cantDiasJornada"   type="float" 		mandatory="no">
		<!----===================================================================================---->	
	</cf_dbtemp>

	<!--- Decide si se buscan los datos en las 
	tablas de trabajo o en las histricas --->
	<cfset prefijo = '' >
	<cfif isdefined('form.tiponomina')>
		<cfset prefijo = 'H' >
	</cfif>
	
	<!--- Define Form.CPidlist (Puede venir en Form.CPidlist1 o Form.CPidlist2) --->
	<cfif isdefined("form.CPidlist1") and len(trim(form.CPidlist1)) gt 0>
		<cfset form.CPidlist = form.CPidlist1>
	<cfelseif isdefined("form.CPidlist2") and len(trim(form.CPidlist2)) gt 0>
		<cfset form.CPidlist = form.CPidlist2>
	<cfelse>
		<!--- Este error no debe presentarse. --->
		<cfthrow message="Error. Se requiere CPidlist (1 o 2). Proceso Cancelado!">
	</cfif>
	<!--- Obtiene informacin del calendario de pago
	selecccionado por el usuario. --->
	<cfquery datasource="#session.dsn#">	
		insert into #calendario#(RCNid, RCdesde, RChasta, Tcodigo, FechaPago)
		select CPid, CPdesde, CPhasta, Tcodigo, CPfpago
		from CalendarioPagos
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
		and <cf_whereInList Column="CPid" ValueList="#form.CPidlist#" cfsqltype="cf_sql_numeric">
	</cfquery>

<!---	INSERTA EN LA INFORMACION DE SALIDA, 
		LOS DATOS BASICOS DEL FUNCIONARIO
--->
<cfquery datasource="#session.dsn#" >
	insert #salida# (DEid, DEidentificacion, Nombre )
	select distinct a.DEid, 
					de.DEidentificacion, 
					<cf_dbfunction name="concat" args="de.DEapellido1,'  ', de.DEapellido2 , '  ', de.DEnombre">
	from #prefijo#SalarioEmpleado a, DatosEmpleado de
	where a.RCNid in ( select RCNid from #calendario# )
	and de.DEid=a.DEid
</cfquery>		
<!---	ACTUALIZA LA INFORMACION CON LA FECHA DE INGRESO DE LOS FUNCIONARIOS
	 	COLUMNA START DATE
--->
<cfquery datasource="#session.dsn#">
	update #salida#
	set FIngreso = ( select EVfantig
					 from EVacacionesEmpleado a 
					 where a.DEid = #salida#.DEid)
</cfquery>	
	
<!--- calcula la nomina mas reciente de cada empleado, de las seleccionadas, en caso de que este en mas de una --->
<cfquery datasource="#session.DSN#">
	update #salida#
	set RCNid = (  select max(a.RCNid)
				   from #calendario# a, #prefijo#SalarioEmpleado b
				   where a.RCNid=b.RCNid
				   and b.DEid=#salida#.DEid
				   and a.FechaPago = ( 	select max(a1.FechaPago)
										from #calendario# a1, #prefijo#SalarioEmpleado b1
										where a1.RCNid=b1.RCNid
										and b1.DEid=#salida#.DEid
									 )  
				)
</cfquery>

<!--- si de los empleados insertados, alguno no cae en las nominas seleccionadas, lo eliminamos--->
<cfquery datasource="#session.DSN#">
	delete from #salida#
	where RCNid is null
</cfquery>

<!--- calcula la fecha hasta del corte mas reciente en la linea del tiempo, para cada empelado  --->
<cfquery datasource="#session.DSN#">
	update #salida#
	set LThasta = ( select max(lt.LThasta)
				  	from LineaTiempo lt, #calendario# c
				  	where lt.DEid=#salida#.DEid
				  	  and c.RCNid=#salida#.RCNid
				  	  and lt.LTdesde <= c.RChasta
				  	  and lt.LThasta >= c.RCdesde
				  )
</cfquery>

<!--- calcula el id de la linea del tiempo del corte mas reciente enal linea del tiempo, para cada empelado, basado en la fecha del query anterior --->
<cfquery datasource="#session.DSN#">
	update #salida#
	set LTid = ( select lt.LTid
				 from LineaTiempo lt
				 where lt.DEid=#salida#.DEid
				 and lt.LThasta = #salida#.LThasta
			   )
</cfquery>

<!--- trae los datos del centro funcional --->
<cfquery datasource="#session.DSN#">
	update #salida#
	set CFcodigo = ( select cf.CFcodigo
					 from CFuncional cf, RHPlazas p, LineaTiempo lt
					 where p.CFid = cf.CFid
					 and lt.RHPid = p.RHPid
					 and lt.LTid = #salida#.LTid ),
		CFdescripcion = (select cf.CFdescripcion
						 from CFuncional cf, RHPlazas p, LineaTiempo lt
						 where p.CFid = cf.CFid
						 and lt.RHPid = p.RHPid
						 and lt.LTid = #salida#.LTid)
</cfquery>



<!--- calcula si al empleado se le paga por horas o por salario fijo --->
<cfquery datasource="#session.DSN#">
	update #salida#
	set PagoPorHora = ( select j.RHJornadahora
						from RHJornadas j, LineaTiempo lt
						where j.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
						and lt.RHJid=j.RHJid
						and lt.LTid = #salida#.LTid )

</cfquery>

<!--- ================================================================== --->
<!--- Salario por hora (Hourly Salary Rate) 							 --->
<!--- ================================================================== --->
	<cfinvoke component="rh.Componentes.RHParametros" method="get" datasource="#session.dsn#" ecodigo="#session.Ecodigo#" pvalor="80" default="" returnvariable="CantDiasMensual"/>

	<!--- calcula la cantidad de dias mensual de la nomina --->
	<cfquery datasource="#session.DSN#">
		update #salida#
		set CantDiasMensual = (  	select <cf_dbfunction name="to_integer" args="tn.FactorDiasSalario" >
									from #calendario# c, TiposNomina tn
									where c.RCNid=#salida#.RCNid
									and tn.Tcodigo=c.Tcodigo
									and tn.Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">   )
	</cfquery>
	<!--- si en el query anterior algun registro quedo nulo, se pone la cantidad de dias mensual de parametros --->
	<cfif len(trim(CantDiasMensual))>
		<cfquery datasource="#session.DSN#">
			update #salida#
			set CantDiasMensual = <cfqueryparam cfsqltype="cf_sql_integer" value="#CantDiasMensual#">
			where CantDiasMensual is null
		</cfquery>	
	</cfif>
	
<!----===================================================================================---->	
<!----Carga componentes en temp salario---->	
<cfquery datasource="#session.DSN#"	>
	insert into #salario# (DEid,componentes,LTid,RCNid)
	select 	s.DEid,
			(select sum(coalesce(dt.DLTmonto, 0.00))
			from DLineaTiempo dt, ComponentesSalariales cs 
			where dt.LTid = b.LTid
			  and cs.CSid = dt.CSid
			  and cs.CSpagohora = 1)	
		 	,s.LTid 
			,a.RCNid	  
	from #prefijo#SalarioEmpleado a
		inner join #salida# s
			on s.DEid=a.DEid
			and s.RCNid=a.RCNid
			
		inner join LineaTiempo b
			on  a.DEid =b.DEid
			and b.LTid = s.LTid
	
		left outer join RHJornadas c
			on b.RHJid = c.RHJid
</cfquery>
<!----Carga cant horas jornada---->
<cfquery datasource="#session.DSN#">
	update  #salario#
	set cantDiasJornada = (select RHJhorasNormales 
							from RHDJornadas 
							where RHJid = j.RHJid 
							and RHDJdia = datepart(dw,x.ICfecha))
	from #prefijo#SalarioEmpleado d, CIncidentes b, LineaTiempo lt, RHJornadas j , #prefijo#IncidenciasCalculo x, #salida# s1, #salario# z				
	where d.DEid = x.DEid
	   and d.RCNid = x.RCNid
	   and b.CIid = x.CIid
	   and b.CItipo < 2   <!---0 = Horas, 1= Dias--->
	   and x.DEid = lt.DEid
	   and x.ICfecha between lt.LTdesde and lt.LThasta
	   and j.RHJid = coalesce(x.RHJid, lt.RHJid)
	
	   and s1.DEid=d.DEid
	   and s1.RCNid=d.RCNid
	
	   and d.DEid = z.DEid
	   and d.RCNid = z.RCNid 						
</cfquery>

<!----Actualiza el valor del salario---->
<cfquery name="r" datasource="#session.DSN#">
	update #salario#
	set salario = 
	(
	select 			
		case when c.RHJornadahora = 1 then <!--- ===== Salario por Hora ====== --->
			coalesce(
				(	select	max( 
					<!---- (	select		---->
						case when (b.CItipo = 0 and coalesce(j.RHJhorasemanal, 0.00) > 1.00) then  <!--- Jornada semanal--->
							coalesce(
									round(z.componentes	* 12.0 / 52.0 / ( j.RHJhorasemanal * 1.00 ),2 )<!--- round --->
									, 0.00 ) <!--- when 1 --->
						when ( b.CItipo = 0 and coalesce(j.RHJhoradiaria, 0.00) > 1.00 ) then	<!--- Jornada diaria --->
							coalesce(
									round(z.componentes/ s1.CantDiasMensual/ 
															(
																( 
																	case 
																		when j.RHJincHJornada = x.CIid then
																			(
																				case (coalesce(z.cantDiasJornada,0.00))
																					when 0.00 then 
																						j.RHJhoradiaria
																					else 
																						(coalesce(z.cantDiasJornada,0.00))
																				end
																			)
																		else j.RHJhoradiaria 
																	end
																) 
																* 1.00
											),2)<!--- round --->
								, 0.00)
							end
						)
						from #prefijo#SalarioEmpleado d, CIncidentes b, 
							  LineaTiempo lt, RHJornadas j , 
							  #prefijo#IncidenciasCalculo x, 
							  #salida# s1	, #salario# z				
						where d.DEid = x.DEid
							   and d.RCNid = x.RCNid
							   and b.CIid = x.CIid
							   and b.CItipo < 2    <!---0 = Horas, 1= Dias--->
							   and x.DEid = lt.DEid
							   and x.ICfecha between lt.LTdesde and lt.LThasta
							   and j.RHJid = coalesce(x.RHJid, lt.RHJid)

							   and s1.DEid=d.DEid
							   and s1.RCNid=d.RCNid
							   
							   and d.DEid = z.DEid
							   and d.RCNid = z.RCNid		

							   <!---se pega con la de afuera --->					  
							   and z.DEid = #salario#.DEid
							   and z.RCNid = #salario#.RCNid
					)
					
					,0)
										
		else <!--- ======= Salario Fijo ======= --->
			coalesce(b.LTsalario,0)
		end
	)
	from #salario#
		inner join LineaTiempo b
			on  #salario#.DEid =b.DEid
			and #salario#.LTid = b.LTid
		
		left outer join RHJornadas c
			on b.RHJid = c.RHJid
</cfquery>
<!----===================================================================================---->
	
	<!----
	<!--- hace el calculo del salario por hora de los empleados --->
	<cfquery datasource="#session.DSN#">
			insert into #salario# (DEid, salario)
			select 	s.DEid, 
					case 
						when c.RHJornadahora = 1 then <!--- ===== Salario por Hora ====== --->
							sum(coalesce(
										<!---(	select	sum(---->
											 (	select		
														case <!--- if 2 --->							
															when (b.CItipo = 0 and coalesce(j.RHJhorasemanal, 0.00) > 1.00) then  <!--- Jornada semanal--->
																coalesce(
																	round(
																		coalesce(
																			( 	select coalesce(dt.DLTmonto, 0.00)
																				from DLineaTiempo dt, ComponentesSalariales cs 
																				where dt.LTid = lt.LTid
																				  and cs.CSid = dt.CSid
																				  and cs.CSpagohora = 1
																			), 
																			0.00 
																		)
																		* 12.0 / 52.0 
																		/ ( j.RHJhorasemanal * 1.00 )
																	,2 ), <!--- round --->
																0.00 ) <!--- when 1 --->
				
															when ( b.CItipo = 0 and coalesce(j.RHJhoradiaria, 0.00) > 1.00 ) then	<!--- Jornada diaria --->
																coalesce(
																	round(
																		coalesce(
																			(	select coalesce(dt.DLTmonto, 0.00)
																				from DLineaTiempo dt, ComponentesSalariales cs 
																				where dt.LTid = lt.LTid
																  				and cs.CSid = dt.CSid
																  				and cs.CSpagohora = 1
																			)
																			, 0.00
																		)
																		/ s1.CantDiasMensual
																		/ 
																		(
																			( 
																				case 
																					when j.RHJincHJornada = x.CIid then
																						(
																							case (coalesce((select RHJhorasNormales from RHDJornadas where RHJid = j.RHJid and RHDJdia = datepart(dw,x.ICfecha)),0.00))
																								when 0.00 then j.RHJhoradiaria
																								else (coalesce((select RHJhorasNormales from RHDJornadas where RHJid = j.RHJid and RHDJdia = datepart(dw,x.ICfecha)),0.00))
																							end
																						)
																					else j.RHJhoradiaria 
																				end
														  					) 
																			* 1.00
																		)
																		,2
																	)
																	, 0.00
																)						
														end<!---) <!--- if 2 --->---->

								from SalarioEmpleado d, CIncidentes b, LineaTiempo lt, RHJornadas j , IncidenciasCalculo x, #salida# s1

								where d.DEid = x.DEid
									   and d.RCNid = x.RCNid
									   and b.CIid = x.CIid
									   and b.CItipo < 2    <!---0 = Horas, 1= Dias--->
									   and x.DEid = lt.DEid
									   and x.ICfecha between lt.LTdesde and lt.LThasta
									   and j.RHJid = coalesce(x.RHJid, lt.RHJid)
									   <!---se pega con la de afuera --->
									   and d.DEid = a.DEid
									   and d.RCNid = a.RCNid
									   and s1.DEid=d.DEid
									   and s1.RCNid=d.RCNid
						)
						,0)
						)

						else <!--- ======= Salario Fijo ======= --->
							coalesce(b.LTsalario,0)
					end

			from #prefijo#SalarioEmpleado a

			inner join #salida# s
			on s.DEid=a.DEid
			and s.RCNid=a.RCNid
				
			inner join LineaTiempo b
			on  a.DEid =b.DEid
			and b.LTid = s.LTid

			left outer join RHJornadas c
			on b.RHJid = c.RHJid
	</cfquery>
	------->

	<cfquery datasource="#session.DSN#">
		update #salida#
		set SalarioPorHora = (  select salario
								from #salario#
								where DEid = #salida#.DEid )
	</cfquery>
	<!--- empleados con salario fijo --->
<!--- ================================================================== --->
<!--- Calculo de Horas Regulares										 --->
<!--- ================================================================== --->

	<cfquery datasource="#session.DSN#">
		update #salida#
		set TotalHorasRegulares = 	(	(	select 	sum(a.CAMcanthorasreb*b.CInegativo)
						
											from RHCMCalculoAcumMarcas a, CIncidentes b, RHJornadas j
											where a.DEid=#salida#.DEid
											and a.CAMestado='A'
											and b.CIid=a.CAMincidrebhoras
											and j.RHJid=a.RHJid
											and j.RHJornadahora=0											
											and convert(varchar,a.CAMfdesde,112) 
											not in (  	select RHFfecha
														from RHFeriados
														where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#"> )
										)
										+	
										(	select 	sum(a.CAMcanthorasjornada*b.CInegativo )
											
											from RHCMCalculoAcumMarcas a , CIncidentes b, RHJornadas j
											where a.DEid=#salida#.DEid
											and a.CAMestado='A'
											and b.CIid=a.CAMincidjornada
											and j.RHJid=a.RHJid
											and j.RHJornadahora=0
											and convert(varchar,a.CAMfdesde,112) 
											not in (  	select RHFfecha
														from RHFeriados
														where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#"> )
											
										)	
										+	
										(	select	sum(a.CAMcanthorasextA*b.CInegativo)
											
											from RHCMCalculoAcumMarcas a, CIncidentes b, RHJornadas j
											where a.DEid=#salida#.DEid
											and a.CAMestado='A'
											and b.CIid=a.CAMincidhorasextA
											and j.RHJid=a.RHJid
											and j.RHJornadahora=0
											and convert(varchar,a.CAMfdesde,112) 
											not in (  	select RHFfecha
														from RHFeriados
														where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#"> )
											
										)
										+	
										(
											select	sum(a.CAMcanthorasextB*b.CInegativo )
											
											from RHCMCalculoAcumMarcas a, CIncidentes b, RHJornadas j
											where a.DEid=#salida#.DEid
											and a.CAMestado='A'
											and b.CIid=a.CAMincidhorasextB
											and j.RHJid=a.RHJid
											and j.RHJornadahora=0
											and convert(varchar,a.CAMfdesde,112) 
											not in (  	select RHFfecha
														from RHFeriados
														where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#"> )
											
										)	
									)
		where PagoPorHora = 0							
	</cfquery>	
	<!--- empleados con salario por horas --->
	<cfquery datasource="#session.DSN#">
		update #salida#
		set TotalHorasRegulares =	(  	select sum(i.ICvalor)
										from #prefijo#IncidenciasCalculo i, #calendario# c
										where c.RCNid=i.RCNid
										  and i.DEid=#salida#.DEid
										  and coalesce(i.ICmontores,0) != 0
										  and i.CIid in (	select CIid
															from RHReportesNomina c
																inner join RHColumnasReporte b
																on b.RHRPTNid = c.RHRPTNid
																and b.RHCRPTcodigo = 'TRH'							
																inner join RHConceptosColumna a
																on a.RHCRPTid = b.RHCRPTid
															where c.RHRPTNcodigo = 'DHC'
															  and c.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#"> )
									)
		where PagoPorHora = 1
	</cfquery>

<!--- ================================================================== --->
<!--- Pago Total (Total Pay)										 	 --->
<!--- ================================================================== --->
	<!--- empleados por hora --->
	<cfquery datasource="#session.DSN#">
		update #salida#
		set PagoTotal = (  	select sum(i.ICmontores)
							from #prefijo#IncidenciasCalculo i, #calendario# c
							where c.RCNid=i.RCNid
							  and i.DEid=#salida#.DEid
							  and i.CIid in (	select CIid
												from RHReportesNomina c
													inner join RHColumnasReporte b
													on b.RHRPTNid = c.RHRPTNid
													and b.RHCRPTcodigo = 'TRH'
													inner join RHConceptosColumna a
													on a.RHCRPTid = b.RHCRPTid
												where c.RHRPTNcodigo = 'DHC'
												  and c.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#"> )
						)
		where PagoPorHora = 1
	</cfquery>
	
	<!--- empleados fijoa --->
	<cfquery datasource="#session.DSN#">
		update #salida#
		set PagoTotal = ( 	select SEsalariobruto
							from #prefijo#SalarioEmpleado
							where DEid = #salida#.DEid
							  and RCNid = #salida#.RCNid  )
		where PagoPorHora = 0
		
		update #salida#
		set PagoTotal = PagoTotal + (select coalesce(sum(ICmontores),0)
											  from #prefijo#IncidenciasCalculo ic
											  where ic.DEid=#salida#.DEid
											  and ic.RCNid=#salida#.RCNid
											  and ic.CIid in (select CIid
															  from RHReportesNomina c
															  inner join RHColumnasReporte b
															   on b.RHRPTNid = c.RHRPTNid
															   and b.RHCRPTcodigo = 'TRH'							
															   inner join RHConceptosColumna a
															    on a.RHCRPTid = b.RHCRPTid
															    where c.RHRPTNcodigo = 'DHC'
															    and c.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#"> )
											  )
		where PagoPorHora = 0											  
	</cfquery>
	
<!--- ================================================================== --->
<!--- Tiempo Extra (Overtime)										 	 --->
<!--- ================================================================== --->
	<!--- empleados por hora --->
	<cfquery datasource="#session.DSN#">
		update #salida#
		set TiempoExtra = (  	select sum(i.ICvalor)
								from #prefijo#IncidenciasCalculo i, #calendario# c
								where c.RCNid=i.RCNid
								  and i.DEid=#salida#.DEid
								  and i.CIid in (	select CIid
													from RHReportesNomina c
														inner join RHColumnasReporte b
														on b.RHRPTNid = c.RHRPTNid
														and b.RHCRPTcodigo = 'OT'
							
														inner join RHConceptosColumna a
														on a.RHCRPTid = b.RHCRPTid
													where c.RHRPTNcodigo = 'DHC'
													  and c.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#"> )
						)
	</cfquery>

<!--- ================================================================== --->
<!--- Cantidad Total de Tiempo Extra (Total Amount Overtime)			 --->
<!--- ================================================================== --->
	<!--- empleados por hora --->
	<cfquery datasource="#session.DSN#">
		update #salida#
		set TotalTiempoExtra = (  	select sum(i.ICmontores)
									from #prefijo#IncidenciasCalculo i, #calendario# c
									where c.RCNid=i.RCNid
									  and i.DEid=#salida#.DEid
									  and i.CIid in (	select CIid
														from RHReportesNomina c
															inner join RHColumnasReporte b
															on b.RHRPTNid = c.RHRPTNid
															and b.RHCRPTcodigo = 'OT'
								
															inner join RHConceptosColumna a
															on a.RHCRPTid = b.RHCRPTid
														where c.RHRPTNcodigo = 'DHC'
														  and c.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#"> )
								)
	</cfquery>

<!--- ================================================================== --->
<!--- Horas Domingo (Hours Sunday)										 --->
<!--- ================================================================== --->
	<!--- empleados por hora --->
	<cfquery datasource="#session.DSN#">
		update #salida#
		set HorasDomingo = (  	select sum(i.ICvalor)
								from #prefijo#IncidenciasCalculo i, #calendario# c
								where c.RCNid=i.RCNid
								  and i.DEid=#salida#.DEid
								  and coalesce(i.ICmontores,0) != 0
								  and i.CIid in (	select CIid
													from RHReportesNomina c
														inner join RHColumnasReporte b
														on b.RHRPTNid = c.RHRPTNid
														and b.RHCRPTcodigo = 'HD'
							
														inner join RHConceptosColumna a
														on a.RHCRPTid = b.RHCRPTid
													where c.RHRPTNcodigo = 'DHC'
													  and c.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#"> )
						)
	</cfquery>

<!--- ================================================================== --->
<!--- Total Horas Domingo (Total Hours Sunday)										 --->
<!--- ================================================================== --->
	<!--- empleados por hora --->
	<cfquery datasource="#session.DSN#">
		update #salida#
		set TotalHorasDomingo = (  	select sum(i.ICmontores)
									from #prefijo#IncidenciasCalculo i, #calendario# c
									where c.RCNid=i.RCNid
									  and i.DEid=#salida#.DEid
									  and i.CIid in (	select CIid
														from RHReportesNomina c
															inner join RHColumnasReporte b
															on b.RHRPTNid = c.RHRPTNid
															and b.RHCRPTcodigo = 'HD'
								
															inner join RHConceptosColumna a
															on a.RHCRPTid = b.RHCRPTid
														where c.RHRPTNcodigo = 'DHC'
														  and c.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#"> )
								)
	</cfquery>

<!--- ================================================================== --->
<!--- Dia nacional(national Day)										 --->
<!--- ================================================================== --->
	<!--- Incidencias tipo horas --->
	<cfquery datasource="#session.DSN#">
		update #salida#
		set DiaNacional = coalesce(DiaNacional, 0) + (  	select sum(i.ICvalor)
															from #prefijo#IncidenciasCalculo i, #calendario# cp
															where cp.RCNid=i.RCNid
															  and i.DEid=#salida#.DEid
															  and coalesce(i.ICmontores,0) != 0
															  and i.CIid in (	select a.CIid
																				from RHReportesNomina c
																					inner join RHColumnasReporte b
																					on b.RHRPTNid = c.RHRPTNid
																					and b.RHCRPTcodigo = 'DN'
														
																					inner join RHConceptosColumna a
																					on a.RHCRPTid = b.RHCRPTid
																					
																					inner join CIncidentes ci
																					on ci.CIid=a.CIid
																					and ci.CItipo = 0
																					
																				where c.RHRPTNcodigo = 'DHC'
																				  and c.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#"> )
													)
	</cfquery>

	<!--- Incidencias tipo diferente de horas --->
	<cfquery datasource="#session.DSN#">
		update #salida#
		set DiaNacional = coalesce(DiaNacional, 0) + (  	select sum(i.ICmontores/j.RHJhoradiaria)
															from #prefijo#IncidenciasCalculo i, #calendario# cp, RHJornadas j
															where cp.RCNid=i.RCNid
															  and i.DEid=#salida#.DEid
															  and j.RHJid = i.RHJid
															  and i.CIid in (	select a.CIid
																				from RHReportesNomina c
																					inner join RHColumnasReporte b
																					on b.RHRPTNid = c.RHRPTNid
																					and b.RHCRPTcodigo = 'DN'
														
																					inner join RHConceptosColumna a
																					on a.RHCRPTid = b.RHCRPTid
																					
																					inner join CIncidentes ci
																					on ci.CIid=a.CIid
																					and ci.CItipo > 0
																					
																				where c.RHRPTNcodigo = 'DHC'
																				  and c.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#"> )
													)
	</cfquery>

<!--- ================================================================== --->
<!--- Total Dia nacional(national Day)										 --->
<!--- ================================================================== --->
	<!--- Incidencias tipo horas --->
	<cfquery datasource="#session.DSN#">
		update #salida#
		set TotalDiaNacional = (  	select sum(i.ICmontores)
									from #prefijo#IncidenciasCalculo i, #calendario# cp
									where cp.RCNid=i.RCNid
									  and i.DEid=#salida#.DEid
									  and i.CIid in (	select a.CIid
														from RHReportesNomina c
															inner join RHColumnasReporte b
															on b.RHRPTNid = c.RHRPTNid
															and b.RHCRPTcodigo = 'DN'
								
															inner join RHConceptosColumna a
															on a.RHCRPTid = b.RHCRPTid
															
														where c.RHRPTNcodigo = 'DHC'
														  and c.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#"> )
							)
	</cfquery>

<!--- ================================================================== --->
<!--- Ajustes (Adjustments)										 		 --->
<!--- ================================================================== --->
	<!--- Incidencias tipo horas --->
	<cfquery datasource="#session.DSN#">
		update #salida#
		set Ajustes = (  	select sum(i.ICmontores)
							from #prefijo#IncidenciasCalculo i, #calendario# cp
							where cp.RCNid=i.RCNid
							  and i.DEid=#salida#.DEid
							  and i.CIid in (	select a.CIid
												from RHReportesNomina c
													inner join RHColumnasReporte b
													on b.RHRPTNid = c.RHRPTNid
													and b.RHCRPTcodigo = 'AJ'
						
													inner join RHConceptosColumna a
													on a.RHCRPTid = b.RHCRPTid
													
												where c.RHRPTNcodigo = 'DHC'
												  and c.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#"> )
					)
	</cfquery>

<!--- ================================================================== --->
<!--- Comision 															 --->
<!--- ================================================================== --->
	<!--- Incidencias tipo horas --->
	<cfquery datasource="#session.DSN#">
		update #salida#
		set Comision = (  	select sum(i.ICmontores)
							from #prefijo#IncidenciasCalculo i, #calendario# cp
							where cp.RCNid=i.RCNid
							  and i.DEid=#salida#.DEid
							  and i.CIid in (	select a.CIid
												from RHReportesNomina c
													inner join RHColumnasReporte b
													on b.RHRPTNid = c.RHRPTNid
													and b.RHCRPTcodigo = 'CO'
						
													inner join RHConceptosColumna a
													on a.RHCRPTid = b.RHCRPTid
													
												where c.RHRPTNcodigo = 'DHC'
												  and c.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#"> )
					)
	</cfquery>

<!--- ================================================================== --->
<!--- Vacaciones 															 --->
<!--- ================================================================== --->
	<!--- Incidencias tipo horas --->
	<cfquery datasource="#session.DSN#">
		update #salida#
		set Vacaciones = ( 	select sum(i.ICmontores)
							from #prefijo#IncidenciasCalculo i, #calendario# cp
							where cp.RCNid=i.RCNid
							  and i.DEid=#salida#.DEid
							  and i.CIid in (	select a.CIid
												from RHReportesNomina c
													inner join RHColumnasReporte b
													on b.RHRPTNid = c.RHRPTNid
													and b.RHCRPTcodigo = 'VA'
						
													inner join RHConceptosColumna a
													on a.RHCRPTid = b.RHCRPTid
													
												where c.RHRPTNcodigo = 'DHC'
												  and c.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#"> )
					)
	</cfquery>

<!--- ================================================================== --->
<!--- XIII 															 --->
<!--- ================================================================== --->
	<!--- Incidencias tipo horas --->
	<cfquery datasource="#session.DSN#">
		update #salida#
		set XIII = ( 	select sum(i.ICmontores)
						from #prefijo#IncidenciasCalculo i, #calendario# cp
						where cp.RCNid=i.RCNid
						  and i.DEid=#salida#.DEid
						  and i.CIid in (	select a.CIid
											from RHReportesNomina c
												inner join RHColumnasReporte b
												on b.RHRPTNid = c.RHRPTNid
												and b.RHCRPTcodigo = 'XIII'
					
												inner join RHConceptosColumna a
												on a.RHCRPTid = b.RHCRPTid
												
											where c.RHRPTNcodigo = 'DHC'
											  and c.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#"> )
				)
	</cfquery>

<!--- ================================================================== --->
<!--- Salario Total														 --->
<!--- ================================================================== --->
	<!--- Incidencias tipo horas --->
	<cfquery datasource="#session.DSN#">
		update #salida#
		set SalarioTotal = coalesce(PagoTotal, 0) + 
		                   coalesce(TotalTiempoExtra, 0) + 
		                   coalesce(TotalHorasDomingo, 0) + 
		                   coalesce(TotalDiaNacional, 0) + 
		                   coalesce(Ajustes, 0) + 
		                   coalesce(Comision, 0) + 
		                   coalesce(Vacaciones, 0) + 
		                   coalesce(XIII, 0)
	</cfquery>

<!--- ================================================================== --->
<!--- Impuesto de Renta													 --->
<!--- ================================================================== --->
	<!--- Incidencias tipo horas --->
	<cfquery datasource="#session.DSN#">
		update #salida#
		set ImpuestoRenta = ( select sum(a.SErenta)
							  from #prefijo#SalarioEmpleado a, #calendario# b
							  where b.RCNid=a.RCNid
							  and a.DEid=#salida#.DEid  )
	</cfquery>

<!--- ================================================================== --->
<!--- Seguro Social Empleado											 --->
<!--- ================================================================== --->
	<!--- Incidencias tipo horas --->
	<cfquery datasource="#session.DSN#">
		update #salida#
		set SeguroSocialEmpleado = ( 	select sum(i.CCvaloremp)
										from #prefijo#CargasCalculo i, #calendario# cp
										where cp.RCNid=i.RCNid
										  and i.DEid=#salida#.DEid
										  and i.DClinea in (	select a.DClinea
																from RHReportesNomina c
																inner join RHColumnasReporte b
																on b.RHRPTNid = c.RHRPTNid
																and b.RHCRPTcodigo = 'SSE'
									
																inner join RHConceptosColumna a
																on a.RHCRPTid = b.RHCRPTid
																
															where c.RHRPTNcodigo = 'DHC'
															  and c.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#"> )
									)
	</cfquery>

<!--- ================================================================== --->
<!--- Educacion Empleado											 --->
<!--- ================================================================== --->
	<!--- Incidencias tipo horas --->
	<cfquery datasource="#session.DSN#">
		update #salida#
		set EducacionEmpleado = ( 		select sum(i.CCvaloremp)
										from #prefijo#CargasCalculo i, #calendario# cp
										where cp.RCNid=i.RCNid
										  and i.DEid=#salida#.DEid
										  and i.DClinea in (	select a.DClinea
																from RHReportesNomina c
																inner join RHColumnasReporte b
																on b.RHRPTNid = c.RHRPTNid
																and b.RHCRPTcodigo = 'EE'
									
																inner join RHConceptosColumna a
																on a.RHCRPTid = b.RHCRPTid
																
															where c.RHRPTNcodigo = 'DHC'
															  and c.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#"> )
									)
	</cfquery>

<!--- ================================================================== --->
<!--- Cargas Sociales											 		 --->
<!--- ================================================================== --->
	<!--- Incidencias tipo horas --->
	<cfquery datasource="#session.DSN#">
		update #salida#
		set CargasSociales = ( 		select sum(i.CCvalorpat)
									from #prefijo#CargasCalculo i, #calendario# cp
									where cp.RCNid=i.RCNid
									  and i.DEid=#salida#.DEid
									  and i.DClinea in (	select a.DClinea
															from RHReportesNomina c
															inner join RHColumnasReporte b
															on b.RHRPTNid = c.RHRPTNid
															and b.RHCRPTcodigo = 'CS'
								
															inner join RHConceptosColumna a
															on a.RHCRPTid = b.RHCRPTid
															
															where c.RHRPTNcodigo = 'DHC'
															  and c.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#"> )
								)
	</cfquery>

<!--- ================================================================== --->
<!--- Salario Neto														 --->
<!--- ================================================================== --->
	<!--- Incidencias tipo horas --->
	<cfquery datasource="#session.DSN#">
		update #salida#
		set SalarioNeto = coalesce(SalarioTotal, 0) - ( coalesce(ImpuestoRenta, 0) + 
														coalesce(SeguroSocialEmpleado, 0) + 
														coalesce(EducacionEmpleado, 0) )
	</cfquery>

<!--- ================================================================== --->
<!--- Deducciones Empleado										 		 --->
<!--- ================================================================== --->
	<!--- Incidencias tipo horas --->
	<cfquery datasource="#session.DSN#">
		update #salida#
		set DeduccionesEmpleado = (	select sum(i.DCvalor)
									from #prefijo#DeduccionesCalculo i, #calendario# cp
									where cp.RCNid=i.RCNid
									  and i.DEid=#salida#.DEid
									  and i.Did in (	select de.Did
														from RHReportesNomina c
														inner join RHColumnasReporte b
														on b.RHRPTNid = c.RHRPTNid
														and b.RHCRPTcodigo = 'DE'
							
														inner join RHConceptosColumna a
														on a.RHCRPTid = b.RHCRPTid
														
														inner join TDeduccion td
														on td.TDid=a.TDid
														
														inner join DeduccionesEmpleado de
														on de.TDid=td.TDid
														and de.DEid=i.DEid
														
														where c.RHRPTNcodigo = 'DHC'
														  and c.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#"> )
								)
	</cfquery>

<!--- ================================================================== --->
<!--- Total Pagado														 --->
<!--- ================================================================== --->
	<!--- Incidencias tipo horas --->
	<cfquery datasource="#session.DSN#">
		update #salida#
		set TotalPagado = coalesce(SalarioNeto, 0) - coalesce(DeduccionesEmpleado, 0)
	</cfquery>

<!--- ================================================================== --->
<!--- Fechas del periodo, Fecha de pago									 --->
<!--- ================================================================== --->
<cfquery datasource="#session.dsn#">
	update #salida#
	set Fechas = '#LB_Periodo#: ' + convert(char(12), (select min(RCdesde) from #calendario#), 107)
</cfquery>	
<cfquery datasource="#session.dsn#">
	update #salida#
	set Fechas = ltrim(rtrim(Fechas)) + ' #LB_A# ' + convert(char(12), (select max(RChasta) from #calendario#), 107)
</cfquery>	
<cfquery datasource="#session.dsn#">
	update #salida#
	set Fechap = '#LB_Fecha_de_Pago#: ' + convert(char(12), (select max(FechaPago) from #calendario#), 107)
</cfquery>

<!--- Consultas para el Reporte --->
<cfquery name="rsReporte" datasource="#session.dsn#">
	<!--- ===============================
	   Ejecuta  la Salida del Reporte en Pantalla 
	   ===============================--->
	select 
		CFdescripcion, 																-- Centro Funcional
		EsNuevo, 																	-- Indica si la fecha de ingreso conincide con la nomina que se esta pagando
		Name = upper(Nombre), 														-- Nombre
		DEidentificacion as id,														-- identificacion
		coalesce(SalarioPorHora,0) as SalarioPorHora,								-- salario por hora
		coalesce(TotalHorasRegulares, 0) as TotalHorasRegulares,					-- total horas regulares
		coalesce(PagoTotal, 0) as PagoTotal,										-- pago total
		coalesce(TiempoExtra, 0) as TiempoExtra,									-- tiempo extra
		coalesce(TotalTiempoExtra, 0) as TotalTiempoExtra,							-- cantidad total tiempo extra		
		coalesce(HorasDomingo, 0) as HorasDomingo,									-- horas domingo
		coalesce(TotalHorasDomingo, 0) as TotalHorasDomingo,						-- total HorasDomingo
		coalesce(DiaNacional, 0) as DiaNacional,									-- Dia Nacional
		coalesce(TotalDiaNacional, 0) as TotalDiaNacional,							-- total Dia Nacional
		coalesce(Ajustes, 0) as Ajustes,											-- Ajustes
		coalesce(Comision, 0) as Comision,											-- Comision
		coalesce(Vacaciones, 0) as Vacaciones,										-- Vacaciones (vacations)
		coalesce(XIII, 0) as XIII,													-- XIII
		coalesce(SalarioTotal, 0) as SalarioTotal,									-- salario total (total salary) 
		coalesce(ImpuestoRenta, 0) as ImpuestoRenta,								-- ImpuestoRenta
		coalesce(SeguroSocialEmpleado, 0) as SeguroSocialEmpleado,					-- Seguro Social Empleado (Employed Social Security)
		coalesce(EducacionEmpleado, 0) as EducacionEmpleado,						-- Educacion Empleado (Employed Educational)
		coalesce(CargasSociales, 0) as CargasSociales,								-- Cargas Sociales
		coalesce(SalarioNeto, 0) as SalarioNeto,									-- SalarioNeto
		coalesce(DeduccionesEmpleado, 0) as DeduccionesEmpleado,					-- Deducciones Empleado (Employed Advance)
		coalesce(TotalPagado, 0) as TotalPagado,									-- TotalPagado (Total Paid)
		FIngreso as Start_Date,														-- Fecha de Ingreso segun EVacacionesEmpleado
		Fechas, 																	-- Titulo 1 para el reporte
		Fechap 																		-- Titulo 2 para el reporte
	from #salida#
	order by CFdescripcion, Nombre
</cfquery>
</cfsilent>
<cf_htmlReportsHeaders irA="PagoNominaDHC.cfm"
FileName="Reporte_de_Planilla_DHC.xls"
title="#LB_Reporte_de_Planilla_DHC#">
<cf_templatecss>
<table width="98%" border="0" cellpadding="0" cellspacing="0" align="center">
<cfoutput>
<tr>
	<td colspan="24">
		<table width="100%" cellpadding="0" cellspacing="0">
			<tr><td>
				<cfinvoke key="LB_ReporteDePlanillaDHC" default="Reporte de Planilla (DHC)" returnvariable="LB_ReporteDePlanillaDHC" component="sif.Componentes.Translate"  method="Translate"/>
				<cfset filtro3=''>
				<cfif isdefined('form.tiponomina')>
					<cfinvoke key="LB_IncluyeNominasAplicadas" default="Incluye N&oacute;minas Aplicadas" returnvariable="LB_IncluyeNominasAplicadas" component="sif.Componentes.Translate"  method="Translate"/>
					<cfset filtro3='#LB_IncluyeNominasAplicadas#'>
				<cfelse>
					<cfinvoke key="LB_IncluyeNominasEnProceso" default="Incluye N&oacute;minas En Proceso" returnvariable="LB_IncluyeNominasEnProceso" component="sif.Componentes.Translate"  method="Translate"/>
					<cfset filtro3='#LB_IncluyeNominasEnProceso#'>
				</cfif>
				<cf_EncReporte
					Titulo="#LB_ReporteDePlanillaDHC#"
					Color="##E3EDEF"
					filtro1="#Trim(rsReporte.Fechas)#"
					filtro2="#Trim(rsReporte.Fechap)#"
					filtro3="#filtro3#"
				>
			</td></tr>
		</table>
	</td>
</tr>
<tr><td>&nbsp;</td></tr>
<!----============================= ENCABEZADO ANTERIOR =============================
<tr><td colspan="24" align="center"><strong>#Trim(Session.Enombre)#</strong></td></tr>
<tr><td colspan="24" align="center"><strong>#Trim(rsReporte.Fechas)#</strong></td></tr>
<tr><td colspan="24" align="center"><strong><strong>#Trim(rsReporte.Fechap)#</strong></strong></td></tr>
<tr><td colspan="24" align="center"><strong><strong>	
	<cfif isdefined('form.tiponomina')>
		<cf_translate key="LB_IncluyeNominasAplicadas"> Incluye N&oacute;minas Aplicadas </cf_translate>
	<cfelse>
		<cf_translate key="LB_IncluyeNominasEnProceso"> Incluye N&oacute;minas En Proceso </cf_translate>
	</cfif>
	</strong></strong></td></tr>
---->	
<tr>
	<td  class="tituloListas" valign="top"><strong>#LB_Nombre#</strong>&nbsp;&nbsp;</td>
	<td  class="tituloListas" valign="top" align="center"><strong>#LB_Tarifa_por_Hora#</strong>&nbsp;</td>
	<td  class="tituloListas" valign="top" align="center"><strong>#LB_Fecha_de_Ingreso#</strong>&nbsp;</td>
	<td  class="tituloListas" valign="top" ><strong>#LB_Identificacion#</strong>&nbsp;</td>
	<td  class="tituloListas" valign="top" align="right"><strong>#LB_TotalHorasRegulares#</strong>&nbsp;</td>
	<td  class="tituloListas" valign="top" align="right"><strong>#LB_PagoTotal#</strong>&nbsp;</td>
	<td  class="tituloListas" valign="top" align="right"><strong>#LB_TiempoExtra#</strong>&nbsp;</td>
	<td  class="tituloListas" valign="top" align="right"><strong>#LB_TotalTiempoExtra#</strong>&nbsp;</td>
	<td  class="tituloListas" valign="top" align="right"><strong>#LB_HorasDomingo#</strong>&nbsp;</td>
	<td  class="tituloListas" valign="top" align="right"><strong>#LB_TotalHorasDomingo#</strong>&nbsp;</td>
	<td  class="tituloListas" valign="top" align="right"><strong>#LB_DiaNacional#</strong>&nbsp;</td>
	<td  class="tituloListas" valign="top" align="right"><strong>#LB_TotalDiaNacional#</strong>&nbsp;</td>
	<td  class="tituloListas" valign="top" align="right"><strong>#LB_Ajustes#</strong>&nbsp;</td>
	<td  class="tituloListas" valign="top" align="right"><strong>#LB_Comision#</strong>&nbsp;</td>
	<td  class="tituloListas" valign="top" align="right"><strong>#LB_Vacaciones#</strong>&nbsp;</td>
	<td  class="tituloListas" valign="top" align="right"><strong>#LB_XIII#</strong>&nbsp;</td>
	<td  class="tituloListas" valign="top" align="right"><strong>#LB_SalarioTotal#</strong>&nbsp;</td>
	<td  class="tituloListas" valign="top" align="right"><strong>#LB_ImpuestoRenta#</strong>&nbsp;</td>
	<td  class="tituloListas" valign="top" align="right"><strong>#LB_SeguroSocialEmpleado#</strong>&nbsp;</td>
	<td  class="tituloListas" valign="top" align="right"><strong>#LB_EducacionEmpleado#</strong>&nbsp;</td>
	<td  class="tituloListas" valign="top" align="right"><strong>#LB_CargasSociales#</strong>&nbsp;</td>
	<td  class="tituloListas" valign="top" align="right"><strong>#LB_SalarioNeto#</strong>&nbsp;</td>
	<td  class="tituloListas" valign="top" align="right"><strong>#LB_DeduccionesEmpleado#</strong>&nbsp;</td>
	<td  class="tituloListas" valign="top" align="right"><strong>#LB_PagoTotal#</strong>&nbsp;</td>
</tr>
</cfoutput>
<cfsilent>

	<cfset Lvar_GrandCount = 0>
	<cfset total_salarioporhora				= 0>
	<cfset total_totalhorasregulares		= 0>
	<cfset total_pagototal					= 0>
	<cfset total_tiempoextra				= 0>
	<cfset total_cantidadtiempoextra		= 0>
	<cfset total_horasdomingo				= 0>
	<cfset total_cantidadhorasdomingo		= 0>
	<cfset total_dianacional				= 0>
	<cfset total_cantidaddianacional		= 0>
	<cfset total_ajustes					= 0>
	<cfset total_comision					= 0>
	<cfset total_vacaciones					= 0>
	<cfset total_xiii						= 0>
	<cfset total_salariototal				= 0>
	<cfset total_impuestorenta				= 0>
	<cfset total_segurosocialempleado		= 0>
	<cfset total_educacionempleado			= 0>
	<cfset total_cargassociales				= 0>
	<cfset total_salarioneto				= 0>
	<cfset total_deduccionesempleado		= 0>
	<cfset total_totalpagado				= 0>

</cfsilent>

<cfoutput query="rsReporte" group="CFdescripcion">
	<cfsilent>
		<cfset Lvar_GroupCount 					= 0>
		<cfset total_grupo_salarioporhora		= 0>
		<cfset total_grupo_totalhorasregulares	= 0>
		<cfset total_grupo_pagototal			= 0>	
		<cfset total_grupo_tiempoextra			= 0>
		<cfset total_grupo_cantidadtiempoextra	= 0>
		<cfset total_grupo_horasdomingo			= 0>
		<cfset total_grupo_cantidadhorasdomingo	= 0>				
		<cfset total_grupo_dianacional			= 0>
		<cfset total_grupo_cantidaddianacional	= 0>
		<cfset total_grupo_ajustes				= 0>
		<cfset total_grupo_comision				= 0>
		<cfset total_grupo_vacaciones			= 0>
		<cfset total_grupo_xiii					= 0>
		<cfset total_grupo_salariototal			= 0>
		<cfset total_grupo_impuestorenta		= 0>
		<cfset total_grupo_segurosocialempleado	= 0>
		<cfset total_grupo_educacionempleado	= 0>
		<cfset total_grupo_cargassociales		= 0>
		<cfset total_grupo_salarioneto			= 0>
		<cfset total_grupo_deduccionesempleado	= 0>
		<cfset total_grupo_totalpagado			= 0>

	</cfsilent>
	<tr>
		<td nowrap class="tituloListas" colspan="24"><strong>#rsReporte.CFdescripcion#</strong>&nbsp;</td>
	</tr>
	<cfoutput>
		<tr class="<cfif rsReporte.CurrentRow mod 2>listaPar<cfelse>listaNon</cfif>" <cfif rsReporte.EsNuevo eq 1>style="background-color:yellow;" </cfif>>
			<td nowrap>#rsReporte.Name#</td>
			<td nowrap align="right">#LSCurrencyformat(rsReporte.SalarioPorHora,'none')#&nbsp;&nbsp;</td>
			<td nowrap align="center">#LSDateFormat(rsReporte.Start_Date, 'mm/dd/yyyy')#</td>
			<td nowrap >&nbsp;#rsReporte.id#</td>
			<td nowrap align="right">#LSNumberFormat(rsReporte.TotalHorasRegulares, '.00')#</td>
			<td nowrap align="right">#LSNumberFormat(rsReporte.PagoTotal, ',9.00')#</td>			
			<td nowrap align="right">#LSNumberFormat(rsReporte.TiempoExtra, ',9.00')#</td>			
			<td nowrap align="right">#LSNumberFormat(rsReporte.TotalTiempoExtra, ',9.00')#</td>									
			<td nowrap align="right">#LSNumberFormat(rsReporte.horasdomingo, ',9.00')#</td>			
			<td nowrap align="right">#LSNumberFormat(rsReporte.Totalhorasdomingo, ',9.00')#</td>									
			<td nowrap align="right">#LSNumberFormat(rsReporte.dianacional, ',9.00')#</td>
			<td nowrap align="right">#LSNumberFormat(rsReporte.Totaldianacional, ',9.00')#</td>
			<td nowrap align="right">#LSNumberFormat(rsReporte.Ajustes, ',9.00')#</td>
			<td nowrap align="right">#LSNumberFormat(rsReporte.Comision, ',9.00')#</td>
			<td nowrap align="right">#LSNumberFormat(rsReporte.Vacaciones, ',9.00')#</td>
			<td nowrap align="right">#LSNumberFormat(rsReporte.XIII, ',9.00')#</td>
			<td nowrap align="right">#LSNumberFormat(rsReporte.salariototal, ',9.00')#</td>
			<td nowrap align="right">#LSNumberFormat(rsReporte.impuestorenta, ',9.00')#</td>
			<td nowrap align="right">#LSNumberFormat(rsReporte.segurosocialempleado, ',9.00')#</td>
			<td nowrap align="right">#LSNumberFormat(rsReporte.educacionempleado, ',9.00')#</td>
			<td nowrap align="right">#LSNumberFormat(rsReporte.cargassociales, ',9.00')#</td>
			<td nowrap align="right">#LSNumberFormat(rsReporte.salarioneto, ',9.00')#</td>
			<td nowrap align="right">#LSNumberFormat(rsReporte.deduccionesempleado, ',9.00')#</td>
			<td nowrap align="right">#LSNumberFormat(rsReporte.totalpagado, ',9.00')#</td>
		</tr>
		<cfsilent>
			<cfset Lvar_GrandCount 					= Lvar_GrandCount + 1>
			<cfset Lvar_GroupCount 					= Lvar_GroupCount + 1>

			<cfset total_salarioporhora				= total_salarioporhora + rsReporte.SalarioPorHora >
			<cfset total_totalhorasregulares		= total_totalhorasregulares + rsReporte.TotalHorasRegulares >
			<cfset total_pagototal					= total_pagototal + rsReporte.PagoTotal >
			<cfset total_tiempoextra				= total_tiempoextra + rsReporte.TiempoExtra >
			<cfset total_cantidadtiempoextra		= total_cantidadtiempoextra + rsReporte.totalTiempoExtra >
			<cfset total_horasdomingo				= total_horasdomingo + rsReporte.horasdomingo >
			<cfset total_cantidadhorasdomingo		= total_cantidadhorasdomingo  + rsReporte.totalhorasdomingo >
			<cfset total_dianacional				= total_dianacional + rsReporte.dianacional >
			<cfset total_cantidaddianacional		= total_cantidaddianacional + rsReporte.totaldianacional >
			<cfset total_ajustes					= total_ajustes + rsReporte.ajustes >
			<cfset total_comision					= total_comision + rsReporte.comision >
			<cfset total_vacaciones					= total_vacaciones + rsReporte.vacaciones >
			<cfset total_xiii						= total_xiii + rsReporte.xiii >
			<cfset total_salariototal				= total_salariototal + rsReporte.salariototal >
			<cfset total_impuestorenta				= total_impuestorenta + rsReporte.impuestorenta >
			<cfset total_segurosocialempleado		= total_segurosocialempleado + rsReporte.SeguroSocialEmpleado >
			<cfset total_educacionempleado			= total_educacionempleado + rsReporte.educacionempleado >
			<cfset total_cargassociales				= total_cargassociales + rsReporte.cargassociales >
			<cfset total_salarioneto				= total_salarioneto + rsReporte.salarioneto >
			<cfset total_deduccionesempleado		= total_deduccionesempleado + rsReporte.deduccionesempleado >
			<cfset total_totalpagado				= total_totalpagado + rsReporte.totalpagado >

			<cfset total_grupo_salarioporhora		= total_grupo_salarioporhora + rsReporte.SalarioPorHora >
			<cfset total_grupo_totalhorasregulares	= total_grupo_totalhorasregulares + rsReporte.TotalHorasRegulares >
			<cfset total_grupo_pagototal			= total_grupo_pagototal + rsReporte.PagoTotal >
			<cfset total_grupo_tiempoextra			= total_grupo_tiempoextra + rsReporte.TiempoExtra >
			<cfset total_grupo_cantidadtiempoextra	= total_grupo_cantidadtiempoextra + rsReporte.totalTiempoExtra >
			<cfset total_grupo_horasdomingo			= total_grupo_horasdomingo + rsReporte.horasdomingo >
			<cfset total_grupo_cantidadhorasdomingo	= total_grupo_cantidadhorasdomingo  + rsReporte.totalhorasdomingo >
			<cfset total_grupo_dianacional			= total_grupo_dianacional + rsReporte.dianacional >			
			<cfset total_grupo_cantidaddianacional	= total_grupo_cantidaddianacional + rsReporte.totaldianacional >				
			<cfset total_grupo_ajustes				= total_grupo_ajustes + rsReporte.ajustes >
			<cfset total_grupo_comision				= total_grupo_comision + rsReporte.comision >
			<cfset total_grupo_vacaciones			= total_grupo_vacaciones + rsReporte.vacaciones >	
			<cfset total_grupo_xiii					= total_grupo_xiii + rsReporte.xiii >
			<cfset total_grupo_salariototal			= total_grupo_salariototal + rsReporte.salariototal >
			<cfset total_grupo_impuestorenta		= total_grupo_impuestorenta + rsReporte.impuestorenta >
			<cfset total_grupo_segurosocialempleado	= total_grupo_segurosocialempleado + rsReporte.SeguroSocialEmpleado >
			<cfset total_grupo_educacionempleado	= total_grupo_educacionempleado + rsReporte.educacionempleado >
			<cfset total_grupo_cargassociales		= total_grupo_cargassociales + rsReporte.cargassociales >
			<cfset total_grupo_salarioneto			= total_grupo_salarioneto + rsReporte.salarioneto >
			<cfset total_grupo_deduccionesempleado	= total_grupo_deduccionesempleado + rsReporte.deduccionesempleado >
			<cfset total_grupo_totalpagado			= total_grupo_totalpagado + rsReporte.totalpagado >

		</cfsilent>
	</cfoutput>
	<tr>
		<td nowrap class="tituloListas"><strong><cf_translate key="LB_Total">Total </cf_translate>#rsReporte.CFdescripcion#</strong></td><!--- &nbsp;&nbsp;&nbsp;#Lvar_GroupCount#---->
		<!---<td nowrap class="tituloListas" align="right">#LSNumberFormat(total_grupo_salarioporhora, ',9.00')#</td>---->
		<td nowrap class="tituloListas" align="right" valign="top"><strong>#Lvar_GroupCount#&nbsp;</strong></td>
		<td nowrap class="tituloListas" align="right">&nbsp;</td>
		<td nowrap class="tituloListas" align="right">&nbsp;</td>
		<td nowrap class="tituloListas" align="right">#LSNumberFormat(total_grupo_totalhorasregulares, ',9.00')#</td>
		<td nowrap class="tituloListas" align="right">#LSNumberFormat(total_grupo_pagototal, ',9.00')#</td>
		<td nowrap class="tituloListas" align="right">#LSNumberFormat(total_grupo_tiempoextra, ',9.00')#</td>
		<td nowrap class="tituloListas" align="right">#LSNumberFormat(total_grupo_cantidadtiempoextra, ',9.00')#</td>
		<td nowrap class="tituloListas" align="right">#LSNumberFormat(total_grupo_horasdomingo, ',9.00')#</td>
		<td nowrap class="tituloListas" align="right">#LSNumberFormat(total_grupo_cantidadhorasdomingo, ',9.00')#</td>
		<td nowrap class="tituloListas" align="right">#LSNumberFormat(total_grupo_dianacional, ',9.00')#</td>
		<td nowrap class="tituloListas" align="right">#LSNumberFormat(total_grupo_cantidaddianacional, ',9.00')#</td>
		<td nowrap class="tituloListas" align="right">#LSNumberFormat(total_grupo_ajustes, ',9.00')#</td>
		<td nowrap class="tituloListas" align="right">#LSNumberFormat(total_grupo_comision, ',9.00')#</td>
		<td nowrap class="tituloListas" align="right">#LSNumberFormat(total_grupo_vacaciones, ',9.00')#</td>
		<td nowrap class="tituloListas" align="right">#LSNumberFormat(total_grupo_xiii, ',9.00')#</td>
		<td nowrap class="tituloListas" align="right">#LSNumberFormat(total_grupo_salariototal, ',9.00')#</td>
		<td nowrap class="tituloListas" align="right">#LSNumberFormat(total_grupo_impuestorenta, ',9.00')#</td>
		<td nowrap class="tituloListas" align="right">#LSNumberFormat(total_grupo_segurosocialempleado, ',9.00')#</td>
		<td nowrap class="tituloListas" align="right">#LSNumberFormat(total_grupo_educacionempleado, ',9.00')#</td>
		<td nowrap class="tituloListas" align="right">#LSNumberFormat(total_grupo_cargassociales, ',9.00')#</td>
		<td nowrap class="tituloListas" align="right">#LSNumberFormat(total_grupo_salarioneto, ',9.00')#</td>
		<td nowrap class="tituloListas" align="right">#LSNumberFormat(total_grupo_deduccionesempleado, ',9.00')#</td>
		<td nowrap class="tituloListas" align="right">#LSNumberFormat(total_grupo_totalpagado, ',9.00')#</td>
	</tr>

</cfoutput>

<cfoutput>

<tr>
	<td nowrap class="tituloListas"><strong><cf_translate key="LB_Total"> Total </cf_translate></strong></td><!----&nbsp;&nbsp;&nbsp;#Lvar_GrandCount#---->
	<!----<td nowrap class="tituloListas" align="right">#LSNumberFormat(total_salarioporhora, ',9.00')#</td>----->
	<td nowrap class="tituloListas" align="right" valign="top">#Lvar_GrandCount#&nbsp;</td>
	<td nowrap class="tituloListas" align="right">&nbsp;</td>
	<td nowrap class="tituloListas" align="right">&nbsp;</td>
	<td nowrap class="tituloListas" align="right">#LSNumberFormat(total_totalhorasregulares, ',9.00')#</td>
	<td nowrap class="tituloListas" align="right">#LSNumberFormat(total_pagototal, ',9.00')#</td>
	<td nowrap class="tituloListas" align="right">#LSNumberFormat(total_tiempoextra, ',9.00')#</td>
	<td nowrap class="tituloListas" align="right">#LSNumberFormat(total_cantidadtiempoextra, ',9.00')#</td>
	<td nowrap class="tituloListas" align="right">#LSNumberFormat(total_horasdomingo, ',9.00')#</td>
	<td nowrap class="tituloListas" align="right">#LSNumberFormat(total_cantidadhorasdomingo, ',9.00')#</td>
	<td nowrap class="tituloListas" align="right">#LSNumberFormat(total_dianacional, ',9.00')#</td>
	<td nowrap class="tituloListas" align="right">#LSNumberFormat(total_cantidaddianacional, ',9.00')#</td>
	<td nowrap class="tituloListas" align="right">#LSNumberFormat(total_ajustes, ',9.00')#</td>
	<td nowrap class="tituloListas" align="right">#LSNumberFormat(total_comision, ',9.00')#</td>
	<td nowrap class="tituloListas" align="right">#LSNumberFormat(total_vacaciones, ',9.00')#</td>
	<td nowrap class="tituloListas" align="right">#LSNumberFormat(total_xiii, ',9.00')#</td>
	<td nowrap class="tituloListas" align="right">#LSNumberFormat(total_salariototal, ',9.00')#</td>
	<td nowrap class="tituloListas" align="right">#LSNumberFormat(total_impuestorenta, ',9.00')#</td>
	<td nowrap class="tituloListas" align="right">#LSNumberFormat(total_segurosocialempleado, ',9.00')#</td>
	<td nowrap class="tituloListas" align="right">#LSNumberFormat(total_educacionempleado, ',9.00')#</td>
	<td nowrap class="tituloListas" align="right">#LSNumberFormat(total_cargassociales, ',9.00')#</td>
	<td nowrap class="tituloListas" align="right">#LSNumberFormat(total_salarioneto, ',9.00')#</td>
	<td nowrap class="tituloListas" align="right">#LSNumberFormat(total_deduccionesempleado, ',9.00')#</td>
	<td nowrap class="tituloListas" align="right">#LSNumberFormat(total_totalpagado, ',9.00')#</td>
</tr>

</cfoutput>

<tr><td colspan="24" align="center"><strong><cf_translate key="LB_FinDelReporte"> --Fin Del Reporte-- </cf_translate></strong></td></tr>
</table>