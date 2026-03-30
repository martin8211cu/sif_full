<cfif isdefined("url.chkDependencias") and isdefined('url.CFid') and url.CFid GT 0>
	<cfinvoke component="sif.rh.Componentes.RH_Funciones" method="CFDependencias"
		cfid = "#url.CFid#"
		nivel = "5"
		returnvariable="Dependencias"/>
	<cfset Centros = ValueList(Dependencias.CFid)>
</cfif>
<cfif isdefined('url.TipoNomina')>
	<cfset tablaCalculoNomina = 'HRCalculoNomina'>
	<cfset tablaDeduccionesCalculo = 'HDeduccionesCalculo'>
	<cfset tablaSalarioEmpleado = 'HSalarioEmpleado'>
	<cfset tablaPagosEmpleado = 'HPagosEmpleado'> 
	<cfset tablaIncidenciasCalculo = 'HIncidenciasCalculo'> 
	<cfset tablaCargasCalculo = 'HCargasCalculo'>
<cfelse>
	<cfset tablaCalculoNomina = 'RCalculoNomina'>
	<cfset tablaDeduccionesCalculo = 'DeduccionesCalculo'>
	<cfset tablaSalarioEmpleado = 'SalarioEmpleado'>
	<cfset tablaPagosEmpleado = 'PagosEmpleado'>
	<cfset tablaIncidenciasCalculo = 'IncidenciasCalculo'> 
	<cfset tablaCargasCalculo = 'CargasCalculo'>
</cfif>

<cfquery name="rsVerificaReporte" datasource="#session.DSN#">
	select 1
    from RHReportesNomina
    where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
      and RHRPTNcodigo = 'RFPP'
</cfquery>
<cfquery name="rsNomina" datasource="#session.DSN#">
	select RCdesde, RChasta,coalesce(CPdescripcion,RCdescripcion) as Descripcion
	from #tablaCalculoNomina# a
	inner join CalendarioPagos b
		on b.CPid = a.RCNid
	where RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.CPid#">
</cfquery>


