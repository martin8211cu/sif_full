<!--- VARIABLES DE TRADUCCION --->
<cfinvoke Key="LB_ReporteDeAnticposPorEmpleado" Default="Reporte de Anticipos por Empleado" returnvariable="LB_ReporteDeAnticposPorEmpleado" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="LB_Fecha" Default="Fecha" returnvariable="LB_Fecha" component="sif.Componentes.Translate" method="Translate"/>
<!--- FIN VARIABLES DE TRADUCCION --->
<cfquery name="rsReporte" datasource="#session.DSN#">
	select b.ACCAid,b.ACCTid, ACCTcodigo, ACCTdescripcion,
		ACCTcapital,
		ACCTamortizado,
		ACCTfechaInicio,
		ACCTcuotas,
		ACPPpagoInteres as Interes,
		ACPPpagoPrincipal,
		ACPPestado,
		ACPPfecha,
		c.ACPPfechaPago as Aplicacion, 
		(ACPPpagoInteres + ACPPpagoPrincipal) as Cuota, 
		ACPPsaldoAnterior, 
		DEidentificacion,
		{fn concat(DEnombre,{fn concat(' ',{fn concat(DEapellido1,{fn concat(' ',DEapellido2)})})})} as nombre,
		ACPPestado as estado
	from ACAsociados a
	inner join ACCreditosAsociado b
		  on b.ACAid = a.ACAid
		 and b.ACCTfechaInicio between <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(url.Fdesde)#"> 
		  							and <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(url.Fhasta)#">
		<cfif isdefined('url.ACCTid') and url.ACCTid GT 0>
		and b.ACCTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.ACCTid#">
		</cfif>
	inner join ACPlanPagos c
		  on c.ACCAid = b.ACCAid
	inner join DatosEmpleado d
		on d.DEid = a.DEid
		and d.Ecodigo = b.Ecodigo
	inner join ACCreditosTipo e
		on e.ACCTid = b.ACCTid
	where b.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	  <cfif isdefined('url.DEid') and LEN(TRIM(url.DEid))>
	  and a.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.DEid#">
	  </cfif>
	order by DEidentificacion, ACCTid,ACCAid, ACPPfecha
</cfquery>
<!--- Busca el nombre de la Empresa --->
<cfquery name="rsEmpresa" datasource="#session.DSN#">
	select Edescripcion
	from Empresas
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
</cfquery>

<style>
	h1.corte {
		PAGE-BREAK-AFTER: always;}
	.titulo_empresa2 {
		font-size:16px;
		font-weight:bold;
		text-align:center;}
	.titulo_columnar {
		font-size:14px;
		font-weight:bold;
		background-color:#CCCCCC;
		text-align:right;
		height:20px}
	.detalle {
		font-size:14px;
		text-align:left;}
	.detaller {
		font-size:14px;
		text-align:right;}
	.detallec {
		font-size:14px;
		text-align:center;}	
</style>

