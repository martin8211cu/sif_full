<cf_template>
	<cf_templatearea name="title">Cuestionarios</cf_templatearea>
	<cf_templatearea name="body">
		<cf_web_portlet_start border="true" titulo="Cuestionarios" >
			<table width="100%" cellpadding="0" cellspacing="0" style="vertical-align:bottom; ">
				<tr><td colspan="2"><cfinclude template="/rh/portlets/pNavegacion.cfm"></td></tr>
				<tr>
					<td valign="top" width="150"><cfinclude template="../menu.cfm"></td>
					<td valign="top">
						<table width="100%" border="0" cellpadding="3" cellspacing="0">
							<tr>
								<td align="center" valign="top" width="50%" >
									<cf_web_portlet_start border="true" titulo="Competencias por Desarrollar" skin="#session.preferences.skin#">
										<cfinclude template="competencias-desarrollar.cfm">
									<cf_web_portlet_end>
								</td>
								<td align="center" valign="top" width="50%" >
									<cf_web_portlet_start border="true" titulo="Evaluaciones pendientes" skin="#session.preferences.skin#">
										<cfinclude template="evaluaciones-pendientes.cfm">
									<cf_web_portlet_end>
								</td>
							</tr>
							<tr>
								<td align="center" valign="top" width="50%" >
									<cf_web_portlet_start border="true" titulo="Progreso por habilidad" skin="#session.preferences.skin#">
										<cfinclude template="progreso-h.cfm">
									<cf_web_portlet_end>
								</td>
								<td align="center" valign="top" width="50%" >
									<cf_web_portlet_start border="true" titulo="Progreso por Centro Funcional" skin="#session.preferences.skin#">
										<cfinclude template="progreso-cf.cfm">
									<cf_web_portlet_end>
								</td>
							</tr>
						</table>
					</td>
				</tr>
			</table>
		<cf_web_portlet_end>		
	</cf_templatearea>
</cf_template>