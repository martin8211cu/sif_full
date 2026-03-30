<cfquery name="rsDeduccionesCalculo" datasource="#Session.DSN#">
	select a.Did, a.DCvalor, a.DCinteres, a.DCcalculo, b.Ddescripcion, b.Dvalor, b.Dmetodo
	from DeduccionesCalculo a, DeduccionesEmpleado b
	where a.RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RCNid#">
	and a.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.DEid#">
	and a.Did = b.Did
</cfquery>

	<tr>
		<td colspan="10" class="tituloAlterno2">Deducciones</td>
	</tr>

	<cfif rsDeduccionesCalculo.RecordCount gt 0 >
		<tr>
			<td align="left" class="FileLabel" colspan="6">Descripci&oacute;n</td>
			<td align="right" class="FileLabel">Valor</td>
			<td align="right" class="FileLabel">Monto</td>
			<td align="right" class="FileLabel">&nbsp;</td>
		</tr>
	
			<cfoutput query="rsDeduccionesCalculo">
				<tr class=<cfif CurrentRow MOD 2>"listaNon" <cfelse>"listaPar"</cfif> onmouseover="style.backgroundColor='##E4E8F3';" onmouseout="style.backgroundColor='<cfif CurrentRow MOD 2>##FFFFFF<cfelse>##FAFAFA</cfif>';">
					<td align="left" colspan="6">#Ddescripcion#</td>
					<td align="right" ><cfif Dmetodo neq 0>#rsMoneda.Msimbolo# #LSCurrencyFormat(Dvalor,'none')#<cfelse>#LSCurrencyFormat(Dvalor,'none')# %</cfif> </td>
					<td align="right" >#rsMoneda.Msimbolo# #LSCurrencyFormat(DCvalor,'none')# </td>
					<td align="right" ><cfif DCcalculo eq 1><img border="0" src="/cfmx/rh/imagenes/Cferror.gif"></cfif> </td>
				</tr>
			</cfoutput>
	<cfelse>		
		<tr><td colspan="9" align="center"><b>No hay Deducciones asociadas al Empleado</b></td></tr>
	</cfif>

