<table width="100%">
	<tr>
		<td colspan="3">&nbsp;
			
		</td>
	</tr>
	<tr>
		<td align="right">
			Período Presupuestario a Exportar:
		</td>
		<td>&nbsp;</td>
		<td align="left">
			<cf_cboCPPid CPPestado="1">
		</td>
	</tr>
	<tr>
		<td align="right">
			Centro Funcional:
		</td>
		<td>&nbsp;</td>
		<td align="left">
			<cf_CPSegUsu_setCFid>
			<cf_CPSegUsu_cboCFid value="#form.CFid#" Consultar="true">
		</td>
	</tr>
	<cfif LvarTipo EQ "exportacionFormulado">
	<tr>
		<td align="right">
			Forzar la exportación desde el 1er mes&nbsp;<BR>del Período Presupuestario:
		</td>
		<td>&nbsp;</td>
		<td align="left">
			<input type="checkbox" name="chkForzarInicio" id="chkForzarInicio" value="1"
				onClick="if (this.checked) alert('PRECAUCION: Recuerde que aunque se fuerce la exportación desde el primer mes del período presupuestario,\ndurante la importación la primera columna de meses debe corresponder al mes actual de contabilidad!');"
			>
		</td>
	</tr>
	<cfelseif LvarTipo EQ "exportacionReales">
	<tr>
		<td align="right">
			Estimar Ejecuciones por Moneda Formulada:
		</td>
		<td>&nbsp;</td>
		<td align="left">
			<input type="checkbox" name="chkEstimarMoneda" id="chkEstimarMoneda" value="1" checked="checked" />
		</td>
	</tr>
	</cfif>
	<tr>
		<td colspan="3">&nbsp;
			
		</td>
	</tr>
	<tr>
		<td colspan="3" align="center">
		<cfoutput>
			<input type="button" value="Generar Exportacion"
				name="#LvarTipo#"
				onClick="location.href='exportacion_sql.cfm?CPPid=' + document.getElementById('CPPid').value + '&CFid=' + document.getElementById('CFid').value + '&#LvarTipo#=1' <cfif LvarTipo EQ "exportacionFormulado">+ '&chkForzarInicio=' + (document.getElementById('chkForzarInicio').checked ? '1' : '0')</cfif>;">
		</cfoutput>
		</td>
	</tr>
	<tr>
		<td colspan="3">&nbsp;
			
		</td>
	</tr>
</table>

