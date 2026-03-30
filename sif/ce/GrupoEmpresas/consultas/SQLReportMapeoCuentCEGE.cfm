<cfquery name="nivel" datasource="#Session.DSN#">
	SELECT Pvalor FROM Parametros WHERE Pcodigo = 200080 AND Mcodigo = 'CE' AND Ecodigo = #Session.Ecodigo#
</cfquery>
<cfquery name="valOrden" datasource="#Session.DSN#">
	SELECT Pvalor FROM Parametros WHERE Pcodigo = 200081 AND Mcodigo = 'CE' AND Ecodigo = #Session.Ecodigo#
</cfquery>

<cfset lvarValorN = "">
<cfset lvarValorS = "">
<cfif #nivel.Pvalor# neq '-1'>
	<cfset lvarValorN = "AND (select PCDCniv from PCDCatalogoCuenta where Ccuentaniv = cc.Ccuenta GROUP BY PCDCniv ) <= #nivel.Pvalor -1#">
	<cfelse>
	<cfset lvarValorS = "and cc.Cmovimiento = 'S'">
</cfif>

<cfset LvarOrden = ''>
<cfif #valOrden.RecordCount# eq 0>
<cfset LvarOrden = "">
<cfelse>
	<cfif #valOrden.Pvalor# eq 'N'>
		<cfset LvarOrden = " INNER JOIN CtasMayor cm ON cc.Cmayor = cm.Cmayor AND cm.Ctipo <> 'O'  and cm.Ecodigo = cc.Ecodigo">
	</cfif>
</cfif>

<cfquery name="rsReporte" datasource="#session.DSN#">
	SELECT cea.CAgrupador+' - '+cea.Descripcion AS agrupador, cec.CCuentaSAT, cec.NombreCuenta,
    (SELECT COUNT(1) FROM CEMapeoSAT cem
	INNER JOIN CContables cc on cem.Ccuenta = cc.Ccuenta and cem.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	#PreserveSingleQuotes(lvarValorS)# #PreserveSingleQuotes(lvarValorN)#
    #PreserveSingleQuotes(LvarOrden)#
	LEFT JOIN (select distinct Ccuenta from SaldosContables where Ecodigo = #Session.Ecodigo# ) Saldos on Saldos.Ccuenta=cem.Ccuenta
	WHERE cem.CCuentaSAT = cec.CCuentaSAT
    AND cem.CAgrupador = cec.CAgrupador
	and cem.Ecodigo = #Session.Ecodigo#
	and cem.GEid = (SELECT  a.GEid FROM AnexoGEmpresa a
					inner join AnexoGEmpresaDet b
						on a.GEid = b.GEid
					where b.Ecodigo = #Session.Ecodigo#)
	) AS numMapeo, cea.Version
    from CEAgrupadorCuentasSAT cea
    INNER JOIN CECuentasSAT cec ON cec.CAgrupador = cea.CAgrupador
	WHERE cea.CAgrupador = '#Form.CAgrupador#'
		and (cea.Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#"> OR cea.Ecodigo IS NULL)
    ORDER BY cea.CAgrupador,
	CASE
        WHEN ISNUMERIC(cec.CCuentaSAT) = 1 THEN CAST(cec.CCuentaSAT AS FLOAT)
        WHEN ISNUMERIC(LEFT(cec.CCuentaSAT,1)) = 0 THEN ASCII(LEFT(LOWER(cec.CCuentaSAT),1))
        ELSE 2147483647
    END
</cfquery>
<!--- <cfdump var="#rsReporte#"> --->
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

<cfinvoke key="LB_Titulo" default="Mapeo de Cuentas" returnvariable="LB_Titulo" component="sif.Componentes.Translate" method="Translate" xmlfile="SQLReportMapeoCuentCEGE..xml"/>
<cfinvoke key="LB_Codigo" default="C&oacute;digo Cuenta" returnvariable="LB_Codigo" component="sif.Componentes.Translate" method="Translate" xmlfile="SQLReportMapeoCuentCEGE..xml"/>
<cfinvoke key="LB_Cuenta" default="Cuenta" returnvariable="LB_Cuenta" component="sif.Componentes.Translate" method="Translate" xmlfile="SQLReportMapeoCuentCEGE..xml"/>
<cfinvoke key="LB_Mapeadas" default="Mapeadas" returnvariable="LB_Mapeadas" component="sif.Componentes.Translate" method="Translate" xmlfile="SQLReportMapeoCuentCEGE..xml"/>

<cfset Title = "Mapeo de Cuentas">
<cfset FileName = "MapeoCuentas">
<cfset FileName = FileName & Session.Usucodigo & "-" & DateFormat(Now(),'yyyymmdd') & "-" & TimeFormat(Now(),'hhmmss') & ".xls">

<!--- Pinta los botones de regresar, impresión y exportar a excel. --->
<cfset LvarIrA  = 'ReporteMapeoCuentasCEGrupEmp.cfm'>

<cf_htmlreportsheaders title="#Title#" filename="#FileName#.xls" download="yes" ira="#LvarIrA#">

<table style="width:95%" align="center" border="0" cellspacing="0" cellpadding="0">
	<tr>
		<td colspan="8" align="right">

		</td>
	</tr>
	<cfoutput>
	<tr class="area">
		<td  align="center" colspan="8" nowrap class="tituloAlterno"><cfoutput>#Empresas.Edescripcion#</cfoutput></td>
	</tr>
	<tr class="area">
		<td align="center" colspan="8" nowrap><strong>#LB_Titulo#</strong></td>
	</tr>
	<tr>
		<td colspan="8" align="right"><strong><cf_translate key=LB_Fecha>Fecha</cf_translate>: <font color="##006699"><cfoutput>#LSDateFormat(Now(),'DD/MM/YYYY')#</cfoutput></font></strong></td>
	</tr>
    <tr>
		<td colspan="8" class="listaCorte">#rsReporte.agrupador#</td>
	</tr>
    <tr>
		<td colspan="8" class="listaCorte"><cf_translate key=LB_Version>Version</cf_translate>:#rsReporte.Version#</td>
	</tr>
	<tr class="tituloListas">
		<td colspan="2"><strong>#LB_Codigo#</strong></td>
		<td colspan="2"><strong>#LB_Cuenta#</strong></td>
		<td colspan="4"><strong>#LB_Mapeadas#</strong></td>
	</tr>
	</cfoutput>
	<cfflush interval="3">
	<cfoutput query="rsReporte" group="agrupador">
		<cfoutput>
			<tr class="<cfif currentrow mod 2>listaPar<cfelse>listaNon</cfif>">
				<td colspan="2">
					#rsReporte.CCuentaSAT#
				</td>
				<td colspan="2">
					#rsReporte.NombreCuenta#
				</td>
				<td colspan="4">
					#rsReporte.numMapeo#
				</td>
			</tr>
		</cfoutput>
	</cfoutput>
</table>