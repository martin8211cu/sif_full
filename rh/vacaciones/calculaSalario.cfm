<cfif vDebug >FechaInicioCalculo: <cfdump var="#FechaInicioCalculo#"></cfif>

<cfset SalarioUltimosPeriodos = 0>
<cfset SalarioPromedio = 0>
<cfset SalarioPromedioDiario = 0>
<cfset SalarioQuincena = 0>
<cfset fechaFormateada= LSDateFormat(FechaInicioCalculo, "yyyymmdd")>


<cfquery name="dropPagosEmpleado" datasource="#cache#">
	delete from #tbl_PagosEmpleado#
</cfquery>
<cfquery name="dropPagosEmpleado" datasource="#cache#">
	delete  from #PAgosPEriodos#
</cfquery>


<cfquery name="rsFecha" datasource="#cache#">
	select max(LThasta) as LThasta  from LineaTiempo
	where DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#data1.DEid#">
</cfquery>

<cfquery name="rsEncabezado" datasource="#cache#">
	select 
		a.Tcodigo,
		a.Ecodigo,
		a.DEid,
		<cf_dbfunction name="to_float" args="h.FactorDiasSalario" datasource="#cache#"> as FactorDiasSalario
	from LineaTiempo a
	inner join TiposNomina h
			on a.Ecodigo = h.Ecodigo 
			and a.Tcodigo = h.Tcodigo		
	where a.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#data1.DEid#">
	and <cfqueryparam cfsqltype="cf_sql_date" value="#FechaInicioCalculo#"> between a.LTdesde   and a.LThasta   
</cfquery>

<cfif vDebug >rsEncabezado: <cfdump var="#rsEncabezado#"></cfif>

