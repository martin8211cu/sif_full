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

<cfquery name="EmpList" datasource="#Session.DSN#">
	SELECT
		ROW_NUMBER() OVER(ORDER BY Cformato) AS Row,
 		Cformato,
		Cdescripcion
	FROM
		CEInactivas
	WHERE Ecodigo = #Session.Ecodigo#
	<cfif #form.cmayor_ccuenta1# NEQ "">
		AND Cformato >= <cfqueryparam value="#form.cmayor_ccuenta1#" cfsqltype="cf_sql_Varchar">
	</cfif>
	<cfif #form.cmayor_ccuenta2# NEQ "">
		AND (Cformato <= '#form.cmayor_ccuenta2#'
		or Cformato like '#form.cmayor_ccuenta2#%')
	</cfif>
	ORDER BY Cformato
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


<cfinvoke key="LB_Titulo" default="Cuentas Excluidas" returnvariable="LB_Titulo" component="sif.Componentes.Translate" method="Translate" xmlfile="SQLCuentasExcluidas.xml"/>
<cfinvoke key="LB_Formato" default="Formato" returnvariable="LB_Formato" component="sif.Componentes.Translate" method="Translate" xmlfile="SQLCuentasExcluidas.xml"/>
<cfinvoke key="LB_Descripcion" default="Descripcion" returnvariable="LB_Descripcion" component="sif.Componentes.Translate" method="Translate" xmlfile="SQLCuentasExcluidas.xml"/>

<cfset Title = "Cuentas Excluidas">
<cfset FileName = "CuentasExcluidas">
<cfset FileName = FileName & Session.Usucodigo & "-" & DateFormat(Now(),'yyyymmdd') & "-" & TimeFormat(Now(),'hhmmss') & ".xls">

<!--- Pinta los botones de regresar, impresión y exportar a excel. --->
<cfset LvarIrA  = 'ReporteMapeoCuentasCE.cfm'>

<cf_htmlreportsheaders title="#Title#" filename="#FileName#.xls" download="yes" ira="#LvarIrA#">
	<!--- <cf_dump var ="#EmpList#"> --->
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
		<td colspan="8" class="listaCorte"></td>
	</tr>
    <tr class="tituloListas">
		<td colspan="2"><strong>L&iacute;nea</strong></td>
		<td colspan="2"><strong>#LB_Formato#</strong></td>
		<td colspan="4"><strong>#LB_Descripcion#</strong></td>
	</tr>
	</cfoutput>
	<!--- <cfflush interval="3"> Demora demasiado con esta etiqueta--->
	<cfoutput query="EmpList">
			<tr class="<cfif currentrow mod 2>listaPar<cfelse>listaNon</cfif>">
				<td colspan="2">
					#EmpList.Row#
				</td>
				<td colspan="2">
					#EmpList.Cformato#
				</td>
				<td colspan="4">
					#EmpList.Cdescripcion#
				</td>
			</tr>
	</cfoutput>
</table>