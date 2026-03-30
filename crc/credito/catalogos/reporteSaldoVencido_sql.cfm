<cfparam name="modo" default="ALTA">
<cfinvoke component="sif.Componentes.Translate" method="init" returnvariable="t">
<cfset LB_Titulo1 		= t.Translate('LB_Titulo1','GRUPO COMERCIAL GRAN BAZAR')>
<cfset LB_Titulo2		= t.Translate('LB_Titulo2','Listado de Saldos Vencidos GBCC')>
<cfset LB_Titulo3		= t.Translate('LB_Titulo3','Generado el')>

<cfset LB_Cuenta		= t.Translate('LB_Cuenta', 'Cuenta')>
<cfset LB_Nombre		= t.Translate('LB_Nombre', 'Nombre')>
<cfset LB_TipoCuenta	= t.Translate('LB_TipoCuenta', 'Tipo Cuenta')>
<cfset LB_Estatus		= t.Translate('LB_Estatus', 'Estatus')>
<cfset LB_Compras		= t.Translate('LB_Compras', 'Compras')>
<cfset LB_PorPagar		= t.Translate('LB_PorPagar', 'Por Pagar')>
<cfset LB_Vencido		= t.Translate('LB_Vencido', 'Vencido')>
<cfset LB_UltimoPago	= t.Translate('LB_UltimoPago', 'Ultimo Pago')>
<cfset LB_FechaUlt		= t.Translate('LB_FechaUlt', 'Fecha Ultimo Pago')>


<cfset prevPag="reporteSaldoVencido.cfm">
<cfset targetAction="reporteSaldoVencido_sql.cfm">
<cfinclude template="imprimirReporte.cfm" >

