<cfsetting enablecfoutputonly="yes" showdebugoutput="no" requesttimeout="36000">
	<cfsavecontent variable="qryLista">
		<cfoutput>
		select 
			a.QPidLote, 
			a.QPLcodigo, 
			a.QPLdescripcion, 
			a.QPLfechaProduccion, 
			a.QPLfechaFinVigencia, 
			BMfecha,
			BMUsucodigo 
		from QPassLote a
		where a.Ecodigo = #session.Ecodigo# 
		order by QPLcodigo
		</cfoutput>
	</cfsavecontent>

<!--- Pintado de los botones de regresar, impresión y exportar a excel. --->
<cf_htmlreportsheaders
	irA=""
	title="Lista de Lotes" 
	back = "no"
	close= "yes"
	filename="ListadoLotes#Session.Usucodigo#-#DateFormat(Now(),'yyyymmdd')#-#TimeFormat(Now(),'hhmmss')#.xls">

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
		<td nowrap class="tituloSub" align="center">Lista de Lotes</td>
	  </tr>
	</table>
	<table width="100%" border="0" cellspacing="0" cellpadding="0">
		<tr class="tituloListas">
			<td nowrap>C&oacute;digo&nbsp;</td>
			<td nowrap>Descripci&oacute;n</td>
			<td nowrap>Fecha Producci&oacute;n</td>
			<td nowrap>Fecha Vigencia</td>
		</tr>
</cfoutput>

<cftry>
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
			<td nowrap>&nbsp;#QPLcodigo#</td>
			<td nowrap>&nbsp;#QPLdescripcion#</td>
			<td nowrap>&nbsp;#LSDateFormat(QPLfechaProduccion, 'dd/mm/yyyy')#</td>
			<td nowrap>&nbsp;#LSDateFormat(QPLfechaFinVigencia, 'dd/mm/yyyy')#</td>
		</tr>
	</cfoutput>
	<cfcatch type="any">
		<cf_jdbcquery_close>
		<cfthrow object="#cfcatch#">
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