<!--- 
	Modificado por Gustavo Fonseca H.
		Fecha: 6-9-2005.
		Motivo: Se corrige el query pues filtraba por el SNnombre y debe filtrar por el SNnumero que es el número que se ve en la pantalla, 
		además se prevee si por alguna razón falla la validacion de los rangos del socio en el fuente EstadoCuenta.cfm para que actue como se espera.
	Modificado por Gustavo Fonseca H.
		Fecha: 19-9-2005.
		Motivo: Se agregan los filtros de la fecha.
	Modificado por Gustavo Fonseca H.
		Fecha: 23-11-2005.
		Motivo: Se corrige la condición de la fecha por que no estaba filtrando bien.
 --->
<!--- Las Fechas Son Requeridas --->
<cfif isdefined("url.fecha1") and not isdefined("Form.fecha1")>
	<cfparam name="Form.fecha1" default="#url.fecha1#">
</cfif>
<cfif isdefined("url.fecha2") and not isdefined("Form.fecha2")>
	<cfparam name="Form.fecha2" default="#url.fecha2#">
</cfif>
<cfif isdefined("url.SNcodigo1") and not isdefined("Form.SNcodigo1")>
	<cfparam name="Form.SNcodigo1" default="#url.SNcodigo1#">
</cfif>
<cfif isdefined("url.SNcodigo2") and not isdefined("Form.SNcodigo2")>
	<cfparam name="Form.SNcodigo2" default="#url.SNcodigo2#">
</cfif>
<!--- Los Nombres No Son Requeridos --->
<cfif isdefined("url.SNnombre1") and not isdefined("Form.SNnombre1")>
	<cfparam name="Form.SNnombre1" default="#url.SNnombre1#">
</cfif>
<cfif isdefined("url.SNnombre2") and not isdefined("Form.SNnombre2")>
	<cfparam name="Form.SNnombre2" default="#url.SNnombre2#">
</cfif>

<cfif isdefined("url.SNnumero1") and not isdefined("Form.SNnumero1")>
	<cfparam name="Form.SNnumero1" default="#url.SNnumero1#">
</cfif>
<cfif isdefined("url.SNnumero2") and not isdefined("Form.SNnumero2")>
	<cfparam name="Form.SNnumero2" default="#url.SNnumero2#">
</cfif>

<cfset form.fecha1 	= #lsparsedatetime(form.fecha1)#>
<cfset form.fecha2 	= #lsparsedatetime(form.fecha2)#>
<cfset LvarMes 		= datepart("M", form.fecha1)>
<cfset LvarAnio 	= datepart("yyyy", form.fecha1)>

<cfquery name="rsMonedas" datasource="#session.dsn#">
	select Mcodigo, Mnombre, Msimbolo
	from Monedas
	where Ecodigo = #session.Ecodigo#
	order by Mcodigo
</cfquery>

<cfquery name="rsSocios" datasource="#Session.dsn#">
	select s.SNid, s.SNcodigo, s.SNnombre
	from SNegocios s
	where s.Ecodigo = #session.Ecodigo#
	  <cfif len(trim(Form.SNnumero1))>and s.SNnumero >= '#Form.SNnumero1#'</cfif>
	  <cfif len(trim(Form.SNnumero2))>and s.SNnumero <= '#Form.SNnumero2#'</cfif>
	  and 
	  (	
	  	exists(
			select 1
			from SNSaldosIniciales si
			where si.SNid = s.SNid
			  and si.Speriodo = #LvarAnio#
			  and si.Smes     = #LvarMes#
		 )
	 or exists(
	 	select 1
		from HDocumentos h
		where h.Ecodigo = s.Ecodigo
		  and h.SNcodigo = s.SNcodigo
		  and h.Dfecha >= <cfqueryparam cfsqltype="cf_sql_date" value="#form.fecha1#">
		  and h.Dfecha <= <cfqueryparam cfsqltype="cf_sql_date" value="#form.fecha2#">
		)
	)
	order by s.SNnombre
</cfquery>


