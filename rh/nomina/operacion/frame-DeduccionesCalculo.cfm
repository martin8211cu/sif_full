<cfquery name="rsDeduccionesCalculo" datasource="#Session.DSN#">
	select  a.Did, a.DCvalor, a.DCinteres, a.DCcalculo, b.Ddescripcion, b.Dvalor, b.Dmetodo, b.Dreferencia
	from DeduccionesCalculo a, DeduccionesEmpleado b
	where a.RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RCNid#">
	and a.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.DEid#">
	and a.Did = b.Did
</cfquery>
	<tr>
		<td colspan="11" class="<cfoutput>#Session.Preferences.Skin#_thcenter</cfoutput>"><div align="center"><cf_translate key="LB_Deducciones">Deducciones</cf_translate></div></td>
	</tr>
	<tr>
		<td align="left" class="FileLabel">&nbsp;</td>
		<td align="left" class="FileLabel" colspan="6"><cf_translate key="LB_Descripcion" XmlFile="/rh/generales.xml">Descripci&oacute;n</cf_translate></td>
		<td align="left" class="FileLabel"><cf_translate key="LB_Referencia">Referencia</cf_translate></td>
		<td align="right" class="FileLabel"><cf_translate key="LB_Valor">Valor</cf_translate></td>
		<td align="right" class="FileLabel"><cf_translate key="LB_MontoResultante">Monto Resultante</cf_translate></td>
		<td align="right" class="FileLabel">&nbsp;</td>
	</tr>
<cfoutput query="rsDeduccionesCalculo">
	<tr class=<cfif CurrentRow MOD 2>"listaNon" <cfelse>"listaPar"</cfif> onmouseover="style.backgroundColor='##E4E8F3';" onmouseout="style.backgroundColor='<cfif CurrentRow MOD 2>##FFFFFF<cfelse>##FAFAFA</cfif>';">
		<td align="left" ><input type="checkbox" name="chk" value="D|#Did#"></td>
		<td align="left" colspan="6">#Ddescripcion#</td>
		<td align="left" >#Dreferencia#</td>
		<td align="right" ><cfif Dmetodo neq 0>#rsMoneda.Msimbolo# #LSCurrencyFormat(Dvalor,'none')#<cfelse>#LSCurrencyFormat(Dvalor,'none')# %</cfif> </td>
		<td align="right" nowrap="nowrap">#rsMoneda.Msimbolo# #LSCurrencyFormat(DCvalor,'none')# </td>
		<td align="right" ><cfif DCcalculo eq 1><img border="0" src="/cfmx/rh/imagenes/Cferror.gif"></cfif> </td>
	</tr>
</cfoutput>
