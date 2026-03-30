<cfquery name="rsDeduccionesCalculo" datasource="#Session.DSN#">
	select   <cf_dbfunction name="to_number" args="a.Did"> as Did, a.DCvalor, a.DCinteres, a.DCcalculo, b.Ddescripcion, b.Dvalor, b.Dmetodo
	from HDeduccionesCalculo a, DeduccionesEmpleado b
	where a.RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RCNid#">
	and a.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.DEid#">
	and a.Did = b.Did
</cfquery>

	<tr>
		<td colspan="8" class="tituloAlterno2"><cf_translate xmlfile="/rh/nomina/operacion/ResultadoCalculo.xml"   key="LB_Deducciones">Deducciones</cf_translate></td>
	</tr>

	<cfif rsDeduccionesCalculo.RecordCount gt 0 >
		<tr>
			<td align="left" class="FileLabel" colspan="4"><cf_translate xmlfile="/rh/generales.xml"   key="LB_Descripcion">Descripci&oacute;n</cf_translate></td>
			<td align="right" class="FileLabel"><cf_translate xmlfile="/rh/nomina/operacion/ResultadoCalculo.xml"   key="LB_Valor">Valor</cf_translate></td>
			<td align="right" class="FileLabel"><cf_translate xmlfile="/rh/nomina/operacion/ResultadoCalculo.xml"   key="LB_Monto">Monto</cf_translate></td>
			<td align="right" class="FileLabel">&nbsp;</td>
		</tr>
	
			<cfoutput query="rsDeduccionesCalculo">
				<tr class=<cfif CurrentRow MOD 2>"listaNon" <cfelse>"listaPar"</cfif> onmouseover="style.backgroundColor='##E4E8F3';" onmouseout="style.backgroundColor='<cfif CurrentRow MOD 2>##FFFFFF<cfelse>##FAFAFA</cfif>';">
					<td align="left" colspan="4">#Ddescripcion#</td>
					<td align="right" ><cfif Dmetodo neq 0>#rsMoneda.Msimbolo# #LSCurrencyFormat(Dvalor,'none')#<cfelse>#LSCurrencyFormat(Dvalor,'none')# %</cfif> </td>
					<td align="right" >#rsMoneda.Msimbolo# #LSCurrencyFormat(DCvalor,'none')# </td>
					<td align="right" ><cfif DCcalculo eq 1><img border="0" src="/cfmx/rh/imagenes/Cferror.gif"></cfif> </td>
				</tr>
			</cfoutput>
	<cfelse>		
		<tr><td colspan="7" align="center"><b><cf_translate xmlfile="/rh/nomina/operacion/ResultadoCalculo.xml"   key="LB_NoHayDeduccionesAsociadasAlEmpleado">No hay Deducciones asociadas al Empleado</cf_translate></b></td></tr>
	</cfif>

