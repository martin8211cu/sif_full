<cfsetting enablecfoutputonly="yes" showdebugoutput="no" requesttimeout="36000">

<cfsavecontent variable="qryLista">
	<cfoutput>
	select a.AFTFid_dispositivo, a.AFTFcodigo_dispositivo, a.AFTFnombre_dispositivo, a.AFTFserie_dispositivo, a.AFTFestatus_dispositivo, 
	case coalesce((select min(1) from AFTFHojaConteo b where b.AFTFid_dispositivo = a.AFTFid_dispositivo and b.AFTFestatus_hoja < 3),0)
		when 0 then 0
		else 1
	end as AFTFinactivar_permitido
	from AFTFDispositivo a
	where a.CEcodigo = #session.CEcodigo# 
	order by AFTFcodigo_dispositivo
	</cfoutput>
</cfsavecontent>

<!--- Pintado de los botones de regresar, impresión y exportar a excel. --->
<cf_htmlreportsheaders
	irA="aftfDispositivosMoviles-rpt.cfm"
	title="Lista de Dispositivos Móviles" 
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
			<td nowrap>C&oacute;digo&nbsp;</td>
			<td nowrap>Nombre&nbsp;</td>
			<td nowrap>Serie&nbsp;</td>
			<td nowrap>Activo&nbsp;</td>
			<td nowrap>En Hoja Activa&nbsp;</td>
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
			<td nowrap>&nbsp;#AFTFcodigo_dispositivo#</td>
			<td nowrap>&nbsp;#AFTFnombre_dispositivo#</td>
			<td nowrap>&nbsp;#AFTFserie_dispositivo#</td>
			<td nowrap>&nbsp;<cfif AFTFestatus_dispositivo eq 0>No<cfelse>S&iacute;</cfif></td>
			<td nowrap>&nbsp;<cfif AFTFinactivar_permitido eq 0>No<cfelse>S&iacute;</cfif></td>
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

