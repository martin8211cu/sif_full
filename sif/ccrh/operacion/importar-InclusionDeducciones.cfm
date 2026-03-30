<script  language="JavaScript" src="/cfmx/sif/js/DHTMLMenu/stm31.js"></script>
<cf_templateheader title="Cuentas por Cobrar de Empleados">
	<cf_templatecss>
	<table width="100%" cellpadding="2" cellspacing="0">
		<tr>
			<td valign="top">
			  <cf_web_portlet_start border="true" titulo="Importar Inclusion de Deducciones de Empleados" skin="#Session.Preferences.Skin#">
					<table width="100%"  border="0" cellspacing="0" cellpadding="0" align="center">
						<tr><td colspan="3" align="center">
							<cfset regresar = '/cfmx/sif/ccrh/operacion/InclusionDeducciones.cfm'>
							<cfinclude template="../../portlets/pNavegacion.cfm">
						</td></tr>
						<tr><td colspan="3" align="center">&nbsp;</td></tr>
						<tr>
							<td align="center" width="2%">&nbsp;</td>
							<td align="center" valign="top" width="60%">
								<cf_sifFormatoArchivoImpr EIcodigo = "CCRH-INCDEDU">
							</td>
							<td align="center" style="padding-left: 15px " valign="top">
								<cf_sifimportar EIcodigo="CCRH-INCDEDU" mode="in" />
							</td>
						</tr>
						<tr><td colspan="3" align="center"><input type="button" name="Regresar" value="Regresar" onClick="javascript:location.href='InclusionDeducciones.cfm'"></td></tr>
						<tr><td colspan="3" align="center">&nbsp;</td></tr>
					</table>
				<cf_web_portlet_end>
			</td>	
		</tr>
	</table>	
<cf_templatefooter> 