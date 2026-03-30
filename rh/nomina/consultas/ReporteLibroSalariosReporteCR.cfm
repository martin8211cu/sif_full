<cfsetting requesttimeout="36000">
<cfquery name="rsVerificaReporte" datasource="#session.DSN#">
	select 1
    from RHReportesNomina
    where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
      and RHRPTNcodigo = 'LSCR'
</cfquery>
	<cfif isdefined("url.CFid") and len(trim(url.CFid))>
	<cfquery name="CFuncional" datasource="#session.DSN#">
		select CFpath, CFcodigo, CFdescripcion
		from CFuncional
		where CFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.CFid#">
	</cfquery>
</cfif>
<cfif isdefined('rsVerificaReporte') and rsVerificaReporte.RecordCount>
<!--- VARIABLES DE TRADUCCION --->
<cfinvoke key="LB_LibroDeSalarios" default="Libro de Salarios" returnvariable="LB_LibroDeSalarios" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_NoHayDatosRelacionados" default="No hay datos relacionados" returnvariable="LB_NoHayDatosRelacionados" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_Fecha" default="Fecha" returnvariable="LB_Fecha" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_FechaRige" default="Fecha Rige" returnvariable="LB_FechaRige"  component="sif.Componentes.Translate" method="Translate" />
<cfinvoke key="LB_FechaVence" default="Fecha Vence" returnvariable="LB_FechaVence" component="sif.Componentes.Translate" method="Translate"/>
<!--- FIN VARIABLES DE TRADUCCION --->
	<!--- Tabla temporal de resultados --->
	<cf_dbtemp name="salida2LCR2" returnvariable="salida2">
    	<cf_dbtempcol name="RCNid"   		type="int"      mandatory="yes">
        <cf_dbtempcol name="DEid"   		type="int"      mandatory="yes">
        <cf_dbtempcol name="CPcodigo"  		type="char(12)" mandatory="no">
        <cf_dbtempcol name="CPtipo"  		type="int" 		mandatory="no">
		<cf_dbtempcol name="CPperiodo" 		type="int" 		mandatory="no">
		<cf_dbtempcol name="CPmes"  		type="int" 		mandatory="no">
        <cf_dbtempcol name="RCdesde" 		type="datetime" mandatory="no">
		<cf_dbtempcol name="RChasta" 		type="datetime" mandatory="no">
		<cf_dbtempcol name="Tcodigo" 		type="char(5)"  mandatory="no">
		<cf_dbtempcol name="FechaPago" 		type="datetime" mandatory="no">
		<!---cf_dbtempcol name="Dias"	  	type="int"      mandatory="no">
		<cf_dbtempcol name="HorasExtra" 	type="float"   	mandatory="no">
		<cf_dbtempcol name="Sueldo" 		type="money"    mandatory="no"--->
		<cf_dbtempcol name="Ordinario" 		type="money"    mandatory="no">
		<cf_dbtempcol name="Prohibicion" 	type="money"  	mandatory="no">
		<!---cf_dbtempcol name="ExtrasS" 	type="money"    mandatory="no">
		<cf_dbtempcol name="ExtrasD" 		type="money"    mandatory="no">
		<cf_dbtempcol name="Aguinaldo" 		type="money"    mandatory="no">
		<cf_dbtempcol name="Vacaciones"		type="money"   	mandatory="no"--->
		<cf_dbtempcol name="Ajustes" 		type="money"    mandatory="no">
		<cf_dbtempcol name="Otros"		type="money"    mandatory="no">
		<cf_dbtempcol name="Subsidios"		type="money"    mandatory="no">
		<cf_dbtempcol name="Comisiones" 	type="money"    mandatory="no">
		<!---cf_dbtempcol name="Septimo" 	type="money"    mandatory="no"--->
		<cf_dbtempcol name="Bonificacion"	type="money"    mandatory="no">
		<!---cf_dbtempcol name="Asoc" 		type="money"    mandatory="no">
		<cf_dbtempcol name="Renta" 		type="money"    mandatory="no">
		<cf_dbtempcol name="BanTrab" 		type="money" 	mandatory="no">
		<cf_dbtempcol name="OtrosDesc" 		type="money" 	mandatory="no">
		<cf_dbtempcol name="MontoLiquido" 	type="money"    mandatory="no"--->
		<cf_dbtempcol name="MontoBruto" 	type="money"   	mandatory="no">
		<cf_dbtempkey cols="DEid,RCNid">
	</cf_dbtemp> 
	<cfif isdefined("url.Fdesde") and len(trim(url.Fdesde))>
		<cfset Lvar_MesD = DatePart('m',url.Fdesde)>
		<cfset Lvar_PeriodoD = DatePart('yyyy',url.Fdesde)>
	</cfif>
	<cfif isdefined("url.Fhasta") and len(trim(url.Fhasta))>
		<cfset Lvar_MesH = DatePart('m',url.Fhasta)>
		<cfset Lvar_PeriodoH = DatePart('yyyy',url.Fhasta)>
	</cfif>
    <!--- INGRESA LOS DATOS DE LOS CALENDARIOS DE PAGO DEL EMPLEADO --->
	<cfquery name="rsCalendarios" datasource="#session.dsn#">	
 	 	insert into #salida2#(RCNid, DEid, RCdesde, RChasta, Tcodigo, FechaPago,CPcodigo,CPtipo,CPperiodo,CPmes)
            select distinct cp.CPid, hse.DEid, CPdesde, CPhasta, cp.Tcodigo, CPfpago,CPcodigo,CPtipo,CPperiodo,CPmes
            from HSalarioEmpleado hse
				inner join CalendarioPagos cp
					on hse.RCNid = cp.CPid
				inner join DatosEmpleado de
					on de.DEid = hse.DEid
					and de.Ecodigo = cp.Ecodigo
				inner join HRCalculoNomina cn
					on cn.RCNid = cp.CPid
				<!----Filtro de cfuncional---->				
				inner join LineaTiempo x
					on hse.DEid = x.DEid
					and (cn.RCdesde between x.LTdesde and x.LThasta
							or
						cn.RChasta between x.LTdesde and x.LThasta
						)
				inner join RHPlazas y
					on x.RHPid = y.RHPid
					<cfif isdefined("url.RHPcodigo") and len(trim(url.RHPcodigo))>
						and y.RHPpuesto = <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.RHPcodigo#">
					</cfif>					
				inner join CFuncional z
					on y.CFid = z.CFid
					<cfif isdefined("url.CFid") and len(trim(url.CFid)) and isdefined("url.chkDependencias") and len(trim(url.chkDependencias))>
						and (z.CFpath like <cfqueryparam cfsqltype="cf_sql_varchar" value="#CFuncional.CFpath#/%">
								or z.CFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.CFid#">
							)
					<cfelseif isdefined("url.CFid") and len(trim(url.CFid)) and not isdefined("url.chkDependencias")>
						and z.CFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.CFid#">
					</cfif>					
			where cp.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
				and CPhasta >= <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(url.Fdesde)#">
				and CPdesde <= <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(url.Fhasta)#">
				and cp.CPtipo <> 2
				and CPperiodo = <cf_dbfunction name="date_part" args="yyyy, CPhasta">
				and CPmes = <cf_dbfunction name="date_part"   args="mm, CPhasta">
				<cfif isdefined('url.DEidentificacion') and LEN(TRIM(url.DEidentificacion)) and not isdefined('url.DEidentificacion')>
					and de.DEidentificacion >= '#url.DEidentificacion#'
				<cfelseif isdefined('url.DEidentificacion1') and LEN(TRIM(url.DEidentificacion1)) and not isdefined('url.DEidentificacion')>
					and de.DEidentificacion <= '#url.DEidentificacion1#'
				<cfelseif isdefined('url.DEidentificacion') and LEN(TRIM(url.DEidentificacion)) and 
						isdefined('url.DEidentificacion1') and LEN(TRIM(url.DEidentificacion1))>
					and de.DEidentificacion between '#url.DEidentificacion#' and '#url.DEidentificacion1#'
				</cfif>
	            order by DEid, CPid
	</cfquery>
    <!--- SALARIO ORDINARIO --->
    <!--- SALARIO BRUTO --->
     <cfquery name="rsSalarioOrd" datasource="#session.DSN#">
    	update #salida2#
        set Ordinario = coalesce((select SEsalariobruto
        			 from HSalarioEmpleado hse
                                     where hse.RCNid = #salida2#.RCNid
                                       and hse.DEid = #salida2#.DEid
        							),0.00)
   	</cfquery>
    <!--- MONTO DE INCIDENCIAS POR HORAS --->
	<!--- SUMA LAS INCIDENCIAS QUE SE INDICARON EN LA DEFINICION DEL REPORTE --->
	<cfquery name="rsHorasExtra" datasource="#session.DSN#">
    	update #salida2#
        set Ordinario = Ordinario + coalesce((
								select sum(a.ICmontores) 
								from HIncidenciasCalculo a
								where a.DEid = #salida2#.DEid
								and a.RCNid = #salida2#.RCNid 
								and CIid in (select distinct a.CIid
											from RHReportesNomina c
												inner join RHColumnasReporte b
															inner join RHConceptosColumna a
															on a.RHCRPTid = b.RHCRPTid
													 on b.RHRPTNid = c.RHRPTNid
													and b.RHCRPTcodigo = 'Ordinario'
											where c.RHRPTNcodigo = 'LSCR'
											  and c.Ecodigo = #session.Ecodigo#)), 0.00)
								- ( coalesce((	select sum(a.DCvalor) 
												from HDeduccionesCalculo a, DeduccionesEmpleado b,TDeduccion z
												where a.DEid = #salida2#.DEid 
												and a.RCNid = #salida2#.RCNid 
												and a.DEid = b.DEid
												and a.Did = b.Did
												and b.TDid=z.TDid
												and z.TDid in (select distinct a.TDid
														from RHReportesNomina c
															inner join RHColumnasReporte b
																		inner join RHConceptosColumna a
																		on a.RHCRPTid = b.RHCRPTid
																 on b.RHRPTNid = c.RHRPTNid
																and b.RHCRPTcodigo = 'Ordinario'
														where c.RHRPTNcodigo = 'LSCR'
														  and c.Ecodigo = #session.Ecodigo#)),0.00)
									+ coalesce((
											select sum(a.CCvaloremp) 	
											from HCargasCalculo a, DCargas b, ECargas c
											where a.DEid = #salida2#.DEid
											  and a.RCNid = #salida2#.RCNid
											  and b.DClinea = a.DClinea
											  and c.ECid = b.ECid
											  and b.DClinea in (select distinct a.DClinea
														from RHReportesNomina c
															inner join RHColumnasReporte b
																		inner join RHConceptosColumna a
																		on a.RHCRPTid = b.RHCRPTid
																 on b.RHRPTNid = c.RHRPTNid
																and b.RHCRPTcodigo = 'Ordinario'
														where c.RHRPTNcodigo = 'LSCR'
														  and c.Ecodigo = #session.Ecodigo#)),0.00)
								
								
								)
    </cfquery> 
	
    <!--- BONIFICACION LEY Q250 --->
	<cfquery name="rsHorasExtra" datasource="#session.DSN#">
    	update #salida2#
        set Prohibicion = coalesce((
								select sum(a.ICmontores) 
								from HIncidenciasCalculo a
								where a.DEid = #salida2#.DEid
								and a.RCNid = #salida2#.RCNid 
								and CIid in (select distinct a.CIid
											from RHReportesNomina c
												inner join RHColumnasReporte b
															inner join RHConceptosColumna a
															on a.RHCRPTid = b.RHCRPTid
													 on b.RHRPTNid = c.RHRPTNid
													and b.RHCRPTcodigo = 'Prohibicion'
											where c.RHRPTNcodigo = 'LSCR'
											  and c.Ecodigo = #session.Ecodigo#)), 0.00)
						- ( coalesce((	select sum(a.DCvalor) 
												from HDeduccionesCalculo a, DeduccionesEmpleado b,TDeduccion z
												where a.DEid = #salida2#.DEid 
												and a.RCNid = #salida2#.RCNid 
												and a.DEid = b.DEid
												and a.Did = b.Did
												and b.TDid=z.TDid
												and z.TDid in (select distinct a.TDid
														from RHReportesNomina c
															inner join RHColumnasReporte b
																		inner join RHConceptosColumna a
																		on a.RHCRPTid = b.RHCRPTid
																 on b.RHRPTNid = c.RHRPTNid
																and b.RHCRPTcodigo = 'Prohibicion'
														where c.RHRPTNcodigo = 'LSCR'
														  and c.Ecodigo = #session.Ecodigo#)),0.00)
									+ coalesce((
											select sum(a.CCvaloremp) 	
											from HCargasCalculo a, DCargas b, ECargas c
											where a.DEid = #salida2#.DEid
											  and a.RCNid = #salida2#.RCNid
											  and b.DClinea = a.DClinea
											  and c.ECid = b.ECid
											  and b.DClinea in (select distinct a.DClinea
														from RHReportesNomina c
															inner join RHColumnasReporte b
																		inner join RHConceptosColumna a
																		on a.RHCRPTid = b.RHCRPTid
																 on b.RHRPTNid = c.RHRPTNid
																and b.RHCRPTcodigo = 'Prohibicion'
														where c.RHRPTNcodigo = 'LSCR'
														  and c.Ecodigo = #session.Ecodigo#)),0.00)
								
								
								)
    </cfquery>   	
    <!--- Ajustes --->
    <cfquery name="rsAguinaldo" datasource="#session.DSN#">
    	update #salida2#
			set Ajustes = coalesce((
					select sum(a.ICmontores) 
					from HIncidenciasCalculo a
					where a.DEid = #salida2#.DEid
					and a.RCNid = #salida2#.RCNid 
					and CIid in (select distinct a.CIid
								from RHReportesNomina c
									inner join RHColumnasReporte b
												inner join RHConceptosColumna a
												on a.RHCRPTid = b.RHCRPTid
										 on b.RHRPTNid = c.RHRPTNid
										and b.RHCRPTcodigo = 'Ajustes'
								where c.RHRPTNcodigo = 'LSCR'
								  and c.Ecodigo = #session.Ecodigo#)), 0.00)
				- ( coalesce((	select sum(a.DCvalor) 
								from HDeduccionesCalculo a, DeduccionesEmpleado b,TDeduccion z
								where a.DEid = #salida2#.DEid 
								and a.RCNid = #salida2#.RCNid 
								and a.DEid = b.DEid
								and a.Did = b.Did
								and b.TDid=z.TDid
								and z.TDid in (select distinct a.TDid
										from RHReportesNomina c
											inner join RHColumnasReporte b
														inner join RHConceptosColumna a
														on a.RHCRPTid = b.RHCRPTid
												 on b.RHRPTNid = c.RHRPTNid
												and b.RHCRPTcodigo = 'Ajustes'
										where c.RHRPTNcodigo = 'LSCR'
										  and c.Ecodigo = #session.Ecodigo#)),0.00)
					+ coalesce((
							select sum(a.CCvaloremp) 	
							from HCargasCalculo a, DCargas b, ECargas c
							where a.DEid = #salida2#.DEid
							  and a.RCNid = #salida2#.RCNid
							  and b.DClinea = a.DClinea
							  and c.ECid = b.ECid
							  and b.DClinea in (select distinct a.DClinea
										from RHReportesNomina c
											inner join RHColumnasReporte b
														inner join RHConceptosColumna a
														on a.RHCRPTid = b.RHCRPTid
												 on b.RHRPTNid = c.RHRPTNid
												and b.RHCRPTcodigo = 'Ajustes'
										where c.RHRPTNcodigo = 'LSCR'
										  and c.Ecodigo = #session.Ecodigo#)),0.00)
					)	
    </cfquery>
    <!--- OTROS --->
    <cfquery name="rsOtros" datasource="#session.DSN#">
    	update #salida2#
			set Otros = coalesce((
					select sum(a.ICmontores) 
					from HIncidenciasCalculo a
					where a.DEid = #salida2#.DEid
					and a.RCNid = #salida2#.RCNid 
					and CIid in (select distinct a.CIid
								from RHReportesNomina c
									inner join RHColumnasReporte b
												inner join RHConceptosColumna a
												on a.RHCRPTid = b.RHCRPTid
										 on b.RHRPTNid = c.RHRPTNid
										and b.RHCRPTcodigo = 'Otros'
								where c.RHRPTNcodigo = 'LSCR'
								  and c.Ecodigo = #session.Ecodigo#)), 0.00)
					- ( coalesce((	select sum(a.DCvalor) 
								from HDeduccionesCalculo a, DeduccionesEmpleado b,TDeduccion z
								where a.DEid = #salida2#.DEid 
								and a.RCNid = #salida2#.RCNid 
								and a.DEid = b.DEid
								and a.Did = b.Did
								and b.TDid=z.TDid
								and z.TDid in (select distinct a.TDid
										from RHReportesNomina c
											inner join RHColumnasReporte b
														inner join RHConceptosColumna a
														on a.RHCRPTid = b.RHCRPTid
												 on b.RHRPTNid = c.RHRPTNid
												and b.RHCRPTcodigo = 'Otros'
										where c.RHRPTNcodigo = 'LSCR'
										  and c.Ecodigo = #session.Ecodigo#)),0.00)
					+ coalesce((
							select sum(a.CCvaloremp) 	
							from HCargasCalculo a, DCargas b, ECargas c
							where a.DEid = #salida2#.DEid
							  and a.RCNid = #salida2#.RCNid
							  and b.DClinea = a.DClinea
							  and c.ECid = b.ECid
							  and b.DClinea in (select distinct a.DClinea
										from RHReportesNomina c
											inner join RHColumnasReporte b
														inner join RHConceptosColumna a
														on a.RHCRPTid = b.RHCRPTid
												 on b.RHRPTNid = c.RHRPTNid
												and b.RHCRPTcodigo = 'Otros'
										where c.RHRPTNcodigo = 'LSCR'
										  and c.Ecodigo = #session.Ecodigo#)),0.00)
				
				
				)
    </cfquery>

<!--- Subsidios ljimenez --->
    <cfquery name="rsSubsidios" datasource="#session.DSN#">
    	update #salida2#
			set Subsidios = coalesce((
					select sum(a.ICmontores) 
					from HIncidenciasCalculo a
					where a.DEid = #salida2#.DEid
					and a.RCNid = #salida2#.RCNid 
					and CIid in (select distinct a.CIid
								from RHReportesNomina c
									inner join RHColumnasReporte b
												inner join RHConceptosColumna a
												on a.RHCRPTid = b.RHCRPTid
										 on b.RHRPTNid = c.RHRPTNid
										and b.RHCRPTcodigo = 'Subsidios'
								where c.RHRPTNcodigo = 'LSCR'
								  and c.Ecodigo = #session.Ecodigo#)), 0.00)
					- ( coalesce((	select sum(a.DCvalor) 
								from HDeduccionesCalculo a, DeduccionesEmpleado b,TDeduccion z
								where a.DEid = #salida2#.DEid 
								and a.RCNid = #salida2#.RCNid 
								and a.DEid = b.DEid
								and a.Did = b.Did
								and b.TDid=z.TDid
								and z.TDid in (select distinct a.TDid
										from RHReportesNomina c
											inner join RHColumnasReporte b
														inner join RHConceptosColumna a
														on a.RHCRPTid = b.RHCRPTid
												 on b.RHRPTNid = c.RHRPTNid
												and b.RHCRPTcodigo = 'Subsidios'
										where c.RHRPTNcodigo = 'LSCR'
										  and c.Ecodigo = #session.Ecodigo#)),0.00)
					+ coalesce((
							select sum(a.CCvaloremp) 	
							from HCargasCalculo a, DCargas b, ECargas c
							where a.DEid = #salida2#.DEid
							  and a.RCNid = #salida2#.RCNid
							  and b.DClinea = a.DClinea
							  and c.ECid = b.ECid
							  and b.DClinea in (select distinct a.DClinea
										from RHReportesNomina c
											inner join RHColumnasReporte b
														inner join RHConceptosColumna a
														on a.RHCRPTid = b.RHCRPTid
												 on b.RHRPTNid = c.RHRPTNid
												and b.RHCRPTcodigo = 'Subsidios'
										where c.RHRPTNcodigo = 'LSCR'
										  and c.Ecodigo = #session.Ecodigo#)),0.00)
				
				
				)
    </cfquery>
<!---ljimenez Fin de calculo de subsidios--->

    <!--- COMISIONES --->
    <cfquery name="rsComisiones" datasource="#session.DSN#">
    	update #salida2#
			set Comisiones = coalesce((
					select sum(a.ICmontores) 
					from HIncidenciasCalculo a
					where a.DEid = #salida2#.DEid
					and a.RCNid = #salida2#.RCNid 
					and CIid in (select distinct a.CIid
								from RHReportesNomina c
									inner join RHColumnasReporte b
												inner join RHConceptosColumna a
												on a.RHCRPTid = b.RHCRPTid
										 on b.RHRPTNid = c.RHRPTNid
										and b.RHCRPTcodigo = 'Comisiones'
								where c.RHRPTNcodigo = 'LSCR'
								  and c.Ecodigo = #session.Ecodigo#)), 0.00)
					- ( coalesce((	select sum(a.DCvalor) 
								from HDeduccionesCalculo a, DeduccionesEmpleado b,TDeduccion z
								where a.DEid = #salida2#.DEid 
								and a.RCNid = #salida2#.RCNid
 								and a.DEid = b.DEid
								and a.Did = b.Did
								and b.TDid=z.TDid
								and z.TDid in (select distinct a.TDid
										from RHReportesNomina c
											inner join RHColumnasReporte b
														inner join RHConceptosColumna a
														on a.RHCRPTid = b.RHCRPTid
												 on b.RHRPTNid = c.RHRPTNid
												and b.RHCRPTcodigo = 'Comisiones'
										where c.RHRPTNcodigo = 'LSCR'
										  and c.Ecodigo = #session.Ecodigo#)),0.00)
					+ coalesce((
							select sum(a.CCvaloremp) 	
							from HCargasCalculo a, DCargas b, ECargas c
							where a.DEid = #salida2#.DEid
							  and a.RCNid = #salida2#.RCNid
							  and b.DClinea = a.DClinea
							  and c.ECid = b.ECid
							  and b.DClinea in (select distinct a.DClinea
										from RHReportesNomina c
											inner join RHColumnasReporte b
														inner join RHConceptosColumna a
														on a.RHCRPTid = b.RHCRPTid
												 on b.RHRPTNid = c.RHRPTNid
												and b.RHCRPTcodigo = 'Comisiones'
										where c.RHRPTNcodigo = 'LSCR'
										  and c.Ecodigo = #session.Ecodigo#)),0.00)
				
				
				)
    </cfquery>
    <!--- SEPTIMO --->
	<cfquery name="rsComisiones" datasource="#session.DSN#">
    	update #salida2#
			set Bonificacion = coalesce((
				select sum(a.ICmontores) 
					from HIncidenciasCalculo a
					where a.DEid = #salida2#.DEid
					and a.RCNid = #salida2#.RCNid 
					and CIid in (select distinct a.CIid
								from RHReportesNomina c
									inner join RHColumnasReporte b
												inner join RHConceptosColumna a
												on a.RHCRPTid = b.RHCRPTid
										 on b.RHRPTNid = c.RHRPTNid
										and b.RHCRPTcodigo = 'Bonificacion'
								where c.RHRPTNcodigo = 'LSCR'
								  and c.Ecodigo = #session.Ecodigo#)), 0.00)
					- ( coalesce((	select sum(a.DCvalor) 
								from HDeduccionesCalculo a, DeduccionesEmpleado b,TDeduccion z
								where a.DEid = #salida2#.DEid 
								and a.RCNid = #salida2#.RCNid 
								and a.DEid = b.DEid
								and a.Did = b.Did
								and b.TDid=z.TDid
								and z.TDid in (select distinct a.TDid
										from RHReportesNomina c
											inner join RHColumnasReporte b
														inner join RHConceptosColumna a
														on a.RHCRPTid = b.RHCRPTid
												 on b.RHRPTNid = c.RHRPTNid
												and b.RHCRPTcodigo = 'Bonificacion'
										where c.RHRPTNcodigo = 'LSCR'
										  and c.Ecodigo = #session.Ecodigo#)),0.00)
					+ coalesce((
							select sum(a.CCvaloremp) 	
							from HCargasCalculo a, DCargas b, ECargas c
							where a.DEid = #salida2#.DEid
							  and a.RCNid = #salida2#.RCNid
							  and b.DClinea = a.DClinea
							  and c.ECid = b.ECid
							  and b.DClinea in (select distinct a.DClinea
										from RHReportesNomina c
											inner join RHColumnasReporte b
														inner join RHConceptosColumna a
														on a.RHCRPTid = b.RHCRPTid
												 on b.RHRPTNid = c.RHRPTNid
												and b.RHCRPTcodigo = 'Bonificacion'
										where c.RHRPTNcodigo = 'LSCR'
										  and c.Ecodigo = #session.Ecodigo#)),0.00)
				
				
				)
    </cfquery>
	<cfquery name="rs" datasource="#session.DSN#">
		select max(a.RCNid) as RCNid
		from #salida2# a
		inner join #salida2# b
			on b.DEid = a.DEid
			and b.CPperiodo = a.CPperiodo
			and b.CPmes = a.CPmes
		group by a.CPperiodo, a.CPmes
	</cfquery>
    <!--- SUMARIZA LAS NOMINAS ESPECIALES A LAS NORMALES, PARA LOS PERIODOS CORRESPONDIENTES.
    <cfquery name="rsEspeciales" datasource="#session.DSN#">
    	update #salida2#
        set Dias	= Dias + coalesce((select sum(Dias) from #salida2# x where x.CPtipo = 1 and x.CPperiodo = #salida2#.CPperiodo and x.CPmes = #salida2#.CPmes and x.DEid = #salida2#.DEid),0),
	    HorasExtra 	= HorasExtra + coalesce((select sum(HorasExtra) from #salida2# x where x.CPtipo = 1 and x.CPperiodo = #salida2#.CPperiodo and x.CPmes = #salida2#.CPmes and x.DEid = #salida2#.DEid),0),
            Ordinario 	= Ordinario + coalesce((select sum(Ordinario) from #salida2# x where x.CPtipo = 1 and x.CPperiodo = #salida2#.CPperiodo and x.CPmes = #salida2#.CPmes and x.DEid = #salida2#.DEid),0),      
            Bonifica 	= Bonifica + coalesce((select sum(Bonifica) from #salida2# x where x.CPtipo = 1 and x.CPperiodo = #salida2#.CPperiodo and x.CPmes = #salida2#.CPmes and x.DEid = #salida2#.DEid),0),
            ExtrasS 	= ExtrasS + coalesce((select sum(ExtrasS) from #salida2# x where x.CPtipo = 1 and x.CPperiodo = #salida2#.CPperiodo and x.CPmes = #salida2#.CPmes and x.DEid = #salida2#.DEid),0),
            ExtrasD 	= ExtrasD + coalesce((select sum(ExtrasD) from #salida2# x where x.CPtipo = 1 and x.CPperiodo = #salida2#.CPperiodo and x.CPmes = #salida2#.CPmes and x.DEid = #salida2#.DEid),0),
       	    Aguinaldo 	= Aguinaldo + coalesce((select sum(Aguinaldo) from #salida2# x where x.CPtipo = 1 and x.CPperiodo = #salida2#.CPperiodo and x.CPmes = #salida2#.CPmes and x.DEid = #salida2#.DEid),0),
            Vacaciones 	= Vacaciones + coalesce((select sum(Vacaciones) from #salida2# x where x.CPtipo = 1 and x.CPperiodo = #salida2#.CPperiodo and x.CPmes = #salida2#.CPmes and x.DEid = #salida2#.DEid),0),
            Indemniza 	= Indemniza + coalesce((select sum(Indemniza) from #salida2# x where x.CPtipo = 1 and x.CPperiodo = #salida2#.CPperiodo and x.CPmes = #salida2#.CPmes and x.DEid = #salida2#.DEid),0),
            Otros	= Otros + coalesce((select sum(Otros) from #salida2# x where x.CPtipo = 1 and x.CPperiodo = #salida2#.CPperiodo and x.CPmes = #salida2#.CPmes and x.DEid = #salida2#.DEid),0),
            Comisiones 	= Comisiones + coalesce((select sum(Comisiones) from #salida2# x where x.CPtipo = 1 and x.CPperiodo = #salida2#.CPperiodo and x.CPmes = #salida2#.CPmes and x.DEid = #salida2#.DEid),0),
            Septimo 	= Septimo + coalesce((select sum(Septimo) from #salida2# x where x.CPtipo = 1 and x.CPperiodo = #salida2#.CPperiodo and x.CPmes = #salida2#.CPmes and x.DEid = #salida2#.DEid),0),
            IGSS	= IGSS + coalesce((select sum(IGSS) from #salida2# x where x.CPtipo = 1 and x.CPperiodo = #salida2#.CPperiodo and x.CPmes = #salida2#.CPmes and x.DEid = #salida2#.DEid),0),
            Asoc	= Asoc + coalesce((select sum(Asoc) from #salida2# x where x.CPtipo = 1 and x.CPperiodo = #salida2#.CPperiodo and x.CPmes = #salida2#.CPmes and x.DEid = #salida2#.DEid),0),
            ISR 	= ISR + coalesce((select sum(ISR) from #salida2# x where x.CPtipo = 1 and x.CPperiodo = #salida2#.CPperiodo and x.CPmes = #salida2#.CPmes and x.DEid = #salida2#.DEid),0),
            BanTrab 	= BanTrab + coalesce((select sum(BanTrab) from #salida2# x where x.CPtipo = 1 and x.CPperiodo = #salida2#.CPperiodo and x.CPmes = #salida2#.CPmes and x.DEid = #salida2#.DEid),0),
            OtrosDesc 	= OtrosDesc + coalesce((select sum(OtrosDesc) from #salida2# x where x.CPtipo = 1 and x.CPperiodo = #salida2#.CPperiodo and x.CPmes = #salida2#.CPmes and x.DEid = #salida2#.DEid),0),
            MontoLiquido= MontoLiquido + coalesce((select sum(MontoLiquido) from #salida2# x where x.CPtipo = 1 and x.CPperiodo = #salida2#.CPperiodo and x.CPmes = #salida2#.CPmes and x.DEid = #salida2#.DEid),0),
            MontoBruto 	= MontoBruto + coalesce((select sum(MontoBruto) from #salida2# x where x.CPtipo = 1 and x.CPperiodo = #salida2#.CPperiodo and x.CPmes = #salida2#.CPmes and x.DEid = #salida2#.DEid),0)
		where CPtipo <> 1
		  and RCNid in (select max(a.RCNid)
						from #salida2# a
						inner join #salida2# b
							on b.DEid = a.DEid
							and b.CPperiodo = a.CPperiodo
							and b.CPmes = a.CPmes
						where a.CPtipo <> 1
						group by a.CPperiodo, a.CPmes)
    </cfquery> --->
     <!--- MONTO BRUTO --->
    <cfquery name="rsSalarioLiq" datasource="#session.DSN#">
    	update #salida2#
        set MontoBruto = Ordinario + Prohibicion + Otros + Comisiones + Bonificacion + Subsidios
    </cfquery>

	<!---cfinclude template="ReporteLibroSalarios-Ceses.cfm">
	<cfquery name="rsInsertaCese" datasource="#session.DSN#">
		insert into #salida2#(RCNid, DEid, CPcodigo,CPtipo, RCdesde, RChasta, 
								 ExtrasS, ExtrasD, Aguinaldo, Vacaciones, Indemniza,
								 Otros, Comisiones, Asoc, ISR, BanTrab, OtrosDesc,Dias,HorasExtra,
								 Ordinario,Bonifica,Septimo,MontoLiquido,MontoBruto,IGSS)
		select DLlinea, DEid, CPcodigo,CPtipo, RCdesde, RChasta, ExtrasS, ExtrasD, Aguinaldo, Vacaciones, Indemniza,
		Otros, Comisiones, Asoc, ISR, BanTrab, OtrosDesc,0,0,0,0,0,0,0,0
		from #salida2Cese#
	</cfquery--->
		
	
    <cfquery name="rsReporte" datasource="#session.DSN#">
    	select CPmes,s.CPperiodo,de.DEid,DEidentificacion, 
        	{fn concat(DEnombre,{fn concat(' ',{fn concat(DEapellido1,{fn concat(' ',DEapellido2)})})})} as NombreEmp,
        	sum(Ordinario) as Ordinario, sum(Prohibicion) as Prohibicion, sum(Ajustes) as Ajustes, sum(Otros) as Otros,
			sum(Comisiones) as Comisiones, sum(Bonificacion) as Bonificacion, sum(Subsidios) as Subsidios,
			sum(MontoBruto) as MontoBruto
        from #salida2# s
        inner join DatosEmpleado de
			on de.DEid = s.DEid 
		group by de.DEid,DEidentificacion, CPmes,CPperiodo,
        	{fn concat(DEnombre,{fn concat(' ',{fn concat(DEapellido1,{fn concat(' ',DEapellido2)})})})}	
		Order by de.DEid, CPperiodo,CPmes 
    </cfquery>
    <!--- FIN DE RECOLECCION DE DATOS DEL REPORTE --->


    <!--- Busca el nombre de la Empresa --->
    <cfquery name="rsEmpresa" datasource="#session.DSN#">
        select Edescripcion
        from Empresas
        where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
    </cfquery>

    <style>
	h1.corte {
		PAGE-BREAK-AFTER: always;}
	.tituloAlterno {
		font-size:20px;
		font-weight:bold;
		text-align:center;}
	.titulo_empresa2 {
		font-size:18px;
		font-weight:bold;
		text-align:center;}
	.titulo_reporte {
		font-size:16px;
		font-style:italic;
		text-align:center;}
	.titulo_filtro {
		font-size:14px;
		font-style:italic;
		text-align:center;}
	.titulolistas {
		font-size:14px;
		font-weight:bold;
		background-color:#CCCCCC;
		}
	.titulo_columnar {
		font-size:14px;
		font-weight:bold;
		background-color:#CCCCCC;
		text-align:right;}
	.listaCorte {
		font-size:10px;
		font-weight:bold;
		background-color: #F4F4F4;
		text-align:left;}
	.listaCorte3 {
		font-size:10px;
		font-weight:bold;
		background-color:  #E8E8E8;
		text-align:left;}
	.listaCorte2 {
		font-size:10px;
		font-weight:bold;
		background-color: #D8D8D8;
		text-align:left;}
	.listaCorte1 {
		font-size:12px;
		font-weight:bold;
		background-color:#CCCCCC;
		text-align:left;}
	.total {
		font-size:14px;
		font-weight:bold;
		background-color:#C5C5C5;
		text-align:right;}

	.detalle {
		font-size:10px;
		text-align:left;}
	.detaller {
		font-size:10px;
		text-align:right;}
	.detallec {
		font-size:10px;
		text-align:center;}	
		
	.mensaje {
		font-size:14px;
		text-align:center;}
	.paginacion {
		font-size:14px;
		text-align:center;}
</style>


<cfinvoke key="LB_Periodo" default="Per&iacute;odo" returnvariable="LB_Periodo" component="sif.Componentes.Translate"  method="Translate"/>
<cfinvoke key="LB_del" default="del" returnvariable="LB_del" component="sif.Componentes.Translate"  method="Translate"/>
<cfinvoke key="LB_al" default="al" returnvariable="LB_al" component="sif.Componentes.Translate"  method="Translate"/>
<cfinvoke key="LB_Indefinido" default="Indefinido" returnvariable="LB_Indefinido" component="sif.Componentes.Translate"  method="Translate"/>
<cfinvoke key="LB_CentroFuncional" default="Centro Funcional" returnvariable="LB_CentroFuncional" component="sif.Componentes.Translate"  method="Translate"/>
<cfinvoke key="LB_Puesto" default="Puesto" returnvariable="LB_Puesto" component="sif.Componentes.Translate"  method="Translate"/>
<cfinvoke key="LB_Empleado" default="Empleado" returnvariable="LB_Empleado" component="sif.Componentes.Translate"  method="Translate"/>
<cfinvoke key="LB_Inicial" default="inicial" returnvariable="LB_Inicial" component="sif.Componentes.Translate"  method="Translate"/>
<cfinvoke key="LB_Final" default="final" returnvariable="LB_Final" component="sif.Componentes.Translate"  method="Translate"/>
<cfinvoke key="LB_IncluyeDependencias" default="(Incluye dependencias)" returnvariable="LB_IncluyeDependencias" component="sif.Componentes.Translate"  method="Translate"/>

<cfset filtro1='#LB_Periodo#'>								
<cfset filtro2 = ''>
<cfset filtro3 = ''>
<cfset filtro4 = ''>
<cfset filtro5 = ''>

<cfset param = ''>

<cfif isdefined("url.Fdesde") and len(trim(url.Fdesde)) and isdefined("url.Fhasta") and len(trim(url.Fhasta))>
	<cfset filtro1=filtro1 & ' #LB_del# #LSDateFormat(url.Fdesde,'dd/mm/yyyy')# #LB_al# #LSDateFormat(url.Fhasta,'dd/mm/yyyy')#'>
	<cfset param = param & '&Fdesde=#url.Fdesde#&Fhasta=#url.Fhasta#'>
<cfelseif isdefined("url.Fdesde") and len(trim(url.Fdesde)) and (not isdefined("url.Fhasta") and len(trim(url.Fhasta)) EQ 0 )>
	<cfset param = param & '&Fdesde=#url.Fdesde#'>
<cfelseif isdefined("url.Fhasta") and len(trim(url.Fhasta)) and (not isdefined("url.Fdesde") and len(trim(url.Fdesde)) EQ 0 )>
	<cfset param = param & '&Fhasta=#url.Fhasta#'>
<cfelseif (not isdefined("url.Fdesde") or len(trim(url.Fdesde)) EQ 0) and (not isdefined("url.Fhasta") or len(trim(url.Fhasta)) EQ 0)>
	<cfset filtro1=filtro1 & ' #LB_Indefinido#'>	
</cfif>

<cfif isdefined("url.CFid") and len(trim(url.CFid))>
	<cfset filtro2= '#LB_CentroFuncional#: #CFuncional.CFcodigo# - #CFuncional.CFdescripcion#'>
	<cfset param = param & '&CFid=#url.CFid#'>
	<cfif isdefined("url.chkDependencias")>
		<cfset filtro2= filtro2 & ' #LB_IncluyeDependencias# '>
		<cfset param = param & '&chkDependencias=#url.chkDependencias#'>
	</cfif>
</cfif>				

<cfif isdefined("url.RHPcodigo") and len(trim(url.RHPcodigo))>
	<cfquery name="rsPuesto" datasource="#session.DSN#">
		select RHPcodigo, RHPdescpuesto
		from RHPuestos
		where RHPcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.RHPcodigo#">
	</cfquery>
	<cfset filtro3= '#LB_Puesto#: #rsPuesto.RHPcodigo# - #rsPuesto.RHPdescpuesto#'>
	<cfset param = param & '&RHPcodigo=#url.RHPcodigo#'>
</cfif>	

<cfif isdefined('url.DEidentificacion') and LEN(TRIM(url.DEidentificacion)) and len(trim(url.DEidentificacion1)) EQ 0>
	<cfquery name="rsEmpleado" datasource="#session.DSN#">
		select <cf_dbfunction name="concat" args="DEnombre,' ',DEapellido1,' ',DEapellido2"> as Empleado
		from DatosEmpleado
		where DEidentificacion = <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.DEidentificacion#">
	</cfquery>
	<cfset filtro4 = '#LB_Empleado#: #rsEmpleado.Empleado#'>
	<cfset param = param & '&DEidentificacion=#url.DEidentificacion#'>
<cfelseif isdefined('url.DEidentificacion1') and LEN(TRIM(url.DEidentificacion1)) and len(trim(url.DEidentificacion)) EQ 0>
	<cfquery name="rsEmpleado" datasource="#session.DSN#">
		select <cf_dbfunction name="concat" args="DEnombre,' ',DEapellido1,' ',DEapellido2"> as Empleado
		from DatosEmpleado
		where DEidentificacion = <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.DEidentificacion1#">
	</cfquery>
	<cfset filtro4 = '#LB_Empleado#: #rsEmpleado.Empleado#'>
	<cfset param = param & '&DEidentificacion1=#url.DEidentificacion1#'>
<cfelseif isdefined('url.DEidentificacion') and LEN(TRIM(url.DEidentificacion)) and isdefined('url.DEidentificacion1') and LEN(TRIM(url.DEidentificacion1))>
	<cfquery name="rsEmpleado" datasource="#session.DSN#">
		select <cf_dbfunction name="concat" args="DEnombre,' ',DEapellido1,' ',DEapellido2"> as Empleado
		from DatosEmpleado
		where DEidentificacion = <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.DEidentificacion#">
	</cfquery>
	<cfquery name="rsEmpleado1" datasource="#session.DSN#">
		select <cf_dbfunction name="concat" args="DEnombre,' ',DEapellido1,' ',DEapellido2"> as Empleado
		from DatosEmpleado
		where DEidentificacion = <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.DEidentificacion1#">
	</cfquery>
	<cfset param = param & '&DEidentificacion=#url.DEidentificacion#&DEidentificacion1=#url.DEidentificacion1#'>
	<cfset filtro4 = '#LB_Empleado# #LB_Inicial#: #rsEmpleado.Empleado#'>
	<cfset filtro5 = '#LB_Empleado# #LB_Final#: #rsEmpleado1.Empleado#'>
</cfif>			

<cf_htmlReportsHeaders 
	title="#LB_LibroDeSalarios#" 
	filename="LibroDeSalariosCR#Session.Usucodigo#-#DateFormat(Now(),'yyyymmdd')#-#TimeFormat(Now(),'hhmmss')#.xls"
	irA="ReporteLibroSalariosCR.cfm"
	param="#param#"
	>
	
    <table width="100%" border="0" cellpadding="2" cellspacing="0" align="center" style="border-color:CCCCCC">
		<cfoutput>
		 <tr>
			<td colspan="21">
				<table width="100%" cellpadding="0" cellspacing="0">
					<tr><td>
						<cf_EncReporte
							Titulo="#LB_LibroDeSalarios#"
							Color="##E3EDEF"
							filtro1="#filtro1#"
							filtro2="#filtro2#"
							filtro3="#filtro3#"
							filtro4="#filtro4#"
							filtro5="#filtro5#"
						>
					</td></tr>
				</table>
			</td>
		</tr>
		<!----===================== ENCABEZADO ANTERIOR =====================---->
        <!----
		<tr><td align="center" class="titulo_empresa2" colspan="21"><strong>#rsEmpresa.Edescripcion#</strong></td></tr>
        <tr><td align="center" class="titulo_empresa2" colspan="21"><strong>#LB_LibroDeSalarios#</strong></td></tr>
        <tr><td align="center" class="titulo_empresa2" colspan="21"><strong>#LB_FechaRige#: #url.Fdesde# &nbsp; #LB_FechaVence#: #url.Fhasta#	</strong></td></tr>
        <tr><td>&nbsp;</td></tr>
		----->		
        </cfoutput>
        <tr><td height="1" bgcolor="000000" colspan="21"></td>
		<cfif rsReporte.RecordCount neq 0>
        <cfoutput query="rsReporte" group="DEid">
			<tr class="listaCorte1"><td colspan="21">#DEidentificacion#&nbsp;-&nbsp;#NombreEmp#</td></tr>
            <tr><td height="1" bgcolor="000000" colspan="21"></td>
            <tr class="listaCorte3">
            	<td nowrap ><cf_translate key="LB_Periodo">Periodo</cf_translate></td>
                <td nowrap align="right">&nbsp;<cf_translate key="LB_SalarioBase">Salario Base</cf_translate></td>
                <td nowrap align="right">&nbsp;<cf_translate key="LB_Prohibicion">Prohibici&oacute;n</cf_translate></td>
                <td nowrap align="right">&nbsp;<cf_translate key="LB_PagoDeComision">Pago de Comisi&oacute;n</cf_translate></td>				
		<td nowrap align="right">&nbsp;<cf_translate key="LB_Bonificaciones">Bonificaciones</cf_translate></td>				
                <td nowrap align="right">&nbsp;<cf_translate key="LB_Subsidios">Subsidios</cf_translate></td>
                <td nowrap align="right">&nbsp;<cf_translate key="LB_Otros">Otros</cf_translate></td>               
                <td nowrap align="right">&nbsp;<cf_translate key="LB_Bruto">Bruto</cf_translate></td>
            </tr>
            <tr><td height="1" bgcolor="000000" colspan="21"></td>
            <cfsilent>
            	<cfset Lvar_Count 	= 0>
                <cfset Lvar_TotalOrd 	= 0>
                <cfset Lvar_TotalProh   = 0>
                <!---<cfset Lvar_TotalAjustes= 0>--->
                <cfset Lvar_TotalSubsi	= 0>
                <cfset Lvar_TotalOtros 	= 0>
                <cfset Lvar_TotalComis 	= 0>
                <cfset Lvar_TotalBono 	= 0>
                <cfset Lvar_TotalBruto 	= 0>
            </cfsilent>
            <cfoutput>
				 <tr>
                    <td class="detalle" nowrap><cfif CPmes LTE 9>0</cfif>#CPmes#/#CPperiodo#</td>
	                <td class="detaller" nowrap>#LSCurrencyFormat(Ordinario,'none')#</td>   
	                <td class="detaller" nowrap>#LSCurrencyFormat(Prohibicion,'none')#</td>
                    	<td class="detaller" nowrap>#LSCurrencyFormat(Comisiones,'none')#</td>
		    	<td class="detaller" nowrap>#LSCurrencyFormat(Bonificacion,'none')#</td>					
<!---                    	<td class="detaller" nowrap>#LSCurrencyFormat(Ajustes,'none')#</td>--->
			<td class="detaller" nowrap>#LSCurrencyFormat(Subsidios,'none')#</td>
                    	<td class="detaller" nowrap>#LSCurrencyFormat(Otros,'none')#</td>
                    	<td class="detaller" nowrap>#LSCurrencyFormat(MontoBruto,'none')#</td>
                </tr>
                <!--- SUMA PARA LOS TOTALES --->
                <cfsilent>
					<cfset Lvar_Count 		= Lvar_Count + 1>
					<cfset Lvar_TotalOrd 	= Lvar_TotalOrd + Ordinario>
					<cfset Lvar_TotalProh 	= Lvar_TotalProh + Prohibicion>
					<!---<cfset Lvar_TotalAjustes = Lvar_TotalAjustes + Ajustes>--->
					<cfset Lvar_TotalOtros 	= Lvar_TotalOtros + Otros>
					<cfset Lvar_TotalComis 	= Lvar_TotalComis + Comisiones>
				        <cfset Lvar_TotalSubsi	= Lvar_TotalSubsi + Subsidios>
					<cfset Lvar_TotalBono 	= Lvar_TotalBono + Bonificacion>
					<cfset Lvar_TotalBruto 	= Lvar_TotalBruto+ MontoBruto>
                </cfsilent>
			</cfoutput>
            <tr><td height="1" bgcolor="000000" colspan="21"></td>
            <tr>
                <td class="detalle" nowrap><cf_translate key="LB_Sumas">Sumas</cf_translate></td>
                <td class="detaller" nowrap>#LSCurrencyFormat(Lvar_TotalOrd,'none')#</td>
                <td class="detaller" nowrap>#LSCurrencyFormat(Lvar_TotalProh,'none')#</td>
		<td class="detaller" nowrap>#LSCurrencyFormat(Lvar_TotalComis,'none')#</td>
                <td class="detaller" nowrap>#LSCurrencyFormat(Lvar_TotalBono,'none')#</td>
<!---                <td class="detaller" nowrap>#LSCurrencyFormat(Lvar_TotalAjustes,'none')#</td>--->
		<td class="detaller" nowrap>#LSCurrencyFormat(Lvar_TotalSubsi,'none')#</td>
                <td class="detaller" nowrap>#LSCurrencyFormat(Lvar_TotalOtros,'none')#</td>
		<td class="detaller" nowrap>#LSCurrencyFormat(Lvar_TotalBruto,'none')#</td>
            </tr>
            <tr><td height="1" bgcolor="000000" colspan="21"></td>
             <!---tr>
                <td class="detalle" nowrap><cf_translate key="LB_Promedios">Promedios</cf_translate></td>
                <td class="detallec" nowrap>&nbsp;</td>
                <td class="detallec" nowrap>&nbsp;</td>
                <td class="detaller" nowrap>&nbsp;</td>
                <td class="detaller" nowrap>#LSCurrencyFormat(Lvar_TotalOrd/Lvar_Count,'none')#</td>
                <td class="detaller" nowrap>#LSCurrencyFormat(Lvar_TotalBono/Lvar_Count,'none')#</td>
                <td class="detaller" nowrap>#LSCurrencyFormat(Lvar_TotalExtraS/Lvar_Count,'none')#</td>
                <td class="detaller" nowrap>#LSCurrencyFormat(Lvar_TotalExtraD/Lvar_Count,'none')#</td>
                <td class="detaller" nowrap>&nbsp;</td>
                <td class="detaller" nowrap>#LSCurrencyFormat(Lvar_TotalVaca/Lvar_Count,'none')#</td>
                <td class="detaller" nowrap>&nbsp;</td>
                <td class="detaller" nowrap>&nbsp;</td>
                <td class="detaller" nowrap>#LSCurrencyFormat(Lvar_TotalComis/Lvar_Count,'none')#</td>
                <td class="detaller" nowrap>#LSCurrencyFormat(Lvar_TotalSept/Lvar_Count,'none')#</td>
                <td class="detaller" nowrap colspan="7">&nbsp;</td>
            </tr--->
            <tr><td height="1" bgcolor="000000" colspan="21"></td>
		</cfoutput><!--- CORTE POR EMPLEADO --->
		<CFELSE>
			<TR><td align="center">----- <cf_translate key="LB_NoSeEncontraronRegistros">No se encontraron registros</cf_translate> -----</td></TR>
		</cfif>
    </table>
<cfelse>
	<table width="100%" border="0" cellpadding="2" cellspacing="0" align="center">
    	<tr class="titulo_empresa2"><td align="center">No se han definido las columnas del reporte.</td></tr>
    </table>
</cfif>