<cfif isdefined('rsVerificaReporte') and rsVerificaReporte.RecordCount>
<!--- VARIABLES DE TRADUCCION --->
<cfinvoke key="LB_PLANILLADEPAGOS" default="PLANILLA DE PAGOS" returnvariable="LB_PLANILLADEPAGOS" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_PLANILLADEPAGOSPORDEPARTAMENTO" default="PLANILLA DE PAGOS POR DEPARTAMENTO" returnvariable="LB_PLANILLADEPAGOSPORDEPARTAMENTO" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_NoHayDatosRelacionados" default="No hay datos relacionados" returnvariable="LB_NoHayDatosRelacionados" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_Fecha" default="Fecha" returnvariable="LB_Fecha" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_FechaRige" default="Fecha Rige" returnvariable="LB_FechaRige"  component="sif.Componentes.Translate" method="Translate" />
<cfinvoke key="LB_FechaVence" default="Fecha Vence" returnvariable="LB_FechaVence" component="sif.Componentes.Translate" method="Translate"/>
<!--- FIN VARIABLES DE TRADUCCION --->

	<!--- Tabla temporal de resultados --->
	<cf_dbtemp name="RPlanillaF" returnvariable="salida">
        <cf_dbtempcol name="RCNid"   		  type="int"      	  mandatory="yes">
		<cf_dbtempcol name="LTid"   		  type="int"      	  mandatory="yes">
		<cf_dbtempcol name="DEid"   		  type="int"      	  mandatory="yes">
		<cf_dbtempcol name="DEidentificacion" type="varchar(60)"  mandatory="yes">
		<cf_dbtempcol name="Nombre"   		  type="varchar(255)" mandatory="yes">
		<cf_dbtempcol name="Dias"	  		  type="int"      	  mandatory="no">
		<cf_dbtempcol name="Ordinario"		  type="money"     	  mandatory="no">
		<cf_dbtempcol name="Bono"			  type="money"     	  mandatory="no">
		<cf_dbtempcol name="Bonificacion" 	  type="money"   	  mandatory="no">
		<cf_dbtempcol name="Comision" 	  	  type="money"   	  mandatory="no">
		<cf_dbtempcol name="VariosIngresos"	  type="money"    	  mandatory="no">
		<cf_dbtempcol name="TotalIngresos"	  type="money"    	  mandatory="no">
		<cf_dbtempcol name="IGSS"	  		  type="money"    	  mandatory="no">
		<cf_dbtempcol name="ISR"	 		  type="money"  	  mandatory="no">
		<cf_dbtempcol name="BanTrab" 		  type="money"  	  mandatory="no">
		<cf_dbtempcol name="Anticipo" 	  	  type="money"    	  mandatory="no">
		<cf_dbtempcol name="VariosDesc"		  type="money"    	  mandatory="no">
		<cf_dbtempcol name="TotalDesc" 		  type="money"    	  mandatory="no">
		<cf_dbtempcol name="Liquido" 		  type="money"    	  mandatory="no">
		<cf_dbtempcol name="CFid"   		  type="int"      	  mandatory="yes">
		<cf_dbtempkey cols="DEid">
	</cf_dbtemp> 
    <!--- INGRESA LOS DATOS DE LOS CALENDARIOS DE PAGO DEL EMPLEADO --->
	<cfquery name="rsCalendarios" datasource="#session.dsn#">	
 	 	insert into #salida#(RCNid,DEid, DEidentificacion,Nombre, Ordinario,LTid,CFid)
			Select <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.CPid#"> as RCNid,
				a.DEid, b.DEidentificacion, 
				{fn concat(DEnombre,{fn concat(' ',{fn concat(DEapellido1,{fn concat(' ',DEapellido2)})})})},
				sum(SEsalariobruto),max(LTid) as LTid,
				max(e.CFid) as CFid
			from #tablaSalarioEmpleado# a
			inner join DatosEmpleado b
				on b.DEid = a.DEid
				and b.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
				<cfif isdefined('url.DEid') and LEN(TRIM(url.DEid))>
				and b.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.DEid#"> 
				</cfif>
			inner join #tablaCalculoNomina# c
				  on c.RCNid = a.RCNid
			inner join LineaTiempo d
				  on d.DEid = b.DEid
				   and (c.RCdesde between LTdesde and LThasta
			  	  or c.RChasta between LTdesde and LThasta) 
			inner join RHPlazas e
				  on e.RHPid = d.RHPid
			<cfif isdefined("url.chkDependencias") and isdefined('url.CFid') and url.CFid GT 0 and (not isdefined('url.DEid') or LEN(TRIM(url.DEid)) EQ 0)>
				and e.CFid in (#Centros#)
			<cfelseif isdefined('url.CFid') and url.CFid GT 0 and (not isdefined('url.DEid') or LEN(TRIM(url.DEid)) EQ 0)>
				and e.CFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.CFid#"> 
			</cfif>
			where a.RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.CPid#"> 
			group by a.DEid, b.DEidentificacion, 
				{fn concat(DEnombre,{fn concat(' ',{fn concat(DEapellido1,{fn concat(' ',DEapellido2)})})})},
				SEsalariobruto
	</cfquery>
	<!--- ACTUALIZA EL CENTRO FUNCIONAL DE CONTABILIZACION --->
	<cfquery name="rsCFid" datasource="#session.DSN#">
		update #salida#
		set CFid = coalesce((select CFidconta
					from LineaTiempo a
					inner join RHPlazas b
						  on b.RHPid = a.RHPid
					where DEid = #salida#.DEid
					  and LTid = #salida#.LTid),CFid)
	</cfquery>
	<!--- ACTUALIZA LOS DIAS PAGADOS EN EL CALENDARIO DE PAGO --->
	<cfquery name="rsDias" datasource="#session.DSN#">
    	update #salida#
        set Dias = coalesce((select sum(PEcantdias)
        			from #tablaPagosEmpleado# a
                   	where a.RCNid = #salida#.RCNid
                      and a.DEid = #salida#.DEid
                    group by a.RCNid),0)
    </cfquery>
    <!--- SALARIO ORDINARIO --->
     <cfquery name="rsSalarioOrd" datasource="#session.DSN#">
    	update #salida#
        set Ordinario = coalesce((select SEsalariobruto
        							 from #tablaSalarioEmpleado# hse
                                     where hse.RCNid = #salida#.RCNid
                                       and hse.DEid = #salida#.DEid
        							),0.00)
   	</cfquery>
    <!--- MONTO DE INCIDENCIAS POR HORAS --->
	<!--- SUMA LAS INCIDENCIAS QUE SE INDICARON EN LA DEFINICION DEL REPORTE --->
	<cfquery name="rsHorasExtra" datasource="#session.DSN#">
    	update #salida#
        set Ordinario = Ordinario + coalesce((
								select sum(a.ICmontores) 
								from #tablaIncidenciasCalculo# a
								where a.DEid = #salida#.DEid
								and a.RCNid = #salida#.RCNid 
								and CIid in (select distinct a.CIid
											from RHReportesNomina c
												inner join RHColumnasReporte b
															inner join RHConceptosColumna a
															on a.RHCRPTid = b.RHCRPTid
													 on b.RHRPTNid = c.RHRPTNid
													and rtrim(ucase(b.RHCRPTcodigo)) = ucase('ORDINARIO')
											where rtrim(ucase(c.RHRPTNcodigo)) = ucase('RFPP')
											  and c.Ecodigo = #session.Ecodigo#)), 0.00)
								- ( coalesce((	select sum(a.DCvalor) 
												from #tablaDeduccionesCalculo# a, DeduccionesEmpleado b,TDeduccion z
												where a.DEid = #salida#.DEid 
												and a.RCNid = #salida#.RCNid 
												and a.DEid = b.DEid
												and a.Did = b.Did
												and b.TDid=z.TDid
												and z.TDid in (select distinct a.TDid
														from RHReportesNomina c
															inner join RHColumnasReporte b
																		inner join RHConceptosColumna a
																		on a.RHCRPTid = b.RHCRPTid
																 on b.RHRPTNid = c.RHRPTNid
																and rtrim(ucase(b.RHCRPTcodigo)) = ucase('ORDINARIO')
														where rtrim(ucase(c.RHRPTNcodigo)) = ucase('RFPP')
														  and c.Ecodigo = #session.Ecodigo#)),0.00)
									+ coalesce((
											select sum(a.CCvaloremp) 	
											from #tablaCargasCalculo# a, DCargas b, ECargas c
											where a.DEid = #salida#.DEid
											  and a.RCNid = #salida#.RCNid
											  and b.DClinea = a.DClinea
											  and c.ECid = b.ECid
											  and b.DClinea in (select distinct a.DClinea
														from RHReportesNomina c
															inner join RHColumnasReporte b
																		inner join RHConceptosColumna a
																		on a.RHCRPTid = b.RHCRPTid
																 on b.RHRPTNid = c.RHRPTNid
																and rtrim(ucase(b.RHCRPTcodigo)) = ucase('ORDINARIO')
														where rtrim(ucase(c.RHRPTNcodigo)) = ucase('RFPP')
														  and c.Ecodigo = #session.Ecodigo#)),0.00)
								
								
								)
    </cfquery> 

    <!---BONIFICACION--->
    <cfquery name="rsMontoExtraA" datasource="#session.DSN#">
    	update #salida#
        set Bono = coalesce((
								select sum(a.ICmontores) 
								from #tablaIncidenciasCalculo# a
								where a.DEid = #salida#.DEid
								and a.RCNid = #salida#.RCNid 
								and CIid in (select distinct a.CIid
											from RHReportesNomina c
												inner join RHColumnasReporte b
															inner join RHConceptosColumna a
															on a.RHCRPTid = b.RHCRPTid
													 on b.RHRPTNid = c.RHRPTNid
													and rtrim(ucase(b.RHCRPTcodigo)) = ucase('Bono')
											where rtrim(ucase(c.RHRPTNcodigo)) = ucase('RFPP')
											  and c.Ecodigo = #session.Ecodigo#)), 0.00)
								- ( coalesce((	select sum(a.DCvalor) 
												from #tablaDeduccionesCalculo# a, DeduccionesEmpleado b,TDeduccion z
												where a.DEid = #salida#.DEid 
												and a.RCNid = #salida#.RCNid 
												and a.DEid = b.DEid
												and a.Did = b.Did
												and b.TDid=z.TDid
												and z.TDid in (select distinct a.TDid
														from RHReportesNomina c
															inner join RHColumnasReporte b
																		inner join RHConceptosColumna a
																		on a.RHCRPTid = b.RHCRPTid
																 on b.RHRPTNid = c.RHRPTNid
																and rtrim(ucase(b.RHCRPTcodigo)) = ucase('Bono')
														where rtrim(ucase(c.RHRPTNcodigo)) = ucase('RFPP')
														  and c.Ecodigo = #session.Ecodigo#)),0.00)
									+ coalesce((
											select sum(a.CCvaloremp) 	
											from #tablaCargasCalculo# a, DCargas b, ECargas c
											where a.DEid = #salida#.DEid
											  and a.RCNid = #salida#.RCNid
											  and b.DClinea = a.DClinea
											  and c.ECid = b.ECid
											  and b.DClinea in (select distinct a.DClinea
														from RHReportesNomina c
															inner join RHColumnasReporte b
																		inner join RHConceptosColumna a
																		on a.RHCRPTid = b.RHCRPTid
																 on b.RHRPTNid = c.RHRPTNid
																and rtrim(ucase(b.RHCRPTcodigo)) = ucase('Bono')
														where rtrim(ucase(c.RHRPTNcodigo)) = ucase('RFPP')
														  and c.Ecodigo = #session.Ecodigo#)),0.00)
								
								
								)
    </cfquery>
    <!---BONIFICACION 37-2001 --->
    <cfquery name="rsMontoExtraA" datasource="#session.DSN#">
    	update #salida#
        set Bonificacion =  coalesce((
								select sum(a.ICmontores) 
								from #tablaIncidenciasCalculo# a
								where a.DEid = #salida#.DEid
								and a.RCNid = #salida#.RCNid 
								and CIid in (select distinct a.CIid
											from RHReportesNomina c
												inner join RHColumnasReporte b
															inner join RHConceptosColumna a
															on a.RHCRPTid = b.RHCRPTid
													 on b.RHRPTNid = c.RHRPTNid
													and rtrim(ucase(b.RHCRPTcodigo)) = ucase('Bonificacion')
											where  rtrim(ucase(c.RHRPTNcodigo)) = ucase('RFPP')
											  and c.Ecodigo = #session.Ecodigo#)), 0.00)
								- ( coalesce((	select sum(a.DCvalor) 
												from #tablaDeduccionesCalculo# a, DeduccionesEmpleado b,TDeduccion z
												where a.DEid = #salida#.DEid 
												and a.RCNid = #salida#.RCNid 
												and a.DEid = b.DEid
												and a.Did = b.Did
												and b.TDid=z.TDid
												and z.TDid in (select distinct a.TDid
														from RHReportesNomina c
															inner join RHColumnasReporte b
																		inner join RHConceptosColumna a
																		on a.RHCRPTid = b.RHCRPTid
																 on b.RHRPTNid = c.RHRPTNid
																and ucase(b.RHCRPTcodigo) = ucase('Bonificacion')
														where ucase(c.RHRPTNcodigo) = ucase('RFPP')
														  and c.Ecodigo = #session.Ecodigo#)),0.00)
									+ coalesce((
											select sum(a.CCvaloremp) 	
											from #tablaCargasCalculo# a, DCargas b, ECargas c
											where a.DEid = #salida#.DEid
											  and a.RCNid = #salida#.RCNid
											  and b.DClinea = a.DClinea
											  and c.ECid = b.ECid
											  and b.DClinea in (select distinct a.DClinea
														from RHReportesNomina c
															inner join RHColumnasReporte b
																		inner join RHConceptosColumna a
																		on a.RHCRPTid = b.RHCRPTid
																 on b.RHRPTNid = c.RHRPTNid
																and ucase(b.RHCRPTcodigo) = ucase('Bonificacion')
														where ucase(c.RHRPTNcodigo) = ucase('RFPP')
														  and c.Ecodigo = #session.Ecodigo#)),0.00)
								
								
								)
    </cfquery>

	<!--- COMISIONES --->
	<cfquery name="rsComision" datasource="#session.DSN#">
    	update #salida#
        set Comision = coalesce((
								select sum(a.ICmontores) 
								from #tablaIncidenciasCalculo# a
								where a.DEid = #salida#.DEid
								and a.RCNid = #salida#.RCNid 
								and CIid in (select distinct a.CIid
											from RHReportesNomina c
												inner join RHColumnasReporte b
															inner join RHConceptosColumna a
															on a.RHCRPTid = b.RHCRPTid
													 on b.RHRPTNid = c.RHRPTNid
													and rtrim(ucase(b.RHCRPTcodigo)) = ucase('COMISION')
											where rtrim(ucase(c.RHRPTNcodigo)) = ucase('RFPP')
											  and c.Ecodigo = #session.Ecodigo#)), 0.00)
						- ( coalesce((	select sum(a.DCvalor) 
												from #tablaDeduccionesCalculo# a, DeduccionesEmpleado b,TDeduccion z
												where a.DEid = #salida#.DEid 
												and a.RCNid = #salida#.RCNid 
												and a.DEid = b.DEid
												and a.Did = b.Did
												and b.TDid=z.TDid
												and z.TDid in (select distinct a.TDid
														from RHReportesNomina c
															inner join RHColumnasReporte b
																		inner join RHConceptosColumna a
																		on a.RHCRPTid = b.RHCRPTid
																 on b.RHRPTNid = c.RHRPTNid
																and rtrim(ucase(b.RHCRPTcodigo)) = ucase('COMISION')
														where rtrim(ucase(c.RHRPTNcodigo)) = ucase('RFPP')
														  and c.Ecodigo = #session.Ecodigo#)),0.00)
									+ coalesce((
											select sum(a.CCvaloremp) 	
											from #tablaCargasCalculo# a, DCargas b, ECargas c
											where a.DEid = #salida#.DEid
											  and a.RCNid = #salida#.RCNid
											  and b.DClinea = a.DClinea
											  and c.ECid = b.ECid
											  and b.DClinea in (select distinct a.DClinea
														from RHReportesNomina c
															inner join RHColumnasReporte b
																		inner join RHConceptosColumna a
																		on a.RHCRPTid = b.RHCRPTid
																 on b.RHRPTNid = c.RHRPTNid
																and rtrim(ucase(b.RHCRPTcodigo)) = ucase('COMISION')
														where rtrim(ucase(c.RHRPTNcodigo)) = ucase('RFPP')
														  and c.Ecodigo = #session.Ecodigo#)),0.00)
								)
    </cfquery>

    <!--- Varios Ingresos --->
    <cfquery name="rsVacaciones" datasource="#session.DSN#">
    	update #salida#
			set VariosIngresos = coalesce((
					select sum(a.ICmontores) 
					from #tablaIncidenciasCalculo# a
					 where a.DEid = #salida#.DEid
					and a.RCNid = #salida#.RCNid 
					and CIid in (select distinct a.CIid
								from RHReportesNomina c
									inner join RHColumnasReporte b
												inner join RHConceptosColumna a
												on a.RHCRPTid = b.RHCRPTid
										 on b.RHRPTNid = c.RHRPTNid
										and rtrim(ucase(b.RHCRPTcodigo)) = ucase('VariosI')
								where rtrim(ucase(c.RHRPTNcodigo)) = ucase('RFPP')
								  and c.Ecodigo = #session.Ecodigo#)),0)
								  
				- ( coalesce((	select sum(a.DCvalor) 
								from #tablaDeduccionesCalculo# a, DeduccionesEmpleado b,TDeduccion z
								where a.DEid = #salida#.DEid 
								and a.RCNid = #salida#.RCNid 
								and a.DEid = b.DEid
								and a.Did = b.Did
								and b.TDid=z.TDid
								and z.TDid in (select distinct a.TDid
										from RHReportesNomina c
											inner join RHColumnasReporte b
														inner join RHConceptosColumna a
														on a.RHCRPTid = b.RHCRPTid
												 on b.RHRPTNid = c.RHRPTNid
												and rtrim(ucase(b.RHCRPTcodigo)) = ucase('VariosI')
										where rtrim(ucase(c.RHRPTNcodigo)) = ucase('RFPP')
										  and c.Ecodigo = #session.Ecodigo#)),0.00)
					+ coalesce((
							select sum(a.CCvaloremp) 	
							from #tablaCargasCalculo# a, DCargas b, ECargas c
							where a.DEid = #salida#.DEid
							  and a.RCNid = #salida#.RCNid
							  and b.DClinea = a.DClinea
							  and c.ECid = b.ECid
							  and b.DClinea in (select distinct a.DClinea
										from RHReportesNomina c
											inner join RHColumnasReporte b
														inner join RHConceptosColumna a
														on a.RHCRPTid = b.RHCRPTid
												 on b.RHRPTNid = c.RHRPTNid
												and rtrim(ucase(b.RHCRPTcodigo)) = ucase('VariosI')
										where rtrim(ucase(c.RHRPTNcodigo)) = ucase('RFPP')
										  and c.Ecodigo = #session.Ecodigo#)),0.00)
				
				
				)	
    </cfquery>
	
    <!--- IGSS --->
    <cfquery name="rsCargas" datasource="#session.DSN#">
    	update #salida#
			set IGSS = coalesce((
									select sum(a.CCvaloremp) 	
									from #tablaCargasCalculo# a
									inner join DCargas b
										  on b.DClinea = a.DClinea
									inner join ECargas c
										  on c.ECid = b.ECid
										  and c.ECauto = 1
									where a.DEid = #salida#.DEid
									and a.RCNid = #salida#.RCNid),0.00)
    </cfquery>
    
    <!--- ISR --->
	<cfquery name="rsSalarioOrd" datasource="#session.DSN#">
    	update #salida#
        set ISR = coalesce((select SErenta
        							 from #tablaSalarioEmpleado# hse
                                     where hse.RCNid = #salida#.RCNid
                                       and hse.DEid = #salida#.DEid
        							),0.00)
   	</cfquery>
    <cfquery name="rsISR" datasource="#session.DSN#">
    	update #salida#
			set ISR = ISR+(coalesce((	select sum(a.DCvalor) 
						from #tablaDeduccionesCalculo# a, DeduccionesEmpleado b,TDeduccion z
						where a.DEid = #salida#.DEid
						and a.RCNid = #salida#.RCNid 
						and a.DEid = b.DEid
						and a.Did = b.Did
						and b.TDid=z.TDid
						and z.TDid in (select distinct a.TDid
								from RHReportesNomina c
									inner join RHColumnasReporte b
												inner join RHConceptosColumna a
												on a.RHCRPTid = b.RHCRPTid
										 on b.RHRPTNid = c.RHRPTNid
										and rtrim(ucase(b.RHCRPTcodigo)) = ucase('ISR')
								where rtrim(ucase(c.RHRPTNcodigo)) = ucase('RFPP')
								  and c.Ecodigo = #session.Ecodigo#)),0.00)
						+ coalesce((
								select sum(a.CCvaloremp) 	
								from #tablaCargasCalculo# a, DCargas b, ECargas c
								where a.DEid = #salida#.DEid
								  and a.RCNid = #salida#.RCNid
								  and b.DClinea = a.DClinea
								  and c.ECid = b.ECid
								  and b.DClinea in (select distinct a.DClinea
											from RHReportesNomina c
												inner join RHColumnasReporte b
															inner join RHConceptosColumna a
															on a.RHCRPTid = b.RHCRPTid
													 on b.RHRPTNid = c.RHRPTNid
													and rtrim(ucase(b.RHCRPTcodigo)) = ucase('ISR')
											where rtrim(ucase(c.RHRPTNcodigo)) = ucase('RFPP')
											  and c.Ecodigo = #session.Ecodigo#)),0.00))
						- ( coalesce((select sum(a.ICmontores) 
										from #tablaIncidenciasCalculo# a
										where a.DEid = #salida#.DEid
										and a.RCNid = #salida#.RCNid 
										and CIid in (select distinct a.CIid
													from RHReportesNomina c
														inner join RHColumnasReporte b
																	inner join RHConceptosColumna a
																	on a.RHCRPTid = b.RHCRPTid
															 on b.RHRPTNid = c.RHRPTNid
															and rtrim(ucase(b.RHCRPTcodigo)) = ucase('ISR')
													where rtrim(ucase(c.RHRPTNcodigo)) = ucase('RFPP')
													  and c.Ecodigo = #session.Ecodigo#)), 0.00))
    </cfquery>
	
    <!--- BANCO DE LOS TRABAJADORES --->
     <cfquery name="rsBanT" datasource="#session.DSN#">
    	update #salida#
			set BanTrab = (coalesce((	select sum(a.DCvalor) 
						from #tablaDeduccionesCalculo# a, DeduccionesEmpleado b,TDeduccion z
						where a.DEid = #salida#.DEid
						and a.RCNid = #salida#.RCNid 
						and a.DEid = b.DEid
						and a.Did = b.Did
						and b.TDid=z.TDid
						and z.TDid in (select distinct a.TDid
								from RHReportesNomina c
									inner join RHColumnasReporte b
												inner join RHConceptosColumna a
												on a.RHCRPTid = b.RHCRPTid
										 on b.RHRPTNid = c.RHRPTNid
										and rtrim(ucase(b.RHCRPTcodigo)) = ucase('BanTrab')
								where rtrim(ucase(c.RHRPTNcodigo)) = ucase('RFPP')
								  and c.Ecodigo = #session.Ecodigo#)),0.00)
						+ coalesce((
								select sum(a.CCvaloremp) 	
								from #tablaCargasCalculo# a, DCargas b, ECargas c
								where a.DEid = #salida#.DEid
								  and a.RCNid = #salida#.RCNid
								  and b.DClinea = a.DClinea
								  and c.ECid = b.ECid
								  and b.DClinea in (select distinct a.DClinea
											from RHReportesNomina c
												inner join RHColumnasReporte b
															inner join RHConceptosColumna a
															on a.RHCRPTid = b.RHCRPTid
													 on b.RHRPTNid = c.RHRPTNid
													and rtrim(ucase(b.RHCRPTcodigo)) = ucase('BanTrab')
											where rtrim(ucase(c.RHRPTNcodigo)) = ucase('RFPP')
											  and c.Ecodigo = #session.Ecodigo#)),0.00))
						- ( coalesce((select sum(a.ICmontores) 
										from #tablaIncidenciasCalculo# a
										where a.DEid = #salida#.DEid
										and a.RCNid = #salida#.RCNid 
										and CIid in (select distinct a.CIid
													from RHReportesNomina c
														inner join RHColumnasReporte b
																	inner join RHConceptosColumna a
																	on a.RHCRPTid = b.RHCRPTid
															 on b.RHRPTNid = c.RHRPTNid
															and rtrim(ucase(b.RHCRPTcodigo)) = ucase('BanTrab')
													where rtrim(ucase(c.RHRPTNcodigo)) = ucase('RFPP')
													  and c.Ecodigo = #session.Ecodigo#)), 0.00))

    </cfquery>
    <!--- ANTICIPOS --->
    <cfquery name="rsAnticipos" datasource="#session.DSN#">
    	update #salida#
			set Anticipo = (coalesce((	select sum(a.DCvalor) 
						from #tablaDeduccionesCalculo# a, DeduccionesEmpleado b,TDeduccion z
						where a.DEid = #salida#.DEid
						and a.RCNid = #salida#.RCNid 
						and a.DEid = b.DEid
						and a.Did = b.Did
						and b.TDid=z.TDid
						and z.TDid in (select distinct a.TDid
								from RHReportesNomina c
									inner join RHColumnasReporte b
												inner join RHConceptosColumna a
												on a.RHCRPTid = b.RHCRPTid
										 on b.RHRPTNid = c.RHRPTNid
										and rtrim(ucase(b.RHCRPTcodigo)) = ucase('Anticipos')
								where rtrim(ucase(c.RHRPTNcodigo)) = ucase('RFPP')
								  and c.Ecodigo = #session.Ecodigo#)),0.00)
						+ coalesce((
								select sum(a.CCvaloremp) 	
								from #tablaCargasCalculo# a, DCargas b, ECargas c
								where a.DEid = #salida#.DEid
								  and a.RCNid = #salida#.RCNid
								  and b.DClinea = a.DClinea
								  and c.ECid = b.ECid
								  and b.DClinea in (select distinct a.DClinea
											from RHReportesNomina c
												inner join RHColumnasReporte b
															inner join RHConceptosColumna a
															on a.RHCRPTid = b.RHCRPTid
													 on b.RHRPTNid = c.RHRPTNid
													and rtrim(ucase(b.RHCRPTcodigo)) = ucase('Anticipos')
											where rtrim(ucase(c.RHRPTNcodigo)) = ucase('RFPP')
											  and c.Ecodigo = #session.Ecodigo#)),0.00))
						- ( coalesce((select sum(a.ICmontores) 
										from #tablaIncidenciasCalculo# a
										where a.DEid = #salida#.DEid
										and a.RCNid = #salida#.RCNid 
										and CIid in (select distinct a.CIid
													from RHReportesNomina c
														inner join RHColumnasReporte b
																	inner join RHConceptosColumna a
																	on a.RHCRPTid = b.RHCRPTid
															 on b.RHRPTNid = c.RHRPTNid
															and rtrim(ucase(b.RHCRPTcodigo)) = ucase('Anticipos')
													where rtrim(ucase(c.RHRPTNcodigo)) = ucase('RFPP')
													  and c.Ecodigo = #session.Ecodigo#)), 0.00))
    </cfquery>
	<!--- VARIOS DESCUENTOS--->
	    <cfquery name="rsVariosDesc" datasource="#session.DSN#">
    	update #salida#
			set VariosDesc = (coalesce((	select sum(a.DCvalor) 
						from #tablaDeduccionesCalculo# a, DeduccionesEmpleado b,TDeduccion z
						where a.DEid = #salida#.DEid
						and a.RCNid = #salida#.RCNid 
						and a.DEid = b.DEid
						and a.Did = b.Did
						and b.TDid=z.TDid
						and z.TDid in (select distinct a.TDid
								from RHReportesNomina c
									inner join RHColumnasReporte b
												inner join RHConceptosColumna a
												on a.RHCRPTid = b.RHCRPTid
										 on b.RHRPTNid = c.RHRPTNid
										and rtrim(ucase(b.RHCRPTcodigo)) = ucase('VariosDesc')
								where rtrim(ucase(c.RHRPTNcodigo)) = ucase('RFPP')
								  and c.Ecodigo = #session.Ecodigo#)),0.00)
					+ coalesce((
								select sum(a.CCvaloremp) 	
								from #tablaCargasCalculo# a, DCargas b, ECargas c
								where a.DEid = #salida#.DEid
								  and a.RCNid = #salida#.RCNid
								  and b.DClinea = a.DClinea
								  and c.ECid = b.ECid
								  and b.DClinea in (select distinct a.DClinea
											from RHReportesNomina c
												inner join RHColumnasReporte b
															inner join RHConceptosColumna a
															on a.RHCRPTid = b.RHCRPTid
													 on b.RHRPTNid = c.RHRPTNid
													and rtrim(ucase(b.RHCRPTcodigo)) = ucase('VariosDesc')
											where rtrim(ucase(c.RHRPTNcodigo)) = ucase('RFPP')
											  and c.Ecodigo = #session.Ecodigo#)),0.00))
						- ( coalesce((select sum(a.ICmontores) 
										from #tablaIncidenciasCalculo# a
										where a.DEid = #salida#.DEid
										and a.RCNid = #salida#.RCNid 
										and CIid in (select distinct a.CIid
													from RHReportesNomina c
														inner join RHColumnasReporte b
																	inner join RHConceptosColumna a
																	on a.RHCRPTid = b.RHCRPTid
															 on b.RHRPTNid = c.RHRPTNid
															and rtrim(ucase(b.RHCRPTcodigo)) = ucase('VariosDesc')
													where rtrim(ucase(c.RHRPTNcodigo)) = ucase('RFPP')
													  and c.Ecodigo = #session.Ecodigo#)), 0.00))			  
								  
					
    </cfquery>
	
	<!--- MONTO TOTALES --->
    <cfquery name="rsSalarioLiq" datasource="#session.DSN#">
    	update #salida#
        set TotalDesc = (IGSS + ISR + BanTrab + Anticipo + VariosDesc),
			TotalIngresos = (Ordinario + Bono + Bonificacion + Comision + VariosIngresos )
    </cfquery>

	<!--- MONTO LIQUIDO --->
    <cfquery name="rsSalarioLiq" datasource="#session.DSN#">
    	update #salida#
        set Liquido = TotalIngresos - TotalDesc
    </cfquery>

    <cfquery name="rsReporte" datasource="#session.DSN#">
    	select s.*, cf.CFcodigo, CFdescripcion
        from #salida# s
		inner join CFuncional cf
			on cf.CFid = s.CFid
        order by <cfif isdefined('url.Agrupar') and LEN(TRIM(url.Agrupar))>CFcodigo,</cfif>DEidentificacion
    </cfquery>
    <!--- FIN DE RECOLECCION DE DATOS DEL REPORTE --->
    <!--- Busca el nombre de la Empresa --->
    <cfquery name="rsEmpresa" datasource="#session.DSN#">
        select Edescripcion,a.Mcodigo,b.Mnombre
		from Empresas a
		inner join Monedas b
			  on b.Ecodigo = a.Ecodigo
			  and b.Mcodigo = a.Mcodigo 
		where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
    </cfquery>
    <style>
	h1.corte {
		PAGE-BREAK-AFTER: always;}
	.tituloAlterno {
		font-size:20px;
		font-weight:bold;
		text-align:center;}
	.titulo_empresa2 {
		font-size:16px;
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
	<cfsilent>
		<cfset Lvar_TotalOrd 		  	  	= 0>
			<cfset Lvar_TotalBonificacion 	= 0>
			<cfset Lvar_TotalBonificacion37 = 0>
			<cfset Lvar_TotalComision 		= 0>
			<cfset Lvar_TotalVariosI		= 0>
			<cfset Lvar_TotalIngresos 		= 0>
			<cfset Lvar_TotalIGSS 	  		= 0>
			<cfset Lvar_TotalISR 	 		= 0>
			<cfset Lvar_TotalBanT     		= 0>
			<cfset Lvar_TotalAnticipos		= 0>
			<cfset Lvar_TotalVariosDesc 	= 0>
			<cfset Lvar_TotalDesc 			= 0>
			<cfset Lvar_TotalLiquido 		= 0>
	</cfsilent>
	
    <table width="100%" border="0" cellpadding="2" cellspacing="0" align="center" style="border-color:CCCCCC">
		<cfoutput>
		<tr>
			<td width="90%"class="titulo_empresa2" colspan="15"><strong>#rsNomina.Descripcion#</strong></td>
			<td>&nbsp;</td>
		</tr>
		<tr>
			<td width="90%" class="titulo_empresa2" colspan="15"><strong>#rsEmpresa.Edescripcion#</strong></td>
			<td>&nbsp;</td>
		</tr>
		<tr>
			<td width="90%" class="titulo_empresa2" colspan="15"><strong>#rsEmpresa.MNombre#</strong></td>
			<td class="titulo_empresa2" nowrap><strong>#LSTimeFormat(Now(),'hh:mm tt')#</strong></td>
		</tr>
        <tr>
			<td width="90%" class="titulo_empresa2" colspan="15"><strong>#LB_FechaRige#: #LSDateFormat(rsNomina.RCdesde,'dd/mm/yyyy')# &nbsp; #LB_FechaVence#: #LSDateFormat(rsNomina.RChasta,'dd/mm/yyyy')#	</strong></td>
			<td class="titulo_empresa2"><strong>#session.Usulogin#</strong></td>
		</tr>
        <tr><td>&nbsp;</td></tr>
		
        </cfoutput>
        <tr><td height="1" bgcolor="000000" colspan="26"></td>
		<cfif not isdefined('url.Agrupar')>
		
 		<tr class="listaCorte3" valign="bottom">
			<td nowrap ><cf_translate key="LB_Codigo">C&oacute;digo</cf_translate></td>
			<td nowrap>&nbsp;<cf_translate key="LB_Nombre">Nombre</cf_translate></td>
			<td nowrap>&nbsp;<cf_translate key="LB_Dias">D&iacute;as</cf_translate></td>
			<td nowrap>&nbsp;<cf_translate key="LB_Ordinario">Ordinario</cf_translate></td>
			<td nowrap>&nbsp;<cf_translate key="LB_Bonificacion">Bonificaci&oacute;n</cf_translate></td>
			<td nowrap align="center">&nbsp;<cf_translate key="LB_Bonificacion37">Bonificaci&oacute;n <br />37-2001</cf_translate></td>
			<td nowrap>&nbsp;<cf_translate key="LB_Comision">Comisi&oacute;n</cf_translate></td>
			<td nowrap align="center">&nbsp;<cf_translate key="LB_VariosIngresos">Varios<br>Ingresos</cf_translate></td>
			<td nowrap align="center">&nbsp;<cf_translate key="LB_TotalIngreso">Total<br>Ingresos</cf_translate></td>
			<td nowrap>&nbsp;<cf_translate key="LB_IGSS">IGSS</cf_translate></td>
			<td nowrap>&nbsp;<cf_translate key="LB_ISR">ISR</cf_translate></td>
			<td nowrap>&nbsp;<cf_translate key="LB_BanTrab">BanTrab</cf_translate></td>
			<td nowrap>&nbsp;<cf_translate key="LB_Anticipos">Anticipos</cf_translate></td>
			<td nowrap align="center">&nbsp;<cf_translate key="LB_VariosDescuentos">Varios<br>Descuentos</cf_translate></td>
			<td nowrap align="center">&nbsp;<cf_translate key="LB_TotalDescuentos">Total<br>Descuentos</cf_translate></td>
			<td nowrap>&nbsp;<cf_translate key="LB_Liquido">L&iacute;quido</cf_translate></td>
		</tr>
		<tr><td height="1" bgcolor="000000" colspan="26"></td>
		</cfif>
        <cfoutput query="rsReporte" group="CFid">
			<cfif isdefined('url.Agrupar')>
				 <tr>
                    <td class="detalle" nowrap>&nbsp;</td>
                    <td class="detalle" nowrap>&nbsp;</td>
                    <td class="detallec" nowrap>&nbsp;</td>
                    <td class="detaller" nowrap>#LSCurrencyFormat(Lvar_TotalOrd,'none')#</td>
                    <td class="detaller" nowrap>#LSCurrencyFormat(Lvar_TotalBonificacion,'none')#</td>
                    <td class="detaller" nowrap>#LSCurrencyFormat(Lvar_TotalBonificacion37,'none')#</td>
					<td class="detaller" nowrap>#LSCurrencyFormat(Lvar_TotalComision,'none')#</td>
                    <td class="detaller" nowrap>#LSCurrencyFormat(Lvar_TotalVariosI,'none')#</td>
                    <td class="detaller" nowrap>#LSCurrencyFormat(Lvar_TotalIngresos,'none')#</td>
                    <td class="detaller" nowrap>#LSCurrencyFormat(Lvar_TotalIGSS,'none')#</td>
                    <td class="detaller" nowrap>#LSCurrencyFormat(Lvar_TotalISR,'none')#</td>
                    <td class="detaller" nowrap>#LSCurrencyFormat(Lvar_TotalBanT,'none')#</td>
                    <td class="detaller" nowrap>#LSCurrencyFormat(Lvar_TotalAnticipos,'none')#</td>
                    <td class="detaller" nowrap>#LSCurrencyFormat(Lvar_TotalVariosDesc,'none')#</td>
                    <td class="detaller" nowrap>#LSCurrencyFormat(Lvar_TotalDesc,'none')#</td>
                    <td class="detaller" nowrap>#LSCurrencyFormat(Lvar_TotalLiquido,'none')#</td>
                </tr>
				<cfsilent>
					<cfset Lvar_TotalOrd 		  	  	= 0>
						<cfset Lvar_TotalBonificacion 	= 0>
						<cfset Lvar_TotalBonificacion37 = 0>
						<cfset Lvar_TotalComision 		= 0>
						<cfset Lvar_TotalVariosI		= 0>
						<cfset Lvar_TotalIngresos 		= 0>
						<cfset Lvar_TotalIGSS 	  		= 0>
						<cfset Lvar_TotalISR 	 		= 0>
						<cfset Lvar_TotalBanT     		= 0>
						<cfset Lvar_TotalAnticipos		= 0>
						<cfset Lvar_TotalVariosDesc 	= 0>
						<cfset Lvar_TotalDesc 			= 0>
						<cfset Lvar_TotalLiquido 		= 0>
				</cfsilent>
			
			<tr class="listaCorte1"><td colspan="26">#CFcodigo#&nbsp;-&nbsp;#CFdescripcion#</td></tr>
            <tr><td height="1" bgcolor="000000" colspan="26"></td>
			<tr class="listaCorte3" valign="bottom">
				<td nowrap ><cf_translate key="LB_Codigo">C&oacute;digo</cf_translate></td>
				<td nowrap>&nbsp;<cf_translate key="LB_Nombre">Nombre</cf_translate></td>
				<td nowrap>&nbsp;<cf_translate key="LB_Dias">D&iacute;as</cf_translate></td>
				<td nowrap>&nbsp;<cf_translate key="LB_Ordinario">Ordinario</cf_translate></td>
				<td nowrap>&nbsp;<cf_translate key="LB_Bonificacion">Bonificaci&oacute;n</cf_translate></td>
				<td nowrap>&nbsp;<cf_translate key="LB_Bonificacion37">Bonificaci&oacute;n <br />37-2001</cf_translate></td>
				<td nowrap>&nbsp;<cf_translate key="LB_Comision">Comisi&oacute;n</cf_translate></td>
				<td nowrap>&nbsp;<cf_translate key="LB_VariosIngresos">Varios Ingresos</cf_translate></td>
				<td nowrap align="center">&nbsp;<cf_translate key="LB_TotalIngreso">Total<br>Ingresos</cf_translate></td>
				<td nowrap>&nbsp;<cf_translate key="LB_IGSS">IGSS</cf_translate></td>
				<td nowrap>&nbsp;<cf_translate key="LB_ISR">ISR</cf_translate></td>
				<td nowrap>&nbsp;<cf_translate key="LB_BanTrab">BanTrab</cf_translate></td>
				<td nowrap>&nbsp;<cf_translate key="LB_Anticipos">Anticipos</cf_translate></td>
				<td nowrap align="center">&nbsp;<cf_translate key="LB_VariosDescuentos">Varios<br>Descuentos</cf_translate></td>
				<td nowrap align="center">&nbsp;<cf_translate key="LB_TotalDescuentos">Total<br>Descuentos</cf_translate></td>
				<td nowrap>&nbsp;<cf_translate key="LB_Liquido">L&iacute;quido</cf_translate></td>
			</tr>
            <tr><td height="1" bgcolor="000000" colspan="26"></td>
			</cfif>
            <cfoutput>
				 <tr>
                    <td class="detalle" nowrap>#DEidentificacion#</td>
                    <td class="detalle" nowrap>#Nombre#</td>
                    <td class="detallec" nowrap>#LSNumberFormat(Dias,'999')#</td>
                    <td class="detaller" nowrap>#LSCurrencyFormat(Ordinario,'none')#</td>
                    <td class="detaller" nowrap>#LSCurrencyFormat(Bono,'none')#</td>
                    <td class="detaller" nowrap>#LSCurrencyFormat(Bonificacion,'none')#</td>
					<td class="detaller" nowrap>#LSCurrencyFormat(Comision,'none')#</td>
                    <td class="detaller" nowrap>#LSCurrencyFormat(VariosIngresos,'none')#</td>
                    <td class="detaller" nowrap>#LSCurrencyFormat(TotalIngresos,'none')#</td>
                    <td class="detaller" nowrap>#LSCurrencyFormat(IGSS,'none')#</td>
                    <td class="detaller" nowrap>#LSCurrencyFormat(ISR,'none')#</td>
                    <td class="detaller" nowrap>#LSCurrencyFormat(BanTrab,'none')#</td>
                    <td class="detaller" nowrap>#LSCurrencyFormat(Anticipo,'none')#</td>
                    <td class="detaller" nowrap>#LSCurrencyFormat(VariosDesc,'none')#</td>
                    <td class="detaller" nowrap>#LSCurrencyFormat(TotalDesc,'none')#</td>
                    <td class="detaller" nowrap>#LSCurrencyFormat(Liquido,'none')#</td>
                </tr>
				<cfsilent>
					<cfset Lvar_TotalOrd 	= Lvar_TotalOrd + Ordinario>
					<cfset Lvar_TotalBonificacion = Lvar_TotalBonificacion + Bono>
					<cfset Lvar_TotalBonificacion37 = Lvar_TotalBonificacion37 + Bonificacion>
					<cfset Lvar_TotalComision = Lvar_TotalComision + Comision>
					<cfset Lvar_TotalVariosI 	= Lvar_TotalVariosI + VariosIngresos>
					<cfset Lvar_TotalIngresos 	= Lvar_TotalIngresos + TotalIngresos>
					<cfset Lvar_TotalIGSS 	= Lvar_TotalIGSS + IGSS>
					<cfset Lvar_TotalISR 	= Lvar_TotalISR + ISR>
					<cfset Lvar_TotalBanT 	= Lvar_TotalBanT + BanTrab>
					<cfset Lvar_TotalAnticipos = Lvar_TotalAnticipos + Anticipo>
					<cfset Lvar_TotalVariosDesc = Lvar_TotalVariosDesc + VariosDesc>
					<cfset Lvar_TotalDesc 	= Lvar_TotalDesc + TotalDesc>
					<cfset Lvar_TotalLiquido = Lvar_TotalLiquido + Liquido>
				</cfsilent>
			</cfoutput>
			<cfif isdefined('url.Agrupar')>
            <tr><td height="1" bgcolor="000000" colspan="26"></td>
			</cfif>
		</cfoutput><!--- CORTE POR CENTRO FUNCIONAL --->
			<cfoutput>
			<tr>
				<td class="detalle" nowrap>&nbsp;</td>
				<td class="detalle" nowrap>&nbsp;</td>
				<td class="detallec" nowrap>&nbsp;</td>
				<td class="detaller" nowrap>#LSCurrencyFormat(Lvar_TotalOrd,'none')#</td>
				<td class="detaller" nowrap>#LSCurrencyFormat(Lvar_TotalBonificacion,'none')#</td>
				<td class="detaller" nowrap>#LSCurrencyFormat(Lvar_TotalBonificacion37,'none')#</td>
				<td class="detaller" nowrap>#LSCurrencyFormat(Lvar_TotalComision,'none')#</td>
				<td class="detaller" nowrap>#LSCurrencyFormat(Lvar_TotalVariosI,'none')#</td>
				<td class="detaller" nowrap>#LSCurrencyFormat(Lvar_TotalIngresos,'none')#</td>
				<td class="detaller" nowrap>#LSCurrencyFormat(Lvar_TotalIGSS,'none')#</td>
				<td class="detaller" nowrap>#LSCurrencyFormat(Lvar_TotalISR,'none')#</td>
				<td class="detaller" nowrap>#LSCurrencyFormat(Lvar_TotalBanT,'none')#</td>
				<td class="detaller" nowrap>#LSCurrencyFormat(Lvar_TotalAnticipos,'none')#</td>
				<td class="detaller" nowrap>#LSCurrencyFormat(Lvar_TotalVariosDesc,'none')#</td>
				<td class="detaller" nowrap>#LSCurrencyFormat(Lvar_TotalDesc,'none')#</td>
				<td class="detaller" nowrap>#LSCurrencyFormat(Lvar_TotalLiquido,'none')#</td>
			</tr>
			</cfoutput>
    </table>
<cfif session.Usulogin eq 'soin'>
	<BR><BR>
	<table width="100%" border="0" cellpadding="2" cellspacing="0" align="center">
    	
				<td class="detallec" nowrap>&nbsp;</td>
    			<td class="detalle" nowrap>ELABORADO POR</td>
    			<td class="detallec" nowrap>&nbsp;</td>
    			<td class="detallec" nowrap>_____________________________________</td>
				<td class="detalle" nowrap>REVISADO POR</td>
				<td class="detallec" nowrap>&nbsp;</td>
    			<td class="detallec" nowrap>_____________________________________</td>				
				<td class="detalle" nowrap>AUTORIZADO POR</td>
				<td class="detallec" nowrap>&nbsp;</td>
    			<td class="detallec" nowrap>_____________________________________</td>	
				<td class="detallec" nowrap>&nbsp;</td>
    	</tr>
    </table>    
</cfif>
<cfelse>
	<table width="100%" border="0" cellpadding="2" cellspacing="0" align="center">
    	<tr class="titulo_empresa2"><td align="center">No se han definido las columnas del reporte.</td></tr>
    </table>
</cfif>