<!--- Valores de entrada que utiliza:
		1. RCNid: lo toma de la variable arguments.RCNid (esta en RH_CalculoNomina)
		2. TDid: lo toma del query DeduccionesEspeciales (esta en RH_CalculoNomina)
		3. minimo: lo toma de RH_CalculoNomina, esta ahi calculado. 
	  Este archivo se parametriza para una deduccion en el mantenimiento de Tipos de Deduccion, pero debe accesarse
	  digitandolo desde la barra de direcciones	(.../cfmx/rh/admin/catalogos/DTipoDeduccion.cfm) 
	  Luego sera incluido para su ejecucion en RH_CalculoNomina si la deduccion asi esta definida --->

<cf_dbtemp name="calculaembargo" returnvariable="calculaembargo">
	<cf_dbtempcol name="DEid" 				type="numeric" 	mandatory="yes">
	<cf_dbtempcol name="salario_mensual" 	type="money"  	mandatory="no">	
	<cf_dbtempcol name="salario_actual" 	type="money"  	mandatory="no">	
	<cf_dbtempcol name="actual" 			type="money"  	mandatory="no">	
	<cf_dbtempcol name="mensual" 			type="money"  	mandatory="no">	
	<cf_dbtempcol name="cobrado" 			type="money"  	mandatory="no">	
	<cf_dbtempcol name="renta_actual" 		type="money"  	mandatory="yes">	
	<cf_dbtempcol name="renta_acumulada"	type="money"  	mandatory="yes">	
	<cf_dbtempcol name="Did" 				type="numeric" 	mandatory="no">
</cf_dbtemp>

<!--- parametros de entrada ASIGNAR LOS VALORES, ver de donde salen --->
<!--- ============================================ --->
<cfset v_RCNid 	  = Arguments.RCNid >
<cfset v_TDid 	  = DeduccionesEspeciales.TDid >
<cfset v_minimo   = arguments.minimo >
<cfset cant_nominas	  = '' >
<!--- ============================================ --->
<cfset minimo = v_minimo * 0.91 >
<cfquery datasource="#session.DSN#" name="rs_minmensual">
select (<cfqueryparam cfsqltype="cf_sql_money" value="#v_minimo#"> *	case Ttipopago  when 0 then 52  <!---(52/12) --->
																						when 1 then 26  	<!---(26/12) --->
																						when 2 then 24      <!---(24/12) --->
																						when 3 then 12
																		end)/12 as minmensual
	from CalendarioPagos a, TiposNomina b
	where a.CPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#v_RCNid#">
	  and a.Tcodigo = b.Tcodigo
	  and a.Ecodigo = b.Ecodigo
</cfquery>	
<cfset minmensual = rs_minmensual.minmensual >
<cfif not len(trim(minmensual))>
	<cfset minmensual = 0 >
</cfif>

<!--- Determina la cantidad de Periodos --->
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

<!--- ---- Determina los empleados con embargo --->
<cfquery datasource="#session.DSN#">
	insert into #calculaembargo#(DEid , salario_mensual , salario_actual , actual , mensual , cobrado, renta_actual, renta_acumulada, Did )
	select a.DEid, 0, 0, 0, 0, 0, 0, 0, a.Did
	from DeduccionesEmpleado b, DeduccionesCalculo a
	where b.TDid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#v_TDid#">
	and b.DEid = a.DEid
	and b.Did = a.Did
	and a.RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#v_RCNid#">
</cfquery>

