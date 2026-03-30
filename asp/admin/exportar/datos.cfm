<cf_templateheader title="Exportar tablas">
<cfinclude template="/home/menu/pNavegacion.cfm">
<cf_web_portlet_start titulo="Exportar Tablas">
	<table cellpadding="0" cellspacing="0" border="0">
		<tr>
			<td valign="top">
				<cfinclude template="datos-tablas.cfm">
			</td>
			<td valign="top">&nbsp;</td>
			<td valign="top">
				<cfinclude template="datos-form.cfm">
			</td>
		</tr>
	</table>
<cf_web_portlet_end>
<cf_templatefooter>