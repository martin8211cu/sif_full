<cf_templateheader title="Cuentas por Cobrar Empleados- Consulta de Pagos Realizados">
	<cfoutput>
		<form name="form1" method="post" action="" style="margin: 0">
			<table width="100%" align="center" border="0" cellspacing="0" cellpadding="0">
				<tr>
					<td><cfinclude template="../../portlets/pNavegacion.cfm"></td>
				</tr>
				<tr><td>
					<cfinclude template="PagosRealizados-form.cfm">
				</td></tr>
				<tr><td>&nbsp;</td></tr>
			</table>
		</form>
	</cfoutput>
<cf_templatefooter>