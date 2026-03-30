	<cfsavecontent variable="presets_ret2">
		<cfquery datasource="#session.dsn#" name="jornadas">
			select RHJhoradiaria, RHJornadahora, RHJcodigo
			from RHJornadas a, LineaTiempo b
			where b.DEid = #DEid#
			and a.Ecodigo = #Ecodigo#
			and b.Ecodigo = #Ecodigo#
			and a.RHJid = b.RHJid
			and <cfqueryparam cfsqltype="cf_sql_date" value="#Fecha1_Accion#"> between LTdesde and LThasta 
		</cfquery>
		HorasDiarias = <cfoutput>#jornadas.RHJhoradiaria#</cfoutput><cfif Not Len(jornadas.RHJhoradiaria)>0</cfif>
		Destajo = <cfif jornadas.RHJornadahora eq 1>true<cfelse>false</cfif>
	
		<!--- Suplanta el Cdigo de la jornada default por la jornada del Planificador , si la tiene --->			
		<cfquery datasource="#session.dsn#" name="planificador">
			select RHJcodigo
			from RHJornadas a, RHPlanificador b
			where b.DEid = #DEid#
			and a.Ecodigo = #Ecodigo#
			and a.RHJid = b.RHJid
			and <cfqueryparam cfsqltype="cf_sql_date" value="#Fecha1_Accion#"> between b.RHPJfinicio and b.RHPJffinal
		</cfquery>
	
		<!--- Obtiene informacin detallada de la jornada del empleado --->			
		<!--- Variables:
				Jornada_Hnormales 	= Horas normales o bsicas de la jornada
				Jornada_Hextras 	= Horas extras bsicas de la jornada, extras que siempre se trabajan, conocidas en Marcas como ExtrasA
				Jornada_factorN		= Es el factor de multiplicacin de la Incidencia para pagar horas normales
				Jornada_factorA		= Es el factor de multiplicacin de la Incidencia para pagar horas ExtrasA
		--->			
		<cfif Arguments.RHJid>	
			<cfquery datasource="#session.dsn#" name="horas">
				select c.RHJhorasExtraA - c.RHJhorasNormales as ExtrasA, 
					   c.RHJhorasNormales as Normales,
					  (select CIfactor from CIncidentes b where a.RHJincExtraA = b.CIid) as factorA, 
					  (select CIfactor from CIncidentes b where a.RHJincHJornada = b.CIid) as factorN
				from RHJornadas a, RHDJornadas c
				where a.RHJid = c.RHJid 
				and a.RHJid = #Arguments.RHJid#
			</cfquery>
			Jornada_Hnormales = <cfoutput>#horas.Normales#</cfoutput><cfif Not Len(horas.Normales)>0</cfif>
			Jornada_Hextras = <cfoutput>#horas.ExtrasA#</cfoutput><cfif Not Len(horas.ExtrasA)>0</cfif>
			Jornada_factorN = <cfoutput>#horas.factorN#</cfoutput><cfif Not Len(horas.factorN)>1</cfif>
			Jornada_factorA = <cfoutput>#horas.factorA#</cfoutput><cfif Not Len(horas.factorA)>1</cfif>
		</cfif>

		<cfset SalarioPromedioLiq = 0>
		<cfif Arguments.calc_promedio>	
			<cfif Len(RHAlinea) Is 0 Or RHAlinea Is 0>
				<cfset Tcodigo = Arguments.Tcodigo>
			<cfelse>
				<cfif isdefined("arguments.origen") and origen eq 'DLaboralesEmpleado'>
					<cfquery name="rsTcodigo" datasource="#Session.DSN#">
						select Tcodigo
						from DLaboralesEmpleado
						where DLlinea = #RHAlinea#
					</cfquery>
				<cfelse>
					<cfquery name="rsTcodigo" datasource="#Session.DSN#">
						select Tcodigo
						from RHAcciones
						where RHAlinea = #RHAlinea#
					</cfquery>
				</cfif>
				<cfset Tcodigo = rsTcodigo.Tcodigo>
			</cfif>
				<cfif not lvarMasivo>
					<cf_dbtemp name="tbl_LPagosEmpleado" returnvariable="tbl_PagosEmpleado">
						<!--- <cf_dbtempcol name="Registro" type="numeric" identity="yes" mandatory="yes">  --->
						<cf_dbtempcol name="RCNid" type="numeric">
						<cf_dbtempcol name="DEid" type="numeric"> 
						<cf_dbtempcol name="FechaDesde" type="datetime">
						<cf_dbtempcol name="FechaHasta" type="datetime">
						<cf_dbtempcol name="Cantidad" type="int">
						<cf_dbtempcol name="RHAlinea" type="numeric">
						<!--- <cf_dbtempkey cols="Registro"> --->
					</cf_dbtemp>
				</cfif>
				<cfquery name="rsTipoPago" datasource="#Session.DSN#">
					select Ttipopago
					from TiposNomina
					where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
					and Tcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#Tcodigo#">
				</cfquery>
				<cfset Ttipopago = rsTipoPago.Ttipopago>
		
				<cfquery name="rsDiasNoPago" datasource="#Session.DSN#">
					select count(1) as diasnopago
					from DiasTiposNomina
					where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
					and Tcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#Tcodigo#">
				</cfquery>
				<cfset DiasNoPago = rsDiasNoPago.diasnopago>
		
				<cfswitch expression="#Ttipopago#">
					<cfcase value="0"> <cfset DiasNoPago = DiasNoPago * 1> </cfcase>
					<cfcase value="1"> <cfset DiasNoPago = DiasNoPago * 2> </cfcase>
					<cfcase value="2"> <cfset DiasNoPago = DiasNoPago * 2> </cfcase>
					<cfcase value="3"> <cfset DiasNoPago = DiasNoPago * 4> </cfcase>
					<cfdefaultcase> <cfset DiasNoPago = DiasNoPago * 1> </cfdefaultcase>
				</cfswitch>
				
				
				<!--- Parmetro de Cantidad de Periodos para el Calculo de Salario Promedio en Liquidaciones --->
				<cfinvoke component="rh.Componentes.RHParametros" method="get" datasource="#session.dsn#" 
					ecodigo="#session.Ecodigo#" pvalor="440" default="6" returnvariable="CantidadPeriodos"/>

				<!---ljimenez si el concepto de pago trae los parametros para el calculo de salario promedio los utiliza.--->
				<cfif isdefined("arguments.CIsprango") and #arguments.CIsprango# GT 0>
					<cfset TipoPeriodos 	= #arguments.CIsprango# >
					<cfset CantidadPeriodos = #arguments.CIspcantidad# >
				</cfif>
				
				<cfquery name="rsFecha1" datasource="#Session.DSN#">
					select max(CPdesde) as fecha1
					from CalendarioPagos
					where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
						and Tcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#Tcodigo#">
						and CPdesde <= <cfqueryparam cfsqltype="cf_sql_date" value="#Fecha1_Accion#">
				</cfquery>
				
				<!---ljimenez si el concepto de pago trae parametro mes completo se actualiza la fecha al inicio del mes.--->
				<cfif isdefined("arguments.CImescompleto") and #arguments.CImescompleto# GT 0>
					<cfset rsFecha1.fecha1 = CreateDate(year(rsFecha1.fecha1), month(rsFecha1.fecha1), 01)>
				</cfif>
				
				<cfquery name="rsFecha2" datasource="#Session.DSN#">
					select max(CPhasta) as fecha1
					from CalendarioPagos
					where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
						and Tcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#Tcodigo#">
						and CPdesde < <cfqueryparam cfsqltype="cf_sql_date" value="#rsFecha1.fecha1#">
				</cfquery>
				<cfset Fecha1 = rsFecha2.fecha1>
				<cfif Len(Trim(Fecha1))>
					<cfset Fecha2 = DateAdd('yyyy', -1, DateAdd('d', -30, Fecha1))>
					<cfquery name="tbl_PagosEmpleadoInsert" datasource="#session.DSN#">
						insert into #tbl_PagosEmpleado# (RCNid, DEid, FechaDesde, FechaHasta, Cantidad, RHAlinea)
						select distinct a.RCNid, #DEid#, a.RCdesde, a.RChasta, 0, <cfqueryparam cfsqltype="cf_sql_numeric" value="#lvarRHAlinea#">
						from HSalarioEmpleado b, HRCalculoNomina a, CalendarioPagos cp
						where b.DEid = #DEid#
						and a.RCNid = b.RCNid
						and a.Ecodigo = #Ecodigo#
						and a.RChasta <= <cfqueryparam cfsqltype="cf_sql_date" value="#Fecha1#">
						and a.RCdesde >= <cfqueryparam cfsqltype="cf_sql_date" value="#Fecha2#">
						and cp.CPid = a.RCNid
						and cp.CPtipo = 0
						order by a.RChasta desc
					</cfquery>
				</cfif>
		
				<!--- Borrar de la historia los periodos donde existe incapacidad --->
				<!---El siguiente codigo se agrega debido a que en el ITCR pagan la incapacidad completa y la toman en cuenta para el calculo del salario promedio--->
				<cfinvoke component="rh.Componentes.RHParametros" method="get" datasource="#session.dsn#" 
					ecodigo="#session.Ecodigo#" pvalor="2037" default="0" returnvariable="vUsaIncSP"/>
				
				<cfif #vUsaIncSP# eq 0>
					<cfquery name="delPagosEmpleado" datasource="#Session.DSN#">
						delete from #tbl_PagosEmpleado#
						where RHAlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#lvarRHAlinea#">
						  and DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#DEid#">
						  and exists(	select 1
										from HPagosEmpleado pe, RHTipoAccion d
										where pe.DEid = #tbl_PagosEmpleado#.DEid
											and pe.RCNid = #tbl_PagosEmpleado#.RCNid
											and d.RHTid = pe.RHTid
											and d.RHTcomportam = 5 )
					</cfquery>
				</cfif>
		
				<!--- 	Borrar de la historia los periodos anteriores o iguales a una salida de la empresa 
						Se busca la fecha maxima de salida y se eliminan los pagos anteriores --->
				<cfquery name="rsFechaSalida" datasource="#Session.DSN#">
					select max(LTdesde) as fechasalida
					from LineaTiempo lt, RHTipoAccion ta
					where lt.DEid = #DEid#
					and ta.RHTid = lt.RHTid
					and ta.RHTcomportam = 2
				</cfquery>
				<cfif rsFechaSalida.recordCount and Len(Trim(rsFechaSalida.fechasalida))>
					<cfquery name="delPagosEmpleado" datasource="#Session.DSN#">
						delete from #tbl_PagosEmpleado#
						where RHAlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#lvarRHAlinea#">
						  and DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#DEid#">
						  and FechaHasta <= <cfqueryparam cfsqltype="cf_sql_date" value="#rsFechaSalida.fechasalida#">
					</cfquery>
				</cfif>
				<cfquery name="rsPagosEmpleado" datasource="#Session.DSN#">
					select *
					from #tbl_PagosEmpleado#
					where RHAlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#lvarRHAlinea#">
					  and DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#DEid#">
					<!--- order by Registro --->
					order by FechaHasta desc,RCNid,DEid
				</cfquery>
				<cfloop query="rsPagosEmpleado">
					<cfquery name="updPagoEmpleado" datasource="#Session.DSN#">
						update #tbl_PagosEmpleado#
						set Cantidad = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsPagosEmpleado.CurrentRow#">
						<!--- where Registro = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsPagosEmpleado.Registro#"> --->
						where RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsPagosEmpleado.RCNid#">
						and DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsPagosEmpleado.DEid#">
					</cfquery>
				</cfloop>
				<cfquery name="delPagosEmpleado" datasource="#Session.DSN#">
					delete from #tbl_PagosEmpleado#
					where Cantidad > <cfqueryparam cfsqltype="cf_sql_integer" value="#CantidadPeriodos#">
					  and RHAlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#lvarRHAlinea#">
					  and DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#DEid#">
				</cfquery>
				<cfquery name="rsPagosEmpleado" datasource="#Session.DSN#">
					select 1
					from #tbl_PagosEmpleado#
					where RHAlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#lvarRHAlinea#">
					  and DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#DEid#">
				</cfquery>
				
				<cfif rsPagosEmpleado.recordCount>
					<!---ljimenez Tomar en salario promedio los retroactivos distribuidos por mes --->
					<cfinvoke component="rh.Componentes.RHParametros" method="get" 
						datasource="#session.dsn#" ecodigo="#session.Ecodigo#" pvalor="2038" default="0" returnvariable="vUsaRetro"/>			
	
					<cfif #vUsaRetro# eq 1>
						<!---Saco el salario que le corresponde a la nomina sin los retroactivos--->
						<cfquery name="rsSalarioPromedio01" datasource="#Session.DSN#">
							select coalesce(sum(hp.PEmontores),0) as salario
							from  HPagosEmpleado hp
								inner join HRCalculoNomina n
									inner join #tbl_PagosEmpleado# pe
									on pe.RCNid=n.RCNid
								on n.RCNid=hp.RCNid
								and n.RCdesde=hp.PEdesde
								and n.RChasta=hp.PEhasta
							where pe.RHAlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#lvarRHAlinea#">
							and hp.DEid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#DEid#">
						</cfquery>
						
						<!---Saco el salario si tiene algun retroactivo--->
						<cfquery name="rsSalarioPromedioR" datasource="#session.dsn#">
							select coalesce(sum(hp.PEmontores),0) as salario
								from  HPagosEmpleado hp,#tbl_PagosEmpleado# pe
								where hp.PEdesde  between pe.FechaDesde and pe.FechaHasta
								and hp.PEtiporeg in (1,2)
								and  pe.RHAlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#lvarRHAlinea#">
								and hp.DEid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#DEid#">
						</cfquery>	
					
						<!---Saco las incidencias del mes--->
						<cfquery name="rsSalarioPromedio2" datasource="#session.dsn#">
							select coalesce(sum(hi.ICmontores),0) as incidente
							from  HIncidenciasCalculo hi, HRCalculoNomina n,#tbl_PagosEmpleado# pe,CIncidentes ci
							where hi.RCNid=pe.RCNid
							and n.RCNid=hi.RCNid
							and hi.DEid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#DEid#">
							and hi.ICfecha between n.RCdesde and n.RChasta
							and  pe.RHAlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#lvarRHAlinea#">
							and ci.CIid = hi.CIid
							and ci.CIafectasalprom = 0
						</cfquery>
						<!---saco las incidencias retroactivas--->
						<cfquery name="rsSalarioPromedioRI" datasource="#Session.DSN#">
							select coalesce(sum(hi.ICmontores),0) as incidente
							from  HIncidenciasCalculo hi, #tbl_PagosEmpleado# pe,CIncidentes ci
							where hi.RCNid=pe.RCNid
							and hi.DEid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#DEid#">
							and hi.ICfecha between pe.FechaDesde and pe.FechaHasta
							and  pe.RHAlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#lvarRHAlinea#">
							and ci.CIid = hi.CIid
							and ci.CIafectasalprom = 0
						</cfquery>
						<cfquery name="rsSalarioPromedio3" datasource="#Session.DSN#">
							select sum(coalesce(PEcantdias, 0)) as dias
							from HPagosEmpleado b, #tbl_PagosEmpleado# a
							where a.RHAlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#lvarRHAlinea#">
							  and a.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#DEid#">
							  and b.RCNid = a.RCNid
							  and b.DEid = a.DEid
							  and b.PEtiporeg = 0
						</cfquery>
						<cfif rsSalarioPromedio3.recordCount GT 0 AND rsSalarioPromedio3.dias GT 0>
							<cfset Lvardias = rsSalarioPromedio3.dias>
						<cfelse>
							<cfset Lvardias = 1>
						</cfif>
						<!--- Obtener el salario promedio diario --->
						<cfset SalarioPromedioLiq = ((rsSalarioPromedio01.salario+rsSalarioPromedioR.salario) - (rsSalarioPromedio2.incidente+rsSalarioPromedioRI.incidente)) / Lvardias>
					<cfelse>
						<cfquery name="rsSalarioPromedioLiq1" datasource="#Session.DSN#">
							select sum(SEsalariobruto + SEincidencias) as salario
							from HSalarioEmpleado se, #tbl_PagosEmpleado# pe
							where se.RCNid = pe.RCNid
							and se.DEid = pe.DEid
							and pe.RHAlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#lvarRHAlinea#">
							and pe.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#DEid#">
						</cfquery>
						
						<cfquery name="rsSalarioPromedioLiq2" datasource="#Session.DSN#">
							select coalesce(sum(ic.ICmontores), 0.00) as incidencias
							from #tbl_PagosEmpleado# pe, HIncidenciasCalculo ic, CIncidentes ci
							where pe.RHAlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#lvarRHAlinea#">
							  and pe.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#DEid#">
							  and ic.RCNid = pe.RCNid
							  and ic.DEid = pe.DEid
							  and ci.CIid = ic.CIid
							  and ci.CIafectasalprom = 0
						</cfquery>
						
						<cfquery name="rsSalarioPromedioLiq3" datasource="#Session.DSN#">
							select sum(coalesce(PEcantdias, 0)) as dias
							from HPagosEmpleado b, #tbl_PagosEmpleado# a
							where a.RHAlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#lvarRHAlinea#">
							  and a.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#DEid#">
							  and b.RCNid = a.RCNid
							  and b.DEid = a.DEid
							  and b.PEtiporeg = 0
						</cfquery>
						
						<cfif rsSalarioPromedioLiq3.recordCount GT 0 AND rsSalarioPromedioLiq3.dias GT 0>
							<cfset Lvardias = rsSalarioPromedioLiq3.dias>
						<cfelse>
							<cfset Lvardias = 1>
						</cfif>
						
						<!--- Obtener el salario promedio diario --->
						<cfset SalarioPromedioLiq = (rsSalarioPromedioLiq1.salario - rsSalarioPromedioLiq2.incidencias) / Lvardias>
					</cfif>
					
					
					<!--- Salario Promedio = Salario Promedio Diario * Cantidad de Dias para calculo de Salario Diario --->
					<cfquery name="rsParametros" datasource="#Session.DSN#">
						select FactorDiasSalario as Pvalor
						from TiposNomina
						where Ecodigo = #session.Ecodigo#
						  and Tcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Tcodigo#">
					</cfquery>
					<cfif len(trim(rsParametros.Pvalor)) EQ 0 or rsParametros.RecordCount EQ 0>
						<cfquery name="rsParametros" datasource="#Session.DSN#">
							select Pvalor
							from RHParametros
							where Ecodigo = #Ecodigo#
							and Pcodigo = 80
						</cfquery>
					</cfif>
					<cfset SalarioPromedioLiq = SalarioPromedioLiq * rsParametros.Pvalor>
					
					<cfif not lvarMasivo>
						<cfquery datasource="#Session.DSN#">
							delete from #tbl_PagosEmpleado#
						</cfquery>
					</cfif>
				<cfelse>
					<cfset SalarioPromedioLiq = 0>
				</cfif>
		</cfif>
		SalarioPromedioLiq = <cfoutput>#SalarioPromedioLiq#</cfoutput>
		


		<!--- ============================================================== --->
		<!--- Modificaciones hechas por Carlos Elizondo en Importadore Monge --->
		<!--- ============================================================== --->		
		<cfset Saldo_VacacionesM = 0.00>
		<cfset saldo_corriente = 0>
		<!--- Solo si viene la accin se procede a calcular el saldo de vacaciones --->
		<cfif Len(Trim(Arguments.RHAlinea)) NEQ 0 and Arguments.RHAlinea NEQ 0>
			<cfif isdefined("arguments.origen") and origen eq 'DLaboralesEmpleado'>
				<cfquery name="rsFechaLiquidacion" datasource="#session.dsn#">
					select <cf_dbfunction name="dateadd" args="-1,a.DLfvigencia"> as fechaliquidacion
					from DLaboralesEmpleado a
					where a.DLlinea = #Arguments.RHAlinea#
				</cfquery>
			<cfelse>
				<cfquery name="rsFechaLiquidacion" datasource="#session.dsn#">
					select a.DLfvigencia as fechaliquidacion
					from RHAcciones a
					where a.RHAlinea = #Arguments.RHAlinea#
				</cfquery>
			</cfif>
			<!--- Vacaciones Acumuladas --->
			<cfquery name="rsVacaciones" datasource="#Session.DSN#">
				select 	a.DEid, 
						coalesce(a.EVfecha, a.EVfantig) as Antiguedad, 
						coalesce(sum(b.DVEdisfrutados + b.DVEcompensados), 0.00) as Disponibles, 
						coalesce(sum(b.DVEenfermedad), 0.00) as DVEenfermedad
				from EVacacionesEmpleado a
					left outer join DVacacionesEmpleado b
						on a.DEid = b.DEid
						<!--- Se asumen que todas las vacaciones cuenta porque se esta ante una liquidacion
						Se realizan ajustes manuales en caso de que la liquidacion sea anterior a una accion de disfrute de vacaciones --->
				where a.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.DEid#">
				group by a.DEid, coalesce(a.EVfecha, a.EVfantig)
			</cfquery>
            <cfif rsVacaciones.RecordCount and rsFechaLiquidacion.RecordCount GT 0>
				<!--- Regimen de Vacaciones --->
                <cfquery name="rsRegimen" datasource="#session.DSN#">
                    select RVid 
                    from LineaTiempo 
                    where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#"> 
                      and DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.DEid#">
                      and <cfqueryparam cfsqltype="cf_sql_timestamp" value="#rsFechaLiquidacion.fechaliquidacion#"> between LTdesde and LThasta
                </cfquery>
        		<cfif rsRegimen.RecordCount GT 0>
					<!--- Se sustituyo por el clculo de Fecha de Ingreso ya existente --->
                    <cfset vFecha = ListToArray(LSDateFormat(Fecha_Ingreso,'dd/mm/yyyy'),'/')>
                    <!--- objeto date con la fecha de ingreso --->
                    <cfset Lvarfecha_ingreso = Createdate(vFecha[3],vFecha[2],vfecha[1]) >
                    <!--- calcula la cantidad de aos laborados, a partir de su ingreso --->
                    <cfset anno = DateDiff('yyyy', Lvarfecha_ingreso, rsFechaLiquidacion.fechaliquidacion)>
                    <!--- objeto date con la fecha del ltimo corte --->
                    <cfset Lvarfecha_corte = DateAdd('yyyy', anno, Lvarfecha_ingreso)>
                    <!--- calcula la cantidad de meses desde la fecha_corte(dia, mes de ingreso, ao en curso) hasta la fecha de hoy --->
                    <cfset meses = DateDiff('m', Lvarfecha_corte, rsFechaLiquidacion.fechaliquidacion)>
                    
                    <!--- Calcula la cantidad de dias para el siguiente corte que le corresponden segun el regimen de vacaciones y la cantidad de aos laborados --->
                    <cfquery name="rsDias" datasource="#session.DSN#">
                        select coalesce(rv.DRVdias, 0) as DRVdias
                        from DRegimenVacaciones rv 
                        where rv.RVid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsRegimen.RVid#">
                          and rv.DRVcant = ( select coalesce(max(DRVcant),1) 
                                             from DRegimenVacaciones rv2 
                                             where rv2.RVid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsRegimen.RVid#">
                                               and rv2.DRVcant <= <cfqueryparam cfsqltype="cf_sql_float" value="#anno+1#"> )
                    </cfquery>
                    <!--- calcula el saldo corriente de vacaciones --->
                    <cfif rsDias.recordCount GT 0 and Len(Trim(rsDias.DRVdias))>
                        <!---<cfset saldo_corriente = meses>--->
                        <cfset saldo_corriente = (rsDias.DRVdias*meses)/12>
                    </cfif>
            
                    <cfif Len(Trim(rsVacaciones.Disponibles))>
                        <cfset Saldo_VacacionesM = rsVacaciones.Disponibles + saldo_corriente>
                    <cfelse>
                        <cfset Saldo_VacacionesM = saldo_corriente >
                    </cfif>
             	</cfif>
             </cfif>
		</cfif>
		Saldo_VacacionesM = <cfoutput>#Saldo_VacacionesM#</cfoutput>
		<!--- ===================================================================== --->
		<!--- Modificaciones hechas por Carlos Elizondo en Importadore Monge - FIN 	--->
		<!--- =====================================================================	--->	

		<!--- nuevo --->
		<cfquery name="data" datasource="#session.dsn#">
			select RHTcodigo, coalesce ((	select sum( a.PEmontores )
											from HPagosEmpleado a,  RHTipoAccion b
											where a.RHTid = ta.RHTid
											  and a.DEid = #DEid#
											  and a.RHTid = b.RHTid
											  and b.Ecodigo =  #Ecodigo#
												<cfif Len(Arguments.CIrango) And (Arguments.CIrango NEQ 0)>
													<!--- danim,9/nov/2005. se toma solo la fecha hasta, gracias a sugerencia de JC Gutierrez
													no se modifica el otro caso para no afectar las formulas que ya existen, donde el CIrango es NULL --->
													and a.PEhasta >= <cfqueryparam cfsqltype="cf_sql_date" value="#Fecha_Salarios#">
													and a.PEhasta <  <cfqueryparam cfsqltype="cf_sql_date" value="#Fecha_Salarios_Final#">
												<cfelse>
													and a.PEhasta >= <cfqueryparam cfsqltype="cf_sql_date" value="#Fecha_Salarios#">
													and a.PEdesde <= <cfqueryparam cfsqltype="cf_sql_date" value="#Fecha_Salarios_Final#">
												</cfif>
											) ,0) as salario
		from RHTipoAccion ta
		where ta.Ecodigo = #Ecodigo#
		</cfquery>
		
		<cfoutput query="data">
		SumaPagosAccion_#RHTcodigo# = #salario#
		</cfoutput>
		
		<!--- 	Desarrollo Baroda-DHC --->
		<!--- 	Variables para manejar Dias de Enfermedad en la empresa 
				Por defecto las variables llevan valor de cero, pero si la empresa usa dias de enfermedad, se hacen los calculos. --->
		<cfset SaldoDiasEnfermedad 	 = 0 >
		<cfset DiasEnfermedadRebajar = 0 >
		<cfquery name="rs_p960" datasource="#session.DSN#">
			select Pvalor
			from RHParametros
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			  and Pcodigo = 960
		</cfquery>

		<cfif trim(rs_p960.Pvalor) eq 1>
			<cfquery name="rs_calcSaldoDiasEnf" datasource="#session.DSN#">
				select DEid, sum(DVEenfermedad) as dias
				from DVacacionesEmpleado
				where DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.DEid#">
				group by DEid				
			</cfquery>
			<cfif len(trim(rs_calcSaldoDiasEnf.dias)) >
				<cfset SaldoDiasEnfermedad = rs_calcSaldoDiasEnf.dias >
			</cfif>

			<cfif isdefined("arguments.origen") and origen eq 'DLaboralesEmpleado'>
				<cfquery name="rs_accionDiasEnfRebajar" datasource="#session.dsn#">
					select 0 as dias
					from DLaboralesEmpleado a
					where a.DLlinea = #Arguments.RHAlinea#
				</cfquery>
			<cfelse>
				<cfquery name="rs_accionDiasEnfRebajar" datasource="#session.dsn#">
					select a.RHAdiasenfermedad as dias
					from RHAcciones a
					where a.RHAlinea = #Arguments.RHAlinea#
				</cfquery>
			</cfif>
			<cfif len(trim(rs_accionDiasEnfRebajar.dias)) >
				<cfset DiasEnfermedadRebajar = rs_accionDiasEnfRebajar.dias >
			</cfif>
		</cfif>
		
		SaldoDiasEnfermedad = <cfoutput>#SaldoDiasEnfermedad#</cfoutput>
		DiasEnfermedadRebajar = <cfoutput>#DiasEnfermedadRebajar#</cfoutput>

		<!--- 	Desarrollo Baroda-DHC --->
		<!--- 	Variables para manejar Dias laborados y No laborados de un empleado 
				Por defecto las variables llevan valor de cero --->
                
		<cfset diasNoLaborados   = 0 >
		<cfset diasNominaPagados = 0 >
		
		<!--- ======================================= --->
		<!--- VARIABLE diasNoLaborados inicio --->
		<!--- ======================================= --->
		<cfquery name="rs_diasnolaborados" datasource="#session.DSN#">
			select 	pe.DEid, sum(pe.PEcantdias) as dias
			from HPagosEmpleado pe
			inner join RHTipoAccion ta
                on ta.RHTid=pe.RHTid
                and ta.RHTcomportam = 5 <!---Incapacidad--->
			where pe.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.DEid#">
				and pe.PEtiporeg=0
				and pe.PEhasta >= <cfqueryparam cfsqltype="cf_sql_date" value="#Fecha_Salarios#">
				and pe.PEdesde <= <cfqueryparam cfsqltype="cf_sql_date" value="#Fecha_Salarios_Final#">
			group by pe.DEid
		</cfquery>
		
		<cfif len(trim(rs_diasnolaborados.dias))>
			<cfset diasNoLaborados = diasNoLaborados + rs_diasnolaborados.dias >
		</cfif>
		
		<cfquery name="rs_diasnolaborados" datasource="#session.DSN#">
			select 	pe.DEid, sum(pe.PEcantdias) as dias
				from HPagosEmpleado pe
                inner join RHTipoAccion ta
                    on ta.RHTid=pe.RHTid
                    and ta.RHTcomportam = 4 <!---Permiso--->
                    and ta.RHTpaga = 0 
                where pe.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.DEid#">
                    and pe.PEtiporeg=0
                    and pe.PEhasta >= <cfqueryparam cfsqltype="cf_sql_date" value="#Fecha_Salarios#">
                    and pe.PEdesde <= <cfqueryparam cfsqltype="cf_sql_date" value="#Fecha_Salarios_Final#">
                group by pe.DEid
		</cfquery>
		<cfif len(trim(rs_diasnolaborados.dias))>
			<cfset diasNoLaborados = diasNoLaborados + rs_diasnolaborados.dias >
		</cfif>

		<cfquery name="rs_diasnolaborados" datasource="#session.DSN#">
			select 
				a.DEid, 
				sum(abs(<cf_dbfunction name="datediff" args="a.DLfvigencia, a.DLffin,dd">)) as dias
			from 	DLaboralesEmpleado a
			inner join  RHTipoAccion x
				on x.RHTid = a.RHTid
				and x.RHTcomportam = 4	<!---Permiso--->
			left outer join RHSaldoPagosExceso pe
				on a.DLlinea = pe.DLlinea
				and pe.RHSPEanulado = 0
			where a.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.DEid#">
			and 
			(
			(a.DLfvigencia between  <cfqueryparam cfsqltype="cf_sql_date" value="#Fecha_Salarios#"> and  <cfqueryparam cfsqltype="cf_sql_date" value="#Fecha_Salarios_Final#">)
			or
			(a.DLffin between  <cfqueryparam cfsqltype="cf_sql_date" value="#Fecha_Salarios#"> and  <cfqueryparam cfsqltype="cf_sql_date" value="#Fecha_Salarios_Final#">)
			)
			group by a.DEid
		</cfquery>
		<cfif len(trim(rs_diasnolaborados.dias))>
			<cfset diasNoLaborados = diasNoLaborados + rs_diasnolaborados.dias >
		</cfif>

		<cfquery name="rs_diasnolaborados" datasource="#session.DSN#">
			select 
				a.DEid, 
				sum(abs(<cf_dbfunction name="datediff" args="a.DLfvigencia, a.DLffin,dd">)) as dias

			from 	DLaboralesEmpleado a
			inner join  RHTipoAccion x
				on x.RHTid = a.RHTid
				and x.RHTcomportam = 5	<!---Incapacidad--->
			left outer join RHSaldoPagosExceso pe
				on a.DLlinea = pe.DLlinea
				and pe.RHSPEanulado = 0
			where a.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.DEid#">
			and 
			(
			(a.DLfvigencia between  <cfqueryparam cfsqltype="cf_sql_date" value="#Fecha_Salarios#"> and  <cfqueryparam cfsqltype="cf_sql_date" value="#Fecha_Salarios_Final#">)
			or
			(a.DLffin between  <cfqueryparam cfsqltype="cf_sql_date" value="#Fecha_Salarios#"> and  <cfqueryparam cfsqltype="cf_sql_date" value="#Fecha_Salarios_Final#">)
			)
			group by a.DEid
		</cfquery>
		<cfif len(trim(rs_diasnolaborados.dias))>
			<cfset diasNoLaborados = diasNoLaborados + rs_diasnolaborados.dias >
		</cfif>
		diasNoLaborados = <cfoutput>#diasNoLaborados#</cfoutput>
		
		<!--- ======================================= --->
		<!--- VARIABLE diasNominaPagados inicio --->
		<!--- ======================================= --->
		<cfquery name="rs_diaspagados" datasource="#session.DSN#">
			select 	pe.DEid, sum(pe.PEcantdias) as dias
			from HPagosEmpleado pe
                where pe.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.DEid#">
	                and pe.PEtiporeg=0
                    and pe.PEhasta >= <cfqueryparam cfsqltype="cf_sql_date" value="#Fecha_Salarios#">
                    and pe.PEdesde <= <cfqueryparam cfsqltype="cf_sql_date" value="#Fecha_Salarios_Final#">
                group by pe.DEid
		</cfquery>
		<cfif len(trim(rs_diaspagados.dias))>
			<cfset diasNominaPagados = diasNominaPagados + rs_diaspagados.dias >
		</cfif>
		diasNominaPagados = <cfoutput>#diasNominaPagados#</cfoutput>
        
        
        <!--- ======================================= --->
		<!--- ljimenez VARIABLE diasNominaProcesoPagados inicio --->
		<!--- ======================================= --->
        
		<cfset diasNominaProcesoPagados = 0 >
        
		<cfquery name="rs_diaspagadosproceso" datasource="#session.DSN#">
			select 	pe.DEid, sum(pe.PEcantdias) as dias
			from PagosEmpleado pe
                where pe.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.DEid#">
	                and pe.PEtiporeg=0
                    and pe.PEhasta <= <cfqueryparam cfsqltype="cf_sql_date" value="#Fecha2_Accion#">
                    and pe.PEdesde >= <cfqueryparam cfsqltype="cf_sql_date" value="#Fecha1_Accion#">
                group by pe.DEid
		</cfquery>
		<cfif len(trim(rs_diaspagadosproceso.dias))>
			<cfset diasNominaProcesoPagados = diasNominaProcesoPagados + rs_diaspagadosproceso.dias >
		</cfif>
		diasNominaProcesoPagados = <cfoutput>#diasNominaProcesoPagados#</cfoutput>
        
        <!--- ======================================= --->
		<!--- VARIABLE diasfaltanomina inicio ljimenez 20110705(MEX)--->
		<!--- ======================================= --->
        <cfset diasfaltanomina = 0>
        <cfquery name="rs_diasfaltanominas" datasource="#session.DSN#">
			select 	pe.DEid, sum(pe.PEcantdias) as dias
				from HPagosEmpleado pe
                inner join RHTipoAccion ta
                    on ta.RHTid=pe.RHTid
                    and ta.RHTcomportam = 13<!---Faltas--->
                    and ta.RHTpaga = 0 
                where pe.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.DEid#">
                    and pe.PEtiporeg=0
                    and pe.PEhasta >= <cfqueryparam cfsqltype="cf_sql_date" value="#Fecha_Salarios#">
                    and pe.PEdesde <= <cfqueryparam cfsqltype="cf_sql_date" value="#Fecha_Salarios_Final#">
                group by pe.DEid
		</cfquery>