<!--- Determina el monto de Renta --->
<cfquery datasource="#session.DSN#">
	update #calculaembargo# 
	set renta_actual = ( select SErenta 
						 from SalarioEmpleado a 
						 where a.DEid = #calculaembargo#.DEid 
						   and a.RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#v_RCNid#"> ),
	    renta_acumulada = coalesce(
									(	select sum(SErenta) 
										from HSalarioEmpleado se 
										where se.DEid = #calculaembargo#.DEid
										  and se.RCNid in (  select CPid
										   					 from CalendarioPagos a
										  					 where exists (Select 1 from
																		  CalendarioPagos b
																		  Where a.CPmes=b.CPmes
																		  and a.CPperiodo=b.CPperiodo
																		  and a.Tcodigo=b.Tcodigo
																		  and a.Ecodigo=b.Ecodigo
																		  and b.CPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#v_RCNid#">)
										  						and CPtipo = 0 
														  )
									), 0
								  )
</cfquery>						

<!--- Calcula el salario devengado en TODO el MES --->
<cfquery datasource="#session.DSN#">
	update #calculaembargo#
	set salario_mensual = 	coalesce
						 	(
								coalesce
								(
									salario_mensual,
									0
								) 
								
								+

								( 	select sum( se.SEsalariobruto + se.SEincidencias )
			 						from HSalarioEmpleado se
									where se.DEid = #calculaembargo#.DEid
									  and se.RCNid in 	(	select CPid
															from CalendarioPagos a
															where exists (Select 1 from
																		  CalendarioPagos b
																		  Where a.CPmes=b.CPmes
																		  and a.CPperiodo=b.CPperiodo
																		  and a.Tcodigo=b.Tcodigo
																		  and a.Ecodigo=b.Ecodigo
																		  and b.CPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#v_RCNid#">)
						  									and CPtipo = 0
														)
		   							group by se.DEid 
								) 
								, 0.00 
							) * 0.91
</cfquery>

<!--- Calcula el salario devengado EN ESTA QUINCENA --->

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
	              	Where a.CPid = c.RCNid)
</cfquery>

<cfset nom_actual = rs_nomina.Cantidad >

	<cfif nom_actual EQ 1 >   <!--- Si es 1, es que es la última del mes --->
		<cfquery datasource="#session.DSN#">
			update #calculaembargo#
			set salario_actual = coalesce
								( 
									(
										select sum( se.SEsalariobruto  + se.SEincidencias )
										from SalarioEmpleado se, RCalculoNomina d, DeduccionesCalculo a, DeduccionesEmpleado b
										where se.DEid = a.DEid
										  and se.RCNid = d.RCNid
										   and b.TDid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#v_TDid#">
										   and b.DEid = a.DEid
										   and b.DEid = #calculaembargo#.DEid
										   and b.Did = #calculaembargo#.Did
										   and b.Did = a.Did
										  and se.RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#v_RCNid#">
										group by a.DEid, #calculaembargo#.Did     
									) 
									, 0.00 
								) * 0.91
		</cfquery>
	<cfelse> 			<!--- Si no es la última, se trata de proyectar --->
		<cfquery datasource="#session.DSN#">
			update #calculaembargo#
			set salario_actual = coalesce
								 ( 
								 	(
									 	select sum(  (se.SEsalariobruto * #cant_nominas# ) + se.SEincidencias )
										from SalarioEmpleado se, RCalculoNomina d, DeduccionesCalculo a, DeduccionesEmpleado b
										where se.DEid = a.DEid
										  and se.RCNid = d.RCNid
										   and b.TDid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#v_TDid#">
										   and b.DEid = a.DEid
										   and b.DEid = #calculaembargo#.DEid
										   and b.Did = a.Did
										   and b.Did = #calculaembargo#.Did
										   and se.RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#v_RCNid#">
										group by a.DEid   
									)
									, 0.00 
								 ) * 0.91
		</cfquery>
	</cfif>

	<!--- Calcula la Renta , segun la tabla --->
	<cfquery datasource="#session.DSN#">
		update #calculaembargo# 
		set renta_actual = 	coalesce
							( 
								(	
									select   ((#calculaembargo#.salario_actual / 0.91) - a.DIRinf ) * (a.DIRporcentaje / 100) + a.DIRmontofijo 
									from EImpuestoRenta b, DImpuestoRenta a
									where b.IRcodigo = 'RCR'
									  and b.EIRestado > 0
									  and a.EIRid = b.EIRid
									  and ( select RChasta 
									  		from RCalculoNomina 
											where RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#v_RCNid#"> ) between EIRdesde and EIRhasta
									  and round((#calculaembargo#.salario_actual / 0.91),2) >= round(a.DIRinf,2)
									  and round((#calculaembargo#.salario_actual / 0.91),2) <= round(a.DIRsup,2) 
								)
								,0
							)
	</cfquery>						   

	<!--- Rebajo de Creditos Familiares --->
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

	<!--- Determina el Embargo de la quincena Actual --->
	<cfquery name="rs_embargo" datasource="#session.DSN#">
		select Did 
		from #calculaembargo#
		order by Did
	</cfquery>

	<cfloop query="rs_embargo">
		<cfquery datasource="#session.DSN#">
			update #calculaembargo#
			set salario_actual =  salario_actual - ( select sum(actual) 
													 from #calculaembargo# x
													 where #calculaembargo#.DEid = x.DEid
												   )
			where DEid = ( select DEid from #calculaembargo# where Did = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rs_embargo.Did#"> )
		</cfquery>

		<cfquery datasource="#session.DSN#">
			update #calculaembargo#
			set actual =  (coalesce((
							select case
										when ( (y.salario_actual - #minmensual# - y.renta_actual ) <=  0 ) then 0.00
										when (( y.salario_actual - #minmensual# - y.renta_actual ) > 0 ) and (( y.salario_actual - #minmensual# - y.renta_actual ) <= #minmensual# * 3) then round( (( y.salario_actual - #minmensual# - y.renta_actual ) / 8) , 2)
										when (( y.salario_actual - #minmensual# - y.renta_actual ) >  ( #minmensual# * 3)) then round( ( #minmensual# * 3 / 8) + (( y.salario_actual - y.renta_actual  - ( #minmensual# * 4)) / 4), 2)
								   end
							from #calculaembargo# y
							where y.DEid = #calculaembargo#.DEid
							  and y.Did = #calculaembargo#.Did 
						  ), 0) / #cant_nominas# )
			where Did = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rs_embargo.Did#">
		</cfquery>
	</cfloop> <!--- while --->

	<!---  Si es la "Ultima" Quincena del mes, saca el Embargo Mensual --->
	<!---  y la diferencia lo cobra en la ultima quincena --->
	
		<!---  viejo
	<cfquery name="rs_nomina"  datasource="#session.DSN#">
		select CPcodigo
		from CalendarioPagos 
		where CPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#v_RCNid#">
	</cfquery>
	<cfset nom_actual = right(trim(rs_nomina.CPcodigo),1) >
	--->

	<cfif nom_actual eq 1 >
		<!---  Suma todas la quincenas del mes y saca un Embargo Mensual --->
		<!--- Determina el Embargo de TODO el MES --->
     	<cfquery datasource="#session.DSN#">
			update #calculaembargo#
			set mensual = 	round
							(
								(
									select 	case when ( (salario_mensual + salario_actual) - #minmensual# - (renta_actual + renta_acumulada) ) <=  0 then 0.00
												 when ((salario_mensual + salario_actual) - #minmensual# - (renta_actual + renta_acumulada) ) > 0
												 and ( (salario_mensual + salario_actual) - #minmensual# - (renta_actual + renta_acumulada) ) <= #minmensual# * 3
												 then round( ( (salario_mensual + salario_actual)  - #minmensual# - (renta_actual + renta_acumulada) ) / 8 , 2)
												 when ( (salario_mensual + salario_actual)  - #minmensual# - (renta_actual + renta_acumulada) ) >  (#minmensual# * 3)
												 then round( ( #minmensual# * 3 / 8) + (( ( (salario_mensual + salario_actual - (renta_actual + renta_acumulada) ) ) - ( #minmensual# * 4)) / 4), 2)
											end
									from #calculaembargo# b
									where b.DEid = #calculaembargo#.DEid 
									  and b.Did = #calculaembargo#.Did 
								)
								, 2
							)
		</cfquery>						
		<!---fin calculo mensual --->

		<!---  Suma lo cobrado en el pasado, pero dentro del mismo mes --->
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
									( select mensual - cobrado
									  from #calculaembargo# x
									  where DeduccionesCalculo.DEid = x.DEid 
									)
									, 0.00 
								)
								, 2 
							)
			where exists( 	select 1
							from DeduccionesEmpleado b, RCalculoNomina c, #calculaembargo# x
							where b.TDid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#v_TDid#">
							  and b.DEid = DeduccionesCalculo.DEid
							  and DeduccionesCalculo.DEid = x.DEid
							  and b.Did = DeduccionesCalculo.Did
							  and c.RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#v_RCNid#">
							  and DeduccionesCalculo.RCNid = c.RCNid
						)	  
		</cfquery>			  
	<cfelse>
		<cfquery datasource="#session.DSN#">
			update DeduccionesCalculo
			 set DCvalor = 	round( 
									coalesce( 
												( select actual
												  from #calculaembargo# x
												  where DeduccionesCalculo.DEid = x.DEid
													and DeduccionesCalculo.Did = x.Did
												)
												, 0.00 
										  )
									,2)
			where exists( 	select 1 
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
</cfif>