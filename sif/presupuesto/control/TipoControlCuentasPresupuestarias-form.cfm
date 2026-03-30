<form name="form1" method="post" action="TipoControlCuentasPresupuestarias-sql.cfm">
  <cfoutput>
  <input name="CPcuenta" value="<cfif isdefined('form.CPcuenta')>#form.CPcuenta#</cfif>" type="hidden">
   <input name="CPPid" value="<cfif isdefined('form.CPPid')>#form.CPPid#</cfif>" type="hidden">
  <table width="100%" border="0" cellspacing="0" cellpadding="0">
    <tr> <td>&nbsp;  </td> </tr>
	<tr> <td>&nbsp;  </td> </tr>
    <tr> <td>&nbsp;  </td> </tr>
	<tr>
		<td nowrap align="right"> &nbsp;Cuenta Mayor:&nbsp;</td>
		<td nowrap  > <input name="CuentaMayor" type="text"  disabled="disabled" value="<cfif isdefined('form.CMayor')>#form.CMayor#</cfif>" 
								   size="5" onFocus="javascript:this.select();">
		</td>						   	
	</tr>
	<tr>
		<td nowrap align="right"> &nbsp;Detalle de Cuenta:&nbsp;</td>
		<td nowrap> <input name="DetalleCuenta" type="text"  disabled="disabled" value="<cfif isdefined('form.CPDetalle')>#form.CPDetalle#</cfif>" 
								   size="20" onFocus="javascript:this.select();">
		</td>								   
	</tr>
	<tr>
		<td nowrap align="right"> &nbsp;Descripci&oacute;n de Cuenta:&nbsp;</td>
		<td nowrap> <input name="DescripcionCuenta" type="text"  disabled="disabled" value="<cfif isdefined('form.CPDescripcion')>#form.CPDescripcion#</cfif>" 
								   size="25" onFocus="javascript:this.select();">
		<td>								   
	</tr>
	<tr>
		<td nowrap align="right"> &nbsp;Tipo de Control:&nbsp; </td>
		<td>
		<select name="TipoControl">
				<option value="0" <cfif isdefined('form.TipoControl') and form.TipoControl EQ 'Abierto'>selected</cfif>>Abierto</option>
				<option value="1" <cfif isdefined('form.TipoControl') and form.TipoControl EQ 'Restringido'>selected</cfif>>Restringido</option>
				<option value="2" <cfif isdefined('form.TipoControl') and form.TipoControl EQ 'Restrictivo'>selected</cfif>>Restrictivo</option>													
		</select>
		</td>
	</tr>
	<tr>
		<td nowrap align="right"> &nbsp;M&eacute;todo C&aacute;lculo de Control:&nbsp; </td>
		<td>
		<select name="CalculoControl">
				<option value="1" <cfif isdefined('form.CalculoControl') and form.CalculoControl EQ 'Mensual'>selected</cfif>>Mensual</option>
				<option value="2" <cfif isdefined('form.CalculoControl') and form.CalculoControl EQ 'Acumulado'>selected</cfif>>Acumulado</option>
				<option value="3" <cfif isdefined('form.CalculoControl') and form.CalculoControl EQ 'Total'>selected</cfif>>Total</option>													
		</select>
		</td>
	</tr>	
	 <tr> <td>&nbsp;  </td> </tr>
	<tr>
		<td  colspan="2" nowrap="nowrap" align="center"> 
			 <input  <cfif isdefined('form.Cmayor')> type="submit" <cfelse> type="button" </cfif> class="btnCambiar"  tabindex="1" name="btnModificar" value="Modificar">
		</td>
	</tr>	
  </table>  
  </cfoutput>
</form>
