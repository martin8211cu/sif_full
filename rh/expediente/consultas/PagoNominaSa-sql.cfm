<!--- Modified with Notepad --->
<cfset Session.DebugInfo = false><!--- Quitar CFSILENT cuando se desea debuguear --->
<!--- Pago de Planilla (S.A.) --->
<cfsilent><!--- Quitar cuando se desea debuguear --->
	<!--- Invoca el portlet de traducción y genera algunas 
	variables utilizadas en este componente. --->
	<cfsavecontent variable="pNavegacion">
		<cfinclude template="/home/menu/pNavegacion.cfm">
	</cfsavecontent>
	<!--- Genera variables de traducción --->
	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		Key="LB_Reporte_de_Planilla_SA"
		Default="#nav__SPdescripcion#"
		returnvariable="LB_Reporte_de_Planilla_SA"/>
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
		Key="LB_Numero_Soc_Sec"
		Default="N&uacute;mero Soc. Sec."
		returnvariable="LB_Numero_Soc_Sec"/>
	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		Key="LB_SUB_TOTAL_SALARIO_NETO_C"
		Default="SUB TOTAL SALARIO NETO C"
		returnvariable="LB_SUB_TOTAL_SALARIO_NETO_C"/>
	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		Key="LB_SUB_TOTAL_SALARIO_NETO_S"
		Default="SUB TOTAL SALARIO NETO $"
		returnvariable="LB_SUB_TOTAL_SALARIO_NETO_S"/>
	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		Key="LB_Vacaciones_mas"
		Default="Vacaciones (+)"
		returnvariable="LB_Vacaciones_mas"/>
	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		Key="LB_Salario_Bruto_C"
		Default="Salario Bruto C"
		returnvariable="LB_Salario_Bruto_C"/>
	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		Key="LB_Salario_Bruto_S"
		Default="Salario Bruto $"
		returnvariable="LB_Salario_Bruto_S"/>
	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		Key="LB_CCSS_9porc_menos"
		Default="CCSS  9% (-)"
		returnvariable="LB_CCSS_9porc_menos"/>
	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		Key="LB_Cargas_Soc_26porc"
		Default="Cargas Soc 26%"
		returnvariable="LB_Cargas_Soc_26porc"/>
	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		Key="LB_Incapacidad_mas"
		Default="Incapacid (+)"
		returnvariable="LB_Incapacidad_mas"/>
	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		Key="LB_Imp_Renta_menos"
		Default="Imp Renta (-)"
		returnvariable="LB_Imp_Renta_menos"/>
	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		Key="LB_Otras_Deducc"
		Default="Otras Deducc"
		returnvariable="LB_Otras_Deducc"/>
	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		Key="LB_Ret_p_embargo_menos"
		Default="Ret p/ embargo (-)"
		returnvariable="LB_Ret_p_embargo_menos"/>
	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		Key="LB_Salario_Neto"
		Default="Salario Neto"
		returnvariable="LB_Salario_Neto"/>
	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		Key="LB_Salario_Neto_S"
		Default="Salario Neto $"
		returnvariable="LB_Salario_Neto_S"/>
	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		Key="LB_Salario_SA"
		Default="Salario SA"
		returnvariable="LB_Salario_SA"/>
	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		Key="LB_Incapacidad_menos"
		Default="Incapacidad (-)"
		returnvariable="LB_Incapacidad_menos"/>
	
	<!--- Tabla temporal de calendario de pagos --->
	<cf_dbtemp name="calendario" returnvariable="calendario">
		<cf_dbtempcol name="RCNid"   type="int"          mandatory="yes">
		<cf_dbtempcol name="RCdesde" type="datetime"     mandatory="no">
		<cf_dbtempcol name="RChasta" type="datetime"     mandatory="no">
		<cf_dbtempcol name="Tcodigo" type="char(5)"      mandatory="no">
		<cf_dbtempcol name="FechaPago" type="datetime"   mandatory="no">
		<cf_dbtempcol name="TipoCambio" type="money"     mandatory="no">
		<cf_dbtempkey cols="RCNid">
	</cf_dbtemp>
	<!--- Tabla temporal de resultados --->
	<cf_dbtemp name="salida" returnvariable="salida">
		<cf_dbtempcol name="DEid"     type="int"          mandatory="yes">
		<cf_dbtempcol name="Nombre"   type="char(40)"     mandatory="no">
		<cf_dbtempcol name="EsNuevo"  type="int"          mandatory="no">
		<cf_dbtempcol name="FIngreso" type="char(10)"     mandatory="no">
		<cf_dbtempcol name="NumeroSS" type="char(50)"     mandatory="no">
		<cf_dbtempcol name="SalarioNeto" type="money"     mandatory="no">
		<cf_dbtempcol name="SalIncidencias" type="money"  mandatory="no">
		<cf_dbtempcol name="SalSA" type="money"           mandatory="no">
		<cf_dbtempcol name="SalIncap" type="money"        mandatory="no">
		<cf_dbtempcol name="RebIncap" type="money"        mandatory="no">
		<cf_dbtempcol name="SubVacaciones" type="money"   mandatory="no">
		<cf_dbtempcol name="SalarioBruto" type="money"    mandatory="no">
		<cf_dbtempcol name="cargasCCSSE" type="money"     mandatory="no">
		<cf_dbtempcol name="cargasCCSSP" type="money"     mandatory="no">
		<cf_dbtempcol name="Renta" type="money"           mandatory="no">
		<cf_dbtempcol name="OtrasDed" type="money"        mandatory="no">
		<cf_dbtempcol name="Embargo" type="money"         mandatory="no">
		<cf_dbtempcol name="SalarioNetoF" type="money"    mandatory="no">
		<cf_dbtempcol name="CFcodigo" type="char(10)"     mandatory="no">
		<cf_dbtempcol name="CFdescripcion" type="char(50)" mandatory="no">
		<cf_dbtempcol name="SalarioNetoD" type="money"    mandatory="no">
		<cf_dbtempcol name="SalarioBrutoD" type="money"   mandatory="no">
		<cf_dbtempcol name="SalarioNetoFD" type="money"   mandatory="no">
		<cf_dbtempcol name="Fechas" type="char(50)"       mandatory="no">
		<cf_dbtempcol name="Fechap" type="char(30)"       mandatory="no">
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
	<!--- Define Form.TipoCambio --->
	<cfparam name="Form.TipoCambio" default="1.00" type="numeric">	
	<!--- Obtiene información del calendario de pago
	selecccionado por el usuario. --->
	<cfquery datasource="#session.dsn#">	
		insert #calendario#(RCNid, RCdesde, RChasta, Tcodigo, FechaPago, TipoCambio)
		select CPid, CPdesde, CPhasta, Tcodigo, CPfpago, #Form.TipoCambio#
		from CalendarioPagos
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
		and <cf_whereInList Column="CPid" ValueList="#form.CPidlist#" cfsqltype="cf_sql_numeric">
	</cfquery>
	<cf_debuginfo table="#calendario#" label="calendario - tomado de Calendario Pagos">
	<!--- Obtiene el Tipo de Cambio --->
	<cfif isdefined('form.tiponomina')>
		<cfquery datasource="#session.dsn#">
			update #calendario#
			set TipoCambio = coalesce(RCtc,#Form.TipoCambio#)
			from HRCalculoNomina a
			where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
			and <cf_whereInList Column="a.RCNid" ValueList="#form.CPidlist#" cfsqltype="cf_sql_numeric">
			and #calendario#.RCNid = a.RCNid
		</cfquery>
	<cfelse>
		<cfquery datasource="#session.dsn#">
			update #calendario#
			set TipoCambio = coalesce(RCtc,#Form.TipoCambio#)
			from RCalculoNomina a
			where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
			and <cf_whereInList Column="a.RCNid" ValueList="#form.CPidlist#" cfsqltype="cf_sql_numeric">
			and #calendario#.RCNid = a.RCNid
		</cfquery>
	</cfif>
	
	
	
	<cf_debuginfo table="#calendario#" label="calendario - tipo cambio actualizado con RCalculoNomina">
	<cfquery datasource="#session.dsn#">
		/* ===============================
		   Carga los Datos Generales del Empleado
		    ===============================*/
		insert #salida# (DEid, Nombre, NumeroSS, CFcodigo, CFdescripcion)
		select distinct 	a.DEid, 
				{fn substring(a.DEapellido1 +  '  ' + a.DEapellido2 +  '  ' + a.DEnombre,1,39)},
				a.DEdato3,
				f.CFcodigo, 
				f.CFdescripcion
		from DatosEmpleado a, LineaTiempo b, CalendarioPagos c, RHPlazas p, CFuncional f, #calendario# x
		where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
		and a.DEid = b.DEid
		and b.Tcodigo = x.Tcodigo 
		and c.Ecodigo = a.Ecodigo
		and c.Tcodigo = b.Tcodigo
		and c.CPid = x.RCNid
		and ((b.LThasta >= x.RCdesde and b.LTdesde <= x.RChasta) or (b.LTdesde <= x.RChasta and b.LThasta >= x.RCdesde))
		and b.RHPid = p.RHPid
		and p.CFid = f.CFid
	</cfquery>
	<cf_debuginfo table="#salida#" label="salida - despues de insertar empleados">
	<!--- Decide si se buscan los datos en las 
	tablas de trabajo o en las históricas --->
	<cfif isdefined('form.tiponomina')>
		<cfquery datasource="#session.dsn#">
			/* ===============================
		  	COLUMNA SALARIO BRUTO QUE SE PASA A INC
			    ===============================*/
			update #salida#
			set SalSA = coalesce((
					select sum(a.PEmontores) 
					from HPagosEmpleado a, #calendario# x 
					where a.DEid = #salida#.DEid and a.RCNid = x.RCNid),0) 
					
			update #salida#
			set SalSA = SalSA + coalesce((
											select sum(a.ICmontores) 
											from HIncidenciasCalculo a, #calendario# x
											where a.DEid = #salida#.DEid 
											and a.RCNid = x.RCNid
											and not exists (Select 1 
															from RHConceptosColumna c
															Where c.CIid = a.CIid)
											),0)
					
			/* ===============================
		  	COLUMNA SALARIO NETO PARTE A
			    ===============================*/
			update #salida#
			set SalarioNeto = SalSA
			
			/* ===============================
		  	COLUMNA SALARIO NETO PARTE B SE SUMARIZA AL FINAL A LA PARTE A
			    ===============================*/	
			update #salida#
			set SalIncidencias = coalesce((
					select sum(a.ICmontores) 
					from HIncidenciasCalculo a, #calendario# x 
					where a.DEid = #salida#.DEid 
					and a.RCNid = x.RCNid 
					and CIid in (select distinct a.CIid
								from RHReportesNomina c
									inner join RHColumnasReporte b
												inner join RHConceptosColumna a
												on a.RHCRPTid = b.RHCRPTid
										 on b.RHRPTNid = c.RHRPTNid
										and b.RHCRPTcodigo = 'SalIncidencias'
								where c.RHRPTNcodigo = 'SA'
								  and c.Ecodigo = #session.Ecodigo#)), 0.00)

			/* ===============================
		  	COLUMNA VACACIONES 
			    ===============================*/
			update #salida#
			set SubVacaciones = coalesce((
					select sum(a.ICmontores) 
					from HIncidenciasCalculo a, #calendario# x
					 where a.DEid = #salida#.DEid 
					and a.RCNid = x.RCNid 
					and CIid in (select distinct a.CIid
								from RHReportesNomina c
									inner join RHColumnasReporte b
												inner join RHConceptosColumna a
												on a.RHCRPTid = b.RHCRPTid
										 on b.RHRPTNid = c.RHRPTNid
										and b.RHCRPTcodigo = 'SubVacaciones'
								where c.RHRPTNcodigo = 'SA'
								  and c.Ecodigo = #session.Ecodigo#)),0)
			/* ===============================
		  	COLUMNA CARGAS OBRERO DEL EMPLEADO
			    ===============================*/
			update #salida#
			set cargasCCSSE = coalesce((
					select sum(a.CCvaloremp) 	
					from HCargasCalculo a, #calendario# x, DCargas b, ECargas c
					where a.DEid = #salida#.DEid 
					and a.DClinea=b.DClinea
					and b.ECid=c.ECid
					and c.ECauto=1
					and a.RCNid = x.RCNid),0)
					
		
			/* ===============================
		  	COLUMNA CARGAS OBRERO DEL PATRONO
			    ===============================*/
			update #salida#
			set cargasCCSSP = coalesce((select sum(a.CCvalorpat) 
						 from HCargasCalculo a, #calendario# x 
						 where a.DEid = #salida#.DEid and a.RCNid = x.RCNid),0)
		
			/* ===============================
		  	COLUMNA INCAPACIDADES POR MATERNIDAD E INCAPACIDAD
			    ===============================*/
			update #salida#
			/* ===============================
		  	COLUMNA SUMA LOS MONTOS POR INCAPACIDAD O MATERNIDAD QUE SE DEBEN REBAJAR
			    ===============================*/	
			set SalIncap = coalesce((select sum(a.ICmontores) 
						  from HIncidenciasCalculo a, #calendario# x 
						  where a.DEid = #salida#.DEid 
						  and a.RCNid = x.RCNid 
						  and CIid in (select distinct a.CIid
								from RHReportesNomina c
									inner join RHColumnasReporte b
												inner join RHConceptosColumna a
												on a.RHCRPTid = b.RHCRPTid
										 on b.RHRPTNid = c.RHRPTNid
										and b.RHCRPTcodigo = 'SalIncap'
								where c.RHRPTNcodigo = 'SA'
								  and c.Ecodigo = #session.Ecodigo#)),0)
	
			/* ===============================
		  	COLUMNA DEL IMPUESTO DE LA RENTA
			    ===============================*/
			update #salida#
			set Renta = coalesce((select sum(a.SErenta) 
					    from HSalarioEmpleado a, #calendario# x 
					    where a.DEid = #salida#.DEid 
					    and a.RCNid = x.RCNid ),0)
		
			/* ===============================
		  	COLUMNA DEDUCCIONES (EXCEPTO EMBARGO)
			    ===============================*/
			update #salida#
			set OtrasDed = coalesce((	select sum(a.DCvalor) 
						from HDeduccionesCalculo a, DeduccionesEmpleado b, #calendario# x, TDeduccion z
						where a.DEid = #salida#.DEid 
						and a.RCNid = x.RCNid 
						and a.DEid = b.DEid
						and a.Did = b.Did
						and b.TDid=z.TDid
						and z.TDid in (select distinct a.TDid
								from RHReportesNomina c
									inner join RHColumnasReporte b
												inner join RHConceptosColumna a
												on a.RHCRPTid = b.RHCRPTid
										 on b.RHRPTNid = c.RHRPTNid
										and b.RHCRPTcodigo = 'OtrasDed'
								where c.RHRPTNcodigo = 'SA'
								  and c.Ecodigo = #session.Ecodigo#)),0)

			/* ===============================
		  	COLUMNA DEDUCCIONES (CARGAS ASOCIADAS) ljimenez
		    ===============================*/						
			update #salida#
			set OtrasDed = OtrasDed + coalesce((	select sum(a.CCvaloremp) 
						from HCargasCalculo a, #calendario# x
						where a.DEid = #salida#.DEid 
						and a.RCNid = x.RCNid 
						and a.DClinea in (select distinct a.DClinea
								from RHReportesNomina c
									inner join RHColumnasReporte b
												inner join RHConceptosColumna a
												on a.RHCRPTid = b.RHCRPTid
										 on b.RHRPTNid = c.RHRPTNid
										and b.RHCRPTcodigo = 'OtrasDed'
								where c.RHRPTNcodigo = 'SA'
								  and c.Ecodigo = #session.Ecodigo#)),0)
			/* =============================== 
				EMBARGO 
			===============================*/	
			update #salida#
			set Embargo = coalesce((	select sum(a.DCvalor) 
						from HDeduccionesCalculo a, DeduccionesEmpleado b, #calendario# x, TDeduccion z
						where a.DEid = #salida#.DEid 
						and a.RCNid = x.RCNid 
						and a.DEid = b.DEid
						and a.Did = b.Did
						and b.TDid=z.TDid
						and z.TDid in (select distinct a.TDid
								from RHReportesNomina c
									inner join RHColumnasReporte b
												inner join RHConceptosColumna a
												on a.RHCRPTid = b.RHCRPTid
										 on b.RHRPTNid = c.RHRPTNid
										and b.RHCRPTcodigo = 'Embargo'
								where c.RHRPTNcodigo = 'SA'
								  and c.Ecodigo = #session.Ecodigo#)),0)
			/* ===============================
			COLUMNA SUMA TODO LO REBAJADO POR MATERNIDAD E INCAPACIDAD
			    ===============================*/	
			update #salida#
			set RebIncap = coalesce((
					select sum(a.ICmontores) 
					from HIncidenciasCalculo a, #calendario# x 
					where a.DEid = #salida#.DEid 
					and a.RCNid = x.RCNid 
					and CIid in (select distinct a.CIid
								from RHReportesNomina c
									inner join RHColumnasReporte b
												inner join RHConceptosColumna a
												on a.RHCRPTid = b.RHCRPTid
										 on b.RHRPTNid = c.RHRPTNid
										and b.RHCRPTcodigo = 'RebIncap'
								where c.RHRPTNcodigo = 'SA'
								  and c.Ecodigo = #session.Ecodigo#)),0)

		</cfquery>
	<cfelse> <!--- para las nominas en proceso --->
		<cfquery datasource="#session.dsn#">
			/* ===============================
		  	COLUMNA SALARIO BRUTO QUE SE PASA A INC
			    ===============================*/
			update #salida#
			set SalSA = isnull((
					select sum(a.PEmontores) 
					from PagosEmpleado a, #calendario# x 
					where a.DEid = #salida#.DEid and a.RCNid = x.RCNid),0) 
					
			update #salida#
			set SalSA = SalSA + coalesce((
											select sum(a.ICmontores) 
											from IncidenciasCalculo a, #calendario# x
											where a.DEid = #salida#.DEid 
											and a.RCNid = x.RCNid
											and not exists (Select 1 
															from RHConceptosColumna c
															Where c.CIid = a.CIid)
											),0)
			/* ===============================
		  	COLUMNA SALARIO NETO PARTE A
			    ===============================*/
			update #salida#
			set SalarioNeto = SalSA

			/* ===============================
		  	COLUMNA SALARIO NETO PARTE B SE SUMARIZA AL FINAL A LA PARTE A
			    ===============================*/	
			update #salida#
			set SalIncidencias = coalesce((
					select sum(a.ICmontores) 
					from IncidenciasCalculo a, #calendario# x 
					where a.DEid = #salida#.DEid 
					and a.RCNid = x.RCNid 
					and CIid in (select distinct a.CIid
								from RHReportesNomina c
									inner join RHColumnasReporte b
												inner join RHConceptosColumna a
												on a.RHCRPTid = b.RHCRPTid
										 on b.RHRPTNid = c.RHRPTNid
										and b.RHCRPTcodigo = 'SalIncidencias'
								where c.RHRPTNcodigo = 'SA'
								  and c.Ecodigo = #session.Ecodigo#)),0) 
			/* ===============================
		  	COLUMNA VACACIONES 
			    ===============================*/
			update #salida#
			set SubVacaciones = coalesce((
					select sum(a.ICmontores) 
					from IncidenciasCalculo a, #calendario# x
					 where a.DEid = #salida#.DEid 
					and a.RCNid = x.RCNid 
					and CIid in (select distinct a.CIid
								from RHReportesNomina c
									inner join RHColumnasReporte b
												inner join RHConceptosColumna a
												on a.RHCRPTid = b.RHCRPTid
										 on b.RHRPTNid = c.RHRPTNid
										and b.RHCRPTcodigo = 'SubVacaciones'
								where c.RHRPTNcodigo = 'SA'
								  and c.Ecodigo = #session.Ecodigo#)),0)
			/* ===============================
		  	COLUMNA CARGAS OBRERO DEL EMPLEADO
			    ===============================*/
			<!--- ljimenez
			update #salida#
			set cargasCCSSE = coalesce((
					select sum(a.CCvaloremp) 	
					from CargasCalculo a, #calendario# x 
					where a.DEid = #salida#.DEid 
					and a.RCNid = x.RCNid),0)
			--->		
			update #salida#
			set cargasCCSSE = coalesce((
					select sum(a.CCvaloremp) 	
					from CargasCalculo a, #calendario# x, DCargas b, ECargas c
					where a.DEid = #salida#.DEid 
					and a.DClinea=b.DClinea
					and b.ECid=c.ECid
					and c.ECauto=1
					and a.RCNid = x.RCNid),0)		
							
			/* ===============================
		  	COLUMNA CARGAS OBRERO DEL PATRONO
			    ===============================*/
			update #salida#
			set cargasCCSSP = coalesce((select sum(a.CCvalorpat) 
						 from CargasCalculo a, #calendario# x 
						 where a.DEid = #salida#.DEid and a.RCNid = x.RCNid),0)
		
			/* ===============================
		  	COLUMNA INCAPACIDADES POR MATERNIDAD E INCAPACIDAD
			    ===============================*/
			update #salida#
			set SalIncap  = coalesce((select sum(a.ICmontores) 
						  from IncidenciasCalculo a, #calendario# x 
						  where a.DEid = #salida#.DEid 
						  and a.RCNid = x.RCNid 
						  and CIid in (select distinct a.CIid
								from RHReportesNomina c
									inner join RHColumnasReporte b
												inner join RHConceptosColumna a
												on a.RHCRPTid = b.RHCRPTid
										 on b.RHRPTNid = c.RHRPTNid
										and b.RHCRPTcodigo = 'SalIncap'
								where c.RHRPTNcodigo = 'SA'
								  and c.Ecodigo = #session.Ecodigo#)),0)
	
			/* ===============================
		  	COLUMNA DEL IMPUESTO DE LA RENTA
			    ===============================*/
			update #salida#
			set Renta = coalesce((select sum(a.SErenta) 
					    from SalarioEmpleado a, #calendario# x 
					    where a.DEid = #salida#.DEid 
					    and a.RCNid = x.RCNid ),0)
		
			/* ===============================
		  	COLUMNA DEDUCCIONES (EXCEPTO EMBARGO)
			    ===============================*/
			update #salida#
			set OtrasDed = coalesce((	select sum(a.DCvalor) 
						from DeduccionesCalculo a, DeduccionesEmpleado b, #calendario# x, TDeduccion z
						where a.DEid = #salida#.DEid 
						and a.RCNid = x.RCNid 
						and a.DEid = b.DEid
						and a.Did = b.Did
						and b.TDid=z.TDid
						and z.TDid in (select distinct a.TDid
								from RHReportesNomina c
									inner join RHColumnasReporte b
												inner join RHConceptosColumna a
												on a.RHCRPTid = b.RHCRPTid
										 on b.RHRPTNid = c.RHRPTNid
										and b.RHCRPTcodigo = 'OtrasDed'
								where c.RHRPTNcodigo = 'SA'
								  and c.Ecodigo = #session.Ecodigo#)),0)
								  
			/* ===============================
		  	COLUMNA DEDUCCIONES (CARGAS ASOCIADAS) ljimenez
		    ===============================*/
			update #salida#
			set OtrasDed = OtrasDed + coalesce((	select sum(a.CCvaloremp) 
						from CargasCalculo a, #calendario# x
						where a.DEid = #salida#.DEid 
						and a.RCNid = x.RCNid 
						and a.DClinea in (select distinct a.DClinea
								from RHReportesNomina c
									inner join RHColumnasReporte b
												inner join RHConceptosColumna a
												on a.RHCRPTid = b.RHCRPTid
										 on b.RHRPTNid = c.RHRPTNid
										and b.RHCRPTcodigo = 'OtrasDed'
								where c.RHRPTNcodigo = 'SA'
								  and c.Ecodigo = #session.Ecodigo#)),0)
	
			/* ===============================
		  		EMBARGO
			    ===============================*/	
			update #salida#
			set Embargo = coalesce((	select sum(a.DCvalor) 
						from DeduccionesCalculo a, DeduccionesEmpleado b, #calendario# x, TDeduccion z
						where a.DEid = #salida#.DEid 
						and a.RCNid = x.RCNid 
						and a.DEid = b.DEid
						and a.Did = b.Did
						and b.TDid=z.TDid
						and z.TDid in (select distinct a.TDid
								from RHReportesNomina c
									inner join RHColumnasReporte b
												inner join RHConceptosColumna a
												on a.RHCRPTid = b.RHCRPTid
										 on b.RHRPTNid = c.RHRPTNid
										and b.RHCRPTcodigo = 'Embargo'
								where c.RHRPTNcodigo = 'SA'
								  and c.Ecodigo = #session.Ecodigo#)),0)
			/* ===============================
			COLUMNA SUMA TODO LO REBAJADO POR MATERNIDAD E INCAPACIDAD
			    ===============================*/	
			update #salida#
			set RebIncap = isnull((
					select sum(a.ICmontores) 
					from IncidenciasCalculo a, #calendario# x 
					where a.DEid = #salida#.DEid 
					and a.RCNid = x.RCNid 
					and CIid in (select distinct a.CIid
								from RHReportesNomina c
									inner join RHColumnasReporte b
												inner join RHConceptosColumna a
												on a.RHCRPTid = b.RHCRPTid
										 on b.RHRPTNid = c.RHRPTNid
										and b.RHCRPTcodigo = 'RebIncap'
								where c.RHRPTNcodigo = 'SA'
								  and c.Ecodigo = #session.Ecodigo#)),0)
		</cfquery>
	</cfif>
	<!--- Realiza calculos generales y finales sobre las
	tablas temporales previo a consultar los resultados --->
	<cfquery datasource="#session.dsn#">
		update #salida#
		set SalarioNeto = SalarioNeto + SalIncidencias
		
		update #salida#
		set SalarioBruto = SalarioNeto + SubVacaciones
		
		update #salida#
		set SalarioNetoF = SalSA   - cargasCCSSE + SalIncap + RebIncap - Renta  - OtrasDed - Embargo 
		
		update #salida# set 
		SalarioNetoD = SalarioNeto / TipoCambio,
		SalarioBrutoD = SalarioBruto / TipoCambio,
		SalarioNetoFD =  SalarioNetoF  / TipoCambio
		from #calendario#
		
		update #salida#
		set Fechas = '#LB_Periodo#: ' + convert(char(12), (select min(RCdesde) from #calendario#), 107)
		
		update #salida#
		set Fechas = rtrim(ltrim(Fechas)) + ' #LB_A# ' + convert(char(12), (select max(RChasta) from #calendario#), 107)
		
		update #salida#
		set Fechap = '#LB_Fecha_de_Pago#: ' + convert(char(12), (select max(FechaPago) from #calendario#), 107)
		
		update #salida#
		set FIngreso = (	select convert(char, EVfantig, 101) 
				from EVacacionesEmpleado a 
				where a.DEid = #salida#.DEid)
		
		update #salida# set EsNuevo = 1
		from CalendarioPagos a, #calendario# x
		where CPid = x.RCNid
		and FIngreso between CPdesde and CPhasta
	</cfquery>
	<!--- Consultas para el Reporte --->
	<cfquery name="rsCalendario" datasource="#session.dsn#">
		select TipoCambio
		from #calendario#
	</cfquery>
	
	
	<cfquery name="rsReporte" datasource="#session.dsn#">
		select 
			CFdescripcion, -- Descripcion del CF
			EsNuevo, -- Indica si la fecha de ingreso conincide con la nomina que se esta pagando
			Nombre = upper(Nombre),	-- Nombre
			NumeroSS,	-- DEdato3, numero del seguro social
			SalSA ,	-- SALARIO BRUTO QUE SE TRANFIERE A S.A
			SalarioNeto ,	-- Salario Neto, seria el Salario de Pagos empleado menos los rebajos por ausencia (de vacaciones e incapacidad)
			SalarioNetoD , -- Salario Neto dividido entre el tipo de cambio
			SubVacaciones, -- Monto del subsidio por vacaciones
			SalarioBruto, -- salario Neto + subsidio por vacaciones
			SalarioBrutoD , -- salario bruto / tipo de cambio
			cargasCCSSE, -- cargas obrero del empleado
			cargasCCSSP, -- cargas obrero del patrono
			SalIncap, --subsisdio de incapacidad
			RebIncap, --subsisdio de incapacidad
			Renta,	--  monto por Renta
			OtrasDed, -- Suma de deducciones - el embargo
			Embargo, -- embargo
			SalarioNetoF, -- Salario Bruto - rebajos
			SalarioNetoFD, -- Salario Neto / tipo de cambio
			Fechas, -- Titulo 1 para el reporte
			Fechap -- Titulo 2 para el reporte
		from #salida#
		order by CFdescripcion, Nombre
	</cfquery>
</cfsilent><!--- Quitar cuando se desea debuguear --->
<cf_htmlReportsHeaders 
	irA="PagoNominaSa.cfm"
	FileName="Reporte_de_Planilla_SA.xls"
	title="#LB_Reporte_de_Planilla_SA#">
<cf_templatecss>
<table width="98%" border="0" cellpadding="0" cellspacing="0" align="center">
	<cfoutput>
	<tr>
		<td colspan="15" align="right" nowrap><cf_translate key="LB_Tipo_De_Cambio">Tipo de Cambio</cf_translate>:#LSCurrencyFormat(rsCalendario.TipoCambio,'none')#</td>
	</tr>
	<tr><td colspan="15" align="center"><strong>#Trim(Session.Enombre)#</strong></td></tr>
	<tr><td colspan="15" align="center"><strong>#Trim(rsReporte.Fechas)#</strong></td></tr>
	<tr><td colspan="15" align="center"><strong><strong>#Trim(rsReporte.Fechap)#</strong></strong></td></tr>
	<tr><td colspan="15" align="center"><strong><strong>
	<cfif isdefined('form.tiponomina')>
		<cf_translate key="LB_IncluyeNominasAplicadas"> Incluye N&oacute;minas Aplicadas </cf_translate>
	<cfelse>
		<cf_translate key="LB_IncluyeNominasEnProceso"> Incluye N&oacute;minas En Proceso </cf_translate>
	</cfif>
	</strong></strong></td></tr>
	<tr>
		<td  class="tituloListas" valign="top"><strong>#LB_Nombre#</strong>&nbsp;</td>
		<td  class="tituloListas" valign="top" align="right"><strong>#LB_Numero_Soc_Sec#</strong>&nbsp;</td>
		<td  class="tituloListas" valign="top" align="right"><strong>#LB_Salario_SA#</strong>&nbsp;</td>
		<td  class="tituloListas" valign="top" align="right"><strong>#LB_SUB_TOTAL_SALARIO_NETO_C#</strong>&nbsp;</td>
		<td  class="tituloListas" valign="top" align="right"><strong>#LB_SUB_TOTAL_SALARIO_NETO_S#</strong>&nbsp;</td>
		<td  class="tituloListas" valign="top" align="right"><strong>#LB_Vacaciones_mas#</strong>&nbsp;</td>
		<td  class="tituloListas" valign="top" align="right"><strong>#LB_Salario_Bruto_C#</strong>&nbsp;</td>
		<td  class="tituloListas" valign="top" align="right"><strong>#LB_Salario_Bruto_S#</strong>&nbsp;</td>
		<td  class="tituloListas" valign="top" align="right"><strong>#LB_CCSS_9porc_menos#</strong>&nbsp;</td>
		<td  class="tituloListas" valign="top" align="right"><strong>#LB_Cargas_Soc_26porc#</strong>&nbsp;</td>
		<td  class="tituloListas" valign="top" align="right"><strong>#LB_Incapacidad_mas#</strong>&nbsp;</td>
		<td  class="tituloListas" valign="top" align="right"><strong>#LB_Incapacidad_menos#</strong>&nbsp;</td>
		<td  class="tituloListas" valign="top" align="right"><strong>#LB_Imp_Renta_menos#</strong>&nbsp;</td>
		<td  class="tituloListas" valign="top" align="right"><strong>#LB_Otras_Deducc#</strong>&nbsp;</td>
		<td  class="tituloListas" valign="top" align="right"K><strong>#LB_Ret_p_embargo_menos#</strong>&nbsp;</td>
		<td  class="tituloListas" valign="top" align="right"><strong>#LB_Salario_Neto#</strong>&nbsp;</td>
		<td  class="tituloListas" valign="top" align="right"><strong>#LB_Salario_Neto_S#</strong>&nbsp;</td>
	</tr>
	</cfoutput>
	<cfsilent>
		<cfset Lvar_GrandCount = 0>
		<cfset Lvar_GrandSalSAAcum =  0>
		<cfset Lvar_GrandSalarioNetoAcum =  0>
		<cfset Lvar_GrandSalarioNetoDAcum =  0>
		<cfset Lvar_GrandSubVacacionesAcum =  0>
		<cfset Lvar_GrandSalarioBrutoAcum =  0>
		<cfset Lvar_GrandSalarioBrutoDAcum =  0>
		<cfset Lvar_GrandcargasCCSSEAcum =  0>
		<cfset Lvar_GrandcargasCCSSPAcum =  0>
		<cfset Lvar_GrandSalIncapAcum =  0>
		<cfset Lvar_GrandRebIncapAcum =  0>
		<cfset Lvar_GrandRentaAcum =  0>
		<cfset Lvar_GrandOtrasDedAcum =  0>
		<cfset Lvar_GrandEmbargoAcum =  0>
		<cfset Lvar_GrandSalarioNetoFAcum =  0>
		<cfset Lvar_GrandSalarioNetoFDAcum =  0>
	</cfsilent>
	<cfoutput query="rsReporte" group="CFdescripcion">
		<cfsilent>
			<cfset Lvar_GroupCount = 0>
			<cfset Lvar_GroupSalSAAcum =  0>
			<cfset Lvar_GroupSalarioNetoAcum =  0>
			<cfset Lvar_GroupSalarioNetoDAcum =  0>
			<cfset Lvar_GroupSubVacacionesAcum =  0>
			<cfset Lvar_GroupSalarioBrutoAcum =  0>
			<cfset Lvar_GroupSalarioBrutoDAcum =  0>
			<cfset Lvar_GroupcargasCCSSEAcum =  0>
			<cfset Lvar_GroupcargasCCSSPAcum =  0>
			<cfset Lvar_GroupSalIncapAcum =  0>
			<cfset Lvar_GroupRebIncapAcum =  0>
			<cfset Lvar_GroupRentaAcum =  0>
			<cfset Lvar_GroupOtrasDedAcum =  0>
			<cfset Lvar_GroupEmbargoAcum =  0>
			<cfset Lvar_GroupSalarioNetoFAcum =  0>
			<cfset Lvar_GroupSalarioNetoFDAcum =  0>
		</cfsilent>
		<tr>
			<td nowrap class="tituloListas" colspan="17"><strong>#rsReporte.CFdescripcion#</strong>&nbsp;</td>
		</tr>
		<cfoutput>
			<tr class="<cfif rsReporte.CurrentRow mod 2>listaPar<cfelse>listaNon</cfif>" <cfif rsReporte.EsNuevo eq 1>style="background-color:yellow;" </cfif>>
				<td nowrap>#rsReporte.Nombre#</td>
				<td nowrap align="right">#rsReporte.NumeroSS#</td>
				<td nowrap align="right">#LSCurrencyformat(rsReporte.SalSA,'none')#</td>
				<td nowrap align="right">#LSCurrencyformat(rsReporte.SalarioNeto,'none')#</td>
				<td nowrap align="right">#LSCurrencyformat(rsReporte.SalarioNetoD,'none')#</td>
				<td nowrap align="right">#LSCurrencyformat(rsReporte.SubVacaciones,'none')#</td>
				<td nowrap align="right">#LSCurrencyformat(rsReporte.SalarioBruto,'none')#</td>
				<td nowrap align="right">#LSCurrencyformat(rsReporte.SalarioBrutoD,'none')#</td>
				<td nowrap align="right">#LSCurrencyformat(rsReporte.cargasCCSSE,'none')#</td>
				<td nowrap align="right">#LSCurrencyformat(rsReporte.cargasCCSSP,'none')#</td>
				<td nowrap align="right">#LSCurrencyformat(rsReporte.SalIncap,'none')#</td>
				<td nowrap align="right">#LSCurrencyformat(rsReporte.RebIncap,'none')#</td>
				<td nowrap align="right">#LSCurrencyformat(rsReporte.Renta,'none')#</td>
				<td nowrap align="right">#LSCurrencyformat(rsReporte.OtrasDed,'none')#</td>
				<td nowrap align="right">#LSCurrencyformat(rsReporte.Embargo,'none')#</td>
				<td nowrap align="right">#LSCurrencyformat(rsReporte.SalarioNetoF,'none')#</td>
				<td nowrap align="right">#LSCurrencyformat(rsReporte.SalarioNetoFD,'none')#</td>
			</tr>
			<cfsilent>
				<cfset Lvar_GrandCount = Lvar_GrandCount + 1>
				<cfset Lvar_GroupCount = Lvar_GroupCount + 1>
				<cfset Lvar_GrandSalSAAcum = Lvar_GrandSalSAAcum + rsReporte.SalSA>
				<cfset Lvar_GrandSalarioNetoAcum = Lvar_GrandSalarioNetoAcum + rsReporte.SalarioNeto>
				<cfset Lvar_GrandSalarioNetoDAcum = Lvar_GrandSalarioNetoDAcum + rsReporte.SalarioNetoD>
				<cfset Lvar_GrandSubVacacionesAcum = Lvar_GrandSubVacacionesAcum + rsReporte.SubVacaciones>
				<cfset Lvar_GrandSalarioBrutoAcum = Lvar_GrandSalarioBrutoAcum + rsReporte.SalarioBruto>
				<cfset Lvar_GrandSalarioBrutoDAcum = Lvar_GrandSalarioBrutoDAcum + rsReporte.SalarioBrutoD>
				<cfset Lvar_GrandcargasCCSSEAcum = Lvar_GrandcargasCCSSEAcum + rsReporte.cargasCCSSE>
				<cfset Lvar_GrandcargasCCSSPAcum = Lvar_GrandcargasCCSSPAcum + rsReporte.cargasCCSSP>
				<cfset Lvar_GrandSalIncapAcum = Lvar_GrandSalIncapAcum + rsReporte.SalIncap>
				<cfset Lvar_GrandRebIncapAcum = Lvar_GrandRebIncapAcum + rsReporte.RebIncap>
				<cfset Lvar_GrandRentaAcum = Lvar_GrandRentaAcum + rsReporte.Renta>
				<cfset Lvar_GrandOtrasDedAcum = Lvar_GrandOtrasDedAcum + rsReporte.OtrasDed>
				<cfset Lvar_GrandEmbargoAcum = Lvar_GrandEmbargoAcum + rsReporte.Embargo>
				<cfset Lvar_GrandSalarioNetoFAcum = Lvar_GrandSalarioNetoFAcum + rsReporte.SalarioNetoF>
				<cfset Lvar_GrandSalarioNetoFDAcum = Lvar_GrandSalarioNetoFDAcum + rsReporte.SalarioNetoFD>
				<cfset Lvar_GroupSalSAAcum = Lvar_GroupSalSAAcum + rsReporte.SalSA>
				<cfset Lvar_GroupSalarioNetoAcum = Lvar_GroupSalarioNetoAcum + rsReporte.SalarioNeto>
				<cfset Lvar_GroupSalarioNetoDAcum = Lvar_GroupSalarioNetoDAcum + rsReporte.SalarioNetoD>
				<cfset Lvar_GroupSubVacacionesAcum = Lvar_GroupSubVacacionesAcum + rsReporte.SubVacaciones>
				<cfset Lvar_GroupSalarioBrutoAcum = Lvar_GroupSalarioBrutoAcum + rsReporte.SalarioBruto>
				<cfset Lvar_GroupSalarioBrutoDAcum = Lvar_GroupSalarioBrutoDAcum + rsReporte.SalarioBrutoD>
				<cfset Lvar_GroupcargasCCSSEAcum = Lvar_GroupcargasCCSSEAcum + rsReporte.cargasCCSSE>
				<cfset Lvar_GroupcargasCCSSPAcum = Lvar_GroupcargasCCSSPAcum + rsReporte.cargasCCSSP>
				<cfset Lvar_GroupSalIncapAcum = Lvar_GroupSalIncapAcum + rsReporte.SalIncap>
				<cfset Lvar_GroupRebIncapAcum = Lvar_GroupRebIncapAcum + rsReporte.RebIncap>
				<cfset Lvar_GroupRentaAcum = Lvar_GroupRentaAcum + rsReporte.Renta>
				<cfset Lvar_GroupOtrasDedAcum = Lvar_GroupOtrasDedAcum + rsReporte.OtrasDed>
				<cfset Lvar_GroupEmbargoAcum = Lvar_GroupEmbargoAcum + rsReporte.Embargo>
				<cfset Lvar_GroupSalarioNetoFAcum = Lvar_GroupSalarioNetoFAcum + rsReporte.SalarioNetoF>
				<cfset Lvar_GroupSalarioNetoFDAcum = Lvar_GroupSalarioNetoFDAcum + rsReporte.SalarioNetoFD>
			</cfsilent>
		</cfoutput>
		<tr>
			<td nowrap class="tituloListas"><strong><cf_translate key="LB_Total"> Total </cf_translate>#rsReporte.CFdescripcion#</strong></td>
			<td nowrap class="tituloListas" align="right"><strong>#LSCurrencyformat(Lvar_GroupCount,'none')#</strong></td>
			<td nowrap class="tituloListas" align="right"><strong>#LSCurrencyformat(Lvar_GroupSalSAAcum,'none')#</strong></td>
			<td nowrap class="tituloListas" align="right"><strong>#LSCurrencyformat(Lvar_GroupSalarioNetoAcum,'none')#</strong></td>
			<td nowrap class="tituloListas" align="right"><strong>#LSCurrencyformat(Lvar_GroupSalarioNetoDAcum,'none')#</strong></td>
			<td nowrap class="tituloListas" align="right"><strong>#LSCurrencyformat(Lvar_GroupSubVacacionesAcum,'none')#</strong></td>
			<td nowrap class="tituloListas" align="right"><strong>#LSCurrencyformat(Lvar_GroupSalarioBrutoAcum,'none')#</strong></td>
			<td nowrap class="tituloListas" align="right"><strong>#LSCurrencyformat(Lvar_GroupSalarioBrutoDAcum,'none')#</strong></td>
			<td nowrap class="tituloListas" align="right"><strong>#LSCurrencyformat(Lvar_GroupcargasCCSSEAcum,'none')#</strong></td>
			<td nowrap class="tituloListas" align="right"><strong>#LSCurrencyformat(Lvar_GroupcargasCCSSPAcum,'none')#</strong></td>
			<td nowrap class="tituloListas" align="right"><strong>#LSCurrencyformat(Lvar_GroupSalIncapAcum,'none')#</strong></td>
			<td nowrap class="tituloListas" align="right"><strong>#LSCurrencyformat(Lvar_GroupRebIncapAcum,'none')#</strong></td>
			<td nowrap class="tituloListas" align="right"><strong>#LSCurrencyformat(Lvar_GroupRentaAcum,'none')#</strong></td>
			<td nowrap class="tituloListas" align="right"><strong>#LSCurrencyformat(Lvar_GroupOtrasDedAcum,'none')#</strong></td>
			<td nowrap class="tituloListas" align="right"><strong>#LSCurrencyformat(Lvar_GroupEmbargoAcum,'none')#</strong></td>
			<td nowrap class="tituloListas" align="right"><strong>#LSCurrencyformat(Lvar_GroupSalarioNetoFAcum,'none')#</strong></td>
			<td nowrap class="tituloListas" align="right"><strong>#LSCurrencyformat(Lvar_GroupSalarioNetoFDAcum,'none')#</strong></td>
		</tr>
	</cfoutput>
	<cfoutput>
	<tr>
		<td nowrap class="tituloListas"><strong><cf_translate key="LB_Total"> Total </cf_translate></strong></td>
		<td nowrap class="tituloListas" align="right"><strong>#LSCurrencyformat(Lvar_GrandCount,'none')#</strong></td>
		<td nowrap class="tituloListas" align="right"><strong>#LSCurrencyformat(Lvar_GrandSalSAAcum,'none')#</strong></td>
		<td nowrap class="tituloListas" align="right"><strong>#LSCurrencyformat(Lvar_GrandSalarioNetoAcum,'none')#</strong></td>
		<td nowrap class="tituloListas" align="right"><strong>#LSCurrencyformat(Lvar_GrandSalarioNetoDAcum,'none')#</strong></td>
		<td nowrap class="tituloListas" align="right"><strong>#LSCurrencyformat(Lvar_GrandSubVacacionesAcum,'none')#</strong></td>
		<td nowrap class="tituloListas" align="right"><strong>#LSCurrencyformat(Lvar_GrandSalarioBrutoAcum,'none')#</strong></td>
		<td nowrap class="tituloListas" align="right"><strong>#LSCurrencyformat(Lvar_GrandSalarioBrutoDAcum,'none')#</strong></td>
		<td nowrap class="tituloListas" align="right"><strong>#LSCurrencyformat(Lvar_GrandcargasCCSSEAcum,'none')#</strong></td>
		<td nowrap class="tituloListas" align="right"><strong>#LSCurrencyformat(Lvar_GrandcargasCCSSPAcum,'none')#</strong></td>
		<td nowrap class="tituloListas" align="right"><strong>#LSCurrencyformat(Lvar_GrandSalIncapAcum,'none')#</strong></td>
		<td nowrap class="tituloListas" align="right"><strong>#LSCurrencyformat(Lvar_GrandRebIncapAcum,'none')#</strong></td>
		<td nowrap class="tituloListas" align="right"><strong>#LSCurrencyformat(Lvar_GrandRentaAcum,'none')#</strong></td>
		<td nowrap class="tituloListas" align="right"><strong>#LSCurrencyformat(Lvar_GrandOtrasDedAcum,'none')#</strong></td>
		<td nowrap class="tituloListas" align="right"><strong>#LSCurrencyformat(Lvar_GrandEmbargoAcum,'none')#</strong></td>
		<td nowrap class="tituloListas" align="right"><strong>#LSCurrencyformat(Lvar_GrandSalarioNetoFAcum,'none')#</strong></td>
		<td nowrap class="tituloListas" align="right"><strong>#LSCurrencyformat(Lvar_GrandSalarioNetoFDAcum,'none')#</strong></td>
	</tr>
	</cfoutput>
	<tr><td colspan="17" align="center"><strong><cf_translate key="LB_FinDelReporte"> --Fin Del Reporte-- </cf_translate></strong></td></tr>
</table>