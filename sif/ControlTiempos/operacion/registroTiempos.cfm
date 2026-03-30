<cf_template>
	<cf_templatearea name="title">
		Catálogo de Actividades
	</cf_templatearea>
	<cf_templatearea name="body">
		<cf_web_portlet titulo="Registro de Tiempos">
	 		<cfinclude template="../../portlets/pNavegacion.cfm">
			<table width="99%" align="center" border="0" cellspacing="0" cellpadding="0">
				<tr>
					<td valign="top" width="50%"><cfinclude template="registroTiempos-form.cfm"></td>
				</tr>
			</table>
		</cf_web_portlet>
	</cf_templatearea>	
</cf_template>