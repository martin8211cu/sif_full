
	<table width="100%"  align="center" cellpadding="0" cellspacing="0"><!---
		<tr>
			<td align="left" nowrap  colspan="3"><strong>Crediticias:</strong>&nbsp;&nbsp;</td>
		</tr>--->
		<tr>
			<td align="left" nowrap  >
				<!---<textarea name="CDrefcredito" id="CDrefcredito" rows="2"  style="width: 100%; font:'Courier New', Courier, mono;"><cfif modo NEQ 'ALTA'><cfoutput>#rsClienteDetallista.CDrefcredito#</cfoutput></cfif></textarea>--->
				<textarea  name="CDrefcredito" id="CDrefcredito" tabindex="1" rows="2" style="width: 100%; font-family:Arial; font-size:9pt" onFocus="this.select();"><cfif modo NEQ 'ALTA'><cfoutput>#HTMLEditFormat(rsClienteDetallista.CDrefcredito)#</cfoutput></cfif></textarea>
			</td>
		</tr>
	</table>
