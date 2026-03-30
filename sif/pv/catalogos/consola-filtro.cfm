<cfoutput>
<form style="margin: 0" action="cajasProceso.cfm" name="cajas" method="post">
	<table width="100%" border="0" cellspacing="0" cellpadding="2" class="areaFiltro">
  		<!--- FILTROS --->
   		<tr>
            	<td width="93" align="right"><strong>Oficina&nbsp;</strong></td>
				<td colspan="4">
					<cfif isdefined("form.Ocodigo") and len(trim(form.Ocodigo))>
						<cf_sifoficinas form="cajas" id="#form.Ocodigo#">
        			<cfelse>
        				<cf_sifoficinas form="cajas">
      				</cfif>
				</td>
          <td>&nbsp;&nbsp;<input type="submit" name="btnFiltro"  value="Filtrar" class="btnfiltrar"></td>
		 </tr>
		
 	</table>
</form>
</cfoutput>