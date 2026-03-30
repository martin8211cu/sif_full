<cfif modo neq 'ALTA'>
	<cfquery name="data" datasource="asp">
		select WTCid, WECdescripcion, WTCmascara, WECtexto
		from WTContable
		where WTCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.WTCid#">
	</cfquery>
</cfif>

<cfoutput>

<table align="center" width="85%" border="0" cellpadding="0" cellspacing="0">
	<tr>
		<td align="right">Descripci&oacute;n:&nbsp;</td>
		<td><input type="text" name="WECdescripcion" size="60" maxlength="80" value="<cfif modo neq 'ALTA'>#data.WECdescripcion#</cfif>" onfocus="this.select();" ></td>
		<td>&nbsp;</td>
		<td align="right" width="1%">M&aacute;scara:&nbsp;</td>
		<td width="1%"><input type="text" name="WTCmascara" size="60" maxlength="100" value="<cfif modo neq 'ALTA'>#data.WTCmascara#</cfif>" onfocus="this.select();"></td>
		<td>&nbsp;</td>
	</tr>	

	<tr>
		<td align="right" valign="top">Texto:&nbsp;</td>
		<td align="left" colspan="4">
			<textarea rows="5" name="WECtexto" style="font-family:sans-serif; width:100%;" onfocus="this.select();"><cfif modo neq 'ALTA'>#trim(data.WECtexto)#</cfif></textarea>
		</td>
	</tr>

</table>

<!--- hiddens --->
<cfif modo NEQ 'ALTA'>
	<input type="hidden" name="WTCid" value="#form.WTCid#">
</cfif>

</cfoutput>