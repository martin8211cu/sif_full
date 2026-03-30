<link href="luke.css" rel="stylesheet" type="text/css">
<cf_template>
	<cf_templatearea name="title">
		Episodio III
	</cf_templatearea>
	<cf_templatearea name="body">
		<cfinclude template="luke-pNavegacion.cfm">
		<cf_web_portlet titulo="Consola Principal de Cuentas por Cobrar">
			<table width="100%"  border="0" cellspacing="0" cellpadding="0">
			  <tr>
				<td valign="top" rowspan="2">
					<table width="98%" align="center"  border="0" cellspacing="0" cellpadding="0">
					  <tr>
						<td>
							<cfinclude template="luke-menu.cfm">
						</td>
					  </tr>
					</table>
				</td>
				<td valign="top" width="100%" colspan="2">
					<table width="98%" align="center"  border="0" cellspacing="0" cellpadding="0">
					  <tr>
						<td>
							<cfinclude template="luke-documentos-v2.cfm">
						</td>
					  </tr>
					</table>
				</td>
			  </tr>
			  <tr>
				<td><cfinclude template="luke-barGraph-v2.cfm"></td>
				<td><cfinclude template="luke-pieGraph.cfm"></td>
			  </tr>
			</table>
			</div>
		</cf_web_portlet>
	</cf_templatearea>
</cf_template>