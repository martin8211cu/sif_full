<!--- Campos por los cuales se realizará el filtro--->
<cfif isdefined("url.Bid") and not isdefined("form.Bid") >
	<cfset form.Bid = url.Bid >
</cfif>
<cfif isdefined("url.FAM18DES") and not isdefined("form.FAM18DES") >
	<cfset form.FAM18DES = url.FAM18DES >
</cfif>

<!--- Dibuja el filtro--->

<cfoutput>
<form style="margin: 0" action="bancos.cfm" name="bancos" method="post">
<table width="100%" border="0" cellspacing="0" cellpadding="2" class="areaFiltro">
	<tr>
		<td colspan="2">
			<td width="84" align="right"><strong><strong>C&oacute;digo:</strong></td>
									
			<td width="247" align="left">
				<input name="Bid_F" type="text" id="FAM17MAX" value="<cfif isdefined('form.Bid_F')>#form.Bid_F#</cfif>" style="text-align: right" size="20" maxlength="15" tabindex="1" onFocus="this.value=qf(this); this.select();" onBlur="fm(this,-1);"  onKeyUp="if(snumber(this,event,-1)){ if(Key(event)=='13') {this.blur();}}">
			</td>
			
			<td width="543" rowspan="2" align="center" valign="middle"><input type="submit" name="btnFiltro"  value="Filtrar"></td>
	  </tr>
	<tr>
		<td colspan="2">
			<td width="84" align="right"><strong>Descripci&oacute;n:</strong><strong><strong></td>
									
			<td width="247" align="left"><input type="text" name="FAM18DES_F" size="30" maxlength="30" value="<cfif isdefined('form.FAM18DES_F')>#form.FAM18DES_F#</cfif>">
			</td>
	  </tr>
 </table>
</form>
</cfoutput>
