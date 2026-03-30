<!--- Modified with Notepad --->
<cfset Session.DebugInfo = true>
<!--- Pago de Planilla (S.A.) --->
<cfsilent>
	<!--- Invoca el portlet de traduccion y genera algunas 
	variables utilizadas en este componente. --->
	<cfsavecontent variable="pNavegacion">
		<cfinclude template="/home/menu/pNavegacion.cfm">
	</cfsavecontent>
	<!--- Genera variables de traduccion --->
	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		Key="LB_Reporte_de_Planilla_INC"
		Default="#nav__SPdescripcion#"
		returnvariable="LB_Reporte_de_Planilla_INC"/>
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
		Key="LB_Ultimo_Aumento"
		Default="Fecha Ultimo Aumento"
		returnvariable="LB_Ultimo_Aumento"/>
	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		Key="LB_Salario_Anterior"
		Default="Salario Anterior"
		returnvariable="LB_Salario_Anterior"/>

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
		returnvariable="LB_Tarifa_por_horas"/>
	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		Key="LB_Fecha_de_Ingreso"
		Default="Fecha de Ingreso"
		returnvariable="LB_Fecha_de_Ingreso"/>
	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		Key="LB_Horas_Regulares"
		Default="Horas Regulares"
		returnvariable="LB_Horas_Regulares"/>
	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		Key="LB_Horas_de_Feriados"
		Default="Horas de Feriados"
		returnvariable="LB_Horas_de_Feriados"/>
	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		Key="LB_Horas_Totales"
		Default="Horas Totales"
		returnvariable="LB_Horas_Totales"/>
	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		Key="LB_Hr_Totales_y_Salario"
		Default="Hr Totales y Salario"
		returnvariable="LB_Hr_Totales_y_Salario"/>
	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		Key="LB_Salario_por_Feriados"
		Default="Salario por Feriados"
		returnvariable="LB_Salario_por_Feriados"/>
	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		Key="LB_Ajuste_Salario_Mas"
		Default="Ajuste Salario (+)"
		returnvariable="LB_Ajuste_Salario_Mas"/>
	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		Key="LB_Salario_Neto"
		Default="Salario Neto"
		returnvariable="LB_Salario_Neto"/>
	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		Key="LB_Vacaciones_Mas"
		Default="Vacaciones (+)"
		returnvariable="LB_Vacaciones_Mas"/>
	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		Key="LB_Comiciones_Mas"
		Default="Comiciones (+)"
		returnvariable="LB_Comiciones_Mas"/>
	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		Key="LB_Salario_Total"
		Default="Salario Total"
		returnvariable="LB_Salario_Total"/>
	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		Key="LB_CLTBSA_Menos"
		Default="CLTBSA (-)"
		returnvariable="LB_CLTBSA_Menos"/>
	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		Key="LB_Pago_Bruto"
		Default="Pago Bruto"
		returnvariable="LB_Pago_Bruto"/>
	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		Key="LB_Anticipos_Menos"
		Default="Anticipos (-)"
		returnvariable="LB_Anticipos_Menos"/>
	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		Key="LB_Pago_Total"
		Default="Pago Total"
		returnvariable="LB_Pago_Total"/>
		
	<!--- Tabla temporal de calendario de pagos --->
	<cf_dbtemp name="calendario" returnvariable="calendario">
		<cf_dbtempcol name="RCNid"   type="int"          mandatory="yes">
		<cf_dbtempcol name="RCdesde" type="datetime"     mandatory="no">
		<cf_dbtempcol name="RChasta" type="datetime"     mandatory="no">
		<cf_dbtempcol name="Tcodigo" type="char(5)"      mandatory="no">
		<cf_dbtempcol name="FechaPago" type="datetime"   mandatory="no">
		<cf_dbtempkey cols="RCNid">
	</cf_dbtemp>
	<!--- Tabla temporal de resultados --->
	<cf_dbtemp name="salida" returnvariable="salida">
		<cf_dbtempcol name="DEid"     type="int"          mandatory="yes">
		<cf_dbtempcol name="Nombre"   type="char(40)"     mandatory="no">
		<cf_dbtempcol name="EsNuevo"  type="int"          mandatory="no">
		<cf_dbtempcol name="FIngreso" type="char(10)"     mandatory="no">
		<cf_dbtempcol name="MaxFecha" type="datetime"     mandatory="no">
		<cf_dbtempcol name="CFcodigo" type="char(10)"     mandatory="no">
		<cf_dbtempcol name="CFdescripcion" type="char(50)" mandatory="no">
		<cf_dbtempcol name="CFid" 	  type="numeric"	 mandatory="no">				
		<cf_dbtempcol name="TotalHoras" type="float"      mandatory="no">
		<cf_dbtempcol name="THorasOrd" type="float"       mandatory="no">
		<cf_dbtempcol name="HorasFer" type="float"        mandatory="no">
		<cf_dbtempcol name="SalaryVac" type="float"       mandatory="no">
		<cf_dbtempcol name="TotalSalHor" type="money"     mandatory="no">
		<cf_dbtempcol name="TotalHorFer" type="money"     mandatory="no">
		<cf_dbtempcol name="Salary_Holiday" type="money"  mandatory="no">
		<cf_dbtempcol name="Ajustes" type="money"         mandatory="no">
		<cf_dbtempcol name="Neto" type="money"            mandatory="no">
		<cf_dbtempcol name="Vacaciones" type="money"      mandatory="no">
		<cf_dbtempcol name="Comisiones" type="money"      mandatory="no">
		<cf_dbtempcol name="Neto2" type="money"           mandatory="no">
		<cf_dbtempcol name="RebajoSA" type="money"        mandatory="no">
		<cf_dbtempcol name="Neto3" type="money"           mandatory="no">
		<cf_dbtempcol name="Deducciones" type="money"     mandatory="no">
		<cf_dbtempcol name="Deducciones1" type="money"    mandatory="no">
		<cf_dbtempcol name="Liquido" type="money"         mandatory="no">
		<cf_dbtempcol name="Fechas" type="char(50)"       mandatory="no">
		<cf_dbtempcol name="Fechap" type="char(30)"       mandatory="no">
		<cf_dbtempcol name="FechaCamb" type="date"   	  mandatory="no">
		<cf_dbtempcol name="SalAnt" type="money"          mandatory="no">
		<cf_dbtempcol name="Tcodigo"		type="char(5)"		mandatory="no">
		<cf_dbtempcol name="FactorDias" 	type="Varchar(100)"	mandatory="no">
		<cf_dbtempcol name="RHJid" 			type="numeric"		mandatory="no">
		<cf_dbtempcol name="RHJhoradiaria" 	type="money"		mandatory="no">
		<cf_dbtempcol name="Salario" 		type="money"        mandatory="no">
		
		<cf_dbtempkey cols="DEid">
	</cf_dbtemp>
	<!--- Define Form.CPidlist (Puede venir en Form.CPidlist1 o Form.CPidlist2) --->
	<cfif isdefined("form.CPidlist1") and len(trim(form.CPidlist1)) gt 0>
		<cfset form.CPidlist = form.CPidlist1>
	<cfelseif isdefined("form.CPidlist2") and len(trim(form.CPidlist2)) gt 0>
		<cfset form.CPidlist = form.CPidlist2>
	<cfelse>
		<!--- Este error no debe presentarse. --->
		<cfthrow message="Error. Se requiere CPidlist (1 o 2). Proceso Cancelado!">
	</cfif>
	<!--- Obtiene informacion del calendario de pago selecccionado por el usuario. --->
	<cfquery datasource="#session.dsn#">	
	insert #calendario#(RCNid, RCdesde, RChasta, Tcodigo, FechaPago)
	select CPid, CPdesde, CPhasta, Tcodigo, CPfpago
	from CalendarioPagos
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
	and <cf_whereInList Column="CPid" ValueList="#form.CPidlist#" cfsqltype="cf_sql_numeric">
