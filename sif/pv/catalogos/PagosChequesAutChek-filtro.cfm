<cfoutput>
<form style="margin: 0" action="PagoChequesAutChk.cfm" name="Cheques_por_Cliente" method="post">
	<table width="100%" border="0" cellspacing="0" cellpadding="2" class="areaFiltro">
  		<!--- FILTROS --->
   		<tr>
   			<td width="93" align="right"><strong>Cliente</strong></td>
			<td colspan="4">
				<cfif isdefined("form.CDCcodigo_F") and len(trim(form.CDCcodigo_F))>
					<cf_sifClienteDetCorp CDCidentificacion="CDCidentificacion_F" CDCcodigo="CDCcodigo_F" form="Cheques_por_Cliente" idquery="#form.CDCcodigo_F#">
        		<cfelse>
        			<cf_sifClienteDetCorp CDCidentificacion="CDCidentificacion_F" CDCcodigo="CDCcodigo_F" form="Cheques_por_Cliente">
      			</cfif>
			</td>
          	<td>&nbsp;&nbsp;<input type="submit" name="btnFiltro"  value="Filtrar"></td>
		</tr>
	</table>
</form>
</cfoutput>
