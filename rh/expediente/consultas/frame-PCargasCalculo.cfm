<cfquery name="rsCargasCalculo" datasource="#Session.DSN#">
	select 	a.DClinea, CCvaloremp, CCvalorpat, DCdescripcion, ECauto
	from CargasCalculo a
	
	inner join DCargas b
	on a.DClinea = b.DClinea
	
	inner join ECargas c
	on b.ECid = c.ECid
	
	where RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RCNid#">
	and DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.DEid#">

</cfquery>
	<tr>
		<td colspan="10" class="tituloAlterno2">Cargas</td>
	</tr>
	<cfif rsCargasCalculo.RecordCount gt 0>
		<tr>
			<td align="left" class="FileLabel" colspan="6">Descripci&oacute;n</td>
			<td align="right" class="FileLabel">Monto Patrono</td>
			<td align="right" class="FileLabel">Monto Empleado</td>
			<td align="right" class="FileLabel">&nbsp;</td>
		</tr>
		<cfoutput query="rsCargasCalculo">
			<tr class=<cfif CurrentRow MOD 2>"listaNon" <cfelse>"listaPar"</cfif> onmouseover="style.backgroundColor='##E4E8F3';" onmouseout="style.backgroundColor='<cfif CurrentRow MOD 2>##FFFFFF<cfelse>##FAFAFA</cfif>';">
				<td align="left" colspan="6">#DCdescripcion#</td>
				<td align="right" >#rsMoneda.Msimbolo# #LSCurrencyFormat(CCvalorpat,'none')# </td>
				<td align="right" >#rsMoneda.Msimbolo# #LSCurrencyFormat(CCvaloremp,'none')# </td>
				<td align="right" >&nbsp;</td>
			</tr>
		</cfoutput>
	<cfelse>		
		<tr><td colspan="9" align="center"><b>No hay Cargas asociadas al Empleado</b></td></tr>
	</cfif>

