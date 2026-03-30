<cfquery name="nivel" datasource="#Session.DSN#">
	SELECT Pvalor FROM Parametros WHERE Pcodigo = 200080 AND Mcodigo = 'CE' AND Ecodigo = #Session.Ecodigo#
</cfquery>
<cfquery name="valOrden" datasource="#Session.DSN#">
	SELECT Pvalor FROM Parametros WHERE Pcodigo = 200081 AND Mcodigo = 'CE' AND Ecodigo = #Session.Ecodigo#
</cfquery>

<cfset lvarValorN = "">
<cfset lvarValorS = "">
<cfif #nivel.Pvalor# neq '-1'>
	<cfset lvarValorN = "AND  (select PCDCniv from PCDCatalogoCuenta where Ccuentaniv = cem.Ccuenta GROUP BY PCDCniv ) <= #nivel.Pvalor -1#">
	<cfelse>
	<cfset lvarValorS = "and cc.Cmovimiento = 'S'">
</cfif>

<cfset LvarOrden = ''>
<cfif #valOrden.RecordCount# eq 0>
<cfset LvarOrden = "">
<cfelse>
	<cfif #valOrden.Pvalor# eq 'N'>
		<cfset LvarOrden = " inner JOIN CtasMayor cm ON cco.Cmayor = cm.Cmayor AND cm.Ctipo <> 'O'  and cm.Ecodigo = cco.Ecodigo">
	</cfif>
</cfif>