<!---
      	<cfquery name="rsFechaNominaFalta" datasource="#session.DSN#">
            select t.CPcodigo, CPdesde, CPhasta, l.DEid
                from LineaTiempo l
                    inner join CalendarioPagos t
                    on l.Tcodigo = t.Tcodigo
                    and t.CPtipo = 0
                where l.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
                    and l.DEid =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.DEid#">
                    and l.Ecodigo = t.Ecodigo
                    and  <cfqueryparam cfsqltype="cf_sql_date" value="#Fecha_Salarios_Final#"> between  l.LTdesde and l.LThasta
                    and <cfqueryparam cfsqltype="cf_sql_date" value="#Fecha_Salarios_Final#"> between  t.CPdesde and t.CPhasta
		</cfquery>
        <cfif rsFechaNominaFalta.RecordCount NEQ 0>
            <cfquery name="rs_diasfaltanominas" datasource="#session.DSN#">
                select 	lt.DEid, coalesce(sum(<cf_dbfunction name="datediff" args="LTdesde,LThasta,DD,true"> + 1 ),0) as dias 
                from LineaTiempo lt
                inner join RHTipoAccion ta
                    on lt.RHTid = ta.RHTid
                    and lt.Ecodigo = ta.Ecodigo
                    and ta.RHTcomportam = 13 <!---falta--->
                where lt.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.DEid#">
                    and lt.LTdesde >= <cfqueryparam cfsqltype="cf_sql_date" value="#rsFechaNominaFalta.CPdesde#">
                    and lt.LThasta <= <cfqueryparam cfsqltype="cf_sql_date" value="#rsFechaNominaFalta.CPhasta#">
                    and lt.Ecodigo =  <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
                group by lt.DEid
            </cfquery>
        </cfif>
