<cfoutput>
<form name="filtro" method="post" style="margin:0;" action="Clientes.cfm">

	<table width="100%" cellpadding="0" cellspacing="0" class="areaFiltro">
		<tr>
		  <td>&nbsp;</td>
		  <td><strong>Identificaci&oacute;n:</strong></td>
			<td><strong>Nombre:</strong></td>
			<td>&nbsp;</td>
		</tr>
		
		<tr>
		  <td>&nbsp;</td>
		  <td><input name="fCDidentificacion" type="text" value="<cfif isdefined("form.fCDidentificacion") and len(trim(form.fCDidentificacion)) neq 0>#trim(form.fCDidentificacion)#</cfif>" size="35" maxlength="30"></td>
			<td><input name="fCDnombre" type="text" value="<cfif isdefined("form.fCDnombre") and len(trim(form.fCDnombre)) neq 0>#trim(form.fCDnombre)#</cfif>" size="35" maxlength="30">
			</td>
			<td>
				<input type="submit" name="filtrar" value="Filtrar">
			</td>
		</tr>
	</table>
</form>
</cfoutput>