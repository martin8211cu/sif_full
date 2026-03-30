<cfoutput>
<form name="filtro" method="post" style="margin:0;" action="TipoDoc.cfm">
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
			<td><input name="fTDdescripcion" type="text" value="<cfif isdefined("form.fTDdescripcion") and len(trim(form.fTDdescripcion)) neq 0>#trim(form.fTDdescripcion)#</cfif>" size="35" maxlength="30">
			</td>
			<td>
				<input type="submit" name="filtrar" value="Filtrar">
			</td>
		</tr>
	</table>
</form>
</cfoutput>