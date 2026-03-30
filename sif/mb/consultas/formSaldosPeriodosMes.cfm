<!---------
	Modificado por: Ana Villavicencio
	Fecha de modificación: 25 de mayo del 2005
	Motivo:	Se cambio el proceso de construccion del reporte utilizando Report Builder
			ademas de la correccion de la consulta q no estaba correcta.
----------->

<cfinvoke component="sif.Componentes.Translate" method="Translate" key="MSG_NoHayDatosParaReportar" default="No hay datos para reportar" returnvariable="MSG_NoHayDatosParaReportar" xmlfile="formSaldosPeriodosMes.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_TituloReporte" default="Reporte de Movimientos de Bancos por Período/Mes" returnvariable="LB_TituloReporte" xmlfile="formSaldosPeriodosMes.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_Periodo" default="Periodo" returnvariable="LB_Periodo" xmlfile="formSaldosPeriodosMes.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_Mes" default="Mes" returnvariable="LB_Mes" xmlfile="formSaldosPeriodosMes.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_Cuenta" default="CUENTA" returnvariable="LB_Cuenta" xmlfile="formSaldosPeriodosMes.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_SaldoMonedaOrigen" default="Saldo Inicial" returnvariable="LB_SaldoMonedaOrigen" xmlfile="formSaldosPeriodosMes.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_SaldoMonedaLocal" default="Saldo Inicial" returnvariable="LB_SaldoMonedaLocal" xmlfile="formSaldosPeriodosMes.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_MonedaLocal" default="Moneda Local" returnvariable="LB_MonedaLocal" xmlfile="formSaldosPeriodosMes.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_MonedaOrigen" default="Moneda Origen" returnvariable="LB_MonedaOrigen" xmlfile="formSaldosPeriodosMes.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_Fecha" default="Fecha" returnvariable="LB_Fecha" xmlfile="formSaldosPeriodosMes.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_Documento" default="Documento" returnvariable="LB_Documento" xmlfile="formSaldosPeriodosMes.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_Descripcion" default="Descripción" returnvariable="LB_Descripcion" xmlfile="formSaldosPeriodosMes.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_Debito" default="Débito" returnvariable="LB_Debito" xmlfile="formSaldosPeriodosMes.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_Credito" default="Crédito" returnvariable="LB_Credito" xmlfile="formSaldosPeriodosMes.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_FinReporte" default="FIN DEL REPORTE" returnvariable="LB_FinReporte" xmlfile="formSaldosPeriodosMes.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_TotalDebitoCredito" default="Total Débitos/Créditos" returnvariable="LB_TotalDebitoCredito" xmlfile="formSaldosPeriodosMes.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_SaldoFinalMonedaOrigen" default="Saldo Final Moneda Original" returnvariable="LB_SaldoFinalMonedaOrigen" xmlfile="formSaldosPeriodosMes.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_SaldoFinalMonedaLocal" default="Saldo Final Moneda Local" returnvariable="LB_SaldoFinalMonedaLocal" xmlfile="formSaldosPeriodosMes.xml"/>


<cfif isdefined("url.MLmes") and  not isdefined("form.MLmes")>
	<cfset form.MLmes = url.MLmes>
</cfif>
<cfif isdefined("url.MLperiodo") and  not isdefined("form.MLperiodo")>
	<cfset form.MLperiodo = url.MLperiodo>
</cfif>
<cfif isdefined("url.formato") and  not isdefined("form.formato")>
	<cfset form.formato = url.formato>
</cfif>

<cfif isdefined("url.CBid") and  not isdefined("form.CBid")>
	<cfset form.CBid = url.CBid>
</cfif>

<cfquery name="rsEmpresa" datasource="#session.DSN#">
	select Edescripcion
	from Empresas
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
</cfquery>

