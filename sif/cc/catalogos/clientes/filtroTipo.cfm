<cfoutput>
<form name="filtro" method="post" style="margin:0;" action="Tipo.cfm">

	<table width="100%" cellpadding="0" cellspacing="0" class="areaFiltro">
		<tr>
		  <td>&nbsp;</td>
			<strong>
				<td>Descripci&oacute;n:
				</td>
				<td>&nbsp;</td>
			</strong>
		</tr>
		
		<tr>
		  <td>&nbsp;</td>
			<td><input name="fCDTdescripcion" type="text" value="<cfif isdefined("form.fCDTdescripcion") and len(trim(form.fCDTdescripcion)) neq 0>#trim(form.fCDTdescripcion)#</cfif>" size="35" maxlength="30">
			</td>
			<td>
				<input type="submit" name="filtrar" value="Filtrar">
			</td>
		</tr>
	</table>
	<!---  <input type="hidden" name="fCcodigo" value="<cfif isdefined("form.fCcodigo") and len(trim(form.fCcodigo)) neq 0>#form.fCcodigo#</cfif>"> 
	 <input type="hidden" name="fCDTdescripcion" value="<cfif isdefined("form.fCDTdescripcion") and len(trim(form.fCDTdescripcion)) neq 0>#form.fCDTdescripcion#</cfif>"> 
	 <input type="hidden" name="fTipo" value="<cfif isdefined("form.fTipo") and len(trim(form.fTipo)) neq 0>#form.fTipo#</cfif>">  --->
</form>
</cfoutput>