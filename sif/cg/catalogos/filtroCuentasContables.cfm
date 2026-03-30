<form style="margin:0" name="formFiltro" method="post" action="">
	<table width="100%" border="0" cellpadding="1" cellspacing="0" class="areaFiltro">
	  <tr>
		<td align="left" >Cuenta</td>
		<td nowrap align="left">Descripci&oacute;n</td>
		<cfif NOT isdefined("LvarFiltroNoBalance")>
	    <td align="left" nowrap>Balance Normal</td>
		</cfif>
	  </tr>
	  <tr>
		<td align="left" width="1%"><input name="F_Cformato" value="<cfif isdefined('form.F_Cformato') and form.F_Cformato NEQ ""><cfoutput>#form.F_Cformato#</cfoutput></cfif>" type="text" id="F_Cformato" size="25" maxlength="100" onfocus="javascript:this.select();"></td>
	    <td align="left" width="1%"><input name="F_Cdescripcion" value="<cfif isdefined('form.F_Cdescripcion') and form.F_Cdescripcion NEQ ""><cfoutput>#form.F_Cdescripcion#</cfoutput></cfif>" type="text" id="F_Cdescripcion" size="30" maxlength="80" onfocus="javascript:this.select();" ></td>
		<cfif NOT isdefined("LvarFiltroNoBalance")>
		<td align="left" width="1%">
			<select name="F_Cbalancen">
          		<option value="D" <cfif isdefined('form.F_Cbalancen') and form.F_Cbalancen EQ "D">selected</cfif>>D&eacute;bito</option>
          		<option value="C" <cfif isdefined('form.F_Cbalancen') and form.F_Cbalancen EQ "C">selected</cfif>>Cr&eacute;dito</option>
        	</select>
		</td>
		</cfif>
	    <td align="center" width="1%"><input name="btnFiltrar" type="submit" id="btnFiltrar2" value="Filtrar"></td>
		<td>
			<input type="hidden" name="Cmayor" value="<cfoutput>#form.Cmayor#</cfoutput>">
			<input type="hidden" name="TipoMascara" value="<cfif isdefined("form.TipoMascara")><cfoutput>#form.TipoMascara#</cfoutput></cfif>">
			<input type="hidden" name="Formato" value="<cfif isdefined("form.formato")><cfoutput>#form.formato#</cfoutput></cfif>">
		</td>
	  </tr>
  </table>
</form>