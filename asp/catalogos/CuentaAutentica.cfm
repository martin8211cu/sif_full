<cf_templateheader title="Opciones de Seguridad">
	<!--- Archivo que carga datos en session --->
	<cfinclude template="frame-config.cfm">
	<cfif not isdefined("Session.Progreso.CEcodigo") or isdefined("url.selecc")>
		<cfinclude template="Cuentas-lista.cfm">
	<cfelse>
		<table width="100%" border="0" cellpadding="4" cellspacing="0">
			<tr>
				<td valign="top">
					<cfinclude template="frame-header.cfm">
				</td>
			</tr>
			<tr>
				<td valign="top">
					<cfinclude template="CuentaAutentica-form.cfm">
				</td>
			</tr>
		</table>
	</cfif>
<cf_templatefooter>