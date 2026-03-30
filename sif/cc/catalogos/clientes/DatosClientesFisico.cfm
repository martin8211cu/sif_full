<fieldset>
	<legend>Datos F&iacute;sicos:</legend>
	<table width="100%"  align="center" cellpadding="0" cellspacing="0">
		<tr align="left">
			<td nowrap colspan="3"><strong>Direcci&oacute;n 1:</strong>&nbsp;</td>
		</tr>
		<tr>
			<td colspan="3">
				<input name="CDdireccion1" type="text" tabindex="1"
					value="<cfif modo neq "ALTA"><cfoutput>#HTMLEditFormat(rsClienteDetallista.CDdireccion1)#</cfoutput></cfif>" 
					size="70" maxlength="255" onfocus="this.select();"  alt="La Direcci&oacute;n Primaria del Cliente">
			</td>
		</tr>
		<tr>
		  <td colspan="3"><strong>Direcci&oacute;n 2:</strong>&nbsp;</td>
	  </tr>
		<tr>
			<td colspan="3">
				<input name="CDdireccion2" type="text" tabindex="1"
					value="<cfif modo neq "ALTA"><cfoutput>#HTMLEditFormat(rsClienteDetallista.CDdireccion2)#</cfoutput></cfif>" 
					size="70" maxlength="255" onfocus="this.select();"  alt="La Direcci&oacute;n Secundaria del Cliente">
			</td>
		</tr>
		<tr>
			<td align="left" nowrap><strong>Pa&iacute;s:</strong>&nbsp;&nbsp;</td>
			<td align="left" nowrap colspan="2"><strong>Ciudad:</strong></td>
		</tr>
		<tr>
			<td nowrap> 
				<cfif modo is 'ALTA'>
					<cfset pais_default = rsPaisDefault.Ppais>
				<cfelse>
					<cfset pais_default = rsClienteDetallista.CDpais>
				</cfif>
				<select name="CDpais" id="CDpais" tabindex="1">
				  <cfoutput query="rsPais"> 
					<option value="#rsPais.Ppais#"<cfif rsPais.Ppais is pais_default> selected</cfif>>#rsPais.Pnombre#</option>
				  </cfoutput>
			  	</select>
		  	</td>
			<td nowrap colspan="2">
				<input name="CDciudad" type="text" tabindex="1"
					value="<cfif modo neq "ALTA"><cfoutput>#HTMLEditFormat(rsClienteDetallista.CDciudad)#</cfoutput></cfif>" 
					size="25" maxlength="30" onFocus="this.select();"  alt="La ciudad origen del Cliente">
			</td>

		</tr>
		<tr>
			<td align="left" nowrap ><strong>C&oacute;digo Postal:</strong></td>
			<td align="left" nowrap ><strong>Provincia o Estado:</strong></td>
			<td>&nbsp;</td>
		</tr>
		<tr>
			<td ><input name="CDcodPostal" type="text" tabindex="1" value="<cfif modo neq "ALTA"><cfoutput>#HTMLEditFormat(rsClienteDetallista.CDcodPostal)#</cfoutput></cfif>" size="25" maxlength="30" onFocus="this.select();"  alt="El c&oacute;digo Postal del Cliente">
			<td ><input name="CDestado" type="text" tabindex="1" value="<cfif modo neq "ALTA"><cfoutput>#HTMLEditFormat(rsClienteDetallista.CDestado)#</cfoutput></cfif>" size="25" maxlength="30" onFocus="this.select();"  alt="El estado de origen del Cliente">
			<td>&nbsp;</td>
		</tr>
	</table>
</fieldset>
