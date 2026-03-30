<cfquery name="rsScripts" datasource="sifcontrol">
	select EIid, EIcodigo, EImodulo, EIdescripcion
	from EImportador
	where not EIcodigo like '%.[0-9][0-9][0-9]'
	order by upper(EIcodigo)
</cfquery>

					
<cfoutput>
<form name="frmScript" action="ScriptExec.cfm" method="post">
	<input type="hidden" name="paso" value="2">
	<input type="hidden" name="paso_ant" value="1">
	<table width="100%"  border="0" cellspacing="0" cellpadding="2">
		<tr>
			<td colspan="2">&nbsp;</td>
		</tr>
		<tr>
		  <td align="right" style="padding-right: 10px; "><strong>Empresa:</strong></td>
		  <td>#Session.Enombre#</td>
	  </tr>
		<tr> 
			<td align="right" width="50%" style="padding-right: 10px; ">
				<strong>Seleccione el Script que desea ejecutar:</strong>
			</td>
			<td> 
				<select name="EIid">
					<cfloop query="rsScripts">
						<option value="#EIid#">#EIcodigo# - #EIdescripcion#</option>
					</cfloop>
				</select>
			</td>
		</tr>
		<tr>
			<td colspan="2">&nbsp;</td>
		</tr>
		<tr align="center">
		  <td colspan="2" style="padding-right: 10px; ">
		  	<input name="btnSiguiente" type="submit" id="btnSiguiente" value="Siguiente >>">
		  </td>
	    </tr>
		<tr>
			<td colspan="2">&nbsp;</td>
		</tr>
	</table>
</form>
</cfoutput>
