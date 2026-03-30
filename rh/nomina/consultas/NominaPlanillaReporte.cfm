<cfif isdefined("url.chkDependencias") and isdefined('url.CFid') and url.CFid GT 0>
	<cfinvoke component="rh.Componentes.RH_Funciones" method="CFDependencias"
		cfid = "#url.CFid#"
		nivel = 5
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
      and RHRPTNcodigo = 'RNP'
</cfquery>
<cfquery name="rsNomina" datasource="#session.DSN#">
	select RCdesde, RChasta
	from #tablaCalculoNomina#
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
	<cf_dbtemp name="NomPlanv1" returnvariable="salida">
        <cf_dbtempcol name="RCNid"   		  type="int"      	  mandatory="yes">
		<cf_dbtempcol name="LTid"   		  type="int"      	  mandatory="yes">
		<cf_dbtempcol name="DEid"   		  type="int"      	  mandatory="yes">
		<cf_dbtempcol name="DEidentificacion" type="varchar(60)"  mandatory="yes">
		<cf_dbtempcol name="Nombre"   		  type="varchar(255)" mandatory="yes">
		<cf_dbtempcol name="Dias"	  		  type="int"      	  mandatory="no">
		<cf_dbtempcol name="DiasSeptimo"	  type="int"      	  mandatory="no">
		<cf_dbtempcol name="DiasBonifica" 	  type="int"   		  mandatory="no">
		<cf_dbtempcol name="HorasExtraS" 	  type="float"   	  mandatory="no">
		<cf_dbtempcol name="HorasExtraD" 	  type="float"   	  mandatory="no">
		<cf_dbtempcol name="Ordinario" 		  type="money"    	  mandatory="no">
		<cf_dbtempcol name="ExtraS"	  		  type="money"    	  mandatory="no">
		<cf_dbtempcol name="ExtraD"	  		  type="money"    	  mandatory="no">
		<cf_dbtempcol name="Septimo" 		  type="money"    	  mandatory="no">
		<cf_dbtempcol name="Bonifica" 		  type="money"  	  mandatory="no">
		<cf_dbtempcol name="Comision" 		  type="money"  	  mandatory="no">
		<cf_dbtempcol name="Vacaciones"		  type="money"   	  mandatory="no">
		<cf_dbtempcol name="Otros" 			  type="money"    	  mandatory="no">
		<cf_dbtempcol name="VariosInc" 		  type="money"    	  mandatory="no">
		<cf_dbtempcol name="TotalIngresos" 	  type="money"    	  mandatory="no">
		<cf_dbtempcol name="IGSS" 			  type="money"    	  mandatory="no">
		<cf_dbtempcol name="Asoc" 			  type="money"    	  mandatory="no">
		<cf_dbtempcol name="ISR" 			  type="money"    	  mandatory="no">
		<cf_dbtempcol name="BanTrab" 		  type="money" 		  mandatory="no">
		<cf_dbtempcol name="VentasTienda"	  type="money"    	  mandatory="no">
		<cf_dbtempcol name="Anticipo" 		  type="money"    	  mandatory="no">
		<cf_dbtempcol name="VariosDesc" 	  type="money"   	  mandatory="no">
		<cf_dbtempcol name="TotalDesc" 		  type="money"    	  mandatory="no">
		<cf_dbtempcol name="Liquido" 		  type="money"   	  mandatory="no">
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
			inner join #tablaPagosEmpleado# d
				  on d.DEid = a.DEid
				  and d.RCNid = c.RCNid
				   and (c.RCdesde between PEdesde and PEhasta
			  	  or c.RChasta between PEdesde and PEhasta) 
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
                      and PEtiporeg=0 <!--- 25-11-2010 Si no se indica sumas los días de Retroactivos--->
                    group by a.RCNid),0)
    </cfquery>
	<!--- CANTIDAD DIAS SEPTIMO --->
    <cfquery name="rsDiasSeptimo" datasource="#session.DSN#">
    	update #salida#
        set DiasSeptimo = coalesce((
								select count(a.ICid)
								from #tablaIncidenciasCalculo# a
								where a.DEid = #salida#.DEid
								and a.RCNid = #salida#.RCNid 
								and CIid in (select distinct a.CIid
											from RHReportesNomina c
												inner join RHColumnasReporte b
															inner join RHConceptosColumna a
															on a.RHCRPTid = b.RHCRPTid
													 on b.RHRPTNid = c.RHRPTNid
													and b.RHCRPTcodigo = 'SEPTIMO'
											where c.RHRPTNcodigo = 'RNP'
											  and c.Ecodigo = #session.Ecodigo#)), 0.00)
    </cfquery>
	<!--- CANTIDAD DIAS SEPTIMO --->
    <cfquery name="rsDiasBonifica" datasource="#session.DSN#">
    	update #salida#
        set DiasBonifica = coalesce((
								select count(a.ICid)
								from #tablaIncidenciasCalculo# a
								where a.DEid = #salida#.DEid
								and a.RCNid = #salida#.RCNid 
								and CIid in (select distinct a.CIid
											from RHReportesNomina c
												inner join RHColumnasReporte b
															inner join RHConceptosColumna a
															on a.RHCRPTid = b.RHCRPTid
													 on b.RHRPTNid = c.RHRPTNid
													and b.RHCRPTcodigo = 'BONIFICACION'
											where c.RHRPTNcodigo = 'RNP'
											  and c.Ecodigo = #session.Ecodigo#)), 0.00)
    </cfquery>


    <!---CANTIDAD HORAS EXTRA S--->
    <cfquery name="rsMontoExtraA" datasource="#session.DSN#">
    	update #salida#
        set HorasExtraS =  coalesce((
<!---								select sum(a.ICvalor) --->
<!--- LZ 2010-11-25 Cuando se suma las Cantidades para la Boleta de Pago, es importante evitar sumar la informacion generada por Retroactivos, cuando se trata de incidencias de Tipo hora o tipo Dia,
pues sino incrementara la cantidad con sumas que no aplican --->
								select sum(case  when a.ICmontoant=0 and bb.CItipo in (0,1) then   <!--- Si no es retroactivo ni es tipo hora y dia sume valor--->
												a.ICvalor 
										  when a.ICmontoant <> 0 and bb.CItipo in (0,1) then  <!--- Si es retroactivo ni es tipo hora y dia no sume--->
										  		0
											else a.ICvalor  <!--- Los demas tipos de Incidencia sumelos --->
										  end)

								from #tablaIncidenciasCalculo# a
									inner join CIncidentes bb
									on a.CIid=bb.CIid
								where a.DEid = #salida#.DEid
								and a.RCNid = #salida#.RCNid 
								and not exists (select 1 
												from RHFeriados f	
												where f.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
													and f.RHFfecha = a.ICfecha
													and f.RHFfecha between <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(rsNomina.RCdesde)#">
																	and <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(rsNomina.RChasta)#">
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
												  and f.RHDJdia = datepart(dw,a.ICfecha)
												  and f.RHDJdia = 1
												where c.DEid = #salida#.DEid
												  and a.ICfecha between c.LTdesde and c.LThasta
								)
								and not exists(select  1
												from LineaTiempo c
												inner join RHJornadas e
												  on e.RHJid = c.RHJid
												inner join RHDJornadas f
												  on f.RHJid = e.RHJid
												  and f.RHDJdia = datepart(dw,a.ICfecha)
												  and f.RHDJdia = 1
												where c.DEid = #salida#.DEid
												  and a.ICfecha between c.LTdesde and c.LThasta
								)
								</cfif>
								and a.CIid in (select distinct a.CIid
											from RHReportesNomina c
												inner join RHColumnasReporte b
															inner join RHConceptosColumna a
															on a.RHCRPTid = b.RHCRPTid
													 on b.RHRPTNid = c.RHRPTNid
													and b.RHCRPTcodigo = 'EXTRAS'
											where c.RHRPTNcodigo = 'RNP'
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
																and b.RHCRPTcodigo = 'EXTRAS'
														where c.RHRPTNcodigo = 'RNP'
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
																and b.RHCRPTcodigo = 'EXTRAS'
														where c.RHRPTNcodigo = 'RNP'
														  and c.Ecodigo = #session.Ecodigo#)),0.00)
								
								
								)
    </cfquery>

    <!--- CANTIDAD HORAS EXTRA D--->
   <cfquery name="rsMontoExtraB" datasource="#session.DSN#">
    	update #salida#
        set HorasExtraD = coalesce((
<!---								select sum(a.ICvalor) --->
<!--- LZ 2010-11-25 Cuando se suma las Cantidades para la Boleta de Pago, es importante evitar sumar la informacion generada por Retroactivos, cuando se trata de incidencias de Tipo hora o tipo Dia,
pues sino incrementara la cantidad con sumas que no aplican --->
								select sum(case  when a.ICmontoant=0 and bb.CItipo in (0,1) then   <!--- Si no es retroactivo ni es tipo hora y dia sume valor--->
												a.ICvalor 
										  when a.ICmontoant <> 0 and bb.CItipo in (0,1) then  <!--- Si es retroactivo ni es tipo hora y dia no sume--->
										  		0
											else a.ICvalor  <!--- Los demas tipos de Incidencia sumelos --->
										  end)								
								from #tablaIncidenciasCalculo# a
								inner join CIncidentes bb
								on a.CIid=bb.CIid
								where a.DEid = #salida#.DEid
								and a.RCNid = #salida#.RCNid 
								and exists (select 1 
												from RHFeriados f	
												where f.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
													and f.RHFfecha = a.ICfecha
													and f.RHFfecha between <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(rsNomina.RCdesde)#">
																	and <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(rsNomina.RChasta)#">
													and f.RHFpagooblig = 1)
								and a.CIid in (select distinct a.CIid
											from RHReportesNomina c
												inner join RHColumnasReporte b
															inner join RHConceptosColumna a
															on a.RHCRPTid = b.RHCRPTid
													 on b.RHRPTNid = c.RHRPTNid
													and b.RHCRPTcodigo = 'EXTRAS'
											where c.RHRPTNcodigo = 'RNP'
											  and c.Ecodigo = #session.Ecodigo#)), 0.00)
    </cfquery>
 	<!--- VERIFICA SI ES UN DIA DOMINGO EN LA JORNADA O EN EL PLANIFICADOR--->
	<cfquery name="rsMontoExtraB" datasource="#session.DSN#">
    	update #salida#
        set HorasExtraD = HorasExtraD + coalesce((
<!---								select sum(a.ICvalor) --->
<!--- LZ 2010-11-25 Cuando se suma las Cantidades para la Boleta de Pago, es importante evitar sumar la informacion generada por Retroactivos, cuando se trata de incidencias de Tipo hora o tipo Dia,
pues sino incrementara la cantidad con sumas que no aplican --->
								select sum(case  when a.ICmontoant=0 and bb.CItipo in (0,1) then   <!--- Si no es retroactivo ni es tipo hora y dia sume valor--->
												a.ICvalor 
										  when a.ICmontoant <> 0 and bb.CItipo in (0,1) then  <!--- Si es retroactivo ni es tipo hora y dia no sume--->
										  		0
											else a.ICvalor  <!--- Los demas tipos de Incidencia sumelos --->
										  end)								
								from #tablaIncidenciasCalculo# a
								inner join CIncidentes bb
								on a.CIid=bb.CIid
								where a.DEid = #salida#.DEid
								and a.RCNid = #salida#.RCNid 
								<cfif Application.dsinfo[session.DSN].type is 'oracle'>
								and (exists (select 1 <!--- VERIFICA QUE LOS DIAS NO SEAN DOMINGOS --->
												from LineaTiempo c, RHJornadas e,RHDJornadas f
												where c.DEid =  #salida#.DEid
												  and a.ICfecha between c.LTdesde and c.LThasta
												  and e.RHJid = c.RHJid
												  and f.RHJid = e.RHJid
												  and f.RHDJdia = to_char(a.ICfecha,'d')
												  and f.RHDJdia = 1)
												or exists	(select  1  <!--- VERIFICA QUE LOS DIAS NO SEAN DOMINGOS EN CASO Q TENGA PLANIFICADOR --->
													from LineaTiempo c,RHPlanificador d, RHJornadas e,RHDJornadas f
													where c.DEid =  #salida#.DEid
													  and a.ICfecha between c.LTdesde and c.LThasta
													  and d.DEid = c.DEid
													  and a.ICfecha = d.RHPJfinicio(+)
													  and e.RHJid = coalesce(d.RHJid,c.RHJid)
													  and f.RHJid = e.RHJid
													  and f.RHDJdia = to_char(a.ICfecha,'d')
													  and f.RHDJdia = 1))
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
												  and f.RHDJdia = 1
												where c.DEid = #salida#.DEid
												  and a.ICfecha between c.LTdesde and c.LThasta
								)or exists(select  1
												from LineaTiempo c
												inner join RHJornadas e
												  on e.RHJid = c.RHJid
												inner join RHDJornadas f
												  on f.RHJid = e.RHJid
												  and f.RHDJdia = datepart(dd,a.ICfecha)
												  and f.RHDJdia = 1
												where c.DEid = #salida#.DEid
												  and a.ICfecha between c.LTdesde and c.LThasta)
								)
								</cfif>
								and a.CIid in (select distinct a.CIid
											from RHReportesNomina c
												inner join RHColumnasReporte b
															inner join RHConceptosColumna a
															on a.RHCRPTid = b.RHCRPTid
													 on b.RHRPTNid = c.RHRPTNid
													and b.RHCRPTcodigo = 'EXTRAS'
											where c.RHRPTNcodigo = 'RNP'
											  and c.Ecodigo = #session.Ecodigo#)), 0.00)
    </cfquery>
	<!--- VERIFICA SI ES UN DIA LIBRE EN EL PLANIFICADOR O EN LA JORNADA --->
	<cfquery name="rsMontoExtraB" datasource="#session.DSN#">
    	update #salida#
        set HorasExtraD = HorasExtraD + coalesce((
<!---							select sum(a.ICvalor) --->
<!--- LZ 2010-11-25 Cuando se suma las Cantidades para la Boleta de Pago, es importante evitar sumar la informacion generada por Retroactivos, cuando se trata de incidencias de Tipo hora o tipo Dia,
pues sino incrementara la cantidad con sumas que no aplican --->
								select sum(case  when a.ICmontoant=0 and bb.CItipo in (0,1) then   <!--- Si no es retroactivo ni es tipo hora y dia sume valor--->
												a.ICvalor 
										  when a.ICmontoant <> 0 and bb.CItipo in (0,1) then  <!--- Si es retroactivo ni es tipo hora y dia no sume--->
										  		0
											else a.ICvalor  <!--- Los demas tipos de Incidencia sumelos --->
										  end)
								from #tablaIncidenciasCalculo# a
								inner join CIncidentes bb
									on a.CIid=bb.CIid
								where a.DEid = #salida#.DEid
								and a.RCNid = #salida#.RCNid 
								<cfif Application.dsinfo[session.DSN].type is 'oracle'>
								and ( not exists (select 1 <!--- VERIFICA QUE LOS DIAS ESTE COMO LIBRES EN LA JORNADA --->
												from LineaTiempo c, RHJornadas e,RHDJornadas f
												where c.DEid =  #salida#.DEid
												  and a.ICfecha between c.LTdesde and c.LThasta
												  and e.RHJid = c.RHJid
												  and f.RHJid = e.RHJid
												  and f.RHDJdia = to_char(a.ICfecha,'d'))
												or exists	(select  1  <!--- VERIFICA QUE LOS DIAS NO SEAN DOMINGOS EN CASO Q TENGA PLANIFICADOR --->
													from LineaTiempo c,RHPlanificador d, RHJornadas e,RHDJornadas f
													where c.DEid =  #salida#.DEid
													  and a.ICfecha between c.LTdesde and c.LThasta
													  and d.DEid = c.DEid
													  and a.ICfecha = d.RHPJfinicio(+)
													  and e.RHJid = coalesce(d.RHJid,c.RHJid)
													  and f.RHJid = e.RHJid
													  and f.RHDJdia = to_char(a.ICfecha,'d')
													  and d.RHPlibre = 1))
								<cfelse>
									and ( not exists (select 1 <!--- VERIFICA QUE LOS DIAS ESTE COMO LIBRES EN LA JORNADA --->
												from LineaTiempo c
												inner join RHJornadas e
													on e.RHJid = c.RHJid
												inner join RHDJornadas f
													on f.RHJid = e.RHJid
												where c.DEid =  #salida#.DEid
												  and a.ICfecha between c.LTdesde and c.LThasta
												  and f.RHDJdia = datepart(dw,a.ICfecha))
												or exists (select  1  <!--- VERIFICA QUE LOS DIAS NO SEAN DOMINGOS EN CASO Q TENGA PLANIFICADOR --->
													from LineaTiempo c
													left outer join RHPlanificador d
														on d.DEid = c.DEid
													inner join RHJornadas e
														on e.RHJid = coalesce(d.RHJid,c.RHJid)
													inner join RHDJornadas f
														on f.RHJid = e.RHJid
													where c.DEid =  #salida#.DEid
													  and a.ICfecha between c.LTdesde and c.LThasta
													  and a.ICfecha = d.RHPJfinicio
													  and f.RHDJdia = datepart(dw,a.ICfecha)
													  and d.RHPlibre = 1))
								</cfif>
								and a.CIid in (select distinct a.CIid
											from RHReportesNomina c
												inner join RHColumnasReporte b
															inner join RHConceptosColumna a
															on a.RHCRPTid = b.RHCRPTid
													 on b.RHRPTNid = c.RHRPTNid
													and b.RHCRPTcodigo = 'EXTRAS'
											where c.RHRPTNcodigo = 'RNP'
											  and c.Ecodigo = #session.Ecodigo#)), 0.00)
    </cfquery>

	<!--- SE SUMAN LOS MONTOS DE LA COLUMNA EXTRAD INDICADAS EN LA CONFIGURACION  DEL REPORTE. --->
	<cfquery name="rsSeptimo" datasource="#session.DSN#">
    	update #salida#
			set HorasExtraD = HorasExtraD + coalesce((
<!---					select sum(a.ICvalor) --->
<!--- LZ 2010-11-25 Cuando se suma las Cantidades para la Boleta de Pago, es importante evitar sumar la informacion generada por Retroactivos, cuando se trata de incidencias de Tipo hora o tipo Dia,
	pues sino incrementara la cantidad con sumas que no aplican --->
				select sum(case  when a.ICmontoant=0 and bb.CItipo in (0,1) then   <!--- Si no es retroactivo ni es tipo hora y dia sume valor--->
								a.ICvalor 
						  when a.ICmontoant <> 0 and bb.CItipo in (0,1) then  <!--- Si es retroactivo ni es tipo hora y dia no sume--->
						  		0
							else a.ICvalor  <!--- Los demas tipos de Incidencia sumelos --->
						  end)
					from #tablaIncidenciasCalculo# a
					inner join CIncidentes bb
					on a.CIid=bb.CIid
					where a.DEid = #salida#.DEid
					and a.RCNid = #salida#.RCNid 
					and a.CIid in (select distinct a.CIid
								from RHReportesNomina c
									inner join RHColumnasReporte b
												inner join RHConceptosColumna a
												on a.RHCRPTid = b.RHCRPTid
										 on b.RHRPTNid = c.RHRPTNid
										and b.RHCRPTcodigo = 'EXTRAD'
								where c.RHRPTNcodigo = 'RNP'
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
												and b.RHCRPTcodigo = 'EXTRAD'
										where c.RHRPTNcodigo = 'RNP'
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
												and b.RHCRPTcodigo = 'EXTRAD'
										where c.RHRPTNcodigo = 'RNP'
										  and c.Ecodigo = #session.Ecodigo#)),0.00)
				
				
				)
    </cfquery>

    <!--- SALARIO ORDINARIO --->
    <!--- SALARIO BRUTO --->
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
													and b.RHCRPTcodigo = 'ORDINARIO'
											where c.RHRPTNcodigo = 'RNP'
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
																and b.RHCRPTcodigo = 'ORDINARIO'
														where c.RHRPTNcodigo = 'RNP'
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
																and b.RHCRPTcodigo = 'ORDINARIO'
														where c.RHRPTNcodigo = 'RNP'
														  and c.Ecodigo = #session.Ecodigo#)),0.00)
								
								
								)
    </cfquery> 
    <!--- Obtiene la finformaciÃ³n del Feriado --->
	<cfquery name="rsFeriados" datasource="#session.DSN#">
		select a.RHFfecha
		from RHFeriados a
		where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			and RHFfecha between <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(rsNomina.RCdesde)#">
        					and <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(rsNomina.RChasta)#">
			and a.RHFpagooblig = 1
	</cfquery>
    <!--- CALCULO DE LAS HORAS EXTRA (TOTAL HORAS EXTRA A Y HORAS EXTRA B) --->
    <!--- HORAS EXTRA A --->
	<!--- SUMA DE TODOS LOS MONTOS PAGADOS POR INCIDENCIAS INDICADAS PARA LA COLUMNA EXTRASS
			EN LA CONFIGURACION DEL REPORTE QUE -- NO -- SEAN FERIADOS NI DIAS LIBRES  --->
    <cfquery name="rsMontoExtraA" datasource="#session.DSN#">
    	update #salida#
        set ExtraS =  coalesce((
								select sum(a.ICmontores) 
								from #tablaIncidenciasCalculo# a
								where a.DEid = #salida#.DEid
								and a.RCNid = #salida#.RCNid 
								and not exists (select 1 
												from RHFeriados f	
												where f.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
													and f.RHFfecha = a.ICfecha
													and f.RHFfecha between <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(rsNomina.RCdesde)#">
																	and <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(rsNomina.RChasta)#">
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
												  and f.RHDJdia = 1
												where c.DEid = #salida#.DEid
												  and a.ICfecha between c.LTdesde and c.LThasta
								)
								and not exists(select  1
												from LineaTiempo c
												inner join RHJornadas e
												  on e.RHJid = c.RHJid
												inner join RHDJornadas f
												  on f.RHJid = e.RHJid
												  and f.RHDJdia = datepart(dd,a.ICfecha)
												  and f.RHDJdia = 1
												where c.DEid = #salida#.DEid
												  and a.ICfecha between c.LTdesde and c.LThasta
								)
								</cfif>
								and CIid in (select distinct a.CIid
											from RHReportesNomina c
												inner join RHColumnasReporte b
															inner join RHConceptosColumna a
															on a.RHCRPTid = b.RHCRPTid
													 on b.RHRPTNid = c.RHRPTNid
													and b.RHCRPTcodigo = 'EXTRAS'
											where c.RHRPTNcodigo = 'RNP'
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
																and b.RHCRPTcodigo = 'EXTRAS'
														where c.RHRPTNcodigo = 'RNP'
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
																and b.RHCRPTcodigo = 'EXTRAS'
														where c.RHRPTNcodigo = 'RNP'
														  and c.Ecodigo = #session.Ecodigo#)),0.00)
								
								
								)
    </cfquery>
    <!--- HORAS EXTRA B --->
	<!--- SUMA DE TODOS LOS MONTOS PAGADOS POR INCIDENCIAS INDICADAS PARA LA COLUMNA EXTRASS
			EN LA CONFIGURACION DEL REPORTE QUE SEAN FERIADOS o DIAS LIBRES  --->
	<!--- VERIFICA SI ES UN FERIADO --->
    <cfquery name="rsMontoExtraB" datasource="#session.DSN#">
    	update #salida#
        set ExtraD = coalesce((
								select sum(a.ICmontores) 
								from #tablaIncidenciasCalculo# a
								where a.DEid = #salida#.DEid
								and a.RCNid = #salida#.RCNid 
								and exists (select 1 
												from RHFeriados f	
												where f.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
													and f.RHFfecha = a.ICfecha
													and f.RHFfecha between <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(rsNomina.RCdesde)#">
																	and <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(rsNomina.RChasta)#">
													and f.RHFpagooblig = 1)
								and CIid in (select distinct a.CIid
											from RHReportesNomina c
												inner join RHColumnasReporte b
															inner join RHConceptosColumna a
															on a.RHCRPTid = b.RHCRPTid
													 on b.RHRPTNid = c.RHRPTNid
													and b.RHCRPTcodigo = 'EXTRAS'
											where c.RHRPTNcodigo = 'RNP'
											  and c.Ecodigo = #session.Ecodigo#)), 0.00)
    </cfquery>
 	<!--- VERIFICA SI ES UN DIA DOMINGO EN LA JORNADA O EN EL PLANIFICADOR--->
	<cfquery name="rsMontoExtraB" datasource="#session.DSN#">
    	update #salida#
        set ExtraD = ExtraD + coalesce((
								select sum(a.ICmontores) 
								from #tablaIncidenciasCalculo# a
								where a.DEid = #salida#.DEid
								and a.RCNid = #salida#.RCNid 
								<cfif Application.dsinfo[session.DSN].type is 'oracle'>
								and (exists (select 1 <!--- VERIFICA QUE LOS DIAS NO SEAN DOMINGOS --->
												from LineaTiempo c, RHJornadas e,RHDJornadas f
												where c.DEid =  #salida#.DEid
												  and a.ICfecha between c.LTdesde and c.LThasta
												  and e.RHJid = c.RHJid
												  and f.RHJid = e.RHJid
												  and f.RHDJdia = to_char(a.ICfecha,'d')
												  and f.RHDJdia = 1)
												or exists	(select  1  <!--- VERIFICA QUE LOS DIAS NO SEAN DOMINGOS EN CASO Q TENGA PLANIFICADOR --->
													from LineaTiempo c,RHPlanificador d, RHJornadas e,RHDJornadas f
													where c.DEid =  #salida#.DEid
													  and a.ICfecha between c.LTdesde and c.LThasta
													  and d.DEid = c.DEid
													  and a.ICfecha = d.RHPJfinicio(+)
													  and e.RHJid = coalesce(d.RHJid,c.RHJid)
													  and f.RHJid = e.RHJid
													  and f.RHDJdia = to_char(a.ICfecha,'d')
													  and f.RHDJdia = 1))
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
												  and f.RHDJdia = 1
												where c.DEid = #salida#.DEid
												  and a.ICfecha between c.LTdesde and c.LThasta
								)or exists(select  1
												from LineaTiempo c
												inner join RHJornadas e
												  on e.RHJid = c.RHJid
												inner join RHDJornadas f
												  on f.RHJid = e.RHJid
												  and f.RHDJdia = datepart(dd,a.ICfecha)
												  and f.RHDJdia = 1
												where c.DEid = #salida#.DEid
												  and a.ICfecha between c.LTdesde and c.LThasta)
								)
								</cfif>
								and CIid in (select distinct a.CIid
											from RHReportesNomina c
												inner join RHColumnasReporte b
															inner join RHConceptosColumna a
															on a.RHCRPTid = b.RHCRPTid
													 on b.RHRPTNid = c.RHRPTNid
													and b.RHCRPTcodigo = 'EXTRAS'
											where c.RHRPTNcodigo = 'RNP'
											  and c.Ecodigo = #session.Ecodigo#)), 0.00)
    </cfquery>
	<!--- VERIFICA SI ES UN DIA LIBRE EN EL PLANIFICADOR O EN LA JORNADA --->
	<cfquery name="rsMontoExtraB" datasource="#session.DSN#">
    	update #salida#
        set ExtraD = ExtraD + coalesce((
								select sum(a.ICmontores) 
								from #tablaIncidenciasCalculo# a
								where a.DEid = #salida#.DEid
								and a.RCNid = #salida#.RCNid 
								<cfif Application.dsinfo[session.DSN].type is 'oracle'>
								and ( not exists (select 1 <!--- VERIFICA QUE LOS DIAS ESTE COMO LIBRES EN LA JORNADA --->
												from LineaTiempo c, RHJornadas e,RHDJornadas f
												where c.DEid =  #salida#.DEid
												  and a.ICfecha between c.LTdesde and c.LThasta
												  and e.RHJid = c.RHJid
												  and f.RHJid = e.RHJid
												  and f.RHDJdia = to_char(a.ICfecha,'d'))
												or exists	(select  1  <!--- VERIFICA QUE LOS DIAS NO SEAN DOMINGOS EN CASO Q TENGA PLANIFICADOR --->
													from LineaTiempo c,RHPlanificador d, RHJornadas e,RHDJornadas f
													where c.DEid =  #salida#.DEid
													  and a.ICfecha between c.LTdesde and c.LThasta
													  and d.DEid = c.DEid
													  and a.ICfecha = d.RHPJfinicio(+)
													  and e.RHJid = coalesce(d.RHJid,c.RHJid)
													  and f.RHJid = e.RHJid
													  and f.RHDJdia = to_char(a.ICfecha,'d')
													  and d.RHPlibre = 1))
								<cfelse>
									and ( not exists (select 1 <!--- VERIFICA QUE LOS DIAS ESTE COMO LIBRES EN LA JORNADA --->
												from LineaTiempo c
												inner join RHJornadas e
													on e.RHJid = c.RHJid
												inner join RHDJornadas f
													on f.RHJid = e.RHJid
												where c.DEid =  #salida#.DEid
												  and a.ICfecha between c.LTdesde and c.LThasta
												  and f.RHDJdia = datepart(dw,a.ICfecha))
												or exists (select  1  <!--- VERIFICA QUE LOS DIAS NO SEAN DOMINGOS EN CASO Q TENGA PLANIFICADOR --->
													from LineaTiempo c
													left outer join RHPlanificador d
														on d.DEid = c.DEid
													inner join RHJornadas e
														on e.RHJid = coalesce(d.RHJid,c.RHJid)
													inner join RHDJornadas f
														on f.RHJid = e.RHJid
													where c.DEid =  #salida#.DEid
													  and a.ICfecha between c.LTdesde and c.LThasta
													  and a.ICfecha = d.RHPJfinicio
													  and f.RHDJdia = datepart(dw,a.ICfecha)
													  and d.RHPlibre = 1))
								</cfif>
								and CIid in (select distinct a.CIid
											from RHReportesNomina c
												inner join RHColumnasReporte b
															inner join RHConceptosColumna a
															on a.RHCRPTid = b.RHCRPTid
													 on b.RHRPTNid = c.RHRPTNid
													and b.RHCRPTcodigo = 'EXTRAS'
											where c.RHRPTNcodigo = 'RNP'
											  and c.Ecodigo = #session.Ecodigo#)), 0.00)
    </cfquery>

	<!--- SE SUMAN LOS MONTOS DE LA COLUMNA EXTRAD INDICADAS EN LA CONFIGURACION  DEL REPORTE. --->
	<cfquery name="rsSeptimo" datasource="#session.DSN#">
    	update #salida#
			set ExtraD = ExtraD + coalesce((
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
										and b.RHCRPTcodigo = 'EXTRAD'
								where c.RHRPTNcodigo = 'RNP'
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
												and b.RHCRPTcodigo = 'EXTRAD'
										where c.RHRPTNcodigo = 'RNP'
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
												and b.RHCRPTcodigo = 'EXTRAD'
										where c.RHRPTNcodigo = 'RNP'
										  and c.Ecodigo = #session.Ecodigo#)),0.00)
				
				
				)
    </cfquery>
	
    <!--- SEPTIMO --->
	<cfquery name="rsSeptimo" datasource="#session.DSN#">
    	update #salida#
			set Septimo = coalesce((
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
										and b.RHCRPTcodigo = 'SEPTIMO'
								where c.RHRPTNcodigo = 'RNP'
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
												and b.RHCRPTcodigo = 'SEPTIMO'
										where c.RHRPTNcodigo = 'RNP'
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
												and b.RHCRPTcodigo = 'SEPTIMO'
										where c.RHRPTNcodigo = 'RNP'
										  and c.Ecodigo = #session.Ecodigo#)),0.00)
				
				
				)
    </cfquery>
    <!--- BONIFICACION LEY Q250 --->
	<cfquery name="rsHorasExtra" datasource="#session.DSN#">
    	update #salida#
        set Bonifica = coalesce((
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
													and b.RHCRPTcodigo = 'BONIFICACION'
											where c.RHRPTNcodigo = 'RNP'
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
																and b.RHCRPTcodigo = 'BONIFICACION'
														where c.RHRPTNcodigo = 'RNP'
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
																and b.RHCRPTcodigo = 'BONIFICACION'
														where c.RHRPTNcodigo = 'RNP'
														  and c.Ecodigo = #session.Ecodigo#)),0.00)
								)
    </cfquery>
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
													and b.RHCRPTcodigo = 'COMISION'
											where c.RHRPTNcodigo = 'RNP'
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
																and b.RHCRPTcodigo = 'COMISION'
														where c.RHRPTNcodigo = 'RNP'
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
																and b.RHCRPTcodigo = 'COMISION'
														where c.RHRPTNcodigo = 'RNP'
														  and c.Ecodigo = #session.Ecodigo#)),0.00)
								)
    </cfquery>

    <!--- VACACIONES --->
    <cfquery name="rsVacaciones" datasource="#session.DSN#">
    	update #salida#
			set Vacaciones = coalesce((
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
										and b.RHCRPTcodigo = 'VACACIONES'
								where c.RHRPTNcodigo = 'RNP'
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
												and b.RHCRPTcodigo = 'VACACIONES'
										where c.RHRPTNcodigo = 'RNP'
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
												and b.RHCRPTcodigo = 'VACACIONES'
										where c.RHRPTNcodigo = 'RNP'
										  and c.Ecodigo = #session.Ecodigo#)),0.00)
				
				
				)	
    </cfquery>
    <!--- OTROS --->
    <cfquery name="rsOtros" datasource="#session.DSN#">
    	update #salida#
			set Otros = coalesce((
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
										and b.RHCRPTcodigo = 'OTROS'
								where c.RHRPTNcodigo = 'RNP'
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
												and b.RHCRPTcodigo = 'OTROS'
										where c.RHRPTNcodigo = 'RNP'
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
												and b.RHCRPTcodigo = 'OTROS'
										where c.RHRPTNcodigo = 'RNP'
										  and c.Ecodigo = #session.Ecodigo#)),0.00)
				
				
				)
    </cfquery>
    <!--- VARIOS INCIDENCIAS --->
    <cfquery name="rsVariosInc" datasource="#session.DSN#">
    	update #salida#
			set VariosInc = coalesce((
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
															and b.RHCRPTcodigo = 'VARIOSINC'
													where c.RHRPTNcodigo = 'RNP'
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
															and b.RHCRPTcodigo = 'VARIOSINC'
													where c.RHRPTNcodigo = 'RNP'
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
															and b.RHCRPTcodigo = 'VARIOSINC'
													where c.RHRPTNcodigo = 'RNP'
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
    <!--- ASOCIACION SOLIDARISTA --->
    <cfquery name="rsAsoc" datasource="#session.DSN#">
    	update #salida#
			set Asoc = (coalesce((	select sum(a.DCvalor) 
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
										and b.RHCRPTcodigo = 'ASOC'
								where c.RHRPTNcodigo = 'RNP'
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
													and b.RHCRPTcodigo = 'ASOC'
											where c.RHRPTNcodigo = 'RNP'
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
															and b.RHCRPTcodigo = 'ASOC'
													where c.RHRPTNcodigo = 'RNP'
													  and c.Ecodigo = #session.Ecodigo#)), 0.00))
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
			set ISR = ISR + (coalesce((	select sum(a.DCvalor) 
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
										and b.RHCRPTcodigo = 'ISR'
								where c.RHRPTNcodigo = 'RNP'
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
													and b.RHCRPTcodigo = 'ISR'
											where c.RHRPTNcodigo = 'RNP'
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
															and b.RHCRPTcodigo = 'ISR'
													where c.RHRPTNcodigo = 'RNP'
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
										and b.RHCRPTcodigo = 'BANTRAB'
								where c.RHRPTNcodigo = 'RNP'
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
													and b.RHCRPTcodigo = 'BANTRAB'
											where c.RHRPTNcodigo = 'RNP'
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
															and b.RHCRPTcodigo = 'BANTRAB'
													where c.RHRPTNcodigo = 'RNP'
													  and c.Ecodigo = #session.Ecodigo#)), 0.00))

    </cfquery>
	<!--- VENTAS Y TIENDA --->
	    <cfquery name="rsISR" datasource="#session.DSN#">
    	update #salida#
			set VentasTienda = (coalesce((	select sum(a.DCvalor) 
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
														and b.RHCRPTcodigo = 'VENTASTIENDA'
												where c.RHRPTNcodigo = 'RNP'
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
														and b.RHCRPTcodigo = 'VENTASTIENDA'
												where c.RHRPTNcodigo = 'RNP'
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
																and b.RHCRPTcodigo = 'VENTASTIENDA'
														where c.RHRPTNcodigo = 'RNP'
														  and c.Ecodigo = #session.Ecodigo#)), 0.00))
    </cfquery>
    <!--- ANTICIPOS --->
    <cfquery name="rsAnticipos" datasource="#session.DSN#">
    	update #salida#
			set Anticipo = coalesce((
					select sum(abs(a.ICmontores)) 
					from #tablaIncidenciasCalculo# a
					 where a.DEid = #salida#.DEid
					and a.RCNid = #salida#.RCNid 
					and CIid in (select distinct a.CIid
								from RHReportesNomina c
									inner join RHColumnasReporte b
												inner join RHConceptosColumna a
												on a.RHCRPTid = b.RHCRPTid
										 on b.RHRPTNid = c.RHRPTNid
										and b.RHCRPTcodigo = 'ANTICIPOS'
								where c.RHRPTNcodigo = 'RNP'
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
											and b.RHCRPTcodigo = 'ANTICIPOS'
									where c.RHRPTNcodigo = 'RNP'
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
											and b.RHCRPTcodigo = 'ANTICIPOS'
									where c.RHRPTNcodigo = 'RNP'
									  and c.Ecodigo = #session.Ecodigo#)),0.00)
			
			
			)
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
										and b.RHCRPTcodigo = 'VARIOSDESC'
								where c.RHRPTNcodigo = 'RNP'
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
													and b.RHCRPTcodigo = 'VARIOSDESC'
											where c.RHRPTNcodigo = 'RNP'
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
															and b.RHCRPTcodigo = 'VARIOSDESC'
													where c.RHRPTNcodigo = 'RNP'
													  and c.Ecodigo = #session.Ecodigo#)), 0.00))			  
								  
					
    </cfquery>
	
	<!--- MONTO TOTALES --->
    <cfquery name="rsSalarioLiq" datasource="#session.DSN#">
    	update #salida#
        set TotalDesc = (IGSS + Asoc + ISR + BanTrab + VentasTienda + Anticipo + VariosDesc),
			TotalIngresos = (Ordinario + ExtraS + ExtraD + Septimo + Bonifica + Vacaciones + Otros + VariosInc + Comision)
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
		<cfset Lvar_TotalOrd 		  	= 0>
			<cfset Lvar_TotalExtraS   	= 0>
			<cfset Lvar_TotalExtraD   	= 0>
			<cfset Lvar_TotalSept 	 	= 0>
			<cfset Lvar_TotalBono 	  	= 0>
			<cfset Lvar_TotalComision 	= 0>
			<cfset Lvar_TotalVaca 	  	= 0>
			<cfset Lvar_TotalOtros 	  	= 0>
			<cfset Lvar_TotalVariosInc	= 0>
			<cfset Lvar_TotalIngresos 	= 0>
			<cfset Lvar_TotalIGSS 	  	= 0>
			<cfset Lvar_TotalAsoc 	  	= 0>
			<cfset Lvar_TotalISR 	 	= 0>
			<cfset Lvar_TotalBanT     	= 0>
			<cfset Lvar_TotalVentasTienda = 0>
			<cfset Lvar_TotalAnticipos	= 0>
			<cfset Lvar_TotalVariosDesc = 0>
			<cfset Lvar_TotalDesc 		= 0>
			<cfset Lvar_TotalLiquido 	= 0>
	</cfsilent>
	
    <table width="100%" border="0" cellpadding="2" cellspacing="0" align="center" style="border-color:CCCCCC">
		<cfoutput>
        <tr>
			<td colspan="26">
				<table width="100%" cellpadding="0" cellspacing="0">
					<tr><td>						
						<cfif isdefined('url.Agrupar')>
							<cfset titulo = '#LB_PLANILLADEPAGOSPORDEPARTAMENTO#'>
						<cfelse>
							<cfset titulo = '#LB_PLANILLADEPAGOS#'>
						</cfif>
						<cf_EncReporte
							Titulo="#titulo#"
							Color="##E3EDEF"
							filtro1="#LB_FechaRige#: #LSDateFormat(rsNomina.RCdesde,'dd/mm/yyyy')# &nbsp; #LB_FechaVence#: #LSDateFormat(rsNomina.RChasta,'dd/mm/yyyy')#"	
						>
					</td></tr>
				</table>
			</td>
		</tr>
		<!----===================== ENCABEZADO ANTERIOR =====================
		<tr><td align="center" class="titulo_empresa2" colspan="21"><strong>#rsEmpresa.Edescripcion#</strong></td></tr>
        <tr><td align="center" class="titulo_empresa2" colspan="21"><strong><cfif isdefined('url.Agrupar')>#LB_PLANILLADEPAGOSPORDEPARTAMENTO#<cfelse>#LB_PLANILLADEPAGOS#</cfif></strong></td></tr>
        <tr><td align="center" class="titulo_empresa2" colspan="21"><strong>#LB_FechaRige#: #LSDateFormat(rsNomina.RCdesde,'dd/mm/yyyy')# &nbsp; #LB_FechaVence#: #LSDateFormat(rsNomina.RChasta,'dd/mm/yyyy')#	</strong></td></tr>
        <tr><td>&nbsp;</td></tr>
		------>
        </cfoutput>
        <tr><td height="1" bgcolor="000000" colspan="26"></td>
		<cfif not isdefined('url.Agrupar')>
		
 		<tr class="listaCorte3" valign="bottom">
			<td nowrap ><cf_translate key="LB_Codigo">C&oacute;digo</cf_translate></td>
			<td nowrap>&nbsp;<cf_translate key="LB_Nombre">Nombre</cf_translate></td>
			<td nowrap>&nbsp;<cf_translate key="LB_Dias">D&iacute;as</cf_translate></td>
			<td nowrap>&nbsp;<cf_translate key="LB_DiasSeptimo">D&iacute;as<br>S&eacute;ptimo</cf_translate></td>
			<td nowrap>&nbsp;<cf_translate key="LB_DiasBonificable">D&iacute;as<br>Bonificable</cf_translate></td>
			<td nowrap>&nbsp;<cf_translate key="LB_HorasExtraSin">Horas<br>Extra Sin</cf_translate></td>
			<td nowrap>&nbsp;<cf_translate key="LB_HorasExtraDob">Horas<br>Extra Dob</cf_translate></td>
			<td nowrap>&nbsp;<cf_translate key="LB_Ordinario">Ordinario</cf_translate></td>
			<td nowrap>&nbsp;<cf_translate key="LB_ExtraS">Extra S</cf_translate></td>
			<td nowrap>&nbsp;<cf_translate key="LB_ExtraD">Extra D</cf_translate></td>
			<td nowrap>&nbsp;<cf_translate key="LB_Septimo">S&eacute;ptimo</cf_translate></td>
			<td nowrap>&nbsp;<cf_translate key="LB_Bonificacion">Bonificaci&oacute;n</cf_translate></td>
			<td nowrap>&nbsp;<cf_translate key="LB_Comision">Comisi&oacute;n</cf_translate></td>
			<td nowrap>&nbsp;<cf_translate key="LB_Vacaciones">Vacaciones</cf_translate></td>
			<td nowrap>&nbsp;<cf_translate key="LB_Otros">Otros</cf_translate></td>
			<td nowrap align="center">&nbsp;<cf_translate key="LB_VariosIngresos">Varios<br>Ingresos</cf_translate></td>
			<td nowrap align="center">&nbsp;<cf_translate key="LB_TotalIngreso">Total<br>Ingreso</cf_translate></td>
			<td nowrap>&nbsp;<cf_translate key="LB_IGSS">IGSS</cf_translate></td>
			<td nowrap align="center">&nbsp;<cf_translate key="LB_AsocSolidarista">Asoc.<br>Solidarista</cf_translate></td>
			<td nowrap>&nbsp;<cf_translate key="LB_ISR">ISR</cf_translate></td>
			<td nowrap>&nbsp;<cf_translate key="LB_BanTrab">BanTrab</cf_translate></td>
			<td nowrap align="center">&nbsp;<cf_translate key="LB_VentasTienda">Ventas<br>/Tienda</cf_translate></td>
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
                    <td class="detallec" nowrap>&nbsp;</td>
                    <td class="detallec" nowrap>&nbsp;</td>
                    <td class="detallec" nowrap>&nbsp;</td>
                    <td class="detallec" nowrap>&nbsp;</td>
                    <td class="detaller" nowrap>#LSCurrencyFormat(Lvar_TotalOrd,'none')#</td>
                    <td class="detaller" nowrap>#LSCurrencyFormat(Lvar_TotalExtraS,'none')#</td>
                    <td class="detaller" nowrap>#LSCurrencyFormat(Lvar_TotalExtraD,'none')#</td>
                    <td class="detaller" nowrap>#LSCurrencyFormat(Lvar_TotalSept,'none')#</td>
                    <td class="detaller" nowrap>#LSCurrencyFormat(Lvar_TotalBono,'none')#</td>
					<td class="detaller" nowrap>#LSCurrencyFormat(Lvar_TotalComision,'none')#</td>
                    <td class="detaller" nowrap>#LSCurrencyFormat(Lvar_TotalVaca,'none')#</td>
                    <td class="detaller" nowrap>#LSCurrencyFormat(Lvar_TotalOtros,'none')#</td>
                    <td class="detaller" nowrap>#LSCurrencyFormat(Lvar_TotalVariosInc,'none')#</td>
                    <td class="detaller" nowrap>#LSCurrencyFormat(Lvar_TotalIngresos,'none')#</td>
                    <td class="detaller" nowrap>#LSCurrencyFormat(Lvar_TotalIGSS,'none')#</td>
                    <td class="detaller" nowrap>#LSCurrencyFormat(Lvar_TotalAsoc,'none')#</td>
                    <td class="detaller" nowrap>#LSCurrencyFormat(Lvar_TotalISR,'none')#</td>
                    <td class="detaller" nowrap>#LSCurrencyFormat(Lvar_TotalBanT,'none')#</td>
                   	<td class="detaller" nowrap>#LSCurrencyFormat(Lvar_TotalVentasTienda,'none')#</td>
                    <td class="detaller" nowrap>#LSCurrencyFormat(Lvar_TotalAnticipos,'none')#</td>
                    <td class="detaller" nowrap>#LSCurrencyFormat(Lvar_TotalVariosDesc,'none')#</td>
                    <td class="detaller" nowrap>#LSCurrencyFormat(Lvar_TotalDesc,'none')#</td>
                    <td class="detaller" nowrap>#LSCurrencyFormat(Lvar_TotalLiquido,'none')#</td>
                </tr>
				<cfsilent>
					<cfset Lvar_TotalOrd 		  	= 0>
						<cfset Lvar_TotalExtraS   	= 0>
						<cfset Lvar_TotalExtraD   	= 0>
						<cfset Lvar_TotalSept 	 	= 0>
						<cfset Lvar_TotalBono 	  	= 0>
						<cfset Lvar_TotalComision 	= 0>
						<cfset Lvar_TotalVaca 	  	= 0>
						<cfset Lvar_TotalOtros 	  	= 0>
						<cfset Lvar_TotalVariosInc	= 0>
						<cfset Lvar_TotalIngresos 	= 0>
						<cfset Lvar_TotalIGSS 	  	= 0>
						<cfset Lvar_TotalAsoc 	  	= 0>
						<cfset Lvar_TotalISR 	 	= 0>
						<cfset Lvar_TotalBanT     	= 0>
						<cfset Lvar_TotalVentasTienda = 0>
						<cfset Lvar_TotalAnticipos	= 0>
						<cfset Lvar_TotalVariosDesc = 0>
						<cfset Lvar_TotalDesc 		= 0>
						<cfset Lvar_TotalLiquido 	= 0>
				</cfsilent>
			
			<tr class="listaCorte1"><td colspan="26">#CFcodigo#&nbsp;-&nbsp;#CFdescripcion#</td></tr>
            <tr><td height="1" bgcolor="000000" colspan="26"></td>
            <tr class="listaCorte3" valign="bottom">
            	<td nowrap ><cf_translate key="LB_Codigo">C&oacute;digo</cf_translate></td>
                <td nowrap>&nbsp;<cf_translate key="LB_Nombre">Nombre</cf_translate></td>
				<td nowrap>&nbsp;<cf_translate key="LB_Dias">D&iacute;as</cf_translate></td>
				<td nowrap>&nbsp;<cf_translate key="LB_Septimo">S&eacute;ptimo</cf_translate></td>
				<td nowrap>&nbsp;<cf_translate key="LB_Bonificable">Bonificable</cf_translate></td>
				<td nowrap>&nbsp;<cf_translate key="LB_ExtraSin">Extra Sin</cf_translate></td>
				<td nowrap>&nbsp;<cf_translate key="LB_ExtraDob">Extra Dob</cf_translate></td>
                <td nowrap>&nbsp;<cf_translate key="LB_Ordinario">Ordinario</cf_translate></td>
                <td nowrap>&nbsp;<cf_translate key="LB_ExtraS">Extra S</cf_translate></td>
                <td nowrap>&nbsp;<cf_translate key="LB_ExtraD">Extra D</cf_translate></td>
                <td nowrap>&nbsp;<cf_translate key="LB_Septimo">S&eacute;ptimo</cf_translate></td>
                <td nowrap>&nbsp;<cf_translate key="LB_Bonificacion">Bonificaci&oacute;n</cf_translate></td>
				<td nowrap>&nbsp;<cf_translate key="LB_Comision">Comisi&oacute;n</cf_translate></td>
                <td nowrap>&nbsp;<cf_translate key="LB_Vacaciones">Vacaciones</cf_translate></td>
                <td nowrap>&nbsp;<cf_translate key="LB_Otros">Otros</cf_translate></td>
                <td nowrap align="center">&nbsp;<cf_translate key="LB_VariosIngresos">Varios<br>Ingresos</cf_translate></td>
                <td nowrap align="center">&nbsp;<cf_translate key="LB_TotalIngreso">Total<br>Ingreso</cf_translate></td>
                <td nowrap>&nbsp;<cf_translate key="LB_IGSS">IGSS</cf_translate></td>
                <td nowrap align="center">&nbsp;<cf_translate key="LB_AsocSolidarista">Asoc.<br>Solidarista</cf_translate></td>
                <td nowrap>&nbsp;<cf_translate key="LB_ISR">ISR</cf_translate></td>
                <td nowrap>&nbsp;<cf_translate key="LB_BanTrab">BanTrab</cf_translate></td>
                <td nowrap align="center">&nbsp;<cf_translate key="LB_VentasTienda">Ventas<br>/Tienda</cf_translate></td>
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
                    <td class="detallec" nowrap>#LSNumberFormat(DiasSeptimo,'999')#</td>
                    <td class="detallec" nowrap>#LSNumberFormat(DiasBonifica,'999')#</td>
                    <td class="detallec" nowrap>#LSNumberFormat(HorasExtraS,'999')#</td>
                    <td class="detallec" nowrap>#LSNumberFormat(HorasExtraD,'999')#</td>
                    <td class="detaller" nowrap>#LSCurrencyFormat(Ordinario,'none')#</td>
                    <td class="detaller" nowrap>#LSCurrencyFormat(ExtraS,'none')#</td>
                    <td class="detaller" nowrap>#LSCurrencyFormat(ExtraD,'none')#</td>
                    <td class="detaller" nowrap>#LSCurrencyFormat(Septimo,'none')#</td>
                    <td class="detaller" nowrap>#LSCurrencyFormat(Bonifica,'none')#</td>
					<td class="detaller" nowrap>#LSCurrencyFormat(Comision,'none')#</td>
                    <td class="detaller" nowrap>#LSCurrencyFormat(Vacaciones,'none')#</td>
                    <td class="detaller" nowrap>#LSCurrencyFormat(Otros,'none')#</td>
                    <td class="detaller" nowrap>#LSCurrencyFormat(VariosInc,'none')#</td>
                    <td class="detaller" nowrap>#LSCurrencyFormat(TotalIngresos,'none')#</td>
                    <td class="detaller" nowrap>#LSCurrencyFormat(IGSS,'none')#</td>
                    <td class="detaller" nowrap>#LSCurrencyFormat(Asoc,'none')#</td>
                    <td class="detaller" nowrap>#LSCurrencyFormat(ISR,'none')#</td>
                    <td class="detaller" nowrap>#LSCurrencyFormat(BanTrab,'none')#</td>
                   	<td class="detaller" nowrap>#LSCurrencyFormat(VentasTienda,'none')#</td>
                    <td class="detaller" nowrap>#LSCurrencyFormat(Anticipo,'none')#</td>
                    <td class="detaller" nowrap>#LSCurrencyFormat(VariosDesc,'none')#</td>
                    <td class="detaller" nowrap>#LSCurrencyFormat(TotalDesc,'none')#</td>
                    <td class="detaller" nowrap>#LSCurrencyFormat(Liquido,'none')#</td>
                </tr>
				<cfsilent>
					<cfset Lvar_TotalOrd 	= Lvar_TotalOrd + Ordinario>
					<cfset Lvar_TotalExtraS = Lvar_TotalExtraS + ExtraS>
					<cfset Lvar_TotalExtraD = Lvar_TotalExtraD + ExtraD>
					<cfset Lvar_TotalSept 	= Lvar_TotalSept + Septimo>
					<cfset Lvar_TotalBono 	= Lvar_TotalBono + Bonifica>
					<cfset Lvar_TotalComision = Lvar_TotalComision + Comision>
					<cfset Lvar_TotalVaca 	= Lvar_TotalVaca + Vacaciones>
					<cfset Lvar_TotalOtros 	= Lvar_TotalOtros + Otros>
					<cfset Lvar_TotalVariosInc 	= Lvar_TotalVariosInc + VariosInc>
					<cfset Lvar_TotalIngresos 	= Lvar_TotalIngresos + TotalIngresos>
					<cfset Lvar_TotalIGSS 	= Lvar_TotalIGSS + IGSS>
					<cfset Lvar_TotalAsoc 	= Lvar_TotalAsoc + Asoc>
					<cfset Lvar_TotalISR 	= Lvar_TotalISR + ISR>
					<cfset Lvar_TotalBanT 	= Lvar_TotalBanT + BanTrab>
					<cfset Lvar_TotalVentasTienda = Lvar_TotalVentasTienda + VentasTienda>
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
				<td class="detallec" nowrap>&nbsp;</td>
				<td class="detallec" nowrap>&nbsp;</td>
				<td class="detallec" nowrap>&nbsp;</td>
				<td class="detallec" nowrap>&nbsp;</td>
				<td class="detaller" nowrap>#LSCurrencyFormat(Lvar_TotalOrd,'none')#</td>
				<td class="detaller" nowrap>#LSCurrencyFormat(Lvar_TotalExtraS,'none')#</td>
				<td class="detaller" nowrap>#LSCurrencyFormat(Lvar_TotalExtraD,'none')#</td>
				<td class="detaller" nowrap>#LSCurrencyFormat(Lvar_TotalSept,'none')#</td>
				<td class="detaller" nowrap>#LSCurrencyFormat(Lvar_TotalBono,'none')#</td>
				<td class="detaller" nowrap>#LSCurrencyFormat(Lvar_TotalComision,'none')#</td>
				<td class="detaller" nowrap>#LSCurrencyFormat(Lvar_TotalVaca,'none')#</td>
				<td class="detaller" nowrap>#LSCurrencyFormat(Lvar_TotalOtros,'none')#</td>
				<td class="detaller" nowrap>#LSCurrencyFormat(Lvar_TotalVariosInc,'none')#</td>
				<td class="detaller" nowrap>#LSCurrencyFormat(Lvar_TotalIngresos,'none')#</td>
				<td class="detaller" nowrap>#LSCurrencyFormat(Lvar_TotalIGSS,'none')#</td>
				<td class="detaller" nowrap>#LSCurrencyFormat(Lvar_TotalAsoc,'none')#</td>
				<td class="detaller" nowrap>#LSCurrencyFormat(Lvar_TotalISR,'none')#</td>
				<td class="detaller" nowrap>#LSCurrencyFormat(Lvar_TotalBanT,'none')#</td>
				<td class="detaller" nowrap>#LSCurrencyFormat(Lvar_TotalVentasTienda,'none')#</td>
				<td class="detaller" nowrap>#LSCurrencyFormat(Lvar_TotalAnticipos,'none')#</td>
				<td class="detaller" nowrap>#LSCurrencyFormat(Lvar_TotalVariosDesc,'none')#</td>
				<td class="detaller" nowrap>#LSCurrencyFormat(Lvar_TotalDesc,'none')#</td>
				<td class="detaller" nowrap>#LSCurrencyFormat(Lvar_TotalLiquido,'none')#</td>
			</tr>
			</cfoutput>
    </table>
<cfelse>
	<table width="100%" border="0" cellpadding="2" cellspacing="0" align="center">
    	<tr class="titulo_empresa2"><td align="center">No se han definido las columnas del reporte.</td></tr>
    </table>
</cfif>