</cfquery>
<cfquery datasource="#session.dsn#">
	/* ====================================
    INSERTA EN LA INFORMACION DE SALIDA, 
    LOS DATOS BASICOS DEL FUNCIONARIO
    ==================================== */
	insert #salida# (DEid, Nombre, CFid, Salario)
	select distinct 	a.DEid, 
			{fn substring(a.DEapellido1 +  '  ' + a.DEapellido2 +  '  ' + a.DEnombre,1,39)},
			Max(f.CFid),
			Max(coalesce(b.LTsalario,0))
	from 	DatosEmpleado a, 
		LineaTiempo b, 
		CalendarioPagos c, 
		RHPlazas p, 
		CFuncional f, 	
		#calendario# x
	where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
		and a.DEid = b.DEid
		and b.Tcodigo = x.Tcodigo 
		and c.Ecodigo = a.Ecodigo
		and c.Tcodigo = b.Tcodigo
		and c.CPid = x.RCNid
		and ((b.LThasta >= x.RCdesde and b.LTdesde <= x.RChasta) or (b.LTdesde <= x.RChasta and b.LThasta >= x.RCdesde))
		and b.RHPid = p.RHPid
		and p.CFid = f.CFid
	Group by a.DEid, 
			{fn substring(a.DEapellido1 +  '  ' + a.DEapellido2 +  '  ' + a.DEnombre,1,39)}
	/* ==================================
	 ACTUALIZA LA INFORMACION CON LA FECHA DE INGRESO DE LOS FUNCIONARIOS
	 COLUMNA START DATE
	 ==================================*/
	update #salida#
	set FIngreso = (select convert(char, EVfantig, 101) from EVacacionesEmpleado a where a.DEid = #salida#.DEid)
	
	update #salida#
	set CFcodigo = (select CFcodigo from CFuncional Where CFid= #salida#.CFid),
		CFdescripcion = (select CFdescripcion from CFuncional Where CFid= #salida#.CFid)
	
	update #salida#
	set TotalHoras=0,
		THorasOrd=0,
		HorasFer=0,
		SalaryVac=0,
		TotalSalHor=0,
		TotalHorFer=0,
		Salary_Holiday=0,
		Ajustes=0,
		Neto=0,
		Vacaciones=0,
		Comisiones=0,
		Neto2=0,
		RebajoSA=0,
		Neto3=0,
		Deducciones=0,
		Deducciones1=0,
		Liquido=0
</cfquery>

<!--- Decide si se buscan los datos en las tablas de trabajo o en las historicas --->
<cfif not isdefined('form.tiponomina')>
	<cfquery datasource="#session.dsn#">
		/* ==================================
		   TRABAJA CON LOS DATOS DE LA NOMINA SIN CERRAR
		    ==================================*/
		/* ===============================
		     actualizo a Horas a quienes se les paga por Hora 
		     COLUMNA Regular_Hours  
		    ===============================*/
		update #salida# set
		MaxFecha = (Select coalesce(Max(c.RCdesde), getdate())
					from #calendario# a,
						 SalarioEmpleado b,
						 RCalculoNomina c
					Where b.RCNid=c.RCNid
					and b.DEid=#salida#.DEid
					and b.RCNid=a.RCNid
					and c.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
					)
				    
		update #salida#
		set THorasOrd = coalesce((select sum(ICvalor)
				 from IncidenciasCalculo a, #calendario# x 
				where a.DEid = #salida#.DEid 
				and a.RCNid = x.RCNid 
				and CIid in (select distinct a.CIid
								from RHReportesNomina c
									inner join RHColumnasReporte b
												inner join RHConceptosColumna a
												on a.RHCRPTid = b.RHCRPTid
										 on b.RHRPTNid = c.RHRPTNid
										and b.RHCRPTcodigo = 'THorasOrd'
								where c.RHRPTNcodigo = 'INC'
								  and c.Ecodigo = #session.Ecodigo#)),0)
		where exists (
			select 1 
			from IncidenciasCalculo a, #calendario# x 
			where a.DEid = #salida#.DEid 
			and a.RCNid = x.RCNid 
			and CIid in (select distinct a.CIid
								from RHReportesNomina c
									inner join RHColumnasReporte b
												inner join RHConceptosColumna a
												on a.RHCRPTid = b.RHCRPTid
										 on b.RHRPTNid = c.RHRPTNid
										and b.RHCRPTcodigo = 'THorasOrd'
								where c.RHRPTNcodigo = 'INC'
								  and c.Ecodigo = #session.Ecodigo#))

		/* ===============================
		    Monto pagado por Horas Trabajadas
		    COLUMNA Total_Hr_Salary 
		    ===============================*/
		update #salida#
		set TotalSalHor =  (select coalesce(sum(a.ICmontores),0) 
				    from IncidenciasCalculo a, #calendario# x 
				    where a.DEid = #salida#.DEid 
				    and a.RCNid = x.RCNid 
				    and CIid  in (select distinct a.CIid
								from RHReportesNomina c
									inner join RHColumnasReporte b
												inner join RHConceptosColumna a
												on a.RHCRPTid = b.RHCRPTid
										 on b.RHRPTNid = c.RHRPTNid
										and b.RHCRPTcodigo = 'TotalSalHor'
								where c.RHRPTNcodigo = 'INC'
								  and c.Ecodigo = #session.Ecodigo#))
		where exists (
			select 1 
			from IncidenciasCalculo a, #calendario# x 
			where a.DEid = #salida#.DEid 

			and a.RCNid = x.RCNid 
			and CIid  in (select distinct a.CIid
								from RHReportesNomina c
									inner join RHColumnasReporte b
												inner join RHConceptosColumna a
												on a.RHCRPTid = b.RHCRPTid
										 on b.RHRPTNid = c.RHRPTNid
										and b.RHCRPTcodigo = 'TotalSalHor'
								where c.RHRPTNcodigo = 'INC'
								  and c.Ecodigo = #session.Ecodigo#))

		/* ===============================
		A los Empleados por Salario Fijo 
		se les Rebaja de su Salario Base el Monto que se les Rebajo
		 por Vacaciones, para mostrar este dato en un otra columna
		===============================*/
		update #salida#
		set SalaryVac = coalesce((select sum(a.ICmontores) 
					     from IncidenciasCalculo a, #calendario# x 
					    where a.DEid = #salida#.DEid 
					    and a.RCNid = x.RCNid 
					     and CIid in (select distinct a.CIid
								from RHReportesNomina c
									inner join RHColumnasReporte b
												inner join RHConceptosColumna a
												on a.RHCRPTid = b.RHCRPTid
										 on b.RHRPTNid = c.RHRPTNid
										and b.RHCRPTcodigo = 'SalaryVac'
								where c.RHRPTNcodigo = 'INC'
								  and c.Ecodigo = #session.Ecodigo#)),0)
		where THorasOrd = 0

		
		/* ===============================
		    Cantidad de Horas Laboradas  
		    Columna Hourly_Rate 
		    ===============================*/
		update #salida#
		set TotalHoras = TotalSalHor / THorasOrd
		where THorasOrd > 0

		/* ===============================
		Actualiza la Columna de Salarios para los Empleados Fijos con lo Ganado en la Bisemana por Salario Nominal 
		COLUMNA Total_Hr_Salary 
		===============================*/
		update #salida#

		set TotalSalHor = coalesce((select sum(a.PEmontores) 
					from PagosEmpleado a, #calendario# x 
					where a.DEid = #salida#.DEid 
					and a.RCNid = x.RCNid),0) 
		where THorasOrd = 0
	
		/* ===============================
		     Actualiza la Columna Total de Horas  para los Empleados Fijos con lo Ganado en la Bisemana por Salario Nominal 
		    Columna Hourly_Rate 
		    ===============================*/
		update #salida#
		set TotalHoras = TotalSalHor
		where TotalHoras = 0


		/* ===============================
		   Actualiza la Columna de Monto de  Feriado con el Monto Pagado por la Incidencia 
		   Columna Salary_Holiday
		    ===============================*/
		update #salida#
		set Salary_Holiday = coalesce((select sum(a.ICmontores) 
					     from IncidenciasCalculo a, #calendario# x 
					    where a.DEid = #salida#.DEid 
					    and a.RCNid = x.RCNid 
					     and CIid in (select distinct a.CIid
								from RHReportesNomina c
									inner join RHColumnasReporte b
												inner join RHConceptosColumna a
												on a.RHCRPTid = b.RHCRPTid
										 on b.RHRPTNid = c.RHRPTNid
										and b.RHCRPTcodigo = 'Salary_Holiday'
								where c.RHRPTNcodigo = 'INC'
								  and c.Ecodigo = #session.Ecodigo#) ),0)

		/* ===============================
		   Actualiza la Columna Horas del Feriado Dividiendo el Monto Pagodo entre la Cantidad de Horas Pagadas
		   COLUMNA Holiday_Hours  
		    ===============================*/
		update #salida#
		set HorasFer = Salary_Holiday / TotalHoras where TotalHoras >  0


		/* ===============================
		     Suma una Serie de Incidencias que determinaran la Columnas de Adjustments, Excluyendo algunas Incidencias
		  Paso 1 COLUMNA Pay_Adjust
		    ===============================*/
		update #salida#
		set Deducciones1 = 
		coalesce((
		select sum(a.DCvalor) from DeduccionesCalculo a, DeduccionesEmpleado b, #calendario# x
					where a.DEid = #salida#.DEid 
							and a.RCNid = x.RCNid 
							and a.DEid = b.DEid
							and a.Did = b.Did
							and b.TDid  in (select distinct a.TDid
								from RHReportesNomina c
									inner join RHColumnasReporte b
												inner join RHConceptosColumna a
												on a.RHCRPTid = b.RHCRPTid
										 on b.RHRPTNid = c.RHRPTNid
										and b.RHCRPTcodigo = 'Deducciones1'
								where c.RHRPTNcodigo = 'INC'
								  and c.Ecodigo = #session.Ecodigo#)
							),0)

		/* ===============================
		     Suma una Serie de Incidencias que determinaran la Columnas de Adjustments, Excluyendo algunas Incidencias
		  Paso 2 COLUMNA Pay_Adjust
		    ===============================*/
		update #salida#
		set Ajustes = coalesce((
					select sum(a.ICmontores) 
					from IncidenciasCalculo a, #calendario# x 
					where a.DEid = #salida#.DEid 
					and a.RCNid = x.RCNid 
					and CIid  in (select distinct a.CIid
								from RHReportesNomina c
									inner join RHColumnasReporte b
												inner join RHConceptosColumna a
												on a.RHCRPTid = b.RHCRPTid
										 on b.RHRPTNid = c.RHRPTNid
										and b.RHCRPTcodigo = 'Ajustes'
								where c.RHRPTNcodigo = 'INC'
								  and c.Ecodigo = #session.Ecodigo#)),0)
		/* ===============================
		     Suma una Serie de Incidencias que determinaran la Columnas de Adjustments, Excluyendo algunas Incidencias
		  Paso FINAL COLUMNA Pay_Adjust
		    ===============================*/
		update #salida#	set Ajustes = Ajustes - Deducciones1

		/* ===============================
		     Es la Suma de Total de Salario por Horas + los Ajustes 
		     COLUMNA Net_Pay 
		    ===============================*/
		update #salida# 
		set Neto = TotalSalHor + Salary_Holiday + Ajustes+ SalaryVac


		/* ===============================
		    Es la Suma de las Incidencias que pagan Vacaciones
		   COLUMNA Vacations 
		   ===============================*/
		update #salida#
		set Vacaciones = coalesce(( select sum(a.ICmontores) 
					from IncidenciasCalculo a, #calendario# x 
					where a.DEid = #salida#.DEid 
					and a.RCNid = x.RCNid 
					and CIid in (select distinct a.CIid
								from RHReportesNomina c
									inner join RHColumnasReporte b
												inner join RHConceptosColumna a
												on a.RHCRPTid = b.RHCRPTid
										 on b.RHRPTNid = c.RHRPTNid
										and b.RHCRPTcodigo = 'Vacaciones'
								where c.RHRPTNcodigo = 'INC'
								  and c.Ecodigo = #session.Ecodigo#)),0)

		/* ===============================
		   A LAS PERSONAS QUE TIENEN SALARIO FIJO
		 SE LES MUESTRA EL MONTO QUE SE LES PAGO POR DICHO CONCEPTO SIN REBAJAR LO NEG
		   ===============================*/
		update #salida#
		set Vacaciones = isnull(( select sum(a.ICmontores) 
					from IncidenciasCalculo a, #calendario# x 
					where a.DEid = #salida#.DEid 
					and a.RCNid = x.RCNid 
					and CIid in (select distinct a.CIid
								from RHReportesNomina c
									inner join RHColumnasReporte b
												inner join RHConceptosColumna a
												on a.RHCRPTid = b.RHCRPTid
										 on b.RHRPTNid = c.RHRPTNid
										and b.RHCRPTcodigo = 'Vacaciones2'
								where c.RHRPTNcodigo = 'INC'
								  and c.Ecodigo = #session.Ecodigo#)),0) 
		where THorasOrd = 0

		
		/* ===============================
		     Es la Suma de las Incidencias que pagan Comisiones 
		     COLUMNA Comm 
		     ===============================*/
		update #salida#
		set Comisiones = coalesce(( select sum(a.ICmontores) 
					from IncidenciasCalculo a, #calendario# x 
					where a.DEid = #salida#.DEid 
					and a.RCNid = x.RCNid 
					and CIid in (select distinct a.CIid
								from RHReportesNomina c
									inner join RHColumnasReporte b
												inner join RHConceptosColumna a
												on a.RHCRPTid = b.RHCRPTid
										 on b.RHRPTNid = c.RHRPTNid
										and b.RHCRPTcodigo = 'Comisiones'
								where c.RHRPTNcodigo = 'INC'
								  and c.Ecodigo = #session.Ecodigo#)),0)

		/* ===============================
		     Es la Suma de Total Neto + Vacaciones + Comisiones 
		     COLUMNA Total_Pay 
		     ===============================*/
		update #salida# 
		set Neto2 = Neto + Vacaciones + Comisiones

		/* ===============================
		    Valor de la Incidencia SA (utilizada para el Traslado de Incidencias entre Empresas) 
		    COLUMNA CLTBSA
		    ===============================*/
		update #salida#
		set RebajoSA = coalesce((select sum(a.ICmontores)*-1 
				          from IncidenciasCalculo a, #calendario# x 
				          where a.DEid = #salida#.DEid 
				          and a.RCNid = x.RCNid 
				          and CIid in (select distinct a.CIid
								from RHReportesNomina c
									inner join RHColumnasReporte b
												inner join RHConceptosColumna a
												on a.RHCRPTid = b.RHCRPTid
										 on b.RHRPTNid = c.RHRPTNid
										and b.RHCRPTcodigo = 'RebajoSA'
								where c.RHRPTNcodigo = 'INC'
								  and c.Ecodigo = #session.Ecodigo#) ),0)

		/* ===============================
		   Al Total Neto2 le resto lo pagado por la Incidencia SA 
		   COLUMNA Gross_Pay 
		    ===============================*/
		update #salida# 
		set Neto3 = Neto2 - RebajoSA

		/* ===============================
		    Suma de Deducciones 
		    COLUMNA EE_Advance
		    ===============================*/
		update #salida#
		set Deducciones = 
			coalesce((
			select sum(a.DCvalor) 
			from DeduccionesCalculo a, DeduccionesEmpleado b, #calendario# x
			where a.DEid = #salida#.DEid 
			and a.RCNid = x.RCNid 
			and a.DEid = b.DEid
			and a.Did = b.Did
			and b.TDid in (select distinct a.TDid
								from RHReportesNomina c
									inner join RHColumnasReporte b
												inner join RHConceptosColumna a
												on a.RHCRPTid = b.RHCRPTid
										 on b.RHRPTNid = c.RHRPTNid
										and b.RHCRPTcodigo = 'Deducciones'
								where c.RHRPTNcodigo = 'INC'
								  and c.Ecodigo = #session.Ecodigo#)
			),0)
	</cfquery>
<cfelse> <!--- Nominas Cerradas --->

	<cfquery datasource="#session.dsn#">
		/* ===============================
		     actualizo a Horas a quienes se les paga por Hora 
		     COLUMNA Regular_Hours  
		    ===============================*/
		update #salida# set
		MaxFecha = (Select coalesce(Max(c.RCdesde),getdate())
					from #calendario# a,
						 HSalarioEmpleado b,
						 HRCalculoNomina c
					Where b.RCNid=c.RCNid
					and b.DEid=#salida#.DEid
					and b.RCNid=a.RCNid
					)	
	</cfquery>	

	
	<cfquery datasource="#session.dsn#">
		update #salida#
		set THorasOrd = coalesce((select sum(ICvalor)
				 from HIncidenciasCalculo a, #calendario# x 
				where a.DEid = #salida#.DEid 
				and a.RCNid = x.RCNid 
				and CIid in (select distinct a.CIid
								from RHReportesNomina c
									inner join RHColumnasReporte b
												inner join RHConceptosColumna a
												on a.RHCRPTid = b.RHCRPTid
										 on b.RHRPTNid = c.RHRPTNid
										and b.RHCRPTcodigo = 'THorasOrd'
								where c.RHRPTNcodigo = 'INC'
								  and c.Ecodigo = #session.Ecodigo#)),0)
		where exists (
			select 1 
			from HIncidenciasCalculo a, #calendario# x 
			where a.DEid = #salida#.DEid 
			and a.RCNid = x.RCNid 
			and CIid in (select distinct a.CIid
								from RHReportesNomina c
									inner join RHColumnasReporte b
												inner join RHConceptosColumna a
												on a.RHCRPTid = b.RHCRPTid
										 on b.RHRPTNid = c.RHRPTNid
										and b.RHCRPTcodigo = 'THorasOrd'
								where c.RHRPTNcodigo = 'INC'
								  and c.Ecodigo = #session.Ecodigo#))

		/* ===============================
		    Monto pagado por Horas Trabajadas
		    COLUMNA Total_Hr_Salary 
		    ===============================*/
		update #salida#
		set TotalSalHor =  (select coalesce(sum(a.ICmontores),0) 
				    from HIncidenciasCalculo a, #calendario# x 
				    where a.DEid = #salida#.DEid 
				    and a.RCNid = x.RCNid 
				    and CIid  in (select distinct a.CIid
								from RHReportesNomina c
									inner join RHColumnasReporte b
												inner join RHConceptosColumna a
												on a.RHCRPTid = b.RHCRPTid
										 on b.RHRPTNid = c.RHRPTNid
										and b.RHCRPTcodigo = 'TotalSalHor'
								where c.RHRPTNcodigo = 'INC'
								  and c.Ecodigo = #session.Ecodigo#))
		where exists (
			select 1 
			from HIncidenciasCalculo a, #calendario# x 
			where a.DEid = #salida#.DEid 

			and a.RCNid = x.RCNid 
			and CIid  in (select distinct a.CIid
								from RHReportesNomina c
									inner join RHColumnasReporte b
												inner join RHConceptosColumna a
												on a.RHCRPTid = b.RHCRPTid
										 on b.RHRPTNid = c.RHRPTNid
										and b.RHCRPTcodigo = 'TotalSalHor'
								where c.RHRPTNcodigo = 'INC'
								  and c.Ecodigo = #session.Ecodigo#))

		/* ===============================
		A los Empleados por Salario Fijo 
		se les Rebaja de su Salario Base el Monto que se les Rebajo
		 por Vacaciones, para mostrar este dato en un otra columna
		===============================*/
		update #salida#
		set SalaryVac = isnull((select sum(a.ICmontores) 
					     from HIncidenciasCalculo a, #calendario# x 
					    where a.DEid = #salida#.DEid 
					    and a.RCNid = x.RCNid 
					     and CIid in (select distinct a.CIid
								from RHReportesNomina c
									inner join RHColumnasReporte b
												inner join RHConceptosColumna a
												on a.RHCRPTid = b.RHCRPTid
										 on b.RHRPTNid = c.RHRPTNid
										and b.RHCRPTcodigo = 'SalaryVac'
								where c.RHRPTNcodigo = 'INC'
								  and c.Ecodigo = #session.Ecodigo#)),0)
		where THorasOrd = 0
		
		/* ===============================
		    Cantidad de Horas Laboradas  
		    Columna Hourly_Rate 
		    ===============================*/
		update #salida#
		set TotalHoras = TotalSalHor / THorasOrd
		where THorasOrd > 0

		/* ===============================
		Actualiza la Columna de Salarios para los Empleados Fijos con lo Ganado en la Bisemana por Salario Nominal 
		COLUMNA Total_Hr_Salary 
		===============================*/
		update #salida#

		set TotalSalHor = coalesce((select sum(a.PEmontores) 
					from HPagosEmpleado a, #calendario# x 
					where a.DEid = #salida#.DEid 
					and a.RCNid = x.RCNid),0) 
		where THorasOrd = 0
	
		/* ===============================
		     Actualiza la Columna Total de Horas  para los Empleados Fijos con lo Ganado en la Bisemana por Salario Nominal 
		    Columna Hourly_Rate 
		    ===============================*/
		update #salida#
		set TotalHoras = TotalSalHor
		where TotalHoras = 0


		/* ===============================
		   Actualiza la Columna de Monto de  Feriado con el Monto Pagado por la Incidencia 
		   Columna Salary_Holiday
		    ===============================*/
		update #salida#
		set Salary_Holiday = coalesce((select sum(a.ICmontores) 
					     from HIncidenciasCalculo a, #calendario# x 
					    where a.DEid = #salida#.DEid 
					    and a.RCNid = x.RCNid 
					     and CIid in (select distinct a.CIid
								from RHReportesNomina c
									inner join RHColumnasReporte b
												inner join RHConceptosColumna a
												on a.RHCRPTid = b.RHCRPTid
										 on b.RHRPTNid = c.RHRPTNid
										and b.RHCRPTcodigo = 'Salary_Holiday'
								where c.RHRPTNcodigo = 'INC'
								  and c.Ecodigo = #session.Ecodigo#) ),0)

		/* ===============================
		   Actualiza la Columna Horas del Feriado Dividiendo el Monto Pagodo entre la Cantidad de Horas Pagadas
		   COLUMNA Holiday_Hours  

		    ===============================*/
		update #salida#
		set HorasFer = Salary_Holiday / TotalHoras where TotalHoras >  0


		/* ===============================
		     Suma una Serie de Incidencias que determinaran la Columnas de Adjustments, Excluyendo algunas Incidencias
		  Paso 1 COLUMNA Pay_Adjust
		    ===============================*/
		update #salida#
		set Deducciones1 = 
		coalesce((
		select sum(a.DCvalor) from HDeduccionesCalculo a, DeduccionesEmpleado b, #calendario# x
					where a.DEid = #salida#.DEid 
							and a.RCNid = x.RCNid 
							and a.DEid = b.DEid
							and a.Did = b.Did
							and b.TDid  in (select distinct a.TDid
								from RHReportesNomina c
									inner join RHColumnasReporte b
												inner join RHConceptosColumna a
												on a.RHCRPTid = b.RHCRPTid
										 on b.RHRPTNid = c.RHRPTNid
										and b.RHCRPTcodigo = 'Deducciones1'
								where c.RHRPTNcodigo = 'INC'
								  and c.Ecodigo = #session.Ecodigo#)
							),0)

		/* ===============================
		     Suma una Serie de Incidencias que determinaran la Columnas de Adjustments, Excluyendo algunas Incidencias
		  Paso 2 COLUMNA Pay_Adjust
		    ===============================*/
		update #salida#
		set Ajustes = coalesce((
					select sum(a.ICmontores) 
					from HIncidenciasCalculo a, #calendario# x 
					where a.DEid = #salida#.DEid 
					and a.RCNid = x.RCNid 
					and CIid  in (select distinct a.CIid
								from RHReportesNomina c
									inner join RHColumnasReporte b
												inner join RHConceptosColumna a
												on a.RHCRPTid = b.RHCRPTid
										 on b.RHRPTNid = c.RHRPTNid
										and b.RHCRPTcodigo = 'Ajustes'
								where c.RHRPTNcodigo = 'INC'
								  and c.Ecodigo = #session.Ecodigo#)),0)
		/* ===============================
		     Suma una Serie de Incidencias que determinaran la Columnas de Adjustments, Excluyendo algunas Incidencias
		  Paso FINAL COLUMNA Pay_Adjust
		    ===============================*/
		update #salida#	set Ajustes = Ajustes - Deducciones1

		/* ===============================
		     Es la Suma de Total de Salario por Horas + los Ajustes 
		     COLUMNA Net_Pay 
		    ===============================*/
		update #salida# 
		set Neto = TotalSalHor + Salary_Holiday + Ajustes+ SalaryVac


		/* ===============================
		    Es la Suma de las Incidencias que pagan Vacaciones
		   COLUMNA Vacations 
		   ===============================*/
		update #salida#
		set Vacaciones = coalesce(( select sum(a.ICmontores) 
					from HIncidenciasCalculo a, #calendario# x 
					where a.DEid = #salida#.DEid 
					and a.RCNid = x.RCNid 
					and CIid in (select distinct a.CIid
								from RHReportesNomina c
									inner join RHColumnasReporte b
												inner join RHConceptosColumna a
												on a.RHCRPTid = b.RHCRPTid
										 on b.RHRPTNid = c.RHRPTNid
										and b.RHCRPTcodigo = 'Vacaciones'
								where c.RHRPTNcodigo = 'INC'
								  and c.Ecodigo = #session.Ecodigo#)),0)

		/* ===============================
		   A LAS PERSONAS QUE TIENEN SALARIO FIJO
		 SE LES MUESTRA EL MONTO QUE SE LES PAGO POR DICHO CONCEPTO SIN REBAJAR LO NEG
		   ===============================*/
		update #salida#
		set Vacaciones = isnull(( select sum(a.ICmontores) 
					from HIncidenciasCalculo a, #calendario# x 
					where a.DEid = #salida#.DEid 
					and a.RCNid = x.RCNid 
					and CIid in (select distinct a.CIid
								from RHReportesNomina c
									inner join RHColumnasReporte b
												inner join RHConceptosColumna a
												on a.RHCRPTid = b.RHCRPTid
										 on b.RHRPTNid = c.RHRPTNid
										and b.RHCRPTcodigo = 'Vacaciones2'
								where c.RHRPTNcodigo = 'INC'
								  and c.Ecodigo = #session.Ecodigo#)
					),0) 
		where THorasOrd = 0

		
		/* ===============================
		     Es la Suma de las Incidencias que pagan Comisiones 
		     COLUMNA Comm 
		     ===============================*/
		update #salida#
		set Comisiones = coalesce(( select sum(a.ICmontores) 
					from HIncidenciasCalculo a, #calendario# x 
					where a.DEid = #salida#.DEid 
					and a.RCNid = x.RCNid 
					and CIid in (select distinct a.CIid
								from RHReportesNomina c
									inner join RHColumnasReporte b
												inner join RHConceptosColumna a
												on a.RHCRPTid = b.RHCRPTid
										 on b.RHRPTNid = c.RHRPTNid
										and b.RHCRPTcodigo = 'Comisiones'
								where c.RHRPTNcodigo = 'INC'
								  and c.Ecodigo = #session.Ecodigo#)),0)

		/* ===============================
		     Es la Suma de Total Neto + Vacaciones + Comisiones 
		     COLUMNA Total_Pay 
		     ===============================*/
		update #salida# 
		set Neto2 = Neto + Vacaciones + Comisiones

		/* ===============================
		    Valor de la Incidencia SA (utilizada para el Traslado de Incidencias entre Empresas) 
		    COLUMNA CLTBSA
		    ===============================*/
		update #salida#
		set RebajoSA = coalesce((select sum(a.ICmontores)*-1 
				          from HIncidenciasCalculo a, #calendario# x 
				          where a.DEid = #salida#.DEid 
				          and a.RCNid = x.RCNid 
				          and CIid in (select distinct a.CIid
								from RHReportesNomina c
									inner join RHColumnasReporte b
												inner join RHConceptosColumna a
												on a.RHCRPTid = b.RHCRPTid
										 on b.RHRPTNid = c.RHRPTNid
										and b.RHCRPTcodigo = 'RebajoSA'
								where c.RHRPTNcodigo = 'INC'
								  and c.Ecodigo = #session.Ecodigo#) ),0)

		/* ===============================
		   Al Total Neto2 le resto lo pagado por la Incidencia SA 
		   COLUMNA Gross_Pay 
		    ===============================*/
		update #salida# 
		set Neto3 = Neto2 - RebajoSA

		/* ===============================
		    Suma de Deducciones 
		    COLUMNA EE_Advance
		    ===============================*/
		update #salida#
		set Deducciones = 
			coalesce((
			select sum(a.DCvalor) 
			from HDeduccionesCalculo a, DeduccionesEmpleado b, #calendario# x
			where a.DEid = #salida#.DEid 
			and a.RCNid = x.RCNid 
			and a.DEid = b.DEid
			and a.Did = b.Did
			and b.TDid in (select distinct a.TDid
								from RHReportesNomina c
									inner join RHColumnasReporte b
												inner join RHConceptosColumna a
												on a.RHCRPTid = b.RHCRPTid
										 on b.RHRPTNid = c.RHRPTNid
										and b.RHCRPTcodigo = 'Deducciones'
								where c.RHRPTNcodigo = 'INC'
								  and c.Ecodigo = #session.Ecodigo#)
			),0)
	</cfquery>
</cfif>

	<!---actualiza salario Anterior--->
	<cfquery datasource="#session.dsn#">						 
		update #salida#
		set SalAnt = (select b.LTsalario as LTsalarioA 
								from LineaTiempo a, 
								     LineaTiempo b, 
								     #calendario# x,
								     HSalarioEmpleado hse 
								Where a.DEid=#salida#.DEid 
									and a.Ecodigo = #session.Ecodigo#
									and b.Ecodigo = #session.Ecodigo#
								    and a.DEid=b.DEid 
								    and #salida#.MaxFecha between a.LTdesde and a.LThasta 
								    and b.LTdesde < a.LTdesde 
								    and b.LTsalario <> a.LTsalario
								    and b.LTdesde = (select max(c.LTdesde) 
								                     from LineaTiempo c 
								                     Where a.DEid=c.DEid 
													 and c.Ecodigo = #session.Ecodigo#								                     
								                     and c.LTdesde < a.LTdesde 
								                     and c.LTsalario <> a.LTsalario )
								union
								select  a.LTsalario as LTsalarioA 
								from LineaTiempo a 
								Where a.DEid=#salida#.DEid
								    and #salida#.MaxFecha between a.LTdesde and a.LThasta 
									and a.Ecodigo = #session.Ecodigo#								    
								    and not exists(Select 1 
								                   from LineaTiempo a, 
								                        LineaTiempo b 
								                   Where a.DEid=#salida#.DEid
														and a.Ecodigo = #session.Ecodigo#								                   
														and b.Ecodigo = #session.Ecodigo#														
								                       and a.DEid=b.DEid and 
								                       #salida#.MaxFecha between a.LTdesde and a.LThasta 
								                       and b.LTdesde < a.LTdesde 
								                       and b.LTsalario <> a.LTsalario)
						)																

	</cfquery>	

	<!---actualiza fecha ultimo aumento--->	


	<cfquery datasource="#session.dsn#">		
  /*Fecha cAmbio Ultimo Salario a la FEcha de la Nomina en base al Salario Actual al momento de la nomina*/				 
		update #salida#
		set FechaCamb = coalesce(
									(Select Min(LTdesde)
									 from LineaTiempo a 
									 inner join HSalarioEmpleado b
									 	on a.DEid=b.DEid
									 inner join  CalendarioPagos c
									 	on c.CPid=b.RCNid
									 Where #salida#.DEid=a.DEid
									 	and a.Ecodigo=#session.Ecodigo#
									 	and a.LTsalario=#salida#.Salario
<!---									 	and a.LTdesde <= c.CPhasta  				--->
									 	and LTdesde > coalesce((Select Max(DLfvigencia)
									 				   from DLaboralesEmpleado aa
									 				   		inner join RHTipoAccion bb
									 				  	 	on aa.RHTid=bb.RHTid
									 				   Where bb.RHTcomportam=2
									 				   and a.DEid = aa.DEid
									 				   and aa.DLfvigencia <= c.CPhasta)
									 				   , (Select EVfantig 
									 				      from EVacacionesEmpleado xx 
									 				      Where a.DEid=xx.DEid))
						 				   
						 				    
						 ), (Select EVfantig
						 	 from EVacacionesEmpleado d
						 	 Where  #salida#.DEid=d.DEid)
						 )
						 
		
						 
	</cfquery>
	 
	<!---actualiza jornada Anterior--->
	<cfquery datasource="#session.dsn#">					 
		update #salida#
			set RHJid = (select coalesce(dl.RHJidant,dl.RHJid) 
						from  RHTipoAccion  a, DLaboralesEmpleado dl
						  where  a.RHTcomportam in (1,6,8)
								and a.Ecodigo = #session.Ecodigo#
								and dl.DLsalario <>  coalesce(dl.DLsalarioant,0)
								and a.RHTid = dl.RHTid
								and dl.DEid = #salida#.DEid 
						  and dl.DLfvigencia = (select max(dl1.DLfvigencia)  
										from  RHTipoAccion  a1, DLaboralesEmpleado dl1
											  where  a1.RHTcomportam in (1,6,8)
													and a1.Ecodigo = #session.Ecodigo#
													and dl1.DLsalario <>  coalesce(dl1.DLsalarioant,0)
													and a1.RHTid = dl1.RHTid
													and dl1.DEid  = #salida#.DEid)
							and dl.DLconsecutivo = (select max(dl2.DLconsecutivo)  
										from  RHTipoAccion  a2, DLaboralesEmpleado dl2
											  where  a2.RHTcomportam in (1,6,8)
													and a2.Ecodigo = #session.Ecodigo#
													and dl2.DLsalario <>  coalesce(dl2.DLsalarioant,0)
													and a2.RHTid = dl2.RHTid
													and dl2.DEid  = #salida#.DEid))
						 
	</cfquery>

	<!---actualiza jornada Anterior--->
	<cfquery datasource="#session.dsn#">					 
		update #salida#
			set Tcodigo = (select coalesce(dl.Tcodigoant,dl.Tcodigo) 
						from  RHTipoAccion  a, DLaboralesEmpleado dl
						  where  a.RHTcomportam in (1,6,8)
								and a.Ecodigo = #session.Ecodigo#
								and dl.DLsalario <>  coalesce(dl.DLsalarioant,0)   
								and a.RHTid = dl.RHTid
								and dl.DEid = #salida#.DEid 
						  and dl.DLfvigencia = (select max(dl1.DLfvigencia)  
										from  RHTipoAccion  a1, DLaboralesEmpleado dl1
											  where  a1.RHTcomportam in (1,6,8)
													and a1.Ecodigo = #session.Ecodigo#
													and dl1.DLsalario <>  coalesce(dl1.DLsalarioant,0)   
													and a1.RHTid = dl1.RHTid
													and dl1.DEid  = #salida#.DEid)
							and dl.DLconsecutivo = (select max(dl2.DLconsecutivo)  
										from  RHTipoAccion  a2, DLaboralesEmpleado dl2
											  where  a2.RHTcomportam in (1,6,8)
													and a2.Ecodigo = #session.Ecodigo#
													and dl2.DLsalario <>  coalesce(dl2.DLsalarioant,0)   
													and a2.RHTid = dl2.RHTid
													and dl2.DEid  = #salida#.DEid))
						 
	</cfquery>

	<cfquery datasource="#session.dsn#" name="x">
		update #salida#
		set FactorDias = (select FactorDiasSalario 
							from TiposNomina 
							where Ecodigo = #session.Ecodigo# 
								and Tcodigo = #salida#.Tcodigo)
	</cfquery>	
	
	
	<cfquery datasource="#session.dsn#" name="x">
		update #salida#
		set RHJhoradiaria = (select RHJhoradiaria
							from RHJornadas 
							where Ecodigo = #session.Ecodigo# 
								and RHJid = #salida#.RHJid)
	</cfquery>		
	
	
	<cfquery datasource="#session.dsn#" name="x">
		update #salida#
			set SalAnt = ((SalAnt / convert(numeric,FactorDias)) / RHJhoradiaria)
			where #salida#.RHJid = (select RHJid from RHJornadas 
										where #salida#.RHJid = RHJid 
										and RHJornadahora = 1
										and Ecodigo = #session.ecodigo#)
	</cfquery>
/*
<cfif session.Usulogin EQ 'manager'>
	<cfquery datasource="#session.dsn#" name="LZ">
			Select  Salario, SalAnt, FechaCamb, RHJid, Tcodigo, FactorDias 
			from #salida#
			Where DEid=5275
	</cfquery>
	<cfdump var="#LZ#">
</cfif>	
*/	
	<cfquery datasource="#session.dsn#" name="x">
		update #salida#
			set SalAnt = ((SalAnt / convert(numeric,FactorDias)) * 14)
			where #salida#.RHJid = (select RHJid from RHJornadas 
										where #salida#.RHJid = RHJid 
										and RHJornadahora = 0
										and Ecodigo = #session.ecodigo#)
	</cfquery>	
	
	<cfquery datasource="#session.dsn#" name="x">
		update #salida#
			set Salario = ((Salario / convert(numeric,FactorDias)) / RHJhoradiaria)
			where #salida#.RHJid = (select RHJid from RHJornadas 
										where #salida#.RHJid = RHJid 
										and RHJornadahora = 1
										and Ecodigo = #session.ecodigo#)
	</cfquery>
	
	<cfquery datasource="#session.dsn#" name="x">
		update #salida#
			set Salario = ((Salario / convert(numeric,FactorDias)) * 14)
			where #salida#.RHJid = (select RHJid from RHJornadas 
										where #salida#.RHJid = RHJid 
										and RHJornadahora = 0
										and Ecodigo = #session.ecodigo#)
	</cfquery>
	
	
	<cfquery datasource="#session.dsn#" name="x">
		update #salida#
			set TotalHoras = Salario
			where #salida#.TotalHoras = 0
	</cfquery>


<!--- Realiza calculos generales y finales sobre las
tablas temporales previo a consultar los resultados --->
<cfquery datasource="#session.dsn#">
	/* ===============================
	  Monto Liquido a Pagar 
	  Columna Total_Pay_Final   
	   ===============================*/
	update #salida# set Liquido = Neto3 - Deducciones
	/* ===============================
    indicador de si es Empleado nuevo o no, para pintarlo en el Reporte 
     ===============================*/
	update #salida# set EsNuevo = 1
	from CalendarioPagos a, #calendario# x
	where CPid = x.RCNid
	and FIngreso between CPdesde and CPhasta

	update #salida#
	set Fechas = '#LB_Periodo#: ' + convert(char(12), (select min(RCdesde) from #calendario#), 107)
	
	update #salida#
	set Fechas = ltrim(rtrim(Fechas)) + ' #LB_A# ' + convert(char(12), (select max(RChasta) from #calendario#), 107)
	
	update #salida#
	set Fechap = '#LB_Fecha_de_Pago#: ' + convert(char(12), (select max(FechaPago) from #calendario#), 107)
</cfquery>
<!--- Consultas para el Reporte --->
<cfquery name="rsReporte" datasource="#session.dsn#">
	/* ===============================
	   Ejecuta  la Salida del Reporte en Pantalla 
	   ===============================*/
	select DEid,
		CFdescripcion, -- Centro Funcional
		EsNuevo, -- Indica si la fecha de ingreso conincide con la nomina que se esta pagando
		Name = upper(Nombre), -- Nombre
		coalesce(FechaCamb,FIngreso) as FechaCamb,
		coalesce(SalAnt,0.00) as SalAnt,
		Hourly_Rate = coalesce(TotalHoras,Salario), -- Costo de la Hora Ordinaria (monto de la incidencia H00 / el numero de horas)
		Start_Date = FIngreso, -- Fecha de Ingreso segun EVacacionesEmpleado
		Regular_Hours = coalesce(THorasOrd,0.00),	-- Numero de Horas de tipo H00
		Holiday_Hours = coalesce(HorasFer,0.00), -- Es el monto por el pago de Holiday (FER) entre el costo por horas
		Total_Hours = coalesce(THorasOrd,0.00) + coalesce(HorasFer,0.00), -- Son las horas de la H00 mas el de FER
		Total_Hr_Salary = coalesce(TotalSalHor,0.00) + coalesce(SalaryVac,0.00), -- Total de Horas Tipo H00, HE1, HE2, En el Caso de los Fijos se 
		Salary_Holiday = coalesce(Salary_Holiday,0.00), -- Monto pagado por el Holiday (FER)
		Pay_Adjust = coalesce(Ajustes,0.00),	-- Ajustes (incidencias que no sean H00 ni FER ni comisiones) y otras deducciones que no sean adelanto ni prestamos personales
		Net_Pay = coalesce(Neto,0.00),	-- total neto 
		Vacations = coalesce(Vacaciones,0.00),	-- subsidios de vacaciones
		Comm = coalesce(Comisiones,0.00), -- Comisiones
		Total_Pay = coalesce(Neto2,0.00),	--Neto + vacaciones + comisiones
		CLTBSA = coalesce(RebajoSA,0.00),	-- rebajos de incidencias que vienen de SA
		Gross_Pay = coalesce(Neto3,0.00),	-- Total Pay  - rebajo de SA
		EE_Advance = coalesce(Deducciones,0.00), -- Deducciones por adelantos de salario, adelanto de comisiones 
		Total_Pay_Final = coalesce(Liquido,0.00), -- Salario liquido
		Fechas, -- Titulo 1 para el reporte
		Fechap -- Titulo 2 para el reporte
	from #salida#
	order by CFdescripcion, Nombre
</cfquery>


</cfsilent>
<cf_htmlReportsHeaders irA="PagoNominaInc.cfm"
FileName="Reporte_de_Planilla_INC.xls"
title="#LB_Reporte_de_Planilla_INC#">
<cf_templatecss>
<table width="98%" border="0" cellpadding="0" cellspacing="0" align="center">
<cfoutput>
<tr>
	<td colspan="17">
		<table width="100%" cellpadding="0" cellspacing="0">
		<tr>
			<td>
				<cfif isdefined('form.tiponomina')>
					<cfinvoke key="LB_IncluyeNominasAplicadas" default="Incluye N&oacute;minas Aplicadas" returnvariable="LB_IncluyeNominasAplicadas" component="sif.Componentes.Translate"  method="Translate"/>
					<cfset filtro3 = LB_IncluyeNominasAplicadas>
				<cfelse>
					<cfinvoke key="LB_IncluyeNominasEnProceso" default="Incluye N&oacute;minas En Proceso" returnvariable="LB_IncluyeNominasEnProceso" component="sif.Componentes.Translate"  method="Translate"/>
					<cfset filtro3 = LB_IncluyeNominasEnProceso>
				</cfif>
				<cfinvoke key="LB_ReporteDePlanillaINC" default="Reporte de Planilla (INC.)" returnvariable="LB_ReporteDePlanillaINC" component="sif.Componentes.Translate"  method="Translate"/>
				<cf_EncReporte
					Titulo="#LB_ReporteDePlanillaINC#"
					Color="##E3EDEF"
					filtro1="#Trim(rsReporte.Fechas)#"
					filtro2="#Trim(rsReporte.Fechap)#"
					filtro3="#filtro3#"
				>
			</td>
		</tr>
		</table>
	</td>
</tr>
<!----====================== ENCABEZADO ANTERIOR ======================
<tr><td colspan="17" align="center"><strong>#Trim(Session.Enombre)#</strong></td></tr>
<tr><td colspan="17" align="center"><strong>#Trim(rsReporte.Fechas)#</strong></td></tr>
<tr><td colspan="17" align="center"><strong><strong>#Trim(rsReporte.Fechap)#</strong></strong></td></tr>
<tr><td colspan="17" align="center"><strong><strong>
	<cfif isdefined('form.tiponomina')>
		<cf_translate key="LB_IncluyeNominasAplicadas"> Incluye N&oacute;minas Aplicadas </cf_translate>
	<cfelse>
		<cf_translate key="LB_IncluyeNominasEnProceso"> Incluye N&oacute;minas En Proceso </cf_translate>
	</cfif>
	</strong></strong></td></tr>
<tr>
----->
	<td  class="tituloListas" valign="top"><strong>#LB_Nombre#</strong>&nbsp;&nbsp;</td>
	<td  class="tituloListas" valign="top" align="right"><strong>#LB_Ultimo_Aumento#</strong>&nbsp;</td>
	<td  class="tituloListas" valign="top" align="right"><strong>#LB_Salario_Anterior#</strong>&nbsp;</td>
	<td  class="tituloListas" valign="top" align="right"><strong>#LB_Tarifa_por_horas#</strong>&nbsp;</td>
	<td  class="tituloListas" valign="top" align="right"><strong>#LB_Fecha_de_Ingreso#</strong>&nbsp;</td>
	<td  class="tituloListas" valign="top" align="right"><strong>#LB_Horas_Regulares#</strong>&nbsp;</td>
	<td  class="tituloListas" valign="top" align="right"><strong>#LB_Horas_de_Feriados#</strong>&nbsp;</td>
	<td  class="tituloListas" valign="top" align="right"><strong>#LB_Horas_Totales#</strong>&nbsp;</td>
	<td  class="tituloListas" valign="top" align="right"><strong>#LB_Hr_Totales_y_Salario#</strong>&nbsp;</td>
	<td  class="tituloListas" valign="top" align="right"><strong>#LB_Salario_por_Feriados#</strong>&nbsp;</td>
	<td  class="tituloListas" valign="top" align="right"><strong>#LB_Ajuste_Salario_Mas#</strong>&nbsp;</td>
	<td  class="tituloListas" valign="top" align="right"><strong>#LB_Salario_Neto#</strong>&nbsp;</td>
	<td  class="tituloListas" valign="top" align="right"><strong>#LB_Vacaciones_Mas#</strong>&nbsp;</td>
	<td  class="tituloListas" valign="top" align="right"><strong>#LB_Comiciones_Mas#</strong>&nbsp;</td>
	<td  class="tituloListas" valign="top" align="right"><strong>#LB_Salario_Total#</strong>&nbsp;</td>
	<td  class="tituloListas" valign="top" align="right"><strong>#LB_CLTBSA_Menos#</strong>&nbsp;</td>
	<td  class="tituloListas" valign="top" align="right"><strong>#LB_Pago_Bruto#</strong>&nbsp;</td>
	<td  class="tituloListas" valign="top" align="right"><strong>#LB_Anticipos_Menos#</strong>&nbsp;</td>
	<td  class="tituloListas" valign="top" align="right"><strong>#LB_Pago_Total#</strong>&nbsp;</td>
</tr>
</cfoutput>
<cfsilent>
	<cfset Lvar_GrandCount = 0>
	<cfset Lvar_GrandRegular_HoursAcum =  0>
	<cfset Lvar_GrandHoliday_HoursAcum =  0>
	<cfset Lvar_GrandTotal_HoursAcum =  0>
	<cfset Lvar_GrandTotal_Hr_SalaryAcum =  0>
	<cfset Lvar_GrandSalary_HolidayAcum =  0>
	<cfset Lvar_GrandPay_AdjustAcum =  0>
	<cfset Lvar_GrandNet_PayAcum =  0>
	<cfset Lvar_GrandVacationsAcum =  0>
	<cfset Lvar_GrandCommAcum =  0>
	<cfset Lvar_GrandTotal_PayAcum =  0>
	<cfset Lvar_GrandCLTBSAAcum =  0>
	<cfset Lvar_GrandGross_PayAcum =  0>
	<cfset Lvar_GrandEE_AdvanceAcum =  0>
	<cfset Lvar_GrandTotal_Pay_FinalAcum =  0>
</cfsilent>
<cfoutput query="rsReporte" group="CFdescripcion">
	<cfsilent>
		<cfset Lvar_GroupCount = 0>
		<cfset Lvar_GroupRegular_HoursAcum =  0>
		<cfset Lvar_GroupHoliday_HoursAcum =  0>
		<cfset Lvar_GroupTotal_HoursAcum =  0>
		<cfset Lvar_GroupTotal_Hr_SalaryAcum =  0>
		<cfset Lvar_GroupSalary_HolidayAcum =  0>
		<cfset Lvar_GroupPay_AdjustAcum =  0>
		<cfset Lvar_GroupNet_PayAcum =  0>
		<cfset Lvar_GroupVacationsAcum =  0>
		<cfset Lvar_GroupCommAcum =  0>
		<cfset Lvar_GroupTotal_PayAcum =  0>
		<cfset Lvar_GroupCLTBSAAcum =  0>
		<cfset Lvar_GroupGross_PayAcum =  0>
		<cfset Lvar_GroupEE_AdvanceAcum =  0>
		<cfset Lvar_GroupTotal_Pay_FinalAcum =  0>
	</cfsilent>
	<tr>
		<td nowrap class="tituloListas" colspan="17"><strong>#rsReporte.CFdescripcion#</strong>&nbsp;</td>
	</tr>
	
	
	<cfoutput>
		<tr class="<cfif rsReporte.CurrentRow mod 2>listaPar<cfelse>listaNon</cfif>" <cfif rsReporte.EsNuevo eq 1>style="background-color:yellow;" </cfif>>
			<td nowrap>#rsReporte.Name#</td>
			<td nowrap align="right">#LSDateFormat(rsReporte.FechaCamb, "mm/dd/yyyy")# &nbsp;&nbsp;</td>
			<td nowrap align="right">#LSCurrencyformat(rsReporte.SalAnt,'none')#&nbsp;&nbsp;</td>
			<td nowrap align="right">#LSCurrencyformat(rsReporte.Hourly_Rate,'none')#&nbsp;&nbsp;</td>
			<td nowrap align="right">#rsReporte.Start_Date#</td>
			<td nowrap align="right">#LSCurrencyformat(rsReporte.Regular_Hours,'none')#</td>
			<td nowrap align="right">#LSCurrencyformat(rsReporte.Holiday_Hours,'none')#</td>
			<td nowrap align="right">#LSCurrencyformat(rsReporte.Total_Hours,'none')#</td>
			<td nowrap align="right">#LSCurrencyformat(rsReporte.Total_Hr_Salary,'none')#</td>
			<td nowrap align="right">#LSCurrencyformat(rsReporte.Salary_Holiday,'none')#</td>
			<td nowrap align="right">#LSCurrencyformat(rsReporte.Pay_Adjust,'none')#</td>
			<td nowrap align="right">#LSCurrencyformat(rsReporte.Net_Pay,'none')#</td>
			<td nowrap align="right">#LSCurrencyformat(rsReporte.Vacations,'none')#</td>
			<td nowrap align="right">#LSCurrencyformat(rsReporte.Comm,'none')#</td>
			<td nowrap align="right">#LSCurrencyformat(rsReporte.Total_Pay,'none')#</td>
			<td nowrap align="right">#LSCurrencyformat(rsReporte.CLTBSA,'none')#</td>
			<td nowrap align="right">#LSCurrencyformat(rsReporte.Gross_Pay,'none')#</td>
			<td nowrap align="right">#LSCurrencyformat(rsReporte.EE_Advance,'none')#</td>
			<td nowrap align="right">#LSCurrencyformat(rsReporte.Total_Pay_Final,'none')#</td>
		</tr>
		<cfsilent>
			<cfset Lvar_GrandCount = Lvar_GrandCount + 1>
			<cfset Lvar_GroupCount = Lvar_GroupCount + 1>
			<cfset Lvar_GrandRegular_HoursAcum = Lvar_GrandRegular_HoursAcum + rsReporte.Regular_Hours>
			<cfset Lvar_GrandHoliday_HoursAcum = Lvar_GrandHoliday_HoursAcum + rsReporte.Holiday_Hours>
			<cfset Lvar_GrandTotal_HoursAcum = Lvar_GrandTotal_HoursAcum + rsReporte.Total_Hours>
			<cfset Lvar_GrandTotal_Hr_SalaryAcum = Lvar_GrandTotal_Hr_SalaryAcum + rsReporte.Total_Hr_Salary>
			<cfset Lvar_GrandSalary_HolidayAcum = Lvar_GrandSalary_HolidayAcum + rsReporte.Salary_Holiday>
			<cfset Lvar_GrandPay_AdjustAcum = Lvar_GrandPay_AdjustAcum + rsReporte.Pay_Adjust>
			<cfset Lvar_GrandNet_PayAcum = Lvar_GrandNet_PayAcum + rsReporte.Net_Pay>
			<cfset Lvar_GrandVacationsAcum = Lvar_GrandVacationsAcum + rsReporte.Vacations>
			<cfset Lvar_GrandCommAcum = Lvar_GrandCommAcum + rsReporte.Comm>
			<cfset Lvar_GrandTotal_PayAcum = Lvar_GrandTotal_PayAcum + rsReporte.Total_Pay>
			<cfset Lvar_GrandCLTBSAAcum = Lvar_GrandCLTBSAAcum + rsReporte.CLTBSA>
			<cfset Lvar_GrandGross_PayAcum = Lvar_GrandGross_PayAcum + rsReporte.Gross_Pay>
			<cfset Lvar_GrandEE_AdvanceAcum = Lvar_GrandEE_AdvanceAcum + rsReporte.EE_Advance>
			<cfset Lvar_GrandTotal_Pay_FinalAcum = Lvar_GrandTotal_Pay_FinalAcum + rsReporte.Total_Pay_Final>
			<cfset Lvar_GroupRegular_HoursAcum = Lvar_GroupRegular_HoursAcum + rsReporte.Regular_Hours>
			<cfset Lvar_GroupHoliday_HoursAcum = Lvar_GroupHoliday_HoursAcum + rsReporte.Holiday_Hours>
			<cfset Lvar_GroupTotal_HoursAcum = Lvar_GroupTotal_HoursAcum + rsReporte.Total_Hours>
			<cfset Lvar_GroupTotal_Hr_SalaryAcum = Lvar_GroupTotal_Hr_SalaryAcum + rsReporte.Total_Hr_Salary>
			<cfset Lvar_GroupSalary_HolidayAcum = Lvar_GroupSalary_HolidayAcum + rsReporte.Salary_Holiday>
			<cfset Lvar_GroupPay_AdjustAcum = Lvar_GroupPay_AdjustAcum + rsReporte.Pay_Adjust>
			<cfset Lvar_GroupNet_PayAcum = Lvar_GroupNet_PayAcum + rsReporte.Net_Pay>
			<cfset Lvar_GroupVacationsAcum = Lvar_GroupVacationsAcum + rsReporte.Vacations>
			<cfset Lvar_GroupCommAcum = Lvar_GroupCommAcum + rsReporte.Comm>
			<cfset Lvar_GroupTotal_PayAcum = Lvar_GroupTotal_PayAcum + rsReporte.Total_Pay>
			<cfset Lvar_GroupCLTBSAAcum = Lvar_GroupCLTBSAAcum + rsReporte.CLTBSA>
			<cfset Lvar_GroupGross_PayAcum = Lvar_GroupGross_PayAcum + rsReporte.Gross_Pay>
			<cfset Lvar_GroupEE_AdvanceAcum = Lvar_GroupEE_AdvanceAcum + rsReporte.EE_Advance>
			<cfset Lvar_GroupTotal_Pay_FinalAcum = Lvar_GroupTotal_Pay_FinalAcum + rsReporte.Total_Pay_Final>
		</cfsilent>
	</cfoutput>
	<tr>
		<td nowrap class="tituloListas"><strong><cf_translate key="LB_Total"> Total </cf_translate>#rsReporte.CFdescripcion#</strong></td>
		<td nowrap class="tituloListas" align="right">&nbsp;</td>
		<td nowrap class="tituloListas" align="right">&nbsp;</td>
		<td nowrap class="tituloListas" align="right">#LSCurrencyformat(Lvar_GroupCount,'none')#&nbsp;&nbsp;</td>
		<td nowrap class="tituloListas" align="right">&nbsp;</td>
		<td nowrap class="tituloListas" align="right">#LSCurrencyformat(Lvar_GroupRegular_HoursAcum,'none')#</td>
		<td nowrap class="tituloListas" align="right">#LSCurrencyformat(Lvar_GroupHoliday_HoursAcum,'none')#</td>
		<td nowrap class="tituloListas" align="right">#LSCurrencyformat(Lvar_GroupTotal_HoursAcum,'none')#</td>
		<td nowrap class="tituloListas" align="right">#LSCurrencyformat(Lvar_GroupTotal_Hr_SalaryAcum,'none')#</td>
		<td nowrap class="tituloListas" align="right">#LSCurrencyformat(Lvar_GroupSalary_HolidayAcum,'none')#</td>
		<td nowrap class="tituloListas" align="right">#LSCurrencyformat(Lvar_GroupPay_AdjustAcum,'none')#</td>
		<td nowrap class="tituloListas" align="right">#LSCurrencyformat(Lvar_GroupNet_PayAcum,'none')#</td>
		<td nowrap class="tituloListas" align="right">#LSCurrencyformat(Lvar_GroupVacationsAcum,'none')#</td>
		<td nowrap class="tituloListas" align="right">#LSCurrencyformat(Lvar_GroupCommAcum,'none')#</td>
		<td nowrap class="tituloListas" align="right">#LSCurrencyformat(Lvar_GroupTotal_PayAcum,'none')#</td>
		<td nowrap class="tituloListas" align="right">#LSCurrencyformat(Lvar_GroupCLTBSAAcum,'none')#</td>
		<td nowrap class="tituloListas" align="right">#LSCurrencyformat(Lvar_GroupGross_PayAcum,'none')#</td>
		<td nowrap class="tituloListas" align="right">#LSCurrencyformat(Lvar_GroupEE_AdvanceAcum,'none')#</td>
		<td nowrap class="tituloListas" align="right">#LSCurrencyformat(Lvar_GroupTotal_Pay_FinalAcum,'none')#</td>
	</tr>
</cfoutput>
<cfoutput>
<tr>
	<td nowrap class="tituloListas"><strong><cf_translate key="LB_Total"> Total </cf_translate></strong></td>
	<td nowrap class="tituloListas" align="right">&nbsp;</td>
	<td nowrap class="tituloListas" align="right">&nbsp;</td>
	<td nowrap class="tituloListas" align="right">#LSCurrencyformat(Lvar_GrandCount,'none')#</td>
	<td nowrap class="tituloListas" align="right">&nbsp;</td>
	<td nowrap class="tituloListas" align="right">#LSCurrencyformat(Lvar_GrandRegular_HoursAcum,'none')#</td>
	<td nowrap class="tituloListas" align="right">#LSCurrencyformat(Lvar_GrandHoliday_HoursAcum,'none')#</td>
	<td nowrap class="tituloListas" align="right">#LSCurrencyformat(Lvar_GrandTotal_HoursAcum,'none')#</td>
	<td nowrap class="tituloListas" align="right">#LSCurrencyformat(Lvar_GrandTotal_Hr_SalaryAcum,'none')#</td>
	<td nowrap class="tituloListas" align="right">#LSCurrencyformat(Lvar_GrandSalary_HolidayAcum,'none')#</td>
	<td nowrap class="tituloListas" align="right">#LSCurrencyformat(Lvar_GrandPay_AdjustAcum,'none')#</td>
	<td nowrap class="tituloListas" align="right">#LSCurrencyformat(Lvar_GrandNet_PayAcum,'none')#</td>
	<td nowrap class="tituloListas" align="right">#LSCurrencyformat(Lvar_GrandVacationsAcum,'none')#</td>
	<td nowrap class="tituloListas" align="right">#LSCurrencyformat(Lvar_GrandCommAcum,'none')#</td>
	<td nowrap class="tituloListas" align="right">#LSCurrencyformat(Lvar_GrandTotal_PayAcum,'none')#</td>
	<td nowrap class="tituloListas" align="right">#LSCurrencyformat(Lvar_GrandCLTBSAAcum,'none')#</td>
	<td nowrap class="tituloListas" align="right">#LSCurrencyformat(Lvar_GrandGross_PayAcum,'none')#</td>
	<td nowrap class="tituloListas" align="right">#LSCurrencyformat(Lvar_GrandEE_AdvanceAcum,'none')#</td>
	<td nowrap class="tituloListas" align="right">#LSCurrencyformat(Lvar_GrandTotal_Pay_FinalAcum,'none')#</td>
</tr>
</cfoutput>
<tr><td colspan="17" align="center"><strong><cf_translate key="LB_FinDelReporte"> --Fin Del Reporte-- </cf_translate></strong></td></tr>
</table>
