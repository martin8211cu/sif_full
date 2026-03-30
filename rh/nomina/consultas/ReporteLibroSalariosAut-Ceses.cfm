	<!--- Tabla temporal de resultados --->
	<cf_dbtemp name="salidaCese" returnvariable="salidaCese">
    	<cf_dbtempcol name="DLlinea"   		type="numeric"  mandatory="yes">
        <cf_dbtempcol name="DEid"   		type="int"      mandatory="yes">
        <cf_dbtempcol name="CPcodigo"  		type="char(12)" mandatory="no">
        <cf_dbtempcol name="CPtipo"  		type="int" 		mandatory="no">
        <cf_dbtempcol name="RCdesde" 		type="datetime" mandatory="no">
		<cf_dbtempcol name="RChasta" 		type="datetime" mandatory="no">
		<cf_dbtempcol name="ExtrasS" 		type="money"    mandatory="no">
		<cf_dbtempcol name="ExtrasD" 		type="money"    mandatory="no">
		<cf_dbtempcol name="Aguinaldo" 		type="money"    mandatory="no">
		<cf_dbtempcol name="Vacaciones"		type="money"   	mandatory="no">
		<cf_dbtempcol name="Indemniza" 		type="money"    mandatory="no">
		<cf_dbtempcol name="Otros" 			type="money"    mandatory="no">
		<cf_dbtempcol name="Comisiones" 	type="money"    mandatory="no">
		<cf_dbtempcol name="Asoc" 			type="money"    mandatory="no">
		<cf_dbtempcol name="ISR" 			type="money"    mandatory="no">
		<cf_dbtempcol name="BanTrab" 		type="money" 	mandatory="no">
		<cf_dbtempcol name="OtrosDesc" 		type="money" 	mandatory="no">
		<cf_dbtempkey cols="DEid,DLlinea">
	</cf_dbtemp> 


