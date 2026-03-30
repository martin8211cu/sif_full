<cfsetting requesttimeout="1800" showdebugoutput="no">
<cfif isdefined("form.botonsel") and len(trim(form.botonsel)) and form.botonsel eq "Exportar">
    <cfheader name="Content-Disposition" value="inline; filename=SaldosDiarios.xls">
	<cfcontent type="application/vnd.msexcel" reset="yes">
<cfelse>
	<cf_templatecss>
</cfif>
<cfflush interval="32">

<cfif isdefined("url.periodo") and len(trim(url.periodo)) and not isdefined("form.periodo")>
	<cfset form.periodo = url.periodo>
</cfif>

<cfif isdefined("url.Cmayor") and len(trim(url.Cmayor)) and not isdefined("form.Cmayor")>
	<cfset form.Cmayor = url.Cmayor>
</cfif>

<cfif isdefined("url.Mcodigo") and len(trim(url.Mcodigo)) and url.Mcodigo NEQ "-1" and not isdefined("form.Mcodigo")>
	<cfset form.Mcodigo = url.Mcodigo>
</cfif> 
<cfset FechaGeneracion = Now()>
<cfset LvarMaxCuentas = 60>
<cfset LvarCantidadRegistros = fnObtieneCuentas(LvarMaxCuentas)>

<cfset tControlTiempoInicial = gettickcount()>

<cfset fnGeneraParametros()>
<cfloop query="DataReporte">
	<cfset fnGeneraReporte(DataReporte.Cuenta, DataReporte.Formato, DataReporte.Descripcion)>
</cfloop>
<cfset tControlTiempoFinal = gettickcount()>

	<br>
	<br>
	Generado en :  <cfoutput>#TcontrolTiempoFinal - TcontrolTiempoInicial#</cfoutput> milisegundos
	<br>


