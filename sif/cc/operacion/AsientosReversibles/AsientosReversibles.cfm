<cf_templateheader title="Cuentas por Cobrar">
	<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" 
		titulo='Generación de asientos reversibles de estimación de incobrables'>
		<table width="100%"  border="0" cellspacing="0" cellpadding="0">
			<tr><td colspan="2"><cfinclude template="../../../portlets/pNavegacion.cfm"></td></tr>
			<tr><td valign="top"><cfinclude template="formAsientosReversibles.cfm"></td></tr>
		</table>
	<cf_web_portlet_end>
<cf_templatefooter>