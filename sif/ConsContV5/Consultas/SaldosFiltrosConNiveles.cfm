<cfquery name="rsEmpresa" datasource="desarrollo">
	select CGE1COD FROM CGE000		
</cfquery>

<cfquery name="rsSucursal" datasource="desarrollo">
	select CGE5COD, CGE5DES
	from CGE005
	where CGE1COD = <cfqueryparam cfsqltype="cf_sql_char" value="#rsEmpresa.CGE1COD#">
</cfquery>

<cfoutput>
<table width="100%"  border="0" cellspacing="0" cellpadding="0">
	<tr>
		<td align="right" nowrap><strong>Nivel Detalle:</strong>&nbsp;</td>
		<td nowrap><input type="text" name="NivelDetalle" maxlength="10" value="" size="10" ></td>
		<td align="right" nowrap><strong>Nivel Total:</strong>&nbsp;</td>
		<td nowrap><input type="text" name="NivelTotal" maxlength="10" value="" size="10" ></td>
	</tr>

	<tr>
		<td align="right" nowrap><strong>A&ntilde;o Inicial:</strong>&nbsp;</td>
	  	<td nowrap><input type="text" name="AnoInicial" maxlength="10" value="" size="10" ></td>
		<td align="right" nowrap ><strong>A&ntilde;o  Final:</strong>&nbsp;</td>
		<td nowrap><input type="text" name="AnoFinal" maxlength="10" value="" size="10" ></td>
	</tr>
	
	<tr>
		<td align="right" nowrap><strong>Mes Inicial:</strong>&nbsp;</td>
		<td nowrap ><input type="text" name="MesInicial" maxlength="10" value="" size="10" ></td>
		<td align="right" nowrap><strong>Mes Final:</strong>&nbsp;</td>
		<td nowrap><input type="text" name="MesFinal" maxlength="10" value="" size="10" ></td>
	</tr>
	
	<tr>
		<td align="right" nowrap><strong>Tipo Impresi&oacute;n:</strong>&nbsp;</td>
		<td nowrap>
			<select name="TipoFormato">
				<option value="1">Detallado</option>
				<option value="2">Detallado por Mes</option>
				<option value="3">Detallado por Asiento</option>
				<option value="4">Resumido</option>
			</select>								    
		</td>											
		<td align="right" nowrap><strong>Segmento:</strong>&nbsp;</td>
		<td nowrap>
			<select name="Segmento">
				<option value="T">Todas</option>
				<cfloop query="rsSucursal">
					<option value="#rsSucursal.CGE5COD#" >#rsSucursal.CGE5DES#</option>
				</cfloop>
			</select>
		</td>											
	</tr>
</table>
</cfoutput>