<style type="text/css">
	.style0 {text-align: center; text-transform: uppercase; font-size: 16px; text-shadow: Black; font-weight: bold; }
	.style1 {text-align: center; text-transform: uppercase; font-size: 14px; text-shadow: Black; font-weight: bold; }
	.style2 {text-align: center; text-transform: uppercase; font-size: 12px; font-style: italic; text-shadow: Black; font-weight: bold; }
	.style3 {text-align: center; text-transform: uppercase; font-size: 12px; font-style: italic; text-shadow: Black; font-weight: bold; }
	.style4 {text-align: center; text-transform: uppercase; font-size: 12px; font-style: italic; text-shadow: Black;}
</style>
<br>
<cfoutput>
	<table width="98%" align="center" border="0" cellspacing="0" cellpadding="0" class="">
		<tr>
			<td class="style0">#Session.Enombre#</td>
		</tr>
		<tr>
			<td class="style1">Integración de Saldos Resumido en Cuentas por Cobrar</td>
		</tr>
		<tr>
			<td class="style2">
				<cfif isdefined("Form.fecha1") and Len(Trim(Form.fecha1)) NEQ 0>
					Desde: #DateFormat(Form.fecha1, 'dd/mm/yyyy')# &nbsp; 
				<cfelse>
					Desde: Inicio &nbsp; 
				</cfif>
				<cfif isdefined("Form.fecha2") and Len(Trim(Form.fecha2)) NEQ 0>
					Hasta: #DateFormat(Form.fecha2, 'dd/mm/yyyy')# 
				<cfelse>
					Hasta: #dateFormat(Now(),'dd/mm/yyyy')# 
				</cfif>
			</td>
		</tr>
		<tr>
			<td class="style3">
				Clientes:
				<cfif Len(Trim(Form.SNnombre1)) EQ 0 and Len(Trim(Form.SNnombre2)) EQ 0>
					Todos
				<cfelseif Len(Trim(Form.SNnombre1)) NEQ 0 and Len(Trim(Form.SNnombre2)) NEQ 0>
					Desde <i>#Form.SNnombre1#</i> Hasta <i>#Form.SNnombre2#</i>
				<cfelseif Len(Trim(Form.SNnombre1)) NEQ 0>
					Desde <i>#Form.SNnombre1#</i>
				<cfelseif Len(Trim(Form.SNnombre2)) NEQ 0>
					Hasta <i>#Form.SNnombre2#</i>
				</cfif>
			</td>
		</tr>
	</table>
</cfoutput>
<br>
<table width="98%" align="center" border="0" cellspacing="0" cellpadding="0">
  <tr>
    <td class="tituloListas">Moneda</td>
    <td class="tituloListas" align="right">Cantidad</td>
    <td class="tituloListas" align="right">Saldo Inicial</td>
	<td class="tituloListas" align="right">Débitos</td>
    <td class="tituloListas" align="right">Créditos</td>
    <td class="tituloListas" align="right">Saldo Final</td>
  </tr>