--->		
		<cfif isdefined('rs_diasfaltanominas') and rs_diasfaltanominas.RecordCount NEQ 0>
			<cfset diasfaltanomina = diasfaltanomina + rs_diasfaltanominas.dias >
		</cfif>

		diasfaltanomina = <cfoutput>#diasfaltanomina#</cfoutput>
        
        <!--- ======================================= --->
		<!--- VARIABLE DiasFaltaNProceso inicio ljimenez 20120124(MEX)--->
        <!--- Nominas en proceso--->
		<!--- ======================================= --->
        
        <cfset diasfaltanproceso = 0>
        <cfquery name="rs_diasfaltanominasproceso" datasource="#session.DSN#">
            select 	coalesce(sum(<cf_dbfunction name="datediff" args="lt.LTdesde,lt.LThasta,DD,true"> + 1 ),0) as dias
                from LineaTiempo lt
                inner join RHTipoAccion ta
                    on ta.RHTid=lt.RHTid
                    and ta.RHTcomportam in (13) <!---Faltas--->
                    and ta.RHTpaga = 1
                    and ta.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
                where lt.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.DEid#">
                    and lt.LThasta >=  (select min(b.CPdesde)
										from LineaTiempo a
										inner join CalendarioPagos b 
										on a.Ecodigo = b.Ecodigo
										and a.Tcodigo = b.Tcodigo
										and CPfcalculo is null
										where  DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.DEid#">
										and <cfqueryparam cfsqltype="cf_sql_date" value="#Fecha1_Accion#"> between a.LTdesde and a.LThasta
										)					
                    and lt.LTdesde <= <cfqueryparam cfsqltype="cf_sql_date" value="#Fecha2_Accion#">
               group by lt.DEid
		</cfquery>
		
		
		
		
		
                          
		<cfif isdefined('rs_diasfaltanominasproceso') and rs_diasfaltanominasproceso.RecordCount NEQ 0>
			<cfset diasfaltanproceso = diasfaltanproceso + rs_diasfaltanominasproceso.dias >
		</cfif>

		diasfaltanproceso = <cfoutput>#diasfaltanproceso#</cfoutput>
		
		<!--- ======================================= --->
		<!--- VARIABLE DiasIncapNProceso inicio ljimenez 20120124(MEX)--->
        <!--- Nominas en proceso--->
		<!--- ======================================= --->
        
        <cfset diasincapnproceso = 0>
        <cfset Fecha1_Accion = DateFormat(Fecha1_Accion,'yyyy-MM-dd')><!--- SML modificacion para calculo de nomina de aguinaldo--->
        <cfset Fecha2_Accion = DateFormat(Fecha2_Accion,'yyyy-MM-dd')><!--- SML modificacion para calculo de nomina de aguinaldo--->
        <cfquery name="rs_diasincapnominasproceso" datasource="#session.DSN#">
		
		 select 
                case when lt.LTdesde > <cfqueryparam cfsqltype="cf_sql_date" value="#Fecha1_Accion#"> then 
                		case when lt.LThasta > <cfqueryparam cfsqltype="cf_sql_date" value="#Fecha2_Accion#"> then 
                                coalesce(sum(<cf_dbfunction name="datediff" args="lt.LTdesde, #Fecha2_Accion#,DD,true"> + 1 ),0)
                                <!---<cfqueryparam cfsqltype="cf_sql_date" value="#Fecha2_Accion#">--->
                             when lt.LThasta <= <cfqueryparam cfsqltype="cf_sql_date" value="#Fecha2_Accion#"> then 
                                coalesce(sum(<cf_dbfunction name="datediff" args="lt.LTdesde,lt.LThasta,DD,true"> + 1 ),0)
                                <!---lt.LThasta--->
                        end
                        <!---lt.LTdesde --->
                    else 
                    	case when lt.LThasta > <cfqueryparam cfsqltype="cf_sql_date" value="#Fecha2_Accion#"> then 
                                coalesce(sum(<cf_dbfunction name="datediff" args=" #Fecha1_Accion#,#Fecha2_Accion#,DD,true"> + 1 ),0)
                                <!---<cfqueryparam cfsqltype="cf_sql_date" value="#Fecha2_Accion#">--->
                             when lt.LThasta <= <cfqueryparam cfsqltype="cf_sql_date" value="#Fecha2_Accion#"> then 
                                coalesce(sum(<cf_dbfunction name="datediff" args=" #Fecha1_Accion#,lt.LThasta,DD,true"> + 1 ),0)
                                <!---lt.LThasta--->
                        end
                       <!--- <cfqueryparam cfsqltype="cf_sql_date" value="#Fecha1_Accion#">--->
                end as dias
                from LineaTiempo lt
                inner join RHTipoAccion ta
                    on ta.RHTid=lt.RHTid
                    and ta.RHTcomportam in (5) <!---Incapacidad--->
                    and ta.RHTpaga = 0
                    and ta.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
                where lt.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.DEid#">
                    and lt.LThasta >= (select min(b.CPdesde)
										from LineaTiempo a
										inner join CalendarioPagos b 
										on a.Ecodigo = b.Ecodigo
										and a.Tcodigo = b.Tcodigo
										and CPfcalculo is null
										where  DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.DEid#">
										and <cfqueryparam cfsqltype="cf_sql_date" value="#Fecha1_Accion#"> between a.LTdesde and a.LThasta
										)
                    and lt.LTdesde <= <cfqueryparam cfsqltype="cf_sql_date" value="#Fecha2_Accion#">
		        group by lt.DEid, lt.LTdesde, lt.LThasta   
		
