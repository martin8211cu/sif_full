<cfif isdefined("url.FAM09MAQ") and not isdefined("form.FAM09MAQ") >
	<cfset form.FAM09MAQ = url.FAM09MAQ >
</cfif>
<cfif isdefined("url.FAM09DES") and not isdefined("form.FAM09DES") >
	<cfset form.FAM09DES = url.FAM09DES >
</cfif>
<cfoutput>
<form style="margin: 0" action="maquinas.cfm" name="maquinas" method="post">
<table width="100%" border="0" cellspacing="0" cellpadding="2" class="areaFiltro">
<tr>
	<td colspan="2">
       	<td width="82" align="right"><strong>C&oacute;digo<strong></td>
								
       	<td width="247" align="left"><input type="text" name="FAM09MAQ_F" size="15" maxlength="30" value="<cfif isdefined('form.FAM09MAQ_F')>#form.FAM09MAQ_F#</cfif>"></td>
   		
		<td width="82" align="right"><strong>Descripci&oacute;n<strong></td>
								
       	<td width="247" align="left"><input type="text" name="FAM09DES_F" size="30" maxlength="30" value="<cfif isdefined('form.FAM09DES_F')>#form.FAM09DES_F#</cfif>"></td>
   			
   		<td><input type="submit" name="btnFiltro"  value="Filtrar"></td>
	</td>	
</tr>
 </table>
</form>
</cfoutput>