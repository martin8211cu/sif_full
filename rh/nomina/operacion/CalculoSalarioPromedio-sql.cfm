
<cf_dbtemp name="PagosEmplv10" returnvariable="tbl_PagosEmpleado">
	<cf_dbtempcol name="Registro" type="numeric" identity="yes" mandatory="yes"> 
	<cf_dbtempcol name="RCNid" type="numeric">
	<cf_dbtempcol name="DEid" type="numeric"> 
	<cf_dbtempcol name="FechaDesde" type="date">
	<cf_dbtempcol name="FechaHasta" type="date">
	<cf_dbtempcol name="Cantidad" type="int">
	<cf_dbtempkey cols="Registro">
</cf_dbtemp>
		
<cf_dbtemp name="PAgosPEriodos10" returnvariable="PAgosPEriodos">
	<cf_dbtempcol name="RCNid"       type="numeric">
	<cf_dbtempcol name="RCNDes"       type="varchar(256)">
	<cf_dbtempcol name="FechaDesde"  type="date">
	<cf_dbtempcol name="FechaHasta"  type="date">
	<cf_dbtempcol name="salario"     type="float">
	<cf_dbtempcol name="incidencias" type="float">
	<cf_dbtempcol name="dias" type="int">
</cf_dbtemp>

<cfquery name="rsFecha" datasource="#Session.DSN#">
	select max(LThasta) as LThasta  from LineaTiempo
	where DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.DEid#">
</cfquery>

<cfoutput>

<!--- 
 
<cfset fecha = CreateDate(DatePart('yyyy', url.fecha), DatePart('d', url.fecha), DatePart('m', url.fecha))>


<cfdump var="#rsFecha.LThasta#"><br>
<cfdump var="#fecha#"><br>



------------#DateCompare(rsFecha.LThasta, fecha)#---------- --->
</cfoutput>
<cfquery name="rsEncabezado" datasource="#Session.DSN#">
	select 
		a.Tcodigo,
		a.Ecodigo,
		a.DEid,
		<cf_dbfunction name="to_float" args="h.FactorDiasSalario"> as FactorDiasSalario,
	   {fn concat({fn concat({fn concat({fn concat(b.DEapellido1, ' ')}, b.DEapellido2)}, ' ')}, b.DEnombre)} as NombreCompleto,
	   b.DEidentificacion
	from LineaTiempo a
	inner join DatosEmpleado b
			on a.DEid = b.DEid
	inner join TiposNomina h
			on a.Ecodigo = h.Ecodigo 
			and a.Tcodigo = h.Tcodigo		
	where a.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.DEid#">
	and '#LSDateFormat(url.fecha, "yyyymmdd")#' between a.LTdesde   and a.LThasta   
</cfquery>





