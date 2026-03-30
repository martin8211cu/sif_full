<cfquery name="rsSalarioEmpleado" datasource="#Session.DSN#">
	select 	SEsalariobruto, SEincidencias, SErenta, SEcargasempleado, 
			SEcargaspatrono,  SEdeducciones, SEliquido
	from SalarioEmpleado 
	where RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RCNid#">
	and DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.DEid#">
</cfquery>
<cfoutput>
<cfinvoke component="rh.Componentes.RHParametros" method="get" datasource="#Session.DSN#" ecodigo="#session.Ecodigo#" pvalor="785" default="0" returnvariable="UnificaSalarioB"/>

	<cfif rsSalarioEmpleado.RecordCount gt 0 >
		<tr> 
			<td nowrap class="FileLabel" align="right">Salario Bruto:&nbsp;</td>
		  	<cfif not UnificaSalarioB><td nowrap class="FileLabel" align="right">Incidencias:&nbsp;</td></cfif>
		  	<td nowrap class="FileLabel" align="right">Renta:&nbsp;</td>
		  	<td nowrap class="FileLabel" align="right">Cargas Empleado:&nbsp;</td>
		  	<td nowrap class="FileLabel" align="right">Deducciones:&nbsp;</td>
		  	<td nowrap class="FileLabel" align="right">Salario Líquido:&nbsp;</td>
		</tr>
		<tr>
		  <td nowrap align="right">#rsMoneda.Msimbolo# <cfif not UnificaSalarioB>#LSCurrencyFormat(rsSalarioEmpleado.SEsalariobruto,'none')#<cfelse>#LSCurrencyFormat(rsSalarioEmpleado.SEsalariobruto+rsSalarioEmpleado.SEincidencias,'none')#</cfif></td>
		  <cfif not UnificaSalarioB><td nowrap align="right">#rsMoneda.Msimbolo# #LSCurrencyFormat(rsSalarioEmpleado.SEincidencias,'none')#</td></cfif>
		  <td nowrap align="right">#rsMoneda.Msimbolo# #LSCurrencyFormat(rsSalarioEmpleado.SErenta,'none')#</td>
		  <td nowrap align="right">#rsMoneda.Msimbolo# #LSCurrencyFormat(rsSalarioEmpleado.SEcargasempleado,'none')#</td>
		  <td nowrap align="right">#rsMoneda.Msimbolo# #LSCurrencyFormat(rsSalarioEmpleado.SEdeducciones,'none')#</td>
		  <td nowrap align="right">#rsMoneda.Msimbolo# #LSCurrencyFormat(rsSalarioEmpleado.SEliquido,'none')#</td>
		</tr>
	<cfelse>
		<tr><td colspan="6" align="center">No hay Pagos asociados al empleado</td></tr>
	</cfif>	
</cfoutput>