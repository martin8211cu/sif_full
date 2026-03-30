<cfif isdefined("url.FAM12COD") and not isdefined("form.FAM12COD") >
	<cfset form.FAM12COD = url.FAM12COD >
</cfif>
<cfif isdefined("url.FAM12CODD") and not isdefined("form.FAM12CODD") >
	<cfset form.FAM12CODD = url.FAM12CODD >
</cfif>
<cfif isdefined("url.FAM12DES") and not isdefined("form.FAM12DES") >
	<cfset form.FAM12DES = url.FAM12DES >
</cfif>
<cfoutput>
<form style="margin: 0" action="impresoras.cfm" name="impresoras" method="post">
<table width="100%" border="0" cellspacing="0" cellpadding="2" class="areaFiltro">
<tr>
	<td colspan="2">
       	<td width="82" align="right"><strong>C&oacute;digo<strong></td>
								
       	<td width="247" align="left"><input type="text" name="FAM12CODD_F" size="15" maxlength="30" value="<cfif isdefined('form.FAM12CODD_F')>#form.FAM12CODD_F#</cfif>"></td>
   		
		<td width="82" align="right"><strong>Descripci&oacute;n<strong></td>
								
       	<td width="247" align="left"><input type="text" name="FAM12DES_F" size="30" maxlength="30" value="<cfif isdefined('form.FAM12DES_F')>#form.FAM12DES_F#</cfif>"></td>
   			
   		<td><input type="submit" name="btnFiltro"  value="Filtrar"></td>
	</td>	
</tr>
 </table>
</form>
</cfoutput>