<cfif isdefined("url.FAD01COD") and not isdefined("form.FAD01COD") >
	<cfset form.FAD01COD = url.FAD01COD >
</cfif>
<cfif isdefined("url.FAM01DES") and not isdefined("form.FAM01DES") >
	<cfset form.FAM01DES = url.FAM01DES >
</cfif>

<cfoutput>
<form style="margin: 0" action="documentos.cfm" name="documentos" method="post">
<table width="100%" border="0" cellspacing="0" cellpadding="2" class="areaFiltro">
<tr>
	<td colspan="2">
       	<td width="82" align="right"><strong>C&oacute;digo<strong></td>
								
       	<td width="247" align="left"><input type="text" name="FAD01COD_F" size="15" maxlength="30" value="<cfif isdefined('form.FAD01COD_F')>#form.FAD01COD_F#</cfif>"></td>
   		
		<td width="82" align="right"><strong>Descripci&oacute;n<strong></td>
								
       	<td width="247" align="left"><input type="text" name="FAD01DES_F" size="30" maxlength="30" value="<cfif isdefined('form.FAD01DES_F')>#form.FAD01DES_F#</cfif>"></td>
   			
   		<td><input type="submit" name="btnFiltro"  value="Filtrar"></td>
	</td>	
</tr>
 </table>
</form>
</cfoutput>