<!---
-----Script para determinar Constancias de Salario
-----Origen: Juan Carlos Gutierrez
-----Adecuado: Josue Gamboa
-----Depurado: Lizandro Villalobos
-----25-11-2008
-----Modificado: Roxana Bolanos 25/NOV/2009
-----ljimenez 
--->
	          
		   
<!---
==========================================================================================
PROCEDIMIENTO DE SALARIO PROMEDIO DE LA CALCULADORA, CON ULTIMAS MODIFICACIONES, PARA SALARIO PROMEDIO REAL
==========================================================================================
--->

<cfset vDebug ="false">


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
	
		<cf_dbtemp name="PagosEmplv110" returnvariable="tbl_PagosEmpleado">
			<cf_dbtempcol name="Registro" type="numeric" identity="yes" mandatory="yes"> 
			<cf_dbtempcol name="RCNid" type="numeric">
			<cf_dbtempcol name="DEid" type="numeric"> 
			<cf_dbtempcol name="FechaDesde" type="date">
			<cf_dbtempcol name="FechaHasta" type="date">
			<cf_dbtempcol name="Cantidad" type="int">
			<cf_dbtempkey cols="Registro">
		</cf_dbtemp>
		
		<cf_dbtemp name="PAgosPEriodos101" returnvariable="PAgosPEriodos">
			<cf_dbtempcol name="RCNid"       type="numeric">
			<cf_dbtempcol name="FechaDesde"  type="date">
			<cf_dbtempcol name="FechaHasta"  type="date">
			<cf_dbtempcol name="salario"     type="float">
			<cf_dbtempcol name="incidencias" type="float">
			<cf_dbtempcol name="dias" type="int">
			<cf_dbtempcol name="liquido"     type="float">
			<cf_dbtempcol name="renta"     type="float">
			
		</cf_dbtemp>
	
			<cfquery name="rsTipoPago" datasource="#Session.DSN#">
				select 	Ttipopago, <cf_dbfunction name="to_float" args="FactorDiasSalario"> as FactorDiasSalario
				from TiposNomina
				where Ecodigo 	= <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
					and Tcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#vTcodigo#">
			</cfquery>
			<cfset Ttipopago = rsTipoPago.Ttipopago>
					
			<cfquery name="rsDiasNoPago" datasource="#Session.DSN#">
				select count(1) as diasnopago
				from DiasTiposNomina
				where Ecodigo 	= <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
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
					insert into #PAgosPEriodos# (FechaDesde,FechaHasta,RCNid,salario,incidencias,
					liquido, renta)
					select
					pe.FechaDesde,
					pe.FechaHasta,
					se.RCNid,
					sum(SEsalariobruto + SEincidencias) as salario,
					0.00 as incidencias,
					sum(se.SEliquido) as liquido,
					sum(se.SErenta) as renta
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
					(salario - incidencias) as salario, dias
					, liquido, renta
					from #PAgosPEriodos#
					order by FechaDesde desc,FechaHasta
				</cfquery>
				
				<cfquery name="rspromedio"  dbtype="query">
					select sum(salario) / sum(dias) as SalarioPromedioDiario
					from rsmeses
				</cfquery>
				
				<cfquery name="rspromedioLiquido"  dbtype="query">
					select sum(liquido) / sum(dias) as SalarioPromedioDiarioLiquido
					from rsmeses
				</cfquery>
				
			
				
				<cfquery name="rspromedioRenta"  dbtype="query">
					select sum(renta) / sum(dias) as SalarioPromedioDiarioRenta
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
				<!--- Obtener los clculos del salario promedio entre los perodos --->
				<cfset SalarioPromedioDiario = rspromedio.SalarioPromedioDiario>
				<cfset SalarioPromedio = SalarioPromedioDiario * rsTipoPago.FactorDiasSalario>
				<cfset V_SalarioLiquido = rspromedioLiquido.SalarioPromedioDiarioLiquido * rsTipoPago.FactorDiasSalario  >
				<cfset V_SalarioRenta = rspromedioRenta.SalarioPromedioDiarioRenta * rsTipoPago.FactorDiasSalario  >
				
				
				<cfif vDebug>
					salarios que se toman en cuenta para el calculo promedio
					<cfquery name="Salarios" datasource="#Session.DSN#">
						select *
						from #tbl_PagosEmpleado#
					</cfquery>
					
					<cf_dump var="#Salarios#">
				</cfif>
				
								
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
		<cfset Fecha_Extension = ' #vFechaEnLetras#' >