<cfquery name="q_DatosReporte" datasource="#Session.DSN#">
	select
	<cfif isdefined("form.resumen")>
		c.Tipo, ec.Descripcion
		, sum(c.Compras) Compras
		, sum(c.SaldoActual) SaldoActual
		, sum(c.SaldoVencido) SaldoVencido
		, sum(c.Interes) Interes
		, sum(dp.Monto) Monto
	<cfelse>
		  c.Numero, sn.SNnombre, ec.Descripcion, c.Compras, c.Tipo
		, c.SaldoActual, c.SaldoVencido, c.Interes, dp.Monto, dp.fecha, sn.SNdireccion
	</cfif>
	from CRCCuentas c
		inner join SNegocios sn
			on sn.SNid = c.SNegociosSNid
		inner join CRCEstatusCuentas ec
			on ec.id = c.CRCEstatusCuentasid
		left join (select CRCCuentasid, max(id) id from CRCTransaccion where TipoTransaccion = 'PG' group by CRCCuentasid) up
			on up.CRCCuentasid = c.id
		left join CRCTransaccion dp
			on dp.id = up.id
	where
		c.SaldoVencido > 0
		<cfif !isDefined('url.p')> and 1=0 </cfif>
		<cfif isdefined('form.tipoCta') && form.tipoCta neq ''>
			and rtrim(ltrim(c.Tipo)) = '#form.tipoCta#'
		</cfif>
		<cfif isdefined('form.EstatusCuentaID') && form.EstatusCuentaID neq ''>
			and c.CRCEstatusCuentasid in (#form.EstatusCuentaID#)
		</cfif>
	<cfif isdefined("form.resumen")>
		group by c.Tipo, ec.Descripcion
	</cfif>
</cfquery>

<cfquery name="rsReporteTotal" dbtype="query">
	select sum(Compras) as Compras, sum(SaldoActual) as SaldoActual, 
		sum(SaldoVencido) as SaldoVencido ,sum(Interes) as Interes, sum(Monto) as Monto
	from q_DatosReporte
</cfquery>


<cfif isdefined('form.EstatusCuentaID') && form.EstatusCuentaID neq ''>
	<cfquery name="q_CRCEstatusCuentas" datasource="#Session.DSN#">
		select descripcion from CRCEstatusCuentas where Ecodigo = #session.Ecodigo# and id in (#form.EstatusCuentaID#)
	</cfquery>
</cfif>

<cfoutput>
<!--- Tabla para mostrar resultados del reporte generado --->
<div id="#printableArea#">
	<table width="100%" cellpadding="2" cellspacing="0">
		<tr>
			<td valign="top">
				<table  width="100%" cellpadding="2" cellspacing="0" border="0">
					<tr><td colspan="4">&nbsp;</td></tr>
					<tr>
						<td height="22" align="center" width="40%">
							<span class="style1" style="font-family: verdana; font-size: 200%">#LB_Titulo1#</span><br>
							<span style="font-family: verdana; font-size: 100%"><strong>#LB_Titulo2#</strong><br></span>
							<strong>#LB_Titulo3# #LSDateFormat(Now(),'dd/mm/yyyy')#</strong><br>
						</td>
					</tr>
					<tr height="22" align="center"></tr>
					<tr>
						<table width="100%" border="0">
							<tr>
								<td colspan="9" align="right">
									Filtros: [Saldo Vencido > 0] 
									<cfif isdefined('form.tipoCta') && form.tipoCta neq ''> &amp; [Tipo Cuenta = #form.tipoCta#]</cfif>
									<cfif isdefined('form.EstatusCuentaID') && form.EstatusCuentaID neq ''> 
										<cfset EstatusCuentas = ValueList(q_CRCEstatusCuentas.descripcion)>
										&amp; [Estatus Cuenta = (#EstatusCuentas#)]
									</cfif>
								</td>
							</tr>
							<tr style="background-color: ##A9A9A9;">
								<cfif not isdefined("form.resumen")>
									<td>#LB_Cuenta#</td>
									<td>#LB_Nombre#</td>
									<td>Direccion</td>
								</cfif>
								<td>#LB_TipoCuenta#</td>
								<td>#LB_Estatus#</td>
								<cfif not isdefined("form.resumen")>
									<td>#LB_Compras#</td>
								</cfif>
								<td>Saldo</td>
								<td>#LB_Vencido#</td>
								<td>Interes</td>
								<cfif not isdefined("form.resumen")>
									<td>#LB_UltimoPago#</td>
									<td>#LB_FechaUlt#</td>
								</cfif>
							</tr>
							<cfif q_DatosReporte.RecordCount gt 0>
									<cfloop query="q_DatosReporte">
										<tr>
											<cfif not isdefined("form.resumen")>
												<td align="left">#q_DatosReporte.Numero#</td>
												<td align="left">#q_DatosReporte.SNnombre#</td>
												<td align="left">#q_DatosReporte.SNdireccion#</td>
											</cfif>
											<td align="left">#q_DatosReporte.Tipo#</td>
											<td align="left">#q_DatosReporte.Descripcion#</td>
											<cfif not isdefined("form.resumen")>
												<td align="right">#lsCurrencyFormat(q_DatosReporte.Compras)#</td>
											</cfif>
											<td align="right">#lsCurrencyFormat(q_DatosReporte.SaldoActual)#</td>
											<td align="right">#lsCurrencyFormat(q_DatosReporte.SaldoVencido)#</td>
											<td align="right">#lsCurrencyFormat(q_DatosReporte.Interes)#</td>
											<cfif not isdefined("form.resumen")>
												<td align="right">#lsCurrencyFormat(q_DatosReporte.Monto)#</td>
												<td align="right">#DateFOrmat(q_DatosReporte.fecha,"dd/mm/yyyy")#</td>
											</cfif>
										</tr>
									</cfloop>
									<tr style="background-color: ##A9A9A9;">
										<td align="right" <cfif not isdefined("form.resumen")>colspan="5"<cfelse>colspan="2"</cfif>><b>TOTAL</b></td>
										<cfif not isdefined("form.resumen")>
											<td align="right"><b>#lsCurrencyFormat(rsReporteTotal.Compras)#</b></td>
										</cfif>
										<td align="right"><b>#lsCurrencyFormat(rsReporteTotal.SaldoActual)#</b></td>
										<td align="right"><b>#lsCurrencyFormat(rsReporteTotal.SaldoVencido)#</b></td>
										<td align="right"><b>#lsCurrencyFormat(rsReporteTotal.Interes)#</b></td>
										<cfif not isdefined("form.resumen")>
											<td align="right"><b>#lsCurrencyFormat(rsReporteTotal.Monto)#</b></td>
											<td align="right"></td>
										</cfif>
									</tr>
							<cfelse>
								<tr><td colspan="9">&nbsp;</td></tr>
								<tr><td colspan="9" align="center"><font color="red"><span style="text-align: center;">--- No se encontraron resultados ---</span></font></td></tr>
							</cfif>
						</table>
					</tr>
				</table>
			</td>	
		</tr>
	</table>
</div>
	
</cfoutput>

