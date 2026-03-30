<cfquery name="rsReporte" datasource="#session.DSN#">
	SELECT cea.CAgrupador+' - '+cea.Descripcion AS agrupador, cexd.CodAgrup, cec.NombreCuenta, cexd.NumCta, cexd.Descripcion, cexe.Mes, cexe.Anio, cexe.Status
    FROM CEXMLEncabezadoCuentas cexe
    INNER JOIN CEAgrupadorCuentasSAT cea ON cea.CAgrupador = cexe.CAgrupador
    INNER JOIN CEXMLDetalleCuentas cexd ON cexd.Id_XMLEnc = cexe.Id_XMLEnc
    INNER JOIN CECuentasSAT cec ON cec.CAgrupador = cea.CAgrupador AND cec.CCuentaSAT = cexd.CodAgrup
    WHERE cexe.GEid = -1 AND cexe.CAgrupador = '#Form.CAgrupador#' and cexe.Version = '#Form.Version#' and cexe.Mes = '#Form.Mes#'  AND cexe.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
    ORDER BY cea.CAgrupador,cec.CCuentaSAT,cexd.NumCta
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
<cfset LvarIrA  = 'ConsultarXMLCuentasCE.cfm?modo=NUEVO'>

<cf_htmlreportsheaders title="#Title#" filename="#FileName#.xls" download="yes" ira="#LvarIrA#">

<table style="width:95%" align="center" border="0" cellspacing="0" cellpadding="2">
	<tr>
		<td colspan="8" align="right">

		</td>
	</tr>
	<tr class="area">
		<td  align="center" colspan="8" nowrap class="tituloAlterno"><cfoutput>#Empresas.Edescripcion#</cfoutput></td>
	</tr>
	<tr class="area">
		<td align="center" colspan="8" nowrap><strong><cf_translate key=LB_Titulo>Consulta de XML de Mapeo SAT preparado o generado</cf_translate></strong></td>
	</tr>
	<tr>
		<td colspan="8" align="right"><strong><cf_translate key=LB_Fecha>Fecha</cf_translate>: <font color="##006699"><cfoutput>#LSDateFormat(Now(),'DD/MM/YYYY')#</cfoutput></font></strong></td>
	</tr>
	</table>
	<cfflush interval="512">
	<cfoutput query="rsReporte" group="agrupador">
	<table style="width:95%" align="center" border="0" cellspacing="0" cellpadding="2">
		<tr>
			<td align="right" width="50%">Mapeo:</td>
			<td align="lefet"><strong>#rsReporte.agrupador#</strong></td>
		</tr>
		<tr>
			<td align="right" >Estatus:</td>
			<td align="lefet" ><strong>#rsReporte.Status#</strong></td>
		</tr>
		<tr>
			<td align="right" >Periodo:</td>
			<td align="lefet" ><strong>#rsReporte.Anio#</strong></td>
		</tr>
		<tr>
			<td align="right" >Mes:</td>
			<td align="lefet" ><strong>#rsReporte.Mes#</strong></td>
		</tr>
        </table>
        <table  style="width:95%" align="center" border="0" cellspacing="0" cellpadding="2">
		<tr class="listaCorte">
			<td ><strong><cf_translate key=LB_Codigo>C&oacute;digo</cf_translate></strong></td>
			<td colspan="7"><strong><cf_translate key=LB_Descripcion>Descripci&oacute;n</cf_translate></strong></td>
		</tr>


		<cfset LvarCuentaControl = "">
		<cfoutput>

			<cfif LvarCuentaControl NEQ rsReporte.CodAgrup>
				<tr class="listaCorte">
				<td>
					#rsReporte.CodAgrup#
				</td>
				<td colspan="7">
					#rsReporte.NombreCuenta#
				</td>
				</tr>
				<cfset LvarCuentaControl = rsReporte.CodAgrup>
				<cfif #rsReporte.NumCta# neq ''>
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
				<cfif #rsReporte.NumCta# neq ''>


				<td colspan="1">&nbsp;

				</td>
				<td colspan="3">
					#rsReporte.NumCta#
				</td>
				<td colspan="4">
					#rsReporte.Descripcion#
				</td>
				<cfelse>
				<td colspan="7">Sin cuentas</td>
				</cfif>
			</tr>

		</cfoutput>
	</cfoutput>
</table>