<cfif rsEncabezado.recordCount GT 0>
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
	
	
	<cfquery name="rsTipoPago" datasource="#Session.DSN#">
		select Ttipopago
		from TiposNomina
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
		and Tcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#rsEncabezado.Tcodigo#">
	</cfquery>
	<cfset Ttipopago = rsTipoPago.Ttipopago>
	
	<cfquery name="rsDiasNoPago" datasource="#Session.DSN#">
		select count(1) as diasnopago
		from DiasTiposNomina
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
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
		and CPdesde <= '#LSDateFormat(url.fecha, "yyyymmdd")#'
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
	
	<cftransaction>
		<cfif Len(Trim(Fecha1))>
			<cfset Fecha2 = DateAdd('yyyy', -1, DateAdd('d', -30, Fecha1))>
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
								AND d.RHTpaga = 0)
		</cfquery>
		
		<cfquery name="delPagosEmpleado" datasource="#Session.DSN#">
			delete #tbl_PagosEmpleado#
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
		<cfquery name="rsFechaSalida" datasource="#Session.DSN#">
			select max(DLfvigencia) as fechasalida
			from DLaboralesEmpleado dl, RHTipoAccion ta
			where dl.DEid = #rsEncabezado.DEid#
			and ta.RHTid = dl.RHTid
			and ta.RHTcomportam = 2
		</cfquery>
		<cfif rsFechaSalida.recordCount and Len(Trim(rsFechaSalida.fechasalida))>
			<cfquery name="delPagosEmpleado" datasource="#Session.DSN#">
				delete #tbl_PagosEmpleado#
				where FechaDesde <= <cfqueryparam cfsqltype="cf_sql_date" value="#rsFechaSalida.fechasalida#"> 
				or    FechaHasta <= <cfqueryparam cfsqltype="cf_sql_date" value="#rsFechaSalida.fechasalida#"> 
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
			
			<cfquery name="upSalarioPromedioC" datasource="#Session.DSN#">
				update #PAgosPEriodos# set RCNDes = (
					select RCDescripcion from  HRCalculoNomina 
					where RCNid = #PAgosPEriodos#.RCNid
				)
			</cfquery>
	
	
			<cfquery name="rsmeses" datasource="#Session.DSN#">
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
			<!---<cfset SalarioPromedio = (rsSalarioPromedio1.salario - rsSalarioPromedio2.incidencias) / CantidadPeriodos>
			 <cfset SalarioPromedioDiario = (rsSalarioPromedio1.salario - rsSalarioPromedio2.incidencias) / ValorPromedioDiario>
			<cfset SalarioQuincena = SalarioPromedio / 2> --->
			
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
	
	<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_apartirde"
	Default="Apartir del "
	returnvariable="LB_apartirde"/> 

	<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_calculodelsalariopromedio"
	Default="C&aacute;lculo del Salario Promedio Diario"
	returnvariable="LB_calculodelsalariopromedio"/> 


	
	<cfoutput>
	<cfset LvarFileName = "#LB_calculodelsalariopromedio#.xls">
	<cf_htmlReportsHeaders 
		title="#LB_calculodelsalariopromedio#" 
		filename="#LvarFileName#"
		back="no"
		method="get"
		irA="BalGeneral.cfm" 
		>
		<table width="100%" align="center" border="0" cellspacing="0" cellpadding="2" class="recuadro1">
			<tr>
				<td valign="top">
					<table width="90%" align="center" border="0" cellspacing="0" cellpadding="2">
						<tr>
							<td nowrap colspan="5"> 
								<cf_EncReporte
								Titulo   ="#LB_calculodelsalariopromedio#" 
								Filtro1  = "#LB_apartirde#&nbsp;#url.fecha#"
								Filtro2  = "#rsEncabezado.DEidentificacion#&nbsp;#rsEncabezado.NombreCompleto#"
								MostrarPagina="false">
							</td>
						</tr>
						<tr>
							<td nowrap colspan="5" 	style="border-bottom: 1px solid black; "><strong><font style="font-size:13px"><cf_translate key="LB_Salario_Ultimos_Periodos">Salario &Uacute;ltimos Per&iacute;odos</cf_translate>(#CantidadPeriodos#)</font></strong></td>
						</tr>
						<tr>
							<td  width="40%" align="left" style="border-bottom: 1px solid black; "><strong><font style="font-size:13px"><cf_translate key="LB_Nomina">N&oacute;mina</cf_translate></font></strong></td>
							<td  width="15%" align="left" style="border-bottom: 1px solid black; "><strong><font style="font-size:13px"><cf_translate key="LB_Desde">Desde</cf_translate></font></strong></td>
							<td  width="15%" align="left" style="border-bottom: 1px solid black; "><strong><font style="font-size:13px"><cf_translate key="LB_Hasta">Hasta</cf_translate></font></strong></td>
							<td  width="15%" align="right" style="border-bottom: 1px solid black; "><strong><font style="font-size:13px"><cf_translate key="LB_Dias">Dias</cf_translate></font></strong></td>
							<td nowrap  width="15%" align="right" style="border-bottom: 1px solid black; "><strong><font style="font-size:13px"><cf_translate key="LB_Salario_Mensual">Salario Mensual</cf_translate></font></strong></td>
						</tr>
						<cfset totaldias 	 = 0>
						<cfset totalsalarios = 0>
						<cfset mes = 0>
						<cfif isdefined("rsmeses") and  rsmeses.recordCount>
						<cfloop query="rsmeses">
							<tr>
								<td align="left"  <cfif  rsmeses.recordCount eq  rsmeses.currentRow>style="border-bottom: 1px solid black;"</cfif>><font style="font-size:13px">#rsmeses.RCNDes#</font></td>
								<td align="left"  <cfif  rsmeses.recordCount eq  rsmeses.currentRow>style="border-bottom: 1px solid black;"</cfif>><font style="font-size:13px">#LSDateformat(rsmeses.RCdesde, 'dd/mm/yyyy')#</font></td>
								<td align="left"  <cfif  rsmeses.recordCount eq  rsmeses.currentRow>style="border-bottom: 1px solid black;"</cfif>><font style="font-size:13px">#LSDateformat(rsmeses.RChasta, 'dd/mm/yyyy')#</font></td>
								<td align="right" <cfif  rsmeses.recordCount eq  rsmeses.currentRow>style="border-bottom: 1px solid black;"</cfif>><font style="font-size:13px">#rsmeses.dias#</font></td>
								<td align="right" <cfif  rsmeses.recordCount eq  rsmeses.currentRow>style="border-bottom: 1px solid black;"</cfif>><font style="font-size:13px">#LSNumberformat(rsmeses.salario, ',9.00')#</font></td>
							</tr>
							<cfset totalsalarios = totalsalarios + rsmeses.salario>
							<cfset totaldias     = totaldias + rsmeses.dias>															
						</cfloop>
						</cfif>
						<tr>
							<td nowrap="nowrap"><strong><font style="font-size:13px"><cf_translate key="LB_Totaldias">Total D&iacute;as</cf_translate></font></strong></td>
							<td align="right" ><font style="font-size:13px"></font></td>
							<td align="right" ><font style="font-size:13px"></font></td>
							<td align="right" ><font style="font-size:13px">#LSNumberformat(totaldias,',9')#</font></td>
							<td align="right" ><font style="font-size:13px">#LSNumberformat(totalsalarios,',9.00')#</font></td>
						</tr>
						<cfif totaldias neq 0>
							<cfset salarioPromedioDiario = totalsalarios /totaldias>
						<cfelse>
							<cfset salarioPromedioDiario = 0>
						</cfif>	
						<tr>
							<td nowrap colspan="5"><strong><font style="font-size:13px"><cf_translate  key="LB_SalarioPromedioDiario">Salario Promedio Diario</cf_translate>: #LSNumberformat(salarioPromedioDiario,',9')#</font></strong></td>
						</tr>
					</table>
				</td>
			</tr>	
		</table>
	</cfoutput>
<cfelse>
<table width="100%" align="center" border="0" cellspacing="0" cellpadding="2" class="recuadro1">
	<tr align="center">
		<td><cf_translate  key="LB_nohay">No hay datos por procesar</cf_translate></td>
	</tr>
</table>
</cfif>



