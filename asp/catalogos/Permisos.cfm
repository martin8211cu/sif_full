<cf_templateheader title="Asignaci&oacute;n de Permisos">
	<cfif isdefined("url.Usucodigo") and not isdefined("form.Usucodigo")>
		<cfset form.Usucodigo = url.Usucodigo>
	</cfif>
	<cfinclude template="frame-config.cfm">
	<cfif not isdefined("form.Usucodigo") or not isdefined("Session.Progreso.CEcodigo") >
		<cfinclude template="Usuarios-lista.cfm">
	<cfelse>
		<table width="100%" border="0" cellpadding="4" cellspacing="0">
			<tr>
				<td valign="top">
					<cfinclude template="frame-header.cfm">
				</td>
			</tr>
			<tr>
				<td valign="top">
					<cfif isdefined("form.opcion") and form.opcion eq 'R'>
						<cfinclude template="Roles-form.cfm">
					<cfelse>
						<cfinclude template="Permisos-form.cfm">
					</cfif>			
				</td>
			</tr>
		</table>
	</cfif>
<cf_templatefooter>