<!--- VERIFICA SI LAS PERSONAS DEL REPORTE TIENEN ALGUN CESE DENTRO DE LAS FECHAS DEFINIDAS --->
	<cfquery name="rsListaEmpleado" datasource="#session.DSN#">
		select distinct DEid as DEid
		from #salida#
	</cfquery>
	<cfif rsListaEmpleado.RecordCount>
	<!--- VERIFICA SI HAY ACCIONES DE CESE  --->
		<cfquery name="rsVerifCese" datasource="#session.DSN#">
			insert into #salidaCese#(DLlinea, DEid, RCdesde, RChasta, CPcodigo,CPtipo)
			select b.DLlinea,b.DEid,DLfvigencia,DLffin, DLfvigencia,0
			from DLaboralesEmpleado b
			inner join RHTipoAccion c
				on c.RHTid = b.RHTid
				and c.Ecodigo = b.Ecodigo
				and c.RHTcomportam = 2
			where b.DEid in (#ValueList(rsListaEmpleado.DEid)#)
				and DLfvigencia between <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(url.Fdesde)#">
						and <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(url.Fhasta)#">
		</cfquery>
		
		<!--- CALCULO DE LAS HORAS EXTRA (TOTAL HORAS EXTRA A Y HORAS EXTRA B) --->
		<!--- HORAS EXTRA A --->
		<!--- SUMA DE TODOS LOS MONTOS PAGADOS POR INCIDENCIAS INDICADAS PARA LA COLUMNA EXTRASS
				EN LA CONFIGURACION DEL REPORTE QUE -- NO -- SEAN FERIADOS NI DIAS LIBRES  --->
		<cfquery name="rsMontoExtraA" datasource="#session.DSN#">
			update #salidaCese#
			set ExtrasS =  coalesce((
									select sum(importe)
									from RHLiquidacionPersonal lp
									inner join RHLiqIngresos li
										on li.DLlinea = lp.DLlinea
										and li.CIid in (select distinct a.CIid
												from RHReportesNomina c
													inner join RHColumnasReporte b
																inner join RHConceptosColumna a
																on a.RHCRPTid = b.RHCRPTid
														 on b.RHRPTNid = c.RHRPTNid
														and b.RHCRPTcodigo = 'HorasExtraA'
												where c.RHRPTNcodigo = 'LSA'
												  and c.Ecodigo = #session.Ecodigo#)
									where lp.DLlinea = #salidaCese#.DLlinea), 0.00)
		</cfquery>
		<!--- HORAS EXTRA B --->
		<!--- SUMA DE TODOS LOS MONTOS PAGADOS POR INCIDENCIAS INDICADAS PARA LA COLUMNA EXTRASS
				EN LA CONFIGURACION DEL REPORTE QUE SEAN FERIADOS NI DIAS LIBRES  --->
		<cfquery name="rsMontoExtraB" datasource="#session.DSN#">
			update #salidaCese#
			set ExtrasD = coalesce((
									select sum(importe)
									from RHLiquidacionPersonal lp
									inner join RHLiqIngresos li
										on li.DLlinea = lp.DLlinea
										and li.CIid in (select distinct a.CIid
												from RHReportesNomina c
													inner join RHColumnasReporte b
																inner join RHConceptosColumna a
																on a.RHCRPTid = b.RHCRPTid
														 on b.RHRPTNid = c.RHRPTNid
														and b.RHCRPTcodigo = 'HorasExtraA'
												where c.RHRPTNcodigo = 'LSA'
												  and c.Ecodigo = #session.Ecodigo#)
									where lp.DLlinea = #salidaCese#.DLlinea), 0.00)
		</cfquery>
		<!--- AGUINALDO --->
		<cfquery name="rsAguinaldo" datasource="#session.DSN#">
			update #salidaCese#
				set Aguinaldo = coalesce((
									select sum(importe)
									from RHLiquidacionPersonal lp
									inner join RHLiqIngresos li
										on li.DLlinea = lp.DLlinea
										and li.CIid in (select distinct a.CIid
												from RHReportesNomina c
													inner join RHColumnasReporte b
																inner join RHConceptosColumna a
																on a.RHCRPTid = b.RHCRPTid
														 on b.RHRPTNid = c.RHRPTNid
														and b.RHCRPTcodigo = 'Aguinaldo'
												where c.RHRPTNcodigo = 'LSA'
												  and c.Ecodigo = #session.Ecodigo#)
									where lp.DLlinea = #salidaCese#.DLlinea), 0.00)
		</cfquery>
		<!--- VACACIONES --->
		<cfquery name="rsVacaciones" datasource="#session.DSN#">
			update #salidaCese#
				set Vacaciones = coalesce((
									select sum(importe)
									from RHLiquidacionPersonal lp
									inner join RHLiqIngresos li
										on li.DLlinea = lp.DLlinea
										and li.CIid in (select distinct a.CIid
												from RHReportesNomina c
													inner join RHColumnasReporte b
																inner join RHConceptosColumna a
																on a.RHCRPTid = b.RHCRPTid
														 on b.RHRPTNid = c.RHRPTNid
														and b.RHCRPTcodigo = 'Vacaciones'
												where c.RHRPTNcodigo = 'LSA'
												  and c.Ecodigo = #session.Ecodigo#)
									where lp.DLlinea = #salidaCese#.DLlinea), 0.00)
		</cfquery>
		
		<!--- INDEMNIZACION --->
		<cfquery name="rsIndemnizacion" datasource="#session.DSN#">
			update #salidaCese#
				set Indemniza = coalesce((
									select sum(importe)
									from RHLiquidacionPersonal lp
									inner join RHLiqIngresos li
										on li.DLlinea = lp.DLlinea
										and li.CIid in (select distinct a.CIid
												from RHReportesNomina c
													inner join RHColumnasReporte b
																inner join RHConceptosColumna a
																on a.RHCRPTid = b.RHCRPTid
														 on b.RHRPTNid = c.RHRPTNid
														and b.RHCRPTcodigo = 'Indemniza'
												where c.RHRPTNcodigo = 'LSA'
												  and c.Ecodigo = #session.Ecodigo#)
									where lp.DLlinea = #salidaCese#.DLlinea), 0.00)
		</cfquery>
		<!--- OTROS --->
		<cfquery name="rsOtros" datasource="#session.DSN#">
			update #salidaCese#
				set Otros = coalesce((
									select sum(importe)
									from RHLiquidacionPersonal lp
									inner join RHLiqIngresos li
										on li.DLlinea = lp.DLlinea
										and li.CIid in (select distinct a.CIid
												from RHReportesNomina c
													inner join RHColumnasReporte b
																inner join RHConceptosColumna a
																on a.RHCRPTid = b.RHCRPTid
														 on b.RHRPTNid = c.RHRPTNid
														and b.RHCRPTcodigo = 'Otros'
												where c.RHRPTNcodigo = 'LSA'
												  and c.Ecodigo = #session.Ecodigo#)
									where lp.DLlinea = #salidaCese#.DLlinea), 0.00)
		</cfquery>
		<!--- COMISIONES --->
		<cfquery name="rsComisiones" datasource="#session.DSN#">
			update #salidaCese#
				set Comisiones = coalesce((
									select sum(importe)
									from RHLiquidacionPersonal lp
									inner join RHLiqIngresos li
										on li.DLlinea = lp.DLlinea
										and li.CIid in (select distinct a.CIid
												from RHReportesNomina c
													inner join RHColumnasReporte b
																inner join RHConceptosColumna a
																on a.RHCRPTid = b.RHCRPTid
														 on b.RHRPTNid = c.RHRPTNid
														and b.RHCRPTcodigo = 'Comisiones'
												where c.RHRPTNcodigo = 'LSA'
												  and c.Ecodigo = #session.Ecodigo#)
									where lp.DLlinea = #salidaCese#.DLlinea), 0.00)
		</cfquery>
		<!--- ASOCIACION SOLIDARISTA --->
		<cfquery name="rsAsoc" datasource="#session.DSN#">
			update #salidaCese#
				set Asoc = coalesce((
									select sum(importe)
									from RHLiquidacionPersonal lp
									inner join RHLiqIngresos li
										on li.DLlinea = lp.DLlinea
										and li.CIid in (select distinct a.CIid
												from RHReportesNomina c
													inner join RHColumnasReporte b
																inner join RHConceptosColumna a
																on a.RHCRPTid = b.RHCRPTid
														 on b.RHRPTNid = c.RHRPTNid
														and b.RHCRPTcodigo = 'Asoc'
												where c.RHRPTNcodigo = 'LSA'
												  and c.Ecodigo = #session.Ecodigo#)
									where lp.DLlinea = #salidaCese#.DLlinea), 0.00)
		</cfquery>
		<!--- ISR --->
		<cfquery name="rsISR" datasource="#session.DSN#">
			update #salidaCese#
				set ISR = coalesce((
									select sum(importe)
									from RHLiquidacionPersonal lp
									inner join RHLiqIngresos li
										on li.DLlinea = lp.DLlinea
										and li.CIid in (select distinct a.CIid
												from RHReportesNomina c
													inner join RHColumnasReporte b
																inner join RHConceptosColumna a
																on a.RHCRPTid = b.RHCRPTid
														 on b.RHRPTNid = c.RHRPTNid
														and b.RHCRPTcodigo = 'ISR'
												where c.RHRPTNcodigo = 'LSA'
												  and c.Ecodigo = #session.Ecodigo#)
									where lp.DLlinea = #salidaCese#.DLlinea), 0.00)
		</cfquery>
		<!--- BANCO DE LOS TRABAJADORES --->
		 <cfquery name="rsBanT" datasource="#session.DSN#">
			update #salidaCese#
				set BanTrab = coalesce((
									select sum(importe)
									from RHLiquidacionPersonal lp
									inner join RHLiqIngresos li
										on li.DLlinea = lp.DLlinea
										and li.CIid in (select distinct a.CIid
												from RHReportesNomina c
													inner join RHColumnasReporte b
																inner join RHConceptosColumna a
																on a.RHCRPTid = b.RHCRPTid
														 on b.RHRPTNid = c.RHRPTNid
														and b.RHCRPTcodigo = 'BanTrab'
												where c.RHRPTNcodigo = 'LSA'
												  and c.Ecodigo = #session.Ecodigo#)
									where lp.DLlinea = #salidaCese#.DLlinea), 0.00)
		</cfquery>
		<!--- OTROS DESCUENTOS --->
		 <cfquery name="rsOtrosDesc" datasource="#session.DSN#">
			update #salidaCese#
				set OtrosDesc = coalesce((
									select sum(importe)
									from RHLiquidacionPersonal lp
									inner join RHLiqIngresos li
										on li.DLlinea = lp.DLlinea
										and li.CIid in (select distinct a.CIid
												from RHReportesNomina c
													inner join RHColumnasReporte b
																inner join RHConceptosColumna a
																on a.RHCRPTid = b.RHCRPTid
														 on b.RHRPTNid = c.RHRPTNid
														and b.RHCRPTcodigo = 'OtrosDesc'
												where c.RHRPTNcodigo = 'LSA'
												  and c.Ecodigo = #session.Ecodigo#)
									where lp.DLlinea = #salidaCese#.DLlinea), 0.00)
		</cfquery>
	</cfif>