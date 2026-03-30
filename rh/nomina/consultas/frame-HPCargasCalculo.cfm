<cfquery name="rsCargasCalculo" datasource="#Session.DSN#">
	select 	 <cf_dbfunction name="to_number" args="a.DClinea"> as DClinea, CCvaloremp, CCvalorpat, DCdescripcion, ECauto
	from HCargasCalculo a, DCargas b, ECargas c
	where RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RCNid#">
	and DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.DEid#">
	and a.DClinea = b.DClinea
	and b.ECid = c.ECid
</cfquery>
	<tr>
		<td colspan="8" class="tituloAlterno2"><cf_translate xmlfile="/rh/nomina/operacion/ResultadoCalculo.xml"   key="LB_Cargas">Cargas</cf_translate></td>
	</tr>
	<cfif rsCargasCalculo.RecordCount gt 0>
		<tr>
			<td align="left" class="FileLabel" colspan="4"><cf_translate xmlfile="/rh/generales.xml"   key="LB_Descripcion">Descripci&oacute;n</cf_translate></td>
			<td align="right" class="FileLabel"><cf_translate xmlfile="/rh/nomina/operacion/ResultadoCalculo.xml"   key="LB_MontoPatrono">Monto Patrono</cf_translate></td>
			<td align="right" class="FileLabel"><cf_translate xmlfile="/rh/nomina/operacion/ResultadoCalculo.xml"   key="LB_MontoEmpleado">Monto Empleado</cf_translate></td>
			<td align="right" class="FileLabel">&nbsp;</td>
		</tr>
		<cfoutput query="rsCargasCalculo">
			<tr class=<cfif CurrentRow MOD 2>"listaNon" <cfelse>"listaPar"</cfif> onmouseover="style.backgroundColor='##E4E8F3';" onmouseout="style.backgroundColor='<cfif CurrentRow MOD 2>##FFFFFF<cfelse>##FAFAFA</cfif>';">
				<td align="left" colspan="4">#DCdescripcion#</td>
				<td align="right" >#rsMoneda.Msimbolo# #LSCurrencyFormat(CCvalorpat,'none')# </td>
				<td align="right" >#rsMoneda.Msimbolo# #LSCurrencyFormat(CCvaloremp,'none')# </td>
				<td align="right" >&nbsp;</td>
			</tr>
		</cfoutput>
	<cfelse>		
		<tr><td colspan="7" align="center"><b><cf_translate xmlfile="/rh/nomina/operacion/ResultadoCalculo.xml"   key="LB_NoHayCargasAsociadasAlEmpleado">No hay Cargas asociadas al Empleado</cf_translate></b></td></tr>
	</cfif>

