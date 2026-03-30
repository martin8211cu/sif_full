<!---
-----Script para determinar Constancias de Salario
-----Origen: Juan Carlos Gutierrez
-----Adecuado: Josue Gamboa
-----Depurado: Lizandro Villalobos
-----25-11-2008
--->
<!---
==========================================================================================
PROCEDIMIENTO DE SALARIO PROMEDIO DE LA CALCULADORA, CON ULTIMAS MODIFICACIONES, PARA SALARIO PROMEDIO REAL
==========================================================================================
--->
<cffunction name="f_salariopromedio" returntype="string">
		<cfargument name="DEid" type="string" required="yes">
		<cfargument name="fecha" type="string" required="yes">
		
	
		<cfquery name="rsParametros2" datasource="#Session.DSN#">
			select Pvalor as tipodeperiodos
			from RHParametros
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
			and Pcodigo = 161
		</cfquery>
		
		<!--- Si el indicador no existe deja el cero (default) ...soporte para clientes viejos --->
		<cfif rsParametros2.recordCount>
			<cfset TipoPeriodos = rsParametros2.tipodeperiodos>
		<cfelse>
			<cfset TipoPeriodos = 0>
		</cfif>
	
		<!--- calcula Tcodigo del Empleado --->
		<cfquery name="rs_tiponomina" datasource="#session.DSN#">
			select Tcodigo
			from LineaTiempo
			where DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.DEid#">
			and <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(arguments.fecha)#"> between LTdesde and LThasta
		</cfquery>
		<cfset vTcodigo = rs_tiponomina.Tcodigo >

		<cf_dbtemp name="PagosEmplv136" returnvariable="tbl_PagosEmpleado"  datasource="#session.DSN#">
			<cf_dbtempcol name="Registro" type="numeric" identity="yes" mandatory="yes"> 
			<cf_dbtempcol name="RCNid" type="numeric">
			<cf_dbtempcol name="DEid" type="numeric"> 
			<cf_dbtempcol name="FechaDesde" type="date">
			<cf_dbtempcol name="FechaHasta" type="date">
			<cf_dbtempcol name="Cantidad" type="int">
			<cf_dbtempkey cols="Registro">
		</cf_dbtemp>
		<cf_dbtemp name="PAgosPEriodos101" returnvariable="PAgosPEriodos"  datasource="#session.DSN#">
			<cf_dbtempcol name="RCNid"       type="numeric">
			<cf_dbtempcol name="FechaDesde"  type="date">
			<cf_dbtempcol name="FechaHasta"  type="date">
			<cf_dbtempcol name="salario"     type="float">
			<cf_dbtempcol name="incidencias" type="float">
			<cf_dbtempcol name="dias" type="int">
		</cf_dbtemp>
	    <cftransaction action="commit"/>
			<cfquery name="rsTipoPago" datasource="#Session.DSN#">
				select 	Ttipopago,
					   	<cf_dbfunction name="to_float" args="FactorDiasSalario"> as FactorDiasSalario
				from TiposNomina
				where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
				and Tcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#vTcodigo#">
			</cfquery>
			<cfset Ttipopago = rsTipoPago.Ttipopago>
		
			<cfquery name="rsDiasNoPago" datasource="#Session.DSN#">
				select count(1) as diasnopago
				from DiasTiposNomina
				where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
				and Tcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#vTcodigo#">
			</cfquery>
			<cfset DiasNoPago = rsDiasNoPago.diasnopago>
		
			<cfswitch expression="#Ttipopago#">
				<cfcase value="0"> <cfset DiasNoPago = DiasNoPago * 1> </cfcase>
				<cfcase value="1"> <cfset DiasNoPago = DiasNoPago * 2> </cfcase>
				<cfcase value="2"> <cfset DiasNoPago = DiasNoPago * 2> </cfcase>
				<cfcase value="3"> <cfset DiasNoPago = DiasNoPago * 4> </cfcase>
				<cfdefaultcase> <cfset DiasNoPago = DiasNoPago * 1> </cfdefaultcase>
			</cfswitch>
		
			<cfquery name="rsParametros" datasource="#Session.DSN#">
				select Pvalor as cantidadperiodos
				from RHParametros
				where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
				and Pcodigo = 440
			</cfquery>
			<cfif rsParametros.recordCount and Len(Trim(rsParametros.cantidadperiodos))>
				<cfset CantidadPeriodos = rsParametros.cantidadperiodos >
			<cfelse>
				<cfset CantidadPeriodos = 1>
			</cfif>
			
			<cfif CantidadPeriodos lt 1>
				<cfset CantidadPeriodos = 1>
			</cfif> 
			<cfquery name="rsFecha1" datasource="#Session.DSN#">
				select max(CPdesde) as fecha1
				from CalendarioPagos
				where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
				and Tcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#vTcodigo#">
	<!--- OJAS ESTA FECHA CORRESPONDE A DLFVIGENCIA, DEMOMENTO SE ESTA USANDO ARGUMENTS.FECHA  --->		
				and CPdesde <= <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDatetime(arguments.fecha)#">
			</cfquery>
			<cfquery name="rsFecha2" datasource="#Session.DSN#">
				select max(CPhasta) as fecha1
				from CalendarioPagos
				where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
				and Tcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#vTcodigo#">
				and CPdesde < <cfqueryparam cfsqltype="cf_sql_date" value="#rsFecha1.fecha1#">
			</cfquery>
			<cfset Fecha1 = rsFecha2.fecha1>
			
			<cfif (Len(Trim(Fecha1)))>
				<cfset Fecha3 = DateAdd('m', -CantidadPeriodos, Fecha1)>
			<cfelse>
				<cfset Fecha3 = DateAdd('m', -CantidadPeriodos, now())>   
			</cfif>		
			
			<cfif Len(Trim(Fecha1))>
				<cfset Fecha2 = DateAdd('yyyy', -1, DateAdd('d', -30, Fecha1))>
				<!--- <cfset Fecha2 = DateAdd('yyyy', -1, DateAdd('d', (CantidadPeriodos * -30), Fecha1))> --->
				
				<cfquery name="tbl_PagosEmpleadoInsert" datasource="#session.DSN#">
					insert into #tbl_PagosEmpleado# (RCNid, DEid, FechaDesde, FechaHasta, Cantidad)
					select distinct a.RCNid, #arguments.DEid#, a.RCdesde, a.RChasta, 0
					from HSalarioEmpleado b, HRCalculoNomina a, CalendarioPagos cp
					where b.DEid = #arguments.DEid#
					and a.RCNid = b.RCNid
					and a.Ecodigo = #session.Ecodigo#
					and a.RChasta <= <cfqueryparam cfsqltype="cf_sql_date" value="#Fecha1#">
					and a.RCdesde >= <cfqueryparam cfsqltype="cf_sql_date" value="#Fecha2#">
					and cp.CPid = a.RCNid
					and cp.CPtipo = 0
					order by a.RChasta desc
				</cfquery>
			</cfif>
		
			<!--- Borrar de la historia los periodos donde existe incapacidad --->
			<cfquery name="delPagosEmpleado" datasource="#Session.DSN#">
				delete #tbl_PagosEmpleado#
				where exists (
					select 1
					from HPagosEmpleado pe, RHTipoAccion d
					where pe.DEid = #tbl_PagosEmpleado#.DEid
						and pe.RCNid = #tbl_PagosEmpleado#.RCNid
						and d.RHTid = pe.RHTid
						and d.RHTcomportam = 5
				)
			</cfquery>
		
			<cfquery name="delPagosEmpleado" datasource="#Session.DSN#">
				delete #tbl_PagosEmpleado#
				where exists (
					select 1
						from 	DLaboralesEmpleado a
						inner join  RHTipoAccion x
							on x.RHTid = a.RHTid
							and x.RHTcomportam = 5
						left outer join RHSaldoPagosExceso pe
							on a.DLlinea = pe.DLlinea
							and pe.RHSPEanulado = 0
						where a.DEid = #tbl_PagosEmpleado#.DEid
						and 
						(
						(a.DLfvigencia between  #tbl_PagosEmpleado#.FechaDesde and  #tbl_PagosEmpleado#.FechaHasta)
						or
						(a.DLffin between  #tbl_PagosEmpleado#.FechaDesde and  #tbl_PagosEmpleado#.FechaHasta)
						)
				)
			</cfquery>
			
			<!--- Borrar de la historia los periodos donde existe permisos sin goce de salario --->
			<cfquery name="delPagosEmpleado" datasource="#Session.DSN#">
				delete #tbl_PagosEmpleado#
				where exists (	select 1
								from HPagosEmpleado pe, RHTipoAccion d
								where pe.DEid = #tbl_PagosEmpleado#.DEid
									and pe.RCNid = #tbl_PagosEmpleado#.RCNid
									and d.RHTid = pe.RHTid
									and d.RHTcomportam = 4 
									AND d.RHTpaga = 1)
			</cfquery>
			
			<cfquery name="delPagosEmpleado" datasource="#Session.DSN#">
				delete #tbl_PagosEmpleado#
				where exists (
					select 1
						from 	DLaboralesEmpleado a
						inner join  RHTipoAccion x
							on x.RHTid = a.RHTid
							and x.RHTcomportam = 4 
							and x.RHTpaga = 1
						left outer join RHSaldoPagosExceso pe
							on a.DLlinea = pe.DLlinea
							and pe.RHSPEanulado = 0
						where a.DEid = #tbl_PagosEmpleado#.DEid
						and 
						(
						(a.DLfvigencia between  #tbl_PagosEmpleado#.FechaDesde and  #tbl_PagosEmpleado#.FechaHasta)
						or
						(a.DLffin between  #tbl_PagosEmpleado#.FechaDesde and  #tbl_PagosEmpleado#.FechaHasta)
						)
				)
			</cfquery>
		
			<!---
				Borrar de la historia los periodos anteriores o iguales a una salida de la empresa 
				Se busca la fecha maxima de salida y se eliminan los pagos anteriores
			--->
			<cfquery name="rsFechaSalida" datasource="#Session.DSN#">
				select max(LTdesde) as fechasalida
				from LineaTiempo lt, RHTipoAccion ta
				where lt.DEid = #arguments.DEid#
				and ta.RHTid = lt.RHTid
				and ta.RHTcomportam = 2
			</cfquery>
			<cfif rsFechaSalida.recordCount and Len(Trim(rsFechaSalida.fechasalida))>
				<cfquery name="delPagosEmpleado" datasource="#Session.DSN#">
					delete #tbl_PagosEmpleado#
					where fechahasta <= <cfqueryparam cfsqltype="cf_sql_date" value="#rsFechaSalida.fechasalida#">
				</cfquery>
			</cfif>
		
			<cfquery name="rsPagosEmpleado" datasource="#Session.DSN#">
				select Registro,RCNid,DEid,FechaDesde,FechaHasta,Cantidad
				from #tbl_PagosEmpleado#
				order by Registro
			</cfquery>
			<cfloop query="rsPagosEmpleado">
				<cfquery name="updPagoEmpleado" datasource="#Session.DSN#">
					update #tbl_PagosEmpleado#
					set Cantidad = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsPagosEmpleado.CurrentRow#">
					where Registro = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsPagosEmpleado.Registro#">
				</cfquery>
			</cfloop>
	
			<cfif TipoPeriodos EQ 1 and Len(Trim(Fecha3))>
				<cfquery name="delPagosEmpleado" datasource="#Session.DSN#">
					delete #tbl_PagosEmpleado#
					where DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.DEid#">
					  and FechaHasta <= <cfqueryparam cfsqltype="cf_sql_date" value="#Fecha3#">
				</cfquery>
			<cfelse>
				<cfquery name="delPagosEmpleado" datasource="#Session.DSN#">
					delete #tbl_PagosEmpleado#
					where  DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.DEid#">
					  and Cantidad > <cfqueryparam cfsqltype="cf_sql_integer" value="#CantidadPeriodos#">
				</cfquery>
			</cfif>		
			
			<cfquery name="rsPagosEmpleado" datasource="#Session.DSN#">
				select 1
				from #tbl_PagosEmpleado#
			</cfquery>
			
			<cfif rsPagosEmpleado.recordCount>
				<cfquery name="rsSalarioPromedioA" datasource="#Session.DSN#">
					insert into #PAgosPEriodos# (FechaDesde,FechaHasta,RCNid,salario,incidencias)
					select
					pe.FechaDesde,
					pe.FechaHasta,
					se.RCNid,
					sum(SEsalariobruto + SEincidencias) as salario,
					0.00 as incidencias
					from HSalarioEmpleado se, #tbl_PagosEmpleado# pe
					where se.RCNid = pe.RCNid
					and se.DEid = pe.DEid
					group by pe.FechaDesde,pe.FechaHasta,se.RCNid
					order by pe.FechaDesde desc,pe.FechaHasta,se.RCNid
				</cfquery>
	
				<cfquery name="rsSalarioPromedioC" datasource="#Session.DSN#">
					select 
					hp.RCNid,
					coalesce(sum(PEcantdias), 0) as dias
					from  HPagosEmpleado  hp, #tbl_PagosEmpleado# pe
					where hp.RCNid = pe.RCNid
					and hp.DEid = pe.DEid
					and hp.PEtiporeg = 0
					group by hp.RCNid
				</cfquery>
					
				<cfquery name="rsSalarioPromedioB" datasource="#Session.DSN#">
					select 
					ic.RCNid,
					coalesce(sum(ic.ICmontores), 0.00) as incidencias
					from HIncidenciasCalculo ic, #tbl_PagosEmpleado# pe, CIncidentes ci
					where ic.RCNid = pe.RCNid
					and ic.DEid = pe.DEid
					and ci.CIid = ic.CIid
					and ci.CIafectasalprom = 0
					and coalesce(ci.CIafectasalpromSP,0) = 0
					group by ic.RCNid
					order by ic.RCNid
				</cfquery>
	
				<cfif rsSalarioPromedioB.recordCount GT 0>
					<cfloop query="rsSalarioPromedioB">
						<cfquery name="upSalarioPromedioB" datasource="#Session.DSN#">
							update #PAgosPEriodos# set incidencias = <cfqueryparam cfsqltype="cf_sql_float" value="#rsSalarioPromedioB.incidencias#"> 
							where RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsSalarioPromedioB.RCNid#">
						</cfquery>
					</cfloop> 
				</cfif>
	
				<cfif rsSalarioPromedioC.recordCount GT 0>
					<cfloop query="rsSalarioPromedioC">
						<cfquery name="upSalarioPromedioC" datasource="#Session.DSN#">
							update #PAgosPEriodos# set dias = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsSalarioPromedioC.dias#"> 
							where RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsSalarioPromedioC.RCNid#">
						</cfquery>
					</cfloop> 
				</cfif>
	
				<cfquery name="rsmeses" datasource="#Session.DSN#">
					select FechaDesde as RCdesde,
					FechaHasta as RChasta,
					(salario - incidencias) as salario,
					dias
					from #PAgosPEriodos#
					order by FechaDesde desc,FechaHasta
				</cfquery>
	
				<cfquery name="rspromedio"  dbtype="query">
					select sum(salario) / sum(dias) as SalarioPromedioDiario
					from rsmeses
				</cfquery>
	
				<cfif len(trim(rsTipoPago.FactorDiasSalario)) eq 0 >
					<cfquery name="rsParametros" datasource="#Session.DSN#">
						select Pvalor
						from RHParametros
						where Ecodigo = #session.Ecodigo#
						and Pcodigo = 80
					</cfquery>
				</cfif>
				
				<cfif len(trim(rsTipoPago.FactorDiasSalario)) eq 0 >
					<cfset ValorPromedioDiario = rsParametros.Pvalor>
				<cfelse>
					<cfset ValorPromedioDiario = rsTipoPago.FactorDiasSalario>
				</cfif>
				
				<!--- Obtener los cálculos del salario promedio entre los períodos --->
				<cfset SalarioPromedioDiario = rspromedio.SalarioPromedioDiario>
				<cfset SalarioPromedio = SalarioPromedioDiario * rsTipoPago.FactorDiasSalario>
				
				<cfif Application.dsinfo[session.dsn].type is 'oracle'>
					<cfquery datasource="#session.DSN#">
						truncate table #tbl_PagosEmpleado#
					</cfquery>
				</cfif>
				
				<cfquery name="dropPagosEmpleado" datasource="#Session.DSN#">
					drop table #tbl_PagosEmpleado#
				</cfquery>
		
			<cfelse>
				<cfset SalarioUltimosPeriodos = 0>
				<cfset SalarioPromedio = 0>
				<cfset SalarioPromedioDiario = 0>
				<cfset SalarioQuincena = 0>
			</cfif>
			
			<cfreturn SalarioPromedio >
</cffunction>

<!---
==========================================================================================
PARAMETROS DE ENTRADA QUE SE RECIBEN DESDE LA SOLICITUD DE LA CERTIFICACION
==========================================================================================
--->
		<cfset pDEidentificacion = rsData.DEidentificacion >
		<cfset pFecha 		 	 = rsData.fecha >

<!---
==========================================================================================
SE CONVIERE LA FECHA DE ENTRADA EN FORMATO EN LETRAS
==========================================================================================
--->
		<cfinvoke component="sif.Componentes.fechaEnLetras" method="fnFechaEnLetras" returnvariable="vFechaEnLetras">
				<cfinvokeargument name="Fecha" value="#dateformat(pFecha,'dd/mm/yyyy')#"/>
		</cfinvoke>
		<cfset fecha = ' #vFechaEnLetras#' >
<!---
==========================================================================================
INICIALIZACION DE VARIABLES DE TRABAJO
==========================================================================================
--->		
		<cfset salario_promedio 	= 0  >
		<cfset asociacion_promedio	= 0  >
		<cfset cargas_promedio 		= 0  >
		
		<cfset salario_base 		= 0  >
		<cfset asociacion_base 		= 0  >
		<cfset cargas_base 			= 0  >
		
		<cfset deducciones_emp 		= 0  >
		<cfset deducciones 			= 0  >
		<cfset asociacion 			= 0  >
		
		<cfset embargos 			= '' >
		<cfset fechaingreso 		= '' >
		<cfset fechasalida 			= '' >
		<cfset labora 				= '' >

<!---
==========================================================================================
TABLA DE DONDE SALEN VAN A ALMACENARSE LOS VALORES CALCULADOS
==========================================================================================
--->
		<cf_dbtemp name="coopelesca_v20" returnvariable="datos" datasource="#session.dsn#">
			<cf_dbtempcol name="DEid"					type="numeric"  		mandatory="no">
			<cf_dbtempcol name="nombre"					type="varchar(100)"  	mandatory="no">
			<cf_dbtempcol name="identificacion"			type="varchar(25)"		mandatory="no">
			<cf_dbtempcol name="empresa"				type="varchar(100)"		mandatory="no">
			<cf_dbtempcol name="fechaingreso"			type="varchar(10)"		mandatory="no">
			<cf_dbtempcol name="puesto"					type="varchar(100)"		mandatory="no">
			<cf_dbtempcol name="cf"						type="varchar(100)"		mandatory="no">
			<cf_dbtempcol name="fechasalida"			type="varchar(50)"		mandatory="no">
			<cf_dbtempcol name="motivosalida"			type="varchar(250)"		mandatory="no">
			<cf_dbtempcol name="cargas_promedio"		type="money"			mandatory="no">	
			<cf_dbtempcol name="deducciones"			type="money"  			mandatory="no">
			<cf_dbtempcol name="salario_promedio"		type="money"			mandatory="no">
			<cf_dbtempcol name="asociacion_promedio"	type="money"			mandatory="no">
			<cf_dbtempcol name="liquido_promedio_ded"	type="money"			mandatory="no">
			<cf_dbtempcol name="salario_base"			type="money"  			mandatory="no">
			<cf_dbtempcol name="cargas_base"			type="money"  			mandatory="no">
			<cf_dbtempcol name="asociacion_base"		type="money"			mandatory="no">
			<cf_dbtempcol name="liquido_todasdeduc"		type="money"			mandatory="no">
			<cf_dbtempcol name="liquido_base_ded"		type="money"			mandatory="no">
			<cf_dbtempcol name="liquido_promedio"		type="money"			mandatory="no">
			<cf_dbtempcol name="liquido_base"			type="money"			mandatory="no">
			<cf_dbtempcol name="renta_base"				type="money"			mandatory="no">
			<cf_dbtempcol name="renta_promedio"			type="money"			mandatory="no">
			<cf_dbtempcol name="embargo"				type="varchar(50)"  	mandatory="no">
			<cf_dbtempcol name="tipoembargo"			type="varchar(50)"  	mandatory="no">
			<cf_dbtempcol name="labora"					type="varchar(50)"  	mandatory="no">
			<cf_dbtempcol name="salario_promedio_calc"	type="money"  			mandatory="no">
			<cf_dbtempcol name="usuario"				type="varchar(255)"		mandatory="no">
			<cf_dbtempcol name="centrofunc"				type="varchar(255)"		mandatory="no">
			<cf_dbtempcol name="usuariocentrofunc"		type="varchar(255)"		mandatory="no">
			<cf_dbtempcol name="nacionalidad"			type="varchar(255)"		mandatory="no">
			<cf_dbtempcol name="direccion"				type="varchar(255)"		mandatory="no">
			<cf_dbtempcol name="cuentabancaria"			type="varchar(255)"		mandatory="no">
			<cf_dbtempcol name="banco"					type="varchar(255)"		mandatory="no">
		</cf_dbtemp>		

<!---
		==========================================================================================
		SE EXTRAE LA INFORMACION DEL EMPLEADO A QUIEN SE LE HACE LA CERTIFICACION
		==========================================================================================
--->
	<cfquery name="rs_empleado" datasource="#session.DSN#">
		select 	DEid 
		from DatosEmpleado a, Empresas e
		where DEidentificacion = <cfqueryparam cfsqltype="cf_sql_varchar" value="#pDEidentificacion#"> <!--- parametro ver como hacer esto --->
		  and a.Ecodigo = e.Ecodigo
		  and a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#"> <!--- parametro ver como hacer esto --->
	</cfquery>

<!---
		==========================================================================================
		SE INSERTA LA INFORMACION DEL EMPLEADO GENERAL EN LA TABLA DE TRABAJO
		==========================================================================================
--->
		<cfquery datasource="#session.DSN#" name="LZ">
			insert into #datos# ( DEid, nombre , identificacion , empresa , fechaingreso , puesto, nacionalidad, direccion, cuentabancaria, banco ) 
			select 	DEid, 
					{fn concat( {fn concat( {fn concat(	{fn concat(DEapellido1, ' ') }, DEapellido2 )}, ' ' )}, DEnombre)} as nombre,
					DEidentificacion, 
					Edescripcion, 
					null, 
					null,
					case	when rtrim(a.Ppais) = 'CR' then 'costarricense' 
							when rtrim(a.Ppais) is null then 'costarricense' 
	 						else  Pnombre
	 				end 	as Nacionalidad, 
	 				coalesce( DEdireccion,'Sin Definir Dirección') as DireccionEmpleado, 
	 				coalesce(DEcuenta,'Sin Definir Cuenta') as CuentaBancaria, 
	 				coalesce(d.Bdescripcion,'Sin Definir Banco') as Banco
			from DatosEmpleado a
				inner join Empresas e
				on a.Ecodigo = e.Ecodigo
			left outer join Pais c
				on a.Ppais=c.Ppais	
			left outer join Bancos d
				on a.Bid = d.Bid
			where DEidentificacion = <cfqueryparam cfsqltype="cf_sql_varchar" value="#pDEidentificacion#"> <!--- parametro ver como hacer esto --->
			and a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#"> <!--- parametro ver como hacer esto --->
			
			
		</cfquery>
<!---
		==========================================================================================
		SE ESPECIFICA EL PUESTO Y CENTRO FUNCIONAL AL DIA DE HOY
		==========================================================================================
--->
		<cfquery datasource="#session.DSN#">
			update #datos#
			set puesto = ( 	select min(e.RHPdescpuesto)
							from LineaTiempo b, RHPlazas c, RHPuestos e
							where b.DEid=#datos#.DEid
							  and b.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#"> 
							  and (<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#"> between b.LTdesde and b.LThasta )
							  and b.RHPid = c.RHPid
							  and e.RHPcodigo = c.RHPpuesto
							  and e.Ecodigo = c.Ecodigo ),
			cf = ( 			select min(e.CFdescripcion)
							from LineaTiempo b, RHPlazas c, CFuncional e
							where b.DEid=#datos#.DEid
							  and b.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#"> 
							  and (<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#"> between b.LTdesde and b.LThasta )
							  and b.RHPid = c.RHPid
							  and e.CFid = c.CFid)
		</cfquery>
<!---
==========================================================================================
ESPECIFICA LA FECHA DE INGRESO SEGUN LA INFORMACION DE EVACIONESEMPLEADO Y SU ULTIMO EVANTIG
==========================================================================================
--->		

		<cf_dbfunction name="to_char" args="EVfantig,'dd-mm-yyyy'" returnvariable="vingreso2">
		<cfquery datasource="#session.DSN#">
			update #datos#
			set fechaingreso =  ( select #preservesinglequotes(vingreso2)#
								  from EVacacionesEmpleado b
								  where b.DEid = #datos#.DEid )
		</cfquery>
		
		
<!---
==========================================================================================
VERIFICACION DE QUE EL EMPLEADO ESTA ACTIVO O NO...
==========================================================================================
--->
		<cfquery name="rsFechaSalida" datasource="#session.DSN#">
			select max(LThasta) as fechasalida
			from #datos# a, LineaTiempo b,  RHTipoAccion d
			where a.DEid = b.DEid 
			and d.RHTid = b.RHTid
		</cfquery>
		<cfset fechasalida = rsFechaSalida.fechasalida >

<cfif len(trim(fechasalida)) and datecompare(fechasalida, now()) lt 0 >
	<!---
	==========================================================================================
	EL EMPLEADO ESTA INACTIVO
	==========================================================================================
	--->

			<!--- VALORES POR DEFECTO PARA UN EMPLEADO INACTIVO--->
			<cfset embargos = 'INACTIVO' >
			<cfset tipoembargo = '' >
			<cfset alafecha = '' >
			<cfset labora = 'laboró' >
			<cfset porlotanto = 'Por lo tanto a partir de esta fecha no tiene ninguna relación laboral con esta empresa' >
			<cfset ultima_fecha = fechasalida>
			<!--- DETERMINA EL CENTRO FUNCIONAL Y PUESTO DONDE ESTUVO POR ULTIMA VEZ--->
			<cfquery datasource="#session.DSN#">
					update #datos#
					set puesto = ( 	select max(e.RHPdescpuesto)
									from LineaTiempo b, RHPlazas c, RHPuestos e
									where b.DEid=#datos#.DEid
									  and b.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#"> 
									  and (<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#"> > b.LThasta )
									  and b.RHPid = c.RHPid
									  and e.RHPcodigo = c.RHPpuesto
									  and e.Ecodigo = c.Ecodigo ),
					cf = ( 			select max(e.CFdescripcion)
									from LineaTiempo b, RHPlazas c, CFuncional e
									where b.DEid=#datos#.DEid
									  and b.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#"> 
									  and (<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#"> > b.LThasta )
									  and b.RHPid = c.RHPid
									  and e.CFid = c.CFid)
			</cfquery>	
			
			<!--- DETERMINA EL MOTIVO DE SALIDA, USANDO LA DESCRIPCION DE LA ACCION DE CESE APLICADA--->
			<cfquery name="rsMotivoSalida" datasource="#session.DSN#">
				select  RHTdesc Motivo
				from #datos# a, DLaboralesEmpleado b,  RHTipoAccion d
				where a.DEid = b.DEid 
				and d.RHTid = b.RHTid
				and d.RHTcomportam=2
				and DLfvigencia >= (select max(LThasta) 
							from LineaTiempo b2
							where b2.DEid = b.DEid )
			</cfquery>
			
			<cfset motivosalida = 'El motivo de salida fue por #rsMotivoSalida.Motivo#'>
			
			<!--- A LA FECHA DE SALIDA SE LE GENERA UN FORMATO EN LETRAS--->
			<cfinvoke component="sif.Componentes.fechaEnLetras" method="fnFechaEnLetras" returnvariable="vFechaEnLetras">
				<cfinvokeargument name="Fecha" value="#dateformat(fechasalida,'dd/mm/yyyy')#"/>
			</cfinvoke>
			<cfset fechasalida = ' hasta el #vFechaEnLetras#' >
		
			<!--- LAS VARIABLES DE RENTA SE VUELVEN CERO AL ESTAR CESADO--->
			<cfset renta_promedio=0>
			<cfset renta_base=0>
<cfelse>
	<!---
	==========================================================================================
	EL EMPLEADO ESTA ACTIVO
	==========================================================================================
	--->
			<!--- VALORES POR DEFECTO PARA UN EMPLEADO ACTIVO--->	
			<cfset fechasalida = '' >
			<cfset motivosalida = '' >
			<cfset porlotanto = '' >
			<cfset labora = 'labora' >
			<cfset alafecha = 'a la fecha' >
			<cfset hastalabores = 'por tiempo indefinido' >
			<cfset ultima_fecha = pFecha>
			<cfset Infinito = CreateDate(6100 ,1,1)> 
			
			<cfquery name="TipoNombramiento" datasource="#session.DSN#">
				select Max(LThasta) as MaxFecha
				from LineaTiempo a, #datos# b
				where a.DEid = b.DEid
			</cfquery>
		
			<cfif TipoNombramiento.MaxFecha LT infinito>			
					<cfset alafecha = TipoNombramiento.MaxFecha >
					<cfset hastalabores = 'por tiempo definido' >				
			</cfif>
			<!--- CALCULA SALARIO BASE --->
			<cfquery name="rsSalarioBase" datasource="#session.DSN#">
				select coalesce(LTsalario  ,0) as LTsalario
				from LineaTiempo a, #datos# b
				where <cfqueryparam cfsqltype="cf_sql_date" value="#now()#"> between LTdesde and LThasta 
				and a.DEid = b.DEid
			</cfquery>
			<cfif len(trim(rsSalarioBase.LTsalario))>
				<cfset salario_base = rsSalarioBase.LTsalario >
				<cfquery name="rsSalarioBase2" datasource="#session.DSN#">
					update #datos#
					set salario_base = <cfqueryparam cfsqltype="cf_sql_varchar" value="#salario_base#">
				</cfquery>
			</cfif>	
			
			<cfquery name="ultima" datasource="#session.DSN#">
				select max(RCdesde) as desde
				from HPagosEmpleado a, #datos# b, HRCalculoNomina c, CalendarioPagos d
				where a.DEid = b.DEid
				and a.RCNid = c.RCNid
				and c.RCNid=d.CPid
				and d.CPtipo=0
			</cfquery>
			
			<!---  CALCULA DEDUCCIONES ULTIMAS DOS NOMINAS 
				  (SE CORRIGE PUES NO NECESARIAMENTE LA NOMINA ANTERIOR ES LA RCNID-1) --->
			<cfquery name="NominaMax" datasource="#session.DSN#">
					Select RCNid, RCdesde 
					from HRCalculoNomina
					Where RCNid in ( select max(RCNid) 
									 from HSalarioEmpleado a, #datos# b, CalendarioPagos c
									 where a.DEid = b.DEid
									 and a.RCNid=c.CPid
									 and c.CPtipo=0)
			</cfquery>
			<cfif NominaMax.Recordcount EQ 0>
						<cfset deducciones = 0 >			
			<cfelse>
					<cfset FechaHasta=DateAdd("d", -1, "#NominaMax.RCdesde#")>
					
					<cfquery name="NominaAnterior" datasource="#session.DSN#">
						select  coalesce(d.RCNid,0) as RCNidAnt
						from HRCalculoNomina a, 
							 HSalarioEmpleado b,	 
							 #datos# c,					 
							 HRCalculoNomina d,
							 CalendarioPagos e
						Where a.RCNid=b.RCNid
						and a.RCNid=b.RCNid
						and b.DEid=c.DEid
						and a.RCNid = #NominaMax.RCNid#
						and a.Ecodigo=d.Ecodigo
						and a.Tcodigo=d.Tcodigo
						and a.RCNid=e.CPid
						and e.CPtipo=0
						and d.RChasta = <cfqueryparam cfsqltype="cf_sql_date" value="#PreserveSingleQuotes(FechaHasta)#">
					</cfquery>
					
					<cfquery name="rsDeducciones" datasource="#session.DSN#">
						select  coalesce(sum(DCvalor),0) as DCvalor
						from HDeduccionesCalculo a, #datos# b
						where a.DEid = b.DEid
						and (RCNid = #NominaMax.RCNid#
							 or RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#NominaAnterior.RCNidAnt#">)
					</cfquery>
			
					<cfif len(trim(rsDeducciones.DCvalor))>
						<cfset deducciones = rsDeducciones.DCvalor >
					</cfif>
		</cfif>					
		<cfset FechaConstante = CreateDate(6100 ,1,1)> 
		<!---  CALCULA VALOR CUOTA ASOCIACION --->
			<cfquery name="rsAsociacion" datasource="#session.DSN#">
				select sum(coalesce(DCvaloremp,0)) as DCvaloremp
				from CargasEmpleado a, DCargas b, #datos# c
				where a.DEid = c.DEid
					and a.DClinea = b.DClinea
					and rtrim(upper(b.DCcodigo))  in ('AHOBR','AHOAD','ASEOB') <!--- OJO ESTE PARAMETRO ES DE COOPELESCA, PUEDE VARIAR DEPENDIENDO CLIENTE --->
					<!----Verificar que el empleado aun sea asociado---->
					and <cfqueryparam cfsqltype="cf_sql_date" value="#pFecha#"> 
						between coalesce(a.CEdesde,
												<cfqueryparam cfsqltype="cf_sql_date" value="#LSDateFormat(FechaConstante,'dd/mm/yyyy')#">)
						and 		coalesce(a.CEhasta, 
													<cfqueryparam cfsqltype="cf_sql_date" value="#LSDateFormat(FechaConstante,'dd/mm/yyyy')#">)
			</cfquery>	

			<cfif len(trim(rsAsociacion.DCvaloremp))>
				<cfset asociacion = rsAsociacion.DCvaloremp >
			</cfif>
	
		<!---  CALCULA RENTA BASE, SOBRE EL SALARIO BASE DEL EMPLEADO--->

	
			<cfquery name="rsRenta" datasource="#session.DSN#">
			<cfif Application.dsinfo[session.DSN].type is 'oracle'>
				select 	( ( salario_base - DIRinf ) * ( DIRporcentaje / 100 ) ) + DIRmontofijo as renta_base
			<cfelse>
				select convert(money,((salario_base - DIRinf ) * (DIRporcentaje / 100)) + DIRmontofijo )as renta_base
			</cfif>	
	
			from EImpuestoRenta a, DImpuestoRenta b, RHParametros c, #datos# d
			where a.EIRid = b.EIRid
			  and a.EIRestado = 1
			  and c.Pcodigo = 30
			  and c.Pvalor = a.IRcodigo
			  and c.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#"> 
			  and round(salario_base,2) >= round(b.DIRinf,2)
			  and round(salario_base,2) <= round(b.DIRsup,2)
			  and <cfqueryparam cfsqltype="cf_sql_date" value="#pfecha#"> between EIRdesde and EIRhasta
		</cfquery>
		<cfif len(trim(rsRenta.renta_base))>
		 	<cfset renta_base = rsRenta.renta_base >
		 
		 	<cfquery name="rsRentaBase2" datasource="#session.DSN#">
				update #datos#
				set renta_base = <cfqueryparam cfsqltype="cf_sql_varchar" value="#renta_base#">
			</cfquery>
		<cfelse>
				<cfset renta_base=0>
	    </cfif>
	<!--- CALCULA SI EL EMPLEADO ESTA EMBARGADO --->
		<cfquery name="rsEmbargos" datasource="#session.DSN#">
			select 	case coalesce(sum(h.DCvalor),0) when 0 then 'libre de embargos' else 'embargado(a)' end as DCvalor,
					min(t.TDdescripcion) as tipo
			   from HDeduccionesCalculo h, DatosEmpleado de, DeduccionesEmpleado d, TDeduccion t
			where  h.DEid = de.DEid
				 and de.DEidentificacion = <cfqueryparam cfsqltype="cf_sql_varchar" value="#pDEidentificacion#">
				 and h.DEid = d.DEid
				 and h.Did = d.Did
				 and <cfqueryparam cfsqltype="cf_sql_date" value="#pfecha#"> between d.Dfechaini and d.Dfechafin
				 and d.TDid = t.TDid
				 and d.Ecodigo = t.Ecodigo
				 and d.Dactivo = 1
				 and upper(t.TDcodigo) like 'EMB%'
		</cfquery>
		<cfif len(trim(rsEmbargos.DCvalor))>
			<cfset embargos = rsEmbargos.DCvalor >
			<cfset tipoembargo = 'Tipo #rsEmbargos.tipo#.' >
		</cfif>
		<cfif trim(embargos) EQ "libre de embargos">
			<cfset tipoembargo = "" >
		</cfif>
</cfif>
<!---
==========================================================================================
PARA CUALQUIER EMPLEADO SEA ACTIVO O INACTIVO
==========================================================================================
--->

	<!--- CALCULAR LA CANTIDAD DE AÑOS Y MESES LABORADO --->
	<cfset v_fecha = LSDateFormat(ultima_fecha, 'dd-mm-yyyy') >
	<cf_dbfunction name="to_date" args="'#v_fecha#'" returnvariable="ultima_fecha">
	<cf_dbfunction name="to_date" args="fechaingreso" returnvariable="fecha_ingreso">
	<cf_dbfunction name="datediff" args="
						#preservesinglequotes(ultima_fecha)#|
						#preservesinglequotes(fecha_ingreso)#" 
				returnvariable = "v_datediff" delimiters="|">
	<cfquery datasource="#session.DSN#" name="rsPeriodos">
		select 	#preservesinglequotes(v_datediff)# as DiasDif
		from #datos#
	</cfquery>
	<cfset periodos_laborados = int(abs(rsPeriodos.DiasDif/ 365.25)) >
	<cfset meses_laborados = int(((abs(rsPeriodos.DiasDif))-(periodos_laborados * 365.25))/30)>

	<!--- SE CARGA LA VARIABLE FECHA DE INGRESO SEGUN EL VALOR RECOPILADO --->
	<cfquery datasource="#session.DSN#" name="rsFechaIngreso">
		select fechaingreso from #datos#
	</cfquery>
	<cfset fechaingreso = rsFechaIngreso.fechaingreso >	
	
<!--- 
	==========================================================================================
	INICIO CALCULO DE SALARIO PROMEDIO USANDO LA FUNCION QUE USA TAMBIEN LA CALCULADORA
	==========================================================================================}
--->
	<!--- salario promedio --->
	<cfset v_salariopromedio = f_salariopromedio(rs_empleado.DEid, LSDateFormat(pFecha, 'dd/mm/yyyy') ) >
	<cfif not isnumeric(v_salariopromedio)>
		<cfset v_salariopromedio = 0 >
	</cfif>
<!--- ========================= FIN CALCULO DE SALARIO PROMEDIO ========================= --->

<!--- 
	==========================================================================================
	CALCULO DE LA RENTA PROMEDIO
	==========================================================================================}
--->
<cfquery name="rsRentaP" datasource="#session.DSN#">
	select coalesce(((#v_salariopromedio# - DIRinf ) * (DIRporcentaje / 100)) + DIRmontofijo,0) as renta_promedio
		from EImpuestoRenta a, DImpuestoRenta b, RHParametros c, #datos# d
		where a.EIRid = b.EIRid
		and a.EIRestado = 1
		and c.Pcodigo = 30
		and c.Pvalor = a.IRcodigo
		and c.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
		and round(#v_salariopromedio#,2) >= round(b.DIRinf,2)
		and round(#v_salariopromedio#,2) <= round(b.DIRsup,2)
		and <cfqueryparam cfsqltype="cf_sql_date" value="#pfecha#"> between EIRdesde and EIRhasta
	</cfquery>

	<cfif len(trim(rsRentaP.renta_promedio))>
	   	<cfquery name="rsRentaBase2" datasource="#session.DSN#">
			update #datos#
			set renta_promedio = #rsRentaP.renta_promedio#
		</cfquery>
		<cfset renta_promedio = rsRentaP.renta_promedio >
	<cfelse>
		<cfset renta_promedio=0>
    </cfif>
    
	<!--- ASOCIACION Y CARGAS A DESPLEGAR EN CERTIFICACION --->
		<cfset asociacion_promedio 	= (v_salariopromedio * asociacion) / 100 >
		<cfset asociacion_base 		= (salario_base * asociacion) / 100 >
		<cfset cargas_promedio 		= v_salariopromedio * 0.0917 >
		<cfset cargas_base 			= salario_base * 0.0917 >
	

	<!--- USUARIO QUE GENERA LA BOLETA --->
		<cfquery name="rs_usuario" datasource="#session.DSN#">
			select <cf_dbfunction name="concat" args="Pnombre,' ',Papellido1,' ',Papellido2"> as usuario
			from DatosPersonales dp, Usuario u
			where u.Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#" >
			and u.datos_personales=dp.datos_personales
		</cfquery>
		
		<!--- CENTRO FUNCIONAL DE QUIEN GENERA LA BOLETA --->
		<cfset v_usuariocentrofunc = '' >
		<cfquery name="rs_esempleado" datasource="#session.DSN#" >
			select llave
			from UsuarioReferencia
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.EcodigoSDC#" >
			  and Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#" >
		</cfquery>
		
		<cfif isnumeric(rs_esempleado.llave) >
			<cfquery name="rs_centro" datasource="#session.DSN#">
				select cf.CFcodigo, cf.CFdescripcion
				from LineaTiempo lt, RHPlazas p, CFuncional cf
				where DEid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#rs_esempleado.llave#">
					and <cfqueryparam cfsqltype="cf_sql_date" value="#pFecha#"> between LTdesde and LThasta
				and p.RHPid=lt.RHPid
				and cf.CFid=p.CFid
			</cfquery>
			<cfset v_usuariocentrofunc = trim(rs_centro.CFdescripcion) >
		<cfelse>	
			<cfset v_usuariocentrofunc = 'USUARIO NO TIENE CENTRO FUNCIONAL' >
		</cfif>

	<!--- CENTRO FUNCIONAL DEL USUARIO A QUIEN SE LE GENERA LA BOLETA--->
		<cfquery name="rs_centro" datasource="#session.DSN#">
			select cf.CFcodigo, cf.CFdescripcion
			from LineaTiempo lt, RHPlazas p, CFuncional cf
			where DEid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#rs_empleado.DEid#">
				and <cfqueryparam cfsqltype="cf_sql_date" value="#pFecha#"> between LTdesde and LThasta
			and p.RHPid=lt.RHPid
			and cf.CFid=p.CFid
		</cfquery>
		<cfset v_centrofunc = trim(rs_centro.CFcodigo) & ' - ' & trim(rs_centro.CFdescripcion) >
		<cfset v_centrofunc = mid(v_centrofunc, 1, 255) >
		
		<cfset fechaingreso = dateformat(fechaingreso,'dd/mm/yyyy') >

		
	<!--- ACTUALIZACION DE DATOS EN TABLA TEMPORAl--->
		<cfquery datasource="#session.DSN#">
			update #datos#
			set	fechaingreso 		= '#fechaingreso#', 
				fechasalida 		= '#fechasalida#', 
				motivosalida 		= '#motivosalida#', 
				deducciones 		= #deducciones#,
				cargas_promedio 	= #cargas_promedio#,
				asociacion_promedio = #asociacion_promedio#,
				salario_base 		= #salario_base#,
				cargas_base 		= #cargas_base#,
				asociacion_base 	= #asociacion_base#,
				liquido_base_ded 	= #salario_base - cargas_base - asociacion_base-renta_base#, 
				liquido_promedio 	= #v_salariopromedio - cargas_promedio - asociacion_promedio-renta_promedio#, 
				liquido_base 		= #salario_base - cargas_base - asociacion_base#,
				liquido_todasdeduc	= #salario_base - cargas_base - asociacion_base - deducciones#,
				embargo 			= '#embargos#',
				tipoembargo 		= '#tipoembargo#',
				labora 				= '#labora#',
				salario_promedio 	= #v_salariopromedio#,
				usuario 			= '#mid(rs_usuario.usuario, 1, 255)#',
				centrofunc 			= '#v_centrofunc#',
				usuariocentrofunc 	= '#v_usuariocentrofunc#'
		</cfquery>		
		
		<cfinvoke component="sif.Componentes.fechaEnLetras" method="fnFechaEnLetras" returnvariable="vFechaEnLetras">
				<cfinvokeargument name="Fecha" value="#dateformat(fechaingreso,'dd/mm/yyyy')#"/>
		</cfinvoke>
		<cfset fechaingreso = ' #vFechaEnLetras#' >
		
<!--- 
	==========================================================================================
	SE FORMATEAN LOS MONTOS Y DEJARLOS CON DOS DECIMALES
	==========================================================================================}
--->

		<cfquery name="rsQueryFormatos" datasource="#session.DSN#">
			select coalesce(salario_base,0) as salario_base,
				   coalesce(liquido_base_ded,0) as liquido_base_ded, 
				   coalesce(cargas_promedio,0) as cargas_promedio,
				   coalesce(asociacion_promedio,0) as asociacion_promedio,
				   coalesce(liquido_base_ded,0) as liquido_base_ded,
				   coalesce(renta_base,0) as renta_base,
				   coalesce(renta_promedio,0) as renta_promedio,
				   coalesce(liquido_promedio,0) as liquido_promedio,
				   coalesce(liquido_base,0) as liquido_base,
				   coalesce(salario_promedio_calc,0) as salario_promedio_calc,
				   coalesce(deducciones,0) as deducciones,
				   coalesce(salario_promedio,0) as salario_promedio,
				   coalesce(liquido_promedio_ded,0) as liquido_promedio_ded,
				   coalesce(cargas_base,0) as cargas_base,
				   coalesce(asociacion_base,0) as asociacion_base,
				   coalesce(renta_base,0) as renta_base,
				   coalesce(liquido_todasdeduc,0) as liquido_todasdeduc
			from #datos#
		</cfquery>

		<cfif len(trim(rsQueryFormatos.salario_base)) >
			<cfset v_salario_base = LSNumberFormat(rsQueryFormatos.salario_base, ',9.00') >
			<cfset v_liquido_base_ded = LSNumberFormat(rsQueryFormatos.liquido_base_ded, ',9.00') >
			<cfset v_salario_promedio = LSNumberFormat(rsQueryFormatos.salario_promedio, ',9.00') >			
			<cfset v_cargas_promedio = LSNumberFormat(rsQueryFormatos.cargas_promedio, ',9.00') >			
			<cfset v_asociacion_promedio = LSNumberFormat(rsQueryFormatos.asociacion_promedio, ',9.00') >			
			<cfset v_liquido_base_ded = LSNumberFormat(rsQueryFormatos.liquido_base_ded, ',9.00') >
			<cfset v_renta_base = LSNumberFormat(rsQueryFormatos.renta_base, ',9.00') >			
			<cfset v_renta_promedio = LSNumberFormat(rsQueryFormatos.renta_promedio, ',9.00') >			
			<cfset v_liquido_promedio = LSNumberFormat(rsQueryFormatos.liquido_promedio, ',9.00') >
			<cfset v_liquido_base = LSNumberFormat(rsQueryFormatos.liquido_base, ',9.00') >			
			<cfset v_deducciones = LSNumberFormat(rsQueryFormatos.deducciones, ',9.00') >			
			<cfset v_liquido_promedio_ded = LSNumberFormat(rsQueryFormatos.liquido_promedio_ded, ',9.00') >
			<cfset v_cargas_base = LSNumberFormat(rsQueryFormatos.cargas_base, ',9.00') >			
			<cfset v_asociacion_base = LSNumberFormat(rsQueryFormatos.asociacion_base, ',9.00') >
			<cfset v_liquido_todasdeduc = LSNumberFormat(rsQueryFormatos.liquido_todasdeduc, ',9.00') >
			<cfset v_salario_bis = LSNumberFormat((rsQueryFormatos.salario_base*12)/26, ',9.00') >
		</cfif> 
		
		<cfquery datasource="#session.DSN#" name="letras">
			select liquido_base_ded, salario_base from  #datos#
		</cfquery>
		
		<cfinvoke component="sif.Componentes.montoEnLetras" method="fnMontoEnLetras" returnvariable="LvarEnLetras">
			<cfinvokeargument name="Monto" value="#letras.liquido_base_ded#"/>
		</cfinvoke>
		<cfset liquido_letras = ' #LvarEnLetras#' >
		
		<cfinvoke component="sif.Componentes.montoEnLetras" method="fnMontoEnLetras" returnvariable="LvarEnLetras">
			<cfinvokeargument name="Monto" value="#letras.salario_base#"/>
		</cfinvoke>
		<cfset salario_letras = ' #LvarEnLetras#' >

		
<!--- 
	==========================================================================================
	DESPIEGUE DE LOS DATOS DE LA CONSTANCIA
	==========================================================================================}
--->


<cfquery name="rsQuery" datasource="#session.DSN#">
	select 	DEid,
			nombre, 
			identificacion, 
			empresa,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#fechaingreso#"> as fechaingreso,
			<cfif alafecha EQ 'a la fecha'>
				'a la fecha' as fechasalida,
				'por tiempo indefinido.' as hastalabores,
			<cfelse>
				fechasalida as fechasalida, 
				'#hastalabores#' as hastalabores,
			</cfif>
			motivosalida,
			puesto, 
			cf as centro_funcional,
			'#v_deducciones#'as deducciones,
			'#v_cargas_promedio#'as cargas_promedio,
			'#v_asociacion_promedio#'as asociacion_promedio,
			'#v_liquido_promedio_ded#'as liquido_promedio_ded, 

			'#v_salario_base#' as salario_base,
			'#v_cargas_base#'as cargas_base,
			'#v_asociacion_base#'as asociacion_base,
			'#v_liquido_base_ded#'as liquido_base_ded, 
		
			'#v_renta_base#'as renta_base,
			'#v_renta_promedio#'as renta_promedio,
	
			'#v_liquido_promedio#'as liquido_promedio, 
			'#v_liquido_base#'as liquido_base, 
			'#v_salario_promedio#' as salario_promedio,
			'#v_liquido_todasdeduc#' as liquido_todasdeduc,
			'#v_salario_bis#'  as salario_bisemanal,
			embargo,
			tipoembargo,
			labora, 
			centrofunc,
			usuariocentrofunc,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#fecha#"> as fecha,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#periodos_laborados#"> as periodos_laborados,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#meses_laborados#"> as meses_laborados,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#liquido_letras#"> as liquido_letras,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#salario_letras#"> as salario_letras,	
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#porlotanto#"> as por_lo_tanto,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#alafecha#"> as a_la_fecha,
			nacionalidad as Nacionalidad,
			direccion as Direccion,
			cuentabancaria as cuentabancaria,
			banco as Banco
		from #datos#
</cfquery>