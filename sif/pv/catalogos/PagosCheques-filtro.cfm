<cfoutput>
<form style="margin: 0" action="PagoCheques.cfm" name="Cheques_por_Cliente_Cuenta" method="post">
	<table width="100%" border="0" cellspacing="0" cellpadding="2" class="areaFiltro">
  		<!--- FILTROS --->
   		<tr>
			<td colspan="4">
		  		<td width="11%" align="right"><strong>Cuenta</strong></td>
				<td width="18%" align="left"><input type="text" name="FAM16NUM_F" size="15" maxlength="30" value="<cfif isdefined('form.FAM16NUM_F')>#form.FAM16NUM_F#</cfif>"></td>
								
				<td width="8%" align="right"><strong>Cliente</strong></td>
				<td width="50%">
					
					<cfif isdefined("form.CDCcodigo_F") and len(trim(form.CDCcodigo_F))>
						<cf_sifClienteDetCorp CDCidentificacion="CDCidentificacion_F" CDCcodigo="CDCcodigo_F" form="Cheques_por_Cliente_Cuenta" idquery="#form.CDCcodigo_F#">
					<cfelse>
						<cf_sifClienteDetCorp CDCidentificacion="CDCidentificacion_F" CDCcodigo="CDCcodigo_F" form="Cheques_por_Cliente_Cuenta">
					</cfif>
				
				</td>
				<td width="12%">&nbsp;&nbsp;<input type="submit" name="btnFiltro"  value="Filtrar"></td>
			<td width="1%"></td>	
		</tr>
	</table>
</form>
</cfoutput>

