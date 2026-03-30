<cfsetting requesttimeout="36000">
<cfquery name="rsVerificaReporte" datasource="#session.DSN#">
	select 1
    from RHReportesNomina
    where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
      and RHRPTNcodigo = 'LSA'
</cfquery>
<!--- Busca el nombre de la Empresa --->
<cfquery name="rsEmpresa" datasource="#session.DSN#">
	select Edescripcion
	from Empresas
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
</cfquery>


<style>
<!--- CLASES DE FORMATO --->
	.titulo_empresa2F {
		font-size:16px;
		font-weight:bold;
		text-align:center;}
	.tituloEmpresaPF {
		font-size:11px;
		text-align:center;}
	.tituloEmpresaPBF {
		font-size:11px;
		font-weight:bold;
		text-align:center;}
	<!--- BORDES --->
   	<!--- Bordes linea  arriba --->
   	.Lin_TOPF {
     border-top-width: 1px;
     border-top-style: solid;
     border-top-color: #000000;
     border-right-style: none;
     border-bottom-style: none;
     border-left-style: none;
    }
   <!--- ARRIBA ABAJO IZQUIERDA ---> 
   	.Lin_BOT_IZQ_TOPF {
	border-bottom-width: 1px;
	border-bottom-style: solid;
	border-bottom-color: #000000;
	border-left-width: 1px;
	border-left-style: solid;
	border-left-color: #000000;
	border-top-width: 1px;
	border-top-style: solid;
	border-top-color: #000000;
   } 
	.tituloColumnF {
	font-size:9px;
	font-weight:bold;
	background-color:  #E8E8E8;
	text-align:center;}
   <!--- Bordes linea  izquierda,arriba --->
   .Lin_IZQ_TOPF {
	border-bottom-width: none;
	border-left-width: 1px;
	border-left-style: solid;
	border-left-color: #000000;
	border-top-width: 1px;
	border-top-style: solid;
	border-top-color: #000000 ;
   }
   <!--- Bordes linea  derecha,izquierda,arriba,abajo --->
   .Lin_DER_IZQ_TOP_BOTF {
	border-bottom-width: 1px;
	border-bottom-style: solid;
	border-bottom-color: #000000;
	border-right-width: 1px;
	border-right-style: solid;
	border-right-color: #000000;
	border-left-width: 1px;
	border-left-style: solid;
	border-left-color: #000000;
	border-top-width: 1px;
	border-top-style: solid;
	border-top-color: #000000 ;
   }
<!--- FIN CLASES DEL FORMATO --->
<!--- CLASES DE DISPLAY --->
	@media print {
	.noImpr { visibility:hidden;}
	.titulo_empresa2 {
		font-size:16px;
		font-weight:bold;
		text-align:center; 
		visibility:hidden;}
	.tituloEmpresaPB {
		font-size:11px;
		font-weight:bold;
		text-align:center;
		visibility:hidden;}
	.tituloColumn {
		font-size:9px;
		font-weight:bold;
		background-color:  #E8E8E8;
		text-align:center;
		visibility:hidden;}

   <!--- Bordes linea  arriba --->
   .Lin_TOP {
		 border-top-width: 1px;
		 border-top-style: solid;
		 border-top-color: #000000;
		 border-right-style: none;
		 border-bottom-style: none;
		 border-left-style: none;
		visibility:hidden;   
		}
   <!--- ARRIBA ABAJO IZQUIERDA ---> 
   .Lin_BOT_IZQ_TOP {
		border-bottom-width: 1px;
		border-bottom-style: solid;
		border-bottom-color: #000000;
		border-left-width: 1px;
		border-left-style: solid;
		border-left-color: #000000;
		border-top-width: 1px;
		border-top-style: solid;
		border-top-color: #000000;
		visibility:hidden;   
	   } 
	 <!--- Bordes linea  izquierda,arriba --->
	.Lin_IZQ_TOP {
		border-bottom-width: none;
		border-left-width: 1px;
		border-left-style: solid;
		border-left-color: #000000;
		border-top-width: 1px;
		border-top-style: solid;
		border-top-color: #000000 ;
		visibility:hidden;     
	   }
   <!--- Bordes linea  derecha,izquierda,arriba,abajo --->
   .Lin_DER_IZQ_TOP_BOT {
		border-bottom-width: 1px;
		border-bottom-style: solid;
		border-bottom-color: #000000;
		border-right-width: 1px;
		border-right-style: solid;
		border-right-color: #000000;
		border-left-width: 1px;
		border-left-style: solid;
		border-left-color: #000000;
		border-top-width: 1px;
		border-top-style: solid;
		border-top-color: #000000 ;
		visibility:hidden;     
	   }
	}
	.titulo_empresa2 {
		font-size:16px;
		font-weight:bold;
		text-align:center;}

	.tituloEmpresaP {
		font-size:11px;
		text-align:center;}
	.tituloEmpresaPB {
		font-size:11px;
		font-weight:bold;
		text-align:center;}
	.tituloColumn {
		font-size:9px;
		font-weight:bold;
		background-color:  #E8E8E8;
		text-align:center;}
   <!--- Bordes linea  arriba --->
   .Lin_TOP {
		 border-top-width: 1px;
		 border-top-style: solid;
		 border-top-color: #000000;
		 border-right-style: none;
		 border-bottom-style: none;
		 border-left-style: none;
		}
   <!--- ARRIBA ABAJO IZQUIERDA ---> 
   .Lin_BOT_IZQ_TOP {
		border-bottom-width: 1px;
		border-bottom-style: solid;
		border-bottom-color: #000000;
		border-left-width: 1px;
		border-left-style: solid;
		border-left-color: #000000;
		border-top-width: 1px;
		border-top-style: solid;
		border-top-color: #000000;
	   } 
	 <!--- Bordes linea  izquierda,arriba --->
	.Lin_IZQ_TOP {
		border-bottom-width: none;
		border-left-width: 1px;
		border-left-style: solid;
		border-left-color: #000000;
		border-top-width: 1px;
		border-top-style: solid;
		border-top-color: #000000 ;
	   }
   <!--- Bordes linea  derecha,izquierda,arriba,abajo --->
   .Lin_DER_IZQ_TOP_BOT {
		border-bottom-width: 1px;
		border-bottom-style: solid;
		border-bottom-color: #000000;
		border-right-width: 1px;
		border-right-style: solid;
		border-right-color: #000000;
		border-left-width: 1px;
		border-left-style: solid;
		border-left-color: #000000;
		border-top-width: 1px;
		border-top-style: solid;
		border-top-color: #000000 ;
	   }
   .Lin_IZQ_BOT {
		border-bottom-width: none;
		border-left-width: 1px;
		border-left-style: solid;
		border-left-color: #000000;
		border-bottom-width: 1px;
		border-bottom-style: solid;
		border-bottom-color: #000000 ;
	   }
   <!--- Bordes linea  abajo,derecha,izquierda --->
   .Lin_DER_IZQ__BOT {
		border-top-width: none;
		border-left-width: 1px;
		border-left-style: solid;
		border-left-color: #000000;
		border-right-width: 1px;
		border-right-style: solid;
		border-right-color: #000000;
		border-bottom-width: 1px;
		border-bottom-style: solid;
		border-bottom-color: #000000  ;
	   }
