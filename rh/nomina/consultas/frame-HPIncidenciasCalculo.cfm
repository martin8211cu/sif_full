<cfquery name="rsIncidenciasCalculo" datasource="#Session.DSN#">
	select <cf_dbfunction name="to_number" args="a.ICid"> as ICid, b.CIdescripcion, a.ICfecha, a.ICvalor, a.ICmontores, a.ICcalculo
	from HIncidenciasCalculo a, CIncidentes b
	where a.CIid = b.CIid
	and RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RCNid#">
	and DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.DEid#">
	order by a.ICfecha
</cfquery>
  <tr> 
    <td colspan="8" class="tituloAlterno2"><cf_translate xmlfile="/rh/nomina/operacion/ResultadoCalculo.xml"   key="LB_Incidencias">Incidencias</cf_translate></td>
  </tr>

	<cfif rsIncidenciasCalculo.RecordCount gt 0>
	  <tr> 
		<td align="left" class="FileLabel"><cf_translate xmlfile="/rh/nomina/operacion/ResultadoCalculo.xml"   key="LB_Fecha">Fecha</cf_translate></td>
		<td align="left" class="FileLabel" colspan="3"><cf_translate xmlfile="/rh/nomina/operacion/ResultadoCalculo.xml"   key="LB_Concepto">Concepto</cf_translate></td>
		<td align="right" class="FileLabel"><cf_translate xmlfile="/rh/nomina/operacion/ResultadoCalculo.xml"   key="LB_Valor">Valor</cf_translate></td>
		<td align="right" class="FileLabel"><cf_translate xmlfile="/rh/nomina/operacion/ResultadoCalculo.xml"   key="LB_Monto">Monto</cf_translate></td>
		<td align="right" class="FileLabel">&nbsp;</td>
	  </tr>

		<cfoutput query="rsIncidenciasCalculo">
		  <tr class=<cfif CurrentRow MOD 2>"listaNon" <cfelse>"listaPar"</cfif> onmouseover="style.backgroundColor='##E4E8F3';" onmouseout="style.backgroundColor='<cfif CurrentRow MOD 2>##FFFFFF<cfelse>##FAFAFA</cfif>';"> 
			<td align="left" >#LSDateFormat(ICfecha,'dd/mm/yyyy')#</td>
			<td align="left" colspan="3">#CIdescripcion#</td>
			<td align="right" >#ICvalor#</td>
			<td align="right" >#rsMoneda.Msimbolo# #LSCurrencyFormat(ICmontores,'none')# </td>
			<td align="right" ><cfif ICcalculo eq 1><img border="0" src="/cfmx/rh/imagenes/Cferror.gif"></cfif></td>
		  </tr>
		</cfoutput>
	<cfelse>		
		<tr><td colspan="7" align="center"><b><cf_translate xmlfile="/rh/nomina/operacion/ResultadoCalculo.xml"   key="LB_NoHayIncidenciasAsociadasAlEmpleado">No hay Incidencias asociadas al Empleado</cf_translate></b></td></tr>
	</cfif>