<cffunction name="fnGeneraReporte" access="private" returntype="numeric" hint="Obtiene y Calcula la Información de Saldos Diarios">
	<cfargument name="Cuenta"      type="numeric" required="yes">
	<cfargument name="Formato"     type="string"  required="yes">
	<cfargument name="Descripcion" type="string"  required="yes">

	<cfset LcntlDia = 1>
	<cfset LcntlMes = 1>
	<cfset LcntlPer = form.periodo>
	<cfset LvarColumnaSaldo  = " s.SLinicial ">
	<cfset LvarColumnaMov    = " d.Dlocal ">
	<cfset LvarFiltroMov     = "">
	<cfset LvarFiltroSaldo   = "">
	<cfset LvarSaldoMes  = arraynew(1)>
	<cfset arrayset(LvarSaldoMes, 1, 12, 0.00)>
	<cfset LvarSaldoDias = arraynew(1)>
	
	<cfif isdefined('form.Mcodigo') and form.Mcodigo NEQ -1>
		<cfset LvarColumnaSaldo = " s.SOinicial ">
		<cfset LvarColumnaMov   = " d.Doriginal ">
		<cfset LvarFiltroMov    = " and d.Mcodigo = #form.Mcodigo#">
		<cfset LvarFiltroSaldo  = " and s.Mcodigo = #form.Mcodigo#">
	</cfif>		

	<cfquery name="rsSaldoCuentaMes" datasource="#session.dsn#">
		select Smes, sum(#LvarColumnaSaldo#) as SaldoInicial
		from SaldosContables s
		where s.Ccuenta  = #Arguments.Cuenta#
		  and s.Speriodo = #LcntlPer#
		  #LvarFiltroSaldo#
		group by Smes
	</cfquery> 

	<cfquery name="rsMovimientoCuentaDia" datasource="#session.dsn#">
		select d.Emes as Smes, e.Efecha as Fecha, sum( case when Dmovimiento = 'D' then #LvarColumnaMov# else -#LvarColumnaMov# end ) as MovimientoDia
		from HDContables d
			inner join HEContables e
			on e.IDcontable = d.IDcontable
		where d.Ccuenta = #Arguments.Cuenta#
		  and d.Eperiodo = #LcntlPer#
		  and e.ECtipo   <> 1
		  #LvarFiltroMov#
		group by d.Emes, e.Efecha
	</cfquery>

	<table width="100%"  border="0" cellspacing="0" cellpadding="2">
		<tr>
			<td colspan="13" align="center"><strong><cfoutput>#session.Enombre#</cfoutput></strong></td>
		</tr>
		<tr>
			<td colspan="13" align="center"><strong>Reporte de Saldos Diarios</strong></td>
		</tr>
		<tr>
			<td colspan="13" align="center"><strong><cfoutput>#Arguments.Formato# - #Arguments.Descripcion#</cfoutput></strong></td>
		</tr>
		<cfif isdefined("form.Mcodigo") and form.Mcodigo NEQ "-1">
			<tr>
				<td colspan="13" align="center"><strong>Moneda: <cfoutput>#lvarMoneda#</cfoutput></strong></td>
			</tr>
		</cfif>
		<tr>
			<td colspan="13" align="center"><strong>Periodo: <cfoutput>#LcntlPer#</cfoutput></strong></td>
		</tr>
		
		<tr>
			<td colspan="13" align="center"><strong>Generado: </strong><cfoutput>#LSDateFormat(FechaGeneracion, 'dd/mm/yyyy')# #LSTimeFormat(FechaGeneracion, 'hh:mm tt')#</cfoutput></td>
		</tr>
		<tr>
			<td colspan="13" align="center">&nbsp;</td>
		</tr>
		<tr align="center">
			<cfset fnPoneEncabezados()>
		</tr>
		
		<cfloop condition="LcntlDia LT 32">
			<cfset LcntlMes = 1>
			<tr>
				<td align="right"><cfoutput>#LcntlDia#</cfoutput></td>
				<cfloop condition="LcntlMes LT 13">
					<cftry>
						<cfset LvarFechaCiclo = createdate(LcntlPer, LcntlMes, LcntlDia)>
						<cfset LvarSaldoDia = 0.00>
						<cfquery name="rsSaldosMes" dbtype="query">
							select SaldoInicial
							from rsSaldoCuentaMes
							where Smes = #LcntlMes#
						</cfquery>
						<cfif rsSaldosMes.recordcount EQ 1>
							<cfset LvarSaldoDia = rsSaldosMes.SaldoInicial>
						</cfif>
						<cfquery name="rsSaldosDia" dbtype="query">
							select sum(MovimientoDia) as Movimiento
							from rsMovimientoCuentaDia
							where Smes = #LcntlMes#
							  and Fecha <= #LvarFechaCiclo#
						</cfquery>
						<cfif rsSaldosDia.recordcount GT 0>
							<cfset LvarSaldoDia = LvarSaldoDia + rsSaldosDia.Movimiento>
						</cfif>
						<td align="right"><cfoutput>#numberformat(LvarSaldoDia, ",0.00")#</cfoutput></td>
						<cfset LvarSaldoMes[LcntlMes]  = LvarSaldoMes[LcntlMes] + LvarSaldoDia>
						<cfset LvarSaldoDias[LcntlMes] = LcntlDia>
					<cfcatch type="any">
						<td align="right">&nbsp;</td>
					</cfcatch>
					</cftry>
					<cfset LcntlMes = LcntlMes + 1>
				</cfloop>
			</tr>	
			<cfset LcntlDia = LcntlDia + 1>
		</cfloop>
		<tr style="background-color:#CCCCCC">
			<td><font color="#000000"><strong>Prom</strong></font></td>
			<td align="right"><font color="#000000"><cfoutput><strong>#NumberFormat(LvarSaldoMes[1] / LvarSaldoDias[1], ",0.00")#</strong></cfoutput></font></td>
			<td align="right"><font color="#000000"><cfoutput><strong>#NumberFormat(LvarSaldoMes[2] / LvarSaldoDias[2], ",0.00")#</strong></cfoutput></font></td>
			<td align="right"><font color="#000000"><cfoutput><strong>#NumberFormat(LvarSaldoMes[3] / LvarSaldoDias[3], ",0.00")#</strong></cfoutput></font></td>
			<td align="right"><font color="#000000"><cfoutput><strong>#NumberFormat(LvarSaldoMes[4] / LvarSaldoDias[4], ",0.00")#</strong></cfoutput></font></td>
			<td align="right"><font color="#000000"><cfoutput><strong>#NumberFormat(LvarSaldoMes[5] / LvarSaldoDias[5], ",0.00")#</strong></cfoutput></font></td>
			<td align="right"><font color="#000000"><cfoutput><strong>#NumberFormat(LvarSaldoMes[6] / LvarSaldoDias[6], ",0.00")#</strong></cfoutput></font></td>
			<td align="right"><font color="#000000"><cfoutput><strong>#NumberFormat(LvarSaldoMes[7] / LvarSaldoDias[7], ",0.00")#</strong></cfoutput></font></td>
			<td align="right"><font color="#000000"><cfoutput><strong>#NumberFormat(LvarSaldoMes[8] / LvarSaldoDias[8], ",0.00")#</strong></cfoutput></font></td>
			<td align="right"><font color="#000000"><cfoutput><strong>#NumberFormat(LvarSaldoMes[9] / LvarSaldoDias[9], ",0.00")#</strong></cfoutput></font></td>
			<td align="right"><font color="#000000"><cfoutput><strong>#NumberFormat(LvarSaldoMes[10] / LvarSaldoDias[10], ",0.00")#</strong></cfoutput></font></td>
			<td align="right"><font color="#000000"><cfoutput><strong>#NumberFormat(LvarSaldoMes[11] / LvarSaldoDias[11], ",0.00")#</strong></cfoutput></font></td>
			<td align="right"><font color="#000000"><cfoutput><strong>#NumberFormat(LvarSaldoMes[12] / LvarSaldoDias[12], ",0.00")#</strong></cfoutput></font></td>
		</tr>
	</table>
	<p style="page-break-before: always">
	<cfreturn 1> 
</cffunction>

<cffunction name="fnObtieneCuentas" access="private" returntype="numeric" output="no" hint="Obtiene las Cuentas para procesar la información de los saldos diarios">
	<cfargument name="MaxCuentas" type="numeric" required="yes">
	<!--- 
			Obtiene todas las cuentas que acepten movimientos 
			y que tenga saldos o movimientos en algun mes del año, para no presentar cuentas ya cerradas
	--->
	<cfquery name="DataReporte" datasource="#Session.DSN#">
		select c.Ccuenta as Cuenta, c.Cformato as Formato, c.Cdescripcion as Descripcion
		from CContables c
		where c.Ecodigo = #Session.Ecodigo#
		  and c.Cmayor = '#Form.Cmayor#'
		  and c.Cmovimiento = 'S'
		  and (
			select count(1)
			from SaldosContables sc
			where sc.Ccuenta = c.Ccuenta
			  and sc.Speriodo = #Form.periodo#
			<cfif isdefined('form.Mcodigo') and form.Mcodigo NEQ "-1">
				and sc.Mcodigo = #form.Mcodigo#
			</cfif>
			) > 0
		order by c.Cformato
	</cfquery>

	<cfset LvarCantidadRegistros = DataReporte.recordcount>
	<cfif LvarCantidadRegistros GT LvarMaxCuentas>
		<br />
		<br />
		<br />
		<p align="center"> Error en el Reporte de Saldos Diarios </p>
		<br />
		<p align="center"> Se generaron <cfoutput>#lvarCantidadRegistros#</cfoutput> cuentas con saldos para la Cuenta: <cfoutput>#Form.Cmayor#</cfoutput></p>
		<br />
		<p align="center"> Se permite un máximo de <cfoutput>#LvarMaxCuentas#</cfoutput> para la generación de este informe</p>
		<br />
		<p align="center"> Seleccione <a href="SaldosDiarios.cfm"> Regresar </a> para seleccionar otra cuenta de Mayor</p>
		<cfabort>
	</cfif>
	<cfreturn LvarCantidadRegistros>
</cffunction>

<cffunction name="fnGeneraParametros" access="private" output="no" returntype="any" hint="Genera los parametros de calculo del reporte">
	<cfset lvarMoneda = "">
	<cfif isdefined("form.Mcodigo") and len(trim(form.Mcodigo)) and form.Mcodigo NEQ "-1">
    	<cfinclude template="../../Utiles/sifConcat.cfm">
		<cfquery name="rsMonedas" datasource="#Session.DSN#">
			select m.Miso4217 #_Cat# ' - ' #_Cat# m.Mnombre as Moneda
			from Monedas m
			where Mcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Mcodigo#">
			  and Ecodigo = #Session.Ecodigo#
		</cfquery>
		
		<cfset lvarMoneda = rsMonedas.Moneda>
		
	</cfif>
	<cfset t1 = Now()>
	<cfset fecha = CreateDate(Form.periodo, 01, 01)>
	<cfset fechainicial = fecha>
	<cfset fechatope = DateAdd('yyyy', 1, fecha)>
</cffunction>

<cffunction name="fnPoneEncabezados" access="private" description="Pone los Encabezados de las tablas de HTML">
	<cfif isdefined("form.botonsel") and len(trim(form.botonsel)) and form.botonsel eq "Exportar">
		<td align="right" bgcolor="#CCCCCC"><strong>D&iacute;a</strong></td>
		<td align="right" bgcolor="#CCCCCC"><strong>Enero</strong></td>
		<td align="right" bgcolor="#CCCCCC"><strong>Febrero</strong></td>
		<td align="right" bgcolor="#CCCCCC"><strong>Marzo</strong></td>
		<td align="right" bgcolor="#CCCCCC"><strong>Abril</strong></td>
		<td align="right" bgcolor="#CCCCCC"><strong>Mayo</strong></td>
		<td align="right" bgcolor="#CCCCCC"><strong>Junio</strong></td>
		<td align="right" bgcolor="#CCCCCC"><strong>Julio</strong></td>
		<td align="right" bgcolor="#CCCCCC"><strong>Agosto</strong></td>
		<td align="right" bgcolor="#CCCCCC"><strong>Septiembre</strong></td>
		<td align="right" bgcolor="#CCCCCC"><strong>Octubre</strong></td>
		<td align="right" bgcolor="#CCCCCC"><strong>Noviembre</strong></td>
		<td align="right" bgcolor="#CCCCCC"><strong>Diciembre</strong></td>
	<cfelse>
		<td align="right" style="border-left: 1px solid black; border-bottom: 1px solid black; border-right: 1px solid black; border-top: 1px solid black;" bgcolor="#CCCCCC"><strong>D&iacute;a</strong></td>
		<td align="right" style="border-bottom: 1px solid black; border-right: 1px solid black; border-top: 1px solid black;" bgcolor="#CCCCCC"><strong>Enero</strong></td>
		<td align="right" style="border-bottom: 1px solid black; border-right: 1px solid black; border-top: 1px solid black;" bgcolor="#CCCCCC"><strong>Febrero</strong></td>
		<td align="right" style="border-bottom: 1px solid black; border-right: 1px solid black; border-top: 1px solid black;" bgcolor="#CCCCCC"><strong>Marzo</strong></td>
		<td align="right" style="border-bottom: 1px solid black; border-right: 1px solid black; border-top: 1px solid black;" bgcolor="#CCCCCC"><strong>Abril</strong></td>
		<td align="right" style="border-bottom: 1px solid black; border-right: 1px solid black; border-top: 1px solid black;" bgcolor="#CCCCCC"><strong>Mayo</strong></td>
		<td align="right" style="border-bottom: 1px solid black; border-right: 1px solid black; border-top: 1px solid black;" bgcolor="#CCCCCC"><strong>Junio</strong></td>
		<td align="right" style="border-bottom: 1px solid black; border-right: 1px solid black; border-top: 1px solid black;" bgcolor="#CCCCCC"><strong>Julio</strong></td>
		<td align="right" style="border-bottom: 1px solid black; border-right: 1px solid black; border-top: 1px solid black;" bgcolor="#CCCCCC"><strong>Agosto</strong></td>
		<td align="right" style="border-bottom: 1px solid black; border-right: 1px solid black; border-top: 1px solid black;" bgcolor="#CCCCCC"><strong>Septiembre</strong></td>
		<td align="right" style="border-bottom: 1px solid black; border-right: 1px solid black; border-top: 1px solid black;" bgcolor="#CCCCCC"><strong>Octubre</strong></td>
		<td align="right" style="border-bottom: 1px solid black; border-right: 1px solid black; border-top: 1px solid black;" bgcolor="#CCCCCC"><strong>Noviembre</strong></td>
		<td align="right" style="border-bottom: 1px solid black; border-right: 1px solid black; border-top: 1px solid black;" bgcolor="#CCCCCC"><strong>Diciembre</strong></td>
	</cfif>
</cffunction>