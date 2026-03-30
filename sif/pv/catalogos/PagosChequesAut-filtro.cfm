<cfoutput>
<form style="margin: 0" action="PagoChequesAut.cfm" name="Cheques_por_Cuenta" method="post">
	<table width="100%" border="0" cellspacing="0" cellpadding="2" class="areaFiltro">
  		<!--- FILTROS --->
   		<tr>
			<td width="36%"  colspan="1"align="right"><strong>Cuenta</strong></td>	
			<td width="25%" align="right"><input type="text" name="FAM16NUM_F" size="20" maxlength="15" value="<cfif isdefined('form.FAM16NUM_F')>#form.FAM16NUM_F#</cfif>"></td>
			<td width="39%">&nbsp;&nbsp;<input type="submit" name="btnFiltro"  value="Filtrar"></td>
			
		</tr>
	</table>
</form>
</cfoutput>