<!--- FIN CLASES DE DISPLAY --->
</style>

<cfif isdefined('rsVerificaReporte') and rsVerificaReporte.RecordCount>
<!--- VARIABLES DE TRADUCCION --->
<cfinvoke key="LB_LibroDeSalarios" default="Libro de Salarios" returnvariable="LB_LibroDeSalarios" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_NoHayDatosRelacionados" default="No hay datos relacionados" returnvariable="LB_NoHayDatosRelacionados" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_Fecha" default="Fecha" returnvariable="LB_Fecha" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_FechaRige" default="Fecha Rige" returnvariable="LB_FechaRige"  component="sif.Componentes.Translate" method="Translate" />
<cfinvoke key="LB_FechaVence" default="Fecha Vence" returnvariable="LB_FechaVence" component="sif.Componentes.Translate" method="Translate"/>
<!--- FIN VARIABLES DE TRADUCCION --->
<cfif not isdefined('url.formatoImp')>
<!--- Tabla temporal de resultados --->
	<cf_dbtemp name="salidaLibrosAut" returnvariable="salida">
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
		<cf_dbtempcol name="Vacaciones"		type="money"    mandatory="no">
		<cf_dbtempcol name="Septimo" 		type="money"    mandatory="no">
		<cf_dbtempcol name="IGSS" 			type="money"    mandatory="no">
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
 				and CPperiodo = <cf_dbfunction name="date_part"   args="yyyy, CPhasta">
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
											where c.RHRPTNcodigo = 'LSA'
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
											where c.RHRPTNcodigo = 'LSA'
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
														where c.RHRPTNcodigo = 'LSA'
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
														where c.RHRPTNcodigo = 'LSA'
														  and c.Ecodigo = #session.Ecodigo#)),0.00)
								
								
								)
    </cfquery> 
	<!--- MONTOS ADICIONALES QUE SE TIENEN QUE INCLUIR, COMO DEDUCCIONES SOBRE SALARIOS NO DEVENGADOS --->
	<cfquery name="rsHorasExtra" datasource="#session.DSN#">
    	update #salida#
        set Ordinario = Ordinario + coalesce((	select sum(a.DCvalor) 
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
														  and c.Ecodigo = #session.Ecodigo#)),0.00)
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
											where c.RHRPTNcodigo = 'LSA'
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
														where c.RHRPTNcodigo = 'LSA'
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
														where c.RHRPTNcodigo = 'LSA'
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
								)
								</cfif>
								and CIid in (select distinct a.CIid
											from RHReportesNomina c
												inner join RHColumnasReporte b
															inner join RHConceptosColumna a
															on a.RHCRPTid = b.RHCRPTid
													 on b.RHRPTNid = c.RHRPTNid
													and b.RHCRPTcodigo = 'HorasExtraA'
											where c.RHRPTNcodigo = 'LSA'
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
														where c.RHRPTNcodigo = 'LSA'
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
														where c.RHRPTNcodigo = 'LSA'
														  and c.Ecodigo = #session.Ecodigo#)),0.00)
								
								
								)
    </cfquery>
    <!--- HORAS EXTRA B --->
	<!--- SUMA DE TODOS LOS MONTOS PAGADOS POR INCIDENCIAS INDICADAS PARA LA COLUMNA EXTRASS
			EN LA CONFIGURACION DEL REPORTE QUE SEAN FERIADOS NI DIAS LIBRES  --->
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
											where c.RHRPTNcodigo = 'LSA'
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
								) or exists(select  1
												from LineaTiempo c, RHJornadas e,RHDJornadas f
												where c.DEid = #salida#.DEid
												  and a.ICfecha between c.LTdesde and c.LThasta
												  and e.RHJid = c.RHJid
												  and f.RHJid = e.RHJid
												  and f.RHDJdia = to_char(a.ICfecha,'d')
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
								) or exists(select  1
												from LineaTiempo c
												inner join RHJornadas e
												  on e.RHJid = c.RHJid
												inner join RHDJornadas f
												  on f.RHJid = e.RHJid
												  and f.RHDJdia = datepart(dd,a.ICfecha)
												where c.DEid = #salida#.DEid
												  and a.ICfecha between c.LTdesde and c.LThasta
								) 
								
								)
								</cfif>
								and CIid in (select distinct a.CIid
											from RHReportesNomina c
												inner join RHColumnasReporte b
															inner join RHConceptosColumna a
															on a.RHCRPTid = b.RHCRPTid
													 on b.RHRPTNid = c.RHRPTNid
													and b.RHCRPTcodigo = 'HorasExtraB'
											where c.RHRPTNcodigo = 'LSA'
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
											where c.RHRPTNcodigo = 'LSA'
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
														where c.RHRPTNcodigo = 'LSA'
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
														where c.RHRPTNcodigo = 'LSA'
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
								where c.RHRPTNcodigo = 'LSA'
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
										where c.RHRPTNcodigo = 'LSA'
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
										where c.RHRPTNcodigo = 'LSA'
										  and c.Ecodigo = #session.Ecodigo#)),0.00)
				
				
				)	
    </cfquery>
    <!--- VACACIONES --->
    <cfquery name="rsOtros" datasource="#session.DSN#">
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
								where c.RHRPTNcodigo = 'LSA'
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
												and b.RHCRPTcodigo = 'Vacaciones'
										where c.RHRPTNcodigo = 'LSA'
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
										where c.RHRPTNcodigo = 'LSA'
										  and c.Ecodigo = #session.Ecodigo#)),0.00)
				
				
				)
    </cfquery>
    <!--- SEPTIMO --->
	<cfquery name="rsSeptimo" datasource="#session.DSN#">
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
								where c.RHRPTNcodigo = 'LSA'
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
										where c.RHRPTNcodigo = 'LSA'
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
										where c.RHRPTNcodigo = 'LSA'
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
								where c.RHRPTNcodigo = 'LSA'
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
											where c.RHRPTNcodigo = 'LSA'
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
													where c.RHRPTNcodigo = 'LSA'
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
            Septimo 	= Septimo + coalesce((select sum(Septimo) from #salida# x where x.CPtipo = 1 and x.CPperiodo = #salida#.CPperiodo and x.CPmes = #salida#.CPmes and x.DEid = #salida#.DEid),0),
            IGSS	 	= IGSS + coalesce((select sum(IGSS) from #salida# x where x.CPtipo = 1 and x.CPperiodo = #salida#.CPperiodo and x.CPmes = #salida#.CPmes and x.DEid = #salida#.DEid),0),
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
        set MontoBruto = Ordinario + Bonifica + ExtrasS + ExtrasD + Aguinaldo + Vacaciones + Septimo 
    </cfquery>

	<cfinclude template="ReporteLibroSalariosAut-Ceses.cfm">
	<cfquery name="rsInsertaCese" datasource="#session.DSN#">
		insert into #salida#(RCNid, DEid, CPcodigo,CPtipo, RCdesde, RChasta, 
								 ExtrasS, ExtrasD, Aguinaldo,  
								 Vacaciones, OtrosDesc,Dias,HorasExtra,
								 Ordinario,Bonifica,Septimo,MontoLiquido,MontoBruto,IGSS)
		select DLlinea, DEid, CPcodigo,CPtipo, RCdesde, RChasta, ExtrasS, ExtrasD, Aguinaldo,  
		Vacaciones, OtrosDesc,0,0,0,0,0,0,0,0
		from #salidaCese#
	</cfquery>
		
	 <cfset fecha = Now()>
	<cfquery name="rsReporte" datasource="#session.DSN#">
		select s.DEid,DEidentificacion,
				{fn concat(DEobs1,{fn concat(' ',DEobs2)})} as CedVec,
				{fn concat(DEnombre,{fn concat(' ',{fn concat(DEapellido1,{fn concat(' ',DEapellido2)})})})} as NombreEmp,
				Pnombre,  
				<cf_dbfunction name="datediff" args="DEfechanac,#fecha#,yy"> as Edad,
				DEsexo,DEdato1 as NumeroIGSS,
				CPmes,CPperiodo,s.Tcodigo,
				sum(s.Ordinario) as Ordinario,
				sum(Dias) as Dias,
				sum(HorasExtra) as HorasExtra,
				sum(ExtrasS) as ExtrasS,
				sum(ExtrasD) as ExtrasD,
				sum(Septimo) as Septimo,
				sum(Vacaciones) as Vacaciones,
				sum(IGSS) as IGSS,
				sum(OtrosDesc) as OtrosDesc,
				sum(Aguinaldo) as Aguinaldo,
				sum(Bonifica) as Bonifica
		from #salida# s
        inner join DatosEmpleado de
			on de.DEid = s.DEid 
		inner join Pais p
			on p.Ppais = de.Ppais
        where CPtipo <> 1
		group by s.DEid,DEidentificacion,{fn concat(DEobs1,{fn concat(' ',DEobs2)})},
				{fn concat(DEnombre,{fn concat(' ',{fn concat(DEapellido1,{fn concat(' ',DEapellido2)})})})},
				Pnombre,  
				<cf_dbfunction name="datediff" args="DEfechanac,#fecha#,yy">,
				DEsexo,DEdato1,
				CPmes,CPperiodo,s.Tcodigo
		order by DEidentificacion,CPperiodo,CPmes
	</cfquery>
	

    <!--- FIN DE RECOLECCION DE DATOS DEL REPORTE --->
    <table width="900" border="0" cellpadding="2" cellspacing="0" align="center" style="border-color:CCCCCC">
		<cfif rsReporte.REcordCount>
        <cfoutput query="rsReporte" group="DEid">
			<cfquery name="DatosPuesto" datasource="#session.DSN#">
				select RHPdescpuesto as Puesto
				from LineaTiempo a
				inner join RHPlazas b
					  on b.RHPid = a.RHPid
					  and b.Ecodigo = a.Ecodigo
				inner join RHPuestos c
					  on c.RHPcodigo = b.RHPpuesto
				where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
				  and a.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsREporte.DEid#">
				  and a.LThasta = (select max(LThasta)
									from LineaTiempo
									where Ecodigo = a.Ecodigo
									  and DEid = a.DEid)
			</cfquery>
			<cfquery name="FechaIngreso" datasource="#session.DSN#">
				select EVfantig as FechaIngreso
				from EVacacionesEmpleado 
				where DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsReporte.DEid#">
			</cfquery>
			<cfquery name="FechaTerminaC" datasource="#session.DSN#">
				select min(DLfvigencia) as Fecha
				 from DLaboralesEmpleado le, RHTipoAccion ta
				where le.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsREporte.DEid#">
				  and le.DLfvigencia <= <cfqueryparam cfsqltype="cf_sql_date" value="#url.Fhasta#">
				  and le.DLfvigencia > <cfqueryparam cfsqltype="cf_sql_date" value="#FechaIngreso.FechaIngreso#">
				  and ta.RHTid = le.RHTid
				  and ta.RHTcomportam = 2
			</cfquery>
			<!--- ENCABEZADO DEL REPORTE --->
		 	<tr>
				<td colspan="19" >
					<table width="900" cellpadding="0" cellspacing="7" border="0">
						<tr>
							<td width="800" class="titulo_empresa2"><div class="noImpr">#rsEmpresa.Edescripcion#</div></td>
							<td width="50" class="tituloEmpresaP" align="right"><div class="noImpr">Folio</div></td>
							<td width="50" class="tituloEmpresaP"></td>
						</tr>
						<tr><td colspan="3" height="20" style="font-size:11px;">#rsReporte.DEidentificacion#</td></tr>
						<tr>
							<td colspan="3" width="900">
								<table width="900">
									<tr class="tituloEmpresaP" height="20">
										<td width="300">#NombreEmp#</td>
										<td width="100">#Edad#</td>
										<td width="100"><cfif DEsexo EQ 'M'><cf_translate key="LB_Masculino">Masculino</cf_translate><cfelse><cf_translate key="LB_Femenino">Femenino</cf_translate></cfif></td>
										<td width="200">#PNombre#</td>
										<td width="200">#DatosPuesto.Puesto#</td>
									</tr>
									<tr align="center" class="tituloEmpresaPB">
										<td class="Lin_TOP"><div class="noImpr"><cf_translate key="LB_NombreDelEmpleado">Nombre del Empleado</cf_translate></div></td>
										<td class="Lin_TOP"><div class="noImpr"><cf_translate key="LB_Edad">Edad</cf_translate></div></td>
										<td class="Lin_TOP"><div class="noImpr"><cf_translate key="LB_Sexo">Sexo</cf_translate></div></td>
										<td class="Lin_TOP"><div class="noImpr"><cf_translate key="LB_Nacionalidad">Nacionalidad</cf_translate></div></td>
										<td class="Lin_TOP"><div class="noImpr"><cf_translate key="LB_Ocupacion">Ocupaci&oacute;n</cf_translate></div></td>
									</tr>
								</table>
							</td>
						</tr>
						<tr><td colspan="3" height="20">&nbsp;</td></tr>
						<tr>
							<td colspan="3" width="900">
								<table width="900">
									<tr class="tituloEmpresaP" height="20">
										<td width="180">#NumeroIGSS#</td>
										<td width="180">#CedVec#</td>
										<td width="180">#LSDateFormat(FechaIngreso.FechaIngreso,'dd/mm/yyyy')#</td>
										<td width="180"><cfif isdefined('FechaTerminaC') and FechaTerminaC.RecordCount>#LSDateFormat(FechaTerminaC.Fecha,'dd/mm/yyyy')#</cfif></td>
										<td width="180">&nbsp;</td>
									</tr>
									<tr align="center"  class="tituloEmpresaPB" height="20">
										<td class="Lin_TOP"><div class="noImpr"><cf_translate key="LB_NumeroAfiliacionalIGSS">No. de afiliaci&oacute;n al IGSS</cf_translate></div></td>
										<td class="Lin_TOP"><div class="noImpr"><cf_translate key="LB_NumeroCedulaOPermiso">No. C&eacute;dula o Permiso</cf_translate></div></td>
										<td class="Lin_TOP"><div class="noImpr"><cf_translate key="LB_FechaDeIngreso">Fecha de Ingreso</cf_translate></div></td>
										<td class="Lin_TOP"><div class="noImpr"><cf_translate key="LB_FechaDeTerminacionDelContrato">Fecha de Terminaci&oacute;n del Contrato</cf_translate></div></td>
										<td>&nbsp;</td>
									</tr>
								</table>
							</td>
						</tr>
					</table>
				</td>
			</tr>
			<!--- FIN ENCABEZADO --->
            <!--- <tr><td height="1" bgcolor="000000" colspan="19"></td> --->
			<tr  class="tituloColumn">
				<td class="Lin_BOT_IZQ_TOP" rowspan="2"><cf_translate key="LB_NumeroOrden">No. Orden</cf_translate></td>
				<td class="Lin_BOT_IZQ_TOP" rowspan="2"><cf_translate key="LB_PeriodoTrabajo">Periodo<br>de<br>Trab</cf_translate></td>
				<td class="Lin_BOT_IZQ_TOP" rowspan="2"><cf_translate key="LB_SalarioEnQuetzakes">Salario<br>en<br>Quetzales</cf_translate></td>
				<td class="Lin_BOT_IZQ_TOP" rowspan="2"><cf_translate key="LB_Sueldo">D&iacute;as Trab.</cf_translate></td>
				<td class="Lin_IZQ_TOP" colspan="2" nowrap="nowrap"><cf_translate key="LB_HorasTRabajadas">HORAS TRABAJADAS</cf_translate></td>
				<td class="Lin_IZQ_TOP" colspan="4"><cf_translate key="LB_SalarioDevengado">SALARIO DEVENGADO</cf_translate></td>
				<td class="Lin_BOT_IZQ_TOP" rowspan="2"><cf_translate key="LB_SalarioTotal">Salario<br>Total</cf_translate></td>
				<td class="Lin_IZQ_TOP" colspan="3" nowrap="nowrap"><cf_translate key="LB_DeduccionesLegales">DEDUCCIONES LEGALES</cf_translate></td>
				<td class="Lin_BOT_IZQ_TOP" align="center" rowspan="2"><cf_translate key="LB_AguinaldoOtros">Decreto 42/92 Aguinaldo y otros</cf_translate></td>
				<td class="Lin_BOT_IZQ_TOP" align="center" rowspan="2"><cf_translate key="LB_BonigicacionIncentivos">Bonificaci&oacute;n Incetivo</cf_translate></td>
				<td class="Lin_BOT_IZQ_TOP" rowspan="2"><cf_translate key="LB_LiquidoARecibir">L&iacute;quido<br> a Recibir</cf_translate></td>
				<td class="Lin_BOT_IZQ_TOP" rowspan="2"><cf_translate key="LB_Firma">Firma</cf_translate></td>
				<td class="Lin_DER_IZQ_TOP_BOT" rowspan="2"><cf_translate key="LB_Observaciones">Observaciones</cf_translate></td>
			</tr>
				<tr class="tituloColumn">
				<td class="Lin_BOT_IZQ_TOP"><cf_translate key="LB_Ordinarias">Ordinarias</cf_translate></td>
				<td class="Lin_BOT_IZQ_TOP"><cf_translate key="LB_Extraordinarias">Extra ordinarias</cf_translate></td>
				<td class="Lin_BOT_IZQ_TOP"><cf_translate key="LB_Ordinario">Ordinario</cf_translate></td>
				<td class="Lin_BOT_IZQ_TOP"><cf_translate key="LB_ExtraOrdinario">Extra ordinario</cf_translate></td>
				<td class="Lin_BOT_IZQ_TOP"><cf_translate key="LB_SetimosYAsuetos">Septimos Asuetos</cf_translate></td>
				<td class="Lin_BOT_IZQ_TOP"><cf_translate key="LB_Vacaciones">Vacaciones</cf_translate></td>
				<td class="Lin_BOT_IZQ_TOP"><cf_translate key="LB_IGSS">IGSS</cf_translate></td>
				<td class="Lin_BOT_IZQ_TOP"><cf_translate key="LB_OtrasDeduccionesLed">Otras Deduc Leg.</cf_translate></td>
				<td class="Lin_BOT_IZQ_TOP"><cf_translate key="LB_TotalDeducciones">Total Deducciones</cf_translate></td>
			</tr>
          <cfsilent>
            	<cfset Lvar_Count 		= 0>
				<cfset Lvar_TotalDias 	= 0>
				<cfset Lvar_TotalHorasO = 0>
                <cfset Lvar_TotalHorasE = 0>
                <cfset Lvar_TotalOrd 	= 0>
                <cfset Lvar_TotalExtra  = 0>
                <cfset Lvar_TotalSept 	= 0>
                <cfset Lvar_TotalVacaciones = 0>
                <cfset Lvar_TotalSal 	= 0>
                <cfset Lvar_TotalIGSS 	= 0>
                <cfset Lvar_TotalOtrosD = 0>
                <cfset Lvar_TotalDeduc 	= 0>
                <cfset Lvar_TotalAgui 	= 0>
                <cfset Lvar_TotalBono 	= 0>
                <cfset Lvar_TotalLiq 	= 0>
				<cfset Lvar_Total	 	= 0>
            </cfsilent>
            <cfoutput>
				<cfset Lvar_SalarioTotal = Ordinario+ExtrasD+ExtrasS+Septimo+Vacaciones>
				<cfset Lvar_DesduccTotal = IGSS+OtrosDesc>
				<cfset Lvar_TotalLiq = Lvar_SalarioTotal - Lvar_DesduccTotal + Aguinaldo + Bonifica>
				 <tr>
                    <td width="15" class="Lin_IZQ_BOT" style="font-size:9px;text-align:center;" nowrap>#CurrentRow#</td>
                    <td width="50" class="Lin_IZQ_BOT" style="font-size:9px;text-align:left;" nowrap>#IIf(len(trim(CPmes)) LT 2,'0','""')##CPmes#-#CPperiodo#</td>
                    <td width="55" class="Lin_IZQ_BOT" style="font-size:9px;text-align:right;" nowrap>#LSCurrencyFormat(Ordinario,'none')#</td>
                    <td width="20" class="Lin_IZQ_BOT" style="font-size:9px;text-align:center;" nowrap>#Dias#</td>
                    <td width="40" class="Lin_IZQ_BOT" style="font-size:9px;text-align:center;" nowrap>#Dias*8#</td>
                    <td width="40" class="Lin_IZQ_BOT" style="font-size:9px;text-align:right;" nowrap>#HorasExtra#</td>
                    <td width="60" class="Lin_IZQ_BOT" style="font-size:9px;text-align:right;" nowrap>#LSCurrencyFormat(Ordinario,'none')#</td>
                    <td width="50" class="Lin_IZQ_BOT" style="font-size:9px;text-align:right;" nowrap>#LSCurrencyFormat(ExtrasD+ExtrasS,'none')#</td>
                    <td width="50" class="Lin_IZQ_BOT" style="font-size:9px;text-align:right;" nowrap>#LSCurrencyFormat(Septimo,'none')#</td>
                    <td width="50" class="Lin_IZQ_BOT" style="font-size:9px;text-align:right;" nowrap>#LSCurrencyFormat(Vacaciones,'none')#</td>
                    <td width="60" class="Lin_IZQ_BOT" style="font-size:9px;text-align:right;" nowrap>#LSCurrencyFormat(Lvar_SalarioTotal,'none')#</td>
                    <td width="45" class="Lin_IZQ_BOT" style="font-size:9px;text-align:right;" nowrap>#LSCurrencyFormat(IGSS,'none')#</td>
                    <td width="45" class="Lin_IZQ_BOT" style="font-size:9px;text-align:right;" nowrap>#LSCurrencyFormat(OtrosDesc,'none')#</td>
                    <td width="50" class="Lin_IZQ_BOT" style="font-size:9px;text-align:right;" nowrap>#TRIM(LSCurrencyFormat(Lvar_DesduccTotal,'none'))#</td>
                    <td width="55" class="Lin_IZQ_BOT" style="font-size:9px;text-align:right;" nowrap>#LSCurrencyFormat(Aguinaldo,'none')#</td>
                    <td width="50" class="Lin_IZQ_BOT" style="font-size:9px;text-align:right;" nowrap>#LSCurrencyFormat(Bonifica,'none')#</td>
                    <td width="60" class="Lin_IZQ_BOT" style="font-size:9px;text-align:right;" nowrap>#LSCurrencyFormat(Lvar_TotalLiq,'none')#</td>
                    <td width="30" class="Lin_IZQ_BOT" style="font-size:9px;text-align:right;" nowrap>&nbsp;</td>
                    <td width="80" class="Lin_DER_IZQ__BOT" style="font-size:9px;text-align:right;" nowrap>&nbsp;</td>
                </tr>
                <!--- SUMA PARA LOS TOTALES --->
                <cfsilent>
                	<cfset Lvar_Count 		=  Lvar_Count + 1>
					<cfset Lvar_TotalDias 	=  Lvar_TotalDias + Dias>
					<cfset Lvar_TotalHorasO	=  Lvar_TotalHorasO + (Dias*8)>
                    <cfset Lvar_TotalHorasE =  Lvar_TotalHorasE + HorasExtra>
                    <cfset Lvar_TotalOrd 	=  Lvar_TotalOrd + Ordinario>
                    <cfset Lvar_TotalExtra  =  Lvar_TotalExtra + ExtrasS + ExtrasD>
                    <cfset Lvar_TotalSept 	=  Lvar_TotalSept + Septimo>
                    <cfset Lvar_TotalSal 	=  Lvar_TotalSal + Lvar_SalarioTotal>
                    <cfset Lvar_TotalVacaciones 	=  Lvar_TotalVacaciones + Vacaciones>
                    <cfset Lvar_TotalIGSS 	=  Lvar_TotalIGSS + IGSS>
                    <cfset Lvar_TotalOtrosD =  Lvar_TotalOtrosD + Lvar_DesduccTotal>
                    <cfset Lvar_TotalAgui 	=  Lvar_TotalAgui + Aguinaldo>
                    <cfset Lvar_TotalBono 	=  Lvar_TotalBono + Bonifica>
					<cfset Lvar_Total		=  Lvar_Total + Lvar_TotalLiq>
                </cfsilent>
				<cfset Lvar_RecActual = CurrentRow>
			</cfoutput>
            <tr>
                <td class="Lin_IZQ_BOT" style="font-size:10px;text-align:left;" nowrap colspan="2"><cf_translate key="LB_Sumas">Sumas</cf_translate></td>
                <!--- <td class="Lin_IZQ_BOT" style="font-size:10px;text-align:center;" nowrap>&nbsp;</td> --->
                <td class="Lin_IZQ_BOT" style="font-size:10px;text-align:right;" nowrap>#LSCurrencyFormat(Lvar_TotalOrd,'none')#</td>
                <td class="Lin_IZQ_BOT" style="font-size:10px;text-align:center;" nowrap>#Lvar_TotalDias#</td>
                <td class="Lin_IZQ_BOT" style="font-size:10px;text-align:center;" nowrap>#Lvar_TotalHorasO#</td>
                <td class="Lin_IZQ_BOT" style="font-size:10px;text-align:right;" nowrap>#Lvar_TotalHorasE#</td>
                <td class="Lin_IZQ_BOT" style="font-size:10px;text-align:right;" nowrap>#LSCurrencyFormat(Lvar_TotalOrd,'none')#</td>
                <td class="Lin_IZQ_BOT" style="font-size:10px;text-align:right;" nowrap>#LSCurrencyFormat(Lvar_TotalExtra,'none')#</td>
                <td class="Lin_IZQ_BOT" style="font-size:10px;text-align:right;" nowrap>#LSCurrencyFormat(Lvar_TotalSept,'none')#</td>
                <td class="Lin_IZQ_BOT" style="font-size:10px;text-align:right;" nowrap>#LSCurrencyFormat(Lvar_TotalVacaciones,'none')#</td>
                <td class="Lin_IZQ_BOT" style="font-size:10px;text-align:right;" nowrap>#LSCurrencyFormat(Lvar_TotalSal,'none')#</td>
                <td class="Lin_IZQ_BOT" style="font-size:10px;text-align:right;" nowrap>#LSCurrencyFormat(Lvar_TotalIGSS,'none')#</td>
                <td class="Lin_IZQ_BOT" style="font-size:10px;text-align:right;" nowrap>#LSCurrencyFormat(Lvar_TotalOtrosD,'none')#</td>
                <td class="Lin_IZQ_BOT" style="font-size:10px;text-align:right;" nowrap>#LSCurrencyFormat(Lvar_TotalIGSS+Lvar_TotalOtrosD,'none')#</td>
                <td class="Lin_IZQ_BOT" style="font-size:10px;text-align:right;" nowrap>#LSCurrencyFormat(Lvar_TotalAgui,'none')#</td>
                <td class="Lin_IZQ_BOT" style="font-size:10px;text-align:right;" nowrap>#LSCurrencyFormat(Lvar_TotalBono,'none')#</td>
                <td class="Lin_IZQ_BOT" style="font-size:10px;text-align:right;" nowrap>#LSCurrencyFormat(Lvar_Total,'none')#</td>
                <td class="Lin_IZQ_BOT" style="font-size:10px;text-align:right;" nowrap>&nbsp;</td>
                <td class="Lin_DER_IZQ__BOT" style="font-size:10px;text-align:right;" nowrap>&nbsp;</td>
            </tr>
			<cfif rsReporte.RecordCount NEQ Lvar_RecActual>
			<tr><td><h1 style="page-break-after:always"></h1></td></tr>
			</cfif>
		</cfoutput><!--- CORTE POR EMPLEADO --->
    </table>
	<cfelse>
		<table width="900" border="0" cellpadding="2" cellspacing="0" align="center" style="border-color:CCCCCC">
			<tr><td colspan="19" align="center">No hay datos relacionados</td></tr>
		</table>
	</cfif>
<cfelse>
	<cfset Lvar_Folio = url.Folio>
	<cfset Lvar_Cantidad = Lvar_Folio + url.Cantidad-1>
	<cfloop index="NFolio" from="#Lvar_Folio#" to="#Lvar_Cantidad#">
		<cfoutput>
		<table width="900" border="0" cellpadding="2" cellspacing="0" align="center" style="border-color:CCCCCC">
			<tr>
				<td colspan="19" >
					<table width="900" cellpadding="0" cellspacing="7" border="0">
						<tr>
							<td width="800" class="titulo_empresa2F">#rsEmpresa.Edescripcion#</td>
							<td width="50" class="tituloEmpresaPF" align="right">Folio</td>
							<td width="50" class="tituloEmpresaPF" align="left">#NFolio#</td>
						</tr>
						<tr><td colspan="3" height="20">&nbsp;</td></tr>
						<tr>
							<td colspan="3" width="900">
								<table width="900">
									<tr class="tituloEmpresaPF" height="20">
										<td width="300">&nbsp;</td>
										<td width="100">&nbsp;</td>
										<td width="100">&nbsp;</td>
										<td width="200">&nbsp;</td>
										<td width="200">&nbsp;</td>
									</tr>
									<tr align="center" class="tituloEmpresaPBF">
										<td width="300" class="Lin_TOPF"><cf_translate key="LB_NombreDelEmpleado">Nombre del Empleado</cf_translate></td>
										<td width="100"  class="Lin_TOPF"><cf_translate key="LB_Edad">Edad</cf_translate></td>
										<td width="100" class="Lin_TOPF"><cf_translate key="LB_Sexo">Sexo</cf_translate></td>
										<td width="200" class="Lin_TOPF"><cf_translate key="LB_Nacionalidad">Nacionalidad</cf_translate></td>
										<td width="200" class="Lin_TOPF"><cf_translate key="LB_Ocupacion">Ocupaci&oacute;n</cf_translate></td>
									</tr>
								</table>
							</td>
						</tr>
						<tr><td height="20">&nbsp;</td></tr>
						<tr>
							<td colspan="3"width="900">
								<table width="900">
									<tr class="tituloEmpresaPF" height="20">
										<td width="180">&nbsp;</td>
										<td width="180">&nbsp;</td>
										<td width="180">&nbsp;</td>
										<td width="180">&nbsp;</td>
										<td width="180">&nbsp;</td>
									</tr>
									<tr align="center"  class="tituloEmpresaPBF" height="20">
										<td class="Lin_TOPF"><cf_translate key="LB_NumeroAfiliacionalIGSS">No. de afiliaci&oacute;n al IGSS</cf_translate></td>
										<td class="Lin_TOPF"><cf_translate key="LB_NumeroCedulaOPermiso">No. C&eacute;dula o Permiso</cf_translate></td>
										<td class="Lin_TOPF"><cf_translate key="LB_FechaDeIngreso">Fecha de Ingreso</cf_translate></td>
										<td class="Lin_TOPF"><cf_translate key="LB_FechaDeTerminacionDelContrato">Fecha de Terminaci&oacute;n del Contrato</cf_translate></td>
										<td>&nbsp;</td>
									</tr>
								</table>
							</td>
						</tr>
					</table>
				</td>
			</tr>
			<tr  class="tituloColumnF">
				<td class="Lin_BOT_IZQ_TOPF" rowspan="2"><cf_translate key="LB_NumeroOrden">No. Orden</cf_translate></td>
				<td class="Lin_BOT_IZQ_TOPF" rowspan="2"><cf_translate key="LB_PeriodoTrabajo">Periodo<br>de<br>Trab</cf_translate></td>
				<td class="Lin_BOT_IZQ_TOPF" rowspan="2"><cf_translate key="LB_SalarioEnQuetzakes">Salario<br>en<br>Quetzales</cf_translate></td>
				<td class="Lin_BOT_IZQ_TOPF" rowspan="2"><cf_translate key="LB_Sueldo">D&iacute;as Trab.</cf_translate></td>
				<td class="Lin_IZQ_TOPF" colspan="2" nowrap="nowrap"><cf_translate key="LB_HorasTRabajadas">HORAS TRABAJADAS</cf_translate></td>
				<td class="Lin_IZQ_TOPF" colspan="4"><cf_translate key="LB_SalarioDevengado">SALARIO DEVENGADO</cf_translate></td>
				<td class="Lin_BOT_IZQ_TOPF" rowspan="2"><cf_translate key="LB_SalarioTotal">Salario<br>Total</cf_translate></td>
				<td class="Lin_IZQ_TOPF" colspan="3" nowrap="nowrap"><cf_translate key="LB_DeduccionesLegales">DEDUCCIONES LEGALES</cf_translate></td>
				<td class="Lin_BOT_IZQ_TOPF" align="center" rowspan="2"><cf_translate key="LB_AguinaldoOtros">Decreto 42/92 Aguinaldo y otros</cf_translate></td>
				<td class="Lin_BOT_IZQ_TOPF" align="center" rowspan="2"><cf_translate key="LB_BonigicacionIncentivos">Bonificaci&oacute;n Incetivo</cf_translate></td>
				<td class="Lin_BOT_IZQ_TOPF" rowspan="2"><cf_translate key="LB_LiquidoARecibir">L&iacute;quido<br>a Recibir</cf_translate></td>
				<td class="Lin_BOT_IZQ_TOPF" rowspan="2"><cf_translate key="LB_Firma">Firma</cf_translate></td>
				<td class="Lin_DER_IZQ_TOP_BOTF" rowspan="2"><cf_translate key="LB_Observaciones">Observaciones</cf_translate></td>
			</tr>
			<tr class="tituloColumnF">
				<td class="Lin_BOT_IZQ_TOPF"><cf_translate key="LB_Ordinarias">Ordinarias</cf_translate></td>
				<td class="Lin_BOT_IZQ_TOPF"><cf_translate key="LB_Extraordinarias">Extra ordinarias</cf_translate></td>
				<td class="Lin_BOT_IZQ_TOPF"><cf_translate key="LB_Ordinario">Ordinario</cf_translate></td>
				<td class="Lin_BOT_IZQ_TOPF"><cf_translate key="LB_ExtraOrdinario">Extra ordinario</cf_translate></td>
				<td class="Lin_BOT_IZQ_TOPF"><cf_translate key="LB_SetimosYAsuetos">Septimos Asuetos</cf_translate></td>
				<td class="Lin_BOT_IZQ_TOPF"><cf_translate key="LB_Vacaciones">Vacaciones</cf_translate></td>
				<td class="Lin_BOT_IZQ_TOPF"><cf_translate key="LB_IGSS">IGSS</cf_translate></td>
				<td class="Lin_BOT_IZQ_TOPF"><cf_translate key="LB_OtrasDeduccionesLed">Otras Deduc Leg.</cf_translate></td>
				<td class="Lin_BOT_IZQ_TOPF"><cf_translate key="LB_TotalDeducciones">Total Deducciones</cf_translate></td>
			</tr>
			 <tr  class="tituloColumnF">
				<td width="15" nowrap></td>
				<td width="50" nowrap></td>
				<td width="55" nowrap></td>
				<td width="20" nowrap></td>
				<td width="40" nowrap></td>
				<td width="40" nowrap></td>
				<td width="60" nowrap></td>
				<td width="50" nowrap></td>
				<td width="50" nowrap></td>
				<td width="50" nowrap></td>
				<td width="60" nowrap></td>
				<td width="45" nowrap></td>
				<td width="45" nowrap></td>
				<td width="50" nowrap></td>
				<td width="55" nowrap></td>
				<td width="50" nowrap></td>
				<td width="60" nowrap></td>
				<td width="30" nowrap></td>
				<td width="80" nowrap></td>
			</tr>
			<cfif Lvar_cantidad NEQ NFolio>
			<tr><td><h1 style="page-break-after:always"></h1></td></tr>
			</cfif>
		</table>
		</cfoutput>
	</cfloop>
</cfif>
<cfelse>
	<table width="100%" border="0" cellpadding="2" cellspacing="0" align="center">
    	<tr class="titulo_empresa2"><td align="center">No se han definido las columnas del reporte.</td></tr>
    </table>
</cfif>