<!---
==========================================================================================
INICIALIZACION DE VARIABLES DE TRABAJO
==========================================================================================
--->		
		<cfset salario_promedio 	= 0  >
		<cfset asociacion_promedio	= 0  >
		<cfset cargas_promedio 		= 0  >		
		<cfset salario_base 		= 0  >	
		<cfset asociacion 			= 0  >		
		<cfset v_leyendaEmbargo 		= '' >
		<cfset fechaingreso 		= '' >
		<cfset fechasalida 			= '' >
		<cfset labora 				= '' >

<!---
==========================================================================================
TABLA DE DONDE SALEN VAN A ALMACENARSE LOS VALORES CALCULADOS
==========================================================================================
--->
		<cf_dbtemp name="TMPconstancias" returnvariable="datos" datasource="#session.dsn#">
			<cf_dbtempcol name="DEid"					type="numeric"  		mandatory="no">
			<cf_dbtempcol name="nombre"					type="varchar(100)"  	mandatory="no">
			<cf_dbtempcol name="identificacion"			type="varchar(25)"		mandatory="no">
			<cf_dbtempcol name="empresa"				type="varchar(100)"		mandatory="no">
			<cf_dbtempcol name="fechaingreso"			type="varchar(10)"		mandatory="no">
			<cf_dbtempcol name="puesto"					type="varchar(100)"		mandatory="no">
			<cf_dbtempcol name="CentroFuncional"	    type="varchar(100)"		mandatory="no">
			<cf_dbtempcol name="fechasalida"			type="varchar(50)"		mandatory="no">
			<cf_dbtempcol name="motivosalida"			type="varchar(250)"		mandatory="no">
			<cf_dbtempcol name="cargas_promedio"		type="money"			mandatory="no">				
			<cf_dbtempcol name="salario_promedio"		type="money"			mandatory="no">
			<cf_dbtempcol name="asociacion_promedio"	type="money"			mandatory="no">		
			<cf_dbtempcol name="salario_base"			type="money"  			mandatory="no">							
			<cf_dbtempcol name="liquido_promedio"		type="money"			mandatory="no">					
			<cf_dbtempcol name="renta_promedio"			type="money"			mandatory="no">
			<cf_dbtempcol name="Leyenda_Embargo"        type="varchar(50)"  	mandatory="no">			
			<cf_dbtempcol name="labora"					type="varchar(50)"  	mandatory="no">
			<cf_dbtempcol name="salario_promedio_calc"	type="money"  			mandatory="no">
			<cf_dbtempcol name="usuario"				type="varchar(255)"		mandatory="no">
			<cf_dbtempcol name="centrofunc"				type="varchar(255)"		mandatory="no">
			<cf_dbtempcol name="usuariocentrofunc"		type="varchar(255)"		mandatory="no">
			<cf_dbtempcol name="usuarioGeneraBoleta"    type="varchar(255)"     mandatory="no">
			<cf_dbtempcol name="estado"                 type="varchar(25)"		mandatory="no">
			<cf_dbtempcol name="tipoidentificacion"     type="varchar(25)"		mandatory="no">
			<cf_dbtempcol name="departamento"	     	type="varchar(100)"		mandatory="no">
			<cf_dbtempcol name="oficina"	   	  		type="varchar(100)"		mandatory="no">
			<cf_dbtempcol name="MontoEmbargoyPension"   type="money"            mandatory="no">
						
		</cf_dbtemp>	
		
<!---
==============================================================================================================================================
SE EXTRAE El DEid DEL EMPLEADO AL QUE SE LE HACE LA CERTIFICACION,PARA EL CALCULO DEL SALARIO PROMEDIO DENTRO DE LA LINEA DEL TIEMPO
==============================================================================================================================================
--->
	<cfquery name="rs_empleado" datasource="#session.DSN#">
		select 	DEid 
		from DatosEmpleado a, Empresas e
		where DEidentificacion = <cfqueryparam cfsqltype="cf_sql_varchar" value="#pDEidentificacion#"> <!--- parametro ver como hacer esto --->
		  and a.Ecodigo = e.Ecodigo
		  and a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#"> <!--- parametro ver como hacer esto --->
	</cfquery>
	
	<cfset v_Deid= rs_empleado.DEid>  

