<cfsetting requesttimeout="36000">
<cfquery name="rsVerificaReporte" datasource="#session.DSN#">
	select 1
    from RHReportesNomina
    where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
      and RHRPTNcodigo = 'LS'
</cfquery>
<cfif isdefined('rsVerificaReporte') and rsVerificaReporte.RecordCount>
<!--- VARIABLES DE TRADUCCION --->
<cfinvoke key="LB_LibroDeSalarios" default="Libro de Salarios" returnvariable="LB_LibroDeSalarios" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_NoHayDatosRelacionados" default="No hay datos relacionados" returnvariable="LB_NoHayDatosRelacionados" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_Fecha" default="Fecha" returnvariable="LB_Fecha" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_FechaRige" default="Fecha Rige" returnvariable="LB_FechaRige"  component="sif.Componentes.Translate" method="Translate" />
<cfinvoke key="LB_FechaVence" default="Fecha Vence" returnvariable="LB_FechaVence" component="sif.Componentes.Translate" method="Translate"/>
<!--- FIN VARIABLES DE TRADUCCION --->
	<!--- Tabla temporal de resultados --->
	<cf_dbtemp name="salidaLibros" returnvariable="salida">
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
		<cf_dbtempcol name="Dias"	  		type="int"      mandatory="no">
		<cf_dbtempcol name="HorasExtra" 	type="float"   	mandatory="no">
		<cf_dbtempcol name="Sueldo" 		type="money"    mandatory="no">
		<cf_dbtempcol name="Ordinario" 		type="money"    mandatory="no">
		<cf_dbtempcol name="Bonifica" 		type="money"  	mandatory="no">
		<cf_dbtempcol name="ExtrasS" 		type="money"    mandatory="no">
		<cf_dbtempcol name="ExtrasD" 		type="money"    mandatory="no">
		<cf_dbtempcol name="Aguinaldo" 		type="money"    mandatory="no">
		<cf_dbtempcol name="Vacaciones"		type="money"   	mandatory="no">
		<cf_dbtempcol name="Indemniza" 		type="money"    mandatory="no">
		<cf_dbtempcol name="Otros" 			type="money"    mandatory="no">
		<cf_dbtempcol name="Comisiones" 	type="money"    mandatory="no">
		<cf_dbtempcol name="Septimo" 		type="money"    mandatory="no">
		<cf_dbtempcol name="IGSS" 			type="money"    mandatory="no">
		<cf_dbtempcol name="Asoc" 			type="money"    mandatory="no">
		<cf_dbtempcol name="ISR" 			type="money"    mandatory="no">
		<cf_dbtempcol name="BanTrab" 		type="money" 	mandatory="no">
		<cf_dbtempcol name="OtrosDesc" 		type="money" 	mandatory="no">
		<cf_dbtempcol name="MontoLiquido" 	type="money"    mandatory="no">
		<cf_dbtempcol name="MontoBruto" 	type="money"   	mandatory="no">
		<cf_dbtempkey cols="DEid,RCNid">
	</cf_dbtemp> 
	<cfset Lvar_MesD = DatePart('m',url.Fdesde)>
	<cfset Lvar_PeriodoD = DatePart('yyyy',url.Fdesde)>
	<cfset Lvar_MesH = DatePart('m',url.Fhasta)>
	<cfset Lvar_PeriodoH = DatePart('yyyy',url.Fhasta)>
	
    <!--- INGRESA LOS DATOS DE LOS CALENDARIOS DE PAGO DEL EMPLEADO --->
	<cfquery name="rsCalendarios" datasource="#session.dsn#">	
 	 	insert into #salida#(RCNid, DEid, RCdesde, RChasta, Tcodigo, FechaPago,CPcodigo,CPtipo,CPperiodo,CPmes)
            select distinct CPid, hse.DEid, CPdesde, CPhasta, cp.Tcodigo, CPfpago,CPcodigo,CPtipo,CPperiodo,CPmes
            from HSalarioEmpleado hse
            inner join CalendarioPagos cp
                on hse.RCNid = cp.CPid
			inner join DatosEmpleado de
				on de.DEid = hse.DEid
				and de.Ecodigo = cp.Ecodigo
			inner join HRCalculoNomina cn
				on cn.RCNid = cp.CPid
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
	
	<!--- TABLA TEMPORAL PARA DATOS DE NOMINAS DE ANTICIPO --->
	<cf_dbtemp name="AnticiposTMP" returnvariable="Anticipos">
		<cf_dbtempcol name="DEid"   	type="int"      mandatory="yes">
		<cf_dbtempcol name="CPmes"   	type="int"      mandatory="yes">
		<cf_dbtempcol name="CPperiodo"	type="int"      mandatory="yes">
		<cf_dbtempcol name="monto"   	type="money"      mandatory="yes">
	</cf_dbtemp> 
	
	<cfquery name="rsAnticipos" datasource="#session.DSN#">
		insert into #Anticipos#(DEid,CPmes,CPperiodo,monto)
		select DEid, CPmes,CPperiodo, SEliquido
		from CalendarioPagos a
		inner join HSalarioEmpleado b
			  on b.RCNid = a.CPid
			  and b.DEid in (select distinct DEid
			  				from #salida#)
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		  and CPtipo = 2
		  and (CPdesde between <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(url.Fdesde)#">
        					and <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(url.Fhasta)#">
			        	or CPhasta between <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(url.Fdesde)#">
        					and <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(url.Fhasta)#">)
			and (CPperiodo between <cfqueryparam cfsqltype="cf_sql_integer" value="#Lvar_PeriodoD#">
						   and <cfqueryparam cfsqltype="cf_sql_integer" value="#Lvar_PeriodoH#">)
			and (CPmes between <cfqueryparam cfsqltype="cf_sql_integer" value="#Lvar_mesD#">
						   and <cfqueryparam cfsqltype="cf_sql_integer" value="#Lvar_mesH#">)
	</cfquery>

	
	<!--- ACTUALIZA LOS DIAS PAGADOS EN EL CALENDARIO DE PAGO --->
	<cfquery name="rsDias" datasource="#session.DSN#">
    	update #salida#
        set Dias = coalesce((select sum(PEcantdias)
        			from HPagosEmpleado a
                   	where a.RCNid = #salida#.RCNid
                      and a.DEid = #salida#.DEid
                    group by a.RCNid),0)
    </cfquery>
    <!--- CALCULO DE LAS HORAS EXTRA (TOTAL HORAS EXTRA A Y HORAS EXTRA B) --->
    <!--- HORAS EXTRA A --->
    <cfquery name="rsHorasExtra" datasource="#session.DSN#">
    	update #salida#
        set HorasExtra = coalesce((
								select sum(a.ICvalor) 
								from HIncidenciasCalculo a
								where a.DEid = #salida#.DEid
								and a.RCNid = #salida#.RCNid 
								and CIid in (select distinct a.CIid
											from RHReportesNomina c
												inner join RHColumnasReporte b
															inner join RHConceptosColumna a
															on a.RHCRPTid = b.RHCRPTid
													 on b.RHRPTNid = c.RHRPTNid
													and b.RHCRPTcodigo = 'HorasExtra'
											where c.RHRPTNcodigo = 'LS'
											  and c.Ecodigo = #session.Ecodigo#)), 0.00)
    </cfquery>
    <!--- SUELDO --->
    <cfquery name="rsSueldo" datasource="#session.DSN#">
    	update #salida#
        set Sueldo = coalesce((select sum(PEsalario)
                                from HPagosEmpleado
                                where DEid = #salida#.DEid
                                  and RCNid = #salida#.RCNid
								  and PEtiporeg = 0
								  and PElinea = (select max(PElinea)
                                from HPagosEmpleado
                                where DEid = #salida#.DEid
                                  and RCNid = #salida#.RCNid
								  and PEtiporeg = 0
								  )),0.00)
    </cfquery>
    <!--- SALARIO ORDINARIO --->
    <!--- SALARIO BRUTO --->
     <cfquery name="rsSalarioOrd" datasource="#session.DSN#">
    	update #salida#
        set Ordinario = coalesce((select SEsalariobruto
        							 from HSalarioEmpleado hse
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
								from HIncidenciasCalculo a
								where a.DEid = #salida#.DEid
								and a.RCNid = #salida#.RCNid 
								and CIid in (select distinct a.CIid
											from RHReportesNomina c
												inner join RHColumnasReporte b
															inner join RHConceptosColumna a
															on a.RHCRPTid = b.RHCRPTid
													 on b.RHRPTNid = c.RHRPTNid
													and b.RHCRPTcodigo = 'Ordinario'
											where c.RHRPTNcodigo = 'LS'
											  and c.Ecodigo = #session.Ecodigo#)), 0.00)
								- ( coalesce((	select sum(a.DCvalor) 
												from HDeduccionesCalculo a, DeduccionesEmpleado b,TDeduccion z
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
																and b.RHCRPTcodigo = 'Ordinario'
														where c.RHRPTNcodigo = 'LS'
														  and c.Ecodigo = #session.Ecodigo#)),0.00)
									+ coalesce((
											select sum(a.CCvaloremp) 	
											from HCargasCalculo a, DCargas b, ECargas c
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
																and b.RHCRPTcodigo = 'Ordinario'
														where c.RHRPTNcodigo = 'LS'
														  and c.Ecodigo = #session.Ecodigo#)),0.00)
								
								
								)
    </cfquery> 
	<!--- MONTOS ADICIONALES QUE SE TIENEN QUE INCLUIR, COMO DEDUCCIONES SOBRE SALARIOS NO DEVENGADOS --->
	<cfquery name="rsHorasExtra" datasource="#session.DSN#">
    	update #salida#
        set Ordinario = Ordinario + ( coalesce((	select sum(a.DCvalor) 
												from HDeduccionesCalculo a, DeduccionesEmpleado b,TDeduccion z
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
																and b.RHCRPTcodigo = 'OrdAdicional'
														where c.RHRPTNcodigo = 'LS'
														  and c.Ecodigo = #session.Ecodigo#)),0.00))
	</cfquery>
    <!--- BONIFICACION LEY Q250 --->
	<cfquery name="rsHorasExtra" datasource="#session.DSN#">
    	update #salida#
        set Bonifica = coalesce((
								select sum(a.ICmontores) 
								from HIncidenciasCalculo a
								where a.DEid = #salida#.DEid
								and a.RCNid = #salida#.RCNid 
								and CIid in (select distinct a.CIid
											from RHReportesNomina c
												inner join RHColumnasReporte b
															inner join RHConceptosColumna a
															on a.RHCRPTid = b.RHCRPTid
													 on b.RHRPTNid = c.RHRPTNid
													and b.RHCRPTcodigo = 'Bonifica'
											where c.RHRPTNcodigo = 'LS'
											  and c.Ecodigo = #session.Ecodigo#)), 0.00)
						- ( coalesce((	select sum(a.DCvalor) 
												from HDeduccionesCalculo a, DeduccionesEmpleado b,TDeduccion z
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
																and b.RHCRPTcodigo = 'Bonifica'
														where c.RHRPTNcodigo = 'LS'
														  and c.Ecodigo = #session.Ecodigo#)),0.00)
									+ coalesce((
											select sum(a.CCvaloremp) 	
											from HCargasCalculo a, DCargas b, ECargas c
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
																and b.RHCRPTcodigo = 'Bonifica'
														where c.RHRPTNcodigo = 'LS'
														  and c.Ecodigo = #session.Ecodigo#)),0.00)
								
								
								)
    </cfquery>
    <!--- Obtiene la finformación del Feriado --->
	<cfquery name="rsFeriados" datasource="#session.DSN#">
		select a.RHFfecha
		from RHFeriados a
		where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			and RHFfecha between <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(url.Fdesde)#">
        					and <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(url.Fhasta)#">
			and a.RHFpagooblig = 1
	</cfquery>
    <!--- CALCULO DE LAS HORAS EXTRA (TOTAL HORAS EXTRA A Y HORAS EXTRA B) --->
    <!--- HORAS EXTRA A --->
	<!--- SUMA DE TODOS LOS MONTOS PAGADOS POR INCIDENCIAS INDICADAS PARA LA COLUMNA EXTRASS
			EN LA CONFIGURACION DEL REPORTE QUE -- NO -- SEAN FERIADOS NI DIAS LIBRES  --->
    <cfquery name="rsMontoExtraA" datasource="#session.DSN#">
    	update #salida#
        set ExtrasS =  coalesce((
								select sum(a.ICmontores) 
								from HIncidenciasCalculo a
								where a.DEid = #salida#.DEid
								and a.RCNid = #salida#.RCNid 
								and not exists (select 1 
												from RHFeriados f	
												where f.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
													and f.RHFfecha = a.ICfecha
													and f.RHFfecha between <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(url.Fdesde)#">
																	and <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(url.Fhasta)#">
													and f.RHFpagooblig = 1)
								<cfif Application.dsinfo[session.DSN].type is 'oracle'>
								and not exists(select  1  <!--- VERIFICA QUE LOS DIAS NO SEAN DOMINGOS EN CASO Q TENGA PLANIFICADOR --->
												from LineaTiempo c,RHPlanificador d, RHJornadas e,RHDJornadas f
												where c.DEid =  #salida#.DEid
												  and a.ICfecha between c.LTdesde and c.LThasta
												  and d.DEid = c.DEid
												  and a.ICfecha = d.RHPJfinicio(+)
												  and e.RHJid = coalesce(d.RHJid,c.RHJid)
												  and f.RHJid = e.RHJid
												  and f.RHDJdia = to_char(a.ICfecha,'d')
												  and f.RHDJdia = 1
								)
								and not exists(select 1 <!--- VERIFICA QUE LOS DIAS NO SEAN DOMINGOS --->
												from LineaTiempo c, RHJornadas e,RHDJornadas f
												where c.DEid =  #salida#.DEid
												  and a.ICfecha between c.LTdesde and c.LThasta
												  and e.RHJid = c.RHJid
												  and f.RHJid = e.RHJid
												  and f.RHDJdia = to_char(a.ICfecha,'d')
												  and f.RHDJdia = 1									
								)
								<cfelse>
								and not exists(select  1
												from LineaTiempo c
												left outer join RHPlanificador d
												  on d.DEid = c.DEid
												  and d.RHPJfinicio = a.ICfecha
												inner join RHJornadas e
												  on e.RHJid = coalesce(d.RHJid,c.RHJid)
												inner join RHDJornadas f
												  on f.RHJid = e.RHJid
												  and f.RHDJdia = datepart(dd,a.ICfecha)
												where c.DEid = #salida#.DEid
												  and a.ICfecha between c.LTdesde and c.LThasta
												  and f.RHDJdia = 1	
								)
								and not exists(select  1
												from LineaTiempo c
												inner join RHJornadas e
												  on e.RHJid = c.RHJid
												inner join RHDJornadas f
												  on f.RHJid = e.RHJid
												  and f.RHDJdia = datepart(dd,a.ICfecha)
												where c.DEid = #salida#.DEid
												  and a.ICfecha between c.LTdesde and c.LThasta
												  and f.RHDJdia = 1	
								)
								</cfif>
								and CIid in (select distinct a.CIid
											from RHReportesNomina c
												inner join RHColumnasReporte b
															inner join RHConceptosColumna a
															on a.RHCRPTid = b.RHCRPTid
													 on b.RHRPTNid = c.RHRPTNid
													and b.RHCRPTcodigo = 'HorasExtraA'
											where c.RHRPTNcodigo = 'LS'
											  and c.Ecodigo = #session.Ecodigo#)), 0.00)
								- ( coalesce((	select sum(a.DCvalor) 
												from HDeduccionesCalculo a, DeduccionesEmpleado b,TDeduccion z
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
																and b.RHCRPTcodigo = 'HorasExtraA'
														where c.RHRPTNcodigo = 'LS'
														  and c.Ecodigo = #session.Ecodigo#)),0.00)
									+ coalesce((
											select sum(a.CCvaloremp) 	
											from HCargasCalculo a, DCargas b, ECargas c
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
																and b.RHCRPTcodigo = 'HorasExtraA'
														where c.RHRPTNcodigo = 'LS'
														  and c.Ecodigo = #session.Ecodigo#)),0.00)
								
								
								)
    </cfquery>
    <!--- HORAS EXTRA B --->
	<!--- SUMA DE TODOS LOS MONTOS PAGADOS POR INCIDENCIAS INDICADAS PARA LA COLUMNA EXTRASS
			EN LA CONFIGURACION DEL REPORTE QUE SEAN FERIADOS O DIAS LIBRES  --->
	<!--- VERIFICA SI ES UN FERIADO --->
    <cfquery name="rsMontoExtraB" datasource="#session.DSN#">
    	update #salida#
        set ExtrasD = coalesce((
								select sum(a.ICmontores) 
								from HIncidenciasCalculo a
								where a.DEid = #salida#.DEid
								and a.RCNid = #salida#.RCNid 
								and exists (select 1 
												from RHFeriados f	
												where f.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
													and f.RHFfecha = a.ICfecha
													and f.RHFfecha between <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(url.Fdesde)#">
																	and <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(url.Fhasta)#">
													and f.RHFpagooblig = 1)
								and CIid in (select distinct a.CIid
											from RHReportesNomina c
												inner join RHColumnasReporte b
															inner join RHConceptosColumna a
															on a.RHCRPTid = b.RHCRPTid
													 on b.RHRPTNid = c.RHRPTNid
													and b.RHCRPTcodigo = 'HorasExtraA'
											where c.RHRPTNcodigo = 'LS'
											  and c.Ecodigo = #session.Ecodigo#)), 0.00)
    </cfquery>
	<!--- VERIFICA SI ES UN DIA LIBRE --->
	 <cfquery name="rsMontoExtraB" datasource="#session.DSN#">
    	update #salida#
        set ExtrasD = ExtrasD + coalesce((
								select sum(a.ICmontores) 
								from HIncidenciasCalculo a
								where a.DEid = #salida#.DEid
								and a.RCNid = #salida#.RCNid 
								<cfif Application.dsinfo[session.DSN].type is 'oracle'>
								and (exists(
											select  1
												from LineaTiempo c,RHPlanificador d, RHJornadas e,RHDJornadas f
												where c.DEid = #salida#.DEid
												  and a.ICfecha between c.LTdesde and c.LThasta
												  and d.DEid = c.DEid
												  and a.ICfecha = d.RHPJfinicio(+)
												  and e.RHJid = coalesce(d.RHJid,c.RHJid)
												  and f.RHJid = e.RHJid
												  and f.RHDJdia = to_char(a.ICfecha,'d')
												  and f.RHDJdia = 1	
								) or exists(select  1
												from LineaTiempo c, RHJornadas e,RHDJornadas f
												where c.DEid = #salida#.DEid
												  and a.ICfecha between c.LTdesde and c.LThasta
												  and e.RHJid = c.RHJid
												  and f.RHJid = e.RHJid
												  and f.RHDJdia = to_char(a.ICfecha,'d')
												  and f.RHDJdia = 1	
											))
								<cfelse>
								and (exists(select  1
												from LineaTiempo c
												left outer join RHPlanificador d
												  on d.DEid = c.DEid
												  and d.RHPJfinicio = a.ICfecha
												inner join RHJornadas e
												  on e.RHJid = coalesce(d.RHJid,c.RHJid)
												inner join RHDJornadas f
												  on f.RHJid = e.RHJid
												  and f.RHDJdia = datepart(dd,a.ICfecha)
												where c.DEid = #salida#.DEid
												  and a.ICfecha between c.LTdesde and c.LThasta
												  and f.RHDJdia = 1	
								) or exists(select  1
												from LineaTiempo c
												inner join RHJornadas e
												  on e.RHJid = c.RHJid
												inner join RHDJornadas f
												  on f.RHJid = e.RHJid
												  and f.RHDJdia = datepart(dd,a.ICfecha)
												where c.DEid = #salida#.DEid
												  and a.ICfecha between c.LTdesde and c.LThasta
												  and f.RHDJdia = 1	
								) 
								
								)
								</cfif>
								and CIid in (select distinct a.CIid
											from RHReportesNomina c
												inner join RHColumnasReporte b
															inner join RHConceptosColumna a
															on a.RHCRPTid = b.RHCRPTid
													 on b.RHRPTNid = c.RHRPTNid
													and b.RHCRPTcodigo = 'HorasExtraA'
											where c.RHRPTNcodigo = 'LS'
											  and c.Ecodigo = #session.Ecodigo#)), 0.00)
    </cfquery>
   <!--- ExtrasD --->
	<cfquery name="rsHorasExtra" datasource="#session.DSN#">
    	update #salida#
        set ExtrasD = ExtrasD + coalesce((
								select sum(a.ICmontores) 
								from HIncidenciasCalculo a
								where a.DEid = #salida#.DEid
								and a.RCNid = #salida#.RCNid 
								and CIid in (select distinct a.CIid
											from RHReportesNomina c
												inner join RHColumnasReporte b
															inner join RHConceptosColumna a
															on a.RHCRPTid = b.RHCRPTid
													 on b.RHRPTNid = c.RHRPTNid
													and b.RHCRPTcodigo = 'HorasExtraB'
											where c.RHRPTNcodigo = 'LS'
											  and c.Ecodigo = #session.Ecodigo#)), 0.00)
						- ( coalesce((	select sum(a.DCvalor) 
												from HDeduccionesCalculo a, DeduccionesEmpleado b,TDeduccion z
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
																and b.RHCRPTcodigo = 'HorasExtraB'
														where c.RHRPTNcodigo = 'LS'
														  and c.Ecodigo = #session.Ecodigo#)),0.00)
									+ coalesce((
											select sum(a.CCvaloremp) 	
											from HCargasCalculo a, DCargas b, ECargas c
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
																and b.RHCRPTcodigo = 'HorasExtraB'
														where c.RHRPTNcodigo = 'LS'
														  and c.Ecodigo = #session.Ecodigo#)),0.00)
								
								
								)
    </cfquery>
	
    <!--- AGUINALDO --->
    <cfquery name="rsAguinaldo" datasource="#session.DSN#">
    	update #salida#
			set Aguinaldo = coalesce((
					select sum(a.ICmontores) 
					from HIncidenciasCalculo a
					where a.DEid = #salida#.DEid
					and a.RCNid = #salida#.RCNid 
					and CIid in (select distinct a.CIid
								from RHReportesNomina c
									inner join RHColumnasReporte b
												inner join RHConceptosColumna a
												on a.RHCRPTid = b.RHCRPTid
										 on b.RHRPTNid = c.RHRPTNid
										and b.RHCRPTcodigo = 'Aguinaldo'
								where c.RHRPTNcodigo = 'LS'
								  and c.Ecodigo = #session.Ecodigo#)), 0.00)
				- ( coalesce((	select sum(a.DCvalor) 
								from HDeduccionesCalculo a, DeduccionesEmpleado b,TDeduccion z
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
												and b.RHCRPTcodigo = 'Aguinaldo'
										where c.RHRPTNcodigo = 'LS'
										  and c.Ecodigo = #session.Ecodigo#)),0.00)
					+ coalesce((
							select sum(a.CCvaloremp) 	
							from HCargasCalculo a, DCargas b, ECargas c
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
												and b.RHCRPTcodigo = 'Aguinaldo'
										where c.RHRPTNcodigo = 'LS'
										  and c.Ecodigo = #session.Ecodigo#)),0.00)
				
				
				)	
    </cfquery>
   <!--- VACACIONES --->
    <cfquery name="rsVacaciones" datasource="#session.DSN#">
    	update #salida#
			set Vacaciones = coalesce((
					select sum(a.ICmontores) 
					from HIncidenciasCalculo a
					 where a.DEid = #salida#.DEid
					and a.RCNid = #salida#.RCNid 
					and CIid in (select distinct a.CIid
								from RHReportesNomina c
									inner join RHColumnasReporte b
												inner join RHConceptosColumna a
												on a.RHCRPTid = b.RHCRPTid
										 on b.RHRPTNid = c.RHRPTNid
										and b.RHCRPTcodigo = 'Vacaciones'
								where c.RHRPTNcodigo = 'LS'
								  and c.Ecodigo = #session.Ecodigo#)),0)
								  
				- ( coalesce((	select sum(a.DCvalor) 
								from HDeduccionesCalculo a, DeduccionesEmpleado b,TDeduccion z
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
												and b.RHCRPTcodigo = 'Vacaciones'
										where c.RHRPTNcodigo = 'LS'
										  and c.Ecodigo = #session.Ecodigo#)),0.00)
					+ coalesce((
							select sum(a.CCvaloremp) 	
							from HCargasCalculo a, DCargas b, ECargas c
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
												and b.RHCRPTcodigo = 'Vacaciones'
										where c.RHRPTNcodigo = 'LS'
										  and c.Ecodigo = #session.Ecodigo#)),0.00)
				
				
				)	
    </cfquery>
    
    <!--- INDEMNIZACION --->
    <cfquery name="rsIndemnizacion" datasource="#session.DSN#">
    	update #salida#
			set Indemniza = coalesce((
					select sum(a.ICmontores) 
					from HIncidenciasCalculo a
					where a.DEid = #salida#.DEid
					and a.RCNid = #salida#.RCNid 
					and CIid in (select distinct a.CIid
								from RHReportesNomina c
									inner join RHColumnasReporte b
												inner join RHConceptosColumna a
												on a.RHCRPTid = b.RHCRPTid
										 on b.RHRPTNid = c.RHRPTNid
										and b.RHCRPTcodigo = 'Indemniza'
								where c.RHRPTNcodigo = 'LS'
								  and c.Ecodigo = #session.Ecodigo#)), 0.00)
				- ( coalesce((	select sum(a.DCvalor) 
								from HDeduccionesCalculo a, DeduccionesEmpleado b,TDeduccion z
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
												and b.RHCRPTcodigo = 'Indemniza'
										where c.RHRPTNcodigo = 'LS'
										  and c.Ecodigo = #session.Ecodigo#)),0.00)
					+ coalesce((
							select sum(a.CCvaloremp) 	
							from HCargasCalculo a, DCargas b, ECargas c
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
												and b.RHCRPTcodigo = 'Indemniza'
										where c.RHRPTNcodigo = 'LS'
										  and c.Ecodigo = #session.Ecodigo#)),0.00)
				
				
				)	
    </cfquery>
    <!--- OTROS --->
    <cfquery name="rsOtros" datasource="#session.DSN#">
    	update #salida#
			set Otros = coalesce((
					select sum(a.ICmontores) 
					from HIncidenciasCalculo a
					where a.DEid = #salida#.DEid
					and a.RCNid = #salida#.RCNid 
					and CIid in (select distinct a.CIid
								from RHReportesNomina c
									inner join RHColumnasReporte b
												inner join RHConceptosColumna a
												on a.RHCRPTid = b.RHCRPTid
										 on b.RHRPTNid = c.RHRPTNid
										and b.RHCRPTcodigo = 'Otros'
								where c.RHRPTNcodigo = 'LS'
								  and c.Ecodigo = #session.Ecodigo#)), 0.00)
					- ( coalesce((	select sum(a.DCvalor) 
								from HDeduccionesCalculo a, DeduccionesEmpleado b,TDeduccion z
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
												and b.RHCRPTcodigo = 'Otros'
										where c.RHRPTNcodigo = 'LS'
										  and c.Ecodigo = #session.Ecodigo#)),0.00)
					+ coalesce((
							select sum(a.CCvaloremp) 	
							from HCargasCalculo a, DCargas b, ECargas c
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
												and b.RHCRPTcodigo = 'Otros'
										where c.RHRPTNcodigo = 'LS'
										  and c.Ecodigo = #session.Ecodigo#)),0.00)
				
				
				)
    </cfquery>
    <!--- COMISIONES --->
    <cfquery name="rsComisiones" datasource="#session.DSN#">
    	update #salida#
			set Comisiones = coalesce((
					select sum(a.ICmontores) 
					from HIncidenciasCalculo a
					where a.DEid = #salida#.DEid
					and a.RCNid = #salida#.RCNid 
					and CIid in (select distinct a.CIid
								from RHReportesNomina c
									inner join RHColumnasReporte b
												inner join RHConceptosColumna a
												on a.RHCRPTid = b.RHCRPTid
										 on b.RHRPTNid = c.RHRPTNid
										and b.RHCRPTcodigo = 'Comisiones'
								where c.RHRPTNcodigo = 'LS'
								  and c.Ecodigo = #session.Ecodigo#)), 0.00)
					- ( coalesce((	select sum(a.DCvalor) 
								from HDeduccionesCalculo a, DeduccionesEmpleado b,TDeduccion z
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
												and b.RHCRPTcodigo = 'Comisiones'
										where c.RHRPTNcodigo = 'LS'
										  and c.Ecodigo = #session.Ecodigo#)),0.00)
					+ coalesce((
							select sum(a.CCvaloremp) 	
							from HCargasCalculo a, DCargas b, ECargas c
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
												and b.RHCRPTcodigo = 'Comisiones'
										where c.RHRPTNcodigo = 'LS'
										  and c.Ecodigo = #session.Ecodigo#)),0.00)
				
				
				)
    </cfquery>
    <!--- SEPTIMO --->
	<cfquery name="rsComisiones" datasource="#session.DSN#">
    	update #salida#
			set Septimo = coalesce((
					select sum(a.ICmontores) 
					from HIncidenciasCalculo a
					where a.DEid = #salida#.DEid
					and a.RCNid = #salida#.RCNid 
					and CIid in (select distinct a.CIid
								from RHReportesNomina c
									inner join RHColumnasReporte b
												inner join RHConceptosColumna a
												on a.RHCRPTid = b.RHCRPTid
										 on b.RHRPTNid = c.RHRPTNid
										and b.RHCRPTcodigo = 'Septimo'
								where c.RHRPTNcodigo = 'LS'
								  and c.Ecodigo = #session.Ecodigo#)), 0.00)
					- ( coalesce((	select sum(a.DCvalor) 
								from HDeduccionesCalculo a, DeduccionesEmpleado b,TDeduccion z
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
												and b.RHCRPTcodigo = 'Septimo'
										where c.RHRPTNcodigo = 'LS'
										  and c.Ecodigo = #session.Ecodigo#)),0.00)
					+ coalesce((
							select sum(a.CCvaloremp) 	
							from HCargasCalculo a, DCargas b, ECargas c
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
												and b.RHCRPTcodigo = 'Septimo'
										where c.RHRPTNcodigo = 'LS'
										  and c.Ecodigo = #session.Ecodigo#)),0.00)
				
				
				)
    </cfquery>
    <!--- IGSS --->
    <cfquery name="rsCargas" datasource="#session.DSN#">
    	update #salida#
			set IGSS = coalesce((
					select sum(a.CCvaloremp) 	
					from HCargasCalculo a
					inner join DCargas b
						  on b.DClinea = a.DClinea
					inner join ECargas c
						  on c.ECid = b.ECid
						  and c.ECauto = 1
					where a.DEid = #salida#.DEid
					and a.RCNid = #salida#.RCNid),0.00)
    </cfquery>
    <!--- ASOCIACION SOLIDARISTA --->
    <cfquery name="rsAsoc" datasource="#session.DSN#">
    	update #salida#
			set Asoc = (coalesce((	select sum(a.DCvalor) 
						from HDeduccionesCalculo a, DeduccionesEmpleado b,TDeduccion z
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
										and b.RHCRPTcodigo = 'Asoc'
								where c.RHRPTNcodigo = 'LS'
								  and c.Ecodigo = #session.Ecodigo#)),0.00)
						+ coalesce((
								select sum(a.CCvaloremp) 	
								from HCargasCalculo a, DCargas b, ECargas c
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
													and b.RHCRPTcodigo = 'Asoc'
											where c.RHRPTNcodigo = 'LS'
											  and c.Ecodigo = #session.Ecodigo#)),0.00))
						- ( coalesce((select sum(a.ICmontores) 
										from HIncidenciasCalculo a
										where a.DEid = #salida#.DEid
										and a.RCNid = #salida#.RCNid 
										and CIid in (select distinct a.CIid
													from RHReportesNomina c
														inner join RHColumnasReporte b
																	inner join RHConceptosColumna a
																	on a.RHCRPTid = b.RHCRPTid
															 on b.RHRPTNid = c.RHRPTNid
															and b.RHCRPTcodigo = 'Asoc'
													where c.RHRPTNcodigo = 'LS'
													  and c.Ecodigo = #session.Ecodigo#)), 0.00))
    </cfquery>
    <!--- ISR --->
	<cfquery name="rsSalarioOrd" datasource="#session.DSN#">
    	update #salida#
        set ISR = coalesce((select SErenta
        							 from HSalarioEmpleado hse
                                     where hse.RCNid = #salida#.RCNid
                                       and hse.DEid = #salida#.DEid
        							),0.00)
   	</cfquery>
    <cfquery name="rsISR" datasource="#session.DSN#">
    	update #salida#
			set ISR = ISR + (coalesce((	select sum(a.DCvalor) 
						from HDeduccionesCalculo a, DeduccionesEmpleado b,TDeduccion z
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
										and b.RHCRPTcodigo = 'ISR'
								where c.RHRPTNcodigo = 'LS'
								  and c.Ecodigo = #session.Ecodigo#)),0.00)
						+ coalesce((
								select sum(a.CCvaloremp) 	
								from HCargasCalculo a, DCargas b, ECargas c
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
													and b.RHCRPTcodigo = 'ISR'
											where c.RHRPTNcodigo = 'LS'
											  and c.Ecodigo = #session.Ecodigo#)),0.00))
						- ( coalesce((select sum(a.ICmontores) 
										from HIncidenciasCalculo a
										where a.DEid = #salida#.DEid
										and a.RCNid = #salida#.RCNid 
										and CIid in (select distinct a.CIid
													from RHReportesNomina c
														inner join RHColumnasReporte b
																	inner join RHConceptosColumna a
																	on a.RHCRPTid = b.RHCRPTid
															 on b.RHRPTNid = c.RHRPTNid
															and b.RHCRPTcodigo = 'ISR'
													where c.RHRPTNcodigo = 'LS'
													  and c.Ecodigo = #session.Ecodigo#)), 0.00))
    </cfquery>
    <!--- BANCO DE LOS TRABAJADORES --->
     <cfquery name="rsBanT" datasource="#session.DSN#">
    	update #salida#
			set BanTrab = (coalesce((	select sum(a.DCvalor) 
						from HDeduccionesCalculo a, DeduccionesEmpleado b,TDeduccion z
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
										and b.RHCRPTcodigo = 'BanTrab'
								where c.RHRPTNcodigo = 'LS'
								  and c.Ecodigo = #session.Ecodigo#)),0.00)
						+ coalesce((
								select sum(a.CCvaloremp) 	
								from HCargasCalculo a, DCargas b, ECargas c
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
													and b.RHCRPTcodigo = 'BanTrab'
											where c.RHRPTNcodigo = 'LS'
											  and c.Ecodigo = #session.Ecodigo#)),0.00))
						- ( coalesce((select sum(a.ICmontores) 
										from HIncidenciasCalculo a
										where a.DEid = #salida#.DEid
										and a.RCNid = #salida#.RCNid 
										and CIid in (select distinct a.CIid
													from RHReportesNomina c
														inner join RHColumnasReporte b
																	inner join RHConceptosColumna a
																	on a.RHCRPTid = b.RHCRPTid
															 on b.RHRPTNid = c.RHRPTNid
															and b.RHCRPTcodigo = 'BanTrab'
													where c.RHRPTNcodigo = 'LS'
													  and c.Ecodigo = #session.Ecodigo#)), 0.00))

    </cfquery>
    <!--- OTROS DESCUENTOS --->
     <cfquery name="rsOtrosDesc" datasource="#session.DSN#">
    	update #salida#
			set OtrosDesc = (coalesce((	select sum(a.DCvalor) 
						from HDeduccionesCalculo a, DeduccionesEmpleado b,TDeduccion z
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
										and b.RHCRPTcodigo = 'OtrosDesc'
								where c.RHRPTNcodigo = 'LS'
								  and c.Ecodigo = #session.Ecodigo#)),0.00)
						+ coalesce((
								select sum(a.CCvaloremp) 	
								from HCargasCalculo a, DCargas b, ECargas c
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
													and b.RHCRPTcodigo = 'OtrosDesc'
											where c.RHRPTNcodigo = 'LS'
											  and c.Ecodigo = #session.Ecodigo#)),0.00))
						- ( coalesce((select sum(a.ICmontores) 
										from HIncidenciasCalculo a
										where a.DEid = #salida#.DEid
										and a.RCNid = #salida#.RCNid 
										and CIid in (select distinct a.CIid
													from RHReportesNomina c
														inner join RHColumnasReporte b
																	inner join RHConceptosColumna a
																	on a.RHCRPTid = b.RHCRPTid
															 on b.RHRPTNid = c.RHRPTNid
															and b.RHCRPTcodigo = 'OtrosDesc'
													where c.RHRPTNcodigo = 'LS'
													  and c.Ecodigo = #session.Ecodigo#)), 0.00))
    </cfquery>
 	<!--- LO PAGADO EN ANTICIPO --->
	<cfquery name="rsPagoAnticipos" datasource="#session.DSN#">
		update #salida#
		set OtrosDesc = OtrosDesc + coalesce((select monto
									 from #Anticipos# a
									 where a.DEid = #salida#.DEid
									   and a.CPperiodo = #salida#.CPperiodo
									   and a.CPmes = #salida#.CPmes),0)
	</cfquery>
    <!--- MONTO LIQUIDO --->
    <cfquery name="rsSalarioLiq" datasource="#session.DSN#">
    	update #salida#
        set MontoLiquido = (select SEliquido
        					from HSalarioEmpleado
                            where DEid = #salida#.DEid
                              and RCNid  = #salida#.RCNid)
    </cfquery>
	<cfquery name="rs" datasource="#session.DSN#">
		select max(a.RCNid) as RCNid
		from #salida# a
		inner join #salida# b
			on b.DEid = a.DEid
			and b.CPperiodo = a.CPperiodo
			and b.CPmes = a.CPmes
		group by a.CPperiodo, a.CPmes
	</cfquery>
    <!--- SUMARIZA LAS NOMINAS ESPECIALES A LAS NORMALES, PARA LOS PERIODOS CORRESPONDIENTES. --->
    <cfquery name="rsEspeciales" datasource="#session.DSN#">
    	update #salida#
        set Dias 		= Dias + coalesce((select sum(Dias) from #salida# x where x.CPtipo = 1 and x.CPperiodo = #salida#.CPperiodo and x.CPmes = #salida#.CPmes and x.DEid = #salida#.DEid),0),
        	HorasExtra 	= HorasExtra + coalesce((select sum(HorasExtra) from #salida# x where x.CPtipo = 1 and x.CPperiodo = #salida#.CPperiodo and x.CPmes = #salida#.CPmes and x.DEid = #salida#.DEid),0),
            Ordinario 	= Ordinario + coalesce((select sum(Ordinario) from #salida# x where x.CPtipo = 1 and x.CPperiodo = #salida#.CPperiodo and x.CPmes = #salida#.CPmes and x.DEid = #salida#.DEid),0),      
            Bonifica 	= Bonifica + coalesce((select sum(Bonifica) from #salida# x where x.CPtipo = 1 and x.CPperiodo = #salida#.CPperiodo and x.CPmes = #salida#.CPmes and x.DEid = #salida#.DEid),0),
            ExtrasS 	= ExtrasS + coalesce((select sum(ExtrasS) from #salida# x where x.CPtipo = 1 and x.CPperiodo = #salida#.CPperiodo and x.CPmes = #salida#.CPmes and x.DEid = #salida#.DEid),0),
            ExtrasD 	= ExtrasD + coalesce((select sum(ExtrasD) from #salida# x where x.CPtipo = 1 and x.CPperiodo = #salida#.CPperiodo and x.CPmes = #salida#.CPmes and x.DEid = #salida#.DEid),0),
        	Aguinaldo 	= Aguinaldo + coalesce((select sum(Aguinaldo) from #salida# x where x.CPtipo = 1 and x.CPperiodo = #salida#.CPperiodo and x.CPmes = #salida#.CPmes and x.DEid = #salida#.DEid),0),
            Vacaciones 	= Vacaciones + coalesce((select sum(Vacaciones) from #salida# x where x.CPtipo = 1 and x.CPperiodo = #salida#.CPperiodo and x.CPmes = #salida#.CPmes and x.DEid = #salida#.DEid),0),
            Indemniza 	= Indemniza + coalesce((select sum(Indemniza) from #salida# x where x.CPtipo = 1 and x.CPperiodo = #salida#.CPperiodo and x.CPmes = #salida#.CPmes and x.DEid = #salida#.DEid),0),
            Otros	 	= Otros + coalesce((select sum(Otros) from #salida# x where x.CPtipo = 1 and x.CPperiodo = #salida#.CPperiodo and x.CPmes = #salida#.CPmes and x.DEid = #salida#.DEid),0),
            Comisiones 	= Comisiones + coalesce((select sum(Comisiones) from #salida# x where x.CPtipo = 1 and x.CPperiodo = #salida#.CPperiodo and x.CPmes = #salida#.CPmes and x.DEid = #salida#.DEid),0),
            Septimo 	= Septimo + coalesce((select sum(Septimo) from #salida# x where x.CPtipo = 1 and x.CPperiodo = #salida#.CPperiodo and x.CPmes = #salida#.CPmes and x.DEid = #salida#.DEid),0),
            IGSS	 	= IGSS + coalesce((select sum(IGSS) from #salida# x where x.CPtipo = 1 and x.CPperiodo = #salida#.CPperiodo and x.CPmes = #salida#.CPmes and x.DEid = #salida#.DEid),0),
            Asoc	 	= Asoc + coalesce((select sum(Asoc) from #salida# x where x.CPtipo = 1 and x.CPperiodo = #salida#.CPperiodo and x.CPmes = #salida#.CPmes and x.DEid = #salida#.DEid),0),
            ISR 		= ISR + coalesce((select sum(ISR) from #salida# x where x.CPtipo = 1 and x.CPperiodo = #salida#.CPperiodo and x.CPmes = #salida#.CPmes and x.DEid = #salida#.DEid),0),
            BanTrab 	= BanTrab + coalesce((select sum(BanTrab) from #salida# x where x.CPtipo = 1 and x.CPperiodo = #salida#.CPperiodo and x.CPmes = #salida#.CPmes and x.DEid = #salida#.DEid),0),
            OtrosDesc 	= OtrosDesc + coalesce((select sum(OtrosDesc) from #salida# x where x.CPtipo = 1 and x.CPperiodo = #salida#.CPperiodo and x.CPmes = #salida#.CPmes and x.DEid = #salida#.DEid),0),
            MontoLiquido= MontoLiquido + coalesce((select sum(MontoLiquido) from #salida# x where x.CPtipo = 1 and x.CPperiodo = #salida#.CPperiodo and x.CPmes = #salida#.CPmes and x.DEid = #salida#.DEid),0),
            MontoBruto 	= MontoBruto + coalesce((select sum(MontoBruto) from #salida# x where x.CPtipo = 1 and x.CPperiodo = #salida#.CPperiodo and x.CPmes = #salida#.CPmes and x.DEid = #salida#.DEid),0)
		where CPtipo <> 1
		  and RCNid in (select max(a.RCNid)
						from #salida# a
						inner join #salida# b
							on b.DEid = a.DEid
							and b.CPperiodo = a.CPperiodo
							and b.CPmes = a.CPmes
						where a.CPtipo <> 1
						group by a.CPperiodo, a.CPmes)
    </cfquery>
     <!--- MONTO BRUTO --->
    <cfquery name="rsSalarioLiq" datasource="#session.DSN#">
    	update #salida#
        set MontoBruto = Ordinario + Bonifica + ExtrasS + ExtrasD + Aguinaldo + Vacaciones +  Indemniza + Otros + Comisiones + Septimo
    </cfquery>

	<cfinclude template="ReporteLibroSalarios-Ceses.cfm">
	<cfquery name="rsInsertaCese" datasource="#session.DSN#">
		insert into #salida#(RCNid, DEid, CPcodigo,CPtipo, RCdesde, RChasta, 
								 ExtrasS, ExtrasD, Aguinaldo, Vacaciones, Indemniza,
								 Otros, Comisiones, Asoc, ISR, BanTrab, OtrosDesc,Dias,HorasExtra,
								 Ordinario,Bonifica,Septimo,MontoLiquido,MontoBruto,IGSS)
		select DLlinea, DEid, CPcodigo,CPtipo, RCdesde, RChasta, ExtrasS, ExtrasD, Aguinaldo, Vacaciones, Indemniza,
		Otros, Comisiones, Asoc, ISR, BanTrab, OtrosDesc,0,0,0,0,0,0,0,0
		from #salidaCese#
	</cfquery>
		
	
    <cfquery name="rsReporte" datasource="#session.DSN#">
    	select DEidentificacion, 
        	{fn concat(DEnombre,{fn concat(' ',{fn concat(DEapellido1,{fn concat(' ',DEapellido2)})})})} as NombreEmp,
        	s.*
        from #salida# s
        inner join DatosEmpleado de
			on de.DEid = s.DEid 
        where CPtipo <> 1
        order by DEidentificacion, RCdesde
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
	
    <table width="100%" border="0" cellpadding="2" cellspacing="0" align="center" style="border-color:CCCCCC">
		<cfoutput>
		<!--- <tr>
			<td colspan="21">
				<table width="100%" cellpadding="0" cellspacing="0">
					<tr><td>
						<cf_EncReporte
							Titulo="#LB_LibroDeSalarios#"
							Color="##E3EDEF"
							filtro1="#LB_FechaRige#: #url.Fdesde#   #LB_FechaVence#: #url.Fhasta#"	
						>
					</td></tr>
				</table>
			</td>
		</tr> --->
		<!----===================== ENCABEZADO ANTERIOR =====================---->
        <tr><td align="center" class="titulo_empresa2" colspan="21"><strong>#rsEmpresa.Edescripcion#</strong></td></tr>
        <tr><td align="center" class="titulo_empresa2" colspan="21"><strong>#LB_LibroDeSalarios#</strong></td></tr>
        <tr><td align="center" class="titulo_empresa2" colspan="21"><strong>#LB_FechaRige#: #url.Fdesde# &nbsp; #LB_FechaVence#: #url.Fhasta#	</strong></td></tr>
        <tr><td>&nbsp;</td></tr>
		
        </cfoutput>
        <tr><td height="1" bgcolor="000000" colspan="21"></td>
        <cfoutput query="rsReporte" group="DEid">
			<tr class="listaCorte1"><td colspan="21">#DEidentificacion#&nbsp;-&nbsp;#NombreEmp#</td></tr>
            <tr><td height="1" bgcolor="000000" colspan="21"></td>
            <tr class="listaCorte3">
            	<td nowrap ><cf_translate key="LB_Codigo">C&oacute;digo</cf_translate></td>
                <td nowrap>&nbsp;<cf_translate key="LB_Dias">D&iacute;as</cf_translate></td>
                <td nowrap>&nbsp;<cf_translate key="LB_HorasExtra">Horas Extra</cf_translate></td>
                <td nowrap>&nbsp;<cf_translate key="LB_Sueldo">Sueldo</cf_translate></td>
                <td nowrap>&nbsp;<cf_translate key="LB_Ordinario">Ordinario</cf_translate></td>
                <td nowrap>&nbsp;<cf_translate key="LB_Bonifica">Bonifica</cf_translate></td>
                <td nowrap>&nbsp;<cf_translate key="LB_ExtraS">Extra S</cf_translate></td>
                <td nowrap>&nbsp;<cf_translate key="LB_ExtraD">Extra D</cf_translate></td>
                <td nowrap>&nbsp;<cf_translate key="LB_Aguinaldo">Aguinaldo</cf_translate></td>
                <td nowrap>&nbsp;<cf_translate key="LB_Vacaciones">Vacaciones</cf_translate></td>
                <td nowrap>&nbsp;<cf_translate key="LB_Indemniza">Indemniza</cf_translate></td>
                <td nowrap>&nbsp;<cf_translate key="LB_Otros">Otros</cf_translate></td>
                <td nowrap>&nbsp;<cf_translate key="LB_Comisiones">Comisiones</cf_translate></td>
                <td nowrap>&nbsp;<cf_translate key="LB_Septimo">S&eacute;ptimo</cf_translate></td>
                <td nowrap>&nbsp;<cf_translate key="LB_IGSS">IGSS</cf_translate></td>
                <td nowrap>&nbsp;<cf_translate key="LB_AsocSolidarista">Asoc. Solidarista</cf_translate></td>
                <td nowrap>&nbsp;<cf_translate key="LB_ISR">ISR</cf_translate></td>
                <td nowrap>&nbsp;<cf_translate key="LB_BanTrab">BanTrab</cf_translate></td>
                <td nowrap>&nbsp;<cf_translate key="LB_OtrosDesc">Otros Desc</cf_translate></td>
                <td nowrap>&nbsp;<cf_translate key="LB_Liquido">L&iacute;quido</cf_translate></td>
                <td nowrap>&nbsp;<cf_translate key="LB_Bruto">Bruto</cf_translate></td>
            </tr>
            <tr><td height="1" bgcolor="000000" colspan="21"></td>
            <cfsilent>
            	<cfset Lvar_Count 		= 0>
				<cfset Lvar_TotalDias 	= 0>
                <cfset Lvar_TotalHorasE = 0>
                <cfset Lvar_TotalOrd 	= 0>
                <cfset Lvar_TotalBono 	= 0>
                <cfset Lvar_TotalExtraS = 0>
                <cfset Lvar_TotalExtraD = 0>
                <cfset Lvar_TotalAgui 	= 0>
                <cfset Lvar_TotalVaca 	= 0>
                <cfset Lvar_TotalIndem 	= 0>
                <cfset Lvar_TotalOtros 	= 0>
                <cfset Lvar_TotalComis 	= 0>
                <cfset Lvar_TotalSept 	= 0>
                <cfset Lvar_TotalIGSS 	= 0>
                <cfset Lvar_TotalAsoc 	= 0>
                <cfset Lvar_TotalISR 	= 0>
                <cfset Lvar_TotalBanT 	= 0>
                <cfset Lvar_TotalOtrosD = 0>
                <cfset Lvar_TotalLiquido = 0>
                <cfset Lvar_TotalBruto 	=  0>
            </cfsilent>
            <cfoutput>
				 <tr>
                    <td class="detalle" nowrap>#CPcodigo#</td>
                    <td class="detallec" nowrap>#Dias#</td>
                    <td class="detallec" nowrap>#HorasExtra#</td>
                    <td class="detaller" nowrap>#LSCurrencyFormat(Sueldo,'none')#</td>
                    <td class="detaller" nowrap>#LSCurrencyFormat(Ordinario,'none')#</td>
                    <td class="detaller" nowrap>#LSCurrencyFormat(Bonifica,'none')#</td>
                    <td class="detaller" nowrap>#LSCurrencyFormat(ExtrasS,'none')#</td>
                    <td class="detaller" nowrap>#LSCurrencyFormat(ExtrasD,'none')#</td>
                    <td class="detaller" nowrap>#LSCurrencyFormat(Aguinaldo,'none')#</td>
                    <td class="detaller" nowrap>#LSCurrencyFormat(Vacaciones,'none')#</td>
                    <td class="detaller" nowrap>#LSCurrencyFormat(Indemniza,'none')#</td>
                    <td class="detaller" nowrap>#LSCurrencyFormat(Otros,'none')#</td>
                    <td class="detaller" nowrap>#LSCurrencyFormat(Comisiones,'none')#</td>
                    <td class="detaller" nowrap>#LSCurrencyFormat(Septimo,'none')#</td>
                    <td class="detaller" nowrap>#LSCurrencyFormat(IGSS,'none')#</td>
                    <td class="detaller" nowrap>#LSCurrencyFormat(Asoc,'none')#</td>
                    <td class="detaller" nowrap>#LSCurrencyFormat(ISR,'none')#</td>
                    <td class="detaller" nowrap>#LSCurrencyFormat(BanTrab,'none')#</td>
                    <td class="detaller" nowrap>#LSCurrencyFormat(OtrosDesc,'none')#</td>
                    <td class="detaller" nowrap>#LSCurrencyFormat(MontoLiquido,'none')#</td>
                    <td class="detaller" nowrap>#LSCurrencyFormat(MontoBruto,'none')#</td>
                </tr>
                <!--- SUMA PARA LOS TOTALES --->
                <cfsilent>
                	<cfset Lvar_Count 		=  Lvar_Count + 1>
					<cfset Lvar_TotalDias 	=  Lvar_TotalDias + Dias>
                    <cfset Lvar_TotalHorasE =  Lvar_TotalHorasE + HorasExtra>
                    <cfset Lvar_TotalOrd 	=  Lvar_TotalOrd + Ordinario>
                    <cfset Lvar_TotalBono 	=  Lvar_TotalBono + Bonifica>
                    <cfset Lvar_TotalExtraS =  Lvar_TotalExtraS + ExtrasS>
                    <cfset Lvar_TotalExtraD =  Lvar_TotalExtraD + ExtrasD>
                    <cfset Lvar_TotalAgui 	=  Lvar_TotalAgui + Aguinaldo>
                    <cfset Lvar_TotalVaca 	=  Lvar_TotalVaca + Vacaciones>
                    <cfset Lvar_TotalIndem 	=  Lvar_TotalIndem + Indemniza>
                    <cfset Lvar_TotalOtros 	=  Lvar_TotalOtros + Otros>
                    <cfset Lvar_TotalComis 	=  Lvar_TotalComis + Comisiones>
                    <cfset Lvar_TotalSept 	=  Lvar_TotalSept + Septimo>
                    <cfset Lvar_TotalIGSS 	=  Lvar_TotalIGSS + IGSS>
                    <cfset Lvar_TotalAsoc 	=  Lvar_TotalAsoc + Asoc>
                    <cfset Lvar_TotalISR 	=  Lvar_TotalISR + ISR>
                    <cfset Lvar_TotalBanT 	=  Lvar_TotalBanT + BanTrab>
                    <cfset Lvar_TotalOtrosD =  Lvar_TotalOtrosD + OtrosDesc>
                    <cfset Lvar_TotalLiquido =  Lvar_TotalLiquido + MontoLiquido>
                    <cfset Lvar_TotalBruto 	=  Lvar_TotalBruto + MontoBruto>
                </cfsilent>
			</cfoutput>
            <tr><td height="1" bgcolor="000000" colspan="21"></td>
            <tr>
                <td class="detalle" nowrap><cf_translate key="LB_Sumas">Sumas</cf_translate></td>
                <td class="detallec" nowrap>#Lvar_TotalDias#</td>
                <td class="detallec" nowrap>#Lvar_TotalHorasE#</td>
                <td class="detaller" nowrap>&nbsp;</td>
                <td class="detaller" nowrap>#LSCurrencyFormat(Lvar_TotalOrd,'none')#</td>
                <td class="detaller" nowrap>#LSCurrencyFormat(Lvar_TotalBono,'none')#</td>
                <td class="detaller" nowrap>#LSCurrencyFormat(Lvar_TotalExtraS,'none')#</td>
                <td class="detaller" nowrap>#LSCurrencyFormat(Lvar_TotalExtraD,'none')#</td>
                <td class="detaller" nowrap>#LSCurrencyFormat(Lvar_TotalAgui,'none')#</td>
                <td class="detaller" nowrap>#LSCurrencyFormat(Lvar_TotalVaca,'none')#</td>
                <td class="detaller" nowrap>#LSCurrencyFormat(Lvar_TotalIndem,'none')#</td>
                <td class="detaller" nowrap>#LSCurrencyFormat(Lvar_TotalOtros,'none')#</td>
                <td class="detaller" nowrap>#LSCurrencyFormat(Lvar_TotalComis,'none')#</td>
                <td class="detaller" nowrap>#LSCurrencyFormat(Lvar_TotalSept,'none')#</td>
                <td class="detaller" nowrap>#LSCurrencyFormat(Lvar_TotalIGSS,'none')#</td>
                <td class="detaller" nowrap>#LSCurrencyFormat(Lvar_TotalAsoc,'none')#</td>
                <td class="detaller" nowrap>#LSCurrencyFormat(Lvar_TotalISR,'none')#</td>
                <td class="detaller" nowrap>#LSCurrencyFormat(Lvar_TotalBanT,'none')#</td>
                <td class="detaller" nowrap>#LSCurrencyFormat(Lvar_TotalOtrosD,'none')#</td>
                <td class="detaller" nowrap>#LSCurrencyFormat(Lvar_TotalLiquido,'none')#</td>
                <td class="detaller" nowrap>#LSCurrencyFormat(Lvar_TotalBruto,'none')#</td>
            </tr>
            <tr><td height="1" bgcolor="000000" colspan="21"></td>
             <tr>
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
            </tr>
            <tr><td height="1" bgcolor="000000" colspan="21"></td>
		</cfoutput><!--- CORTE POR EMPLEADO --->
    </table>
<cfelse>
	<table width="100%" border="0" cellpadding="2" cellspacing="0" align="center">
    	<tr class="titulo_empresa2"><td align="center">No se han definido las columnas del reporte.</td></tr>
    </table>
</cfif>