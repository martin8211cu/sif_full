<cf_templateheader title="Importador Descripci&oacute;n de Cuentas">
	<table width="100%" cellpadding="2" cellspacing="0">
		<tr> 
			<td valign="top">
				<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo="Importación Descripci&oacute;n de Cuentas">
					<cfinclude template="/sif/portlets/pNavegacion.cfm">
					<table width="100%" border="0" cellspacing="1" cellpadding="1">
						<tr>
							<td valign="top" width="60%">
								<cf_sifFormatoArchivoImpr EIcodigo = 'DESCCFINANCI'>
							</td>
							<td valign="top" align="center">
								<cf_sifimportar eicodigo="DESCCFINANCI" mode="in" />
							</td>
							<td valign="top"><cf_botones exclude="ALTA,CAMBIO,BAJA,LIMPIAR"></td>
						</tr>
					</table>	
				<cf_web_portlet_end>
			</td>	
	 	</tr>
		<tr>
			<td colspan="2">
				<BR><BR>
				<strong>TipoCuenta:</strong><BR><BR>
				F = Cuentas Financiera + Contable + Presupuesto<BR>
				&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;- Verifica la Cuenta Financiera de último nivel<BR>
				&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;- Si la Cuenta Financiera no existe la genera, si no actualiza su descripción<BR>
				&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;- Si la Cuenta Contable tiene el mismo formato de la Financiera actualiza su descripción<BR>
				&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;- Si la Cuenta de Presupuesto tiene el mismo formato de la Financiera actualiza su descripción<BR>
				C = Únicamente Cuenta Contable<BR>
				&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;- Si la Cuenta Contable existe actualiza su descripción<BR>
				&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;- No realiza ninguna Verificación<BR>
				P = Únicamente Cuentas de Presupuesto<BR>
				&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;- Si la Cuenta de Presupuestos existe actualiza su descripción<BR>
				&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;- No realiza ninguna Verificación<BR>
			</td>
		</tr>
	</table>	
<cf_templatefooter>