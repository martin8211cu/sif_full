<!--- Campos por los cuales se realizará el filtro--->
<cfif isdefined("url.Mcodigo") and not isdefined("form.Mcodigo") >
	<cfset form.Mcodigo = url.Mcodigo >
</cfif>
<cfif isdefined("url.FAM24DES") and not isdefined("form.FAM24DES") >
	<cfset form.FAM24DES = url.FAM24DES >
</cfif>

<cfoutput>
<form style="margin: 0" action="den_monedas.cfm" name="den_monedas" method="post">
<table width="100%" border="0" cellspacing="0" cellpadding="2" class="areaFiltro">
<tr>
	<td colspan="2">
       	<td width="82" align="right"><strong>C&oacute;digo<strong></td>
								
       	<td width="247" align="left"><input type="text" name="Mcodigo_F" size="15" maxlength="30" value="<cfif isdefined('form.Mcodigo_F')>#form.Mcodigo_F#</cfif>"></td>
   		
		<td width="82" align="right"><strong>Descripci&oacute;n<strong></td>
								
       	<td width="247" align="left"><input type="text" name="FAM24DES_F" size="30" maxlength="30" value="<cfif isdefined('form.FAM24DES_F')>#form.FAM24DES_F#</cfif>"></td>
   			
   		<td><input type="submit" name="btnFiltro"  value="Filtrar"></td>
	</td>	
</tr>
 </table>
</form>
</cfoutput>
