<cfset escenario = getCVTCEscenario(form.cvtid)>
<table width="100%"  border="0" cellspacing="0" cellpadding="0">
	<tr>
		<td width="50%" valign="top"><cfinclude template="mesesLista.cfm"></td>
		<td width="50%" valign="top"><cfinclude template="mesesForm.cfm"></td>
	</tr>
</table>