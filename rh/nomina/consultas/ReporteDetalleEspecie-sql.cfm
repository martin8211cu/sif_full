<!--- VARIABLES DE TRADUCCION --->
<cfinvoke key="LB_ReporteDeValesDespensa" default="Reporte de Vales de Despensa" returnvariable="LB_ReporteDeValesDespensa" component="sif.Componentes.Translate" method="Translate"/>

<!--- FIN VARIABLES DE TRADUCCION --->
<cfif isdefined('url.CPid') and LEN(TRIM(url.CPid))>
	<cfset CPid = url.CPid>
	<cfset CPcodigo = url.CPcodigo>
	<cfset Tcodigo = url.Tcodigo>
</cfif>

<cf_dbfunction name="op_concat" returnvariable="LvarCNCT">
<cfquery name="rsReporte" datasource="#session.DSN#">
	select b.DEid,b.DEidentificacion, 
		case when b.DEdato3 is null  then 'INDEFINIDO'
		else b.DEdato3
		end as Nombre, 
		case when b.DEcuenta is null then 'INDEFINIDO'
		else b.DEcuenta
		end CuentaVales,coalesce(SEespecie,0) as TotalEspecie
	from HSalarioEmpleado a
		inner join DatosEmpleado b on b.DEid = a.DEid
	where a.RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#CPid#">
		and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		and coalesce(SEespecie,0) > 0
	order by DEidentificacion
</cfquery>

<cfquery dbtype="query" name="rsTotalVales">
	select sum(TotalEspecie) as TotalGeneral
    from rsReporte
</cfquery>
<!---<cf_dump var = "#rsReporte#">--->

<!--- Busca el nombre de la Empresa --->
<cfquery name="rsEmpresa" datasource="#session.DSN#">
	select Edescripcion
	from Empresas
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
</cfquery>

<!--- Datos de la nomina --->
<cfquery name="rsNomina" datasource="#session.DSN#">
	select CPhasta, CPdesde, CPfpago,CPdescripcion,CPperiodo,CPmes,
	case when CPtipo = 0 then 'Normal'
		 when CPtipo = 2 then 'Anticipo' end as TipoCalendario, Tdescripcion,
		 RCDescripcion as Descripcion
	from CalendarioPagos a
		inner join TiposNomina b
			on b.Ecodigo = a.Ecodigo 
			and b.Tcodigo = a.Tcodigo
	inner join HRCalculoNomina c
		on c.Ecodigo = a.Ecodigo
		and c.RCNid = a.CPid
	where CPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#CPid#">
</cfquery>

<style>
	h1.corte {
		PAGE-BREAK-AFTER: always;}
	.tituloAlterno {
		font-size:16px;
		font-weight:bold;
		text-align:center;}
	.titulo_empresa2 {
		font-size:18px;
		font-weight:bold;
		text-align:center;}
	.titulo_reporte {
		font-size:12px;
		font-style:italic;
		text-align:center;}
	.titulo_filtro {
		font-size:10px;
		font-style:italic;
		text-align:center;}
	.titulolistas {
		font-size:10px;
		font-weight:bold;
		background-color:#CCCCCC;
		}
	.titulo_columnar {
		font-size:14px;
		font-weight:bold;
		background-color:#CCCCCC;
		text-align:right;}
	.listaCorte {
		font-size:10px;
		font-weight:bold;
		background-color:#CCCCCC;
		text-align:left;}
	.total {
		font-size:14px;
		font-weight:bold;
		background-color:#C5C5C5;
		text-align:right;}

	.detalle {
		font-size:14px;
		text-align:left;}
	.detaller {
		font-size:14px;
		text-align:right;}
	.detallec {
		font-size:14px;
		text-align:center;}	
		
	.mensaje {
		font-size:10px;
		text-align:center;}
	.paginacion {
		font-size:10px;
		text-align:center;}
</style>

<cf_htmlReportsHeaders irA="ReporteDetalleEspecie.cfm"
FileName="Reporte_detalle_Planilla.xls"
title="#LB_ReporteDeValesDespensa#">
<table width="700" align="center" border="0" cellspacing="2" cellpadding="0">
    <cfoutput>
    <tr><td align="center" colspan="4" class="titulo_empresa2"><strong>#rsEmpresa.Edescripcion#</strong></td></tr>
    <tr><td align="center" colspan="4" class="titulo_empresa2"><strong>#LB_ReporteDeValesDespensa#</strong></td></tr>
    <tr><td colspan="4">&nbsp;</td></tr>
    <tr>
        <td align="center" colspan="4">
            <table width="550" align="center" border="0" cellspacing="2" cellpadding="0">
                <tr><td class="detalle" colspan="2"><strong>#rsNomina.Descripcion#</strong></td></tr>
                <tr>
                    <td class="detalle"><strong><cf_translate key="LB_TipoDeNomina">Tipo de N&oacute;mina</cf_translate>: #rsNomina.Tdescripcion#</strong></td>
                    <td class="detalle"><strong><cf_translate key="LB_FechaRige">Fecha Rige</cf_translate>: #LSDateFormat(rsNomina.CPdesde,'dd/mm/yyyy')# <cf_translate key="LB_FechaHasta">Fecha Hasta</cf_translate>: #LSDateFormat(rsNomina.CPhasta,'dd/mm/yyyy')# </strong></td>
                </tr>
                <tr>
                     <td class="detalle"><strong><cf_translate key="LB_Periodo">Per&iacute;odo</cf_translate>: #rsNomina.CPperiodo# - #rsNomina.CPmes#</strong></td>
                    <td class="detalle"><strong><cf_translate key="LB_TipoDeCalendario">Tipo de Calendario</cf_translate>: #rsNomina.TipoCalendario#</strong></td>
                </tr>
            </table>
        </td>
    </tr>
    <tr><td colspan="4">&nbsp;</td></tr>
    <tr class="titulo_columnar">
    	<td align="center" width="30"><cf_translate key="LB_DEidentificacion">Identificaci&oacute;n</cf_translate></td>
        <td align="center" width="250"><cf_translate key="LB_Nombre">Nombre de Tarjeta Titular</cf_translate></td>
        <td align="center" width="150"><cf_translate key="LB_Cuenta">Numero de Tarjeta Titular</cf_translate></td>
        <td align="right" width="100"><cf_translate key="LB_TotalAPagar">Total a Pagar</cf_translate>&nbsp;</td>
    </tr>
    </cfoutput>

    <cfloop query="rsReporte">      
        <cfoutput>
            <tr>
                <td class="detalle">#DEidentificacion#</td>
                <td class="detalle">#Nombre#</td>
                <td class="detallec">#CuentaVales#</td>
                <td class="detaller">#LSCurrencyFormat(rsReporte.TotalEspecie,'none')#</td>
            </tr>
         </cfoutput>
    </cfloop>
    <tr>
        <td class="total" colspan="3"><cf_translate key="LB_TotalGeneral">Total General</cf_translate>&nbsp;</td>
        <td class="total"><cfoutput>#LSCurrencyFormat(rsTotalVales.TotalGeneral, 'none')# </cfoutput></td>
    </tr>
</table>
