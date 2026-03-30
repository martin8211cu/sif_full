<cf_htmlReportsHeaders 
title="Reporte de Nominas" 
filename="ReporteDeNominas.xls"
irA="ReporteNominas.cfm" 
>
<style type="text/css">
	.RLTtopline {
		border-bottom-width: 1px;
		border-right-width: 1px;
		border-right-style: solid;
		border-right-color: red;
		border-left-width: 1px;
		border-left-style: solid;
		border-left-color: #000000;
		border-top-width: 1px;
		border-top-style: solid;
		border-top-color: #000000;
		font-size:11px;
		font-family:Arial;
		background-color: #CCCCCC;		
	}	
	
	.LTtopline {
		border-color: red;
		border-bottom-width: 0px;
		border-right-width: 0px;
		border-left-width: 0px;
		border-top-width: 0px;
		border-style: solid;
		font-size:11px;
		font-family:Arial;
	}	
	
	.Completoline {
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
		border-top-color: #000000			
	}	
	
	
</style>
<cfflush interval="512">
<cfsetting requesttimeout="36000">
<cfset pre=''>
<cfif isdefined("ckNominasHistoricas")>
<cfset pre='H'>
</cfif>

<cfif form.radRep eq 1><!--- en el caso que el reporte sea resumido---->
	<cfquery datasource="#session.dsn#" name="rsdatos">
	select rcn.RCNid,rcn.Tcodigo,rcn.RCDescripcion as nomina,rcn.RCdesde as fechaDesde,rcn.RChasta as fechaHasta,
		
		coalesce((select sum(se.SEsalariobruto) from #pre#SalarioEmpleado se 		where se.RCNid=rcn.RCNid),0) as bruto,
		
		coalesce((select sum(ic.ICmontores)   	from #pre#IncidenciasCalculo ic 	where ic.RCNid=rcn.RCNid),0) as incidencias,
		
		coalesce((select sum(cc.CCvaloremp) 	from #pre#CargasCalculo cc 			where cc.RCNid=rcn.RCNid),0) as cargasEmpleado,
		
		coalesce((select sum(de.DCvalor) 	from #pre#DeduccionesCalculo de			where de.RCNid=rcn.RCNid),0) as deducciones,
		
		coalesce((select sum(se.SErenta) 		from #pre#SalarioEmpleado se 		where se.RCNid=rcn.RCNid),0) as renta,
		
		coalesce((select sum(se.SEliquido) 		from #pre#SalarioEmpleado se 		where se.RCNid=rcn.RCNid),0) as liquido  
	
	from #pre#RCalculoNomina rcn
	where rcn.Ecodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
		<cfif isdefined("form.TcodigoList") and len(trim(form.TcodigoList)) GT 0>
			and rcn.RCNid in (#form.TcodigoList#)
		</cfif>
		<cfif isdefined("form.FechaDesde") and len(trim(form.FechaDesde)) GT 0 and isdefined("form.ckUtilizarFiltroFechas")>
			and rcn.RChasta >= <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(form.FechaDesde)#">
		</cfif>
		<cfif isdefined("form.FechaHasta") and len(trim(form.FechaHasta)) GT 0 and isdefined("form.ckUtilizarFiltroFechas")>
			and rcn.RCdesde <= <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(form.FechaHasta)#">
		</cfif>
		order by rcn.Tcodigo, rcn.RCdesde
	</cfquery>
	
	<cfif rsdatos.recordcount GT 0>
		<cfoutput>
		<table width="100%" align="center" cellpadding="0" cellspacing="0" border="0">
			<cfset Tbruto=0>
			<cfset Tincidencias=0>
			<cfset Trenta=0>
			<cfset TcargasEmpleado=0>
			<cfset Tdeducciones=0>
			<cfset Tliquido=0>
			<cfloop query="rsdatos">

			<tr>
				<td td colspan="4"><b><cf_translate  key="LB_Nomina">N&oacute;mina</cf_translate>  #trim(rsdatos.Tcodigo)# - #trim(rsdatos.nomina)#</b></td>
			</tr>
			<tr>
				<td td colspan="4">Desde #LSDateFormat(rsdatos.fechaDesde,'dd-mm-yyyy')#  Hasta #LSDateFormat(rsdatos.fechaHasta,'dd-mm-yyyy')#</td>
			</tr>
			<tr class="RLTtopline">
				<td align="center"><cf_translate  key="LB_Descripcion">Descripci&oacute;n</cf_translate></td>
				<td align="center"><cf_translate  key="LB_Bruto">Bruto</cf_translate></td>
				<td align="center"><cf_translate  key="LB_Incidencias">Incidencias</cf_translate></td>
				<td align="center"><cf_translate  key="LB_Renta">Renta</cf_translate></td>
				<td align="center"><cf_translate  key="LB_Cargas">Cargas Empleado</cf_translate></td>
				<td align="center"><cf_translate  key="LB_Deducciones">Deducciones</cf_translate></td>
				<td align="center"><cf_translate  key="LB_Liquido">Liquido</cf_translate></td>
			</tr>
			<tr class="LTtopline">
				<td  align="center">Resumen General</td>
				<td  align="right">#LSNumberFormat(rsdatos.bruto,',.00')#</td>
				<td  align="right">#LSNumberFormat(rsdatos.incidencias,',.00')#</td>
				<td  align="right">#LSNumberFormat(rsdatos.renta,',.00')#</td>
				<td  align="right">#LSNumberFormat(rsdatos.cargasEmpleado,',.00')#</td>
				<td  align="right">#LSNumberFormat(rsdatos.deducciones,',.00')#</td>
				<td  align="right">#LSNumberFormat(rsdatos.liquido,',.00')#</td>
			</tr>	
				<cfset Tbruto=Tbruto+rsdatos.bruto>
				<cfset Tincidencias=Tincidencias+rsdatos.incidencias>
				<cfset Trenta=Trenta+rsdatos.renta>
				<cfset TcargasEmpleado=TcargasEmpleado+rsdatos.cargasEmpleado>
				<cfset Tdeducciones=Tdeducciones+rsdatos.deducciones>
				<cfset Tliquido=Tliquido+rsdatos.liquido>	
				<tr><td>&nbsp;</td></tr>
			</cfloop>
			<tr><td>&nbsp;</td></tr>
			<tr class="LTtopline">
				<td  align="right"><b>Total</b></td>
				<td  align="right"><strong>#LSNumberFormat(Tbruto,',.00')#</strong></td>
				<td  align="right"><strong>#LSNumberFormat(Tincidencias,',.00')#</strong></td>
				<td  align="right"><strong>#LSNumberFormat(Trenta,',.00')#</strong></td>
				<td  align="right"><strong>#LSNumberFormat(TcargasEmpleado,',.00')#</strong></td>
				<td  align="right"><strong>#LSNumberFormat(Tdeducciones,',.00')#</strong></td>
				<td  align="right"><strong>#LSNumberFormat(Tliquido,',.00')#</strong></td>
			</tr>	
		</table>
		</cfoutput>
	</cfif>
<cfelseif form.radRep eq 2><!--- en el caso que el reporte sea detallado---->
	<cf_dbfunction name="OP_concat" returnvariable="concat">
	<cfquery datasource="#session.dsn#" name="rsdatos">
		select distinct se.DEid,rcn.RCNid,rcn.Tcodigo,rcn.RCDescripcion as nomina,rcn.RCdesde as fechaDesde,rcn.RChasta as fechaHasta,
		cf.CFcodigo, cf.CFdescripcion, de.DEidentificacion as cedula, de.DEnombre #concat#' '#concat# de.DEapellido1 #concat#' '#concat# de.DEapellido2 as nombre, 
		 coalesce(se.SEsalariobruto,0) as bruto, coalesce(se.SErenta,0) as renta, coalesce(se.SEliquido,0) as liquido 
		from #pre#RCalculoNomina rcn 
			inner join  #pre#SalarioEmpleado se
				on rcn.RCNid=se.RCNid 
			inner join DatosEmpleado de
				on se.DEid=de.DEid    
			left join LineaTiempo lt
				on rcn.Ecodigo=lt.Ecodigo
				and se.DEid=lt.DEid
				and lt.LTdesde <=rcn.RChasta
				and lt.LThasta >=rcn.RCdesde
			 inner join RHPlazas rhp
				on lt.RHPid = rhp.RHPid   
				and lt.Ecodigo=rhp.Ecodigo
			 inner join CFuncional cf
				on rhp.CFid=cf.CFid   
		where rcn.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
		<cfif isdefined("form.TcodigoList") and len(trim(form.TcodigoList)) GT 0>
			and rcn.RCNid in (#form.TcodigoList#)
		</cfif>
		<cfif isdefined("form.FechaDesde") and len(trim(form.FechaDesde)) GT 0 and isdefined("form.ckUtilizarFiltroFechas")>
			and rcn.RChasta >= <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(form.FechaDesde)#">
		</cfif>
		<cfif isdefined("form.FechaHasta") and len(trim(form.FechaHasta)) GT 0 and isdefined("form.ckUtilizarFiltroFechas")>
			and rcn.RCdesde <= <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(form.FechaHasta)#">
		</cfif>
		order by rcn.Tcodigo,rcn.RCdesde
	</cfquery>

	<cfquery datasource="#session.dsn#" name="rsDatosIncidencias">
	    select rcn.RCNid,ic.DEid,cin.CIdescripcion as descripcion, ic.ICmontores as monto
		from #pre#RCalculoNomina rcn
		 inner join #pre#IncidenciasCalculo ic
		 	on rcn.RCNid=ic.RCNid
		 inner join CIncidentes cin
			on ic.CIid = cin.CIid  
		where rcn.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">	
		<cfif isdefined("form.TcodigoList") and len(trim(form.TcodigoList)) GT 0>
			and rcn.RCNid in (#form.TcodigoList#)
		</cfif>
		<cfif isdefined("form.FechaDesde") and len(trim(form.FechaDesde)) GT 0 and isdefined("form.ckUtilizarFiltroFechas")>
			and rcn.RChasta >= <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(form.FechaDesde)#">
		</cfif>
		<cfif isdefined("form.FechaHasta") and len(trim(form.FechaHasta)) GT 0 and isdefined("form.ckUtilizarFiltroFechas")>
			and rcn.RCdesde <= <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(form.FechaHasta)#">
		</cfif>
	</cfquery>
	<cfquery datasource="#session.dsn#" name="rsDatosCargas">
	    select rcn.RCNid,cc.DEid,dc.DCdescripcion as descripcion, cc.CCvaloremp as monto
		from #pre#RCalculoNomina rcn
		 inner join #pre#CargasCalculo cc
		 	on rcn.RCNid=cc.RCNid
		 inner join DCargas dc
			on cc.DClinea=dc.DClinea
		where rcn.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">	
		<cfif isdefined("form.TcodigoList") and len(trim(form.TcodigoList)) GT 0>
			and rcn.RCNid in (#form.TcodigoList#)
		</cfif>
		<cfif isdefined("form.FechaDesde") and len(trim(form.FechaDesde)) GT 0 and isdefined("form.ckUtilizarFiltroFechas")>
			and rcn.RChasta >= <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(form.FechaDesde)#">
		</cfif>
		<cfif isdefined("form.FechaHasta") and len(trim(form.FechaHasta)) GT 0 and isdefined("form.ckUtilizarFiltroFechas")>
			and rcn.RCdesde <= <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(form.FechaHasta)#">
		</cfif>
	</cfquery>
	<cfquery datasource="#session.dsn#" name="rsDatosDeducciones">
		select rcn.RCNid,dc.DEid,td.TDdescripcion as descripcion, dc.DCvalor as monto
		from #pre#RCalculoNomina rcn
		 inner join #pre#DeduccionesCalculo dc
		 	on rcn.RCNid=dc.RCNid
		 inner join DeduccionesEmpleado de
			on dc.Did=de.Did
		 inner join TDeduccion td
			on de.TDid=td.TDid
		where rcn.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">	
		<cfif isdefined("form.TcodigoList") and len(trim(form.TcodigoList)) GT 0>
			and rcn.RCNid in (#form.TcodigoList#)
		</cfif>
		<cfif isdefined("form.FechaDesde") and len(trim(form.FechaDesde)) GT 0 and isdefined("form.ckUtilizarFiltroFechas")>
			and rcn.RChasta >= <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(form.FechaDesde)#">
		</cfif>
		<cfif isdefined("form.FechaHasta") and len(trim(form.FechaHasta)) GT 0 and isdefined("form.ckUtilizarFiltroFechas")>
			and rcn.RCdesde <= <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(form.FechaHasta)#">
		</cfif>
	</cfquery>
	
	<cfif rsdatos.recordcount GT 0>
		<cfoutput>
		<table width="100%" align="center" cellpadding="0" cellspacing="4" border="0">
			
			<cfquery dbtype="query" name="rsdatosNominas">
				select distinct RCNid ,Tcodigo, nomina, fechaDesde, fechaHasta from rsDatos order by Tcodigo
			</cfquery>
			<!--- variables para guardar los totales finales---->
			<cfset FTbruto=0>
			<cfset FTincidencias=0>
			<cfset FTdevengado=0>
			<cfset FTrenta=0>
			<cfset FTcargasEmpleado=0>
			<cfset FTdeducciones=0>
			<cfset FTliquido=0>	
			<cfloop query="rsdatosNominas">
			<tr>
				<td td colspan="4" nowrap="nowrap"><b><cf_translate  key="LB_Nomina">N&oacute;mina</cf_translate>  #trim(rsdatosNominas.Tcodigo)# - #trim(rsdatosNominas.nomina)#</b></td>
			</tr>
			<tr>
				<td td colspan="4"  nowrap="nowrap">Desde #LSDateFormat(rsdatosNominas.fechaDesde,'dd-mm-yyyy')#  Hasta #LSDateFormat(rsdatosNominas.fechaHasta,'dd-mm-yyyy')#</td>
			</tr>
			
				<!--- obteniendo totales--->			
				<cfset Tbruto=0>
				<cfset Tincidencias=0>
				<cfset Tdevengado=0>
				<cfset Trenta=0>
				<cfset TcargasEmpleado=0>
				<cfset Tdeducciones=0>
				<cfset Tliquido=0>
				
				<cfquery dbtype="query"  name="TotalesPorNominaBruto">
				select sum(bruto) as monto from rsDatos where RCNid=#rsdatosNominas.RCNid#
				</cfquery>
				<cfquery dbtype="query"  name="TotalesPorNominaIncidencias">
				select sum(monto) as monto  from rsDatosIncidencias where RCNid=#rsdatosNominas.RCNid#
				</cfquery>
				<cfquery dbtype="query"  name="TotalesPorNominaRenta">
				select sum(renta) as monto from rsDatos where RCNid=#rsdatosNominas.RCNid#
				</cfquery>
				<cfquery dbtype="query"  name="TotalesPorNominaCargas">
				select sum(monto) as monto  from rsDatosCargas where RCNid=#rsdatosNominas.RCNid#
				</cfquery>
				<cfquery dbtype="query"  name="TotalesPorNominaDeducciones">
				select sum(monto) as monto  from rsDatosDeducciones where RCNid=#rsdatosNominas.RCNid#
				</cfquery>
				<cfquery dbtype="query"  name="TotalesPorNominaLiquido">
				select sum(liquido) as monto  from rsDatos where RCNid=#rsdatosNominas.RCNid#
				</cfquery>
				
				<cfif TotalesPorNominaBruto.recordcount gt 0>
					<cfset Tbruto=TotalesPorNominaBruto.monto>
				</cfif>
				<cfif TotalesPorNominaIncidencias.recordcount gt 0>
					<cfset Tincidencias=TotalesPorNominaIncidencias.monto>
				</cfif>
				<cfif TotalesPorNominaRenta.recordcount gt 0>
					<cfset Trenta=TotalesPorNominaRenta.monto>
				</cfif>
				<cfif TotalesPorNominaCargas.recordcount gt 0>
					<cfset TcargasEmpleado=TotalesPorNominaCargas.monto>
				</cfif>
				<cfif TotalesPorNominaDeducciones.recordcount gt 0>
					<cfset Tdeducciones=TotalesPorNominaDeducciones.monto>
				</cfif>
				<cfif TotalesPorNominaLiquido.recordcount gt 0>
					<cfset Tliquido=TotalesPorNominaLiquido.monto>
				</cfif>
				<cfset Tdevengado=Tbruto+Tincidencias>
				<!--- final de totales por nomina---->
	
				<cfif isdefined("form.radRepDetallado") and trim(form.radRepDetallado) eq 2>
					<cfquery dbtype="query"  name="rsDatosDetalleNomina">
					select * from rsDatos where RCNid=#rsdatosNominas.RCNid# order by CFcodigo, nombre
					</cfquery>
				<cfelse>
					<cfquery dbtype="query"  name="rsDatosDetalleNomina">
					select * from rsDatos where RCNid=#rsdatosNominas.RCNid# order by nombre
					</cfquery>
				</cfif>
		
				
				<cfset idContador=0>
				
				<cfset totalDevengadoCentroF=0>
				<cfset totalDeduccionCentroF=0>
				<cfset totalIncidenciaCentroF=0>
				<cfset totalCargasCentroF=0>
				
				<cfloop query="rsDatosDetalleNomina">
				<tr class="RLTtopline">
					<td align="center" nowrap="nowrap"><cf_translate  key="LB_CFcodigo">C&oacute;digo CF</cf_translate></td>
					<td align="center" nowrap="nowrap"><cf_translate  key="LB_CFdescripcion">CF. Descripci&oacute;n</cf_translate></td>
					<td align="center" nowrap="nowrap"><cf_translate  key="LB_Cedula">Identificaci&oacute;n</cf_translate></td>
					<td align="center" nowrap="nowrap"><cf_translate  key="LB_Nombre">Nombre</cf_translate></td>
					<td align="center" nowrap="nowrap"><cf_translate  key="LB_Bruto">Salario Bruto</cf_translate></td>
					<td align="center" nowrap="nowrap"><cf_translate  key="LB_Incidencias">Incidencias</cf_translate></td>
					<td align="center" nowrap="nowrap"><cf_translate  key="LB_TotalDevengado">Total Devengado</cf_translate></td>
					<td align="center" nowrap="nowrap"><cf_translate  key="LB_Renta">Renta</cf_translate></td>
					<td align="center" nowrap="nowrap"><cf_translate  key="LB_Cargas">Cargas Empleado</cf_translate></td>
					<td align="center" nowrap="nowrap"><cf_translate  key="LB_Deducciones">Deducciones</cf_translate></td>
					<td align="center" nowrap="nowrap"><cf_translate  key="LB_Liquido">Liquido</cf_translate></td>
				</tr>
				<tr class="LTtopline">
					<td  align="left" valign="top"  nowrap="nowrap">#rsDatosDetalleNomina.CFcodigo#</td>
					<td  align="left" valign="top" nowrap="nowrap">#rsDatosDetalleNomina.CFdescripcion#</td>
					<td  align="left" valign="top" nowrap="nowrap">#rsDatosDetalleNomina.cedula#</td>
					<td  align="left" valign="top" nowrap="nowrap">#rsDatosDetalleNomina.nombre#</td>
					<td  align="right" valign="top" nowrap="nowrap"><strong>#LSNumberFormat(rsDatosDetalleNomina.bruto,',.00')#</strong></td>
					<!--- detalle de incidencias---->
					<td  align="right" valign="top"  nowrap="nowrap">
						<table width="100%" align="center" >
							<cfquery dbtype="query" name="detalle">
							select descripcion, monto from rsDatosIncidencias where RCNid=#rsDatosDetalleNomina.RCNid# and DEid=#rsDatosDetalleNomina.DEid#
							</cfquery>
								<cfif isdefined("detalle")>
									<cfquery dbtype="query" name="detalleTotal">
									select sum(monto) as monto from detalle
									</cfquery>
									<cfif detalleTotal.recordcount gt 0>
										<cfset totalIncidenciaCentroF=totalIncidenciaCentroF+detalleTotal.monto>
									</cfif>	
								</cfif>
							<tr class="LTtopline"><td colspan="2" align="right"><strong>#LSNumberFormat(detalleTotal.monto,',.00')#</strong></td></tr>
							<cfloop query="detalle">
							<tr class="LTtopline">
								<td align="left">#detalle.descripcion#</td>
								<td align="right">#LSNumberFormat(detalle.monto,',.00')#</td>
							</tr>
							</cfloop>
						</table>
					</td>
					<!--- devengado=  Salario Bruto + incidencias--->
					<cfquery dbtype="query" name="totalIncidencias">
					select sum(monto) as monto from  rsDatosIncidencias
					where RCNid=#rsDatosDetalleNomina.RCNid# and DEid=#rsDatosDetalleNomina.DEid#
					</cfquery>
					<cfset misIncidencias=0>
					<cfif totalIncidencias.recordcount gt 0>
						<cfset misIncidencias=totalIncidencias.monto>
					</cfif>
					<cfset totalDevengado=misIncidencias+rsDatosDetalleNomina.bruto>
					<cfset totalDevengadoCentroF=totalDevengadoCentroF+totalDevengado>
					<td  align="right" valign="top" nowrap="nowrap"><strong>#LSNumberFormat(totalDevengado,',.00')#</strong></td><!--- devengado--->
					<td  align="right" valign="top" nowrap="nowrap"><strong>#LSNumberFormat(rsDatosDetalleNomina.renta,',.00')#</strong></td>
					<!--- detalle de cargas--->
					<td  align="right" valign="top" nowrap="nowrap">
						<table width="100%" align="center">
							<cfquery dbtype="query" name="detalle">
							select descripcion, monto from rsDatosCargas where RCNid=#rsDatosDetalleNomina.RCNid# and DEid=#rsDatosDetalleNomina.DEid#
							</cfquery>
								<cfif isdefined("detalle")>
									<cfquery dbtype="query" name="detalleTotal">
									select sum(monto) as monto from detalle
									</cfquery>
									<cfif detalleTotal.recordcount gt 0>
										<cfset totalCargasCentroF=totalCargasCentroF+detalleTotal.monto>
									</cfif>	
								</cfif>							
							<tr class="LTtopline"><td colspan="2" align="right" nowrap="nowrap"><strong>#LSNumberFormat(detalleTotal.monto,',.00')#</strong></td></tr>
							<cfloop query="detalle">
							<tr class="LTtopline">
								<td align="left">#detalle.descripcion#</td>
								<td align="right">#LSNumberFormat(detalle.monto,',.00')#</td>
							</tr>
							</cfloop>
						</table>
					</td>
					
					<!--- detalle de deducciones--->
					<td  align="right" valign="top"  nowrap="nowrap">
						<table width="100%" align="center">
							<cfquery dbtype="query" name="detalle">
							select descripcion, monto from rsDatosDeducciones where RCNid=#rsDatosDetalleNomina.RCNid# and DEid=#rsDatosDetalleNomina.DEid#
							</cfquery>
								<cfif isdefined("detalle")>
									<cfquery dbtype="query" name="detalleTotal">
									select sum(monto) as monto from detalle
									</cfquery>
									<cfif detalleTotal.recordcount gt 0>
										<cfset totalDeduccionCentroF=totalDeduccionCentroF+detalleTotal.monto>
									</cfif>
								</cfif>							
							<tr class="LTtopline"><td colspan="2" align="right"><strong>#LSNumberFormat(detalleTotal.monto,',.00')#</strong></td></tr>
							<cfloop query="detalle">
							<tr class="LTtopline">
								<td align="left">#detalle.descripcion#</td>
								<td align="right">#LSNumberFormat(detalle.monto,',.00')#</td>
							</tr>
							</cfloop>
						</table>
					</td>
					<td  align="right" valign="top">
						<strong>#LSNumberFormat(rsDatosDetalleNomina.liquido,',.00')#</strong>
					</td>
				</tr>
				<cfif isdefined("form.radRepDetallado") and trim(form.radRepDetallado) eq 2>
					<cfquery dbtype="query"  name="cantidadRegistros">
					select count(1) as cant from rsDatos where RCNid=#rsdatosNominas.RCNid# and CFcodigo = '#trim(rsDatosDetalleNomina.CFcodigo)#'
					</cfquery>
					<cfset idContador=idContador+1>	
					<cfif trim(idContador) EQ trim(cantidadRegistros.cant)>
						<cfquery dbtype="query" name="CentroFuncional">
						select distinct sum(bruto) as bruto, sum(renta) as renta,sum(liquido) as liquido, max(CFcodigo) as CFcodigo, max(CFdescripcion) as CFdescripcion
						from rsDatos
						where RCNid=#rsDatosDetalleNomina.RCNid# and CFcodigo = '#trim(rsDatosDetalleNomina.CFcodigo)#'
						</cfquery>
						
						<cfquery dbtype="query" name="totalIncidencias">
						select sum(monto) as monto 
						from rsDatosIncidencias
						where RCNid=#rsDatosDetalleNomina.RCNid# and DEid=#rsDatosDetalleNomina.DEid#
						</cfquery>
						
						<tr><td>&nbsp;</td></tr>
						<tr class="LTtopline">
							<td  align="right" colspan="3"  nowrap="nowrap">&nbsp;</td>
							<td  align="center" nowrap="nowrap"><b>Total Centro Funcional: #trim(CentroFuncional.CFcodigo)# - #trim(CentroFuncional.CFdescripcion)#</b></td>
							<td  align="right" nowrap="nowrap"><strong>#LSNumberFormat(CentroFuncional.Bruto,',.00')#</strong></td>
							<td  align="right" nowrap="nowrap"><strong>#LSNumberFormat(totalIncidenciaCentroF,',.00')#</strong></td>
							<td  align="right" nowrap="nowrap"><strong>#LSNumberFormat(totalDevengadoCentroF,',.00')#</strong></td>
							<td  align="right" nowrap="nowrap"><strong>#LSNumberFormat(CentroFuncional.renta,',.00')#</strong></td>
							<td  align="right" nowrap="nowrap"><strong>#LSNumberFormat(totalCargasCentroF,',.00')#</strong></td>
							<td  align="right" nowrap="nowrap"><strong>#LSNumberFormat(totalDeduccionCentroF,',.00')#</strong></td>
							<td  align="right" nowrap="nowrap"><strong>#LSNumberFormat(CentroFuncional.liquido,',.00')#</strong></td>
						</tr>	
						<cfset totalDeduccionCentroF=0>
						<cfset totalIncidenciaCentroF=0>
						<cfset totalCargasCentroF=0>
						<cfset totalDevengadoCentroF=0>
						<cfset idContador=0>
					</cfif>		
							
				</cfif>	
				</cfloop>	
				<tr><td>&nbsp;</td></tr>
				<tr class="LTtopline">
					<td  align="right" colspan="3"  nowrap="nowrap">&nbsp;</td>
					<td  align="center" nowrap="nowrap"><b>Total N&oacute;mina: #trim(rsdatosNominas.Tcodigo)# - #trim(rsdatosNominas.nomina)#</b></td>
					<td  align="right" nowrap="nowrap"><strong>#LSNumberFormat(Tbruto,',.00')#</strong></td>
					<td  align="right" nowrap="nowrap"><strong>#LSNumberFormat(Tincidencias,',.00')#</strong></td>
					<td  align="right" nowrap="nowrap"><strong>#LSNumberFormat(Tdevengado,',.00')#</strong></td>
					<td  align="right" nowrap="nowrap"><strong>#LSNumberFormat(Trenta,',.00')#</strong></td>
					<td  align="right" nowrap="nowrap"><strong>#LSNumberFormat(TcargasEmpleado,',.00')#</strong></td>
					<td  align="right" nowrap="nowrap"><strong>#LSNumberFormat(Tdeducciones,',.00')#</strong></td>
					<td  align="right" nowrap="nowrap"><strong>#LSNumberFormat(Tliquido,',.00')#</strong></td>
				</tr>	
				<tr><td>&nbsp;</td></tr>
				<!--- suma los totales finales---->
					<cfset FTbruto=FTbruto+Tbruto>
					<cfset FTincidencias=FTincidencias+Tincidencias>
					<cfset FTdevengado=FTdevengado+Tdevengado>
					<cfset FTrenta=FTrenta+Trenta>
					<cfset FTcargasEmpleado=FTcargasEmpleado+TcargasEmpleado>
					<cfset FTdeducciones=FTdeducciones+Tdeducciones>
					<cfset FTliquido=FTliquido+Tliquido>
				</cfloop>
				<tr class="RLTtopline ">
					<td  align="right" colspan="3"  nowrap="nowrap">&nbsp;</td>
					<td  align="center" nowrap="nowrap"><b>Total</b></td>
					<td  align="right" nowrap="nowrap"><strong>#LSNumberFormat(FTbruto,',.00')#</strong></td>
					<td  align="right" nowrap="nowrap"><strong>#LSNumberFormat(FTincidencias,',.00')#</strong></td>	
					<td  align="right" nowrap="nowrap"><strong>#LSNumberFormat(FTdevengado,',.00')#</strong></td>
					<td  align="right" nowrap="nowrap"><strong>#LSNumberFormat(FTrenta,',.00')#</strong></td>
					<td  align="right" nowrap="nowrap"><strong>#LSNumberFormat(FTcargasEmpleado,',.00')#</strong></td>
					<td  align="right" nowrap="nowrap"><strong>#LSNumberFormat(FTdeducciones,',.00')#</strong></td>
					<td  align="right" nowrap="nowrap"><strong>#LSNumberFormat(FTliquido,',.00')#</strong></td>
				</tr>	
		</table>
		</cfoutput>
	</cfif>	
</cfif>

<cfif isdefined("rsdatos") and rsdatos.recordcount EQ 0>
	<br>
	<br>
	<cf_translate  key="LB_NoSeGeneroUnReporteSegunLosFiltrosDados">No se gener&oacute; un reporte seg&uacute;n los filtros dados. Intente de nuevo!</cf_translate>
	<br>
	<br>
	<cfabort>
</cfif>
