<!--- CAMPOR POR EL CUAL SE REALIZARÁ EL FILTRO--->
<cfif isdefined("url.FAM23DES") and not isdefined("form.FAM23DES") >
	<cfset form.FAM23DES = url.FAM23DES >
</cfif>

<cfoutput>
<form style="margin: 0" action="mensajes.cfm" name="mensajes" method="post">
<table width="100%" border="0" cellspacing="0" cellpadding="2" class="areaFiltro">
<tr>
	<td colspan="2">
       	<td width="82" align="right"><strong>Descripci&oacute;n<strong></td>
								
       	<td width="247" align="left"><input type="text" name="FAM23DES_F" size="30" maxlength="30" value="<cfif isdefined('form.FAM23DES_F')>#form.FAM23DES_F#</cfif>"></td>
   			
   		<td><input type="submit" name="btnFiltro"  value="Filtrar"></td>
	</td>	
</tr>
 </table>
</form>
</cfoutput>