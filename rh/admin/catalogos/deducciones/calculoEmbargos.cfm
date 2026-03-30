<!--- Valores de entrada que utiliza:
		1. RCNid: lo toma de la variable arguments.RCNid (esta en RH_CalculoNomina)
		2. TDid: lo toma del query DeduccionesEspeciales (esta en RH_CalculoNomina)
		3. minimo: lo toma de RH_CalculoNomina, esta ahi calculado. 
	  Este archivo se parametriza para una deduccion en el mantenimiento de Tipos de Deduccion, pero debe accesarse
	  digitandolo desde la barra de direcciones	(.../cfmx/rh/admin/catalogos/DTipoDeduccion.cfm) 
	  Luego sera incluido para su ejecucion en RH_CalculoNomina si la deduccion asi esta definida --->

<cf_dbtemp name="calculaembargo4" returnvariable="calculaembargo">
	<cf_dbtempcol name="DEid" 				type="numeric" 	mandatory="yes">
	<cf_dbtempcol name="salario_mensual" 	type="money"  	mandatory="no">	
	<cf_dbtempcol name="salario_actual" 	type="money"  	mandatory="no">	
	<cf_dbtempcol name="salario_hist"	    type="money"  	mandatory="no">
	<cf_dbtempcol name="salario_mes"	    type="money"  	mandatory="no">		
	<cf_dbtempcol name="incidencias_actual" type="money"  	mandatory="no">	
	<cf_dbtempcol name="incidencias_hist" 	type="money"  	mandatory="no">
	<cf_dbtempcol name="incidencias_mes"	    type="money"  	mandatory="no">		
	<cf_dbtempcol name="actual" 			type="money"  	mandatory="no">	
	<cf_dbtempcol name="mensual" 			type="money"  	mandatory="no">	
	<cf_dbtempcol name="cobrado" 			type="money"  	mandatory="no">	
	<cf_dbtempcol name="renta_actual" 		type="money"  	mandatory="yes">	
	<cf_dbtempcol name="renta_acumulada"	type="money"  	mandatory="yes">	
	<cf_dbtempcol name="Did" 				type="numeric" 	mandatory="no">
	<cf_dbtempcol name="monto_embargo"	type="money"  	mandatory="no">
</cf_dbtemp>

<!--- parametros de entrada ASIGNAR LOS VALORES, ver de donde salen --->
<!--- ============================================ --->
<cfset v_RCNid 	  = Arguments.RCNid >
<cfset v_TDid 	  = DeduccionesEspeciales.TDid >

<cfset cant_nominas	  = '' >
<!--- ============================================ --->

<!--- ============================================ --->
<!--- LZ 2010-01-08 
	  Se modifica el procedimiento del Embargo, porque el 0.91 
	  que se usa del Salario, presupone que el % de la CCSS del empleado es el 9%, 
	  pero con el cambio de Ley para el 2010 es el 9.17%  
	  
      PARA QUE EL CAMBIO SEA DINAMICO SE TRABAJA CON AQUELLAS CARGAS EMPLEADO QUE PERTENEZCAN AL GRUPO DE AUTOMATICAS, PERO QUE NO TENGAN EL CHECK DE PROVISION	  
--->
<!--- ============================================ --->

<!--- ============================================ --->
<!--- LZ 2011-01-20
	  El PArámetro Salario Mínimo trae el monto mensual convertido en su Homólogo Calendario, Desde el Cálculo de Nómina, por ello, aqui se toma el valor integro 
	  y se manipula según el Tipo de FRecuencia de PAgo
--->
<!--- ============================================ --->
<cfquery datasource="#Arguments.datasource#" name="SMinimo">
	select pn.Pvalor
	from RCalculoNomina rn, RHParametros pn
	where rn.RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#v_RCNid#">
	  and pn.Ecodigo = rn.Ecodigo
	  and pn.Pcodigo = 130
</cfquery>
<cfset minimo   = SMinimo.Pvalor >


<cfquery name="SalarioGravable" datasource="#session.DSN#">
	Select 1-(coalesce(Sum(DCvaloremp),0)/100) as gravable
	from DCargas a, <!--- Detalle de Cargas --->
		 ECargas b  <!--- Encabezado de Cargas --->
    Where a.ECid =b.ECid
    and   b.ECauto=1 <!--- De Ley o Asociadas automáticamente --->
    and   a.DCprovision=0 <!--- No se etiquetaron como tipo Provisión --->
    and   b.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
