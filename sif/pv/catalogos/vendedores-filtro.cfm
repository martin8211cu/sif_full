<!--- CAMPOS POR LOS CUALES SE REALIZARÁ EL FILTRO--->
<cfif isdefined("url.FAM21CED") and not isdefined("form.FAM21CED") >
	<cfset form.FAM21CED = url.FAM21CED >
</cfif>
<cfif isdefined("url.FAM21NOM") and not isdefined("form.FAM21NOM") >
	<cfset form.FAM21NOM = url.FAM21NOM >
</cfif>

<cfoutput>
<form style="margin: 0" action="vendedores.cfm" name="vendedores" method="post">
<table width="50%" border="0" cellspacing="0" cellpadding="2" class="areaFiltro">
<tr>
	<td colspan="2">
       	<td width="82" align="right"><strong>Identificaci&oacute;n<strong></td>
								
       	<td width="247" align="left"><input type="text" name="FAM21CED_F" size="15" maxlength="30" value="<cfif isdefined('form.FAM21CED_F')>#form.FAM21CED_F#</cfif>"></td>
   		
		<td width="82" align="right"><strong>Nombre<strong></td>
								
       	<td width="247" align="left"><input type="text" name="FAM21NOM_F" size="20" maxlength="30" value="<cfif isdefined('form.FAM21NOM_F')>#form.FAM21NOM_F#</cfif>"></td>
   			
   		<td><input type="submit" name="btnFiltro"  value="Filtrar"></td>
	</td>	
</tr>
 </table>
</form>
</cfoutput>