<cfloop query="rsMonedas">
	<cfset LvarBanderaMoneda = 0>
	<cfset LvarMoneda    = rsMonedas.Mcodigo>
	<cfset LvarNomMoneda = rsMonedas.Mnombre>
	<cfset TotalCantidad = 0>
	<cfset Totalsaldoinicial = 0>
	<cfset TotalDebitos = 0>
	<cfset TotalCreditos = 0>
	<cfset TotalSaldoFinal = 0>
	<cfloop query="rsSocios">
			<cfset LvarSNid = rsSocios.SNid>
			<cfset LvarSNcodigo = rsSocios.SNcodigo>
			<cfset LvarSNnombre = rsSocios.SNnombre>
			<cfset LvarSaldoInicial  = 0>
			<cfset LvarDebitos  = 0>
			<cfset LvarCreditos = 0>
			<cfset LvarSaldoFinal = 0>
			<cfset LvarCantidad = 0>
			<cfquery name="rsresultado" datasource="#session.dsn#">
				select sum(SIsaldoinicial) as SaldoInicial
				from SNSaldosIniciales 
				where SNid     = #LvarSNid#
				  and Mcodigo  = #LvarMoneda#
				  and Speriodo = #LvarAnio#
				  and Smes     = #LvarMes#
			</cfquery>
			<cfif isdefined('rsresultado') and rsresultado.recordcount GT 0 and len(trim(rsresultado.SaldoInicial))>
				<cfset LvarSaldoInicial = rsresultado.SaldoInicial>
			</cfif>
			<cfquery name="rsresultado" datasource="#session.dsn#">
				select sum(Dtotal) as Debitos, count(1) as Cantidad
				from HDocumentos h
					inner join CCTransacciones t
					on t.Ecodigo = h.Ecodigo
					and t.CCTcodigo = h.CCTcodigo
				where h.Ecodigo    = #Session.Ecodigo#
				  and h.SNcodigo   = #LvarSNcodigo#
				  and h.Mcodigo    = #LvarMoneda#
				  and h.Dfecha    >= <cfqueryparam cfsqltype="cf_sql_date" value="#form.fecha1#"> 
				  and h.Dfecha    <= <cfqueryparam cfsqltype="cf_sql_date" value="#form.fecha2#">
				  and t.CCTtipo    = 'D'
			</cfquery>
			<cfif isdefined('rsresultado') and rsresultado.recordcount GT 0 and len(trim(rsresultado.Debitos))>
				<cfset LvarDebitos = rsresultado.Debitos>
				<cfset LvarCantidad = rsresultado.Cantidad>
			</cfif>
			<cfquery name="rsresultado" datasource="#session.dsn#">
				select sum(Dtotal) as Creditos, count(1) as Cantidad
				from HDocumentos h
					inner join CCTransacciones t
					on t.Ecodigo = h.Ecodigo
					and t.CCTcodigo = h.CCTcodigo
				where h.Ecodigo    = #Session.Ecodigo#
				  and h.SNcodigo   = #LvarSNcodigo#
				  and h.Mcodigo    = #LvarMoneda#
				  and h.Dfecha    >= <cfqueryparam cfsqltype="cf_sql_date" value="#form.fecha1#">
				  and h.Dfecha    <= <cfqueryparam cfsqltype="cf_sql_date" value="#form.fecha2#">
				  and t.CCTtipo    = 'C'
			</cfquery>
			<cfif isdefined('rsresultado') and rsresultado.recordcount GT 0 and len(trim(rsresultado.Creditos))>
				<cfset LvarCreditos = rsresultado.Creditos>
				<cfset LvarCantidad = LvarCantidad + rsresultado.Cantidad>
			</cfif>

			<!--- Pagos  (Creditos)             --->
			<cfquery name="rsresultado" datasource="#session.dsn#">
				select sum(Dtotal) as Creditos
				from BMovimientos m
					inner join CCTransacciones t
					on  t.Ecodigo =   m.Ecodigo
					and t.CCTcodigo = m.CCTcodigo

					inner join CCTransacciones t2
					on t2.Ecodigo = m.Ecodigo
					and t2.CCTcodigo = m.CCTRcodigo
					
				where m.Ecodigo    = #Session.Ecodigo#
				  and m.SNcodigo   = #LvarSNcodigo#
				  and m.Mcodigo    = #LvarMoneda#
				  and m.Dfecha    >= <cfqueryparam cfsqltype="cf_sql_date" value="#form.fecha1#">
				  and m.Dfecha    <= <cfqueryparam cfsqltype="cf_sql_date" value="#form.fecha2#">
				  and t.CCTtipo    = 'C'
				  and t.CCTpago    = 1
				  and t2.CCTtipo   = 'D'
			</cfquery>
			<cfif isdefined('rsresultado') and rsresultado.recordcount GT 0 and len(trim(rsresultado.Creditos))>
				<cfset LvarCreditos = LvarCreditos + rsresultado.Creditos>
			</cfif>

			<!--- Neteos (Creditos / Debitos )  --->
			<cfquery name="rsresultado" datasource="#session.dsn#">
				select 
					sum(case when t2.CCTtipo='D' then Dtotal else 0 end) as Creditos,
					sum(case when t2.CCTtipo='C' then Dtotal else 0 end) as Debitos
				from BMovimientos m
					inner join CCTransacciones t
					on  t.Ecodigo =   m.Ecodigo
					and t.CCTcodigo = m.CCTcodigo

					inner join CCTransacciones t2
					on  t.Ecodigo =   m.Ecodigo
					and t.CCTcodigo = m.CCTRcodigo
				where m.Ecodigo    = #Session.Ecodigo#
				  and m.SNcodigo   = #LvarSNcodigo#
				  and m.Mcodigo    = #LvarMoneda#
				  and m.Dfecha    >= <cfqueryparam cfsqltype="cf_sql_date" value="#form.fecha1#">
				  and m.Dfecha    <= <cfqueryparam cfsqltype="cf_sql_date" value="#form.fecha2#">
				  and t.CCTtranneteo    = 1
			</cfquery>
			<cfif isdefined('rsresultado') and rsresultado.recordcount GT 0 and (len(trim(rsresultado.Debitos)) or len(trim(rsresultado.Creditos)))>
				<cfset LvarCreditos = LvarCreditos + rsresultado.Creditos>
				<cfset LvarDebitos = LvarDebitos + rsresultado.Debitos>
			</cfif>

			<cfif LvarSaldoInicial NEQ 0 or LvarDebitos NEQ 0 or LvarCreditos NEQ 0>
				<cfif LvarBanderaMoneda EQ 0>
					<cfoutput>
						<tr>
						<td style="border-top: 1px solid black;" class="listaCorte" align="left" colspan="6" nowrap >
							#LvarNomMoneda#
						</td>
						</tr>
					</cfoutput>
					<cfset LvarBanderaMoneda = 1>
				</cfif>
				<cfset LvarSaldoFinal = LvarSaldoInicial + LvarDebitos - LvarCreditos>
				<cfoutput>
					<tr>
						<td>#LvarSNnombre#</td>
						<td align="right">#LvarCantidad#</td>
						<td align="right">#LSCurrencyFormat(LvarSaldoinicial,'none')#</td>
						<td align="right">#LSCurrencyFormat(LvarDebitos,'none')#</td>
						<td align="right">#LSCurrencyFormat(LvarCreditos,'none')#</td>
						<td align="right">#LSCurrencyFormat(LvarSaldoFinal,'none')#</td>
					</tr>
				</cfoutput>
				<cfset Totalcantidad = Totalcantidad + LvarCantidad>
				<cfset Totalsaldoinicial = Totalsaldoinicial + LvarSaldoinicial>
				<cfset TotalDebitos = TotalDebitos + LvarDebitos>
				<cfset TotalCreditos = TotalCreditos + LvarCreditos>
				<cfset TotalSaldoFinal = TotalSaldoFinal + LvarSaldoFinal>
			</cfif>
	</cfloop>
	<cfif LvarBanderaMoneda EQ 1>
	<cfoutput>
	  <tr class="listaCorte">
		<td style="border-bottom: 1px solid black; " nowrap><strong>Total #LvarNomMoneda#</strong></td>
		<td style="border-bottom: 1px solid black; " nowrap align="right"><strong>#Totalcantidad#</strong></td>
		<td style="border-bottom: 1px solid black; " nowrap align="right"><strong>#LSCurrencyFormat(Totalsaldoinicial,'none')#</strong></td>
		<td style="border-bottom: 1px solid black; " nowrap align="right"><strong>#LSCurrencyFormat(TotalDebitos,'none')#</strong></td>
		<td style="border-bottom: 1px solid black; " nowrap align="right"><strong>#LSCurrencyFormat(TotalCreditos,'none')#</strong></td>
		<td style="border-bottom: 1px solid black; " nowrap align="right"><strong>#LSCurrencyFormat(TotalSaldoFinal,'none')#</strong></td>
	  </tr>
	  <tr><td colspan="6">&nbsp;</td></tr>
	 </cfoutput>
	 </cfif>
</cfloop>
</table>
<br>
<table width="98%" align="center" border="0" cellspacing="0" cellpadding="0">
	<tr> 
		<td class="style4"> ------------------ Fin del Reporte ------------------ </td>
	</tr>
</table>