<cf_templateheader title="Cuentas por Cobrar RH">
	<cf_templatecss>
	<cfoutput>
		<table width="100%" cellpadding="2" cellspacing="0">
			<tr>
				<td valign="top">
					<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='Registro de Deducciones por Empleado'>
						<cfinclude template="../../portlets/pNavegacion.cfm">
						<!--- Si viene de la pantalla de confirmar, carga el empleado de session.deduccion_empleado --->
						<cfif isdefined("form.CRegresar") >
							<cfif isdefined("session.deduccion_empleado.DEid")>
								<cfset form.DEid = session.deduccion_empleado.DEid >
							</cfif>
						<cfelseif isdefined("session.deduccion_empleado")>
							<!--- Elimina la estructura session.deduccion_empleado, para evitar datos de basura --->
							<cfset structDelete(session, 'deduccion_empleado')>
						</cfif>
						<table width="98%" align="center" cellpadding="0" cellspacing="0">
							<tr>
								<td align="center" class="#Session.preferences.Skin#_thcenter">Agregar Deducci&oacute;n</td>
							</tr>
							<tr><td><cfinclude template="registroDeducciones-form.cfm"></td></tr>
						</table>
						<br>
					<cf_web_portlet_end>
				</td>	
			</tr>
		</table>
	</cfoutput>
<cf_templatefooter>