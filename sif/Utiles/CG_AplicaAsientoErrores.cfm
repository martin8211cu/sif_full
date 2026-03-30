<cf_template>
	<cf_templatearea name="title">
		Entrega de Cheques
	</cf_templatearea>
	<cf_templatearea name="body">
	
		<cf_templatecss>

		<BR>
		<div align="center">
			<cf_web_portlet border="true" titulo="Lista de Cuentas Financieras con error" skin="#Session.Preferences.Skin#" width="70%">
				<BR>
				<input type="button" onclick="history.go(-2);" value="Regresar">
				<BR><BR>
				<cfoutput>
				#url.Errores#
				</cfoutput>
				<BR>
				<BR>
			</cf_web_portlet>
		</div>
	</cf_templatearea>
</cf_template>
