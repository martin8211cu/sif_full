<cfinvoke component="sif.Componentes.Translate" method="init" returnvariable="t" />
<cfset LvarFileName = "Consulta_Cajas#Session.Usucodigo#-#DateFormat(Now(),'yyyymmdd')#-#TimeFormat(Now(),'hhmmss')#.xls">
<style type="text/css">
	* { font-size:11px; font-family:Verdana, Arial, Helvetica, sans-serif }
	.niv1 { font-size: 18px; }
	.niv2 { font-size: 16px; }
	.niv3 { font-size: 12px; }
	.niv4 { font-size: 10px; }
</style>	
<table cellpadding="0" cellspacing="0" border="0" width="100%">
	<tr>
		<td colspan="8" align="right" style="width:100%">
			<cf_htmlreportsheaders
				title="Consulta de Cajas Pendientes de Cierre" 
				filename="#LvarFileName#" 
				ira="ConsultaCajasPendientes.cfm">
		</td>
	</tr>
</table>
<cfflush interval="256">
<table cellpadding="0" cellspacing="0" border="0" width="100%">
	<tr bgcolor="#99CCFF">
		<td colspan="2" style="width:10%"> <cfoutput>#DateFormat(Now(),'dd-mm-yyyy')#</cfoutput></td>
		<td colspan="4" align="center" style="font-size:18px"><cfoutput>#HTMLEditFormat(session.Enombre)#</cfoutput></td>
		<td colspan="2" align="right"  style="width:10%"><cfoutput>#TimeFormat(Now(), 'HH:mm:ss')#</cfoutput></td>
	</tr>
	<tr bgcolor="#99CCFF">
		<td colspan="8" align="center" style="font-size:18px"><strong>Consulta de Cajas Pendientes de Cierre</strong></td>
	</tr>
	<tr bgcolor="#99CCFF">
		<td colspan="8">&nbsp</td>
	</tr>
	<cfif rsDatos.recordcount LT 1>
		<tr>
			<td colspan="8" align="center"><strong>No se Encontraron Cajas Pendientes de Cierre</strong></td>
		</tr>
	<cfelse>
		<tr bgcolor="#99CCFF">
			<td colspan="8">&nbsp;</td>
		</tr>
		<tr bgcolor="#99CCFF">
			<td>&nbsp;</td>
			<td><strong>Código Caja</strong></td>
			<td><strong>Nombre</strong></td>
			<td><strong>Responsable</strong></td>
			<td><strong>Fecha Primer Transaccion</strong></td>
			<td><strong>Fecha Ultima Transaccion</strong></td>
			<td>&nbsp;</td>
			<td>&nbsp;</td>
		</tr>
		<tr>
			<td colspan="8">&nbsp;</td>
		</tr>
		<cfoutput query="rsDatos">
			<tr>
				<td>&nbsp;</td>
				<td>#CodigoCaja#</td>
				<td>#DescripcionCaja#</td>
				<td>#ResponsableCaja#</td>
				<td>#DateFormat(TransaccionesDesde,'DD/MM/YYYY')#</td>
				<td>#DateFormat(TransaccionesHasta,'DD/MM/YYYY')#</td>
				<td >&nbsp;</td>
				<td >&nbsp;</td>
			</tr>
		</cfoutput>
		<tr><td colspan="8">&nbsp;</td></tr>
		<tr><td colspan="8" align="center">---- FIN DE CONSULTA ---</td></tr>
	</cfif>
</table>
