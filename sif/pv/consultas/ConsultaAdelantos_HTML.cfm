
<cfinvoke component="sif.Componentes.Translate" method="init" returnvariable="t" />

<cfset LvarFileName = "Consulta_Adelantos#Session.Usucodigo#-#DateFormat(Now(),'yyyymmdd')#-#TimeFormat(Now(),'hhmmss')#.xls">

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
				title="Consulta de Adelantos y Notas de Cr&eacute;dito Generadas" 
				filename="#LvarFileName#" 
				ira="ConsultaAdelantos.cfm">
		</td>
	</tr>
</table>
<cfflush interval="64">
<table cellpadding="0" cellspacing="0" border="0" width="100%">
	<tr>
		<td colspan="1" style="width:10%"> <cfoutput>#DateFormat(Now(),'dd-mm-yyyy')#</cfoutput></td>
		<td colspan="8" align="center" style="font-size:18px"><cfoutput>#HTMLEditFormat(session.Enombre)#</cfoutput></td>
		<td align="right"><cfoutput>#TimeFormat(Now(), 'HH:mm:ss')#</cfoutput></td>
	</tr>
	<tr>
		<td colspan="1">&nbsp;</td>
		<td colspan="8" align="center" style="font-size:16px">Consulta de Adelantos y Notas de Cr&eacute;dito Generadas</td>
		<td>&nbsp;</td>
	</tr>
	<tr>
		<td colspan="1">&nbsp;&nbsp;</td>
		<td colspan="8" align="center" style="font-size:12px">&nbsp;</td>
		<td>&nbsp;</td>
	</tr>
	
	<cfset LvarTotalLinea = 0>
	<cfset LvarAplicado = 0>
	<cfset LvarSaldo = 0>
	
	<cfoutput query="rsReporte" group="agrupador">
	<cfset LvarTotalLinea = 0>
	<cfset LvarAplicado = 0>
	<cfset LvarSaldo = 0>
	<tr bgcolor="##f0f0f0">
		<td colspan="10" style="width:25%" nowrap="nowrap">
			#Cliente#&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Moneda: #CodigoMoneda#
		</td>
	</tr>
	<tr bgcolor="##f0f0f0">
		<td>No.</td>
		<td>Documento</td>
		<td>Tipo Doc.</td>
		<td>Fecha</td>
		<td>Oficina</td>
		<td>Caja</td>
		<td align="right">Transacci&oacute;n</td>
		<td align="right">Monto</td>
		<td align="right">Aplicado</td>
		<td align="right">Saldo</td>
	</tr>
	
	<cfoutput>
		<tr>
			<td >
				#numberformat(Consecutivo,",9")#
			</td>
		
			<td >
				#Documento#
			</td>
			<td >
				#TipoDoc#
			</td>
			<td >
				#DateFormat(FechaFactura,'DD/MM/YYYY')#
			</td>
			<td >
				#Oficina#
			</td>
			<td >
				#CodigoCaja#
			</td>
			<td align="right">
				#numberformat(NoTransaccion,",9")#
			</td>
			<td align="right">
				#NumberFormat(TotalLinea, ",_.__")#
			</td>
			<td align="right">
				#NumberFormat(Aplicado, ",_.__")#
			</td>
			<td align="right">
				#NumberFormat(Saldo, ",_.__")#
			</td>
		</tr>
		<cfset LvarTotalLinea = LvarTotalLinea + TotalLinea>
		<cfset LvarAplicado = LvarAplicado + Aplicado>
		<cfset LvarSaldo = LvarSaldo + Saldo>
	</cfoutput>
		<tr>
			<td>&nbsp;</td>
		</tr>
		<tr>
			<td colspan="7" align="left"><strong>Totales</strong></td>
			<td align="right"><strong>#NumberFormat(LvarTotalLinea, ",_.__")#</strong></td>
			<td align="right"><strong>#NumberFormat(LvarAplicado, ",_.__")#</strong></td>
			<td align="right"><strong>#NumberFormat(LvarSaldo, ",_.__")#</strong></td>
		</tr>

</cfoutput>