<!---
==========================================================================================
SE INSERTA LA INFORMACION DEL EMPLEADO GENERAL EN LA TABLA DE TRABAJO
==========================================================================================
--->
		<cfquery datasource="#session.DSN#">
			insert into #datos# ( DEid, nombre , identificacion , empresa , fechaingreso , puesto, tipoidentificacion )
			select 	DEid, 
			        <cf_dbfunction name="concat" args="DEapellido1,' ',DEapellido2,' ',DEnombre"> ,			
					DEidentificacion,
					Edescripcion, 
					null, 
					null,
					c.NTIdescripcion
			from DatosEmpleado a, NTipoIdentificacion c, Empresas e
			where DEidentificacion = <cfqueryparam cfsqltype="cf_sql_varchar" value="#pDEidentificacion#"> <!--- parametro ver como hacer esto --->
			and a.NTIcodigo = c.NTIcodigo
			and a.Ecodigo = e.Ecodigo
			and a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#"> <!--- parametro ver como hacer esto --->
		</cfquery>
		
		
<!---
==========================================================================================
SE ESPECIFICA EL PUESTO CENTRO FUNCIONAL AL DIA DE HOY
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
							  
			CentroFuncional = ( select min(e.CFdescripcion)
							from LineaTiempo b, RHPlazas c, CFuncional e
							where b.DEid = #datos#.DEid
							  and b.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#"> 
							  and (<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#"> between b.LTdesde and b.LThasta )
							  and b.RHPid = c.RHPid
							  and e.CFid = c.CFid),
							  
			departamento 	= (select min(c.Ddescripcion)
									from LineaTiempo a, Departamentos c
									where (<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#"> between a.LTdesde and a.LThasta)
									and a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#"> 
									and a.DEid = #datos#.DEid
									and a.Dcodigo = c.Dcodigo)
									,
									
			oficina 	= (select max(c.Odescripcion)
									from LineaTiempo a, Oficinas c
									where <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#"> between a.LTdesde and a.LThasta
										and a.DEid = #datos#.DEid
										and a.Ocodigo = c.Ocodigo
										and a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
										and a.Ecodigo = c.Ecodigo
										and a.LThasta = (select Max(x.LThasta) 
														from LineaTiempo x
														where x.DEid = #datos#.DEid
															and  x.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">))
		</cfquery>
		
<!---		
<cfquery   datasource="#session.DSN#" name="x" >
			select c.*
				from LineaTiempo a, Oficinas c
				where (<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#"> between a.LTdesde and a.LThasta)
					and a.DEid = 631
					and a.Ocodigo = c.Ocodigo
					and a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
					and a.Ecodigo = c.Ecodigo
					and a.LThasta = (select Max(x.LThasta) 
									from LineaTiempo x
									where x.DEid = 631
									and  x.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">)
									

</cfquery> 

<cf_dump var="#x#">
		
---->	
		
<!---
==========================================================================================
ESPECIFICA LA FECHA DE INGRESO SEGUN LA INFORMACION DE EVACIONESEMPLEADO Y SU ULTIMO EVANTIG
==========================================================================================
--->		

	    <cf_dbfunction name="to_char" args="EVfantig,105" returnvariable="vingreso2">
	    
		<cfquery   datasource="#session.DSN#" >
			update #datos#
			set fechaingreso =  ( select #vingreso2#
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
		    <cfset v_EmbargosyPension = 0.00 >
		<!--- VALORES POR DEFECTO PARA UN EMPLEADO INACTIVO --->
			<cfset estado='INACTIVO'>  
			<cfset v_leyendaEmbargo = 'Inactivo' >
			<cfset alafecha = '' >
			<cfset labora = 'laboró' >
			<cfset porlotanto = 'Por lo tanto a partir de esta fecha no tiene ninguna relación laboral con esta empresa' >
			<cfset ultima_fecha = fechasalida >
			<!--- DETERMINA EL CENTRO FUNCIONAL Y PUESTO DONDE ESTUVO POR ULTIMA VEZ --->
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
					CentroFuncional = ( 			select max(e.CFdescripcion)
									from LineaTiempo b, RHPlazas c, CFuncional e
									where b.DEid=#datos#.DEid
									  and b.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#"> 
									  and (<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#"> > b.LThasta )
									  and b.RHPid = c.RHPid
									  and e.CFid = c.CFid),
									  
					departamento 	= (select max(c.Ddescripcion)
									from LineaTiempo a, Departamentos c
									where (<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#"> > a.LThasta)
									and a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
									and a.DEid = #datos#.DEid
									and a.Dcodigo = c.Dcodigo),
									
					oficina 	=  (select max(c.Odescripcion)
									from Oficinas c
										where c.Ocodigo = (select a.Ocodigo
																from LineaTiempo a
																where DEid = #datos#.DEid
																	and LThasta = (select max(LThasta) from LineaTiempo b where DEid = #datos#.DEid
																		and  b.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">))
										and  c.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">)
					
					
					
					<!---(select max(c.Odescripcion)
									from LineaTiempo a, Oficinas c
									where (<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#"> > a.LThasta)
									and a.DEid = #datos#.DEid
									and a.Ocodigo = c.Ocodigo
									and a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">)--->
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
			
			<cfset motivosalida = 'motivo de #rsMotivoSalida.Motivo#'>
			
			<!--- A LA FECHA DE SALIDA SE LE GENERA UN FORMATO EN LETRAS--->
			<cfinvoke component="sif.Componentes.fechaEnLetras" method="fnFechaEnLetras" returnvariable="vFechaEnLetras">
				<cfinvokeargument name="Fecha" value="#dateformat(fechasalida,'dd/mm/yyyy')#"/>
			</cfinvoke>
			<cfset fechasalida = ' hasta el #vFechaEnLetras#' >
		
			<!--- LAS VARIABLES DE RENTA SE VUELVEN CERO AL ESTAR CESADO--->
			<cfset renta_promedio=0>			
<cfelse>
			
		<!---
==========================================================================================
	EL EMPLEADO ESTA ACTIVO
==========================================================================================
--->
			<!--- VALORES POR DEFECTO PARA UN EMPLEADO ACTIVO--->	
			<cfset estado='ACTIVO'>   
			<cfset fechasalida = '' >
			<cfset motivosalida = '' >
			<cfset porlotanto = '' >
			<cfset labora = 'labora' >
			<cfset alafecha = 'a la fecha' >
			<cfset ultima_fecha = pFecha>
			
			<!--- CALCULA SALARIO BASE  ---> <!---  2.Salario de Contrataccion  --->
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
					set salario_base = <cfqueryparam cfsqltype="cf_sql_float" value="#salario_base#">		
				<!--- <cfqueryparam cfsqltype="cf_sql_varchar" value="#salario_base#"> --->
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
			
				
		<!---  CALCULA VALOR CUOTA ASOCIACION --->
			<cfquery name="rsAsociacion" datasource="#session.DSN#">
				select coalesce(DCvaloremp,0) as DCvaloremp
				from CargasEmpleado a, DCargas b, #datos# c
				where a.DEid = c.DEid
				and a.DClinea = b.DClinea
				and upper(b.DCcodigo) = 'ASOC' <!--- OJO ESTE PARAMETRO ES DE Purdy, PUEDE VARIAR DEPENDIENDO CLIENTE --->
			</cfquery>
						
			<cfif len(trim(rsAsociacion.DCvaloremp))>
				<cfset asociacion = rsAsociacion.DCvaloremp >
			</cfif>
						
		    
<!--- CALCULA SI EL EMPLEADO ESTA EMBARGADO CON RELACION A LA ULTIMA(S) NOMINA(S), HACE UN CALCULO APROX. DEPEDNIENDO DE LA FRECUENCIA DE PAGO ****** --->			
       
		<cfquery name="rsUltimaNomina" datasource="#session.DSN#">	
			select max(RCNid)as ultimaNomina 
    		from  HSalarioEmpleado, CalendarioPagos
    		where DEid= #v_Deid#
    			and CPtipo = 0   
		</cfquery>		
		<cfset v_ultimaNomina = rsUltimaNomina.ultimaNomina>
		
		
		
		<cfif v_ultimaNomina NEQ '' >
		
	    <!--- VERIFICA QUE LA NOMINA ENCONTRADA ES ORDINARIA ---> 
		<cfquery name="rsEsOrdinaria" datasource="#session.DSN#">			
			select 1 as verificar   		   		 
			from  HRCalculoNomina nomina, CalendarioPagos calend
			where nomina.RCNid= #v_ultimaNomina#					
				and nomina.Ecodigo = calend.Ecodigo
				and nomina.Tcodigo =calend.Tcodigo
				and nomina.RCNid= calend.CPid 	
				and calend.CPtipo = 0   				
		</cfquery>
		
		<cfif rsEsOrdinaria.verificar  NEQ  1>
			<cfquery name="rsSiguienteNomina" datasource="#session.DSN#">
				select max(h.RCNid) as SiguienteNomina
				from HSalarioEmpleado h, CalendarioPagos c
				where h.DEid = #v_Deid#
				and h.RCNid <> #v_ultimaNomina#	
				and h.RCNid = c.CPid
				and c.CPtipo = 0   
    		</cfquery>	    		
    		<cfset v_ultimaNomina = rsSiguienteNomina.SiguienteNomina>    		
		</cfif>
		
<!---
select max(RCNid)as SiguienteNomina 
from  HSalarioEmpleado
where DEid = #v_Deid#
and RCNid <> #v_ultimaNomina#	
and CPtipo = 0   
--->
		
								
		<cfquery name="rsFrecuenciaPago" datasource="#session.DSN#">
			select Tnomina.Ttipopago as tipoPago
			from HRCalculoNomina nomina, TiposNomina Tnomina
			where nomina.RCNid=#v_ultimaNomina#
			and nomina.Tcodigo = Tnomina.Tcodigo
			and nomina.Ecodigo =  Tnomina.Ecodigo
		</cfquery>
		
		<cfset v_tipoPago = rsFrecuenciaPago.tipoPago>		
					
		<cfswitch expression="#v_tipoPago#">
				<cfcase value="0"> <cfset FrecuenciaPago = 'Semanal'> </cfcase>
				<cfcase value="1"> <cfset FrecuenciaPago = 'Bisemanal'> </cfcase>
				<cfcase value="2"> <cfset FrecuenciaPago = 'Quincenal'> </cfcase>  
				<cfcase value="3"> <cfset FrecuenciaPago = 'Mensual'> </cfcase>
				<cfdefaultcase> <cfset FrecuenciaPago = 'Mensual'> </cfdefaultcase>
		</cfswitch>
		
		
		<!---  Por cada nomina Se totalizan los montos, ya que el monto por Embargo y Pension se distribuye entre cada nomina --->		
		<cfif FrecuenciaPago EQ 'Semanal' or FrecuenciaPago EQ 'Bisemanal' or FrecuenciaPago EQ 'Quincenal'>
		        
				<!--- Encuentra el periodo y mes de la Ultima nomina Calculada  ---> 				
				<cfquery name="rsPeriodoMesdeUltimaNomina" datasource="#session.DSN#">			
			   		select calendario.CPperiodo as periodo, 
				   		calendario.CPmes as mes
				   		,nomina.Tcodigo as Tcodigo, 
				   		nomina.Ecodigo  
			   		from  HRCalculoNomina nomina, CalendarioPagos calendario
					
			   		where nomina.RCNid= #v_ultimaNomina#
						and nomina.Ecodigo = calendario.Ecodigo
						and nomina.Tcodigo = calendario.Tcodigo
						and nomina.RCNid= calendario.CPid 	
						and calendario.CPtipo = 0   --Solo Nominas Ordinarias				
				</cfquery>

			 
		        <!--- Para la ultima nomina calculada se obtiene Periodo, Mes ,Tipo de Nomina y Ecodigo --->
				<cfset v_periodo = rsPeriodoMesdeUltimaNomina.periodo>
				<cfset v_mes = rsPeriodoMesdeUltimaNomina.mes>
				<cfset v_Tcodigo = rsPeriodoMesdeUltimaNomina.Tcodigo >
				<cfset v_Ecodigo= rsPeriodoMesdeUltimaNomina.Ecodigo>
																	
				<!--- Cantidad de Nominas cerradas (que esten en la tabla HRCalculoNomina ) de ese tipo de nomina, periodo y mes   --->
				<cfquery name="rsNominasCerradas" datasource="#session.DSN#">	
					select  count(nomina.RCNid)as NominasCerradas
					from CalendarioPagos calend, HRCalculoNomina nomina
					where calend.Tcodigo=<cfqueryparam cfsqltype="cf_sql_varchar" value="#v_Tcodigo#">  
					and calend.Ecodigo=#v_Ecodigo#
					and calend.CPperiodo=#v_periodo#
					and calend.CPmes=#v_mes#
					and calend.CPtipo = 0   --Solo Nominas Ordinarias	
					and nomina.RCNid = calend.CPid  
					and nomina.Tcodigo = calend.Tcodigo 
					and nomina.Ecodigo = calend.Ecodigo	
				</cfquery>								
				<cfset v_nominas_cerradas = rsNominasCerradas.NominasCerradas>	
								
				<!--- Cantidad de Nominas encontradas para ese periodo y mes   --->
				<cfquery name="rsNominas" datasource="#session.DSN#">	
					select  count(calend.CPid )as cantNominas
					from CalendarioPagos calend
					where calend.Tcodigo=<cfqueryparam cfsqltype="cf_sql_varchar" value="#v_Tcodigo#">  
					and calend.Ecodigo=#v_Ecodigo#
					and calend.CPperiodo=#v_periodo#
					and calend.CPmes=#v_mes#
					and calend.CPtipo = 0   --Solo Nominas Ordinarias
				</cfquery>				
				<cfset v_cantNominas=rsNominas.cantNominas>	
				
				<!--- SE TOTALIZA EL MONTO CALCULADO POR CONCEPTO DE EMBARGO Y PESNIONES EN LA TABLA HDeduccionesCalculo PARA C/U DE LAS NOMINAS DE ESE PERIODO Y MES  --->
				<cfquery name="rsEmbargosyPension" datasource="#session.DSN#">		
					select coalesce(sum(deduccCal.DCvalor),0 ) as EmbargosyPension					     					      
					from CalendarioPagos calend , HDeduccionesCalculo deduccCal, DeduccionesEmpleado deduccEmpl,  TDeduccion Tdeducc
					where calend.Tcodigo= <cfqueryparam cfsqltype="cf_sql_varchar" value="#v_Tcodigo#">  
					and calend.Ecodigo= #v_Ecodigo#
					and calend.CPperiodo= #v_periodo#
					and calend.CPmes= #v_mes#
					and calend.CPtipo = 0   --Solo Nominas Ordinarias
                    	
					and deduccCal.RCNid = calend.CPid
					and deduccCal.DEid= #v_Deid#
	
					and deduccEmpl.Did =deduccCal.Did
					and deduccEmpl.DEid=deduccCal.DEid
	
					and   deduccEmpl.Ecodigo = Tdeducc.Ecodigo 
					and   ((Tdeducc.TDcodigo = 'DE10' and Tdeducc.TDcodigo = 'DE11') or (Tdeducc.TDcodigo = 'DE10' or Tdeducc.TDcodigo = 'DE11') ) 
					and   Tdeducc.TDid = deduccEmpl.TDid
				</cfquery>
				
				<!--- Esta formula es para el caso de que una nomina no se haya cerrado se calcula un aproximado cercano --->
				<!--- (monto total por Embargos y Pensiones de todas las nominas de ese periodo  y mes/ cantidad de nominas cerradas ) * Cantidad Nominas   --->			
		      	<cfif  (rsEmbargosyPension.EmbargosyPension  gt 0)     > 		     		      			      	
					<cfset v_EmbargosyPension = (#rsEmbargosyPension.EmbargosyPension# / #v_nominas_cerradas#)* #v_cantNominas# > 
					<cfset v_leyendaEmbargo= 'Embargado.'>
				<cfelse>				
					<cfset v_EmbargosyPension = 0.00 >	
					<cfset v_leyendaEmbargo= 'libre de gravámenes o Embargado.'>
				</cfif>		
				
		<cfelse>			
				<cfquery name="rsEmbargosyPension2" datasource="#session.DSN#">	
					select coalesce(sum(deduccCalc.DCvalor),0)as EmbargosyPension
					from HDeduccionesCalculo deduccCalc, DeduccionesEmpleado deduccEmpleado, TDeduccion Tdeducc
					where deduccCalc.RCNid=#v_ultimaNomina#
					and   deduccCalc.DEid=#v_Deid#

					and  deduccEmpleado.DEid=deduccCalc.DEid
					and  deduccEmpleado.Did=deduccCalc.Did

					and deduccEmpleado.Ecodigo = Tdeducc.Ecodigo 
					and ((Tdeducc.TDcodigo = 'TD001' and Tdeducc.TDcodigo = 'TD002') or (Tdeducc.TDcodigo = 'TD001' or Tdeducc.TDcodigo = 'TD002') )
					and   Tdeducc.TDid = deduccEmpleado.TDid			
				</cfquery>	
				<cfset v_EmbargosyPension = rsEmbargosyPension2.EmbargosyPension  >
				<cfif  rsEmbargosyPension2.EmbargosyPension  gt 0     >					
					<cfset v_leyendaEmbargo= 'Embargado.'>
				<cfelse>
					<cfset v_leyendaEmbargo= 'libre de gravámenes/Embargado.'>					
			    </cfif>				
		</cfif>
		<cfelse>
			<cfset v_EmbargosyPension = 0.00 >
			<cfset v_leyendaEmbargo= 'libre de gravámenes/Embargado.'>
	</cfif>	
		
		
					
</cfif>	

<!---
==========================================================================================
PARA CUALQUIER EMPLEADO SEA ACTIVO O INACTIVO
==========================================================================================
--->
	
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
	<cfset v_3 = f_salariopromedio(rs_empleado.DEid, LSDateFormat(pFecha, 'dd/mm/yyyy') ) >
	<cfif not isnumeric(v_3)>
		<cfset v_salariopromedio = 0 >
	<cfelse>
		<cfset v_salariopromedio = v_3 >
	</cfif> 
	
	
	<!--- El salario promedio es igual a cero cuando el empleado esta cesado ó --->
	<!--- en el caso en que los historicos de pagos de un empleado estan en un tipo de nomina diferente a la que fue nombrada  --->
	<cfif v_salariopromedio EQ 0>
		<!--- 2009-12-15 RX. PARA EL CASO EN QUE LOS HISTORICOS ESTAN EN UN TIPO DE NOMINA DIFERENTE A LA QUE FUERON NOMBRADA, se toma el ultimo salario --->
		<cfquery name="rs_ultimoSalario" datasource="#session.DSN#">
				select LTsalario
				from LineaTiempo
				where DEid = #rs_empleado.DEid#
				and <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(pFecha)#"> between LTdesde and LThasta
		</cfquery>
		<!--- Si no trae ningun registro es que el empleado esta cesado   --->
		<cfif rs_ultimoSalario.recordCount eq 0  >
		<cfset v_salariopromedio = 0 >
		<cfelse>		
		<cfset v_salariopromedio = rs_ultimoSalario.LTsalario >
	 </cfif>
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
		
	
<!--- ============================================ --->
<!---  
	    El cambio para la cuota del trabajador para el 2010 es el 9.17%  	  
      PARA QUE EL CAMBIO SEA DINAMICO SE TRABAJA CON AQUELLAS CARGAS EMPLEADO QUE PERTENEZCAN 
      AL GRUPO DE AUTOMATICAS, PERO QUE NO TENGAN EL CHECK DE PROVISION	  
--->
<!--- ============================================ --->
	<cfquery name="CargasEmpleado" datasource="#session.DSN#">
		Select (coalesce(Sum(DCvaloremp),0)/100) as cargasEmpl
		from DCargas a, <!--- Detalle de Cargas --->
			 ECargas b  <!--- Encabezado de Cargas --->
		Where a.ECid =b.ECid
		and   b.ECauto=1 <!--- De Ley o Asociadas automáticamente --->
		and   a.DCprovision=0 <!--- No se etiquetaron como tipo Provisión --->
		and   b.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	</cfquery>

	<cfset cargas_promedio = v_salariopromedio * #CargasEmpleado.cargasEmpl#>
				
	
	<!--- USUARIO QUE GENERA LA BOLETA --->
		<cfquery name="rs_usuario" datasource="#session.DSN#">
			select <cf_dbfunction name="concat" args="Pnombre,' ',Papellido1,' ',Papellido2"> as usuario
			from DatosPersonales dp, Usuario u
			where u.Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#" >
			and u.datos_personales=dp.datos_personales
		</cfquery>
		
		<!--- ROX --->
		<cfset v_usuarioGeneraBoleta = '#rs_usuario.usuario#'>  
		
		<!--- CENTRO FUNCIONAL DE QUIEN GENERA LA BOLETA --->
		<cfset v_usuariocentrofunc = '' >
		<cfquery name="rs_esempleado" datasource="#session.DSN#" >
			select llave
			from UsuarioReferencia
			where Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#" >
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
		<cfset v_centrofunc = trim(rs_centro.CFdescripcion) >		
		<cfset fechaingreso = dateformat(fechaingreso,'dd/mm/yyyy') >

		
	
		<cfif not isdefined("V_SalarioLiquido")>
			<cfset V_SalarioLiquido = 0>
			<cfset v_salariopromedio = 0>
		</cfif>
	<!--- ACTUALIZACION DE DATOS EN TABLA TEMPORAl--->
		<cfquery datasource="#session.DSN#">
			update #datos#
			set	fechaingreso 			= '#fechaingreso#', 
				fechasalida 			= '#fechasalida#', 
				motivosalida 			= '#motivosalida#', 				
				cargas_promedio 		= #cargas_promedio#,
				asociacion_promedio 	= #asociacion_promedio#,
				salario_base 			= #salario_base#,				
				liquido_promedio 		= #V_SalarioLiquido#,
				<!---liquido_promedio 		= #v_salariopromedio - cargas_promedio - asociacion_promedio-renta_promedio#, --->
				
				Leyenda_Embargo 		= '#v_leyendaEmbargo#',				
				labora 					= '#labora#',
				salario_promedio 		= #v_salariopromedio#,
				usuario 				= '#mid(rs_usuario.usuario, 1, 255)#',
				centrofunc 				= '#v_centrofunc#',
				usuariocentrofunc 		= '#v_usuariocentrofunc#',
				usuarioGeneraBoleta 	= '#v_usuarioGeneraBoleta#',		
				estado              	= '#estado#',
				MontoEmbargoyPension 	= #v_EmbargosyPension# 			
				
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
			select 			      
				   coalesce(liquido_promedio,0) as liquido_promedio,				  
				   coalesce(salario_promedio_calc,0) as salario_promedio_calc,				 
				   coalesce(salario_promedio,0) as salario_promedio,		
				   coalesce(salario_base,0) as salario_base,		
				   coalesce(MontoEmbargoyPension,0.00) as  MontoEmbargoyPension
			from #datos#				  
		</cfquery>

		<cfif len(trim(rsQueryFormatos.salario_base)) >	
			<cfset v_salario_base 	  = LSNumberFormat(rsQueryFormatos.salario_base, ',9.00') >		
		    <cfset v_salario_promedio = LSNumberFormat(rsQueryFormatos.salario_promedio, ',9.00') >	 				
			<cfset v_liquido_promedio = LSNumberFormat(rsQueryFormatos.liquido_promedio, ',9.00') >
			<cfset v_EmbargosyPension =	LSNumberFormat(rsQueryFormatos.MontoEmbargoyPension,'99.00') >		
		    
		</cfif> 
		
							
<!--- 
	==========================================================================================
	DESPIEGUE DE LOS DATOS DE LA CONSTANCIA
	==========================================================================================}
--->

<cfquery name="rsQuery" datasource="#session.DSN#">
	select  DEid,
			nombre, 
			identificacion, 
			tipoidentificacion,
			puesto, 
			CentroFuncional as departamento,
			<!---departamento,
			--->
			oficina as sucursal,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#fechaingreso#"> as fechaingreso,  
			<cfif alafecha EQ 'a la fecha'>
				'a la fecha' as fechasalida,
			<cfelse>
				fechasalida,                                                                 
			</cfif>
			estado,                                                                          
			motivosalida as cese,					 	
			'#v_salario_promedio#' as salario_promedio,                                      
			'#v_EmbargosyPension#' as MontoEmbargoyPension,                                  
			'#v_liquido_promedio#' as liquido_promedio,                                      
            Leyenda_Embargo as embargo,			
			 <cfqueryparam cfsqltype="cf_sql_varchar" value="#Fecha_Extension#"> as Fecha,              
			 usuarioGeneraBoleta,                                                             
			 usuariocentrofunc,                                                               
			 labora,  
			 centrofunc,                                                                    
			empresa,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#alafecha#"> as a_la_fecha
			
		from #datos#
</cfquery>