<cfif isdefined('form.formato') and isdefined('form.MLmes') and isdefined('form.MLperiodo') >
	<cfquery name="rsReporte" datasource="#session.DSN#">
		select DISTINCT cb.Ocodigo,cb.Mcodigo, cb.Bid, ml.CBid,ml.MLid,
				ml.MLfecha,
				ml.MLdescripcion,
				ml.MLtipomov,
				(case ml.MLtipomov when 'C' then MLmonto when 'D' then 0 end) as CreditoO,
				(case ml.MLtipomov when 'C' then 0  when 'D' then MLmonto end) as DebitoO,
				(case ml.MLtipomov when 'C' then MLmontoloc when 'D' then 0 end) as CreditoL,
				(case ml.MLtipomov when 'C' then 0  when 'D' then MLmontoloc end) as DebitoL,
				cb.CBcodigo, o.Odescripcion, ml.Bid, b.Bdescripcion, m.Mnombre, MLmonto, MLmontoloc,
				<cf_dbfunction name="concat" args="tb.BTcodigo,' - ',ml.MLdocumento"> as MLdocumento,
				coalesce(Sinicial, 0) as SaldoInicialO,
				coalesce(Slocal, 0) as SaldoInicialL,
				tb.BTcodigo as CodigoTransaccion
		from MLibros ml
			inner join BTransacciones tb
				on tb.BTid = ml.BTid
			inner join Bancos b
				on b.Bid=ml.Bid
			inner join CuentasBancos cb
				 on cb.CBid = ml.CBid
				and cb.Ecodigo = ml.Ecodigo
			inner join  Oficinas o
				 on o.Ocodigo=cb.Ocodigo
				and o.Ecodigo=cb.Ecodigo
			inner join Monedas m
				on m.Mcodigo=cb.Mcodigo
			left outer join SaldosBancarios sb
				 on sb.CBid = ml.CBid
				and sb.Periodo = ml.MLperiodo
				and sb.Mes = ml.MLmes
		where ml.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
          and cb.CBesTCE = <cfqueryparam value="0" cfsqltype="cf_sql_bit">
		  and MLperiodo = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.MLperiodo#">
		  and MLmes = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.MLmes#">
		<cfif isdefined('form.CBid') and form.CBid GT 0>
		  and ml.CBid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CBid#">
		</cfif>
		ORDER BY cb.Bid,
         ml.CBid,
		 cb.Mcodigo,
		 ml.MLfecha
	</cfquery>

	<cfif isdefined("form.MLmes")>
		<cfset myDate = CreateDate(YEAR(now()), #form.MLmes#, 1)>

		<cfset varMes = #UCASE(LSDATEFORMAT(myDate,'MMMM','es_MX'))#>
	<cfelse>
		<cfset varMes = "Sin definir">
	</cfif>
	<!--- pdf flaspaper--->
	<cfif isdefined('rsReporte') and rsReporte.REcordCount GT 0 and form.formato NEQ "excel">
		<cfreport format="#form.formato#" template="../Reportes/RPMovimientosPeriodoMes.cfr" query="rsReporte">
		<cfif isdefined("rsEmpresa") and rsEmpresa.recordcount gt 0>
			<cfreportparam name="Edescripcion" value="#rsEmpresa.Edescripcion#">
			<cfreportparam name="Periodo" value="#form.MLperiodo#">
			<cfreportparam name="Mes" value="#varMes#">
            <cfreportparam name="LBTituloReporte" value="#LB_TituloReporte#">
            <cfreportparam name="LBPeriodo" value="#LB_Periodo#">
            <cfreportparam name="LBMes" value="#LB_Mes#">
            <cfreportparam name="LBCuenta" value="#LB_Cuenta#">
            <cfreportparam name="LBSaldoMonedaOrigen" value="#LB_SaldoMonedaOrigen#">
            <cfreportparam name="LBSaldoMonedaLocal" value="#LB_SaldoMonedaLocal#">
            <cfreportparam name="LBFecha" value="#LB_Fecha#">
            <cfreportparam name="LBDocumento" value="#LB_Documento#">
            <cfreportparam name="LBDescripcion" value="#LB_Descripcion#">
            <cfreportparam name="LBDebito" value="#LB_Debito#">
            <cfreportparam name="LBCredito" value="#LB_Credito#">
            <cfreportparam name="LBTotalDebitoCredito" value="#LB_TotalDebitoCredito#">
            <cfreportparam name="LBSaldoFinalMonedaOrigen" value="#LB_SaldoFinalMonedaOrigen#">
            <cfreportparam name="LBSaldoFinalMonedaLocal" value="#LB_SaldoFinalMonedaLocal#">
            <cfreportparam name="LBMonedaLocal" value="#LB_MonedaLocal#">
            <cfreportparam name="LBMonedaOrigen" value="#LB_MonedaOrigen#">
		</cfif>
		</cfreport>
	<!--- EXCEL --->
	<cfelseif isdefined('rsReporte') and form.formato EQ "excel" and rsReporte.REcordCount GT 0>
	<cfoutput>
		<cf_importLibs>
		<cf_htmlReportsHeaders
			title="" filename="RepBancariosPeriodoMes#session.usucodigo#.xls"
			irA="javascript:history.back();" download="yes" preview="no">
			<cfif isdefined("form.MLmes")>
				<cfset myDate = CreateDate(YEAR(now()), #form.MLmes#, 1)>

				<cfset varMes = #UCASE(LSDATEFORMAT(myDate,'MMMM','es_MX'))#>
			<cfelse>
				<cfset varMes = "Sin definir">
			</cfif>
		<table border="0" cellpadding="0" cellspacing="0" style="width:99%; font-size:12px">
			<tr>
				<td colspan="8" align="center" bgcolor="##E3EDEF" style="color:##6188A5; font-size:24px"><strong>#rsEmpresa.Edescripcion#</strong></td>
			</tr>
			<tr>
				<td colspan="8" align="center" bgcolor="##E3EDEF" style="width:96%;"><strong>#LB_TituloReporte#</strong></td>
			</tr>
			<tr>
				<td colspan="8" align="center" bgcolor="##E3EDEF" style="width:4%;">#LB_Periodo#: #form.MLperiodo#  &nbsp;&nbsp;&nbsp; #LB_Mes#: #varMes#</td>
			</tr>
			<tr>
				<td colspan="8" align="right" bgcolor="##E3EDEF" style="width:4%;">Fecha creaci&oacute;n: #dateformat(now(),'dd/mm/yyyy')#</td>
			</tr>
			<tr>
				<td colspan="8" bgcolor="##E3EDEF">&nbsp;</td>
			</tr>


			<cfset parnon=1>
			<cfset varCBcodigo = "">
			<cfloop query="rsReporte">
				<cfif varCBcodigo NEQ rsReporte.CBcodigo>
					<!--- Encabezado por cuenta --->
					<tr>
						<td colspan="8" align="left" bgcolor="##e6e6e6"><b style="font-size:13px;">MONEDA: #rsReporte.Mnombre#</b></td>
					</tr>
					<tr>
						<td colspan="8" align="left" bgcolor="##e6e6e6"><b style="font-size:16px;">BANCO: #rsReporte.Bdescripcion#</b></td>
					</tr>
					<tr>
						<td colspan="8" align="left" bgcolor="##e6e6e6"><b style="font-size:13px;">#LB_Cuenta#: #trim(rsReporte.Bdescripcion)# - #trim(rsReporte.CBcodigo)#</b></td>
					</tr>

					<tr style="font-weight:bold;padding:2px;font-size: 130%;">
						<td colspan="4">&nbsp;</td>
						<td colspan="2" align="center">Moneda Origen</td>
						<td colspan="2" align="center">Moneda Local</td>
					</tr>
					<tr style="font-weight:bold;padding:2px;font-size: 110%;">
						<td colspan="4">&nbsp;</td>
						<td colspan="2" align="right"> #LB_SaldoMonedaOrigen#: #LSNumberFormat(rsReporte.SaldoInicialO, ",_.__")# </td>
						<td colspan="2" align="right"> #LB_SaldoMonedaLocal#: #LSNumberFormat(rsReporte.SaldoInicialL, ",_.__")# </td>
					</tr>
					<tr bgcolor="##d8d8d8" style="font-weight:bold;padding:2px;">
						<td>&nbsp</td>
						<td align="center">#LB_Fecha#</td>
						<td>#LB_Documento#</td>
						<td>#LB_Descripcion#</td>
						<td align="right">#LB_Debito#</td>
						<td align="right">#LB_Credito#</td>
						<td align="right">#LB_Debito#</td>
						<td align="right">#LB_Credito#</td>
					</tr>
				</cfif>
				<cfset varCBcodigo = #rsReporte.CBcodigo#>
				<tr bgcolor="##<cfif parnon EQ 1 ><cfset parnon=0>ffffff<cfelse><cfset parnon=1>f2f2f2</cfif>">
					<td></td>
					<td align="center">#DateFormat(rsReporte.MLfecha, "dd/mm/yyyy")#</td>
					<td>#rsReporte.MLdocumento#</td>
					<td>#rsReporte.MLdescripcion#</td>
					<td align="right">#LSNumberFormat(rsReporte.DebitoO, ",_.__")#</td>
					<td align="right">#LSNumberFormat(rsReporte.CreditoO, ",_.__")#</td>
					<td align="right">#LSNumberFormat(rsReporte.DebitoL, ",_.__")#</td>
					<td align="right">#LSNumberFormat(rsReporte.CreditoL, ",_.__")#</td>
				</tr>
				<cfif varCBcodigo NEQ rsReporte.CBcodigo[CurrentRow+1]>
					<cfquery name="getTotalesCuenta" dbtype="query">
						SELECT SUM(DebitoO) AS totalCtaDebitoO,
						       SUM(CreditoO) AS totalCtaCreditoO,
						       SUM(DebitoL) AS totalCtaDebitoL,
						       SUM(CreditoL) AS totalCtaCreditoL
						FROM rsReporte
						WHERE CBcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#varCBcodigo#">
					</cfquery>
					<cfif #getTotalesCuenta.recordcount# GT 0>
						<tr bgcolor="##<cfif parnon EQ 1 ><cfset parnon=0>ffffff<cfelse><cfset parnon=1>f2f2f2</cfif>" style="font-weight:bold;padding:2px;">
							<td colspan="4" align="right">&nbsp;Total por cuenta (#varCBcodigo#):&nbsp;</td>
							<td align="right">#LSNumberFormat(getTotalesCuenta.totalCtaDebitoO, ",_.__")#</td>
							<td align="right">#LSNumberFormat(getTotalesCuenta.totalCtaCreditoO, ",_.__")#</td>
							<td align="right">#LSNumberFormat(getTotalesCuenta.totalCtaDebitoL, ",_.__")#</td>
							<td align="right">#LSNumberFormat(getTotalesCuenta.totalCtaCreditoL, ",_.__")#</td>
						</tr>
						<tr style="font-weight:bold;padding:2px;font-size: 110%;">
							<td colspan="8">&nbsp;</td>
						</tr>
					</cfif>
				</cfif>
				<!--- TOTAL FINAL --->
				<cfif rsReporte.RecordCount EQ rsReporte.CurrentRow>
					<cfquery name="getTotalesCuenta" dbtype="query">
						SELECT SUM(DebitoO) AS totalCtaDebitoOF,
						       SUM(CreditoO) AS totalCtaCreditoOF,
						       SUM(DebitoL) AS totalCtaDebitoLF,
						       SUM(CreditoL) AS totalCtaCreditoLF
						FROM rsReporte
					</cfquery>
					<tr bgcolor="##<cfif parnon EQ 1 ><cfset parnon=0>ffffff<cfelse><cfset parnon=1>f2f2f2</cfif>" style="font-weight:bold;padding:2px;">
						<td colspan="4" align="right">&nbsp;Total Final Origen/Local:&nbsp;</td>
						<td align="right">#LSNumberFormat(getTotalesCuenta.totalCtaDebitoOF, ",_.__")#</td>
						<td align="right">#LSNumberFormat(getTotalesCuenta.totalCtaCreditoOF, ",_.__")#</td>
						<td align="right">#LSNumberFormat(getTotalesCuenta.totalCtaDebitoLF, ",_.__")#</td>
						<td align="right">#LSNumberFormat(getTotalesCuenta.totalCtaCreditoLF, ",_.__")#</td>
					</tr>
					<tr style="font-weight:bold;padding:2px;font-size: 110%;">
						<td colspan="8">&nbsp;</td>
					</tr>
				</cfif>
			</cfloop>
		</table>
	</cfoutput>
	<cfelse>
		<table align="center" cellpadding="0" cellspacing="0">
			<tr><td align="center">-----<cfoutput>#MSG_NoHayDatosParaReportar#</cfoutput>-----</td></tr>
		</table>
	</cfif>
<cfelse>
	<table align="center" cellpadding="0" cellspacing="0">
		<tr><td align="center">-----<cfoutput>#MSG_NoHayDatosParaReportar#</cfoutput>-----</td></tr>
	</table>
</cfif>