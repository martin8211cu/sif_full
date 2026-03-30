
<fieldset>
	<legend>Perfil Econ&oacute;mico:</legend>
	<table width="100%"  align="center" cellpadding="0" cellspacing="0">
		<tr>
			<td align="left" nowrap ><strong>Trabajo:</strong></td>
			<td align="left" colspan="2" nowrap><strong>Antig&uuml;edad:</strong></td>
		</tr>
		<tr>
			<td nowrap><input name="CDtrabajo" type="text" tabindex="1" value="<cfif modo neq "ALTA"><cfoutput>#HTMLEditFormat(rsClienteDetallista.CDtrabajo)#</cfoutput></cfif>" size="25" maxlength="30" onFocus="this.select();"  alt="Trabajo del Cliente"></td>
			<td align="left" nowrap colspan="2">
				<input name="CDantiguedad" type="text" tabindex="1" value="<cfif modo neq "ALTA"><cfoutput>#HTMLEditFormat(rsClienteDetallista.CDantiguedad)#</cfoutput><cfelse>0</cfif>" size="5" maxlength="2" onFocus="javascript:this.value=qf(this); this.select();" onBlur="javascript: fm(this,0); " onKeyUp="javascript:if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}" alt="Antiguedad del Cliente">
			</td>
		</tr>
		<tr>
			<td align="left" nowrap><strong>Estudios:</strong>&nbsp;&nbsp;</td>
			<td align="left" nowrap colspan="2"><strong>Dependientes:</strong></td>
		</tr>
		<tr>
			<td ><select name="CDestudios" id="CDestudios" tabindex="1">
				<option value="" <cfif modo NEQ 'ALTA' and rsClienteDetallista.CDestudios EQ ''> selected</cfif>>No especificada</option>
				<option value="1" <cfif modo NEQ 'ALTA' and rsClienteDetallista.CDestudios EQ '1'> selected</cfif>>Primaria Incompleta</option>
				<option value="2" <cfif modo NEQ 'ALTA' and rsClienteDetallista.CDestudios EQ '2'> selected</cfif>>Primaria Completa</option>
				<option value="3" <cfif modo NEQ 'ALTA' and rsClienteDetallista.CDestudios EQ '3'> selected</cfif>>Secundaria Incompleta</option>
				<option value="4" <cfif modo NEQ 'ALTA' and rsClienteDetallista.CDestudios EQ '4'> selected</cfif>>Secundaria Completa</option>
				<option value="5" <cfif modo NEQ 'ALTA' and rsClienteDetallista.CDestudios EQ '5'> selected</cfif>>T&eacute;cnica Incompleta</option>
				<option value="6" <cfif modo NEQ 'ALTA' and rsClienteDetallista.CDestudios EQ '6'> selected</cfif>>T&eacute;cnica Completa</option>
				<option value="7" <cfif modo NEQ 'ALTA' and rsClienteDetallista.CDestudios EQ '7'> selected</cfif>>Universitaria Incompleta</option>
				<option value="8" <cfif modo NEQ 'ALTA' and rsClienteDetallista.CDestudios EQ '8'> selected</cfif>>Universitaria Completa</option>
				<option value="9" <cfif modo NEQ 'ALTA' and rsClienteDetallista.CDestudios EQ '9'> selected</cfif>>Postgrado</option>
			  </select>
			</td>
			<td align="left" nowrap colspan="2">
  				<input name="CDdependientes" type="text" tabindex="1" value="<cfif modo neq "ALTA"><cfoutput>#HTMLEditFormat(rsClienteDetallista.CDdependientes)#</cfoutput><cfelse>0</cfif>" size="5" maxlength="2" onFocus="javascript:this.value=qf(this); this.select();" onBlur="javascript: fm(this,0); " onKeyUp="javascript:if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}" alt="N&uuml;mero de dependientes del Cliente">
			&nbsp;&nbsp;											
			</td>
		</tr>
		<tr>
			<td align="left" nowrap><strong>Vivienda:</strong></td>
			<td align="left" nowrap colspan="2"><strong>Ingresos Mensuales:</strong></td>
		</tr>
		<tr>
			<td>
				<select name="CDvivienda" id="CDvivienda" tabindex="1">
					<option value="A" <cfif modo NEQ 'ALTA' and rsClienteDetallista.CDvivienda EQ 'A'> selected</cfif>>Alquilada</option>
					<option value="H" <cfif modo NEQ 'ALTA' and rsClienteDetallista.CDvivienda EQ 'H'> selected</cfif>>Hipotecada</option>
					<option value="P" <cfif modo NEQ 'ALTA' and rsClienteDetallista.CDvivienda EQ 'P'> selected</cfif>>Propia</option>
					<option value="F" <cfif modo NEQ 'ALTA' and rsClienteDetallista.CDvivienda EQ 'F'> selected</cfif>>Vive con familiares</option>
			  	</select>
			</td>
			<td><!--- <input name="CDingreso" type="text"  value="<cfif modo neq "ALTA"><cfoutput>#rsClienteDetallista.CDingreso#</cfoutput></cfif>" size="25" maxlength="30" onFocus="this.select();"  alt="Ingresos del Cliente">--->
				<input name="CDingreso" type="text" tabindex="1" style="text-align: right;" onFocus="javascript:this.value=qf(this); this.select();" onBlur="javascript: fm(this,2); " onKeyUp="javascript:if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}" value="<cfif modo neq 'ALTA'><cfoutput>#LSCurrencyFormat(rsClienteDetallista.CDingreso, 'none')#</cfoutput><cfelse>0.00</cfif>" size="30" maxlength="14" alt="Ingresos del Cliente" >
			</td>
		</tr>
		
	</table>
</fieldset>

