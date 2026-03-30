<cfif modo neq 'ALTA'>
	<cfquery name="data" datasource="asp">
		select WTCid, WECdescripcion, WTCmascara, WECtexto
		from WTContable
		where WTCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.WTCid#">
	</cfquery>
</cfif>

<cfoutput>

<table width="100%" cellpadding="0" cellspacing="0">
	<tr>
		<td align="right">Descripci&oacute;n:&nbsp;</td>
		<td><input type="text" name="WECdescripcion" size="60" maxlength="80" value="<cfif modo neq 'ALTA'>#data.WECdescripcion#</cfif>" onfocus="this.select();" ></td>
		<td align="right">M&aacute;scara:&nbsp;</td>
		<td><input type="text" name="WTCmascara" size="60" maxlength="100" value="<cfif modo neq 'ALTA'>#data.WTCmascara#</cfif>" onfocus="this.select();"></td>
	<tr>
		<td align="right" valign="top">Texto:&nbsp;</td>
		<td align="right" colspan="3"><textarea  cols="100" rows="5" name="WECtexto" onfocus="this.select();"><cfif modo neq 'ALTA'>#trim(data.WECtexto)#</cfif></textarea></td>
	</tr>
</table>

<!--- hiddens --->
<cfif modo NEQ 'ALTA'>
	<input type="hidden" name="WTCid" value="#form.WTCid#">
</cfif>

</cfoutput>