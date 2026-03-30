<cfquery name="rsIncidenciasCalculo" datasource="#Session.DSN#">
	select ICid, b.CIdescripcion, a.ICfecha, a.ICvalor, a.ICmontores, a.ICcalculo
	from IncidenciasCalculo a, CIncidentes b
	where a.CIid = b.CIid
	and RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RCNid#">
	and DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.DEid#">
	order by a.ICfecha
</cfquery>
  <tr> 
    <td colspan="10" class="tituloAlterno2">Incidencias</td>
  </tr>

	<cfif rsIncidenciasCalculo.RecordCount gt 0>
	  <tr> 
		<td align="left" class="FileLabel">Fecha</td>
		<td align="left" class="FileLabel" colspan="5">Concepto</td>
		<td align="right" class="FileLabel">Valor</td>
		<td align="right" class="FileLabel">Monto</td>
		<td align="right" class="FileLabel">&nbsp;</td>
	  </tr>

		<cfoutput query="rsIncidenciasCalculo">
		  <tr class=<cfif CurrentRow MOD 2>"listaNon" <cfelse>"listaPar"</cfif> onmouseover="style.backgroundColor='##E4E8F3';" onmouseout="style.backgroundColor='<cfif CurrentRow MOD 2>##FFFFFF<cfelse>##FAFAFA</cfif>';"> 
			<td align="left" >#LSDateFormat(ICfecha,'dd/mm/yyyy')#</td>
			<td align="left" colspan="5">#CIdescripcion#</td>
			<td align="right" >#ICvalor#</td>
			<td align="right" >#rsMoneda.Msimbolo# #LSCurrencyFormat(ICmontores,'none')# </td>
			<td align="right" ><cfif ICcalculo eq 1><img border="0" src="/cfmx/rh/imagenes/Cferror.gif"></cfif></td>
		  </tr>
		</cfoutput>
	<cfelse>		
		<tr><td colspan="9" align="center"><b>No hay Incidencias asociadas al Empleado</b></td></tr>
	</cfif>