<cfif rsReporte.RecordCount>
	<table width="750" align="center" border="0" cellspacing="0" cellpadding="0">
		<cfoutput>
		<tr><td align="center" colspan="7" class="titulo_empresa2"><strong>#rsEmpresa.Edescripcion#</strong></td></tr>
		<tr><td align="center" colspan="7" class="titulo_empresa2"><strong>#LB_ReporteDeAnticposPorEmpleado#</strong></td></tr>
		<tr><td colspan="7">&nbsp;</td></tr>
		<tr><td align="right" colspan="7" class="detaller"><strong>#LB_Fecha#:#LSDateFormat(now(),'dd/mm/yyyy')#</strong></td></tr>
		</cfoutput>
		<cfoutput query="rsReporte" group="ACCTid">
			<tr>
				<td class="detalle" colspan="5"><strong><cf_translate key="LB_TipoDeCredito">Tipo de Cr&eacute;dito</cf_translate></strong>:<strong>&nbsp;#ACCTcodigo#&nbsp;-&nbsp;#ACCTdescripcion#</strong></td>
			</tr>
			<cfoutput group="ACCAid">
				<cfquery name="rsPagado" dbtype="query">
					select sum(Interes) as InteresPagado, sum(ACPPpagoPrincipal) as capitalPagado
					from rsReporte
					where ACPPestado = 'S'
					  and ACCAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#ACCAid#">
				</cfquery>
				<cfquery name="rsPendiente" dbtype="query">
					select sum(Interes) as InteresPendiente, sum(ACPPpagoPrincipal) as capitalPendiente, count(1) as Cuotas
					from rsReporte
					where ACPPestado = 'N'
					  and ACCAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#ACCAid#">
				</cfquery>
				<cfquery name="rsInteresesTotales" dbtype="query">
					select sum(Interes) as Interes
					from rsReporte
					where ACCAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#ACCAid#">
				</cfquery>
				<cfset Lvar_ImprimeSaldosCero = 1>
				<cfif rsPagado.capitalPagado GTE rsReporte.ACCTcapital and isdefined('url.chkSaldoCero')>
					<cfset Lvar_ImprimeSaldosCero = 0>
				</cfif>
				<cfif Lvar_ImprimeSaldosCero>
				<tr>
					<td colspan="7">
						<table width="650" align="center" border="0" cellspacing="2" cellpadding="0">
							<tr>
								<td class="detalle" colspan="5"><strong><cf_translate key="LB_Asociado">Asociado</cf_translate></strong>:<strong>&nbsp;#DEidentificacion#&nbsp;-&nbsp;#nombre#</strong></td>
							</tr>
							<tr>
								<td class="detalle" nowrap><strong><cf_translate key="LB_FechaDelPrestamo">Fecha del Anticipo</cf_translate>: #LSDateFormat(ACCTfechaInicio,'dd/mm/yyyy')#</strong></td>
								<td class="detalle" colspan="2"><strong><cf_translate key="LB_Cuotas">Cuotas</cf_translate>: #ACCTcuotas#</td>
							</tr>
							<tr>
								<td class="detalle"><strong><cf_translate key="LB_CapitalInicial">Capital Inicial</cf_translate>: #LSCurrencyFormat(ACCTcapital,'none')#</strong></td>
								<td class="detalle"><strong><cf_translate key="LB_BonosTotales">Bonos Totales</cf_translate>: #LSCurrencyFormat(rsInteresesTotales.Interes,'none')#</strong></td>
								<td class="detalle"><strong><cf_translate key="LB_Total">Total</cf_translate>: #LSCurrencyFormat(ACCTcapital+ rsInteresesTotales.Interes,'none')#</strong></td>
							</tr>
							<tr>
								<td class="detalle"><strong><cf_translate key="LB_CapitalPagado">Capital Pagado</cf_translate>: <cfif isdefined('rsPagado') and rsPagado.RecordCount>#LSCurrencyFormat(rsPagado.capitalPagado,'none')#<cfelse>0.00</cfif></strong></td>
								<td class="detalle"><strong><cf_translate key="LB_BonosPagado">Bonos Pagados</cf_translate>: <cfif isdefined('rsPagado') and rsPagado.RecordCount>#LSCurrencyFormat(rsPagado.InteresPagado,'none')#<cfelse>0.00</cfif></strong></td>
								<td class="detalle"><strong><cf_translate key="LB_TotalPagado">Total Pagado</cf_translate>: <cfif isdefined('rsPagado') and rsPagado.RecordCount>#LSCurrencyFormat(rsPagado.capitalPagado + rsPagado.InteresPagado,'none')#<cfelse>0.00</cfif></strong></td>
							</tr>
							<cfif isdefined('rsPendiente') and rsPendiente.RecordCount>
							<tr>
								<td class="detalle"><strong><cf_translate key="LB_CapitalPendiente">Capital Pendiente</cf_translate>: #LSCurrencyFormat(rsPendiente.capitalPendiente,'none')#</strong></td>
								<td class="detalle"><strong><cf_translate key="LB_BonosPendientes">Bonos Pendientes</cf_translate>: #LSCurrencyFormat(rsPendiente.InteresPendiente,'none')#</strong></td>
								<td class="detalle"><strong><cf_translate key="LB_CuotasPendientes">Cuotas Pendientes</cf_translate>: #rsPendiente.cuotas#</strong></td>
							</tr>
							</cfif>
						</table>
					</td>
				</tr>
				<tr><td colspan="7">&nbsp;</td></tr>
				<tr class="titulo_columnar">
					<td align="left"><cf_translate key="LB_Fecha">Fecha</cf_translate></td>
					<td align="right"><cf_translate key="LB_Cuota">Cuota</cf_translate></td>
					<td align="right"><cf_translate key="LB_Amortización">Amortizaci&oacute;n</cf_translate></td>
					<td align="right"><cf_translate key="LB_Bonos">Bonos</cf_translate></td>
					<td align="right"><cf_translate key="LB_SaldoActual">Saldo Actual</cf_translate></td>
					<td align="right"><cf_translate key="LB_BonosAcum">Bonos Acum.</cf_translate></td>
					<td align="right"><cf_translate key="LB_CapitalPagado">Capital Pagado</cf_translate></td>
					<td align="right" style="padding-left:7px;"><cf_translate key="LB_Estado">Pagado</cf_translate></td>
				</tr>
				<cfset Lvar_DeudaActual = ACCTcapital>
				<cfset Lvar_InteresAcum = 0>
				<cfset Lvar_CapitalPagado = 0>
				<cfoutput>
					<cfset Lvar_InteresAcum = Lvar_InteresAcum + Interes>
					<cfset Lvar_CapitalPagado = Lvar_CapitalPagado + ACPPpagoPrincipal>
					<tr <cfif ACPPestado EQ 'S'>bgcolor="EAEAEA"</cfif>>
						<td class="detalle">#LSDateFormat(ACPPfecha,'dd/mm/yyyy')#</td>
						<td class="detaller">#LSCurrencyFormat(Cuota,'none')#</td>
						<td class="detaller">#LSCurrencyFormat(ACPPpagoPrincipal,'none')#</td>
						<td class="detaller">#LSCurrencyFormat(Interes,'none')#</td>
						<td class="detaller">#LSCurrencyFormat(Lvar_DeudaActual,'none')#</td>
						<td class="detaller">#LSCurrencyFormat(Lvar_InteresAcum,'none')#</td>
						<td class="detaller">#LSCurrencyFormat(Lvar_CapitalPagado,'none')#</td>
						<td class="detaller"><cfif estado eq 'S'>S&iacute;<cfelse>No</cfif></td>						
					</tr>
					<cfset Lvar_DeudaActual = Lvar_DeudaActual - ACPPpagoPrincipal>
				</cfoutput>
				<tr><td colspan="5">&nbsp;</td></tr>
					
				</cfif>
			</cfoutput>
			<cfif isdefined('url.chkCorte')>
			<tr><td width="1%"><h1 style="page-break-after:always"></td></tr> 
			</cfif>
		</cfoutput>
	</table>
<cfelse>
	<table width="700" align="center" border="0" cellspacing="0" cellpadding="0">
		<tr><td align="center"><cf_translate key="MSG_NoHayDatosRelacionados">No hay datos relacionados</cf_translate></td></tr>
	</table>
</cfif>