<!---			select 	coalesce(sum(<cf_dbfunction name="datediff" args="lt.LTdesde,lt.LThasta,DD,true"> + 1 ),0) as dias
                from LineaTiempo lt
                inner join RHTipoAccion ta
                    on ta.RHTid=lt.RHTid
                    and ta.RHTcomportam in (5) <!---Incapacidad--->
                    and ta.RHTpaga = 0
                    and ta.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
                where lt.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.DEid#">
                    and lt.LThasta >= <cfqueryparam cfsqltype="cf_sql_date" value="#Fecha1_Accion#">
                    and lt.LTdesde <= <cfqueryparam cfsqltype="cf_sql_date" value="#Fecha2_Accion#">
                group by lt.DEid --->
		</cfquery>
		
		<cfquery name="rs_diasincapnominasproceso" dbtype="query">
        	select sum(dias) as dias
            from rs_diasincapnominasproceso
		</cfquery>
        
		
		<cfif isdefined('rs_diasincapnominasproceso') and rs_diasincapnominasproceso.RecordCount NEQ 0>
			<cfset diasincapnproceso = diasincapnproceso + rs_diasincapnominasproceso.dias >
		</cfif>
		diasincapnproceso = <cfoutput>#diasincapnproceso#</cfoutput>
        
		<!--- ======================================= --->
		<!--- VARIABLE DiasVacNProceso inicio ljimenez 20120124(MEX)--->
        <!--- Nominas en proceso--->
		<!--- ======================================= --->
		
       <cfset diasvacnproceso = 0>
        
