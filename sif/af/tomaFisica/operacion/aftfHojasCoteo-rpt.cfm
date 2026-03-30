<cfsetting enablecfoutputonly="yes" showdebugoutput="no" requesttimeout="36000">

<cfquery name="rsAFTFHojaConteo" datasource="#session.dsn#">
	select a.AFTFdescripcion_hoja, a.AFTFfecha_hoja
	from AFTFHojaConteo a
	where a.AFTFid_hoja = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.AFTFid_hoja#">
</cfquery>

<cfsavecontent variable="qryLista">
	<cfoutput>
	select a.AFTFid_hoja, a.AFTFdescripcion_hoja, a.AFTFfecha_hoja, a.AFTFfecha_conteo_hoja, 
		case a.AFTFestatus_hoja
			when 0 then 'En Generación de Hoja'
			when 1 then 'En Disposotivo Móvil'
			when 2 then 'En Proceso de Inventario'
			when 3 then 'Aplicada'
			when 9 then 'Cancelada'
		end as AFTFestatus_hoja
	from AFTFHojaConteo a
	where a.CEcodigo = #session.CEcodigo# 
	and a.Ecodigo = #session.Ecodigo# 
	order by AFTFfecha_hoja desc
	</cfoutput>
</cfsavecontent>

<!--- Pintado de los botones de regresar, impresión y exportar a excel. --->
<cf_htmlreportsheaders
	irA="aftfHojasCoteo-rpt.cfm"
	title="Lista de Hojas de Conteo" 
	filename="ListadoDispositivos#Session.Usucodigo#-#DateFormat(Now(),'yyyymmdd')#-#TimeFormat(Now(),'hhmmss')#.xls">

<cfhtmlhead text="
<style type='text/css'>
td {  font-size: xx-small; font-family: Verdana, Arial, Helvetica, sans-serif; font-weight: normal}
a {
	text-decoration: none;
	color: ##000000;
}
.listaNon { background-color:##FFFFFF; vertical-align:middle; padding-left:5px;}
.listaPar { background-color:##FAFAFA; vertical-align:middle; padding-left:5px;}	.tituloSub {  font-weight: bolder; text-align: center; vertical-align: middle; font-size: small; border-color: black black ##CCCCCC; border-style: inset; border-top-width: 0px; border-right-width: 0px; border-bottom-width: 1px; border-left-width: 0px}
.tituloListas {

	font-weight: bolder;
	vertical-align: middle;
	padding: 2px;
	background-color: ##F5F5F5;
}
</style>">

<cfoutput>
	<table width="100%" border="0" cellspacing="0" cellpadding="0">
	  <tr>
		<td nowrap class="tituloSub" align="center">Lista de Dispositivos Móviles</td>
	  </tr>
	</table>
	<table width="100%" border="0" cellspacing="0" cellpadding="0">
		<tr class="tituloListas">
			<td nowrap>Descripci&oacute;n&nbsp;</td>
			<td nowrap>Fecha&nbsp;</td>
			<td nowrap>Fecha Cierre&nbsp;</td>
			<td nowrap>Condici&oacute;n&nbsp;</td>
		</tr>
</cfoutput>

<cftry>
	<!--- Empieza a pintar el reporte en el usuario cada 512 bytes los bytes que toma en cuenta son de aquí en adelante omitiendo lo que hay antes, y la informació de los headers de la cantidad de bytes --->
	<cfflush interval="512">
	<cf_jdbcquery_open name="rsLista" datasource="#session.DSN#">
		<cfoutput>#qryLista#</cfoutput>
	</cf_jdbcquery_open>
	<cfset class  = "">
	<cfoutput query="rsLista">
		<cfif class neq "listaNon">
			<cfset class = "listaNon">
		<cfelse>
			<cfset class = "listaPar">
		</cfif>
		<tr class="#class#">
			<td nowrap>&nbsp;#AFTFdescripcion_hoja#</td>
			<td nowrap>&nbsp;#LSDateFormat(AFTFfecha_hoja,'dd/mm/yyyyy')#</td>
			<td nowrap>&nbsp;#LSDateFormat(AFTFfecha_conteo_hoja,'dd/mm/yyyyy')#</td>
			<td nowrap>&nbsp;#AFTFestatus_hoja#</td>
		</tr>
	</cfoutput>
	<cfcatch type="any">
		<cf_jdbcquery_close>
		<cfrethrow>
	</cfcatch>
</cftry>
<cf_jdbcquery_close>

<cfoutput>
	</table>
	<table width="100%" border="0" cellspacing="0" cellpadding="0">
	  <tr>
		<td nowrap align="center"><strong>--Fin de la Lista--</strong></td>
	  </tr>
	</table>
</cfoutput>

