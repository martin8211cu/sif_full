<cf_templateheader title="Registro de Inter&oacute;s Moratorio">
		<cfinclude template="../../portlets/pNavegacionIV.cfm">
		<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo="Registro de Intereses Moratorios">

			<form action="RegistroInteresMoratorioCxC.cfm" method="post" name="sql">
				<table width="75%" cellpadding="0" cellspacing="0" border="0" align="center">
					<tr><td>&nbsp;</td></tr>
					<tr>
						<td align="center">
							<span style="font-size:13px">
							Los documentos de Inter&eacute;s Moratorio fueron generados exitosamente, <br>
							estos pueden ser verificados en el Registro de Documentos.
							</span>
						</td>
					</tr>
					<tr><td>&nbsp;</td></tr>
					<tr><td><cf_botones values="Aceptar"></td></tr>
					<tr><td>&nbsp;</td></tr>
				</table>
			</form>

		<cf_web_portlet_end> 
	<cf_templatefooter>