<cfquery name="rsReporte" datasource="#session.DSN#">
	SELECT cea.CAgrupador+' - '+cea.Descripcion AS agrupador, cec.CCuentaSAT, cec.NombreCuenta,
    	cco.Cformato, cco.Cdescripcion,cea.Version
    from CEAgrupadorCuentasSAT cea
    INNER JOIN CECuentasSAT cec ON cec.CAgrupador = cea.CAgrupador
    LEFT JOIN CEMapeoSAT cem ON cem.CCuentaSAT = cec.CCuentaSAT AND cem.CAgrupador = cec.CAgrupador
	LEFT JOIN (select distinct Ccuenta from SaldosContables where Ecodigo = #Session.Ecodigo# ) Saldos on Saldos.Ccuenta=cem.Ccuenta
    LEFT JOIN CContables cco ON cco.Ccuenta = cem.Ccuenta
	#PreserveSingleQuotes(LvarOrden)#
	WHERE cem.Ecodigo = #Session.Ecodigo# and cea.CAgrupador = '#Form.CAgrupador#' AND (cea.Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#"> OR cea.Ecodigo IS NULL)
   #PreserveSingleQuotes(lvarValorN)#
	ORDER BY cea.CAgrupador,
	CASE
        WHEN ISNUMERIC(cec.CCuentaSAT) = 1 THEN CAST(cec.CCuentaSAT AS FLOAT)
        WHEN ISNUMERIC(LEFT(cec.CCuentaSAT,1)) = 0 THEN ASCII(LEFT(LOWER(cec.CCuentaSAT),1))
        ELSE 2147483647
    END
	,cco.Cformato
</cfquery>

<cfquery name="Empresas" datasource="#Session.DSN#">
	select
		Ecodigo,
		Edescripcion
	from Empresas
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
</cfquery>

<cfhtmlhead text="
<style type='text/css'>
td {  font-size: 11px; font-family: Verdana, Arial, Helvetica, sans-serif; font-weight: normal}
a {
	text-decoration: none;
	color: ##000000;
}
.listaCorte { font-size: 11px; font-weight:bold; background-color:##CCCCCC; text-align:left;}
.listaNon { background-color:##FFFFFF; vertical-align:middle; padding-left:5px;}
.listaPar { background-color:##FAFAFA; vertical-align:middle; padding-left:5px;}
.tituloSub { background-color:##FFFFFF; font-weight: bolder; text-align: center; vertical-align: middle; font-size: smaller; border-color: black black ##CCCCCC; border-style: inset; border-top-width: 0px; border-right-width: 0px; border-bottom-width: 1px; border-left-width: 0px}
.tituloListas {

	font-weight: bolder;
	vertical-align: middle;
	padding: 5px;
	background-color: ##F5F5F5;
}
</style>">
<cfset Title = "Detalle de Cuentas Mapeadas">
			<cfset FileName = "MapeoCuentasDET">
			<cfset FileName = FileName & Session.Usucodigo & "-" & DateFormat(Now(),'yyyymmdd') & "-" & TimeFormat(Now(),'hhmmss') & ".xls">
			<!--- Pinta los botones de regresar, impresión y exportar a excel. --->
			<cfset LvarIrA  = 'ReporteMapeoCuentasCE.cfm'>
<cf_htmlreportsheaders
				title="#Title#"
				filename="#FileName#.xls"
				download="yes"
				ira="#LvarIrA#">
<table style="width:95%" align="center" border="0" cellspacing="0" cellpadding="2">
	<tr>
		<td colspan="8" align="right">

		</td>
	</tr>
	<tr class="area">
		<td  align="center" colspan="8" nowrap class="tituloAlterno"><cfoutput>#Empresas.Edescripcion#</cfoutput></td>
	</tr>
	<tr class="area">
		<td align="center" colspan="8" nowrap><strong><cf_translate key=LB_Titulo>Detalle de Cuentas Mapeadas</cf_translate></strong></td>
	</tr>
	<tr>
		<td colspan="8" align="right"><strong><cf_translate key=LB_Fecha>Fecha</cf_translate>: <font color="##006699"><cfoutput>#LSDateFormat(Now(),'DD/MM/YYYY')#</cfoutput></font></strong></td>
	</tr>
	<cfflush interval="512">
	<cfoutput query="rsReporte" group="agrupador">
		<tr>
			<td colspan="8">&nbsp;</td>
		</tr>
		<tr>
			<td colspan="8" align="center"><strong>#rsReporte.agrupador#</strong></td>
		</tr>
        <tr>
			<td colspan="8" align="center"><strong><cf_translate key=LB_Version>Version</cf_translate>: #rsReporte.Version#</strong></td>
		</tr>
		<tr class="listaCorte">
			<td ><strong><cf_translate key=LB_Codigo>C&oacute;digo</cf_translate></strong></td>
			<td colspan="7"><strong><cf_translate key=LB_Descripcion>Descripci&oacute;n</cf_translate></strong></td>
		</tr>
		<cfset LvarCuentaControl = "">
		<cfoutput>

			<cfif LvarCuentaControl NEQ rsReporte.CCuentaSAT>
				<tr class="listaCorte">
				<td>
					#rsReporte.CCuentaSAT#
				</td>
				<td colspan="7">
					#rsReporte.NombreCuenta#
				</td>
				</tr>
				<cfset LvarCuentaControl = rsReporte.CCuentaSAT>
				<cfif #rsReporte.Cformato# neq ''>
				<tr>
				<td colspan="1">&nbsp;

				</td>
				<td colspan="3">
					<strong><cf_translate key=LB_Cuenta>Cuenta</cf_translate></strong>
				</td>
				<td colspan="4">
					<strong><cf_translate key=LB_Nombre>Nombre</cf_translate></strong>
				</td>
				</tr>
				</cfif>
			</cfif>
			<tr class="<cfif currentrow mod 2>listaPar<cfelse>listaNon</cfif>">
				<cfif #rsReporte.Cformato# neq ''>


				<td colspan="1">&nbsp;

				</td>
				<td colspan="3">
					#rsReporte.Cformato#
				</td>
				<td colspan="4">
					#rsReporte.Cdescripcion#
				</td>
				<cfelse>
				<td colspan="7">Sin cuentas</td>
				</cfif>
			</tr>

		</cfoutput>
	</cfoutput>
</table>