</cfquery>

<cfset v_minimo = minimo * #SalarioGravable.gravable# >

<cfset minmensual = v_minimo>

<cfif not len(trim(minmensual))>
	<cfset minmensual = 0 >
</cfif>

<!--- ============================================
	   Cantidad de Nóminas que Tiene el Mes
	  ============================================ --->
<!--- Determina la cantidad de Periodos que tiene el MES --->
<cfquery name="rs_ultima" datasource="#session.DSN#">
	select count(CPcodigo) as Cantidad
	from CalendarioPagos a
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	and exists (Select 1
				from CalendarioPagos b
				Where a.CPmes=b.CPmes
				and a.CPperiodo=b.CPperiodo
				and a.Tcodigo=b.Tcodigo
				and a.Ecodigo=b.Ecodigo
				and b.CPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#v_RCNid#">)                			 
	and CPtipo = 0
</cfquery>
<cfset cant_nominas	= rs_ultima.Cantidad>

<!--- ============================================
	   NOMINAS PENDIENTES DEL MES
	  ============================================ --->
<cfquery name="rs_nomina" datasource="#session.DSN#">
    select count(1) as Cantidad
	from CalendarioPagos a
	where exists (Select 1 from
				  CalendarioPagos b
				  Where a.CPmes=b.CPmes
				  and a.CPperiodo=b.CPperiodo
				  and a.Tcodigo=b.Tcodigo
				  and a.Ecodigo=b.Ecodigo
				  and b.CPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#v_RCNid#">)
	and CPtipo = 0
    and not exists (Select 1 
        	      	from HRCalculoNomina c
	              	Where a.CPid = c.RCNid
	              	and c.RCNid not in (Select RCNid from RCalculoNomina))
</cfquery>

<cfset nom_pendientes	= rs_nomina.Cantidad>


<!--- ============================================
	   NOMINAS CALCULADAS EN EL MES (TOMANDO EN CUANTA LA ACTUAL)
	  ============================================ --->
<cfquery name="rs_nomina" datasource="#session.DSN#">
    select count(1)+ 1 as Cantidad
	from CalendarioPagos a
	where exists (Select 1 from
				  CalendarioPagos b
				  Where a.CPmes=b.CPmes
				  and a.CPperiodo=b.CPperiodo
				  and a.Tcodigo=b.Tcodigo
				  and a.Ecodigo=b.Ecodigo
				  and b.CPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#v_RCNid#">)
	and CPtipo = 0
    and exists (Select 1 
        	      	from HRCalculoNomina c
	              	Where a.CPid = c.RCNid)
</cfquery>
<cfset nom_calculadas = rs_nomina.Cantidad >
<!--- ============================================
      Determina los empleados con embargo
============================================ --->
<cfquery datasource="#session.DSN#">
	insert into #calculaembargo#(DEid , salario_mensual , salario_actual , actual , mensual , cobrado, renta_actual, renta_acumulada, Did, monto_embargo)
	select a.DEid, 0, 0, 0, 0, 0, 0, 0, a.Did, 0
	from DeduccionesEmpleado b, DeduccionesCalculo a
	where b.TDid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#v_TDid#">
	and b.DEid = a.DEid
	and b.Did = a.Did
	and a.RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#v_RCNid#">
	<cfif IsDefined('Arguments.pDEid')> and b.DEid = #Arguments.pDEid#</cfif>
</cfquery>

<!--- ============================================
      Determina los empleados con embargo
============================================ --->

<cfif nom_pendientes NEQ 1 >		
	<cfset nom_proyectar = cant_nominas>
<cfelse >		
	<cfset nom_proyectar = 1>
	<cfset nom_calculadas = 1>
</cfif>

<!--- ============================================
	Se almacena los Montos por Incidencias y Salarios Ganados en la Nómina en Proceso
	============================================ --->

		<cfquery datasource="#session.DSN#">
			update #calculaembargo#
			set salario_actual = coalesce( 
										 	(select sum(se.SEsalariobruto)
											 from SalarioEmpleado se, 
												 RCalculoNomina d
											 where se.RCNid = d.RCNid
										       and se.RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#v_RCNid#">
											   and #calculaembargo#.DEid=se.DEid
											 group by se.DEid
											 ), 0.00 
								  ) * 1,
			   incidencias_actual = coalesce( 
											 	(select sum(ic.ICmontores)
												from IncidenciasCalculo ic, 
												     RCalculoNomina d ,
												     CIncidentes ci
												where ic.RCNid = d.RCNid
												  and ic.CIid=ci.CIid
												  and ci.CInocargasley=0
												  and ic.RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#v_RCNid#">
												  and #calculaembargo#.DEid=ic.DEid
												group by ic.DEid
											), 0.00 
								  ) * 1
		</cfquery>
		
<!--- ============================================
	Se almacena los Montos por Incidencias y Salarios Ganados en la Nómina en HISTORICOS DEL MES
	============================================ --->

		<cfquery datasource="#session.DSN#">
			update #calculaembargo#
			set salario_hist = coalesce( 
										 	(select sum(se.SEsalariobruto )
												from HSalarioEmpleado se, 
													 HRCalculoNomina d ,
													 CalendarioPagos c
												where se.RCNid = d.RCNid
											      and c.CPid=d.RCNid
											      and #calculaembargo#.DEid=se.DEid
												  and exists (Select 1 from
															  CalendarioPagos b
															  Where c.CPmes=b.CPmes
															  and c.CPperiodo=b.CPperiodo
															  and c.Tcodigo=b.Tcodigo
															  and c.Ecodigo=b.Ecodigo
															  and b.CPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#v_RCNid#">)
												group by se.DEid   
											), 0.00 
								  )  * 1,
			   incidencias_hist = coalesce( 
										 	(select sum(hic.ICmontores)
												from HIncidenciasCalculo hic, 
												     HRCalculoNomina d,
												     CalendarioPagos c,
												     CIncidentes ci
												where hic.RCNid = d.RCNid
												  and #calculaembargo#.DEid=hic.DEid
											      and c.CPid=d.RCNid
												  and hic.CIid=ci.CIid
												  and ci.CInocargasley=0
												  and exists (Select 1 from
															  CalendarioPagos b
															  Where c.CPmes=b.CPmes
															  and c.CPperiodo=b.CPperiodo
															  and c.Tcodigo=b.Tcodigo
															  and c.Ecodigo=b.Ecodigo
															  and b.CPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#v_RCNid#">)											      
												group by hic.DEid   
											), 0.00 
								  ) * 1
		</cfquery>
<!--- 		
		<cfquery datasource="#session.DSN#" name="LZ">
			Select  a.DEid, c.DEnombre, c.DEapellido1, c.DEapellido2,
					a.salario_hist,
					a.incidencias_hist, 
					a.incidencias_actual, 
					a.salario_actual
			from #calculaembargo# a, DeduccionesCalculo b, DatosEmpleado c
			where a.DEid=b.DEid
			and a.Did=b.Did
			and c.DEid=a.DEid
		</cfquery>
		<cf_dump var="#LZ#">
--->
<!--- ============================================
	Se suman los Salarios del Mes y las Incidencias del Mes
	============================================ --->		
		<cfquery datasource="#session.DSN#">
				update #calculaembargo#
				set salario_mes =    (salario_actual + salario_hist),
					incidencias_mes =(incidencias_actual + incidencias_hist)
				
		</cfquery>
<!---	
	
		<cfquery datasource="#session.DSN#" name="LZ">
			Select  a.DEid, c.DEnombre, c.DEapellido1, c.DEapellido2,
					a.salario_hist,
					a.incidencias_hist, 
					a.incidencias_actual, 
					a.salario_actual
			from #calculaembargo# a, DeduccionesCalculo b, DatosEmpleado c
			where a.DEid=b.DEid
			and a.Did=b.Did
			and c.DEid=a.DEid
		</cfquery>
--->

<!--- ============================================
	Se suman los Salarios del Mes (proyectando) y las Incidencias del Mes
	============================================ --->		
		<cfquery datasource="#session.DSN#">
				update #calculaembargo#
				set salario_mes =    ((salario_actual + salario_hist)/ #nom_calculadas# ) * #nom_proyectar#,
					incidencias_mes =(incidencias_actual + incidencias_hist)
		</cfquery>
<!---		
		<cfquery datasource="#session.DSN#" name="LZ">
			Select  a.DEid, c.DEnombre, c.DEapellido1, c.DEapellido2,
					a.salario_mes,
					a.incidencias_mes
			from #calculaembargo# a, DeduccionesCalculo b, DatosEmpleado c
			where a.DEid=b.DEid
			and a.Did=b.Did
			and c.DEid=a.DEid
			and c.DEid=531
		</cfquery>
		<cf_dump var="#LZ#">
--->	
<!--- ============================================
	Se consolida la Informacion Proyectada y las Incidencias, para el Calculo de la renta se usa el Salario Devengado completo
	============================================ --->				
		<cfquery datasource="#session.DSN#">
				update #calculaembargo#
				set salario_mensual =    salario_mes + incidencias_mes 
		</cfquery>
		
		
		<cfquery datasource="#session.DSN#" name="tablarenta">
				Select Pvalor
				from RHParametros
				Where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
				and Pcodigo=30
		</cfquery>

<!--- ============================================
	Se Calcula la renta Estimada sobre la Proyeccion
	============================================ --->				
	<cfquery datasource="#session.DSN#">
		update #calculaembargo# 
		set renta_actual = 	coalesce
							( 
								(	
									select   ((#calculaembargo#.salario_mensual) - a.DIRinf ) * 
										  (a.DIRporcentaje / 100) + a.DIRmontofijo 
									from EImpuestoRenta b, DImpuestoRenta a
									where b.IRcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#tablarenta.Pvalor#">
									  and b.EIRestado > 0
									  and a.EIRid = b.EIRid
									  and ( select RChasta 
									  		from RCalculoNomina 
											where RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#v_RCNid#"> ) between EIRdesde and EIRhasta
									  and round((#calculaembargo#.salario_mensual ),2) >= round(a.DIRinf,2)
									  and round((#calculaembargo#.salario_mensual ),2) <= round(a.DIRsup,2) 
								)
								,0
							)
	</cfquery>

<!---
		<cfquery datasource="#session.DSN#" name="LZ">
			Select  a.DEid, c.DEnombre, c.DEapellido1, c.DEapellido2,
					a.salario_mensual,
					a.renta_actual 
			from #calculaembargo# a, DeduccionesCalculo b, DatosEmpleado c
			where a.DEid=b.DEid
			and a.Did=b.Did
			and c.DEid=a.DEid
			and c.DEid=531
		</cfquery>
		<cf_dump var="#LZ#">
--->	
<!--- ============================================
	Se Calculan los Créditos Fiscales
	============================================ --->	
	<cfquery datasource="#session.DSN#">
		update #calculaembargo# 
		set renta_actual = renta_actual  -  coalesce
											(
												(	
													select sum(d.DCDvalor)
													from FEmpleado a, ConceptoDeduc f, EImpuestoRenta e, DConceptoDeduc d, RCalculoNomina re
													where a.DEid = #calculaembargo#.DEid
													  and re.RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#v_RCNid#">
													  and a.FEdeducrenta > 0
													  and a.FEdeducdesde <= RChasta 
													  and a.FEdeduchasta >= RCdesde 
													  and a.FEidconcepto = f.CDid
													  and e.IRcodigo = f.IRcodigo
													  and e.EIRestado > 0
													  and RCdesde between e.EIRdesde and e.EIRhasta
													  and RChasta between e.EIRdesde and e.EIRhasta
													  and d.CDid = f.CDid
													  and d.EIRid = e.EIRid
												)
												, 0.00 
											)
	</cfquery>

<!--- ============================================
	Si la renta es Menor a Cero entonces se indica que Renta es Cero, 
	esto sucede cuando se aplica la resta de creditos fiscales a una renta en cero
	============================================ --->	
	<cfquery datasource="#session.DSN#">
			update #calculaembargo#
			set renta_actual = 0
			Where renta_actual < 0
	</cfquery>


<!--- ============================================
	Calculada la Renta, se determina cuanto es el Salario del Funcionario sin el 9%
	============================================ --->	
	<cfquery datasource="#session.DSN#">
			update #calculaembargo#
			set salario_mensual = salario_mensual *  <cfqueryparam cfsqltype="cf_sql_float" value="#SalarioGravable.gravable#">
	</cfquery>

 		
	
<!--- ============================================
	Se Calcula Los Montos Que se han cobrado en la misma Nómina por Otros Embargos, 
	para que se rebajen de la siguente proyeccion
	============================================ --->	
	<cfquery name="rs_embargo" datasource="#session.DSN#">
		update #calculaembargo#
		set actual= coalesce((select sum(a.DCvalor)
							from DeduccionesCalculo a, 
							DeduccionesEmpleado b
							where a.Did = b.Did
							  and a.DEid = b.DEid
							  and b.DEid = #calculaembargo#.DEid
							  and b.TDid =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#v_TDid#">
							  and a.RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#v_RCNid#">),0)
	</cfquery>

<!--- ============================================
	Se establece el Salario Mensual con que se va a trabajar
	============================================ --->	
		<cfquery name="rs_embargo" datasource="#session.DSN#">
				select Did 
				from #calculaembargo#
				order by Did
		</cfquery>
	
	<cfloop query="rs_embargo">	
	
	<cfset DeduccionActual= #rs_embargo.Did#>
<!--- 
		<cfdump var="Ingreso al Ciclo <BR>">
		<cfquery datasource="#session.DSN#" name="LZ">
			Select  a.DEid, c.DEnombre, c.DEapellido1, c.DEapellido2,
					a.Did,
					a.actual,
					a.monto_embargo,
					a.cobrado,
					a.mensual
			from #calculaembargo# a, DeduccionesCalculo b, DatosEmpleado c
			where a.DEid=b.DEid
			and a.Did=b.Did
			and a.Did=#DeduccionActual#
			and a.DEid=c.DEid
			--and c.DEid=531			
		</cfquery>
		<cf_dump var="#LZ#">	
--->
	
	
			<cfquery datasource="#session.DSN#">
				update #calculaembargo#
				set mensual =  salario_mensual - (Select sum(actual) 
												  from #calculaembargo# x
												  where #calculaembargo#.DEid = x.DEid)
				where DEid = ( 	select DEid 
								from #calculaembargo# 
								where Did = #DeduccionActual# )
			</cfquery>	
		
<!--- ============================================
	Se Calcula el Embargo / #cant_nominas# )
	============================================ --->		 	
		<cfquery datasource="#session.DSN#">
			update #calculaembargo#
			set monto_embargo =  coalesce((
											select case
											when ( (y.mensual - #minmensual# - y.renta_actual ) <=  0 ) then 
												0.00
											when (( y.mensual - #minmensual# - y.renta_actual ) > 0 )
												and (( y.mensual - #minmensual# - y.renta_actual ) 
												      <= (#minmensual# * 3)) then 
												round( (( y.mensual - #minmensual# - y.renta_actual ) / 8) , 2)
											when (( y.mensual - #minmensual# - y.renta_actual ) >  ( #minmensual# * 3)) then 
												round( 
														((#minmensual# * 3) / 8) 
														+ 
														(((y.mensual - #minmensual# - y.renta_actual) - ( #minmensual# * 3))/4)
														, 2) 
								   			end
											from #calculaembargo# y
											where y.DEid = #calculaembargo#.DEid
							  				and y.Did = #calculaembargo#.Did)
							  	, 0) 
			where Did =  #DeduccionActual#
		</cfquery>
<!---		
	<cfquery datasource="#session.DSN#" name="Lzemb">
		Select 'LZmontoEmbargo', DEid, mensual, #minmensual#, renta_actual, monto_embargo, salario_mensual, actual
		from #calculaembargo#
		--where DEid=531
	</cfquery>
	<cf_dump var="#Lzemb#"><BR><BR>
--->	
<!--- ============================================
	Se Revisa cuando se ha Cobrado hasta el momento de Embargo
	============================================ --->		
     	<cfquery datasource="#session.DSN#">
			update #calculaembargo#
			set cobrado =  	coalesce
							( 
								(
									select sum(a.DCvalor)
									from HDeduccionesCalculo a, DeduccionesEmpleado b
									where a.Did = b.Did
									  and a.DEid = b.DEid
									  and b.DEid = #calculaembargo#.DEid
									  and b.TDid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#v_TDid#">
									  and b.Did= #DeduccionActual#
									  and a.RCNid in (	select CPid
														from CalendarioPagos a
														where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
														and exists (Select 1 from
																		  CalendarioPagos b
																		  Where a.CPmes=b.CPmes
																		  and a.CPperiodo=b.CPperiodo
																		  and a.Tcodigo=b.Tcodigo
																		  and a.Ecodigo=b.Ecodigo
																		  and b.CPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#v_RCNid#">)
													 )
									  group by a.DEid, #calculaembargo#.Did     
								) ,0
							)
		</cfquery>
		
		<cfquery datasource="#session.DSN#">
			update DeduccionesCalculo
			set DCvalor =	round
							( 
								coalesce
								( 
									( select (monto_embargo - cobrado)
									  from #calculaembargo# x
									  where DeduccionesCalculo.DEid = x.DEid
									  and  x.Did =  #DeduccionActual#
									)
									, 0.00 
								)
								, 2 
							)
			where DeduccionesCalculo.Did =  #DeduccionActual#
			and RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#v_RCNid#">			
			<cfif IsDefined('Arguments.pDEid')> and DEid = #Arguments.pDEid#</cfif>		
		</cfquery>
		
		<cfquery datasource="#session.DSN#">
			update DeduccionesCalculo
			set DCvalor = 	round((DCvalor / #nom_pendientes# ),2)
			where Did= #DeduccionActual#
			and RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#v_RCNid#">			
			<cfif IsDefined('Arguments.pDEid')> and DEid = #Arguments.pDEid#</cfif>
			and exists( 	select 1 
							from DeduccionesEmpleado b, RCalculoNomina c, #calculaembargo# x
							where b.TDid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#v_TDid#">
								  and b.DEid = DeduccionesCalculo.DEid
								  and DeduccionesCalculo.DEid = x.DEid
								  and b.Did = DeduccionesCalculo.Did
								  and c.RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#v_RCNid#">
								  and DeduccionesCalculo.RCNid = c.RCNid
								  and DeduccionesCalculo.Did = x.Did
						)		  
		</cfquery>	
		
		<!--- ============================================
		Para Cada Persona, en el Ciclo de Embargos voy Restando 
		lo que se Calcula en un Embargo anterior, en caso que tenga Varios
	============================================ --->			
		<cfquery datasource="#session.DSN#">
			update #calculaembargo#
			set actual =  actual + round((monto_embargo - cobrado) / #nom_pendientes#, 2)
			Where Did =  #DeduccionActual#
		</cfquery>
		
<!--- 
		Minimo Mensual: <cfdump var="#minmensual#"><BR>
		<cfquery datasource="#session.DSN#" name="LZ">
			Select  a.DEid,c.DEnombre, c.DEapellido1, c.DEapellido2,
					a.Did,
					a.actual,
					a.monto_embargo,
					a.cobrado,
					a.mensual,
					b.DCvalor
			from #calculaembargo# a, DeduccionesCalculo b, DatosEmpleado c
			where a.DEid=b.DEid
			and a.Did=b.Did
			and a.Did=#DeduccionActual#
			and a.DEid=c.DEid
			and c.DEid=531			
		</cfquery>
		<cfdump var="#LZ#">	
--->	
</cfloop> <!--- while --->

<!---
		<cf_dump var="Salida al Ciclo <BR>">
		Minimo Mensual: <cfdump var="#minmensual#"><BR>
		Cantidad Nominas: <cfdump var="#cant_nominas#"><BR>
		Cantidad Pendientes: <cfdump var="#nom_pendientes#"><BR>
		Nominas Calculadas: <cfdump var="#nom_calculadas#"><BR>
		Nominas Proyectar: <cfdump var="#nom_proyectar#"><BR>
		Minimo Inembargable: <cfdump var="#minmensual * 3# "><BR>
		<cfquery datasource="#session.DSN#" name="LZ">
			Select  a.DEid,
					a.salario_mes, 
					a.incidencias_mes, 
					a.salario_mensual,
					a.renta_actual,
					a.actual,
					a.monto_embargo,
					a.cobrado,
					b.DCvalor,
					a.mensual
			from #calculaembargo# a, DeduccionesCalculo b
			where a.DEid=b.DEid
			and a.Did=b.Did
		</cfquery>
		<cf_dump var="#LZ#">
--->
		
