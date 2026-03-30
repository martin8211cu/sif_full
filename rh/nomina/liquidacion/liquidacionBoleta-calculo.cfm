<cfquery name="rsEncabezado" datasource="#Session.DSN#">
	select b.DEid,
		   {fn concat({fn concat({fn concat({fn concat(b.DEapellido1, ' ')}, b.DEapellido2)}, ' ')}, b.DEnombre)} as NombreCompleto,
		   b.DEidentificacion,
		   e.EVfantig,
		   c.DLfvigencia,
		   d.RHPdescpuesto,
		   f.Ddescripcion,
		   g.RHTdesc,
		   c.Ecodigo,
		   c.Tcodigo,
		   i.Msimbolo,
		   coalesce(a.RHLPrenta, 0) as renta,
		   coalesce(a.RHLPfecha,getdate()) as RHLPfecha,
		   <cf_dbfunction name="to_number" args="h.FactorDiasSalario"> as FactorDiasSalario
		   
	from RHLiquidacionPersonal a

		inner join DatosEmpleado b
			on a.DEid = b.DEid
		
		inner join DLaboralesEmpleado c
			on a.DLlinea = c.DLlinea
		
		inner join RHPuestos d
			on c.Ecodigo = d.Ecodigo
			and c.RHPcodigo = d.RHPcodigo
		
		inner join EVacacionesEmpleado e
			on a.DEid = e.DEid
		
		inner join Departamentos f
			on c.Ecodigo = f.Ecodigo
			and c.Dcodigo = f.Dcodigo

		inner join RHTipoAccion g
			on c.RHTid = g.RHTid

		inner join TiposNomina h
			on c.Ecodigo = h.Ecodigo
			and c.Tcodigo = h.Tcodigo
			
		inner join Monedas i
			on h.Ecodigo = i.Ecodigo
			and h.Mcodigo = i.Mcodigo

	where a.DLlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.DLlinea#">
</cfquery>

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