<cfif isdefined("rsEncabezado")  and rsEncabezado.recordCount GT 0>

	<!--- Recupera el parametros de TipoPeriodos --->
	<cfinvoke component="rh.Componentes.RHParametros" method="get" datasource="#cache#" 
		ecodigo="#empresa#" pvalor="161" default="0" returnvariable="TipoPeriodos"/>	

	<cfquery name="rsTipoPago" datasource="#cache#">
		select Ttipopago
		from TiposNomina
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#empresa#">
		and Tcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#rsEncabezado.Tcodigo#">
	</cfquery>
	<cfset Ttipopago = rsTipoPago.Ttipopago>
	
	<cfquery name="rsDiasNoPago" datasource="#cache#">
		select count(1) as diasnopago
		from DiasTiposNomina
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#empresa#">
		and Tcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#rsEncabezado.Tcodigo#">
	</cfquery>
	<cfset DiasNoPago = rsDiasNoPago.diasnopago>
	
	<cfswitch expression="#Ttipopago#">
		<cfcase value="0"> <cfset DiasNoPago = DiasNoPago * 1> </cfcase>
		<cfcase value="1"> <cfset DiasNoPago = DiasNoPago * 2> </cfcase>
		<cfcase value="2"> <cfset DiasNoPago = DiasNoPago * 2> </cfcase>
		<cfcase value="3"> <cfset DiasNoPago = DiasNoPago * 4> </cfcase>
		<cfdefaultcase> <cfset DiasNoPago = DiasNoPago * 1> </cfdefaultcase>
	</cfswitch>
	
	<!--- Recupera el parametros Cantidad de Períodos para Cálculo de Salario Promedio --->
	<cfinvoke component="rh.Componentes.RHParametros" method="get" datasource="#cache#" 
		ecodigo="#rsEncabezado.Ecodigo#" pvalor="440" default="1" returnvariable="CantidadPeriodos"/>	
	
	<cfif CantidadPeriodos lt 1>
		<cfset CantidadPeriodos = 1>
	</cfif> 
	
	
	
	<cfquery name="rsFecha1" datasource="#cache#">
		select max(CPdesde) as fecha1
		from CalendarioPagos
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsEncabezado.Ecodigo#">
		and Tcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#rsEncabezado.Tcodigo#">
		and CPdesde <= <cfqueryparam cfsqltype="cf_sql_date" value="#FechaInicioCalculo#"> 
	</cfquery>
	
	<cfif isdefined("rsFecha1")  and rsFecha1.recordCount GT 0 and len(trim(rsFecha1.fecha1))>
		<cfquery name="rsFecha2" datasource="#cache#">
			select max(CPhasta) as fecha1
			from CalendarioPagos
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsEncabezado.Ecodigo#">
			and Tcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#rsEncabezado.Tcodigo#">
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
			<cfquery name="tbl_PagosEmpleadoInsert" datasource="#cache#">
				insert into #tbl_PagosEmpleado# (RCNid, DEid, FechaDesde, FechaHasta, Cantidad)
					select distinct a.RCNid, #rsEncabezado.DEid#, a.RCdesde, a.RChasta, 0
						from HSalarioEmpleado b, HRCalculoNomina a, CalendarioPagos cp
						where b.DEid = #rsEncabezado.DEid#
							and a.RCNid = b.RCNid
							and a.Ecodigo = #rsEncabezado.Ecodigo#
							and a.RChasta <= <cfqueryparam cfsqltype="cf_sql_date" value="#Fecha1#">
							and a.RCdesde >= <cfqueryparam cfsqltype="cf_sql_date" value="#Fecha2#">
							and cp.CPid = a.RCNid
							<!--- ljimenez se elimina esta condicion para que tome en cuenta todas la nominas incluyendo las especiales
							la configuracion para ver si afectan o no afectan el salario promedio se hace a nivel de sistema --->
							<!--- and cp.CPtipo = 0 ---> 
					order by a.RChasta desc
			</cfquery>
		</cfif>

		<cfif vDebug >
			<cfquery name="tbl_PagosEmpleadoInsert" datasource="#cache#">
				select * from #tbl_PagosEmpleado#
			</cfquery>
			<cfdump var="#tbl_PagosEmpleadoInsert#">
			Fecha1: <cfdump var="#Fecha1#"><br />
			Fecha2: <cfdump var="#Fecha2#"><br />
		</cfif>
	
	
		<!--- Borrar de la historia los periodos donde existe incapacidad --->
		<!---El siguiente codigo se agrega debido a que en el ITCR pagan la incapacidad completa  Tomar en cuenta en Salario Promedio las incapacidades --->
		<cfinvoke component="rh.Componentes.RHParametros" method="get" datasource="#cache#" 
			ecodigo="#empresa#" pvalor="2037" default="0" returnvariable="vUsaIncSP"/>
		
		<cfif #vUsaIncSP# eq 0>
			<cfquery name="delPagosEmpleado" datasource="#cache#">
				delete from #tbl_PagosEmpleado#
				where exists (
					select 1
					from HPagosEmpleado pe, RHTipoAccion d
					where pe.DEid = #tbl_PagosEmpleado#.DEid
						and pe.RCNid = #tbl_PagosEmpleado#.RCNid
						and d.RHTid = pe.RHTid
						and d.RHTcomportam = 5
				)
			</cfquery>
		
			<cfquery name="delPagosEmpleado" datasource="#cache#">
				delete from #tbl_PagosEmpleado#
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
		</cfif>
		<!--- Borrar de la historia los periodos donde existe permisos sin goce de salario --->
		<cfquery name="delPagosEmpleado" datasource="#cache#">
			delete from #tbl_PagosEmpleado#
			where exists (	select 1
							from HPagosEmpleado pe, RHTipoAccion d
							where pe.DEid = #tbl_PagosEmpleado#.DEid
								and pe.RCNid = #tbl_PagosEmpleado#.RCNid
								and d.RHTid = pe.RHTid
								and d.RHTcomportam = 4 
								AND d.RHTpaga = 0)
		</cfquery>
			
		<cfquery name="delPagosEmpleado" datasource="#cache#">
			delete from #tbl_PagosEmpleado#
			where exists (
				select 1
					from 	DLaboralesEmpleado a
					inner join  RHTipoAccion x
						on x.RHTid = a.RHTid
						and x.RHTcomportam = 4 
						and x.RHTpaga = 0
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
		<cfquery name="rsFechaSalida" datasource="#cache#">
			select max(DLfvigencia) as fechasalida
			from DLaboralesEmpleado dl, RHTipoAccion ta
			where dl.DEid = #rsEncabezado.DEid#
			and ta.RHTid = dl.RHTid
			and ta.RHTcomportam = 2
		</cfquery>
		<cfif rsFechaSalida.recordCount and Len(Trim(rsFechaSalida.fechasalida))>
			<cfquery name="delPagosEmpleado" datasource="#cache#">
				delete from #tbl_PagosEmpleado#
				where FechaDesde <= <cfqueryparam cfsqltype="cf_sql_date" value="#rsFechaSalida.fechasalida#"> 
				or    FechaHasta <= <cfqueryparam cfsqltype="cf_sql_date" value="#rsFechaSalida.fechasalida#"> 
			</cfquery>
		</cfif>
	
		<cfquery name="rsPagosEmpleado" datasource="#cache#">
			select RCNid,DEid,FechaDesde,FechaHasta,Cantidad
			from #tbl_PagosEmpleado#
			order by FechaHasta desc,RCNid,DEid
		</cfquery>
		<cfloop query="rsPagosEmpleado">
			<cfquery name="updPagoEmpleado" datasource="#cache#">
				update #tbl_PagosEmpleado#
				set Cantidad = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsPagosEmpleado.CurrentRow#">
				 <!--- where Registro = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsPagosEmpleado.Registro#"> --->
				where RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsPagosEmpleado.RCNid#">
				and DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsPagosEmpleado.DEid#">				
			</cfquery>
		</cfloop>
		
		<cfif TipoPeriodos EQ 1 and Len(Trim(Fecha3))>
			<cfquery name="delPagosEmpleado" datasource="#cache#">
				delete from #tbl_PagosEmpleado#
				where DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#DEid#">
				  and FechaHasta <= <cfqueryparam cfsqltype="cf_sql_date" value="#Fecha3#">
			</cfquery>
		<cfelse>
			<cfquery name="delPagosEmpleado" datasource="#cache#">
				delete from #tbl_PagosEmpleado#
				where  DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#DEid#">
				  and Cantidad > <cfqueryparam cfsqltype="cf_sql_integer" value="#CantidadPeriodos#">
			</cfquery>
		</cfif>	
		
		<cfquery name="rsPagosEmpleado" datasource="#cache#">
			select 1
			from #tbl_PagosEmpleado#
		</cfquery>
			
			
		<cfif rsPagosEmpleado.recordCount>
			<cfquery name="rsSalarioPromedioA" datasource="#cache#">
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
			
			<cfquery name="rsSalarioPromedioC" datasource="#cache#">
				select hp.RCNid, coalesce(sum(PEcantdias), 0) as dias
					from  HPagosEmpleado  hp, #tbl_PagosEmpleado# pe
					where hp.RCNid = pe.RCNid
						and hp.DEid = pe.DEid
						and hp.PEtiporeg = 0
					group by hp.RCNid
			</cfquery>
				
			<cfquery name="rsSalarioPromedioB" datasource="#cache#">
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
					<cfquery name="upSalarioPromedioB" datasource="#cache#">
						update #PAgosPEriodos# set incidencias = <cfqueryparam cfsqltype="cf_sql_float" value="#rsSalarioPromedioB.incidencias#"> 
						where RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsSalarioPromedioB.RCNid#">
					</cfquery>
				</cfloop> 
			</cfif>

			<cfif rsSalarioPromedioC.recordCount GT 0>
				<cfloop query="rsSalarioPromedioC">
					<cfquery name="upSalarioPromedioC" datasource="#cache#">
						update #PAgosPEriodos# set dias = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsSalarioPromedioC.dias#"> 
						where RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsSalarioPromedioC.RCNid#">
					</cfquery>
				</cfloop> 
			</cfif>
			
			<cfquery name="upSalarioPromedioC" datasource="#cache#">
				update #PAgosPEriodos# set RCNDes = (
					select RCDescripcion from  HRCalculoNomina 
					where RCNid = #PAgosPEriodos#.RCNid
				)
			</cfquery>
	
	
			<cfquery name="rsmeses" datasource="#cache#">
				select FechaDesde as RCdesde,
				FechaHasta as RChasta,
				(salario - incidencias) as salario,
				dias,RCNDes
				from #PAgosPEriodos#
				order by FechaDesde desc,FechaHasta
			</cfquery>
	
			<cfquery name="rspromedio"  dbtype="query">
				select sum(salario) / sum(dias) as SalarioPromedioDiario
				from rsmeses
			</cfquery>
			
			
			<cfquery name="rsSalarioPromedio1" datasource="#cache#">
				select sum(SEsalariobruto + SEincidencias) as salario
				from HSalarioEmpleado se, #tbl_PagosEmpleado# pe
				where se.RCNid = pe.RCNid
				and se.DEid = pe.DEid
			</cfquery>
			
			
			<cfif vDebug >
				<cfquery name="xsalarios" datasource="#cache#">
					select 
					se.DEID ,se.RCNID ,se.SEACUMULADO ,se.SECALCULADO ,se.SECARGASEMPLEADO ,se.SECARGASPATRONO,
					se.SEDEDUCCIONES ,se.SEINCIDENCIAS ,se.SEINOCARGAS ,se.SEINODEDUC ,se.SEINORENTA ,se.SELIQUIDO ,
					se.SEPROYECTADO ,se.SERENTA ,se.SESALARIOBRUTO 
					<!---sum(SEsalariobruto + SEincidencias) as salario--->
					from HSalarioEmpleado se, #tbl_PagosEmpleado# pe
					where se.RCNid = pe.RCNid
					and se.DEid = pe.DEid
					and se.DEid = 97
					ORDER BY se.RCNID DESC
				</cfquery>
				
				<cfquery name="xsalariosb" datasource="#cache#">
					select sum(SEsalariobruto) AS BRUTO,sum(SEincidencias) as INCIDENCAS
					<!---sum(SEsalariobruto + SEincidencias) as salario--->
					from HSalarioEmpleado se, #tbl_PagosEmpleado# pe
					where se.RCNid = pe.RCNid
					and se.DEid = pe.DEid
					and se.DEid = 97
				</cfquery>
				
				
				<cfquery name="rsSalarioresta" datasource="#cache#">
					select coalesce(sum(ic.ICmontores), 0.00) as incidencias
					from HIncidenciasCalculo ic, #tbl_PagosEmpleado# pe, CIncidentes ci
					where ic.RCNid = pe.RCNid
					and ic.DEid = pe.DEid
					and ic.DEid = #vDEid#
					and ci.CIid = ic.CIid
					and ci.CIafectasalprom = 0
					and coalesce(ci.CIafectasalpromSP,0) = 0
				</cfquery>
				
			
				xsalarios: <cfdump var="#xsalarios#"> </br>
				xsalariosB: <cfdump var="#xsalariosb#"> </br>
				xsalario Resta: <cfdump var="#rsSalarioresta#"> </br>
				
			</cfif>
			
			<cfquery name="rsSalarioPromedio2" datasource="#cache#">
				select coalesce(sum(ic.ICmontores), 0.00) as incidencias
				from HIncidenciasCalculo ic, #tbl_PagosEmpleado# pe, CIncidentes ci
				where ic.RCNid = pe.RCNid
				and ic.DEid = pe.DEid
				and ci.CIid = ic.CIid
				and ci.CIafectasalprom = 0
				and coalesce(ci.CIafectasalpromSP,0) = 0
			</cfquery>
			
					
			<cfif len(trim(rsEncabezado.FactorDiasSalario)) eq 0 >
					<!--- Recupera el parametros de TipoPeriodos --->
					<cfinvoke component="rh.Componentes.RHParametros" method="get" datasource="#cache#" 
						ecodigo="#empresa#" pvalor="80" default="0" returnvariable="ValorPromedioDiario"/>	
			<cfelse>
				<cfset ValorPromedioDiario = rsEncabezado.FactorDiasSalario>
			</cfif>
			
			<!--- ljimenez se corrige el calculo --->
			<!--- Obtener los cálculos del salario promedio entre los períodos --->
			<cfset SalarioUltimosPeriodos = (rsSalarioPromedio1.salario - rsSalarioPromedio2.incidencias)>
			<cfset SalarioPromedio        =  SalarioUltimosPeriodos / CantidadPeriodos>
			<cfset SalarioPromedioDiario  =  SalarioPromedio / ValorPromedioDiario>
			<cfset SalarioQuincena = SalarioPromedio / 2>
			<cfif vDebug >
				CantidadPeriodos: 		<cfdump var="#CantidadPeriodos#"> </br>
				ValorPromedioDiario: 	<cfdump var="#ValorPromedioDiario#"></br>
				
				SalarioUltimosPeriodos: <cfdump var="#SalarioUltimosPeriodos#"></br>
				SalarioPromedio: 		<cfdump var="#SalarioPromedio#"></br>
				SalarioPromedioDiario: 	<cfdump var="#SalarioPromedioDiario#"></br>
				SalarioQuincena: 		<cf_dump var="#SalarioQuincena#"></br>
			</cfif>
			 
		<cfelse>
			<cfset SalarioUltimosPeriodos = 0>
			<cfset SalarioPromedio = 0>
			<cfset SalarioPromedioDiario = 0>
			<cfset SalarioQuincena = 0>
		</cfif>	
	<cfelse>
		<cfset SalarioUltimosPeriodos = 0>
		<cfset SalarioPromedio = 0>
		<cfset SalarioPromedioDiario = 0>
		<cfset SalarioQuincena = 0>
	</cfif>	
</cfif>

<cfquery name="dropPagosEmpleado" datasource="#cache#">
	delete from #tbl_PagosEmpleado#
</cfquery>
<cfquery name="dropPagosEmpleado" datasource="#cache#">
	delete from #PAgosPEriodos#
</cfquery>