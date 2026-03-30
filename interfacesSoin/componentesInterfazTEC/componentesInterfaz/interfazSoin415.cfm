<cfobject name="LobjInterfaz" component="interfacesSoin.Componentes.interfaces">
<cfset LobjInterfaz.sbReportarActividad(GvarNI, GvarID)>

<cfset XMLD = xmlParse(GvarXML_IE) />
<cfset Datos = xmlSearch(XMLD,'/resultset/row')>
<cfset datosXML = xmlparse(Datos[1]) />
<cfset LvarDEidentificacion = #datosXML.row.Cedula.xmltext#>

<cfif  len(trim(#LvarDEidentificacion#)) eq 0 or trim(#LvarDEidentificacion#) EQ -1 >
	<cfthrow message="La Identificacion del la persona es requerida">
</cfif>

<!--- Verificar si el empleado existe   --->
<cfquery name="rsVerificasiEmplExiste" datasource="#session.DSN#" >
	select 1
	from DatosEmpleado
	where DEidentificacion = <cfqueryparam cfsqltype="cf_sql_varchar" value="#LvarDEidentificacion#">
</cfquery>
<cfif  rsVerificasiEmplExiste.RecordCount eq 0>
	<cfthrow message="El empleado no existe">
</cfif>

   <cfquery name="consulta" datasource="#session.DSN#"> 	
		select  a.DLlinea, a.DEid,a.RHLPfecha, b.DEid,
				{fn concat({fn concat({fn concat({fn concat(b.DEapellido1 , ' ' )}, b.DEapellido2 )}, ' ' )}, b.DEnombre )} as nombre,
				b.DEidentificacion,
				g.RHTdesc,
				g.RHTid,
				c.Tcodigo,
			    c.DLfvigencia,
				<cf_dbfunction name="to_number" args="h.FactorDiasSalario"> as FactorDiasSalario,
				 c.Ecodigo
				
		from RHLiquidacionPersonal a
	
			inner join DatosEmpleado b
				on a.Ecodigo = b.Ecodigo
				and a.DEid = b.DEid
	
				 <cfif len(trim(LvarDEidentificacion)) >
					and b.DEidentificacion = <cfqueryparam cfsqltype="cf_sql_varchar" value="#LvarDEidentificacion#">	
				</cfif>
				
			inner join DLaboralesEmpleado c
			on a.DLlinea = c.DLlinea
			
			inner join RHTipoAccion g
			on c.RHTid = g.RHTid	
			
			inner join TiposNomina h
			on c.Ecodigo = h.Ecodigo
			and c.Tcodigo = h.Tcodigo
									
		where a.Ecodigo= <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		and a.RHLPestado = 1
		and a.RHLPfecha = (select max(RHLPfecha)
						from RHLiquidacionPersonal  LiqPer
						where LiqPer.DEid = a.DEid
						and LiqPer.Ecodigo = a.Ecodigo
						and  LiqPer.RHLPestado = 1)	 
	</cfquery> 

<cfif consulta.RecordCount gt 0>
	<!--- Liq aguinaldo, vacaciones y Cesantía --->
	<cfquery name="rsRHLiqIngresos" datasource="#session.DSN#">
		select	a.DLlinea, a.DEid, a.RHLPfecha, a.fechaalta,
		b.RHLPid, b.RHLPdescripcion as nombre, b.fechaalta,
		c.CIcodigo, c.CIdescripcion,
		case when d.DDCcant is null then b.importe else d.DDCimporte end as importe,
		coalesce(d.DDCres,0) as Resultado, 
		coalesce(d.DDCcant,0) as Cantidad
		from RHLiquidacionPersonal a
	
		  inner join RHLiqIngresos b
			on  a.Ecodigo = b.Ecodigo
			and a.DEid = b.DEid
			and a.DLlinea = b.DLlinea
	
		  inner join CIncidentes c
			on  b.CIid = c.CIid
			and b.Ecodigo = c.Ecodigo
		
		  left outer join DDConceptosEmpleado d
			on d.CIid = c.CIid
			and d.DLlinea = a.DLlinea
			
		where a.DLlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#consulta.DLlinea#">
		  and b.RHLPautomatico = 1
	
		order by 2
</cfquery>

<cfquery name="rsDetalleRHLiquidacionPersonal" datasource="#session.DSN#">
	select    rhta.RHTdesc,	 dle.DLfvigencia as DLfechaaplic, eve.EVfantig, dle.DEid
	 from DLaboralesEmpleado  dle
	  inner join RHTipoAccion rhta
		on  dle.Ecodigo = rhta.Ecodigo
		and dle.RHTid = rhta.RHTid
	  inner join EVacacionesEmpleado eve
	    on  dle.DEid = eve.DEid 
	where dle.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
	  and dle.DLlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#consulta.DLlinea#">
</cfquery>

<cfquery name="rsSumRHLiqIngresosAutom" datasource="#session.DSN#">
	select sum(importe) as totIngresos 
	from RHLiqIngresos
	where DLlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#consulta.DLlinea#"> 
	  and RHLPautomatico = 1
</cfquery> 
		
<cfset ylaborados = DateDiff('yyyy',rsDetalleRHLiquidacionPersonal.EVfantig,rsDetalleRHLiquidacionPersonal.DLfechaaplic)>
<cfset mlaborados = DateDiff('m',DateAdd('yyyy',ylaborados,rsDetalleRHLiquidacionPersonal.EVfantig),rsDetalleRHLiquidacionPersonal.DLfechaaplic)>
<cfset dlaborados = DateDiff('d',DateAdd('m',mlaborados,DateAdd('yyyy',ylaborados,rsDetalleRHLiquidacionPersonal.EVfantig)),rsDetalleRHLiquidacionPersonal.DLfechaaplic)>

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
<cfif consulta.recordCount>
	
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
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			and Tcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#consulta.Tcodigo#">
		</cfquery>
		<cfset Ttipopago = rsTipoPago.Ttipopago>
	
		<cfquery name="rsDiasNoPago" datasource="#Session.DSN#">
			select count(1) as diasnopago
			from DiasTiposNomina
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			and Tcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#consulta.Tcodigo#">
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
			and Tcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#consulta.Tcodigo#">
			and CPdesde <= <cfqueryparam cfsqltype="cf_sql_date" value="#consulta.DLfvigencia#">
		</cfquery>
		<cfquery name="rsFecha2" datasource="#Session.DSN#">
			select max(CPhasta) as fecha1
			from CalendarioPagos
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			and Tcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#consulta.Tcodigo#">
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
				
				select distinct a.RCNid, #consulta.DEid#, a.RCdesde, a.RChasta, 0
				from HSalarioEmpleado b, HRCalculoNomina a, CalendarioPagos cp
				where b.DEid = #consulta.DEid#
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
			where DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#consulta.DEid#">
			  and exists (	select 1
							from HPagosEmpleado pe, RHTipoAccion d
							where pe.DEid = #tbl_PagosEmpleado#.DEid
								and pe.RCNid = #tbl_PagosEmpleado#.RCNid
								and d.RHTid = pe.RHTid
								and d.RHTcomportam = 5 )
		</cfquery>
		
		<cfquery name="delPagosEmpleado" datasource="#Session.DSN#">
				delete #tbl_PagosEmpleado#
				where DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#consulta.DEid#">
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
				where DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#consulta.DEid#">
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
				where DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#consulta.DEid#">
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
			where lt.DEid = #consulta.DEid#
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
				where DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#consulta.DEid#">
				  and FechaHasta <= <cfqueryparam cfsqltype="cf_sql_date" value="#Fecha3#">
			</cfquery>
		<cfelse>
			<cfquery name="delPagosEmpleado" datasource="#Session.DSN#">
				delete #tbl_PagosEmpleado#
				where  DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#consulta.DEid#">
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

			<cfif len(trim(consulta.FactorDiasSalario)) eq 0 >
				<cfquery name="rsParametros" datasource="#Session.DSN#">
					select Pvalor
					from RHParametros
					where Ecodigo = #consulta.Ecodigo#
					and Pcodigo = 80
				</cfquery>
			</cfif>
			
			<cfif len(trim(consulta.FactorDiasSalario)) eq 0 >
				<cfset ValorPromedioDiario = rsParametros.Pvalor>
			<cfelse>
				<cfset ValorPromedioDiario = consulta.FactorDiasSalario>
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
</cfif>
<!--- ----------------------------------------------- FIN CALCULOS DE SALARIO PROMEDIO ------------------------------------------ --->

<cfset GvarXML_OE = "<recordset>
    <row>
        <!---<DLlinea>#consulta.DLlinea#</DLlinea>	--->
		<anos>#ylaborados#</anos>
		<meses>#mlaborados#</meses>
		<dias>#dlaborados#</dias>
		<SalarioPromedioDiario>#LSNumberFormat(rspromedio.SalarioPromedioDiario, ',9.00')#</SalarioPromedioDiario>
		
		<nombre>#consulta.nombre#</nombre>
		<concepto>#rsRHLiqIngresos.nombre#</concepto>
		<cantidad>#rsRHLiqIngresos.cantidad#</cantidad>
		<monto>#LsCurrencyFormat(rsRHLiqIngresos.importe,'none')#</monto>
		<total>#LsCurrencyFormat(rsRHLiqIngresos.resultado,'none')#</total>
		
    </row>
<recordset>
">
<cfelse>
	<cfthrow message="El funcionario no tiene una liquidación asociada">
</cfif>