<!---
        <cfset Fechafin = #LSDateformat(Fecha2_Accion,'dd/mm/yyyy')#>
        <cfset Fechaini = #LSDateformat(Fecha1_Accion,'dd/mm/yyyy')#>
      
        
        Fecha2_AccionFecha2_AccionFecha2_AccionFecha2_AccionFecha2_AccionFecha2_AccionFecha2_AccionFecha2_Accion
        <cfdump var = "#Fecha2_Accion#">
        
        
        <cfdump var = "#Fechaini#">
        <cfdump var = "#Fechafin#">
        
 --->         
       <!--- <cfquery name="rs_diasvacnominasproceso" datasource="#session.DSN#">
        
        select 
             
         case when lt.LTdesde >= <cfqueryparam cfsqltype="cf_sql_date" value="#Fecha1_Accion#"> then 
                		case when lt.LThasta > <cfqueryparam cfsqltype="cf_sql_date" value="#Fecha2_Accion#"> then 
                                coalesce(sum(<cf_dbfunction name="datediff" args="lt.LTdesde, #Fecha2_Accion#,DD,true"> + 1 ),0)
                               
                                
                             when lt.LThasta <= <cfqueryparam cfsqltype="cf_sql_date" value="#Fecha2_Accion#"> then 
                                coalesce(sum(<cf_dbfunction name="datediff" args="lt.LTdesde,lt.LThasta,DD,true"> + 1 ),0)
                               
                        end
                    else 
	   					case when lt.LThasta = <cfqueryparam cfsqltype="cf_sql_date" value="#Fecha1_Accion#"> then coalesce(sum(datediff(dd, <cfqueryparam cfsqltype="cf_sql_date" value="#Fecha1_Accion#">, <cfqueryparam cfsqltype="cf_sql_date" value="#Fecha1_Accion#">) + 1 ),0)
                    else 
                    	case when lt.LThasta <= <cfqueryparam cfsqltype="cf_sql_date" value="#Fecha2_Accion#"> then 
                                coalesce(sum(<cf_dbfunction name="datediff" args=" #Fecha1_Accion#,#Fecha2_Accion#,DD,true"> + 1 ),0)
                               
                             when lt.LThasta <= <cfqueryparam cfsqltype="cf_sql_date" value="#Fecha2_Accion#"> then 
                                coalesce(sum(<cf_dbfunction name="datediff" args=" #Fecha1_Accion#,lt.LThasta,DD,true"> + 1 ),0)
                                
                        end
                     end   
                end as dias
                
             
                from LineaTiempo lt
                inner join RHTipoAccion ta
                    on ta.RHTid=lt.RHTid
                    and ta.RHTcomportam in (3) <!---Vacaciones--->
                    and ta.RHTpaga = 0
                    and ta.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
                where lt.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.DEid#">
                    and lt.LThasta >= <!---<cfqueryparam cfsqltype="cf_sql_date" value="#Fecha1_Accion#">---> (select min(b.CPdesde)
										from LineaTiempo a
										inner join CalendarioPagos b 
										on a.Ecodigo = b.Ecodigo
										and a.Tcodigo = b.Tcodigo
										and CPfcalculo is null
										where  DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.DEid#">
										and <cfqueryparam cfsqltype="cf_sql_date" value="#Fecha1_Accion#"> between a.LTdesde and a.LThasta
										)
                    and lt.LTdesde <= <cfqueryparam cfsqltype="cf_sql_date" value="#Fecha2_Accion#">
                    
		        group by lt.DEid, lt.LTdesde, lt.LThasta
         </cfquery>  ---> 
         
         <cfquery name="rs_diasvacnominasproceso" datasource="#session.DSN#"> <!---SML. Modificacion para considerar los dias para PM--->
         select case when lt.LTdesde > <cfqueryparam cfsqltype="cf_sql_date" value="#Fecha1_Accion#">  
         			 then case when lt.LThasta >  <cfqueryparam cfsqltype="cf_sql_date" value="#Fecha2_Accion#"> 
                               then coalesce(sum(datediff(dd, lt.LTdesde, <cfqueryparam cfsqltype="cf_sql_date" value="#Fecha2_Accion#">)+1),0) 
					           when lt.LThasta <= <cfqueryparam cfsqltype="cf_sql_date" value="#Fecha2_Accion#"> 
                               then coalesce(sum(DATEDIFF(dd, LTdesde,<cfqueryparam cfsqltype="cf_sql_date" value="#Fecha2_Accion#">)),0) 
				          end 
					 when lt.LTdesde = <cfqueryparam cfsqltype="cf_sql_date" value="#Fecha1_Accion#">  
                     then case when lt.LThasta > <cfqueryparam cfsqltype="cf_sql_date" value="#Fecha2_Accion#"> 
                               then coalesce(sum(datediff(dd, lt.LTdesde, <cfqueryparam cfsqltype="cf_sql_date" value="#Fecha2_Accion#">)+ 1),0) 
							   when lt.LThasta <= <cfqueryparam cfsqltype="cf_sql_date" value="#Fecha2_Accion#"> 
                               then coalesce(sum(datediff(dd, lt.LTdesde, lt.LThasta) + 1 ),0) 
				          end 
				    when lt.LThasta = <cfqueryparam cfsqltype="cf_sql_date" value="#Fecha1_Accion#">  
                    then coalesce(sum(datediff(dd, <cfqueryparam cfsqltype="cf_sql_date" value="#Fecha1_Accion#">, <cfqueryparam cfsqltype="cf_sql_date" value="#Fecha1_Accion#">) + 1 ),0)
				    when lt.LThasta > <cfqueryparam cfsqltype="cf_sql_date" value="#Fecha2_Accion#"> 
                    then coalesce(sum(datediff(dd, <cfqueryparam cfsqltype="cf_sql_date" value="#Fecha1_Accion#"> , <cfqueryparam cfsqltype="cf_sql_date" value="#Fecha2_Accion#">) + 1 ),0)
				    when lt.LThasta <= <cfqueryparam cfsqltype="cf_sql_date" value="#Fecha2_Accion#"> 
                    then coalesce(sum(datediff(dd, <cfqueryparam cfsqltype="cf_sql_date" value="#Fecha1_Accion#"> , lt.LTdesde)),0) 
	   		  end as Dias
		from LineaTiempo lt inner join RHTipoAccion ta on ta.RHTid=lt.RHTid and ta.RHTcomportam in (3) 
	 		and ta.RHTpaga = 0 and ta.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		where lt.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.DEid#">
	 		and lt.LThasta >= (select min(b.CPdesde) 
						from LineaTiempo a inner join CalendarioPagos b on a.Ecodigo = b.Ecodigo 
						and a.Tcodigo = b.Tcodigo and CPfcalculo is null 
						where DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.DEid#">) 
			and lt.LTdesde <= <cfqueryparam cfsqltype="cf_sql_date" value="#Fecha2_Accion#">
			group by lt.DEid, lt.LTdesde, lt.LThasta 
         </cfquery>
         
      

         
         
   <!---     
        
      
        <cfquery name="rs_diasvacnominasproceso" datasource="#session.DSN#">
        
        select lt.*
             
        <!---   case when lt.LTdesde > <cfqueryparam cfsqltype="cf_sql_date" value="#Fecha1_Accion#"> then 
                		case when lt.LThasta > <cfqueryparam cfsqltype="cf_sql_date" value="#Fecha2_Accion#"> then 
                                coalesce(sum(<cf_dbfunction name="datediff" args="lt.LTdesde, #Fechafin#,DD,true"> + 1 ),0)
                                
                             when lt.LThasta <= <cfqueryparam cfsqltype="cf_sql_date" value="#Fecha2_Accion#"> then 
                                coalesce(sum(<cf_dbfunction name="datediff" args="lt.LTdesde,lt.LThasta,DD,true"> + 1 ),0)
                               
                        end
                        
                    else 
                    	case when lt.LThasta > <cfqueryparam cfsqltype="cf_sql_date" value="#Fecha2_Accion#"> then 
                                coalesce(sum(<cf_dbfunction name="datediff" args=" #Fechaini#,#Fechafin#,DD,true"> + 1 ),0)
                               
                             when lt.LThasta <= <cfqueryparam cfsqltype="cf_sql_date" value="#Fecha2_Accion#"> then 
                                coalesce(sum(<cf_dbfunction name="datediff" args=" #Fechaini#,lt.LThasta,DD,true"> + 1 ),0)
                                
                        end
                       
                end as dias--->
                
             
                from LineaTiempo lt
                inner join RHTipoAccion ta
                    on ta.RHTid=lt.RHTid
                    and ta.RHTcomportam in (3) <!---Vacaciones--->
                    and ta.RHTpaga = 0
                    and ta.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
                where lt.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.DEid#">
                    and lt.LThasta >= <cfqueryparam cfsqltype="cf_sql_date" value="#Fecha1_Accion#">
                    and lt.LTdesde <= <cfqueryparam cfsqltype="cf_sql_date" value="#Fecha2_Accion#">
                    
		        --group by lt.DEid, lt.LTdesde, lt.LThasta
         </cfquery>   
         
         <cf_dump var="#rs_diasvacnominasproceso#">
         
      --->   
         
		<cfif isdefined('rs_diasvacnominasproceso') and rs_diasvacnominasproceso.RecordCount NEQ 0>
        	<cfloop query="rs_diasvacnominasproceso"><!--- SML modificacion para considerar las vacaciones por separado--->
			<cfset diasvacnproceso = diasvacnproceso + rs_diasvacnominasproceso.dias >
            </cfloop>
		</cfif>
        <!---<cfthrow message="#diasvacnproceso#">--->
		diasvacnproceso = <cfoutput>#diasvacnproceso#</cfoutput>	
        
		

		<!--- ============================================================================= --->
		<!--- VARIABLES: 	HorasSemanalJornada, DiasSemanalJornada, HorasDiariasJornada
							Se calculan a partir de la fech ade rige de la accion		 	--->
		<!--- ============================================================================= --->
		<cfset HorasSemanalJornada = 0 >
		<cfset DiasSemanalJornada  = 0 >
		<cfset HorasDiariasJornada = 0 >
		<cfquery name="rs_datosjornada" datasource="#session.DSN#">
			select RHJhorasemanal, RHJdiassemanal, RHJhoradiaria
			from RHJornadas j
			where j.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
				and 	j.RHJid = (	select distinct lt.RHJid
							from LineaTiempo lt
							where lt.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.DEid#">
							and lt.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
							and <cfqueryparam cfsqltype="cf_sql_date" value="#arguments.fecha1_Accion#"> between lt.LTdesde and lt.LThasta )
		</cfquery>
		<cfif len(trim(rs_datosjornada.RHJhorasemanal)) >
			<cfset HorasSemanalJornada = rs_datosjornada.RHJhorasemanal >
		</cfif>
		<cfif len(trim(rs_datosjornada.RHJdiassemanal)) >
			<cfset DiasSemanalJornada = rs_datosjornada.RHJdiassemanal >
		</cfif>
		<cfif len(trim(rs_datosjornada.RHJhoradiaria)) >
			<cfset HorasDiariasJornada = rs_datosjornada.RHJhoradiaria >
		</cfif>
		HorasSemanalJornada = <cfoutput>#HorasSemanalJornada#</cfoutput>
		DiasSemanalJornada  = <cfoutput>#DiasSemanalJornada#</cfoutput>
		HorasDiariasJornada = <cfoutput>#HorasDiariasJornada#</cfoutput>

	</cfsavecontent>

