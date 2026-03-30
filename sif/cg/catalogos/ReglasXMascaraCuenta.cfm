<cf_templateheader title="Plan de Cuentas">
	<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='Reglas por M&aacute;scara de Cuenta'>
		   <cfset Regresar = "javascript: ACMAYOR();">
		   <cfinclude template="../../portlets/pNavegacionCG.cfm">
			<table width="100%" border="0" cellspacing="1" cellpadding="1">
			  <tr>
				<td width="40%" valign="top"><cfinclude template="ArbolReglasMascaras.cfm"></td>
				<td width="60%" valign="top"><cfinclude template="formReglasXMascaraCuenta.cfm"></td>
			  </tr>
			</table>
	<cf_web_portlet_end>
<cf_templatefooter>