<cf_web_portlet_start border="true" titulo="Copia de Valores de Conductor" skin="#Session.Preferences.Skin#">

<cfoutput>
<form action="Valor_Conductor_sql.cfm" method="post" id="form1">
<input type="hidden" name="params" value="#url.params#" />
<input type="hidden" name="smes" value="#url.smes#" />
<input type="hidden" name="speriodo" value="#url.speriodo#" />
<table width="100%" align="center" border="0">
	<cfif not isdefined('url.bandera')>
	<tr>
		<td align="right">
		<strong>Periodo:</strong></td>
		<td><cf_periodos></td>		  
	</tr>
	<tr>
		<td align="right">
		<strong>Mes:</strong></td>
		<td><cf_meses></td>		  
	</tr>
	<tr>
		<td align="center" colspan="2"><input name="copiar" id="copiar" value="Listo" type="submit" /></td>
	</tr>
		<cfif isdefined ('url.bandera1')>
		<tr>
			<td align="center" colspan="2">
			<strong>No existen datos en el periodo: #url.periodo# y mes: #url.mes#</strong>
			</td>
		</tr>
		</cfif>
	<cfelse>
	<tr>
		<td align="center">
		<input type="hidden" name="mes" value="#url.mes#" />
		<input type="hidden" name="periodo" value="#url.periodo#" />
		 <strong>El registro al que se van a insertar los valores tiene datos, desea sobrescribirlos</strong>
		 </td>
	</tr>
	<tr>
		<td align="center">
			 <input type="submit" name="sobre" value="Sobrescribir" />
		</td>
	</tr>
	</cfif>
</table>
<!---<cfloop list="#url.params#" delimiters="," index="aa">
	<cfset valor=#listgetat(aa, 1, ',')#>
	<cfdump var="#valor#"><br/>
	</cfloop>--->
	</form>
</cfoutput>
 <cf_web_portlet_end>
