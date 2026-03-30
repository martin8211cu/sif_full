<cf_templateheader title="Pagos de Tarjetas de Credito Cancelados">
	<cf_web_portlet_start _start titulo="Pagos emitidos como Cancelados">

		<cf_navegacion name="Usucodigo" default="" navegacion="">

		<table width="100%" align="center" border="0">

			<tr>
				<td class="tituloListas" nowrap align="left">
				&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<strong>Trabajar con Tesorer&iacute;a:</strong>&nbsp;
				<cf_cboTESid onchange="this.form1.submit();" tabindex="1"></td>
			</tr>
			<tr>
				<td valign="top" align="center" width="50%">
					<cfinclude template="TCEPagosCancelados-form.cfm">
				</td>
			</tr>
		</table>
	<cf_web_portlet_start _end>
<cf_templatefooter>
