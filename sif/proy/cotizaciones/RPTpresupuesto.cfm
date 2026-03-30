<cf_template template="#session.sitio.template#">
	<cf_templatearea name="title">
		Productos
	</cf_templatearea>
	<cf_templatearea name="body">
		<cf_web_portlet border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='Ajustes de Inventario'>
		<cfinclude template="../../portlets/pNavegacion.cfm">
		<br><table width="99%" align="center" border="0" cellpadding="0" cellspacing="0"><tr><td>
		<cfinclude template="PRTpresupuesto-form.cfm">
		<br></td></tr></table>
		</cf_web_portlet>
	</cf_templatearea>
</cf_template>
