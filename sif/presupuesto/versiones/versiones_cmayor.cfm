<table width="99%" align="center" border="0" cellspacing="0" cellpadding="0">
  <tr><td colspan="2">&nbsp;</td></tr>
	<tr><td colspan="2" class="subTitulo" align="center">Cuentas de Mayor</td></tr>
  <tr><td colspan="2">&nbsp;</td></tr>
	<tr>
		<td valign="top" align="center" width="60%">
			<table width="99%" align="left" border="0" cellspacing="0" cellpadding="0">
				<tr>
					<td bgcolor="#EBEBEB" class="titulolistas" align="center">Lista de Cuentas de Mayor</td>
				</tr>
				<tr>
					<td>
						<cfinclude template="versiones_cmayor_filtro.cfm">
						<cfinclude template="versiones_cmayor_lista.cfm">
					</td>
				</tr>
			</table>
		</td>
	<cfif session.versiones.formular EQ "V">
		<td valign="top" align="center" width="40%">
			<table width="99%" align="right" border="0" cellspacing="0" cellpadding="0">
				<tr>
					<td bgcolor="#EBEBEB" class="titulolistas" align="center">Modificación de Cuentas de Mayor</td>
				</tr>
				<tr>
					<td>
						<cfinclude template="versiones_cmayor_form.cfm">
					</td>
				</tr>
			</table>
		</td>
	</cfif>
	</tr>
</table>