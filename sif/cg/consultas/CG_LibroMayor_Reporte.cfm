<cfsetting requesttimeout="900">
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>Reporte de Libro Mayor</title>
</head>
<cf_htmlReportsHeaders 
	title="Libro Mayor Contabilidad" 
	bodytag="style=""size:portrait; page:'letter';""" 
	filename="LibroMayor#dateformat(now(), 'YYYY-MM-DD')##dateformat(now(), 'HHmmss')#.xls"
	irA="CG_LibroMayor.cfm"  
>

<cfif not isdefined('form.btnDownload')>
                <cf_templatecss>
</cfif>    

<cfparam name="periodoini" type="integer" default="2007">
<cfparam name="mesini" type="integer" default="1">
<cfparam name="periodofin" type="integer" default="2007">
<cfparam name="mesfin" type="integer" default="1">
<cfif isdefined("form.periodoini")>
	<cfset periodoini = form.periodoini>
</cfif>
<cfif isdefined("form.periodofin")>
	<cfset periodofin = form.periodofin>
</cfif>
<cfif isdefined("form.mesini")>
	<cfset mesini = form.mesini>
</cfif>
<cfif isdefined("form.mesfin")>
	<cfset mesfin = form.mesfin>
</cfif>
<cfflush interval="20">
<table width="100%">
	<cfoutput>
		<tr>
			<td colspan="7" align="center" style="font-size:16px; font-weight:bolder">#session.enombre#</td>
		</tr>
		<tr>
			<td colspan="7" align="center" style="font-size:16px; font-weight:bolder">Libro Mayor</td>
		</tr>
		<tr>
			<td colspan="7">&nbsp;</td>
		</tr>
	</cfoutput>
	<cfquery name="rsCuentas" datasource="#session.dsn#">
		select c.Ccuenta, c.Cformato, c.Cdescripcion
		from CContables c
		where c.Ecodigo = #session.Ecodigo#
		  and c.Cmovimiento = 'S'
		  and ((
				select count(1)
				from SaldosContables s
				where s.Ccuenta = c.Ccuenta
				   and (s.Speriodo * 100 + s.Smes ) between #(periodoini * 100 + mesini)# and #(periodofin * 100 + mesfin)#
			)) > 0
		order by Cformato
	</cfquery>
	<cfloop query="rsCuentas">
		<cfset LvarCuenta = rsCuentas.Ccuenta>
		<cfset LvarCformato = rsCuentas.Cformato>
		<cfset LvarCdescripcion = rsCuentas.Cdescripcion>
		<cfset LvarCuentaAnt = -1>
		<cfset LvarCSaldo = 0.00>
		<cfset LvarTotCDebitos = 0.00>
		<cfset LvarTotCCreditos = 0.00>
		<cfquery name="rsOficinas" datasource="#session.dsn#">
			select Ocodigo, Oficodigo, Odescripcion
			from Oficinas o
			where o.Ecodigo = #session.Ecodigo#
			order by Oficodigo
		</cfquery>
		<cfloop query="rsOficinas">
			<cfset LvarOcodigo = rsOficinas.Ocodigo>
			<cfset LvarOficodigo = rsOficinas.Oficodigo>
			<cfset LvarOdescripcion = rsOficinas.Odescripcion>
			<cfset LvarSaldo       = 0.00>
			<cfset LvarTotDebitos  = 0.00>
			<cfset LvarTotCreditos = 0.00>
			<cfquery name="rsSaldosContables" datasource="#session.dsn#">
				select count(1) as Cantidad
				from SaldosContables s
				where s.Ccuenta = #rsCuentas.Ccuenta#
                   and s.Speriodo >= #periodoini#
                   and s.Speriodo <= #periodofin#
				   and s.Ocodigo = #LvarOcodigo#
				   and s.Speriodo * 100 + s.Smes between #periodoini * 100 + mesini# and #periodofin * 100  + mesfin#
			</cfquery>
			<cfif rsSaldosContables.Cantidad GT 0>
				<!--- Imprmir la cuenta y descripcion --->
				<cfif LvarCuentaAnt NEQ LvarCuenta>
					<tr>
						<cfoutput><td colspan="7"><strong>CUENTA: #LvarCformato#  #LvarCdescripcion#</strong></td></cfoutput>
					</tr>
				</cfif>
				
				<cfquery name="rsSaldosContables" datasource="#session.dsn#">
					select sum(s.SLinicial) as SaldoInicial
					from SaldosContables s
					where s.Ccuenta = #LvarCuenta#
					   and s.Ocodigo = #LvarOcodigo#
					   and s.Speriodo = #periodoini#
					   and s.Smes = #mesini#
				</cfquery>
				<cfif isdefined("rsSaldosContables") and len(trim(rsSaldosContables.SaldoInicial)) NEQ 0 and rsSaldosContables.recordcount GT 0 and rsSaldosContables.SaldoInicial NEQ 0>
					<cfset LvarSaldo = rsSaldosContables.SaldoInicial>
				</cfif>
				<cfoutput>	
					<tr>
						<td colspan="7">&nbsp;</td>
					</tr>
					<tr>
						<td colspan="5">Oficina: #LvarOdescripcion#</td>
						<td colspan="1" align="right">Saldo Inicial:</td>
						<td colspan="1" align="right">#NumberFormat(LvarSaldo, ",9.00")#</td>
					</tr>
					<tr>
						<td colspan="7">&nbsp;</td>
					</tr>
					<tr>
						<td align="right"><strong>Año</strong></td>
						<td align="right"><strong>Mes</strong></td>
						<td align="right"><strong>Fecha</strong></td>
						<td><strong>Descripción</strong></td>
						<td align="right"><strong>Débitos</strong></td>
						<td align="right"><strong>Créditos</strong></td>
						<td align="right"><strong>Saldo</strong></td>
					</tr>
				</cfoutput>
				<cfquery name="rsMovimientos" datasource="#session.dsn#">
					select 
						e.Eperiodo, e.Emes, e.Efecha, e.ECtipo,
						sum(case when d.Dmovimiento = 'D' then Dlocal else 0.00 end) as Debitos, 
						sum(case when d.Dmovimiento='C' then Dlocal else 0.00 end) as Creditos
					from HDContables d
						inner join HEContables e
						on e.IDcontable = d.IDcontable
					where d.Ccuenta = #LvarCuenta#
					   and d.Ocodigo = #LvarOcodigo#
					   and (d.Eperiodo * 100 + d.Emes) between #(periodoini * 100 + mesini)# and #(periodofin * 100 + mesfin)#
					   <cfif not isdefined("chkCierre")>
	                       and e.ECtipo <> 1
                       </cfif>
					group by e.Eperiodo, e.Emes, e.Efecha, e.ECtipo
					order by e.Eperiodo, e.Emes, e.Efecha, e.ECtipo
				</cfquery>
				<cfoutput query="rsMovimientos">
					<cfset LvarTotDebitos  = LvarTotDebitos + rsMovimientos.Debitos>
					<cfset LvarTotCreditos = LvarTotCreditos + rsMovimientos.Creditos>
					<cfset LvarSaldo = LvarSaldo + rsMovimientos.Debitos - rsMovimientos.Creditos>
					<tr>
						<td align="right">#numberformat(rsMovimientos.Eperiodo, "9999")#</td>
						<td align="right">#numberformat(rsMovimientos.Emes, "99")#</td>
						<td align="right">#dateformat(rsMovimientos.Efecha, "DD/MM/YYYY")#</td>
						<td>&nbsp;Movimiento del dia</td>
						<td align="right"><cfif rsMovimientos.Debitos NEQ 0>#numberformat(rsMovimientos.Debitos, ",9.00")#<cfelse>&nbsp;</cfif></td>
						<td align="right"><cfif rsMovimientos.Creditos NEQ 0>#numberformat(rsMovimientos.Creditos, ",9.00")#<cfelse>&nbsp;</cfif></td>
						<td align="right">#numberformat(LvarSaldo, ",9.00")#</td>
					</tr>
				</cfoutput>
				<cfoutput>
					<tr>
						<td colspan="4" align="left">Total #LvarOdescripcion#</td>
						<td align="right" style="border-top:solid; border-width:thin">#numberformat(LvarTotDebitos, ",9.00")#</td>
						<td align="right" style="border-top:solid; border-width:thin">#numberformat(LvarTotCreditos, ",9.00")#</td>
						<td align="right">&nbsp;</td>
					</tr>
					<tr>
						<td colspan="6">Saldo Final #LvarOdescripcion#</td>
						<td align="right">#numberformat(LvarSaldo, ",9.00")#</td>
					</tr>
				</cfoutput>
				<cfset LvarCuentaAnt = LvarCuenta>
			</cfif>
			<cfset LvarCSaldo = LvarCSaldo + LvarSaldo>
			<cfset LvarTotCDebitos = LvarTotCDebitos + LvarTotCreditos>
			<cfset LvarTotCCreditos = LvarTotCCreditos + LvarTotCreditos>
		</cfloop>
		<cfif LvarCuentaAnt NEQ -1>
			<cfset ImprimeCuenta()>
		</cfif>
	</cfloop>
	<cfif isdefined("LvarCuentaAnt") and LvarCuentaAnt NEQ -1>
		<cfset ImprimeCuenta()>
	</cfif>
	<tr>
		<td colspan="7"><div align="center">----- Fin del Reporte -----</div></td>
	</tr>
</table>
<body>
</body>
</html>

<cffunction name="ImprimeCuenta" returntype="any" output="true">
	<cfoutput>
		<tr>
			<td colspan="7">&nbsp;</td>
		</tr>

		<tr>
			<td colspan="4" align="left"><strong>Total #LvarCdescripcion#</strong></td>
			<td align="right" style="border-top:thick"><strong>#numberformat(LvarTotCDebitos, ",9.00")#</strong></td>
			<td align="right" style="border-top:thick"><strong>#numberformat(LvarTotCCreditos, ",9.00")#</strong></td>
			<td align="right">&nbsp;</td>
		</tr>
		<tr>
			<td colspan="6"><strong>Saldo Final #LvarCdescripcion#</strong></td>
			<td align="right"><strong>#numberformat(LvarCSaldo, ",9.00")#</strong></td>
		</tr>
		<tr>
			<td colspan="7">&nbsp;</td>
		</tr>
	</cfoutput>
</cffunction>

