<cfparam name="modo" default="ALTA">
<cfinvoke component="sif.Componentes.Translate" method="init" returnvariable="t">
<cfset LB_Titulo1 		= t.Translate('LB_Titulo1','GRUPO COMERCIAL GRAN BAZAR')>
<cfset LB_Titulo2		= t.Translate('LB_Titulo2','Desglose Deuda')>
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


<cfset prevPag="reporteDesgloseDeuda.cfm">
<cfset targetAction="reporteDesgloseDeuda_sql.cfm">
<cfinclude template="imprimirReporte.cfm" >

<cfquery name="q_DatosReporte" datasource="#Session.DSN#">
Select * from (
	select r.id, 
		case when sum(r.Intereses) <= 0 and sum(r.GastoCobranza) <= 0 then case when cuenta.saldo < 0 then 0 else cuenta.saldo end else sum(r.Capital) end Capital, 
		sum(r.Intereses) Intereses, 
		case when sum(r.GastoCobranza) >= 0 then sum(r.GastoCobranza) else 0 end GastoCobranza,
		c.Numero, sn.SNnombre, ec.Descripcion, c.Tipo, 
		case when cuenta.saldo < 0 then 0 else cuenta.saldo end Saldo
	from (
		select 
			a.id,
			Capital = case when a.TipoTransaccion in ('TC','VC') then sum(a.Saldo_Capital) else 0 end,
			GastoCobranza = case when a.TipoTransaccion = 'GC' then sum(a.Saldo_Capital) else 0 end,
			Intereses = sum(a.Saldo_Intereses)
		from (
			select c.id, t.TipoTransaccion, t.monto,-- m.id,
				sum(m.MontoRequerido) MontoRequerido,  sum(m.Intereses) Intereses,  
				sum(m.MontoRequerido) + sum(m.Intereses) MontoPagar,  
				sum(m.Pagado + isnull(m.Descuento,0) + isnull(m.Condonaciones,0)) Pagado,
				Saldo_Intereses = sum(m.Intereses)/*case
									when sum(m.Pagado + isnull(m.Descuento,0) + isnull(m.Condonaciones,0)) >= sum(m.Intereses) then 0
									else sum(m.Intereses) - sum(m.Pagado + isnull(m.Descuento,0) + isnull(m.Condonaciones,0))
								end*/,
				Saldo_Capital = sum(m.MontoRequerido) - sum(m.Pagado + isnull(m.Descuento,0) + isnull(m.Condonaciones,0))/*case
									when sum(m.Pagado + isnull(m.Descuento,0) + isnull(m.Condonaciones,0)) >= sum(m.Intereses) 
										then sum(m.MontoRequerido) - (sum(m.Pagado + isnull(m.Descuento,0) + isnull(m.Condonaciones,0)) - sum(m.Intereses))
									else sum(m.MontoRequerido)
								end*/
			from CRCCuentas c
			inner join CRCTransaccion t on c.id = t.CRCCuentasid
			inner join CRCMovimientoCuenta m on t.id = m.CRCTransaccionid
			where 1 = 1 /*c.id = 50*/
			and t.TipoTransaccion in ('TC','VC','GC')
			group by c.id, t.monto, t.TipoTransaccion
			having t.monto - sum(m.Pagado + isnull(m.Descuento,0) + isnull(m.Condonaciones,0)) > 0
		) a
		group by a.id, a.TipoTransaccion
	) r
	inner join (
			select a.id,
				Saldo = sum(
					Monto * case when a.TipoMov = 'D' then -1 else 1 end 
				),
				Credito = sum(
					Monto * case when a.TipoMov = 'D' then 0 else 1 end 
				),
				Debito = sum(
					Monto * case when a.TipoMov = 'D' then 1 else 0 end 
				)   
			from (
				select c.id, c.SaldoActual, t.TipoMov, t.TipoTransaccion, sum(t.Monto) Monto
				from CRCCuentas c
				inner join SNegocios s
					on c.SNegociosSNid = s.SNid
				inner join CRCTransaccion t
					on c.id = t.CRCCuentasid
				inner join CRCTipoTransaccion tt
					on tt.id = t.CRCTipoTransaccionid
				where 1=1 <!--- and c.SaldoVencido > 0 --->
					<cfif !isDefined('url.p')> and 1=0 </cfif>
					<cfif isdefined('form.tipoCta') && form.tipoCta neq ''>
						and rtrim(ltrim(c.Tipo)) = '#form.tipoCta#'
					</cfif>
					<cfif isdefined('form.EstatusCuentaID') && form.EstatusCuentaID neq ''>
						and c.CRCEstatusCuentasid in (#form.EstatusCuentaID#)
					</cfif>
				group by c.id, c.SaldoActual, t.TipoMov, t.TipoTransaccion
			) a
			group by a.id
		) cuenta on r.id = cuenta.id
	inner join CRCCuentas c on c.id = r.id
	inner join SNegocios sn on sn.SNid = c.SNegociosSNid
	inner join CRCEstatusCuentas ec on ec.id = c.CRCEstatusCuentasid
	where ec.Descripcion <> 'Juridico'
	group by r.id, c.Numero, sn.SNnombre, ec.Descripcion, c.Tipo, 
			case when cuenta.saldo < 0 then 0 else cuenta.saldo end

			Union All

select * from (
	select r.id, 
		case when sum(r.Intereses) <= 0 and sum(r.GastoCobranza) <= 0 then case when cuenta.saldo < 0 then 0 else cuenta.saldo end else sum(r.Capital) end Capital, 
		sum(r.Intereses) Intereses, 
		case when sum(r.GastoCobranza) >= 0 then sum(r.GastoCobranza) else 0 end GastoCobranza,
		c.Numero, sn.SNnombre, ec.Descripcion, c.Tipo 
		, sum(SaldoTotal) as Saldo
	from (
		select 
			a.id,
			Capital = case when a.TipoTransaccion in ('TC','VC') then sum(a.Saldo_Capital) else 0 end,
			GastoCobranza = case when a.TipoTransaccion = 'GC' then sum(a.Saldo_Capital) else 0 end,
			Intereses = sum(a.Saldo_Intereses),
			SaldoTotal = sum(a.Saldo_Intereses) + sum(a.Saldo_Capital)
		from (
			select c.id, t.TipoTransaccion, t.monto,-- m.id,
				sum(m.MontoRequerido) MontoRequerido,  sum(m.Intereses) Intereses,  
				sum(m.MontoRequerido) + sum(m.Intereses) MontoPagar,  
				sum(m.Pagado + isnull(m.Descuento,0) + isnull(m.Condonaciones,0)) Pagado,
				Saldo_Intereses = sum(m.Intereses),
				Saldo_Capital = sum(m.MontoRequerido) - sum(m.Pagado + isnull(m.Descuento,0) + isnull(m.Condonaciones,0))
			from CRCCuentas c
			inner join CRCTransaccion t on c.id = t.CRCCuentasid
			inner join CRCMovimientoCuenta m on t.id = m.CRCTransaccionid
			where 1 = 1 
			and t.TipoTransaccion in ('TC','VC','GC')
			group by c.id, t.monto, t.TipoTransaccion
			--having t.monto - sum(m.Pagado + isnull(m.Descuento,0) + isnull(m.Condonaciones,0)) > 0
		) a
		group by a.id, a.TipoTransaccion
	) r
	inner join (
			select a.id,
				Saldo = sum(
					Monto * case when a.TipoMov = 'D' then -1 else 1 end 
				),
				Credito = sum(
					Monto * case when a.TipoMov = 'D' then 0 else 1 end 
				),
				Debito = sum(
					Monto * case when a.TipoMov = 'D' then 1 else 0 end 
				)   
			from (
				select c.id, c.SaldoActual, t.TipoMov, t.TipoTransaccion, sum(t.Monto) Monto
				from CRCCuentas c
				inner join SNegocios s
					on c.SNegociosSNid = s.SNid
				inner join CRCTransaccion t
					on c.id = t.CRCCuentasid
				inner join CRCTipoTransaccion tt
					on tt.id = t.CRCTipoTransaccionid
				where 1=1 
				<cfif !isDefined('url.p')> and 1=0 </cfif>
					<cfif isdefined('form.tipoCta') && form.tipoCta neq ''>
						and rtrim(ltrim(c.Tipo)) = '#form.tipoCta#'
					</cfif>
					<cfif isdefined('form.EstatusCuentaID') && form.EstatusCuentaID neq ''>
						and c.CRCEstatusCuentasid in (#form.EstatusCuentaID#)
					</cfif>
				group by c.id, c.SaldoActual, t.TipoMov, t.TipoTransaccion
			) a
			group by a.id
		) cuenta on r.id = cuenta.id
	inner join CRCCuentas c on c.id = r.id
	inner join SNegocios sn on sn.SNid = c.SNegociosSNid
	inner join CRCEstatusCuentas ec on ec.id = c.CRCEstatusCuentasid
	where ec.Descripcion = 'Juridico'
	group by r.id, c.Numero, sn.SNnombre, ec.Descripcion, c.Tipo, 
			case when cuenta.saldo < 0 then 0 else cuenta.saldo end
			) Total
) a
order by SNnombre
	/* select c.id, c.Numero, sn.SNnombre, ec.Descripcion, c.Tipo, 
		case when cuenta.saldo < 0 then 0 else cuenta.saldo end Saldo,
		isnull(desglose.Capital, case when cuenta.saldo < 0 then 0 else cuenta.saldo end) Capital,
		isnull(desglose.Intereses, 0) Intereses,
		isnull(desglose.GastoCobranza, 0) GastoCobranza 
	from (
		select a.id,
			Saldo = sum(
				Monto * case when a.TipoMov = 'D' then -1 else 1 end 
			),
			Credito = sum(
				Monto * case when a.TipoMov = 'D' then 0 else 1 end 
			),
			Debito = sum(
				Monto * case when a.TipoMov = 'D' then 1 else 0 end 
			)   
		from (
			select c.id, c.SaldoActual, t.TipoMov, t.TipoTransaccion, sum(t.Monto) Monto
			from CRCCuentas c
			inner join SNegocios s
				on c.SNegociosSNid = s.SNid
			inner join CRCTransaccion t
				on c.id = t.CRCCuentasid
			inner join CRCTipoTransaccion tt
				on tt.id = t.CRCTipoTransaccionid
			where c.SaldoVencido > 0
				<cfif !isDefined('url.p')> and 1=0 </cfif>
				<cfif isdefined('form.tipoCta') && form.tipoCta neq ''>
					and rtrim(ltrim(c.Tipo)) = '#form.tipoCta#'
				</cfif>
				<cfif isdefined('form.EstatusCuentaID') && form.EstatusCuentaID neq ''>
					and c.CRCEstatusCuentasid in (#form.EstatusCuentaID#)
				</cfif>
			group by c.id, c.SaldoActual, t.TipoMov, t.TipoTransaccion
		) a
		group by a.id
	) cuenta
	inner join CRCCuentas c on c.id = cuenta.id
	inner join SNegocios sn on sn.SNid = c.SNegociosSNid
	inner join CRCEstatusCuentas ec on ec.id = c.CRCEstatusCuentasid
	left join (
		select d.id, sum(d.Capital) Capital, sum(d.Intereses) Intereses, sum(d.GastoCobranza) GastoCobranza
		from (
			select c.id, t.TipoTransaccion, 
			sum(mc.Intereses) Intereses,
			case when t.TipoTransaccion != 'GC' then isnull(sum(sv.SaldoVencido),0) else 0 end Capital,
			case when t.TipoTransaccion = 'GC' then isnull(sum(sv.SaldoVencido),0) else 0 end GastoCobranza
			from CRCCuentas c
			inner join CRCTransaccion t
				on c.id = t.CRCCuentasid
			inner join CRCMovimientoCuenta mc
				on mc.CRCTransaccionid = t.id
			inner join (
				select mcsv.id, mcsv.SaldoVencido
				from CRCMovimientoCuenta mcsv
				inner join CRCCortes ct2
					on mcsv.Corte = ct2.Codigo
					and ct2.status =2
			) sv
				on mc.id = sv.id
			left join CRCCortes ct
				on mc.Corte = ct.Codigo
			group by c.id,t.TipoTransaccion
		) d
		group by d.id
	) desglose
		on cuenta.id = desglose.id
	order by c.Numero */
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
								<td>#LB_Cuenta#</td>
								<td>#LB_Nombre#</td>
								<td>#LB_TipoCuenta#</td>
								<td>#LB_Estatus#</td>
								<td>Saldo</td>
								<td>Capital</td>
								<td>Interes</td>
								<td>Gastos Cobranza</td>
							</tr>
							<cfif q_DatosReporte.RecordCount gt 0>
								<cfset total.Saldo = 0>
								<cfset total.Capital = 0>
								<cfset total.Intereses = 0>
								<cfset total.GastoCobranza = 0>
								<cfloop query="q_DatosReporte">
									<tr>
										<td align="left">#q_DatosReporte.Numero#</td>
										<td align="left">#q_DatosReporte.SNnombre#</td>
										<td align="left">#q_DatosReporte.Tipo#</td>
										<td align="left">#q_DatosReporte.Descripcion#</td>
										<td align="right">#lsCurrencyFormat(q_DatosReporte.Saldo)#</td>
										<td align="right">#lsCurrencyFormat(q_DatosReporte.Capital)#</td>
										<td align="right">#lsCurrencyFormat(q_DatosReporte.Intereses)#</td>
										<td align="right">#lsCurrencyFormat(q_DatosReporte.GastoCobranza)#</td>
									</tr>
									<cfset total.Saldo += q_DatosReporte.Saldo>
									<cfset total.Capital += q_DatosReporte.Capital>
									<cfset total.Intereses += q_DatosReporte.Intereses>
									<cfset total.GastoCobranza += q_DatosReporte.GastoCobranza>
								</cfloop>
								<tr style="background-color: ##A9A9A9;">
									<td align="right" colspan="4"<b>TOTAL</b></td>
									<td align="right">#lsCurrencyFormat(total.Saldo)#</td>
									<td align="right">#lsCurrencyFormat(total.Capital)#</td>
									<td align="right">#lsCurrencyFormat(total.Intereses)#</td>
									<td align="right">#lsCurrencyFormat(total.GastoCobranza)#</td>									
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