<!--- ----------------------------------------------- CALCULOS DE SALARIO PROMEDIO -------------------------------------------- --->
<cfif rsEncabezado.recordCount>
	
		<cf_dbtemp name="PagosEmplv1" returnvariable="tbl_PagosEmpleado">
			<!--- <cf_dbtempcol name="Registro" type="numeric" identity="yes" mandatory="yes">  --->
			<cf_dbtempcol name="RCNid" type="numeric">
			<cf_dbtempcol name="DEid" type="numeric"> 
			<cf_dbtempcol name="FechaDesde" type="datetime">
			<cf_dbtempcol name="FechaHasta" type="datetime">
			<cf_dbtempcol name="Cantidad" type="int">
			<cf_dbtempkey cols="RCNid,DEid">
			<!--- <cf_dbtempkey cols="Registro"> --->
		</cf_dbtemp>
		
		<cf_dbtemp name="PAgosPEriodos" returnvariable="PAgosPEriodos">
			<cf_dbtempcol name="RCNid"       type="numeric">
			<cf_dbtempcol name="FechaDesde"  type="datetime">
			<cf_dbtempcol name="FechaHasta"  type="datetime">
			<cf_dbtempcol name="salario"     type="float">
			<cf_dbtempcol name="incidencias" type="float">
			<cf_dbtempcol name="dias" type="int">
		</cf_dbtemp>

	<cftransaction>

		<cfquery name="rsTipoPago" datasource="#Session.DSN#">
			select Ttipopago
			from TiposNomina
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsEncabezado.Ecodigo#">
			and Tcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#rsEncabezado.Tcodigo#">
		</cfquery>
		<cfset Ttipopago = rsTipoPago.Ttipopago>
	
		<cfquery name="rsDiasNoPago" datasource="#Session.DSN#">
			select count(1) as diasnopago
			from DiasTiposNomina
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsEncabezado.Ecodigo#">
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
	
		<cfquery name="rsParametros" datasource="#Session.DSN#">
			select Pvalor as cantidadperiodos
			from RHParametros
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsEncabezado.Ecodigo#">
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
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsEncabezado.Ecodigo#">
			and Tcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#rsEncabezado.Tcodigo#">
			and CPdesde <= <cfqueryparam cfsqltype="cf_sql_date" value="#rsEncabezado.DLfvigencia#">
		</cfquery>
		<cfquery name="rsFecha2" datasource="#Session.DSN#">
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
			<!--- <cfset Fecha2 = DateAdd('yyyy', -1, DateAdd('d', (CantidadPeriodos * -30), Fecha1))> --->
			
			<cfquery name="tbl_PagosEmpleadoInsert" datasource="#session.DSN#">
				insert into #tbl_PagosEmpleado# (RCNid, DEid, FechaDesde, FechaHasta, Cantidad)
				
				select distinct a.RCNid, #rsEncabezado.DEid#, a.RCdesde, a.RChasta, 0
				from HSalarioEmpleado b, HRCalculoNomina a, CalendarioPagos cp
				where b.DEid = #rsEncabezado.DEid#
				and a.RCNid = b.RCNid
				and a.Ecodigo = #rsEncabezado.Ecodigo#
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
			where DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#DEid#">
			  and exists (	select 1
							from HPagosEmpleado pe, RHTipoAccion d
							where pe.DEid = #tbl_PagosEmpleado#.DEid
								and pe.RCNid = #tbl_PagosEmpleado#.RCNid
								and d.RHTid = pe.RHTid
								and d.RHTcomportam = 5 )
		</cfquery>
		
		<cfquery name="delPagosEmpleado" datasource="#Session.DSN#">
				delete #tbl_PagosEmpleado#
				where DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#DEid#">
				  and exists (
					
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
				where DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#DEid#">
				  and exists (	select 1
								from HPagosEmpleado pe, RHTipoAccion d
								where pe.DEid = #tbl_PagosEmpleado#.DEid
									and pe.RCNid = #tbl_PagosEmpleado#.RCNid
									and d.RHTid = pe.RHTid
									and d.RHTcomportam = 4 
									AND d.RHTpaga = 0)
			</cfquery>
			
			<cfquery name="delPagosEmpleado" datasource="#Session.DSN#">
				delete #tbl_PagosEmpleado#
				where DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#DEid#">
				  and exists (
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
		<cfquery name="rsFechaSalida" datasource="#Session.DSN#">
			select max(LTdesde) as fechasalida
			from LineaTiempo lt, RHTipoAccion ta
			where lt.DEid = #rsEncabezado.DEid#
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
			select RCNid,DEid,FechaDesde,FechaHasta,Cantidad
			from #tbl_PagosEmpleado#
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
		
		
		<cfif TipoPeriodos EQ 1 and Len(Trim(Fecha3))>
			<cfquery name="delPagosEmpleado" datasource="#Session.DSN#">
				delete #tbl_PagosEmpleado#
				where DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#DEid#">
				  and FechaHasta <= <cfqueryparam cfsqltype="cf_sql_date" value="#Fecha3#">
			</cfquery>
		<cfelse>
			<cfquery name="delPagosEmpleado" datasource="#Session.DSN#">
				delete #tbl_PagosEmpleado#
				where  DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#DEid#">
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
				coalesce(PEcantdias, 0) as dias
				from  HPagosEmpleado  hp, #tbl_PagosEmpleado# pe
				where hp.RCNid = pe.RCNid
				and hp.DEid = pe.DEid
				and hp.PEtiporeg = 0
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
				coalesce(dias,0) as dias
				from #PAgosPEriodos#
				order by FechaDesde desc,FechaHasta
			</cfquery>

			<cfquery name="rspromedio"  dbtype="query">
				select sum(salario) / sum(dias) as SalarioPromedioDiario
				from rsmeses
			</cfquery>
			
			
			<cfquery name="rsSalarioPromedio1" datasource="#Session.DSN#">
				select sum(SEsalariobruto + SEincidencias) as salario
				from HSalarioEmpleado se, #tbl_PagosEmpleado# pe
				where se.RCNid = pe.RCNid
				and se.DEid = pe.DEid
			</cfquery>
			
			

			
			
			
			<cfquery name="rsSalarioPromedio2" datasource="#Session.DSN#">
				select coalesce(sum(ic.ICmontores), 0.00) as incidencias
				from HIncidenciasCalculo ic, #tbl_PagosEmpleado# pe, CIncidentes ci
				where ic.RCNid = pe.RCNid
				and ic.DEid = pe.DEid
				and ci.CIid = ic.CIid
				and ci.CIafectasalprom = 0
				and coalesce(ci.CIafectasalpromSP,0) = 0
			</cfquery>

			<cfif len(trim(rsEncabezado.FactorDiasSalario)) eq 0 >
				<cfquery name="rsParametros" datasource="#Session.DSN#">
					select Pvalor
					from RHParametros
					where Ecodigo = #rsEncabezado.Ecodigo#
					and Pcodigo = 80
				</cfquery>
			</cfif>
			
			<cfif len(trim(rsEncabezado.FactorDiasSalario)) eq 0 >
				<cfset ValorPromedioDiario = rsParametros.Pvalor>
			<cfelse>
				<cfset ValorPromedioDiario = rsEncabezado.FactorDiasSalario>
			</cfif>
			
			<!--- Obtener los cálculos del salario promedio entre los períodos --->
			<cfset SalarioUltimosPeriodos = (rsSalarioPromedio1.salario - rsSalarioPromedio2.incidencias)>
			<cfset SalarioPromedio = (rsSalarioPromedio1.salario - rsSalarioPromedio2.incidencias) / CantidadPeriodos>
			<!--- <cfset SalarioPromedioDiario = (rsSalarioPromedio1.salario - rsSalarioPromedio2.incidencias) / ValorPromedioDiario> --->
			<cfset SalarioQuincena = SalarioPromedio / 2>
			
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
		
	</cftransaction>

<!--- ----------------------------------------------- FIN CALCULOS DE SALARIO PROMEDIO ------------------------------------------ --->

<!--- ----------------------------------- CALCULO DE ANTIGUEDAD PARA CESANTIA SEGUN FECHA DE CORTE ----------------------------- --->
	<cfquery name="rsParametros" datasource="#Session.DSN#">
		select Pvalor
		from RHParametros
		where Ecodigo = #rsEncabezado.Ecodigo#
		and Pcodigo = 430
	</cfquery>

	<cfset FechaCorte = LSParseDateTime(rsParametros.Pvalor)>
	<cfset DiasAntesCorte = DateDiff('d', rsEncabezado.EVfantig, FechaCorte)>
	<cfif DiasAntesCorte LT 0>
		<cfset DiasAntesCorte = 0>
	</cfif>

	<cfif DiasAntesCorte GT 0>
		<cfset AnnosAntesCorte = DateDiff('yyyy', rsEncabezado.EVfantig, FechaCorte)>
		<cfset MesesAntesCorte = DateDiff('m', DateAdd('yyyy', AnnosAntesCorte, rsEncabezado.EVfantig), FechaCorte)>
		<cfset DiasAntesCorte = DateDiff('d', DateAdd('m', MesesAntesCorte, DateAdd('yyyy', AnnosAntesCorte, rsEncabezado.EVfantig)), FechaCorte)>
	<cfelse>
		<cfset AnnosAntesCorte = 0>
		<cfset MesesAntesCorte = 0>
		<cfset DiasAntesCorte = 0>
	</cfif>

	<cfif DateCompare(rsEncabezado.EVfantig, LSParseDateTime(rsParametros.Pvalor)) GT 0>
		<cfset FechaCorte = rsEncabezado.EVfantig>
	</cfif>
	<cfset DiasDespuesCorte = DateDiff('d', FechaCorte, rsEncabezado.DLfvigencia)>
	
	<cfif DiasDespuesCorte GT 0>
		<cfset AnnosDespuesCorte = DateDiff('yyyy', FechaCorte, rsEncabezado.DLfvigencia)>
		<cfset MesesDespuesCorte = DateDiff('m', DateAdd('yyyy', AnnosDespuesCorte, FechaCorte), rsEncabezado.DLfvigencia)>
		<cfset DiasDespuesCorte = DateDiff('d', DateAdd('m', MesesDespuesCorte, DateAdd('yyyy', AnnosDespuesCorte, FechaCorte)), rsEncabezado.DLfvigencia)>
	<cfelse>
		<cfset AnnosDespuesCorte = 0>
		<cfset MesesDespuesCorte = 0>
		<cfset DiasDespuesCorte = 0>
	</cfif>
<!--- -------------------------------- FIN CALCULO DE ANTIGUEDAD PARA CESANTIA SEGUN FECHA DE CORTE ----------------------------- --->

<!--- -------------------------------------- QUERYS PARA DESPLIEGUE DE PRESTACIONES LEGALES ------------------------------------- --->
	<cfquery name="rsDetallePrestaciones" datasource="#Session.DSN#">
		select a.RHLPid, a.CIid, a.RHLPdescripcion as Descripcion, a.importe, 
			   b.DDCres as Resultado, b.DDCcant as Cantidad, b.DDCimporte as Monto
		from RHLiqIngresos a, DDConceptosEmpleado b , CIncidentes c
		where a.DLlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.DLlinea#">
		and a.DLlinea = b.DLlinea
		and a.CIid = b.CIid
		and b.CIid = c.CIid
		and coalesce(c.CISumarizarLiq,0) = 0
		and a.RHLPautomatico = 1
	</cfquery>

	<cfquery name="rsDetalleOtrasPrestaciones" datasource="#Session.DSN#">
		select a.RHLPdescripcion as Descripcion, 
			case when b.DDCcant is null then a.importe else b.DDCimporte end as importe,
			coalesce(b.DDCres,0) as Resultado, 
			coalesce(b.DDCcant,0) as Cantidad
		from RHLiqIngresos a
		left outer join DDConceptosEmpleado  b
			on b.CIid = a.CIid
			and b.DLlinea = a.DLlinea
		left outer join CIncidentes c
			on c.CIid = b.CIid
			and coalesce(c.CISumarizarLiq,0) = 0
		where a.DLlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.DLlinea#">
		and a.RHLPautomatico = 0
	</cfquery>

	<cfquery name="rsDetalleOtrasPrestaciones" datasource="#Session.DSN#">
		select a.RHLPdescripcion as Descripcion, 
			case when b.DDCcant is null then a.importe else b.DDCimporte end as importe,
			coalesce(b.DDCres,0) as Resultado, 
			coalesce(b.DDCcant,0) as Cantidad
		from RHLiqIngresos a
		left outer join DDConceptosEmpleado  b
			on b.CIid = a.CIid
			and b.DLlinea = a.DLlinea
		where a.DLlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.DLlinea#">
		and a.RHLPautomatico = 0
	</cfquery>	

<!--- ----------------------------------------- QUERY PARA DESPLIEGUE LOS APORTES REALIZADOS ----------------------------------------- --->
	<cfquery name="rsDetalleAportesRealizados" datasource="#Session.DSN#">
		select a.RHLCdescripcion as Descripcion, a.importe as Resultado
		from RHLiqCargas a
		inner join DCargas   b
			on a.DClinea = b.DClinea
			and coalesce(DCSumarizarLiq,0) = 0
			
		where a.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.DEid#">
	</cfquery>
<!--- ----------------------------------------- QUERY PARA OTROS RUBROS ESPECIALES ----------------------------------------- --->

	<cfquery name="rsOtrosRubrosEspeciales" datasource="#Session.DSN#">
		select a.RHLCdescripcion as Descripcion, a.importe as Resultado
		from RHLiqCargas a
		inner join DCargas   b
			on a.DClinea = b.DClinea
			and coalesce(DCSumarizarLiq,0) = 1
			and coalesce(DCMostrarLiq,0) = 1
		where a.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.DEid#">
	</cfquery>	
	
	<cfquery datasource="#Session.DSN#" name="rsSalPromAccion"><!---CarolRS--->
		select RCNid,DLlinea,DEid,RHSPAmonto,RHSPAdias 
		from DLSalPromAccion
		where DLlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.DLlinea#">
		and DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.DEid#">
	</cfquery>
 	
	<cfquery name="rsDetallePrestacionesSP" datasource="#Session.DSN#">
		select a.RHLPid, a.CIid, a.RHLPdescripcion as Descripcion, a.importe, 
			   b.DDCres as Resultado, b.DDCcant as Cantidad, b.DDCimporte as Monto
		from RHLiqIngresos a, DDConceptosEmpleado b , CIncidentes c
		where a.DLlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.DLlinea#">
		and a.DLlinea = b.DLlinea
		and a.CIid = b.CIid
		and b.CIid = c.CIid
		and coalesce(c.CISumarizarLiq,0) = 1
		and coalesce(c.CIMostrarLiq,0)   = 1
		and a.RHLPautomatico = 1
	</cfquery>
	<cfquery name="rsDetalleOtrasPrestacionesSP" datasource="#Session.DSN#">
		select a.RHLPdescripcion as Descripcion, 
			case when b.DDCcant is null then a.importe else b.DDCimporte end as importe,
			coalesce(b.DDCres,0) as Resultado, 
			coalesce(b.DDCcant,0) as Cantidad
		from RHLiqIngresos a
		left outer join DDConceptosEmpleado  b
			on b.CIid = a.CIid
			and b.DLlinea = a.DLlinea
		<!--- left outer join CIncidentes c --->	
		left outer join CIncidentes c
			on c.CIid = b.CIid
			and coalesce(c.CISumarizarLiq,0) = 1
			and coalesce(c.CIMostrarLiq,0)   = 1
		where a.DLlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.DLlinea#">
		and a.RHLPautomatico = 0
	</cfquery>

<!--- -------------------------------------- QUERYS PARA DESPLIEGUE DE OBLIGACIONES DEL EMPLEADO ------------------------------------- --->

	<cfquery name="rsDetalleObligaciones" datasource="#Session.DSN#">
		select coalesce(rtrim(b.RHLDdescripcion), rtrim(b.RHLDreferencia)) as Descripcion, b.importe as Resultado, d.SNnumero, d.SNnombre, coalesce(e.Cformato, 'EL SOCIO NO TIENE CUENTA ASOCIADA') as Cformato, f.TDcodigo
		from RHLiquidacionPersonal a
			inner join RHLiqDeduccion b
				on a.DEid = b.DEid
				and a.DLlinea = b.DLlinea
			left outer join DeduccionesEmpleado c
				on b.Did = c.Did
				and b.DEid = c.DEid
			inner join SNegocios d
				on a.Ecodigo = d.Ecodigo
				and b.SNcodigo = d.SNcodigo
			left outer join CContables e
				on d.SNcuentacxp = e.Ccuenta 
			left outer join TDeduccion f
				on c.TDid = f.TDid
		where a.DLlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.DLlinea#">
		order by d.SNnumero, d.SNnombre
	</cfquery>

</cfif>
