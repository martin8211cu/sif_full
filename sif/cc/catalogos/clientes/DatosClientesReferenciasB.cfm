	<table width="100%"  align="center" cellpadding="0" cellspacing="0">
	<!---
		<tr>
			<td align="left" nowrap  colspan="3"><strong>Bancarias:</strong>&nbsp;&nbsp;</td>
		</tr>--->
		<tr>
			<td align="left" nowrap  colspan="3">
				<textarea name="CDrefbancaria" tabindex="1" id="CDrefbancaria" rows="2" style="width: 100%; font-family:Arial; font-size:9pt" onFocus="this.select();"><cfif modo NEQ 'ALTA'><cfoutput>#HTMLEditFormat(rsClienteDetallista.CDrefbancaria)#</cfoutput></cfif></textarea>
			</td>
		</tr>
	</table>
