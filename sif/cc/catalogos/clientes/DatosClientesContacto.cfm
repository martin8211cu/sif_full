
<fieldset>
	<legend>Datos Contacto:</legend>
	<table width="100%"  align="center" cellpadding="0" cellspacing="0">
		<tr>
			<td class="fileLabel" width="50%"><strong>Tel&eacute;fono de Residencia </strong></td>
			<td class="fileLabel" width="50%"><strong>Tel&eacute;fono Celular</strong></td>
		</tr>
		<tr> 
			<td width="50%"><input name="CDcasa" type="text" id="CDcasa" tabindex="1"  value="<cfif modo NEQ 'ALTA'><cfoutput>#HTMLEditFormat(rsClienteDetallista.CDcasa)#</cfoutput></cfif>" size="35" maxlength="30" onFocus="this.select();"></td>
			<td width="50%"><input name="CDcelular" type="text" id="CDcelular" tabindex="1"  value="<cfif modo NEQ 'ALTA'><cfoutput>#HTMLEditFormat(rsClienteDetallista.CDcelular)#</cfoutput></cfif>" size="35" maxlength="30" onFocus="this.select();"></td>
		</tr>
		<tr>
			<td class="fileLabel" width="50%"><strong>Tel&eacute;fono de Oficina </strong></td>
			<td class="fileLabel" width="50%"><strong>Fax</strong></td>
		</tr>
		<tr> 
			<td width="50%"><input name="CDoficina" type="text" id="CDoficina" tabindex="1" value="<cfif modo NEQ 'ALTA'><cfoutput>#HTMLEditFormat(rsClienteDetallista.CDoficina)#</cfoutput></cfif>" size="35" maxlength="30" onFocus="this.select();"></td>
			<td width="50%"><input name="CDfax" type="text" id="CDfax" tabindex="1" value="<cfif modo NEQ 'ALTA'><cfoutput>#HTMLEditFormat(rsClienteDetallista.CDfax)#</cfoutput></cfif>" size="35" maxlength="30" onFocus="this.select();"></td>
		</tr>
		<tr>
			<td width="50%"><strong>Direcci&oacute;n Electr&oacute;nica:</strong></td>
			<td width="50%"><strong>Lista de Precios</strong></td>
		</tr>
		<cfoutput>
			<tr>
				<td width="50%"><input name="CDemail" type="text" id="CDemail" tabindex="1"  onFocus="this.select();" value="<cfif modo NEQ 'ALTA'><cfoutput>#HTMLEditFormat(rsClienteDetallista.CDemail)#</cfoutput></cfif>" size="35" maxlength="120"></td>
				<td width="50%">
					<select name="LPid" id="LPid" tabindex="1">
						<option value="">- Usar predeterminada del sistema -</option>
						<cfloop query="rsListaPrecios">
						  <option value="#rsListaPrecios.LPid#" <cfif Len(rsListaPrecios.SNcodigo)>selected</cfif>>#HTMLEditFormat(rsListaPrecios.LPdescripcion)#</option>
						</cfloop>
			  		</select>
				</td>						
			</tr>
		</cfoutput>
	</table>
</fieldset>
